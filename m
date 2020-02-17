Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D681607ED
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 03:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgBQCLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Feb 2020 21:11:46 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10624 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726251AbgBQCLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 Feb 2020 21:11:46 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BB6A29D15348A178E034;
        Mon, 17 Feb 2020 10:11:24 +0800 (CST)
Received: from [127.0.0.1] (10.133.205.80) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 17 Feb 2020
 10:11:23 +0800
Subject: Re: [PATCH for 4.19-stable] padata: fix null pointer deref of
 pd->pinst
To:     Sasha Levin <sashal@kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>
References: <20200214182821.337706-1-daniel.m.jordan@oracle.com>
 <20200215150118.B22262084E@mail.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <5E49F64A.2070904@huawei.com>
Date:   Mon, 17 Feb 2020 10:11:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20200215150118.B22262084E@mail.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.133.205.80]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,


On 2020/2/15 23:01, Sasha Levin wrote:
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: dc34710a7aba ("padata: Remove broken queue flushing").
>
> The bot has tested the following trees: v5.5.3, v5.4.19, v4.19.103.
>
> v5.5.3: Build failed! Errors:
>      kernel/padata.c:460:4: error: ‘struct parallel_data’ has no member named ‘pinst’
>
> v5.4.19: Build failed! Errors:
>      kernel/padata.c:460:4: error: ‘struct parallel_data’ has no member named ‘pinst’
>
> v4.19.103: Build OK!
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
The commit bbefa1dd6a6d ("crypto: pcrypt - Avoid deadlock by using 
per-instance padata queues") that merged
on linux-5.4.y and linux-5.5.y changes struct parallel_data, so this 
patch it's only needed on linux-4.19.y.
>


