Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BAF1F6698
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 13:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgFKL14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 07:27:56 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:62008 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgFKL14 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 07:27:56 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 49jM6H46wHz9tyFm;
        Thu, 11 Jun 2020 13:27:51 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 5rh-Lhaxt5l9; Thu, 11 Jun 2020 13:27:51 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 49jM6H3D0Dz9tyFk;
        Thu, 11 Jun 2020 13:27:51 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 34A708B851;
        Thu, 11 Jun 2020 13:27:53 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id K--oBiCbpyzy; Thu, 11 Jun 2020 13:27:53 +0200 (CEST)
Received: from [10.25.210.22] (po15451.idsi0.si.c-s.fr [10.25.210.22])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id EE2868B850;
        Thu, 11 Jun 2020 13:27:52 +0200 (CEST)
Subject: Re: Patch "crypto: talitos - fix ECB and CBC algs ivsize" has been
 added to the 4.9-stable tree
To:     gregkh@linuxfoundation.org, cantona@cantona.net,
        stable@vger.kernel.org, davem@davemloft.net,
        herbert@gondor.apana.org.au
Cc:     stable-commits@vger.kernel.org
References: <1591874497241120@kroah.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <b639a842-5654-d719-d28c-9791f8f9cbac@csgroup.eu>
Date:   Thu, 11 Jun 2020 13:27:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1591874497241120@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 11/06/2020 à 13:21, gregkh@linuxfoundation.org a écrit :
> 
> This is a note to let you know that I've just added the patch titled
> 
>      crypto: talitos - fix ECB and CBC algs ivsize
> 
> to the 4.9-stable tree which can be found at:
>      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>       crypto-talitos-fix-ecb-and-cbc-algs-ivsize.patch
> and it can be found in the queue-4.9 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

As far as I can see, the faulty commit e1de42fdfc6a ("crypto: talitos - 
fix ECB algs ivsize") only removed .ivsize = AES_BLOCK_SIZE at a wrong 
place.

The other changes (removal of .ivsize = DES_BLOCK_SIZE and .ivsize = 
DES3_EDE_BLOCK_SIZE) are not from the faulty patch.

Christophe

> 
> 
>  From cantona@cantona.net  Thu Jun 11 12:53:25 2020
> From: Su Kang Yin <cantona@cantona.net>
> Date: Thu, 11 Jun 2020 18:07:45 +0800
> Subject: crypto: talitos - fix ECB and CBC algs ivsize
> To: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org, christophe.leroy@c-s.fr
> Cc: Su Kang Yin <cantona@cantona.net>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
> Message-ID: <20200611100745.6513-1-cantona@cantona.net>
> 
> From: Su Kang Yin <cantona@cantona.net>
> 
> Patch for 4.9 upstream:
> 
> commit e1de42fdfc6a ("crypto: talitos - fix ECB algs ivsize")
> wrongly modified CBC algs ivsize instead of ECB aggs ivsize.
> 
> This restore the CBC algs original ivsize of removes ECB's ones.
> 
> Signed-off-by: Su Kang Yin <cantona@cantona.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/crypto/talitos.c |    4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -2636,7 +2636,6 @@ static struct talitos_alg_template drive
>   			.cra_ablkcipher = {
>   				.min_keysize = AES_MIN_KEY_SIZE,
>   				.max_keysize = AES_MAX_KEY_SIZE,
> -				.ivsize = AES_BLOCK_SIZE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -2670,6 +2669,7 @@ static struct talitos_alg_template drive
>   			.cra_ablkcipher = {
>   				.min_keysize = AES_MIN_KEY_SIZE,
>   				.max_keysize = AES_MAX_KEY_SIZE,
> +				.ivsize = AES_BLOCK_SIZE,
>   				.setkey = ablkcipher_aes_setkey,
>   			}
>   		},
> @@ -2687,7 +2687,6 @@ static struct talitos_alg_template drive
>   			.cra_ablkcipher = {
>   				.min_keysize = DES_KEY_SIZE,
>   				.max_keysize = DES_KEY_SIZE,
> -				.ivsize = DES_BLOCK_SIZE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -2720,7 +2719,6 @@ static struct talitos_alg_template drive
>   			.cra_ablkcipher = {
>   				.min_keysize = DES3_EDE_KEY_SIZE,
>   				.max_keysize = DES3_EDE_KEY_SIZE,
> -				.ivsize = DES3_EDE_BLOCK_SIZE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> 
> 
> Patches currently in stable-queue which might be from cantona@cantona.net are
> 
> queue-4.9/crypto-talitos-fix-ecb-and-cbc-algs-ivsize.patch
> 
