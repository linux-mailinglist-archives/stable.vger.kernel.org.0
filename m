Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F45396BA5
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 04:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhFAC4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 22:56:06 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:13572 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232268AbhFAC4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 22:56:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UaoGXlt_1622516047;
Received: from B-455UMD6M-2027.local(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UaoGXlt_1622516047)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Jun 2021 10:54:08 +0800
Subject: Re: [PATCH] crypto: sm2 - fix a memory leak in sm2
To:     Hongbo Li <herbert.tencent@gmail.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, dhowells@redhat.com, jarkko@kernel.org,
        herberthbli@tencent.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1622467801-30957-1-git-send-email-herbert.tencent@gmail.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <91999e12-a7de-ad4b-72c4-2376ac682c92@linux.alibaba.com>
Date:   Tue, 1 Jun 2021 10:54:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1622467801-30957-1-git-send-email-herbert.tencent@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Hongbo,

On 5/31/21 9:30 PM, Hongbo Li wrote:
> From: Hongbo Li <herberthbli@tencent.com>
> 
> SM2 module alloc ec->Q in sm2_set_pub_key(), when doing alg test in
> test_akcipher_one(), it will set public key for every test vector,
> and don't free ec->Q. This will cause a memory leak.
> 
> This patch alloc ec->Q in sm2_ec_ctx_init().
> 
> Fixes: ea7ecb66440b ("crypto: sm2 - introduce OSCCA SM2 asymmetric cipher algorithm")
> Signed-off-by: Hongbo Li <herberthbli@tencent.com>
> Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>   crypto/sm2.c | 24 ++++++++++--------------
>   1 file changed, 10 insertions(+), 14 deletions(-)
> 

Just add Cc: to SOB, like this:

   Fixes: ea7ecb66440b (...)
   Signed-off-by: Hongbo Li <herberthbli@tencent.com>
   Cc: stable@vger.kernel.org # v5.10+
   Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

Thanks,
Tianjia
