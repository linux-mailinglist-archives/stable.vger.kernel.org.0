Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FAF5F9D4D
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 13:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbiJJLHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 07:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiJJLHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 07:07:04 -0400
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F2D5BC3B
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 04:07:01 -0700 (PDT)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
        by gw.atmark-techno.com (Postfix) with ESMTPS id 7444A60109
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 20:07:00 +0900 (JST)
Received: by mail-pj1-f70.google.com with SMTP id o15-20020a17090a0a0f00b0020ae208febfso3853199pjo.5
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 04:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6kaXrUY3ds3NT80yBeO+dgFMn3QrJP1rbt9Y4guB0fU=;
        b=Al5yMVieouwxEdZc5LNHG8Zp/dFXWWTr6NzUKhojEt6jLuN2GUz/opkg/3pE186TET
         qcH32Yo1mauEFEwZwC7QHLcQbCWOwJT3kt/E6jYyT4dRrkqTzrnGeldGCNGMKeXlqKsP
         APLRYM5HGzV2FnqK8GZruSHS0aV3FD93UqgM9+GDo7lW+a6k5SCZDP8As2yb424LyCuQ
         dh+W7pYrI6WL65Ol/cugBy9Gvmvr9SX3jd11pm2ufXOTRGXkKF1V9YCBcqXYV6w8F2lz
         X1KrBoSo1NupTLNfu7XKmi3Htq/nbnc7O5B9kuukZybUfbjr/sbMlwlv827jXJG6xxHC
         7LQQ==
X-Gm-Message-State: ACrzQf1Nh73IvFhEnBHTRu0N6J44l8Q/YAQW/horKbiDKQcOyXJin7Q9
        iK5FBiR3g2awrUWCFKuDDO+MwWkn1vZEgA5WQPb+noydpWdBHpUkm1wbq9nJA+lj/3Doj/725FL
        5XZuh2LVFMAYrYLt7uExs
X-Received: by 2002:a17:90a:4e48:b0:209:a883:7f45 with SMTP id t8-20020a17090a4e4800b00209a8837f45mr30957428pjl.106.1665400019463;
        Mon, 10 Oct 2022 04:06:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5G4l8W/f4N1dU2rep4UW9rNCshL05qc75JiwYwqqkanqV4pUPmLY9S5B35hpMChnd5mm4YDg==
X-Received: by 2002:a17:90a:4e48:b0:209:a883:7f45 with SMTP id t8-20020a17090a4e4800b00209a8837f45mr30957408pjl.106.1665400019198;
        Mon, 10 Oct 2022 04:06:59 -0700 (PDT)
Received: from pc-zest.atmarktech (145.82.198.104.bc.googleusercontent.com. [104.198.82.145])
        by smtp.gmail.com with ESMTPSA id nm12-20020a17090b19cc00b0020a9af6bb1asm5907067pjb.32.2022.10.10.04.06.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Oct 2022 04:06:58 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.96)
        (envelope-from <martinet@pc-zest>)
        id 1ohqca-008nSX-06;
        Mon, 10 Oct 2022 20:06:56 +0900
Date:   Mon, 10 Oct 2022 20:06:46 +0900
From:   Dominique MARTINET <dominique.martinet@atmark-techno.com>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] serial: Deassert Transmit Enable on probe in
 driver-specific way
Message-ID: <Y0P8xle/cw3cRkGv@atmark-techno.com>
References: <2de36eba3fbe11278d5002e4e501afe0ceaca039.1663863805.git.lukas@wunner.de>
 <Y0O46rcQap99fZVC@atmark-techno.com>
 <20221010085305.GA32599@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221010085305.GA32599@wunner.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Lukas Wunner wrote on Mon, Oct 10, 2022 at 10:53:05AM +0200:
> > Unfortunately you've marked this for v4.14+ stable, but it doesn't even
> > apply to 5.19.14
> [...]
> > What would you like to do for stable branches?
> > Would you be able to send a patch that applies on older 5.10 and 5.15
> > where commit d3b3404df318 ("serial: Fix incorrect rs485 polarity on uart
> > open") has been backported?
> 
> Greg will try to apply it to stable kernels (probably after the merge
> window closes) and send an e-mail that it failed.  I was going to wait
> for that to happen and then look into backporting the patch.

Ah, sorry for rushing you here -- I got tricked by the git committer
date but that doesn't mean the merge commit was that old, I hadn't
noticed this just got in.

> Basically what needs to be done is replace calls to uart_rs485_config()
> with a direct invocation of port->rs485_config().  Plus carefully checking
> that nothing is missing or breaks.  That's probably simpler than just
> backporting additional patches or reverting stuff.  If you want to take
> a stab at it, go ahead. :)

The only hardware I have is ims and your patch touches at quite a few of
the drivers, I'm not really in a good position to check anything there
but I can give it a stab tomorrow or Wed


By the way that just made me check the imx code, but if I am to trust
that set_mctrl is never called with RS485 enabled and rs485_config is
only called when it is enabled should the SER_RS485_ENABLED checks be
removed there, or did I misunderstand something and it's still useful?

(I wouldn't know if the rs232 hardware flags have any impact on rs485
actual control but I'll trust you on this and that nothing ever calls
set_mctrl when rs485 is enabled... I would actually have said that
rts_active/inactive should keep setting port->mctrl precisely for the
cases where both are muxed as you'll otherwise unreliably enable/disable
RTS based on the state the last time was when get_mctrl was called; but
I haven't seen this done so it doesn't really matter to me)


Thanks,
-- 
Dominique
