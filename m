Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B541F8C09
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 03:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgFOBTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jun 2020 21:19:05 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42246 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727969AbgFOBTF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Jun 2020 21:19:05 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 334B27D8576459A523DB;
        Mon, 15 Jun 2020 09:19:03 +0800 (CST)
Received: from [127.0.0.1] (10.166.213.7) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Mon, 15 Jun 2020
 09:19:01 +0800
Subject: Re: [PATCH] powerpc/fsl_booke/32: fix build with
 CONFIG_RANDOMIZE_BASE
To:     Arseny Solokha <asolokha@kb.kras.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        <linuxppc-dev@lists.ozlabs.org>
CC:     Scott Wood <oss@buserror.net>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20200613162801.1946619-1-asolokha@kb.kras.ru>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <48e8cd6c-9128-e8f0-6fd6-0f93b84629ca@huawei.com>
Date:   Mon, 15 Jun 2020 09:19:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200613162801.1946619-1-asolokha@kb.kras.ru>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.213.7]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


ÔÚ 2020/6/14 0:28, Arseny Solokha Ð´µÀ:
> Building the current 5.8 kernel for a e500 machine with
> CONFIG_RANDOMIZE_BASE set yields the following failure:
> 
>    arch/powerpc/mm/nohash/kaslr_booke.c: In function 'kaslr_early_init':
>    arch/powerpc/mm/nohash/kaslr_booke.c:387:2: error: implicit declaration
> of function 'flush_icache_range'; did you mean 'flush_tlb_range'?
> [-Werror=implicit-function-declaration]
> 
> Indeed, including asm/cacheflush.h into kaslr_booke.c fixes the build.
> 
> The issue dates back to the introduction of that file and probably went
> unnoticed because there's no in-tree defconfig with CONFIG_RANDOMIZE_BASE
> set.
> 
> Fixes: 2b0e86cc5de6 ("powerpc/fsl_booke/32: implement KASLR infrastructure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
> ---
>   arch/powerpc/mm/nohash/kaslr_booke.c | 1 +
>   1 file changed, 1 insertion(+)
> 

Reviewed-by: Jason Yan <yanaijie@huawei.com>

