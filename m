Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512065658A6
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 16:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbiGDOaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 10:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiGDOaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 10:30:08 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306E42A7
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 07:30:04 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VIO43Eh_1656944998;
Received: from 30.39.89.24(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0VIO43Eh_1656944998)
          by smtp.aliyun-inc.com;
          Mon, 04 Jul 2022 22:30:00 +0800
Message-ID: <a3b54463-2a4b-d244-9c3a-b26ddda734e2@linux.alibaba.com>
Date:   Mon, 4 Jul 2022 22:29:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH 4.19] x86/mm/cpa: Unconditionally avoid WBINDV when we can
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Bin Yang <bin.yang@intel.com>,
        Mark Gross <mark.gross@intel.com>, stable@vger.kernel.org
References: <20220704082817.4596-1-wenyang@linux.alibaba.com>
 <YsLJiSZ0mCCEckR2@kroah.com>
From:   Wen Yang <wenyang@linux.alibaba.com>
In-Reply-To: <YsLJiSZ0mCCEckR2@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2022/7/4 下午7:05, Greg Kroah-Hartman 写道:
> On Mon, Jul 04, 2022 at 04:28:17PM +0800, Wen Yang wrote:
>> From: Peter Zijlstra <peterz@infradead.org>
>>
>> commit ab3e9c0b75dcb13e9254ef68caa7f15bc66b6471 upstream.
> 
> This commit id is not in Linus's tree :(


Sorry, accidentally added the internal id.

It is this commit id in Linus' tree:
ddd07b750382adc2b78fdfbec47af8a6e0d8ef37

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ddd07b750382adc2b78fdfbec47af8a6e0d8ef37


--
Best wishes,
Wen
