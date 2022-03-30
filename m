Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B984EBC78
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 10:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239799AbiC3IQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 04:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244172AbiC3IQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 04:16:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4BF1006;
        Wed, 30 Mar 2022 01:14:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6576617A1;
        Wed, 30 Mar 2022 08:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8875CC340EC;
        Wed, 30 Mar 2022 08:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648628065;
        bh=Fpgu/5DFUpUWwvmosdF3rDCTCvGpt5n55LZWD7h9KY0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N3Ujer1GOfdHR8vrboTmvE5HM062A3m98x/JTdYYnd+knTEHzcq62yOpQ0qQKQbuI
         KZtM5RN4TnvUlEqNIzLc4z1FzAJrCLo//4NHnoqssrSbZYTf0zabOjgTcZKoO4weTP
         ozwUcTyHiooeDJr4wgb8GBijtYFFkYd0r6ncESUM=
Date:   Wed, 30 Mar 2022 10:14:22 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     =?utf-8?B?7KGw7KSA7JmE?= <junwan.cho@samsung.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "michael.zaidman@gmail.com" <michael.zaidman@gmail.com>,
        "erazor_de@users.sourceforge.net" <erazor_de@users.sourceforge.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?utf-8?B?6rmA7J287Zi4?= <ih0923.kim@samsung.com>,
        =?utf-8?B?67CV7LKc7Zi4?= <chun.ho.park@samsung.com>,
        =?utf-8?B?67Cw7Jyk7Iud?= <yunsik.bae@samsung.com>,
        =?utf-8?B?6rCV64yA7Z2s?= <daihee7.kang@samsung.com>,
        =?utf-8?B?7J206rSR7Zi4?= <gaudium.lee@samsung.com>,
        =?utf-8?B?66WY7LKc7Jqw?= <chunwoo.ryu@samsung.com>,
        =?utf-8?B?64KY65GQ7IiY?= <doosu.na@samsung.com>,
        =?utf-8?B?6rmA7IiY7ZiE?= <suhyun_.kim@samsung.com>
Subject: Re: (2) Request for reverting the commit for Samsung HID driver
Message-ID: <YkQRXqlzVjBLbvp2@kroah.com>
References: <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm>
 <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3>
 <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p5>
 <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 05:09:37PM +0900, 조준완 wrote:
> 
> Dear Jiri Kosina,
> 
> Thank you for your propt reponse.
> 
> 
> Please refer to accossories below.
> 
> 
> static const struct hid_device_id samsung_devices[] = {
> 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
> 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE) },
>     { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SAMSUNG_ELECTRONICS, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD) },
>     { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SAMSUNG_ELECTRONICS, USB_DEVICE_ID_SAMSUNG_WIRELESS_GAMEPAD) },
>     { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SAMSUNG_ELECTRONICS, USB_DEVICE_ID_SAMSUNG_WIRELESS_ACTIONMOUSE) },
>     { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SAMSUNG_ELECTRONICS, USB_DEVICE_ID_SAMSUNG_WIRELESS_UNIVERSAL_KBD) },
>     { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SAMSUNG_ELECTRONICS, USB_DEVICE_ID_SAMSUNG_WIRELESS_MULTI_HOGP_KBD) },
> 	{ }
> };
> MODULE_DEVICE_TABLE(hid, samsung_devices);
> 
> 
> Mobile users prefer to use Bluetooth devices instead of USB devices.
> The commit should be reverted for Bluetooth accessories.
> 
> Due to internal problem, it takes time to upload Samsung's patch.
> So, please first revert the commit :)

No, not at all.

The commit is correct, as the driver code, as contained in the kernel
tree, requires that check to solve a problem where this driver can be
used to exploit the system.

Any out-of-tree changes you make, you are required to maintain and keep
up to date in order to have them remain working.  That is a requirement
of you, we have no idea what changes anyone else makes, that would be
impossible.

This is the real cost of keeping out-of-tree changes, your management
knows this and plans for it in their budgeting.  There is nothing that
we can do about this.

So the change needs to remain in order for the code to be correct.
Without it, you have a broken and totally insecure system.

If you wish to make the changes you list above to the driver, you now
need to make more changes in order to properly handle the fixes we made
to the code.  Please submit your changes so that we can review them and
accept them if they are correct.

thanks,

greg k-h
