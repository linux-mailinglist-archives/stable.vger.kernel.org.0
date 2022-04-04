Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3A54F157B
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 15:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbiDDNIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 09:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350725AbiDDNIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 09:08:10 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5D3FC1
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 06:06:13 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id l14so5082240ybe.4
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 06:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Pz18IJpl3w5Y1XoWgzEqbRbukEktXr4RhLO4P7cpCLw=;
        b=W+twQQ/g5kLLlVO3Pv5CnrnLYaCCLqN3g+TZ/8JqU9tpSVno+UeqjHynSqnf7Oz5qR
         e1vWXOHaH2vY2Iymsh/p2iyYznaYdHzMhWGzRBPZEtoBkAaDJ5hQ2BU5LogDO/pbgAqH
         kXzsU+2B+ESeipNg3Aivn7ANAssFNbL9b+kWSHLyQM3HvaCZ9EeaghWmtIBaR89QGUCn
         iuqbtdWiCCpNGSIm57gjlvqWhgAF+VJ/SZzkV3uLxyfcNAmin/Gx6iJVwE/zOvgmSzyj
         +hQB++qYC+3xZeuZE1/zQC+AfpmcW6cXU6VcY2wzUDyCBmV0G9cxh3jz+z4wUUxPydvW
         KvQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Pz18IJpl3w5Y1XoWgzEqbRbukEktXr4RhLO4P7cpCLw=;
        b=3J0Wdyy41z3PDmHu0Dmyz/fWw58MTRbtMfnX28DJr+hoawNo9Fvn5lv6aipF4uqb9c
         SXDgdrE0LUnZwDf5+cHbTNOYI1twNxIyc/2lcLtHAoqigJtABFuBLY2O9o0ER7nr8jko
         5ysy04Cu1qZ6cHGx8f/RyYhYFcyvomchGVWZdF9ews7GgkxoGvbppA0zmCWkv8JyggdH
         QqG9aLvOs1xDo1kpbb2f1WTSujT6zvoJJI7P0OShdjIQKVF6WWCd46xvI6LcPuFPxRH6
         +iTxpjljuCbgLYDaE9S8H77M32g+QQpe67aloRzO/gq1zMyta4UkBmqKJFQYBW84uwgL
         33hw==
X-Gm-Message-State: AOAM532EQ5U25NwiPS6T05Wa0D6KOSc5xZmata2TibmXnKK9QndnANcb
        +Ks+91h6LiclWUmHfpb04YtGnvCFRFslsN0cYOL5RQ==
X-Google-Smtp-Source: ABdhPJwUl/bfPDj16KsxzbRPCxwpfiJJbPLGaR9jtUfnYU7XsYKodoKbEtLt5WbRMB7fRQpt+JHqI3VL7ALLR3CJFlE=
X-Received: by 2002:a25:d14e:0:b0:63d:b1e2:a86d with SMTP id
 i75-20020a25d14e000000b0063db1e2a86dmr7507109ybg.603.1649077573002; Mon, 04
 Apr 2022 06:06:13 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 4 Apr 2022 18:36:01 +0530
Message-ID: <CA+G9fYty-Vjznwm6=x3fQystvRoYODKaM_kWrJZmjM8vsA6gFw@mail.gmail.com>
Subject: stable-rc: 5.4: blk-mq.h:62:33: error: field 'kobj' has incomplete type
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Linux stable-rc 5.4 branch build breaks on all architecture for allnoconfig.

metadata:
    git_describe: v5.4.188-369-ga60d79f382c9
    git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
    git_sha: a60d79f382c91dcb19578178a5032af6ccbf4c89
    kconfig:allnoconfig
    kernel_version: 5.4.189-rc1
    target_arch: x86_64
    toolchain: gcc-11

In file included from include/linux/blk-cgroup.h:25,
                 from include/linux/writeback.h:14,
                 from include/linux/memcontrol.h:22,
                 from include/linux/swap.h:9,
                 from include/linux/suspend.h:5,
                 from arch/x86/kernel/asm-offsets.c:13:
include/linux/blk-mq.h:62:33: error: field 'kobj' has incomplete type
   62 |         struct kobject          kobj;
      |                                 ^~~~
include/linux/blk-mq.h: In function 'blk_mq_rq_from_pdu':
include/linux/blk-mq.h:352:29: error: invalid application of 'sizeof'
to incomplete type 'struct request'
  352 |         return pdu - sizeof(struct request);
      |                             ^~~~~~
include/linux/blk-mq.h: In function 'blk_mq_rq_to_pdu':
include/linux/blk-mq.h:356:19: error: invalid use of undefined type
'struct request'
  356 |         return rq + 1;
      |                   ^
include/linux/blk-mq.h: In function 'request_to_qc_t':
include/linux/blk-mq.h:370:15: error: invalid use of undefined type
'struct request'
  370 |         if (rq->tag != -1)
      |               ^~
include/linux/blk-mq.h:371:26: error: invalid use of undefined type
'struct request'
  371 |                 return rq->tag | (hctx->queue_num << BLK_QC_T_SHIFT);
      |                          ^~
include/linux/blk-mq.h:373:18: error: invalid use of undefined type
'struct request'
  373 |         return rq->internal_tag | (hctx->queue_num << BLK_QC_T_SHIFT) |
      |                  ^~
include/linux/blk-mq.h: In function 'blk_mq_cleanup_rq':
include/linux/blk-mq.h:379:15: error: invalid use of undefined type
'struct request'
  379 |         if (rq->q->mq_ops->cleanup_rq)
      |               ^~
include/linux/blk-mq.h:380:19: error: invalid use of undefined type
'struct request'
  380 |                 rq->q->mq_ops->cleanup_rq(rq);
      |                   ^~
make[2]: *** [scripts/Makefile.build:99: arch/x86/kernel/asm-offsets.s] Error 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org

[1] https://builds.tuxbuild.com/27KejBvVC9gRN1Yk21Nqn51Ptv6/
