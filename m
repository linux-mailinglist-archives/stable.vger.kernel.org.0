Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723D157F85E
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 04:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiGYCxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jul 2022 22:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiGYCxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jul 2022 22:53:46 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8937DFBC;
        Sun, 24 Jul 2022 19:53:44 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=dtcccc@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VKG9avC_1658717621;
Received: from 30.97.49.20(mailfrom:dtcccc@linux.alibaba.com fp:SMTPD_---0VKG9avC_1658717621)
          by smtp.aliyun-inc.com;
          Mon, 25 Jul 2022 10:53:42 +0800
Message-ID: <6258c4a1-0132-5afe-8dab-afa4ca3c49d6@linux.alibaba.com>
Date:   Mon, 25 Jul 2022 10:53:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
To:     gregkh@linuxfoundation.org
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org, lmb@cloudflare.com,
        sashal@kernel.org, stable@vger.kernel.org
References: <20211115165356.685521944@linuxfoundation.org>
Subject: Re: [PATCH 5.10 373/575] selftests: bpf: Convert sk_lookup ctx access
 tests to PROG_TEST_RUN
Content-Language: en-US
From:   Tianchen Ding <dtcccc@linux.alibaba.com>
In-Reply-To: <20211115165356.685521944@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg.

We found a compile error when building tools/testing/selftests/bpf/ on 5.10.

tools/testing/selftests/bpf/prog_tests/sk_lookup.c:1092:15: error: 'struct bpf_sk_lookup' has no member named 'cookie'
  1092 |  if (CHECK(ctx.cookie == 0, "ctx.cookie", "no socket selected\n"))

It requires 7c32e8f8bc33 ("bpf: Add PROG_TEST_RUN support for sk_lookup programs") from upstream.

Maybe the left patches of this patchset are needed for 5.10 LTS?
https://lore.kernel.org/bpf/20210303101816.36774-1-lmb@cloudflare.com/

Thanks.
