Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC385F9944
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiJJHKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiJJHJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:09:26 -0400
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8AB5BC24
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 00:06:15 -0700 (PDT)
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        by gw.atmark-techno.com (Postfix) with ESMTPS id EE4426010A
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 16:06:09 +0900 (JST)
Received: by mail-pl1-f199.google.com with SMTP id d18-20020a170903231200b0018031042fb6so4876311plh.19
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 00:06:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7IgE0ag6icu39lDWLleAsDr5Zb9nBOutjsMecAkOD4M=;
        b=CB5YOGEKI7W2rffTJFSiYGqrr79FXBC8hkOVszkt2xky8QQp6MmxzyUJzYJtIPAZqS
         gM/3V0CEMnJFtVCyO99/VlK9+RFEreqwZPgllDcgHtXwI/yhZ61jTyBQLvZ4vi3ltpxm
         OxNIOnLyZVy2dPCNGpsnIoLad5eAl8gfQXY14NacIK+RC1BTuAbjZv0VnvVCdjnX0zHh
         K3F1xcUs07jRK+S3ZZ4zAy9Y2e6pXR1fPl2VkBzEoRAsCO2ak15dYa1cw7oQ4MjayiIo
         axnChoBJvHJinXWOqdn/Ad15TPTYC8Y/kybelT5amwJAzdFObZancB8m5EA+fPt3OBL0
         qZ5w==
X-Gm-Message-State: ACrzQf3X+9YxJYJExAiPS+I5RdZA8wn7oNcxY0K+QoGoq205SgS2qaeY
        4/8dUBobMf6TM8xGTLOFHmjYSjpRLlA3FxyYBOGDwI7MnCJFoYDI8WAq9LHuPiTgj5lugQFG/FE
        zrnAHNcW2cE7XvkgEsHHm
X-Received: by 2002:a63:ed58:0:b0:439:b3a:4f01 with SMTP id m24-20020a63ed58000000b004390b3a4f01mr15458092pgk.327.1665385568961;
        Mon, 10 Oct 2022 00:06:08 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4UN7oKeQP7gCTCfMCPDB0BKSJLNi7zrjXS6PxaiaZ75jY8Gcci5Ah/mYLQFYnDVe4vX1gimg==
X-Received: by 2002:a63:ed58:0:b0:439:b3a:4f01 with SMTP id m24-20020a63ed58000000b004390b3a4f01mr15458073pgk.327.1665385568678;
        Mon, 10 Oct 2022 00:06:08 -0700 (PDT)
Received: from pc-zest.atmarktech (103.131.189.35.bc.googleusercontent.com. [35.189.131.103])
        by smtp.gmail.com with ESMTPSA id o28-20020aa7979c000000b00562bc93f1c9sm5925705pfp.213.2022.10.10.00.06.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Oct 2022 00:06:08 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.96)
        (envelope-from <martinet@pc-zest>)
        id 1ohmrW-0080RB-1e;
        Mon, 10 Oct 2022 16:06:06 +0900
Date:   Mon, 10 Oct 2022 16:05:56 +0900
From:   Dominique MARTINET <dominique.martinet@atmark-techno.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lukas Wunner <lukas@wunner.de>, linux-serial@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] serial: Deassert Transmit Enable on probe in
 driver-specific way
Message-ID: <Y0PEVDSYGWA+kYwF@atmark-techno.com>
References: <2de36eba3fbe11278d5002e4e501afe0ceaca039.1663863805.git.lukas@wunner.de>
 <Y0O46rcQap99fZVC@atmark-techno.com>
 <Y0O9z3dg5K6qQrRm@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y0O9z3dg5K6qQrRm@kroah.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman wrote on Mon, Oct 10, 2022 at 08:38:07AM +0200:
> > Thanks for this fix!
> > We also noticed rs485 DE was initially wrong last week and I noticed
> > this when I was about to send a patch that just inverted the
> > SER_RS485_RTS_AFTER_SEND check in uart_configure_port, but after reading
> > the commit message here it's a lot more complicated than that depending
> > on the serial driver...
> > (fixing commit 2dd8a74fddd2 ("serial: core: Initialize rs485 RTS
> > polarity already on probe"), but it's actually the same problem in the
> > opposite direction)
> > 
> > 
> > Unfortunately you've marked this for v4.14+ stable, but it doesn't even
> > apply to 5.19.14 due to (at least) commit d8fcd9cfbde5 ("serial: core:
> > move sanitizing of RS485 delays into own function"), so it hasn't been
> > picked up yet; since quite a bit of code was cleaned up/moved one will
> > need to pay a bit attention when doing that.
> > 
> > What would you like to do for stable branches?
> > Would you be able to send a patch that applies on older 5.10 and 5.15
> > where commit d3b3404df318 ("serial: Fix incorrect rs485 polarity on uart
> > open") has been backported?
> > 
> > If that sounds too complicated we could probably just revert a handful
> > of serial_core/rs485 commits, but going forward sounds more future-proof
> > to me.
> > 
> > Thanks!
> > (nothing below, leaving quote for stable@)
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>

Yes, it does not apply. I've just added stable@ in cc so you're aware
that 5.10 and 5.15 still have a problem with the serial code (and in
case you have an opinion between trying to backport this big patch or
reverting a bunch of older ones)

The quote is just context.

I can try to backport it and send it properly if Lukas doesn't have
time, but it doesn't hurt to discuss first.

Thanks,
-- 
Dominique
