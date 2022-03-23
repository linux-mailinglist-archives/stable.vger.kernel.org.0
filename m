Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4DD4E4BFF
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 06:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241807AbiCWFHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 01:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiCWFHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 01:07:20 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F239313DC2;
        Tue, 22 Mar 2022 22:05:48 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9A2795C01C2;
        Wed, 23 Mar 2022 01:05:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 23 Mar 2022 01:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=who-t.net; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; bh=cXs53kf34gzbeb
        VPwtBy2GATRwcGNz8VOEiL+25X/14=; b=kXsFzI3ROzb6ENUiw13L+s3a4egCK3
        6rfFrYikC4dduRHAaxOk9VyhGbQyqyjP0Ov1RZcklsw9OSV1qQjka9IEXkPuYo8e
        nJiQ4sH6R0/gJCMsf4/KXQogDMXDqagAQ3AO82qeF6CSmSqmLCq6tk8j6N2Ylg56
        wjfOqaLfRIQyHGfbxIcxg1cBkvnswMaQur9boEos99uJCXG+1HRetQScQzCq89Wo
        agPAPD7z2XaY9TUs5Eq9Y3kSXO4cjcTlb1MSiwMs+tIm5okmKwe0NZ6QtxpEBEx0
        GBV+lcdTWCWGU8GILRCqpYBIdX6u1IklJl3tYXBQpWfe3izDR4m24bWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=cXs53kf34gzbebVPwtBy2GATRwcGNz8VOEiL+25X/
        14=; b=hJZ3AA0bANboTwuu0aoDJknE+op+FPx+IsLSk8CPZ1AGyKOLaPpVP63ls
        nmMhNBkfl9qhX3Rgum/kbwXEKk2WBNtrrFtgtvZtmsoLQkR7cKInKw4w/awnN/V/
        Aj+5ceAXu6iLVQfjwstREK46BpIoU9nG3zmAz++sfPhQkO84fQOxv4KsbeWbsnwE
        tQwLs92/0ohABUkNOmD9PaANaw73FkGSUdvf+KhmyfRwclSRk77zFybkn65qR3TG
        cG9NjIkrkrDm7wW/m91HcjQvg2I7YWqst8hoAHlViZfZ8FvpA2Yfq37sBfl9WIh9
        qcTN42uYCfr4C1xrbnrjsx3K6v7+w==
X-ME-Sender: <xms:qao6YtFmqUVQzSXOh-ouWgBq_S18-x6JZyVP0b4jxwsqjdj3ERhWPw>
    <xme:qao6YiWpIiqgQRWDKROoRWVIZRuQP4HjCbHP76OaKYUQDzHN7jPFMKpppb6e_Fdf2
    PRMGKWqedT3vY24Bxs>
X-ME-Received: <xmr:qao6YvKaNRD5iQ_2WK7j7bse_U_FIbspkP_pAx5VzYSZFzTDdLM4kH-vvu0PPp0EPuzzpyhbUfnnmXZ6vKc7kHFh4a3NznEyDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudegiedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomheprfgvthgv
    rhcujfhuthhtvghrvghruceophgvthgvrhdrhhhuthhtvghrvghrseifhhhoqdhtrdhnvg
    htqeenucggtffrrghtthgvrhhnpeevfeejhedvffeuhfelfefghfdtvddvfffhleejffeu
    gfekvdefhfeffffgueefleenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrgh
    dprhgvughhrghtrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepphgvthgvrhdrhhhuthhtvghrvghrseifhhhoqdhtrdhnvght
X-ME-Proxy: <xmx:qao6YjHRAwhthxWqsP4rkbWRyDj2h2DIW7Wf-pEltZ-PiQF5qv431A>
    <xmx:qao6YjXcAWuGr38uvfR_LKrYbhbukTB3JqduCm1EoBNdII69XCSvTQ>
    <xmx:qao6YuP8ZLOiHnU3KDriRjDQIRvR6d2OxBkxLq6XbYsk8N_7Z5vAgg>
    <xmx:qao6YqHGTG8zQs-OkPW-W3jE1wTjOmRfDl0MVdshzG5f1qpWQjvpeg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Mar 2022 01:05:42 -0400 (EDT)
Date:   Wed, 23 Mar 2022 15:05:37 +1000
From:   Peter Hutterer <peter.hutterer@who-t.net>
To:     =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>
Cc:     jkosina@suse.cz, tiwai@suse.de, benjamin.tissoires@redhat.com,
        regressions@leemhuis.info, linux-input@vger.kernel.org,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "Input: clear BTN_RIGHT/MIDDLE on buttonpads"
Message-ID: <YjqqoW9jU3SoBgYn@quokka>
References: <20220321184404.20025-1-jose.exposito89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220321184404.20025-1-jose.exposito89@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 21, 2022 at 07:44:05PM +0100, José Expósito wrote:
> This reverts commit 37ef4c19b4c659926ce65a7ac709ceaefb211c40.
> 
> The touchpad present in the Dell Precision 7550 and 7750 laptops
> reports a HID_DG_BUTTONTYPE of type MT_BUTTONTYPE_CLICKPAD. However,
> the device is not a clickpad, it is a touchpad with physical buttons.
> 
> In order to fix this issue, a quirk for the device was introduced in
> libinput [1] [2] to disable the INPUT_PROP_BUTTONPAD property:
> 
> 	[Precision 7x50 Touchpad]
> 	MatchBus=i2c
> 	MatchUdevType=touchpad
> 	MatchDMIModalias=dmi:*svnDellInc.:pnPrecision7?50*
> 	AttrInputPropDisable=INPUT_PROP_BUTTONPAD
> 
> However, because of the change introduced in 37ef4c19b4 ("Input: clear
> BTN_RIGHT/MIDDLE on buttonpads") the BTN_RIGHT key bit is not mapped
> anymore breaking the device right click button and making impossible to
> workaround it in user space.
> 
> In order to avoid breakage on other present or future devices, revert
> the patch causing the issue.
> 
> Cc: stable@vger.kernel.org
> Link: https://gitlab.freedesktop.org/libinput/libinput/-/merge_requests/481 [1]
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=1868789  [2]
> Signed-off-by: José Expósito <jose.exposito89@gmail.com>

Acked-by: Peter Hutterer <peter.hutterer@who-t.net>

Cheers,
  Peter


> ---
>  drivers/input/input.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index c3139bc2aa0d..ccaeb2426385 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -2285,12 +2285,6 @@ int input_register_device(struct input_dev *dev)
>  	/* KEY_RESERVED is not supposed to be transmitted to userspace. */
>  	__clear_bit(KEY_RESERVED, dev->keybit);
>  
> -	/* Buttonpads should not map BTN_RIGHT and/or BTN_MIDDLE. */
> -	if (test_bit(INPUT_PROP_BUTTONPAD, dev->propbit)) {
> -		__clear_bit(BTN_RIGHT, dev->keybit);
> -		__clear_bit(BTN_MIDDLE, dev->keybit);
> -	}
> -
>  	/* Make sure that bitmasks not mentioned in dev->evbit are clean. */
>  	input_cleanse_bitmasks(dev);
>  
> -- 
> 2.25.1
> 
