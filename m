Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C62B4EBC30
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 09:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237879AbiC3Hyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 03:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243979AbiC3Hyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 03:54:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1B0C0D;
        Wed, 30 Mar 2022 00:52:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 73980CE1BE5;
        Wed, 30 Mar 2022 07:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C554BC340F0;
        Wed, 30 Mar 2022 07:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648626768;
        bh=uOUpJYOXOJLgRXyKzz89unZGakk2wmHGrK9GrCRr/aQ=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=k9nFMKsvi61AbRhFGck3e5m+TDyQDu8QUEFSQ4l4q7fKdEz8sBUFJnaDO4twKrIwP
         La1NAbKwom6wiI+Hw3jDqEEPQGeY/lNevPbMwO7xBFZbD3uzYJFUjScGGu6Y8HkTk3
         SQNz8whDYy0IdZpWOxXrDuneAQDm3hTYPy7XcMblE6ToRhvZQvJehBT2kx+9day+B4
         ce/0Pcp9qgQdapYevtVgrY+SKDLvz3YVzooT0n84j5WTsPJOnw9+tEuJPPPO3qfLNb
         rM4q0FGR3L3rcRzLEY0RPlhn3a3gdxorHZsZWpadcoUB/gVLVHVMIvS0Uce7jTavSq
         rvtIX2mjVf45Q==
Date:   Wed, 30 Mar 2022 09:52:43 +0200 (CEST)
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
Subject: Re: Request for reverting the commit for Samsung HID driver
In-Reply-To: <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3>
Message-ID: <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm>
References: <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p3> <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 30 Mar 2022, 조준완 wrote:

> author
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> 2021-12-01 19:35:03 +0100
> 
> committer
> Benjamin Tissoires <benjamin.tissoires@redhat.com> 2021-12-02 15:36:18 +0100
> 
> commit
> 93020953d0fa7035fd036ad87a47ae2b7aa4ae33 (patch)
> 
> tree
> f734e9962e28cedcccfbb109e510d39a18ed6d34 /drivers/hid/hid-samsung.c
> 
> parent
> 720ac467204a70308bd687927ed475afb904e11b (diff)
> 
> download
> linux-93020953d0fa7035fd036ad87a47ae2b7aa4ae33.tar.gz
>  
> HID: check for valid USB device for many HID drivers
> 
> Many HID drivers assume that the HID device assigned to them is a USB 
> device as that was the only way HID devices used to be able to be 
> created in Linux. However, with the additional ways that HID devices can 
> be created for many different bus types, that is no longer true, so 
> properly check that we have a USB device associated with the HID device 
> before allowing a driver that makes this assumption to claim it.
> 
> 
> diff --git a/drivers/hid/hid-samsung.c b/drivers/hid/hid-samsung.c
> index 2e1c31156eca0..cf5992e970940 100644
> --- a/drivers/hid/hid-samsung.c
> +++ b/drivers/hid/hid-samsung.c
> 
> @@ -152,6 +152,9 @@ static int samsung_probe(struct hid_device *hdev,
> 
> int ret;
> 
> unsigned int cmask = HID_CONNECT_DEFAULT;
> 
> 
> + if (!hid_is_usb(hdev))
> 
> + return -EINVAL;
> 
> +
> 
> ret = hid_parse(hdev);
> 
> if (ret) {
> 
> hid_err(hdev, "parse failed\n");
> 
> 
> Bluetooth HID devices like Keyboard and mice don't work at all because 
> of this commit.

Could you please elaborate a little bit more -- which Bluetooth device 
(VID/PID) are you referring to please? hid-samsung as-is in mainline 
should only match against these two:

	static const struct hid_device_id samsung_devices[] = {
	        { HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
	        { HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE) },
	        { }
	};
	MODULE_DEVICE_TABLE(hid, samsung_devices);

which are both USB devices, not Bluetooth.

> We Samsung applies several patches to Samsung drivers for Android models 
> based on Linux kernel Samsung Driver. For example, add Samsung 
> accessories or define key codes for special key processing.
> 
> We don't want any changes in Samsung hid driver by others.

That's not how Linux development works though.

> Soorer or later, I have a plan to contribute a modified driver by 
> Samsung that is currently in use on Samsung Android.

That would be very much appreciated, thanks.

Once you do so, you can very well become maintainers of hid-samsung driver 
(which would make a lot of sense for someone from Samsung to actually 
participate in development of that driver), and have much better influence 
on what goes in and in which form.

> Anyway, we sincerely hope you will revert this commit because Samsung 
> driver is not just for USB accessories.

I still would like to understand this part, because as far as I can tell, 
the in-kernel one is.

Thanks,

-- 
Jiri Kosina
SUSE Labs

