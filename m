Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF46454EEBC
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 03:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbiFQBYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 21:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiFQBYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 21:24:49 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6C515A1C;
        Thu, 16 Jun 2022 18:24:48 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VGcIT1O_1655429084;
Received: from B-LB6YLVDL-0141.local(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0VGcIT1O_1655429084)
          by smtp.aliyun-inc.com;
          Fri, 17 Jun 2022 09:24:46 +0800
Subject: Re: [PATCH] mm: page_alloc: validate buddy page before using
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, ziy@nvidia.com, stable@vger.kernel.org,
        guoren@kernel.org, huanyi.xj@alibaba-inc.com, guohanjun@huawei.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20220616161746.3565225-1-xianting.tian@linux.alibaba.com>
 <b08725b1-2f4b-cea0-43fc-1ce0a2a7e8f4@linux.alibaba.com>
 <YqtfTavoMNxQeFlg@kroah.com>
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
Message-ID: <7c52a1f2-b2c6-44d5-6c38-acad6088bbda@linux.alibaba.com>
Date:   Fri, 17 Jun 2022 09:24:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YqtfTavoMNxQeFlg@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-12.5 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry for the misleading, I mean just this one in the series, not the 
whole series, actually this patch is for 4.9, But I forget the add the 
Label 4.9.

So I send the patch for 4.9 again in

https://lkml.org/lkml/2022/6/16/782 <https://lkml.org/lkml/2022/6/16/782>

在 2022/6/17 上午12:50, Greg KH 写道:
> On Fri, Jun 17, 2022 at 12:20:19AM +0800, Xianting Tian wrote:
>> Sorry, please ignore this one.
> Which "one"?  This was a series :(
