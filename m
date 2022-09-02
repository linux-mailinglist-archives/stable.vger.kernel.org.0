Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58F25AADDB
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 13:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbiIBLrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 07:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiIBLrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 07:47:10 -0400
X-Greylist: delayed 387 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 02 Sep 2022 04:47:08 PDT
Received: from mail.bitwise.fi (mail.bitwise.fi [109.204.228.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947C0B02B6;
        Fri,  2 Sep 2022 04:47:08 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.bitwise.fi (Postfix) with ESMTP id 1F04C460041;
        Fri,  2 Sep 2022 14:40:39 +0300 (EEST)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mail.bitwise.fi ([127.0.0.1])
        by localhost (mustetatti.dmz.bitwise.fi [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9mVdyALJ5hoz; Fri,  2 Sep 2022 14:40:36 +0300 (EEST)
Received: from [192.168.5.238] (fw1.dmz.bitwise.fi [192.168.69.1])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: anssiha)
        by mail.bitwise.fi (Postfix) with ESMTPSA id B61EF46003F;
        Fri,  2 Sep 2022 14:40:36 +0300 (EEST)
Message-ID: <e1c06d77-9758-49e3-f772-084d2df365b9@bitwise.fi>
Date:   Fri, 2 Sep 2022 14:40:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v3 04/15] can: kvaser_usb: kvaser_usb_leaf: Get
 capabilities from device
Content-Language: en-US
To:     Jimmy Assarsson <extja@kvaser.com>, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org
References: <20220901122729.271-1-extja@kvaser.com>
 <20220901122729.271-5-extja@kvaser.com>
From:   Anssi Hannula <anssi.hannula@bitwise.fi>
In-Reply-To: <20220901122729.271-5-extja@kvaser.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 1.9.2022 15.27, Jimmy Assarsson wrote:
> Use the CMD_GET_CAPABILITIES_REQ command to query the device for certain
> capabilities. We are only interested in LISTENONLY mode and wither the
> device reports CAN error counters.
>
> And remove hard coded capabilities for all Leaf devices.

I think the second paragraph is no longer accurate.

But the patch itself works for me now with no regressions that I can see.

Tested-by: Anssi Hannula <anssi.hannula@bitwise.fi>

Thanks for taking care of the patchset!

> Cc: stable@vger.kernel.org
> Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
> Reported-by: Anssi Hannula <anssi.hannula@bitwise.fi>
> Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
> ---
> Changes in v3
>  - Rebased on 1d5eeda23f36 ("can: kvaser_usb: advertise timestamping capabilities and add ioctl support")
>  - Add stable to CC
>  - Re-add hard coded capabilities for Leaf M32C devices, to fix regression
>    found by Anssi Hannula in v2 [1].
>
> Changes in v2:
>   - New in v2. Replaces [PATCH 04/12] can: kvaser_usb: Mark Mini PCIe 2xHS as supporting
>  error counters
>   - Fixed Anssi's comments; https://lore.kernel.org/linux-can/9742e7ab-3650-74d8-5a44-136555788c08@bitwise.fi/
>
> [1] https://lore.kernel.org/linux-can/b25bc059-d776-146d-0b3c-41aecf4bd9f8@bitwise.fi/
>
>  .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 144 +++++++++++++++++-
>  1 file changed, 143 insertions(+), 1 deletion(-)
>
[...]


-- 
Anssi Hannula / Bitwise Oy
+358 503803997

