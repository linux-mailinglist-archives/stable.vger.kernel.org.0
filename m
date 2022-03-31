Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA914EE208
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 21:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240934AbiCaTo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 15:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240185AbiCaTo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 15:44:26 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EABF23F9F7
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 12:42:38 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id i11so492875plg.12
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 12:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=FLmyF/ADmt/SVOlekhuzZ5m0Y9Svgpyvb8XZ74qoiUI=;
        b=pD5w7XtghtGzZsLNW7+14BYv/55evR2ezIh8Iq4+xg6pZOAnWHAiX9ZRBAu0XS59Wf
         N74V4845Tv6DT+5Dm0o+pl3vuVQhHgw4cU5/HMOhaaoznrq5Hw2C32QqBfTAwa8MARTd
         ywo04mo3WS6B4A3l358e75e/CyMVVMxAEgCdCbsWZWfkJEVwqyWNWTnzCJh65WGHttNZ
         P3PDq6ZYQ7bvnFUniZ2NB67FbZmFgD95V8kqLwtvOyGU2Vtg2UAWl31CBNCyBZyOgaTM
         4J5tj9IrSs6JLK7mJiXkDy+g5HAlbFgO7fPSUUhfcS1SkngyOhlzj8LcWQMJNHsKluL+
         rrWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=FLmyF/ADmt/SVOlekhuzZ5m0Y9Svgpyvb8XZ74qoiUI=;
        b=dcqkS2odqf0h9DwJ3ZGaVtwCaMDd0XNB91a+CzdYJwhSpHMQpUmHOtRqL0LVGNq//f
         loczCiDHLsuwoOpuYBJhQbJCUzU27+fld7WIHHtSzfiAokLvdB1HaZxg2VfXMJD7f6el
         U2tNObb11uPynSDM8+NXd05/p6Z3E2MivA9O+os64mk83HO8FwdHMvhtSZXx4hlGBTxX
         310LPM2ymhXRquqfQU8EhScGAoG78StuQkXreJGwD9rlEfSP9gXW13oIHp9mOgX+PhYX
         nF9D+C2NNn4cE1owe6MJQMPDSZVbMIlAe12rHrf2QOe/Jl4Q7ET5MX2Mf0Amc+5a+Wt4
         pRWg==
X-Gm-Message-State: AOAM530nhHTFN7gEYr4CX6QY8Gx5+Sc2hj7z8xnaFzZdO09d9nTmlqqb
        hpAM1AfNISOnyWURIK9+FwMd5A==
X-Google-Smtp-Source: ABdhPJxaGZz1vhPYU1kLfpDIJMLn2dWkfNb3LGwg9IPLvlr/r2wlcOtYuaK9JMWEpE/iAoqv3DfpXQ==
X-Received: by 2002:a17:90b:2242:b0:1c6:80e3:71b6 with SMTP id hk2-20020a17090b224200b001c680e371b6mr7866471pjb.152.1648755757630;
        Thu, 31 Mar 2022 12:42:37 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id r8-20020a17090a0ac800b001c9e35d3a3asm155420pje.24.2022.03.31.12.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 12:42:36 -0700 (PDT)
Date:   Thu, 31 Mar 2022 12:42:36 -0700 (PDT)
X-Google-Original-Date: Thu, 31 Mar 2022 12:42:29 PDT (-0700)
Subject:     Re: [PATCH] riscv: fix build with binutils 2.38
In-Reply-To: <CAHk-=wjnuMD091mNbY=fRm-qFyhMjbtfiwkAFKyFehyR8bPB5A@mail.gmail.com>
CC:     mkl@pengutronix.de, aurelien@aurel32.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kito Cheng <kito.cheng@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org,
        linux-sparse@vger.kernel.org, ukl@pengutronix.de,
        luc.vanoostenryck@gmail.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <mhng-7e447636-2324-406b-9cfc-e5cf766b1737@palmer-mbp2014>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 31 Mar 2022 11:16:53 PDT (-0700), Linus Torvalds wrote:
> On Thu, Mar 31, 2022 at 3:51 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>>
>> Cc += linux-sparse, Uwe, Luc Van Oostenryck
>>
>> tl;dr:
>>
>> A recent change in the kernel regarding the riscv -march handling breaks
>> current sparse.

Sorry about that, looks like I'm not running sparse as part of my 
testing.  I'll add it, but it might take a bit as I'm assuming there 
will be a bunch of issues it points out.

> Gaah. Normally sparse doesn't even look at the -march flag, but for
> riscv it does, because it's meaningful for the predefined macros.
>
> Maybe that 'die()' shouldn't be so fatal. And maybe add a few more
> extensions (but ignore them) to the parsing.
>
> Something ENTIRELY UNTESTED like the attached.

Converting this to a warning seems reasonable to me, as then we're not 
as coupled to the sparse version.  The current crop of extensions don't 
set anything exciting for Linux, but there are some on the horizon that 
likely will -- hopefully having sparse in my test setup should be 
sufficient to dig those up, though.

As far as the new extension go: "Counters" isn't an ISA extension, and 
"e" defines "__riscv_32e".  It'd also be slightly saner to match on 
"_Zifencei", but that probably doesn't matter (GCC is sufficiently 
strict here).  Looks like there's also some oddities in the sparse ISA 
string parsing, I'll go clean them up as I get it running locally.

We could also stop relying on the compiler's defines, which would avoid 
this problem entirely, but IIRC that was discussed when decided to 
modify sparse in the first place and we went this way (though I don't 
remember why).  That would keep everything inside the kernel.
