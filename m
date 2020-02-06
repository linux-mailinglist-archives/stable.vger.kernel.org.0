Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC1E315476C
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 16:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgBFPOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 10:14:12 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59642 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727392AbgBFPOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 10:14:12 -0500
Received: (qmail 2315 invoked by uid 2102); 6 Feb 2020 10:14:11 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 6 Feb 2020 10:14:11 -0500
Date:   Thu, 6 Feb 2020 10:14:11 -0500 (EST)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     "Enderborg, Peter" <Peter.Enderborg@sony.com>
cc:     Jiri Kosina <jikos@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 17/78] HID: Fix slab-out-of-bounds read in
 hid_field_extract (Broken!)
In-Reply-To: <e80973cc-812a-df52-c54a-8edf500c0c75@sony.com>
Message-ID: <Pine.LNX.4.44L0.2002061011140.1503-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 6 Feb 2020, Enderborg, Peter wrote:

> > Also, please post the output from "lsusb -v" for the StreamDeck.
> 
> Bus 002 Device 008: ID 0fd9:0060 Elgato Systems GmbH Stream Deck
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x0fd9 Elgato Systems GmbH
>   idProduct          0x0060
>   bcdDevice            1.00
>   iManufacturer           1
>   iProduct                2
>   iSerial                 3
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength       0x0029
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0xe0
>       Self Powered
>       Remote Wakeup
>     MaxPower              400mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass         3 Human Interface Device
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>         HID Device Descriptor:
>           bLength                 9
>           bDescriptorType        33
>           bcdHID               1.11
>           bCountryCode            0 Not supported
>           bNumDescriptors         1
>           bDescriptorType        34 Report
>           wDescriptorLength     248
>          Report Descriptors:
>            ** UNAVAILABLE **

I was hoping to see the report descriptors.  This would produce the 
actual descriptors as sent by the device, not the kernel's 
interpretation or modification of the descriptors.

I guess you have to unbind the device from the usbhid driver first in
order for lsusb to get them.  Can you do that?

Alan Stern

