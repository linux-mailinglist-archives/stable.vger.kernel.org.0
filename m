Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2A5644027
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbiLFJtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234542AbiLFJsf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:48:35 -0500
Received: from mailgw.kylinos.cn (unknown [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0152A205DA;
        Tue,  6 Dec 2022 01:47:18 -0800 (PST)
X-UUID: 0e63761a6c204ba28afc32a41fac233a-20221206
X-CPASD-INFO: 6d929a2ce59e4e2da7f6245c816724ef@f7RzUmaTYJORVXuxg6h9noFolmZjYFW
        yemtWZ2BkkYaVhH5xTV5nX1V9gnNXZF5dXFV3dnBQY2BhXVJ3i3-XblBgXoZgUZB3haZzUmmPYg==
X-CLOUD-ID: 6d929a2ce59e4e2da7f6245c816724ef
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,OB:0.0,URL:-5,TVAL:145.
        0,ESV:1.0,ECOM:-5.0,ML:0.0,FD:1.0,CUTS:147.0,IP:-2.0,MAL:-5.0,PHF:-5.0,PHC:-5
        .0,SPF:4.0,EDMS:-5,IPLABEL:4480.0,FROMTO:0,AD:0,FFOB:0.0,CFOB:0.0,SPC:0,SIG:-
        5,AUF:0,DUF:10056,ACD:163,DCD:163,SL:0,EISP:0,AG:0,CFC:0.606,CFSR:0.053,UAT:0
        ,RAF:1,IMG:-5.0,DFA:0,DTA:0,IBL:-2.0,ADI:-5,SBL:0,REDM:0,REIP:0,ESB:0,ATTNUM:
        0,EAF:0,CID:-5.0,VERSION:2.3.17
X-CPASD-ID: 0e63761a6c204ba28afc32a41fac233a-20221206
X-CPASD-BLOCK: 1001
X-CPASD-STAGE: 1
X-UUID: 0e63761a6c204ba28afc32a41fac233a-20221206
X-User: wangdicheng@kylinos.cn
Received: from [172.20.116.115] [(116.128.244.169)] by mailgw
        (envelope-from <wangdicheng@kylinos.cn>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES128-GCM-SHA256 128/128)
        with ESMTP id 592157723; Tue, 06 Dec 2022 17:47:14 +0800
Message-ID: <18143b4b-26ff-fea9-2d5b-c49554b8179a@kylinos.cn>
Date:   Tue, 6 Dec 2022 17:47:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 -next] ALSA:usb-audio:Add the information of KT0206
 device driven by USB audio
To:     Dicheng Wang <wangdicheng123@hotmail.com>, perex@perex.cz,
        tiwai@suse.com, sdoregor@sdore.me, connerknoxpublic@gmail.com,
        hahnjo@hahnjo.de, john-linux@pelago.org.uk
Cc:     alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <SG2PR02MB58780ED138433086A3213AE98A1B9@SG2PR02MB5878.apcprd02.prod.outlook.com>
Content-Language: en-US
From:   wangdicheng <wangdicheng@kylinos.cn>
In-Reply-To: <SG2PR02MB58780ED138433086A3213AE98A1B9@SG2PR02MB5878.apcprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

lsusb -v信息如下：


Bus 002 Device 003: ID 2109:0817 VIA Labs, Inc.
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               3.20
   bDeviceClass            9 Hub
   bDeviceSubClass         0
   bDeviceProtocol         3
   bMaxPacketSize0         9
   idVendor           0x2109 VIA Labs, Inc.
   idProduct          0x0817
   bcdDevice            7.73
   iManufacturer           1 VIA Labs, Inc.
   iProduct                2 USB3.0 Hub
   iSerial                 3 000000000
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength       0x001f
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xc0
       Self Powered
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           19
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0002  1x 2 bytes
         bInterval               8
         bMaxBurst               0
Hub Descriptor:
   bLength              12
   bDescriptorType      42
   nNbrPorts             4
   wHubCharacteristic 0x0009
     Per-port power switching
     Per-port overcurrent protection
   bPwrOn2PwrGood      175 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   bHubDecLat          0.4 micro seconds
   wHubDelay          2292 nano seconds
   DeviceRemovable    0x00
  Hub Port Status:
    Port 1: 0000.02a0 lowspeed L1
    Port 2: 0000.02a0 lowspeed L1
    Port 3: 0000.02a0 lowspeed L1
    Port 4: 0000.02a0 lowspeed L1
Binary Object Store Descriptor:
   bLength                 5
   bDescriptorType        15
   wTotalLength       0x002a
   bNumDeviceCaps          3
   USB 2.0 Extension Device Capability:
     bLength                 7
     bDescriptorType        16
     bDevCapabilityType      2
     bmAttributes   0x00000002
       HIRD Link Power Management (LPM) Supported
   SuperSpeed USB Device Capability:
     bLength                10
     bDescriptorType        16
     bDevCapabilityType      3
     bmAttributes         0x00
     wSpeedsSupported   0x000e
       Device can operate at Full Speed (12Mbps)
       Device can operate at High Speed (480Mbps)
       Device can operate at SuperSpeed (5Gbps)
     bFunctionalitySupport   1
       Lowest fully-functional device speed is Full Speed (12Mbps)
     bU1DevExitLat           4 micro seconds
     bU2DevExitLat         231 micro seconds
   Container ID Device Capability:
     bLength                20
     bDescriptorType        16
     bDevCapabilityType      4
     bReserved               0
     ContainerID             {30eef35c-07d5-2549-b001-802d79434c30}
Device Status:     0x0001
   Self Powered

Bus 002 Device 004: ID 0781:55a3 SanDisk Corp.
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               3.20
   bDeviceClass            0
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         9
   idVendor           0x0781 SanDisk Corp.
   idProduct          0x55a3
   bcdDevice            1.00
   iManufacturer           1 SanDisk
   iProduct                2 Ultra Luxe
   iSerial                 3 
0101b2e6aaca3ab1fa2181c90bd6bc814d344653ac38de3f1bd49270e8ab2aab0304000000000000000000001fd5431800965d00a35581079ea6ede3
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength       0x002c
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower              896mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           2
       bInterfaceClass         8 Mass Storage
       bInterfaceSubClass      6 SCSI
       bInterfaceProtocol     80 Bulk-Only
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               0
         bMaxBurst               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               0
         bMaxBurst              15
Binary Object Store Descriptor:
   bLength                 5
   bDescriptorType        15
   wTotalLength       0x0016
   bNumDeviceCaps          2
   USB 2.0 Extension Device Capability:
     bLength                 7
     bDescriptorType        16
     bDevCapabilityType      2
     bmAttributes   0x00000002
       HIRD Link Power Management (LPM) Supported
   SuperSpeed USB Device Capability:
     bLength                10
     bDescriptorType        16
     bDevCapabilityType      3
     bmAttributes         0x00
     wSpeedsSupported   0x000e
       Device can operate at Full Speed (12Mbps)
       Device can operate at High Speed (480Mbps)
       Device can operate at SuperSpeed (5Gbps)
     bFunctionalitySupport   1
       Lowest fully-functional device speed is Full Speed (12Mbps)
     bU1DevExitLat          10 micro seconds
     bU2DevExitLat         256 micro seconds
Device Status:     0x0000
   (Bus Powered)

Bus 002 Device 002: ID 2109:0817 VIA Labs, Inc.
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               3.20
   bDeviceClass            9 Hub
   bDeviceSubClass         0
   bDeviceProtocol         3
   bMaxPacketSize0         9
   idVendor           0x2109 VIA Labs, Inc.
   idProduct          0x0817
   bcdDevice            7.73
   iManufacturer           1 VIA Labs, Inc.
   iProduct                2 USB3.0 Hub
   iSerial                 3 000000000
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength       0x001f
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xc0
       Self Powered
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes           19
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Feedback
         wMaxPacketSize     0x0002  1x 2 bytes
         bInterval               8
         bMaxBurst               0
Hub Descriptor:
   bLength              12
   bDescriptorType      42
   nNbrPorts             4
   wHubCharacteristic 0x0009
     Per-port power switching
     Per-port overcurrent protection
   bPwrOn2PwrGood      175 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   bHubDecLat          0.4 micro seconds
   wHubDelay          2292 nano seconds
   DeviceRemovable    0x00
  Hub Port Status:
    Port 1: 0000.0203 lowspeed enable connect
    Port 2: 0000.02a0 lowspeed L1
    Port 3: 0000.02a0 lowspeed L1
    Port 4: 0000.02a0 lowspeed L1
Binary Object Store Descriptor:
   bLength                 5
   bDescriptorType        15
   wTotalLength       0x002a
   bNumDeviceCaps          3
   USB 2.0 Extension Device Capability:
     bLength                 7
     bDescriptorType        16
     bDevCapabilityType      2
     bmAttributes   0x00000002
       HIRD Link Power Management (LPM) Supported
   SuperSpeed USB Device Capability:
     bLength                10
     bDescriptorType        16
     bDevCapabilityType      3
     bmAttributes         0x00
     wSpeedsSupported   0x000e
       Device can operate at Full Speed (12Mbps)
       Device can operate at High Speed (480Mbps)
       Device can operate at SuperSpeed (5Gbps)
     bFunctionalitySupport   1
       Lowest fully-functional device speed is Full Speed (12Mbps)
     bU1DevExitLat           4 micro seconds
     bU2DevExitLat         231 micro seconds
   Container ID Device Capability:
     bLength                20
     bDescriptorType        16
     bDevCapabilityType      4
     bReserved               0
     ContainerID             {30eef35c-07d5-2549-b001-802d79434c30}
Device Status:     0x0001
   Self Powered

Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               3.00
   bDeviceClass            9 Hub
   bDeviceSubClass         0
   bDeviceProtocol         3
   bMaxPacketSize0         9
   idVendor           0x1d6b Linux Foundation
   idProduct          0x0003 3.0 root hub
   bcdDevice            4.19
   iManufacturer           3 Linux 4.19.90-23.1.v2101.ky10.aarch64 xhci-hcd
   iProduct                2 xHCI Host Controller
   iSerial                 1 0000:01:00.0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength       0x001f
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval              12
         bMaxBurst               0
Hub Descriptor:
   bLength              12
   bDescriptorType      42
   nNbrPorts             4
   wHubCharacteristic 0x0009
     Per-port power switching
     Per-port overcurrent protection
   bPwrOn2PwrGood       10 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   bHubDecLat          0.0 micro seconds
   wHubDelay             0 nano seconds
   DeviceRemovable    0x00
  Hub Port Status:
    Port 1: 0000.0203 5Gbps power U0 enable connect
    Port 2: 0000.0203 5Gbps power U0 enable connect
    Port 3: 0000.02a0 5Gbps power Rx.Detect
    Port 4: 0000.02a0 5Gbps power Rx.Detect
Binary Object Store Descriptor:
   bLength                 5
   bDescriptorType        15
   wTotalLength       0x000f
   bNumDeviceCaps          1
   SuperSpeed USB Device Capability:
     bLength                10
     bDescriptorType        16
     bDevCapabilityType      3
     bmAttributes         0x02
       Latency Tolerance Messages (LTM) Supported
     wSpeedsSupported   0x0008
       Device can operate at SuperSpeed (5Gbps)
     bFunctionalitySupport   3
       Lowest fully-functional device speed is SuperSpeed (5Gbps)
     bU1DevExitLat           0 micro seconds
     bU2DevExitLat           0 micro seconds
Device Status:     0x0001
   Self Powered

Bus 001 Device 004: ID 31b2:0011
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            0
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x31b2
   idProduct          0x0011
   bcdDevice            1.15
   iManufacturer           1 KTMicro
   iProduct                2 KT_USB_AUDIO
   iSerial                 3 214b206000000178
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength       0x0127
     bNumInterfaces          4
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              100mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass         1 Audio
       bInterfaceSubClass      1 Control Device
       bInterfaceProtocol      0
       iInterface              0
       AudioControl Interface Descriptor:
         bLength                10
         bDescriptorType        36
         bDescriptorSubtype      1 (HEADER)
         bcdADC               1.00
         wTotalLength       0x005c
         bInCollection           2
         baInterfaceNr(0)        2
         baInterfaceNr(1)        1
       AudioControl Interface Descriptor:
         bLength                12
         bDescriptorType        36
         bDescriptorSubtype      2 (INPUT_TERMINAL)
         bTerminalID             1
         wTerminalType      0x0201 Microphone
         bAssocTerminal          0
         bNrChannels             2
         wChannelConfig     0x0003
           Left Front (L)
           Right Front (R)
         iChannelNames           0
         iTerminal               0
       AudioControl Interface Descriptor:
         bLength                10
         bDescriptorType        36
         bDescriptorSubtype      6 (FEATURE_UNIT)
         bUnitID                 2
         bSourceID               1
         bControlSize            1
         bmaControls(0)       0x03
           Mute Control
           Volume Control
         bmaControls(1)       0x00
         bmaControls(2)       0x00
         iFeature                0
       AudioControl Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      5 (SELECTOR_UNIT)
         bUnitID                 3
         bNrInPins               1
         baSourceID(0)           2
         iSelector               0
       AudioControl Interface Descriptor:
         bLength                 9
         bDescriptorType        36
         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
         bTerminalID             4
         wTerminalType      0x0101 USB Streaming
         bAssocTerminal          0
         bSourceID               3
         iTerminal               0
       AudioControl Interface Descriptor:
         bLength                12
         bDescriptorType        36
         bDescriptorSubtype      2 (INPUT_TERMINAL)
         bTerminalID             5
         wTerminalType      0x0101 USB Streaming
         bAssocTerminal          0
         bNrChannels             2
         wChannelConfig     0x0003
           Left Front (L)
           Right Front (R)
         iChannelNames           0
         iTerminal               0
       AudioControl Interface Descriptor:
         bLength                13
         bDescriptorType        36
         bDescriptorSubtype      4 (MIXER_UNIT)
         bUnitID                 6
         bNrInPins               2
         baSourceID(0)           5
         baSourceID(1)           5
         bNrChannels             2
         wChannelConfig     0x0003
           Left Front (L)
           Right Front (R)
         iChannelNames           0
         bmControls(0)        0x00
         iMixer                  0
       AudioControl Interface Descriptor:
         bLength                10
         bDescriptorType        36
         bDescriptorSubtype      6 (FEATURE_UNIT)
         bUnitID                 7
         bSourceID               6
         bControlSize            1
         bmaControls(0)       0x03
           Mute Control
           Volume Control
         bmaControls(1)       0x00
         bmaControls(2)       0x00
         iFeature                0
       AudioControl Interface Descriptor:
         bLength                 9
         bDescriptorType        36
         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
         bTerminalID             8
         wTerminalType      0x0301 Speaker
         bAssocTerminal          0
         bSourceID               7
         iTerminal               0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       1
       bNumEndpoints           1
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
       AudioStreaming Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      1 (AS_GENERAL)
         bTerminalLink           4
         bDelay                  1 frames
         wFormatTag         0x0001 PCM
       AudioStreaming Interface Descriptor:
         bLength                11
         bDescriptorType        36
         bDescriptorSubtype      2 (FORMAT_TYPE)
         bFormatType             1 (FORMAT_TYPE_I)
         bNrChannels             2
         bSubframeSize           2
         bBitResolution         16
         bSamFreqType            1 Discrete
         tSamFreq[ 0]        48000
       Endpoint Descriptor:
         bLength                 9
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x00c0  1x 192 bytes
         bInterval               1
         bRefresh                0
         bSynchAddress           0
         AudioStreaming Endpoint Descriptor:
           bLength                 7
           bDescriptorType        37
           bDescriptorSubtype      1 (EP_GENERAL)
           bmAttributes         0x01
             Sampling Frequency
           bLockDelayUnits         0 Undefined
           wLockDelay         0x0000
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       1
       bNumEndpoints           1
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
       AudioStreaming Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      1 (AS_GENERAL)
         bTerminalLink           5
         bDelay                  1 frames
         wFormatTag         0x0001 PCM
       AudioStreaming Interface Descriptor:
         bLength                14
         bDescriptorType        36
         bDescriptorSubtype      2 (FORMAT_TYPE)
         bFormatType             1 (FORMAT_TYPE_I)
         bNrChannels             2
         bSubframeSize           2
         bBitResolution         16
         bSamFreqType            2 Discrete
         tSamFreq[ 0]        44100
         tSamFreq[ 1]        48000
       Endpoint Descriptor:
         bLength                 9
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            9
           Transfer Type            Isochronous
           Synch Type               Adaptive
           Usage Type               Data
         wMaxPacketSize     0x00c0  1x 192 bytes
         bInterval               1
         bRefresh                0
         bSynchAddress           0
         AudioStreaming Endpoint Descriptor:
           bLength                 7
           bDescriptorType        37
           bDescriptorSubtype      1 (EP_GENERAL)
           bmAttributes         0x01
             Sampling Frequency
           bLockDelayUnits         0 Undefined
           wLockDelay         0x0000
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       2
       bNumEndpoints           1
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
       AudioStreaming Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      1 (AS_GENERAL)
         bTerminalLink           5
         bDelay                  1 frames
         wFormatTag         0x0001 PCM
       AudioStreaming Interface Descriptor:
         bLength                14
         bDescriptorType        36
         bDescriptorSubtype      2 (FORMAT_TYPE)
         bFormatType             1 (FORMAT_TYPE_I)
         bNrChannels             2
         bSubframeSize           3
         bBitResolution         24
         bSamFreqType            2 Discrete
         tSamFreq[ 0]        44100
         tSamFreq[ 1]        48000
       Endpoint Descriptor:
         bLength                 9
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            9
           Transfer Type            Isochronous
           Synch Type               Adaptive
           Usage Type               Data
         wMaxPacketSize     0x0120  1x 288 bytes
         bInterval               1
         bRefresh                0
         bSynchAddress           0
         AudioStreaming Endpoint Descriptor:
           bLength                 7
           bDescriptorType        37
           bDescriptorSubtype      1 (EP_GENERAL)
           bmAttributes         0x01
             Sampling Frequency
           bLockDelayUnits         0 Undefined
           wLockDelay         0x0000
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        3
       bAlternateSetting       0
       bNumEndpoints           2
       bInterfaceClass         3 Human Interface Device
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.10
           bCountryCode           33 US
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength      74
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval              16
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval              16
Device Status:     0x0002
   (Bus Powered)
   Remote Wakeup Enabled

Bus 001 Device 006: ID 093a:2510 Pixart Imaging, Inc. Optical Mouse
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         8
   idVendor           0x093a Pixart Imaging, Inc.
   idProduct          0x2510 Optical Mouse
   bcdDevice            1.00
   iManufacturer           1 PixArt
   iProduct                2 USB Optical Mouse
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength       0x0022
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              100mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         3 Human Interface Device
       bInterfaceSubClass      1 Boot Interface Subclass
       bInterfaceProtocol      2 Mouse
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.11
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength      46
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval              10
Device Status:     0x0000
   (Bus Powered)

Bus 001 Device 005: ID 1c4f:0026 SiGma Micro Keyboard
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            0
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         8
   idVendor           0x1c4f SiGma Micro
   idProduct          0x0026 Keyboard
   bcdDevice            1.10
   iManufacturer           1 SIGMACHIP
   iProduct                2 USB Keyboard
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength       0x003b
     bNumInterfaces          2
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower               98mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         3 Human Interface Device
       bInterfaceSubClass      1 Boot Interface Subclass
       bInterfaceProtocol      1 Keyboard
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.10
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength      54
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval              10
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         3 Human Interface Device
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.10
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength      50
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0003  1x 3 bytes
         bInterval              10
Device Status:     0x0000
   (Bus Powered)

Bus 001 Device 003: ID 2109:2817 VIA Labs, Inc.
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.10
   bDeviceClass            9 Hub
   bDeviceSubClass         0
   bDeviceProtocol         2 TT per port
   bMaxPacketSize0        64
   idVendor           0x2109 VIA Labs, Inc.
   idProduct          0x2817
   bcdDevice            7.73
   iManufacturer           1 VIA Labs, Inc.
   iProduct                2 USB2.0 Hub
   iSerial                 3 000000000
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength       0x0029
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xc0
       Self Powered
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0
       bInterfaceProtocol      1 Single TT
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              12
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       1
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0
       bInterfaceProtocol      2 TT per port
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              12
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             4
   wHubCharacteristic 0x00e9
     Per-port power switching
     Per-port overcurrent protection
     TT think time 32 FS bits
     Port indicators
   bPwrOn2PwrGood      175 * 2 milli seconds
   bHubContrCurrent    100 milli Ampere
   DeviceRemovable    0x00
   PortPwrCtrlMask    0xff
  Hub Port Status:
    Port 1: 0000.0303 lowspeed power enable connect
    Port 2: 0000.0100 power
    Port 3: 0000.0100 power
    Port 4: 0000.0303 lowspeed power enable connect
Binary Object Store Descriptor:
   bLength                 5
   bDescriptorType        15
   wTotalLength       0x002a
   bNumDeviceCaps          3
   USB 2.0 Extension Device Capability:
     bLength                 7
     bDescriptorType        16
     bDevCapabilityType      2
     bmAttributes   0x00000006
       BESL Link Power Management (LPM) Supported
   SuperSpeed USB Device Capability:
     bLength                10
     bDescriptorType        16
     bDevCapabilityType      3
     bmAttributes         0x00
     wSpeedsSupported   0x000e
       Device can operate at Full Speed (12Mbps)
       Device can operate at High Speed (480Mbps)
       Device can operate at SuperSpeed (5Gbps)
     bFunctionalitySupport   1
       Lowest fully-functional device speed is Full Speed (12Mbps)
     bU1DevExitLat           4 micro seconds
     bU2DevExitLat         231 micro seconds
   Container ID Device Capability:
     bLength                20
     bDescriptorType        16
     bDevCapabilityType      4
     bReserved               0
     ContainerID             {30eef35c-07d5-2549-b001-802d79434c30}
Device Status:     0x0001
   Self Powered

Bus 001 Device 002: ID 2109:2817 VIA Labs, Inc.
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.10
   bDeviceClass            9 Hub
   bDeviceSubClass         0
   bDeviceProtocol         2 TT per port
   bMaxPacketSize0        64
   idVendor           0x2109 VIA Labs, Inc.
   idProduct          0x2817
   bcdDevice            7.73
   iManufacturer           1 VIA Labs, Inc.
   iProduct                2 USB2.0 Hub
   iSerial                 3 000000000
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength       0x0029
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xc0
       Self Powered
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0
       bInterfaceProtocol      1 Single TT
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              12
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       1
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0
       bInterfaceProtocol      2 TT per port
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              12
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             4
   wHubCharacteristic 0x00e9
     Per-port power switching
     Per-port overcurrent protection
     TT think time 32 FS bits
     Port indicators
   bPwrOn2PwrGood      175 * 2 milli seconds
   bHubContrCurrent    100 milli Ampere
   DeviceRemovable    0x00
   PortPwrCtrlMask    0xff
  Hub Port Status:
    Port 1: 0000.0100 power
    Port 2: 0000.0100 power
    Port 3: 0000.0100 power
    Port 4: 0000.0100 power
Binary Object Store Descriptor:
   bLength                 5
   bDescriptorType        15
   wTotalLength       0x002a
   bNumDeviceCaps          3
   USB 2.0 Extension Device Capability:
     bLength                 7
     bDescriptorType        16
     bDevCapabilityType      2
     bmAttributes   0x00000006
       BESL Link Power Management (LPM) Supported
   SuperSpeed USB Device Capability:
     bLength                10
     bDescriptorType        16
     bDevCapabilityType      3
     bmAttributes         0x00
     wSpeedsSupported   0x000e
       Device can operate at Full Speed (12Mbps)
       Device can operate at High Speed (480Mbps)
       Device can operate at SuperSpeed (5Gbps)
     bFunctionalitySupport   1
       Lowest fully-functional device speed is Full Speed (12Mbps)
     bU1DevExitLat           4 micro seconds
     bU2DevExitLat         231 micro seconds
   Container ID Device Capability:
     bLength                20
     bDescriptorType        16
     bDevCapabilityType      4
     bReserved               0
     ContainerID             {30eef35c-07d5-2549-b001-802d79434c30}
Device Status:     0x0001
   Self Powered

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            9 Hub
   bDeviceSubClass         0
   bDeviceProtocol         1 Single TT
   bMaxPacketSize0        64
   idVendor           0x1d6b Linux Foundation
   idProduct          0x0002 2.0 root hub
   bcdDevice            4.19
   iManufacturer           3 Linux 4.19.90-23.1.v2101.ky10.aarch64 xhci-hcd
   iProduct                2 xHCI Host Controller
   iSerial                 1 0000:01:00.0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength       0x0019
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval              12
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             4
   wHubCharacteristic 0x0009
     Per-port power switching
     Per-port overcurrent protection
     TT think time 8 FS bits
   bPwrOn2PwrGood       10 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   DeviceRemovable    0x00
   PortPwrCtrlMask    0xff
  Hub Port Status:
    Port 1: 0000.0503 highspeed power enable connect
    Port 2: 0000.0503 highspeed power enable connect
    Port 3: 0000.0100 power
    Port 4: 0000.0103 power enable connect
Device Status:     0x0001
   Self Powered

在 2022/12/6 17:36, Dicheng Wang 写道:
> From: wangdicheng <wangdicheng@kylinos.cn>
>
> Cc: stable@vger.kernel.org
> Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
> ---
> v2:use USB_DEVICE_VENDOR_SPEC() suggested by Takashi Iwai
>
>   sound/usb/quirks-table.h | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
> index 874fcf245747..271884e35003 100644
> --- a/sound/usb/quirks-table.h
> +++ b/sound/usb/quirks-table.h
> @@ -76,6 +76,8 @@
>   { USB_DEVICE_VENDOR_SPEC(0x041e, 0x3f0a) },
>   /* E-Mu 0204 USB */
>   { USB_DEVICE_VENDOR_SPEC(0x041e, 0x3f19) },
> +/* Ktmicro Usb_audio device */
> +{ USB_DEVICE_VENDOR_SPEC(0x31b2, 0x0011) },
>   
>   /*
>    * Creative Technology, Ltd Live! Cam Sync HD [VF0770]
