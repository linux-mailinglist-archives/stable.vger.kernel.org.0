Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3106C4B9B49
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 09:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237874AbiBQIjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 03:39:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237871AbiBQIjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 03:39:51 -0500
Received: from ha.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 184CF1FFC82;
        Thu, 17 Feb 2022 00:39:36 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by ha.nfschina.com (Postfix) with ESMTP id F0D841E80D5E;
        Thu, 17 Feb 2022 16:35:10 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from ha.nfschina.com ([127.0.0.1])
        by localhost (ha.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9jyA9AroTJe0; Thu, 17 Feb 2022 16:35:08 +0800 (CST)
Received: from [172.30.12.152] (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by ha.nfschina.com (Postfix) with ESMTPA id 784B81E80CB5;
        Thu, 17 Feb 2022 16:35:08 +0800 (CST)
Subject: Re: [PATCH] mm: fix dereference a null pointer in
 migrate[_huge]_page_move_mapping()
From:   =?UTF-8?B?5p2O5Yqb55C8?= <liqiong@nfschina.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220217063808.42018-1-liqiong@nfschina.com>
 <Yg35UXjB7RpqVCOI@kroah.com>
 <64157952-22d7-b21b-1b08-c784b8eed1fe@nfschina.com>
Message-ID: <5ee3d92e-99e4-38ce-aee6-66258398f579@nfschina.com>
Date:   Thu, 17 Feb 2022 16:39:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <64157952-22d7-b21b-1b08-c784b8eed1fe@nfschina.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RDNS_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Gerg,

Sorry, i may understand your confusion.
I thought 'Upstream' as the newest code, so, I said 'Upstream has no this bug'.

Yes, we found this bug on 'Upstream v4.19.191'.

How could i submit this patch to 'longterm: 4.19'.

Thanks.

**

在 2022/2/17 下午3:59, 李力琼 写道:
> Hi Greg,
>
> Upstream replaces migrate_page_move_mapping() with 
> folio_migrate_mapping(),
> does not use radix tree any more. So, the upstream don't have the null
> pointer bug.
>
> We found and fix this bug on '4.19.191'.
>
> 在 2022/2/17 下午3:29, Greg KH 写道:
>> On Thu, Feb 17, 2022 at 02:38:08PM +0800, liqiong wrote:
>>> Upstream has no this bug.
>> What do you mean by this?
>>
>> confused,
>>
>> greg k-h
