Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F1F2E18D8
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 07:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgLWGUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 01:20:31 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:46978 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726069AbgLWGUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 01:20:31 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=liangyan.peng@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UJVvGLe_1608704385;
Received: from LiangyandeMacBook-Pro.local(mailfrom:liangyan.peng@linux.alibaba.com fp:SMTPD_---0UJVvGLe_1608704385)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 23 Dec 2020 14:19:46 +0800
Subject: Re: [PATCH v4] ovl: fix dentry leak in ovl_get_redirect
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        joseph.qi@linux.alibaba.com, stable@vger.kernel.org
References: <20201222030626.181165-1-liangyan.peng@linux.alibaba.com>
 <20201222032633.GS3579531@ZenIV.linux.org.uk>
From:   Liangyan <liangyan.peng@linux.alibaba.com>
Message-ID: <fb1dac63-34aa-b72f-e7f5-12703eba0578@linux.alibaba.com>
Date:   Wed, 23 Dec 2020 14:19:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201222032633.GS3579531@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Viro.

@Miklos, can you please advise?

On 20/12/22 上午11:26, Al Viro wrote:
> On Tue, Dec 22, 2020 at 11:06:26AM +0800, Liangyan wrote:
> 
>> Cc: <stable@vger.kernel.org>
>> Fixes: a6c606551141 ("ovl: redirect on rename-dir")
>> Signed-off-by: Liangyan <liangyan.peng@linux.alibaba.com>
>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Fine by me...  I can put it through vfs.git#fixes, but IMO
> that would be better off in overlayfs tree.
> 
