/**
 * @file
 * @copyright 2020 bobbahbrown (https://github.com/bobbahbrown)
 * @license MIT
 */

import { Loader } from "./common/Loader";
import { useBackend } from '../backend';
import { Component, createRef } from 'inferno';
import { Box, Flex, Section } from '../components';
import { Window } from '../layouts';
import {
  KEY_ENTER,
  KEY_LEFT,
  KEY_RIGHT,
  KEY_SPACE,
  KEY_TAB,
} from 'common/keycodes';

export const AlertModal = (props, context) => {
  const { act, data } = useBackend(context);
  const { title, message, buttons, timeout } = data;

  return (
    <Window title={title} width={350} height={150} resizable>
      {timeout !== undefined && <Loader value={timeout} />}
      <Window.Content>
        <Flex direction="column" height="100%">
          <Flex.Item grow={1}>
            <Flex
              direction="column"
              className="AlertModal__Message"
              height="100%"
            >
              <Flex.Item>
                <Box m={1}>{message}</Box>
              </Flex.Item>
            </Flex>
          </Flex.Item>
          <Flex.Item my={2}>
            <Flex className="AlertModal__Buttons">
              {buttons.map((button) => (
                <Flex.Item key={button} mx={1}>
                  <Button
                    px={3}
                    onClick={() => act('choose', { choice: button })}
                  >
                    {button}
                  </Button>
                </Flex.Item>
              ))}
            </Flex>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

export const Loader = (props) => {
  const { value } = props;
  return (
    <div className="AlertModal__Loader">
      <Box
        className="AlertModal__LoaderProgress"
        style={{
          width: clamp01(value) * 100 + '%',
        }}
      />
    </div>
  );
};
