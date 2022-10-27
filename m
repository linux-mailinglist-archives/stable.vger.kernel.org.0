Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E629F60ECF6
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 02:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbiJ0AWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 20:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbiJ0AV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 20:21:59 -0400
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400DA89CF8
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 17:21:56 -0700 (PDT)
Received: from gw.atmark-techno.com (localhost [127.0.0.1])
        by gw.atmark-techno.com (Postfix) with ESMTP id DE1286013D
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:21:55 +0900 (JST)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        by gw.atmark-techno.com (Postfix) with ESMTPS id DD8606013D
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:21:54 +0900 (JST)
Received: by mail-pj1-f72.google.com with SMTP id c91-20020a17090a496400b00212eb50e75cso2058100pjh.6
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 17:21:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t3MAXWAYZ9njFYeSK2wb8W58ukiSVlbgeipHRg6/XSI=;
        b=TMY09Kgnpr5dlBSsG3Ao+fgxG5EuEmWy2EqCBb1zBagQm2YWDtmrZal4NPGx6z1npr
         Ls/+GwD2zeTY8KmmHKKyeUP/Yv0D+dQcWCtt50ZmgKatxSmfbCqU8Rf8H07X3UdZaMtV
         SQCQ695qpix/rn6F92+tBpTg8txn/osCxrXTA+7Ayfb30s/NJ15VB8xHKu86JPUTufKP
         YqXoOTWiROx+8BW1b6UyklTkF58OqgDWbldCPKC3gKYTQg/2+gfoHZhVggr6FP0CjDoU
         s9ipuE1LtXjsl4qtFfEJvbE4NqKw8wONH8YNkBbHUzQWeeJ3m9dff3bj67p0maCkhID/
         MRgQ==
X-Gm-Message-State: ACrzQf3E4FbDSzar6hPcgaM/XZKAtRCkbtQNnBSHuuE5qR8B+cy4h3dz
        jct1iV2kMLghwbm/OegJHnldZpkAEUikRvpuj+ilosJEmXZfQbdj5pu1Q+H1O+MkgQAIrYIj6W1
        bWmf7oh2xLJILCpg1Ui6c
X-Received: by 2002:a17:902:d4ce:b0:186:c8b9:c301 with SMTP id o14-20020a170902d4ce00b00186c8b9c301mr9715903plg.27.1666830113966;
        Wed, 26 Oct 2022 17:21:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6N4/aQSVoFzd1G2K7+143BFzYuHhWpdNKnui7L9HzUFlMABvSsO1BhS5xcZfuns9b/0nzkkg==
X-Received: by 2002:a17:902:d4ce:b0:186:c8b9:c301 with SMTP id o14-20020a170902d4ce00b00186c8b9c301mr9715882plg.27.1666830113749;
        Wed, 26 Oct 2022 17:21:53 -0700 (PDT)
Received: from pc-zest.atmarktech (76.125.194.35.bc.googleusercontent.com. [35.194.125.76])
        by smtp.gmail.com with ESMTPSA id t11-20020aa7946b000000b0052d4cb47339sm1706669pfq.151.2022.10.26.17.21.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Oct 2022 17:21:52 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.96)
        (envelope-from <martinet@pc-zest>)
        id 1onqed-002g2D-1p;
        Thu, 27 Oct 2022 09:21:51 +0900
Date:   Thu, 27 Oct 2022 09:21:41 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lukas Wunner <lukas@wunner.de>, stable@vger.kernel.org,
        Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Roosen Henri <Henri.Roosen@ginzinger.com>,
        linux-serial@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Daisuke Mizobuchi <mizo@atmark-techno.com>
Subject: Re: [PATCH 5.10 v2 1/2] serial: core: move RS485 configuration tasks
 from drivers into core
Message-ID: <Y1nPFe6IaRI7j6fE@atmark-techno.com>
References: <20221017051737.51727-1-dominique.martinet@atmark-techno.com>
 <Y1lmM7Qu1yscuaIU@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y1lmM7Qu1yscuaIU@kroah.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman wrote on Wed, Oct 26, 2022 at 06:54:11PM +0200:
> On Mon, Oct 17, 2022 at 02:17:36PM +0900, Dominique Martinet wrote:
> > From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> > 
> > Several drivers that support setting the RS485 configuration via userspace
> > implement one or more of the following tasks:
> > 
> > - in case of an invalid RTS configuration (both RTS after send and RTS on
> >   send set or both unset) fall back to enable RTS on send and disable RTS
> >   after send
> > 
> > - nullify the padding field of the returned serial_rs485 struct
> > 
> > - copy the configuration into the uart port struct
> > 
> > - limit RTS delays to 100 ms
> > 
> > Move these tasks into the serial core to make them generic and to provide
> > a consistent behaviour among all drivers.
> > 
> > Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> > Link: https://lore.kernel.org/r/20220410104642.32195-2-LinoSanfilippo@gmx.de
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > [ Upstream commit 0ed12afa5655512ee418047fb3546d229df20aa1 ]
> > Signed-off-by: Daisuke Mizobuchi <mizo@atmark-techno.com>
> > Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
> > ---
> > Follow-up of https://lkml.kernel.org/r/20221017013807.34614-1-dominique.martinet@atmark-techno.com
> 
> I need a 5.15.y version of this series before I can take the 5.10.y
> version.

Thanks for the probing, I did not know about this rule (but it makes
sense); I've just sent a 5.15 version:
https://lkml.kernel.org/r/20221027001943.637449-1-dominique.martinet@atmark-techno.com

I'd really appreciate if Lino could take a look and confirm we didn't
botch this too much -- we've tested the 5.10 version and it looks ok,
but this is different enough from the original patch to warrant a check
from the author.

Thanks!
-- 
Dominique


