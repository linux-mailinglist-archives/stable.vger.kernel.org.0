Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7553559B350
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 13:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiHUL3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 07:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiHUL3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 07:29:03 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97047140EA;
        Sun, 21 Aug 2022 04:29:02 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id y13so16350196ejp.13;
        Sun, 21 Aug 2022 04:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=fMM08NkXjQf8LQsd9if/tOzac0dPGc2gucFpi22QVMQ=;
        b=Pl0IJgXimvbpN8Ay+cPjZUz7W9u9zY5Mds0dOZTqJDTZXNbMF/qhwJjS/rnUGbN1Jr
         KkHT++eKkZ8wDN5+on6ILJlvMOc8u5Im4o5eQJVoqCmHieLs6pkfaSd5eGfrs6eL40uK
         kvk2njQtHJ+p2d+cqEjOtY3JE3khnkdv36FkH6AqPqfNaCi4LHC69GZazbeizO1Pca9J
         r/8I2O72WqThxbqRF1WAYhthGhQ11UfD5h/yTgBQo8ENuXyyJAhQKGFHPS9tv0Ty8m3u
         VWFL3d+EJ3867f/GBFko/whzW2FcH4luLpibwYyUgGR/DdvHdSbg5aeQ4V1w9AZuebF2
         vepw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=fMM08NkXjQf8LQsd9if/tOzac0dPGc2gucFpi22QVMQ=;
        b=VXvlqYG5kA3R6oP+pSghgC/LZuvisOkTkU7AV8UQCjdKwWXui6p6iwC7nUI4bimq0X
         sGrmZCetKryTRNjcfIjN0o0KA73vapJYBEaGBw02W8rmsiClec+9NgRRaB88MhZmFbms
         /gAjpa6U87E/PSAUHwKnvB3/BSS2P4zQAXBYqSaTB/6MSEBCt/oAN6g9yonF9ejN77pS
         Ci3rjSWBQN9VR6Xc7DbaKKckMxvB9I+B5ye8HtznDhzcSCxTCEe1joR/y9XJcHxblYVt
         W3JQesnCZzHrivAuk6z2YpU55YobYtsVei2lsETpaZewZF6RsgYZKoBa5EO2uyFMVkiG
         NnsA==
X-Gm-Message-State: ACgBeo3Mesdi2KspUUSn30ik5NPsK1/ZraGL/YowOVyEs9QtJw68+xE0
        nQ7vNiWOnBeb7Mpx0emu8hE=
X-Google-Smtp-Source: AA6agR5ewCNy9F+q8FAPPV2JuMBq7E35ydIBDWEqmJhjsir4JqdKjtpA6P9Nw0uNlVJtU8RmTWHvrA==
X-Received: by 2002:a17:907:1629:b0:730:7ad7:24f2 with SMTP id hb41-20020a170907162900b007307ad724f2mr10163420ejc.261.1661081341112;
        Sun, 21 Aug 2022 04:29:01 -0700 (PDT)
Received: from gmail.com (195-38-113-151.pool.digikabel.hu. [195.38.113.151])
        by smtp.gmail.com with ESMTPSA id jv16-20020a170907769000b0073d6ab5bcaasm1596941ejc.212.2022.08.21.04.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 04:29:00 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Sun, 21 Aug 2022 13:28:58 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Mel Gorman <mgorman@suse.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] sched/all: Change all BUG_ON() instances in the
 scheduler to WARN_ON_ONCE()
Message-ID: <YwIW+mVeZoTOxn/4@gmail.com>
References: <20220808073232.8808-1-david@redhat.com>
 <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
 <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com>
 <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
 <YvSsKcAXISmshtHo@gmail.com>
 <CAHk-=wgqW6zQcAW4i-ARJ8KNZZjw6tP3nn0QimyTWO=j+ZKsLA@mail.gmail.com>
 <YvYdbn2GtTlCaand@gmail.com>
 <20220815144143.zjsiamw5y22bvgki@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815144143.zjsiamw5y22bvgki@suse.de>
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> For the rest, I didn't see obvious recovery paths that would allow the 
> system to run predictably. Any of them firing will have unpredictable 
> consequences (e.g. move_queued_task firing would be fun if it was a 
> per-cpu kthread). Depending on which warning triggers, the remaining life 
> of the system may be very short but maybe long enough to be logged even 
> if system locks up shortly afterwards.

Correct. I'd prefer to keep all these warnings 'simple' - i.e. no attempted 
recovery & control flow, unless we ever expect these to trigger.

I.e. instead of adding a 'goto' I'd prefer if we removed most of the ones 
you highlighted. But wanted to keep this first patch simple.

Thanks,

	Ingo
