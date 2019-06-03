Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4462032610
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 03:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfFCBZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Jun 2019 21:25:54 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39230 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfFCBZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Jun 2019 21:25:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id j2so9606583pfe.6
        for <stable@vger.kernel.org>; Sun, 02 Jun 2019 18:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=JzUdo3fmPOXMInLK5aYh7b7p036NOMuq6m8d15Ir4ZE=;
        b=pytWj0ikn6CEtfS1lZR5QH0fkJMCxlEmV9xI95xhxX663KRA7mpknlTAQgP68Dr/6v
         h/2oQcWN98nlIDgVfbj4os/7XPBaJ5mF/4Yp6etIlGX7hsyNTf+8BwZ5Ky2iyYRp1kGe
         9EROCrgFDjTEtGNqrx3G4YsMA2+6iZuaFEb6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=JzUdo3fmPOXMInLK5aYh7b7p036NOMuq6m8d15Ir4ZE=;
        b=jFAsRGgpp+aYQMoHujQq7DkNKiLylI8iG04rdWV/Z3g9n7NYUge6gY58PEDwQyUEbd
         gV25zwBpkQkvdlPYKbj6JwKsss9Y4zUZjPYZm2YRS6ubiXku1iXfrolF3IXy+grSTMkX
         cdg7OdPRXl0uRnFUPwwf4JfoIJklDIib9O2oz2gcXJ0CwXPKAVUkPnnVxwMxGN9zQb3l
         jDbGRXk68e90M8GtahFiDudfuHrpVSsoAKEVaPRTm13eliLSabDe7yteJqh/9XY4gETz
         fVp1/aNAWtFPsCSYsIrBXNz3SilojR9NJIzBQdMHplOLETxdKYFb7edgdmK9BfAO/zuj
         eYkw==
X-Gm-Message-State: APjAAAUR7Hixw9et8pMeQR40Po4EboW9I/Zh+/5H5FHyPZysa9+CoLy5
        cTqh7bgIM4XzTCuh4JTBDHloALGMh44=
X-Google-Smtp-Source: APXvYqwrOpqykx7M8dSTRn1RupYJQOHGQCOP+ZCf17EPS5C8K+9pt6Lyha43CtRU/CEau9ntf9UzxQ==
X-Received: by 2002:aa7:8d10:: with SMTP id j16mr13865871pfe.204.1559525153408;
        Sun, 02 Jun 2019 18:25:53 -0700 (PDT)
Received: from localhost (ppp167-251-205.static.internode.on.net. [59.167.251.205])
        by smtp.gmail.com with ESMTPSA id g71sm19737980pgc.41.2019.06.02.18.25.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 02 Jun 2019 18:25:52 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH BACKPORT 4.19, 5.0, 5.1] crypto: vmx - ghash: do nosimd fallback manually
In-Reply-To: <20190531103644.Horde.1vLZxotmT6VbaFiL0yODKQ7@messagerie.si.c-s.fr>
References: <20190531103644.Horde.1vLZxotmT6VbaFiL0yODKQ7@messagerie.si.c-s.fr>
Date:   Mon, 03 Jun 2019 11:25:48 +1000
Message-ID: <874l57zcgz.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Christophe Leroy <christophe.leroy@c-s.fr> writes:

> Daniel Axtens <dja@axtens.net> a =C3=A9crit=C2=A0:
>
> Hi
>
> I think you have to mention the upstream commit Id when submitting a=20=20
> patch to stable, see=20=20=20
> https://elixir.bootlin.com/linux/v5.2-rc1/source/Documentation/process/st=
able-kernel-rules.rst

Argh, right, sorry, still in Canonical Stable Release Update mode:
>> (backported from commit 357d065a44cdd77ed5ff35155a989f2a763e96ef)

I'll do a backport v2 with the correct format.

Regards,
Daniel

>
> Christophe
>
>> VMX ghash was using a fallback that did not support interleaving simd
>> and nosimd operations, leading to failures in the extended test suite.
>>
>> If I understood correctly, Eric's suggestion was to use the same
>> data format that the generic code uses, allowing us to call into it
>> with the same contexts. I wasn't able to get that to work - I think
>> there's a very different key structure and data layout being used.
>>
>> So instead steal the arm64 approach and perform the fallback
>> operations directly if required.
>>
>> Fixes: cc333cd68dfa ("crypto: vmx - Adding GHASH routines for VMX module=
")
>> Cc: stable@vger.kernel.org # v4.1+
>> Reported-by: Eric Biggers <ebiggers@google.com>
>> Signed-off-by: Daniel Axtens <dja@axtens.net>
>> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Tested-by: Michael Ellerman <mpe@ellerman.id.au>
>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

>> Signed-off-by: Daniel Axtens <dja@axtens.net>
>> ---
>>  drivers/crypto/vmx/ghash.c | 212 +++++++++++++++----------------------
>>  1 file changed, 86 insertions(+), 126 deletions(-)
>>
>> diff --git a/drivers/crypto/vmx/ghash.c b/drivers/crypto/vmx/ghash.c
>> index dd8b8716467a..2d1a8cd35509 100644
>> --- a/drivers/crypto/vmx/ghash.c
>> +++ b/drivers/crypto/vmx/ghash.c
>> @@ -1,22 +1,14 @@
>> +// SPDX-License-Identifier: GPL-2.0
>>  /**
>>   * GHASH routines supporting VMX instructions on the Power 8
>>   *
>> - * Copyright (C) 2015 International Business Machines Inc.
>> - *
>> - * This program is free software; you can redistribute it and/or modify
>> - * it under the terms of the GNU General Public License as published by
>> - * the Free Software Foundation; version 2 only.
>> - *
>> - * This program is distributed in the hope that it will be useful,
>> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> - * GNU General Public License for more details.
>> - *
>> - * You should have received a copy of the GNU General Public License
>> - * along with this program; if not, write to the Free Software
>> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>> + * Copyright (C) 2015, 2019 International Business Machines Inc.
>>   *
>>   * Author: Marcelo Henrique Cerri <mhcerri@br.ibm.com>
>> + *
>> + * Extended by Daniel Axtens <dja@axtens.net> to replace the fallback
>> + * mechanism. The new approach is based on arm64 code, which is:
>> + *   Copyright (C) 2014 - 2018 Linaro Ltd. <ard.biesheuvel@linaro.org>
>>   */
>>
>>  #include <linux/types.h>
>> @@ -39,71 +31,25 @@ void gcm_ghash_p8(u64 Xi[2], const u128 htable[16],
>>  		  const u8 *in, size_t len);
>>
>>  struct p8_ghash_ctx {
>> +	/* key used by vector asm */
>>  	u128 htable[16];
>> -	struct crypto_shash *fallback;
>> +	/* key used by software fallback */
>> +	be128 key;
>>  };
>>
>>  struct p8_ghash_desc_ctx {
>>  	u64 shash[2];
>>  	u8 buffer[GHASH_DIGEST_SIZE];
>>  	int bytes;
>> -	struct shash_desc fallback_desc;
>>  };
>>
>> -static int p8_ghash_init_tfm(struct crypto_tfm *tfm)
>> -{
>> -	const char *alg =3D "ghash-generic";
>> -	struct crypto_shash *fallback;
>> -	struct crypto_shash *shash_tfm =3D __crypto_shash_cast(tfm);
>> -	struct p8_ghash_ctx *ctx =3D crypto_tfm_ctx(tfm);
>> -
>> -	fallback =3D crypto_alloc_shash(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
>> -	if (IS_ERR(fallback)) {
>> -		printk(KERN_ERR
>> -		       "Failed to allocate transformation for '%s': %ld\n",
>> -		       alg, PTR_ERR(fallback));
>> -		return PTR_ERR(fallback);
>> -	}
>> -
>> -	crypto_shash_set_flags(fallback,
>> -			       crypto_shash_get_flags((struct crypto_shash
>> -						       *) tfm));
>> -
>> -	/* Check if the descsize defined in the algorithm is still enough. */
>> -	if (shash_tfm->descsize < sizeof(struct p8_ghash_desc_ctx)
>> -	    + crypto_shash_descsize(fallback)) {
>> -		printk(KERN_ERR
>> -		       "Desc size of the fallback implementation (%s) does not=20=20
>> match the expected value: %lu vs %u\n",
>> -		       alg,
>> -		       shash_tfm->descsize - sizeof(struct p8_ghash_desc_ctx),
>> -		       crypto_shash_descsize(fallback));
>> -		return -EINVAL;
>> -	}
>> -	ctx->fallback =3D fallback;
>> -
>> -	return 0;
>> -}
>> -
>> -static void p8_ghash_exit_tfm(struct crypto_tfm *tfm)
>> -{
>> -	struct p8_ghash_ctx *ctx =3D crypto_tfm_ctx(tfm);
>> -
>> -	if (ctx->fallback) {
>> -		crypto_free_shash(ctx->fallback);
>> -		ctx->fallback =3D NULL;
>> -	}
>> -}
>> -
>>  static int p8_ghash_init(struct shash_desc *desc)
>>  {
>> -	struct p8_ghash_ctx *ctx =3D crypto_tfm_ctx(crypto_shash_tfm(desc->tfm=
));
>>  	struct p8_ghash_desc_ctx *dctx =3D shash_desc_ctx(desc);
>>
>>  	dctx->bytes =3D 0;
>>  	memset(dctx->shash, 0, GHASH_DIGEST_SIZE);
>> -	dctx->fallback_desc.tfm =3D ctx->fallback;
>> -	dctx->fallback_desc.flags =3D desc->flags;
>> -	return crypto_shash_init(&dctx->fallback_desc);
>> +	return 0;
>>  }
>>
>>  static int p8_ghash_setkey(struct crypto_shash *tfm, const u8 *key,
>> @@ -121,7 +67,51 @@ static int p8_ghash_setkey(struct crypto_shash=20=20
>> *tfm, const u8 *key,
>>  	disable_kernel_vsx();
>>  	pagefault_enable();
>>  	preempt_enable();
>> -	return crypto_shash_setkey(ctx->fallback, key, keylen);
>> +
>> +	memcpy(&ctx->key, key, GHASH_BLOCK_SIZE);
>> +
>> +	return 0;
>> +}
>> +
>> +static inline void __ghash_block(struct p8_ghash_ctx *ctx,
>> +				 struct p8_ghash_desc_ctx *dctx)
>> +{
>> +	if (!IN_INTERRUPT) {
>> +		preempt_disable();
>> +		pagefault_disable();
>> +		enable_kernel_vsx();
>> +		gcm_ghash_p8(dctx->shash, ctx->htable,
>> +				dctx->buffer, GHASH_DIGEST_SIZE);
>> +		disable_kernel_vsx();
>> +		pagefault_enable();
>> +		preempt_enable();
>> +	} else {
>> +		crypto_xor((u8 *)dctx->shash, dctx->buffer, GHASH_BLOCK_SIZE);
>> +		gf128mul_lle((be128 *)dctx->shash, &ctx->key);
>> +	}
>> +}
>> +
>> +static inline void __ghash_blocks(struct p8_ghash_ctx *ctx,
>> +				  struct p8_ghash_desc_ctx *dctx,
>> +				  const u8 *src, unsigned int srclen)
>> +{
>> +	if (!IN_INTERRUPT) {
>> +		preempt_disable();
>> +		pagefault_disable();
>> +		enable_kernel_vsx();
>> +		gcm_ghash_p8(dctx->shash, ctx->htable,
>> +				src, srclen);
>> +		disable_kernel_vsx();
>> +		pagefault_enable();
>> +		preempt_enable();
>> +	} else {
>> +		while (srclen >=3D GHASH_BLOCK_SIZE) {
>> +			crypto_xor((u8 *)dctx->shash, src, GHASH_BLOCK_SIZE);
>> +			gf128mul_lle((be128 *)dctx->shash, &ctx->key);
>> +			srclen -=3D GHASH_BLOCK_SIZE;
>> +			src +=3D GHASH_BLOCK_SIZE;
>> +		}
>> +	}
>>  }
>>
>>  static int p8_ghash_update(struct shash_desc *desc,
>> @@ -131,49 +121,33 @@ static int p8_ghash_update(struct shash_desc *desc,
>>  	struct p8_ghash_ctx *ctx =3D crypto_tfm_ctx(crypto_shash_tfm(desc->tfm=
));
>>  	struct p8_ghash_desc_ctx *dctx =3D shash_desc_ctx(desc);
>>
>> -	if (IN_INTERRUPT) {
>> -		return crypto_shash_update(&dctx->fallback_desc, src,
>> -					   srclen);
>> -	} else {
>> -		if (dctx->bytes) {
>> -			if (dctx->bytes + srclen < GHASH_DIGEST_SIZE) {
>> -				memcpy(dctx->buffer + dctx->bytes, src,
>> -				       srclen);
>> -				dctx->bytes +=3D srclen;
>> -				return 0;
>> -			}
>> +	if (dctx->bytes) {
>> +		if (dctx->bytes + srclen < GHASH_DIGEST_SIZE) {
>>  			memcpy(dctx->buffer + dctx->bytes, src,
>> -			       GHASH_DIGEST_SIZE - dctx->bytes);
>> -			preempt_disable();
>> -			pagefault_disable();
>> -			enable_kernel_vsx();
>> -			gcm_ghash_p8(dctx->shash, ctx->htable,
>> -				     dctx->buffer, GHASH_DIGEST_SIZE);
>> -			disable_kernel_vsx();
>> -			pagefault_enable();
>> -			preempt_enable();
>> -			src +=3D GHASH_DIGEST_SIZE - dctx->bytes;
>> -			srclen -=3D GHASH_DIGEST_SIZE - dctx->bytes;
>> -			dctx->bytes =3D 0;
>> -		}
>> -		len =3D srclen & ~(GHASH_DIGEST_SIZE - 1);
>> -		if (len) {
>> -			preempt_disable();
>> -			pagefault_disable();
>> -			enable_kernel_vsx();
>> -			gcm_ghash_p8(dctx->shash, ctx->htable, src, len);
>> -			disable_kernel_vsx();
>> -			pagefault_enable();
>> -			preempt_enable();
>> -			src +=3D len;
>> -			srclen -=3D len;
>> -		}
>> -		if (srclen) {
>> -			memcpy(dctx->buffer, src, srclen);
>> -			dctx->bytes =3D srclen;
>> +				srclen);
>> +			dctx->bytes +=3D srclen;
>> +			return 0;
>>  		}
>> -		return 0;
>> +		memcpy(dctx->buffer + dctx->bytes, src,
>> +			GHASH_DIGEST_SIZE - dctx->bytes);
>> +
>> +		__ghash_block(ctx, dctx);
>> +
>> +		src +=3D GHASH_DIGEST_SIZE - dctx->bytes;
>> +		srclen -=3D GHASH_DIGEST_SIZE - dctx->bytes;
>> +		dctx->bytes =3D 0;
>> +	}
>> +	len =3D srclen & ~(GHASH_DIGEST_SIZE - 1);
>> +	if (len) {
>> +		__ghash_blocks(ctx, dctx, src, len);
>> +		src +=3D len;
>> +		srclen -=3D len;
>>  	}
>> +	if (srclen) {
>> +		memcpy(dctx->buffer, src, srclen);
>> +		dctx->bytes =3D srclen;
>> +	}
>> +	return 0;
>>  }
>>
>>  static int p8_ghash_final(struct shash_desc *desc, u8 *out)
>> @@ -182,25 +156,14 @@ static int p8_ghash_final(struct shash_desc=20=20
>> *desc, u8 *out)
>>  	struct p8_ghash_ctx *ctx =3D crypto_tfm_ctx(crypto_shash_tfm(desc->tfm=
));
>>  	struct p8_ghash_desc_ctx *dctx =3D shash_desc_ctx(desc);
>>
>> -	if (IN_INTERRUPT) {
>> -		return crypto_shash_final(&dctx->fallback_desc, out);
>> -	} else {
>> -		if (dctx->bytes) {
>> -			for (i =3D dctx->bytes; i < GHASH_DIGEST_SIZE; i++)
>> -				dctx->buffer[i] =3D 0;
>> -			preempt_disable();
>> -			pagefault_disable();
>> -			enable_kernel_vsx();
>> -			gcm_ghash_p8(dctx->shash, ctx->htable,
>> -				     dctx->buffer, GHASH_DIGEST_SIZE);
>> -			disable_kernel_vsx();
>> -			pagefault_enable();
>> -			preempt_enable();
>> -			dctx->bytes =3D 0;
>> -		}
>> -		memcpy(out, dctx->shash, GHASH_DIGEST_SIZE);
>> -		return 0;
>> +	if (dctx->bytes) {
>> +		for (i =3D dctx->bytes; i < GHASH_DIGEST_SIZE; i++)
>> +			dctx->buffer[i] =3D 0;
>> +		__ghash_block(ctx, dctx);
>> +		dctx->bytes =3D 0;
>>  	}
>> +	memcpy(out, dctx->shash, GHASH_DIGEST_SIZE);
>> +	return 0;
>>  }
>>
>>  struct shash_alg p8_ghash_alg =3D {
>> @@ -215,11 +178,8 @@ struct shash_alg p8_ghash_alg =3D {
>>  		 .cra_name =3D "ghash",
>>  		 .cra_driver_name =3D "p8_ghash",
>>  		 .cra_priority =3D 1000,
>> -		 .cra_flags =3D CRYPTO_ALG_NEED_FALLBACK,
>>  		 .cra_blocksize =3D GHASH_BLOCK_SIZE,
>>  		 .cra_ctxsize =3D sizeof(struct p8_ghash_ctx),
>>  		 .cra_module =3D THIS_MODULE,
>> -		 .cra_init =3D p8_ghash_init_tfm,
>> -		 .cra_exit =3D p8_ghash_exit_tfm,
>>  	},
>>  };
>> --
>> 2.19.1
