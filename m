Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1458B4B9B6E
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 09:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235672AbiBQIsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 03:48:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238037AbiBQIsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 03:48:46 -0500
Received: from ha.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 070CE2A2281;
        Thu, 17 Feb 2022 00:48:31 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by ha.nfschina.com (Postfix) with ESMTP id 71CB21E80D5E;
        Thu, 17 Feb 2022 16:44:05 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from ha.nfschina.com ([127.0.0.1])
        by localhost (ha.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TmbRzabDwoTH; Thu, 17 Feb 2022 16:44:03 +0800 (CST)
Received: from [172.30.12.152] (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by ha.nfschina.com (Postfix) with ESMTPA id D28F71E80CB5;
        Thu, 17 Feb 2022 16:44:02 +0800 (CST)
Subject: Re: [PATCH] mm: fix dereference a null pointer in
 migrate[_huge]_page_move_mapping()
To:     David Hildenbrand <david@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220217063808.42018-1-liqiong@nfschina.com>
 <Yg35UXjB7RpqVCOI@kroah.com>
 <d29fd91b-2043-0880-17ab-0ef7ec14bf62@redhat.com>
From:   =?UTF-8?B?5p2O5Yqb55C8?= <liqiong@nfschina.com>
Message-ID: <8f00ecbf-245d-f063-40a3-4aaa77680b73@nfschina.com>
Date:   Thu, 17 Feb 2022 16:48:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <d29fd91b-2043-0880-17ab-0ef7ec14bf62@redhat.com>
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

在 2022/2/17 下午3:51, David Hildenbrand 写道:
> On 17.02.22 08:29, Greg KH wrote:
>> On Thu, Feb 17, 2022 at 02:38:08PM +0800, liqiong wrote:
>>> Upstream has no this bug.
>> What do you mean by this?
>>
>> confused,
> Dito. If this is fixed upstream and broken in stable kernels, we'd want
> either a backport of the relevant upstream fix, or if too complicated, a
> stable-only fix.
>
>
There is a wrong describe， i thought 'Upstream' as the newest code.
The newest code has no this bug, i should submit this patch to "longterm:4.19".
How could i do it ?

Thanks.

