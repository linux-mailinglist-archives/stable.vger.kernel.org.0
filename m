Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C318D53FB1E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 12:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240957AbiFGKZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 06:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240974AbiFGKZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 06:25:05 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E335DA5A
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 03:25:02 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id r123-20020a1c2b81000000b0039c1439c33cso9272273wmr.5
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 03:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=malat-biz.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jn0EHNfnW+j1MiRaoiifQn0/z4QTwceqDn9P9T64iwQ=;
        b=uqhMyEocxEWlapBw4E6UOxzNuzO983FvPAcwdxo1nGvTqJkD5JmLMyUVNmMKQkDC7U
         +Lwa5lFsgL9NZDhjc7QixV0Ok5G6Fwx9zVO2PmKv3gPhQKaxVZXwmczZSFw3AwqN1SG7
         jDXB8YLO6BaBVtziqpI+foGNSL8u9mhaH7eYYrFMMlpmMC/gClvZ5FFBlr1xW4tfwPms
         ryENPneNB3lXSlVXMxE4fHvOvlr9Y9tJ2dfitj/A40Lr4KuXvJT3xiXi8crog6Mn1cPj
         O4Ebs2XO44VxnDzwAhBR3DJO6Gp5KknkFHPeqvTozFDwzwZTRyZBzGxs9u4dJc5rgfts
         JAuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jn0EHNfnW+j1MiRaoiifQn0/z4QTwceqDn9P9T64iwQ=;
        b=s/GCdauUpHgdk41BfbaGbeHdt7BR6LRzcB3oMjEAmwy8SnFefZq60XhaCbtm3iI+hC
         HNQjJZZcDGfKmOk6Z6YJmmGYQE4rzwa6EjgRPuFqGmP2Lg9jLw/a8uySnhP6JsDRpPXO
         rO1Fp81KeWJIa8e4YyV88i8RO1O0NAT7STLOlMHWPqPNRJuUf4NpXj2ruq/sU1xhzmrG
         m2A2op315yAdc+0YHvWcXNEH8WUy8m4sOyZ8rWO29eA3LRSUr8Xg/DQutPsuZwA3eE0o
         HBTB7qkirvt+KfC4RygBHoPovwTgPu2mZaLhjPDkoBGBQTD/yYXsbVr3U9yIoLXsVOza
         YK6w==
X-Gm-Message-State: AOAM533mITsNgkL6WF6V+7a/EusDMd420i64dR0q+dQho+BDZg9OZNYp
        yfHT1t2Hafu6jxWpl0yXBgA5/Q==
X-Google-Smtp-Source: ABdhPJyzgrVt1X0JsGbdSXIMkWI5Sw9Ff7ZZTKZe7Vp3ZgnjCyAt/AGRVS3Ld09OKm/TFFd5hJ4Ieg==
X-Received: by 2002:a1c:5444:0:b0:39c:3761:ac37 with SMTP id p4-20020a1c5444000000b0039c3761ac37mr24918987wmi.144.1654597501012;
        Tue, 07 Jun 2022 03:25:01 -0700 (PDT)
Received: from ntb.petris.klfree.czf ([193.86.118.65])
        by smtp.gmail.com with ESMTPSA id n20-20020a7bc5d4000000b0039aef592ca0sm19759738wmk.35.2022.06.07.03.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 03:25:00 -0700 (PDT)
Date:   Tue, 7 Jun 2022 12:24:52 +0200
From:   Petr Malat <oss@malat.biz>
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Joern Engel <joern@lazybastard.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mtd: phram: Map RAM using memremap instead of ioremap
Message-ID: <Yp8ndNcYbkIKjZmI@ntb.petris.klfree.czf>
References: <20220523142825.3144904-1-oss@malat.biz>
 <3cab9a7f4ed34ca0b742a62c2bdc3bce@AcuMS.aculab.com>
 <Youn9AmqY6/EExDw@ntb.petris.klfree.czf>
 <e33f91a3eacc4aa3a08e6465fef9265c@AcuMS.aculab.com>
 <YoyFpbhLB1E+8ilr@ntb.petris.klfree.czf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoyFpbhLB1E+8ilr@ntb.petris.klfree.czf>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

On Mon, May 23, 2022 at 04:09:20PM +0000, David Laight wrote:
> On x86 (which I know a lot more about) memcpy() has a nasty
> habit of getting implemented as 'rep movsb' relying on the
> cpu to speed it up.
> But that doesn't happen for uncached addresses - so you get
> very slow byte copies.

I have measured the performance with (patched) and without my
change (orig). My change improves the performance on X8664 and
arm. On Mips64 it stays the same:

Tests
=====
All runtimes are in milliseconds, average real-time of 3 runs, time
measured with bash time built-in. Measured process run in SCHED_FIFO
with priority 99. Page cache was flushed before every run, but all
involved program images were in tmpfs (no swap).
 - dd r512
   dd if=/dev/TESTDEV of=/dev/null  bs=512
 - dd r1MB
   dd if=/dev/TESTDEV of=/dev/null  bs=1M
 - dd r512
   dd of=/dev/TESTDEV if=/tmpfs/img bs=512
 - dd r1MB
   dd of=/dev/TESTDEV if=/tmpfs/img bs=1M
 - flashcp
   flashcp /tmpfs/img /dev/TESTDEV
 - flasherase
   flash_eraseall -q /dev/TESTDEV

Results
=======
All times are in ms

ARCH       |     MIPS64      |       ARM       |     X8664
CPU        |   CN6335p2.2    |    v7 TI K2     |  Xeon D-1548
Dev. size  |      32MB       |      128MB      |     256MB
-----------+-------+---------+-------+---------+-------+---------
     in ms |  Orig | Patched |  Orig | Patched |  Orig | Patched
dd r512    |   131 |     130 |  1101 |     543 | 22906 |     281
dd r1MB    |    65 |      65 |   655 |     122 | 22715 |      70
dd w512    |  1150 |    1150 |  1136 |    1042 | 28067 |     412
dd w1MB    |   104 |     104 |   396 |     244 | 27761 |     122
flashcp    |   100 |      99 |  1438 |     568 | 78455 |     270
flasherase |    21 |      21 |   208 |      77 | 27707 |      57

BR,
  Petr
