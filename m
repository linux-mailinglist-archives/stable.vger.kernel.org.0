Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637A4460350
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 03:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348023AbhK1C7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 21:59:52 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:56844 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355100AbhK1C5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 21:57:51 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=yang.wei@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UyVbI59_1638068072;
Received: from B-N4MVMD6P-2042.local(mailfrom:yang.wei@linux.alibaba.com fp:SMTPD_---0UyVbI59_1638068072)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 28 Nov 2021 10:54:33 +0800
Subject: Re: [PATCH 4.19] x86/mm: add cond_resched() in _set_memory_array()
 and set_memory_array_wb()
To:     Dave Hansen <dave.hansen@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Yang Wei <albin.yangwei@alibaba-inc.com>
Cc:     dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        stable@vger.kernel.org
References: <1637911946-67009-1-git-send-email-albin.yangwei@alibaba-inc.com>
 <YaENEIbE8hA1h19/@kroah.com>
 <9c415df9-9575-8217-03e9-a6bbf20a491a@linux.alibaba.com>
 <90306161-6810-6f54-5ac6-1c974602f963@intel.com>
From:   YangWei <yang.wei@linux.alibaba.com>
Message-ID: <7735c857-d456-0b1c-00f1-0df67fc3aef3@linux.alibaba.com>
Date:   Sun, 28 Nov 2021 10:54:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <90306161-6810-6f54-5ac6-1c974602f963@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


在 2021/11/28 02:09, Dave Hansen 写道:
> On 11/27/21 8:25 AM, YangWei wrote:
>> We found that the nvidia driver calling
>> nv_alloc_system_pages()/nv_free_system_pages()
> Is that the proprietary nvidia driver?

Nvidia display driver 460.73.01. Since there is no source code, we 
cannot modify and recompile the driver. I think the kernel interface 
set_memory_array_wb()/set_memory_array_xx() should be adapted to any 
parameter input.


