Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB058596025
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 18:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiHPQ0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 12:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236307AbiHPQ0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 12:26:47 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121BA7B2BF;
        Tue, 16 Aug 2022 09:26:46 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id m2so9681095pls.4;
        Tue, 16 Aug 2022 09:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=ljLPeyJn0iV7kitzqLVt7KHdOIXq5hmQNIGV4Rf22NI=;
        b=jXPLtZvYYGW1UCSKcJdgu1Qq8Dj49ejW9ZdP9CCg/hqwv1bdbEY4wPJD1MAowdz/WT
         mM3FVSjRlhXKRvZgtCo0kM6Jq41EYfJP4r27COFSuti8y26r/GuQXgSRz27GvtKrMXcT
         EaJlN9jrbiJVSc0uUm3EkTyblrXhYhEJNRnqvwEXkQ0yovmOnig8MXCGcfFMdtcjXnYj
         qVCCWsLaNimCmMXYqLQoBwhUlzvgly9FLSDRjVCyhgYtXDzF5qwRpyvIEIf9+AcJyHE4
         MG6kHbVv08KVZi1rlJGbVipz/eDBdBNBe8VMw0uoSVbnZN0TczWAdr54yVWeUH/LGbJ7
         BrQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=ljLPeyJn0iV7kitzqLVt7KHdOIXq5hmQNIGV4Rf22NI=;
        b=X+foym+Wp0us27bMYvqAFj5q2xClqovjfAAtgDgMqGHfxo1cI8EMx4eTarnkjhc9xm
         XNm1ujFlIw+182kgKW9aNS4ScIqXIApBQPdF9SGsveaP3fop4SNHTlBQ07t2A76CBsrs
         gzbHc974SE5kEOdAAijQkCh/YCYoQavxuTxM/hAyr+v1pp/RKkYYS2pWtOO82KfACSRJ
         gtguZkLHvLJNWnMGWrrhXDiMxGJcRuNgVk5r+nJDErlhtTmtWqKVda9bmZjLqBleGpoT
         +knEDdhMSOr6gQq9fr3ANPOIma8aTbd2WH7Q4G5K1jwxb9q+He3VOYFW/fKhd1fUCLRE
         Sq/Q==
X-Gm-Message-State: ACgBeo026asFPcmkfssQjSrbk3rX5AN6NXWJ8+oiDXWe0vI+uw5CaEwL
        IZVBTuS4bnxXyAmjyXUKB24=
X-Google-Smtp-Source: AA6agR5bHivgn4E351xXewu5xhtK6GrUe9gmyfDOPVlKI+snri85TlL75sgjwzpP/K3IpUj8NJbEYA==
X-Received: by 2002:a17:902:d151:b0:172:9361:2a11 with SMTP id t17-20020a170902d15100b0017293612a11mr1044157plt.148.1660667205379;
        Tue, 16 Aug 2022 09:26:45 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:7229])
        by smtp.gmail.com with ESMTPSA id d2-20020a17090a02c200b001faae55c013sm133834pjd.52.2022.08.16.09.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 09:26:44 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 16 Aug 2022 06:26:43 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, marcan@marcan.st,
        will@kernel.org, peterz@infradead.org, jirislaby@kernel.org,
        maz@kernel.org, mark.rutland@arm.com, boqun.feng@gmail.com,
        catalin.marinas@arm.com, oneukum@suse.com,
        roman.penyaev@profitbricks.com, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
Message-ID: <YvvFQwBVh1s23gbR@slm.duckdns.org>
References: <YvqaK3hxix9AaQBO@slm.duckdns.org>
 <YvsZ6vObgLaDeSZk@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvsZ6vObgLaDeSZk@gondor.apana.org.au>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Tue, Aug 16, 2022 at 12:15:38PM +0800, Herbert Xu wrote:
> Tejun Heo <tj@kernel.org> wrote:
> > 
> > Oh, tricky one and yeah you're absolutely right that it makes no sense to
> > not guarantee barrier semantics when already pending. I didn't even know
> > test_and_set_bit() wasn't a barrier when it failed. Thanks a lot for hunting
> > down and fixing this. Applied to wq/for-6.0-fixes.
> 
> Please revert this as test_and_set_bit was always supposed to be
> a full memory barrier.  This is an arch bug.

Alright, reverting.

Thanks.

-- 
tejun
