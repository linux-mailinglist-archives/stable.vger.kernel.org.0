Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333B34EBC6C
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 10:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238763AbiC3INm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 04:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbiC3INl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 04:13:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7103EB9F;
        Wed, 30 Mar 2022 01:11:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A864B818F9;
        Wed, 30 Mar 2022 08:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE97DC340F0;
        Wed, 30 Mar 2022 08:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648627913;
        bh=dIzVSbj8UvotNR4lZOGyubyhMpuU6aq4MF/oOU4GcRk=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=VYHe+LL6G3UqzsnRrh29N9q+4z8zS3UOGPlF86fFlUKq8AlZxMfClxEeEsTB3Zdtb
         4jAloy2DldzzDw5Ar2jGbTexEfnatJSq7jth09DZdsbfi0fpmbebYzKmZ2Yz7EHm6B
         5zgI/2naYh9aTRbPW2z1F82mxBoJie69wJqgFIIZrdDx1AlzYXXVG3JuQ8VEE8j9M2
         zJaLl9/lOLA7/QlQ21fMJcdXh7455R9dKjQ1TwFyhaX53o7kGJHA/j/Afc7kfBK2rk
         AbRf7yNdrPrnuzpkUFWgtPVFcnszM3OV2jE3rPTSntY6epYe9WIeKbNoERStXrWV3m
         DqadRJA7M0XsQ==
Date:   Wed, 30 Mar 2022 10:11:48 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     =?EUC-KR?B?wbbB2L/P?= <junwan.cho@samsung.com>
cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "michael.zaidman@gmail.com" <michael.zaidman@gmail.com>,
        "erazor_de@users.sourceforge.net" <erazor_de@users.sourceforge.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?EUC-KR?B?sejAz8ij?= <ih0923.kim@samsung.com>,
        =?EUC-KR?B?udrDtcij?= <chun.ho.park@samsung.com>,
        =?EUC-KR?B?uejAsb3E?= <yunsik.bae@samsung.com>,
        =?EUC-KR?B?sK2068jx?= <daihee7.kang@samsung.com>,
        =?EUC-KR?B?wMyxpMij?= <gaudium.lee@samsung.com>,
        =?EUC-KR?B?t/nDtb/s?= <chunwoo.ryu@samsung.com>,
        =?EUC-KR?B?s6q1zrz2?= <doosu.na@samsung.com>,
        =?EUC-KR?B?sei89sf2?= <suhyun_.kim@samsung.com>
Subject: RE:(2) Request for reverting the commit for Samsung HID driver
In-Reply-To: <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
Message-ID: <nycvar.YFH.7.76.2203301010270.24795@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm> <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3> <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p5>
 <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 30 Mar 2022, 조준완 wrote:

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

This is not how the in-kernel driver looks like in Linus' tree though.

> Mobile users prefer to use Bluetooth devices instead of USB devices. The 
> commit should be reverted for Bluetooth accessories.

Yeah, but the driver in kernel tree doesn't support any Bluetooth devices, 
so there is no need to revert that commit there.

Once you submit your patches to support Bluetooth devices, we'd of course 
have to adjust that condition.

Thanks,

-- 
Jiri Kosina
SUSE Labs

