Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EE261EDDD
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 09:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbiKGI4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 03:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiKGIzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 03:55:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA99167E8
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 00:55:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D80CB80E6C
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 08:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC35C433C1;
        Mon,  7 Nov 2022 08:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667811336;
        bh=hPwj94MWF/Zorm4aOBb95Urft2bovYV2W04S1cTWGpQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U35RMGne0xH8ZNoPjGnGEQNHXhydjeJay4ZD0dftxSs4ryFXkVreJDf5WVNy++xCN
         IWOfk4huOJmbpu8GqCf1Vgbup4aML+wbdgk6V1a06w48LScZosF8ewz2irqjCK7raN
         JW61OwoAquq0QqUoMePtaPRsbQSdz0KAKevnBYp8=
Date:   Mon, 7 Nov 2022 09:55:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Veness <john-linux@pelago.org.uk>
Cc:     Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: Re: [PATCH] ALSA: usb-audio: Add quirks for MacroSilicon
 MS2100/MS2106 devices (5.10)
Message-ID: <Y2jIBPGASBqZ4A/L@kroah.com>
References: <20221103181544.18958-1-john-linux@pelago.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103181544.18958-1-john-linux@pelago.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 03, 2022 at 06:15:44PM +0000, John Veness wrote:
> [ Upstream commit 6e2c9105e0b743c92a157389d40f00b81bdd09fe]
> 
> Backported to 5.10.
> 
> Treat the claimed 96kHz 1ch in the descriptors as 48kHz 2ch, so that
> the audio stream doesn't sound mono. Also fix initial stream
> alignment, so that left and right channels are in the correct order.
> 
> Signed-off-by: John Veness <john-linux@pelago.org.uk>
> Cc: <stable@vger.kernel.org> # 5.10

Now queued up, thanks.

greg k-h
