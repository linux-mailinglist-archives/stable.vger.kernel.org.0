Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD6447D190
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 13:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhLVMQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 07:16:20 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:50977 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233608AbhLVMQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 07:16:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V.QmW12_1640175377;
Received: from 30.225.24.37(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0V.QmW12_1640175377)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 22 Dec 2021 20:16:18 +0800
Message-ID: <bf6777e2-4c87-44ec-10bb-83ae1a69f255@linux.alibaba.com>
Date:   Wed, 22 Dec 2021 20:16:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: FAILED: patch "[PATCH] netfs: fix parameter of cleanup()" failed
 to apply to 5.15-stable tree
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>
Cc:     jlayton@redhat.com, stable@vger.kernel.org
References: <163913443334205@kroah.com>
 <292330.1639150575@warthog.procyon.org.uk> <YcMWTgAEslW1Vg57@kroah.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
In-Reply-To: <YcMWTgAEslW1Vg57@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/22/21 8:13 PM, Greg KH wrote:
> On Fri, Dec 10, 2021 at 03:36:15PM +0000, David Howells wrote:
>> <gregkh@linuxfoundation.org> wrote:
>>
>>> -			ops->cleanup(netfs_priv, folio_file_mapping(folio));
>>> +			ops->cleanup(folio_file_mapping(folio), netfs_priv);
>>
>> Is it page->mapping or page_mapping(page) instead of folio_file_mapping()?  If
>> so, you can switch that to the other side instead, e.g.:
>>
>> -			ops->cleanup(netfs_priv, page_mapping(page));
>> +			ops->cleanup(page_mapping(page), netfs_priv);
>>
>> David
>>
> 
> Ok, can you or someone send me a fixed up patch like this so that I can
> apply it?
> 

OK I will send a new version later. Thanks David for the suggestion.

-- 
Thanks,
Jeffle
