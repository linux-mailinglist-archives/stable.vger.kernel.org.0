Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E509A327A17
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 09:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhCAIyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 03:54:53 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:45861 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233717AbhCAIxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 03:53:02 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tao.peng@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UPwsqrR_1614588724;
Received: from graymalkin.local(mailfrom:tao.peng@linux.alibaba.com fp:SMTPD_---0UPwsqrR_1614588724)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Mar 2021 16:52:05 +0800
Subject: Re: [PATCH CK 4.19 1/4] fuse: fix page dereference after free
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     alikernel-developer@linux.alibaba.com,
        Liu Bo <bo.liu@linux.alibaba.com>,
        Ma Jie Yue <majieyue@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Eryu Guan <eguan@linux.alibaba.com>,
        Miklos Szeredi <mszeredi@redhat.com>, stable@vger.kernel.org
References: <1614569779-12114-1-git-send-email-tao.peng@linux.alibaba.com>
 <1614569779-12114-2-git-send-email-tao.peng@linux.alibaba.com>
 <YDygOH7MGVOAYk+H@kroah.com>
From:   Peng Tao <tao.peng@linux.alibaba.com>
Message-ID: <c9807ed1-dcaa-4e9f-476e-4bcedf0745c4@linux.alibaba.com>
Date:   Mon, 1 Mar 2021 16:52:03 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <YDygOH7MGVOAYk+H@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2021/3/1 16:05, Greg Kroah-Hartman wrote:
> On Mon, Mar 01, 2021 at 11:36:16AM +0800, Peng Tao wrote:
>> From: Miklos Szeredi <mszeredi@redhat.com>
>>
>> commit d78092e4937de9ce55edcb4ee4c5e3c707be0190 upstream.
>>
>> fix #32833505
> 
> What does this mean?
> 
> And why are you all backporting random stable kernel patches to your
> tree and not just taking all of them with a simple merge?
> 
> By selectivly cherry-picking patches like this, you are guaranteed to be
> doing more work, and have a much more insecure and buggy kernel.  The
> opposite of what your end goal should be, correct?
> 

Hi Greg,

My apology for the noise. It was due to a mistake in my git config. And 
thanks for your suggestions. Our tree is actually a mixture of stable 
backports and feature backports. I guess that's why the cherry-picking 
method was chosen, since a simple merge creates too many conflicts and 
it is error prone to fix them in one shoot.

Cheers,
Tao
