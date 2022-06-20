Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34260551649
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 12:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240837AbiFTKyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 06:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240819AbiFTKyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 06:54:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992911402E;
        Mon, 20 Jun 2022 03:54:21 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KAFku2013608;
        Mon, 20 Jun 2022 10:54:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=OYqLhqvUauJr6u5admFA0SGeBES5Sesocwb98ajY/l0=;
 b=a04jOTd8D9HTmZGRuxJzsSf4+NFfElm1Bs4WLPzf11rXyZZaLVAzMjUKcNV8GrNvH+Bb
 I7tGk5+0qkxLr4F0xXOiUB7IGy7UBCV99oFVgExsP8ajJ6ODIOXYjZMK9ED54FWrREVj
 8EO3AiKnDpuY8QbTrMHHcGTzNFgqy/WHlSUcR2ytxy8r4/jPQwlIKxQSPJTu+Og9tPXv
 yn9ecc6SwL0bFwkB3KlCv93bkIn6B0lOzKpyyaDGto9mX2Mx4rb5Vru7DXMPaMT0avmN
 3wxJuTC0IxKJGccMXSXW/X63KVykFEQgimn6MYKEYDsOxZUDrir8eSJAiDCMvW3c6Fll Ag== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrb5x5y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 10:54:20 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25KApXlv012708;
        Mon, 20 Jun 2022 10:54:19 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 3gs6b97yk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 10:54:19 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25KAsGtk25756098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 10:54:16 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D0926A08E;
        Mon, 20 Jun 2022 10:54:15 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17C636A07C;
        Mon, 20 Jun 2022 10:54:15 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jun 2022 10:54:14 +0000 (GMT)
MIME-Version: 1.0
Date:   Mon, 20 Jun 2022 12:54:11 +0200
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ingo Franzki <ifranzki@linux.ibm.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] s390/archrandom: simplify back to earlier design
Reply-To: freude@linux.ibm.com
In-Reply-To: <20220610111041.2709-1-Jason@zx2c4.com>
References: <20220610111041.2709-1-Jason@zx2c4.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <1e6dd1baa9a5d7a665917793e2df785c@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vsu7GuyMfyUF8FM3OC9UqGyWJio47bGD
X-Proofpoint-GUID: vsu7GuyMfyUF8FM3OC9UqGyWJio47bGD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206200049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-06-10 13:10, Jason A. Donenfeld wrote:
> s390x appears to present two RNG interfaces:
> - a "TRNG" that gathers entropy using some hardware function; and
> - a "DRBG" that takes in a seed and expands it.
> 
> Previously, the TRNG was wired up to arch_get_random_{long,int}(), but
> it was observed that this was being called really frequently, resulting
> in high overhead. So it was changed to be wired up to arch_get_random_
> seed_{long,int}(), which was a reasonable decision. Later on, the DRBG
> was then wired up to arch_get_random_{long,int}(), with a complicated
> buffer filling thread, to control overhead and rate.
> 
> Fortunately, none of the performance issues matter much now. The RNG
> always attempts to use arch_get_random_seed_{long,int}() first, which
> means a complicated implementation of arch_get_random_{long,int}() 
> isn't
> really valuable or useful to have around. And it's only used when
> reseeding, which means it won't hit the high throughput complications
> that were faced before.
> 
> So this commit returns to an earlier design of just calling the TRNG in
> arch_get_random_seed_{long,int}(), and returning false in arch_get_
> random_{long,int}().
> 
> Cc: stable@vger.kernel.org
> Cc: Harald Freudenberger <freude@linux.ibm.com>
> Cc: Ingo Franzki <ifranzki@linux.ibm.com>
> Cc: Juergen Christ <jchrist@linux.ibm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Harald - please let me know if my assumptions about how the s390
> machinery works are correct. I might have misunderstood the history of
> these changes and their motivations. -Jason
> 
>  arch/s390/crypto/arch_random.c     | 211 +----------------------------
>  arch/s390/include/asm/archrandom.h |  14 +-
>  2 files changed, 9 insertions(+), 216 deletions(-)
> 
> diff --git a/arch/s390/crypto/arch_random.c 
> b/arch/s390/crypto/arch_random.c
> index 56007c763902..55c35d4c03b2 100644
> --- a/arch/s390/crypto/arch_random.c
> +++ b/arch/s390/crypto/arch_random.c
> @@ -4,36 +4,12 @@
>   *
>   * Copyright IBM Corp. 2017, 2020
>   * Author(s): Harald Freudenberger
> - *
> - * The s390_arch_random_generate() function may be called from 
> random.c
> - * in interrupt context. So this implementation does the best to be 
> very
> - * fast. There is a buffer of random data which is asynchronously 
> checked
> - * and filled by a workqueue thread.
> - * If there are enough bytes in the buffer the 
> s390_arch_random_generate()
> - * just delivers these bytes. Otherwise false is returned until the
> - * worker thread refills the buffer.
> - * The worker fills the rng buffer by pulling fresh entropy from the
> - * high quality (but slow) true hardware random generator. This 
> entropy
> - * is then spread over the buffer with an pseudo random generator 
> PRNG.
> - * As the arch_get_random_seed_long() fetches 8 bytes and the calling
> - * function add_interrupt_randomness() counts this as 1 bit entropy 
> the
> - * distribution needs to make sure there is in fact 1 bit entropy 
> contained
> - * in 8 bytes of the buffer. The current values pull 32 byte entropy
> - * and scatter this into a 2048 byte buffer. So 8 byte in the buffer
> - * will contain 1 bit of entropy.
> - * The worker thread is rescheduled based on the charge level of the
> - * buffer but at least with 500 ms delay to avoid too much CPU 
> consumption.
> - * So the max. amount of rng data delivered via arch_get_random_seed 
> is
> - * limited to 4k bytes per second.
>   */
> 
>  #include <linux/kernel.h>
>  #include <linux/atomic.h>
>  #include <linux/random.h>
> -#include <linux/slab.h>
>  #include <linux/static_key.h>
> -#include <linux/workqueue.h>
> -#include <linux/moduleparam.h>
>  #include <asm/cpacf.h>
> 
>  DEFINE_STATIC_KEY_FALSE(s390_arch_random_available);
> @@ -41,194 +17,11 @@ 
> DEFINE_STATIC_KEY_FALSE(s390_arch_random_available);
>  atomic64_t s390_arch_random_counter = ATOMIC64_INIT(0);
>  EXPORT_SYMBOL(s390_arch_random_counter);
> 
> -#define ARCH_REFILL_TICKS (HZ/2)
> -#define ARCH_PRNG_SEED_SIZE 32
> -#define ARCH_RNG_BUF_SIZE 2048
> -
> -static DEFINE_SPINLOCK(arch_rng_lock);
> -static u8 *arch_rng_buf;
> -static unsigned int arch_rng_buf_idx;
> -
> -static void arch_rng_refill_buffer(struct work_struct *);
> -static DECLARE_DELAYED_WORK(arch_rng_work, arch_rng_refill_buffer);
> -
> -bool s390_arch_random_generate(u8 *buf, unsigned int nbytes)
> -{
> -	/* max hunk is ARCH_RNG_BUF_SIZE */
> -	if (nbytes > ARCH_RNG_BUF_SIZE)
> -		return false;
> -
> -	/* lock rng buffer */
> -	if (!spin_trylock(&arch_rng_lock))
> -		return false;
> -
> -	/* try to resolve the requested amount of bytes from the buffer */
> -	arch_rng_buf_idx -= nbytes;
> -	if (arch_rng_buf_idx < ARCH_RNG_BUF_SIZE) {
> -		memcpy(buf, arch_rng_buf + arch_rng_buf_idx, nbytes);
> -		atomic64_add(nbytes, &s390_arch_random_counter);
> -		spin_unlock(&arch_rng_lock);
> -		return true;
> -	}
> -
> -	/* not enough bytes in rng buffer, refill is done asynchronously */
> -	spin_unlock(&arch_rng_lock);
> -
> -	return false;
> -}
> -EXPORT_SYMBOL(s390_arch_random_generate);
> -
> -static void arch_rng_refill_buffer(struct work_struct *unused)
> -{
> -	unsigned int delay = ARCH_REFILL_TICKS;
> -
> -	spin_lock(&arch_rng_lock);
> -	if (arch_rng_buf_idx > ARCH_RNG_BUF_SIZE) {
> -		/* buffer is exhausted and needs refill */
> -		u8 seed[ARCH_PRNG_SEED_SIZE];
> -		u8 prng_wa[240];
> -		/* fetch ARCH_PRNG_SEED_SIZE bytes of entropy */
> -		cpacf_trng(NULL, 0, seed, sizeof(seed));
> -		/* blow this entropy up to ARCH_RNG_BUF_SIZE with PRNG */
> -		memset(prng_wa, 0, sizeof(prng_wa));
> -		cpacf_prno(CPACF_PRNO_SHA512_DRNG_SEED,
> -			   &prng_wa, NULL, 0, seed, sizeof(seed));
> -		cpacf_prno(CPACF_PRNO_SHA512_DRNG_GEN,
> -			   &prng_wa, arch_rng_buf, ARCH_RNG_BUF_SIZE, NULL, 0);
> -		arch_rng_buf_idx = ARCH_RNG_BUF_SIZE;
> -	}
> -	delay += (ARCH_REFILL_TICKS * arch_rng_buf_idx) / ARCH_RNG_BUF_SIZE;
> -	spin_unlock(&arch_rng_lock);
> -
> -	/* kick next check */
> -	queue_delayed_work(system_long_wq, &arch_rng_work, delay);
> -}
> -
> -/*
> - * Here follows the implementation of s390_arch_get_random_long().
> - *
> - * The random longs to be pulled by arch_get_random_long() are
> - * prepared in an 4K buffer which is filled from the NIST 800-90
> - * compliant s390 drbg. By default the random long buffer is refilled
> - * 256 times before the drbg itself needs a reseed. The reseed of the
> - * drbg is done with 32 bytes fetched from the high quality (but slow)
> - * trng which is assumed to deliver 100% entropy. So the 32 * 8 = 256
> - * bits of entropy are spread over 256 * 4KB = 1MB serving 131072
> - * arch_get_random_long() invocations before reseeded.
> - *
> - * How often the 4K random long buffer is refilled with the drbg
> - * before the drbg is reseeded can be adjusted. There is a module
> - * parameter 's390_arch_rnd_long_drbg_reseed' accessible via
> - *   /sys/module/arch_random/parameters/rndlong_drbg_reseed
> - * or as kernel command line parameter
> - *   arch_random.rndlong_drbg_reseed=<value>
> - * This parameter tells how often the drbg fills the 4K buffer before
> - * it is re-seeded by fresh entropy from the trng.
> - * A value of 16 results in reseeding the drbg at every 16 * 4 KB = 64
> - * KB with 32 bytes of fresh entropy pulled from the trng. So a value
> - * of 16 would result in 256 bits entropy per 64 KB.
> - * A value of 256 results in 1MB of drbg output before a reseed of the
> - * drbg is done. So this would spread the 256 bits of entropy among 
> 1MB.
> - * Setting this parameter to 0 forces the reseed to take place every
> - * time the 4K buffer is depleted, so the entropy rises to 256 bits
> - * entropy per 4K or 0.5 bit entropy per arch_get_random_long().  With
> - * setting this parameter to negative values all this effort is
> - * disabled, arch_get_random long() returns false and thus indicating
> - * that the arch_get_random_long() feature is disabled at all.
> - */
> -
> -static unsigned long rndlong_buf[512];
> -static DEFINE_SPINLOCK(rndlong_lock);
> -static int rndlong_buf_index;
> -
> -static int rndlong_drbg_reseed = 256;
> -module_param_named(rndlong_drbg_reseed, rndlong_drbg_reseed, int, 
> 0600);
> -MODULE_PARM_DESC(rndlong_drbg_reseed, "s390 arch_get_random_long()
> drbg reseed");
> -
> -static inline void refill_rndlong_buf(void)
> -{
> -	static u8 prng_ws[240];
> -	static int drbg_counter;
> -
> -	if (--drbg_counter < 0) {
> -		/* need to re-seed the drbg */
> -		u8 seed[32];
> -
> -		/* fetch seed from trng */
> -		cpacf_trng(NULL, 0, seed, sizeof(seed));
> -		/* seed drbg */
> -		memset(prng_ws, 0, sizeof(prng_ws));
> -		cpacf_prno(CPACF_PRNO_SHA512_DRNG_SEED,
> -			   &prng_ws, NULL, 0, seed, sizeof(seed));
> -		/* re-init counter for drbg */
> -		drbg_counter = rndlong_drbg_reseed;
> -	}
> -
> -	/* fill the arch_get_random_long buffer from drbg */
> -	cpacf_prno(CPACF_PRNO_SHA512_DRNG_GEN, &prng_ws,
> -		   (u8 *) rndlong_buf, sizeof(rndlong_buf),
> -		   NULL, 0);
> -}
> -
> -bool s390_arch_get_random_long(unsigned long *v)
> -{
> -	bool rc = false;
> -	unsigned long flags;
> -
> -	/* arch_get_random_long() disabled ? */
> -	if (rndlong_drbg_reseed < 0)
> -		return false;
> -
> -	/* try to lock the random long lock */
> -	if (!spin_trylock_irqsave(&rndlong_lock, flags))
> -		return false;
> -
> -	if (--rndlong_buf_index >= 0) {
> -		/* deliver next long value from the buffer */
> -		*v = rndlong_buf[rndlong_buf_index];
> -		rc = true;
> -		goto out;
> -	}
> -
> -	/* buffer is depleted and needs refill */
> -	if (in_interrupt()) {
> -		/* delay refill in interrupt context to next caller */
> -		rndlong_buf_index = 0;
> -		goto out;
> -	}
> -
> -	/* refill random long buffer */
> -	refill_rndlong_buf();
> -	rndlong_buf_index = ARRAY_SIZE(rndlong_buf);
> -
> -	/* and provide one random long */
> -	*v = rndlong_buf[--rndlong_buf_index];
> -	rc = true;
> -
> -out:
> -	spin_unlock_irqrestore(&rndlong_lock, flags);
> -	return rc;
> -}
> -EXPORT_SYMBOL(s390_arch_get_random_long);
> -
>  static int __init s390_arch_random_init(void)
>  {
> -	/* all the needed PRNO subfunctions available ? */
> -	if (cpacf_query_func(CPACF_PRNO, CPACF_PRNO_TRNG) &&
> -	    cpacf_query_func(CPACF_PRNO, CPACF_PRNO_SHA512_DRNG_GEN)) {
> -
> -		/* alloc arch random working buffer */
> -		arch_rng_buf = kmalloc(ARCH_RNG_BUF_SIZE, GFP_KERNEL);
> -		if (!arch_rng_buf)
> -			return -ENOMEM;
> -
> -		/* kick worker queue job to fill the random buffer */
> -		queue_delayed_work(system_long_wq,
> -				   &arch_rng_work, ARCH_REFILL_TICKS);
> -
> -		/* enable arch random to the outside world */
> +	/* check if subfunction CPACF_PRNO_TRNG is available */
> +	if (cpacf_query_func(CPACF_PRNO, CPACF_PRNO_TRNG))
>  		static_branch_enable(&s390_arch_random_available);
> -	}
> 
>  	return 0;
>  }
> diff --git a/arch/s390/include/asm/archrandom.h
> b/arch/s390/include/asm/archrandom.h
> index 5dc712fde3c7..2c6e1c6ecbe7 100644
> --- a/arch/s390/include/asm/archrandom.h
> +++ b/arch/s390/include/asm/archrandom.h
> @@ -15,17 +15,13 @@
> 
>  #include <linux/static_key.h>
>  #include <linux/atomic.h>
> +#include <asm/cpacf.h>
> 
>  DECLARE_STATIC_KEY_FALSE(s390_arch_random_available);
>  extern atomic64_t s390_arch_random_counter;
> 
> -bool s390_arch_get_random_long(unsigned long *v);
> -bool s390_arch_random_generate(u8 *buf, unsigned int nbytes);
> -
>  static inline bool __must_check arch_get_random_long(unsigned long *v)
>  {
> -	if (static_branch_likely(&s390_arch_random_available))
> -		return s390_arch_get_random_long(v);
>  	return false;
>  }
> 
> @@ -37,7 +33,9 @@ static inline bool __must_check
> arch_get_random_int(unsigned int *v)
>  static inline bool __must_check arch_get_random_seed_long(unsigned 
> long *v)
>  {
>  	if (static_branch_likely(&s390_arch_random_available)) {
> -		return s390_arch_random_generate((u8 *)v, sizeof(*v));
> +		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
> +		atomic64_add(sizeof(*v), &s390_arch_random_counter);
> +		return true;
>  	}
>  	return false;
>  }
> @@ -45,7 +43,9 @@ static inline bool __must_check
> arch_get_random_seed_long(unsigned long *v)
>  static inline bool __must_check arch_get_random_seed_int(unsigned int 
> *v)
>  {
>  	if (static_branch_likely(&s390_arch_random_available)) {
> -		return s390_arch_random_generate((u8 *)v, sizeof(*v));
> +		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
> +		atomic64_add(sizeof(*v), &s390_arch_random_counter);
> +		return true;
>  	}
>  	return false;
>  }

Hi Jason, I've been on vacation and now seen your s390 arch random 
rework.
Your assumption is right. The hw TRNG we have on the s390 platform is
relatively expensive and I had to learn that directly calling the TRNG
as part of an arch_get_random_{long,int} is not the right way. As we
also have a NIST 800-90A conform PRNG in hardware, I used it as some
kind of caching the TRNG random data.

With all the changes in random.c there is no need to provide any
arch_get_random_{long,int}() implementation any more.
However, the arch_get_random_seed functions should provide TRNG
values to random.c and so I'll have a close look onto your changes.
Thanks for your patches, I'll come back with some feedback.
Harald Freudenberger
