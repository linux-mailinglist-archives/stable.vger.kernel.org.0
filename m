Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A6461FA23
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 17:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbiKGQlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 11:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiKGQlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 11:41:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93133634B
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 08:41:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31F84611C9
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 16:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A72FC433C1;
        Mon,  7 Nov 2022 16:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667839261;
        bh=rV0FEWDWEX3pw5xk/P6Od1hD9YTelKAB+AEHNXGucGw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1kLSFg96R6WxIT17jCcSOuD/8/wkolVtUWEQLk7do6PfaB0tcc8Z/ROW20FqiK0sw
         f2obEh4jVYXdqaw0uJVhOCpE622woq5+3NfNZgYoKNEwrsGTwQgMiZrVeTrceqhG2h
         uiuxY1uV/hm6jjzPPcaE4Mykre3OyPJ5gJspyUqA=
Date:   Mon, 7 Nov 2022 17:40:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Veness <john-linux@pelago.org.uk>
Cc:     Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: Re: [PATCH] ALSA: usb-audio: Add quirks for MacroSilicon
 MS2100/MS2106 devices (4.9-5.4)
Message-ID: <Y2k1GvrY8WrX/g4+@kroah.com>
References: <20221107160536.27565-1-john-linux@pelago.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107160536.27565-1-john-linux@pelago.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 04:05:36PM +0000, John Veness wrote:
> commit 6e2c9105e0b743c92a157389d40f00b81bdd09fe upstream.
> 
> Treat the claimed 96kHz 1ch in the descriptors as 48kHz 2ch, so that
> the audio stream doesn't sound mono. Also fix initial stream
> alignment, so that left and right channels are in the correct order.
> 
> Signed-off-by: John Veness <john-linux@pelago.org.uk>
> Link: https://lore.kernel.org/r/20220624140757.28758-1-john-linux@pelago.org.uk
> Cc: <stable@vger.kernel.org> # 5.4
> Cc: <stable@vger.kernel.org> # 4.19
> Cc: <stable@vger.kernel.org> # 4.14
> Cc: <stable@vger.kernel.org> # 4.9
> 
> ---
> Backported to 4.9-5.4.

Now queued up, thanks.

greg k-h
