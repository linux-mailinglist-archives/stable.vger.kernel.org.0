Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFD12A797E
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 09:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725320AbgKEIeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 03:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgKEIeg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 03:34:36 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C696C0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 00:34:36 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id k9so637405edo.5
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 00:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DbsYvz4Gavs4u4SpOXcgyktQpQGaj3PvUYqLH7RUqeA=;
        b=EI7E2SWBkV5f7bgcpD+Pw9OntbBgLQgSOCFmNSLdGTtr8ghO96LVRXrWWXO41/oH5S
         V2xxXcliOgw85+LmQ8ZoEIlYve2D5ti0s8k+nZIyfCnMlUFuxcbzKTUiISoljkIPhk+G
         TPaNWkK020ZWD0DRNcR7yYhskinMdJj2OaChx9+yFFOycRuAyT7+VKXgWIuUIh+eYnEx
         sw3XItaQws2Fu6+AepirNOZhTb5jYzni61a5SA0JCfko1KbvacWtTn1jr0b0b9ScOKRj
         2oMJ5oEVUxQeFpWcSRIl4QqMQQb95RAmp8co1kyz/i2qUWLOEDX5kz9D/Kf8pfWK42xu
         rT2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DbsYvz4Gavs4u4SpOXcgyktQpQGaj3PvUYqLH7RUqeA=;
        b=ld2VT/zDMnkMxYtM5FZqxN9tPVE3VA+f6GLW25VhyLkTyvQcEkCKi3aHR8V8r+CzxY
         lqrIeik9Ktb56Yy4WqDIw1dCiCByO/B7Dn7J1YHJJoh+Y1BRb04A4kxFMrGHVcVSeY2T
         gVtbZmx6FfSRjwqZ6Tb+Z6KXAzYBZZXw9uDJ8YIzOXU5HNz79Went7Ma3s3EWqnuDPM9
         x2r1TvnyHGHbnJlMafjo4LvvqbYZT4PEcoG/5YeghNYfEc4qTKPzlaqnBwCyWyUY07Hz
         qEANp17e6l9JEyhKKl4je9s6iZ3mqjdyWGbmNpu24Qf6NmhHVyegKmw11mU6+9CgfMHH
         tYYA==
X-Gm-Message-State: AOAM530m1nbVLee7niPEo1HZmXcY4yoXKsyB3GgIjz48DwXYroubVVYH
        uPyBKDqA9rKo2my5GP3XwzGTuvLrlSzOyw==
X-Google-Smtp-Source: ABdhPJzouLc6dvk7ocumoVbg2nXnyiBeCrge1bQ4CESylxcJzX7aFxfTXkqzArwS7DrDGiRZx78gGQ==
X-Received: by 2002:a50:e443:: with SMTP id e3mr1479663edm.160.1604565274318;
        Thu, 05 Nov 2020 00:34:34 -0800 (PST)
Received: from ?IPv6:2a02:a03f:5aa3:2700::f4d? ([2a02:a03f:5aa3:2700::f4d])
        by smtp.gmail.com with ESMTPSA id z13sm513754ejp.30.2020.11.05.00.34.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 00:34:33 -0800 (PST)
Subject: Re: Linux 5.9.4
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
References: <16045237196633@kroah.com> <16045237193961@kroah.com>
From:   =?UTF-8?Q?Fran=c3=a7ois_Valenduc?= <francoisvalenduc@gmail.com>
Message-ID: <13da09e2-9692-f2f5-7a55-d949f1f9a6de@gmail.com>
Date:   Thu, 5 Nov 2020 09:34:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <16045237193961@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr-moderne
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I find this strange. There is only 4 commits in git between 5.9.3 and 
5.9.4 while the review had 391 patches. Is it normal ?

Best regards,

François Valenduc

Le 4/11/20 à 22:04, Greg Kroah-Hartman a écrit :
> diff --git a/Makefile b/Makefile
> index 50e927f34853..0c8f0ba8c34f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,7 +1,7 @@
>   # SPDX-License-Identifier: GPL-2.0
>   VERSION = 5
>   PATCHLEVEL = 9
> -SUBLEVEL = 3
> +SUBLEVEL = 4
>   EXTRAVERSION =
>   NAME = Kleptomaniac Octopus
>   
> diff --git a/tools/testing/selftests/powerpc/copyloops/copy_mc_64.S b/tools/testing/selftests/powerpc/copyloops/copy_mc_64.S
> deleted file mode 100644
> index 88d46c471493..000000000000
> --- a/tools/testing/selftests/powerpc/copyloops/copy_mc_64.S
> +++ /dev/null
> @@ -1,242 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -/*
> - * Copyright (C) IBM Corporation, 2011
> - * Derived from copyuser_power7.s by Anton Blanchard <anton@au.ibm.com>
> - * Author - Balbir Singh <bsingharora@gmail.com>
> - */
> -#include <asm/ppc_asm.h>
> -#include <asm/errno.h>
> -#include <asm/export.h>
> -
> -	.macro err1
> -100:
> -	EX_TABLE(100b,.Ldo_err1)
> -	.endm
> -
> -	.macro err2
> -200:
> -	EX_TABLE(200b,.Ldo_err2)
> -	.endm
> -
> -	.macro err3
> -300:	EX_TABLE(300b,.Ldone)
> -	.endm
> -
> -.Ldo_err2:
> -	ld	r22,STK_REG(R22)(r1)
> -	ld	r21,STK_REG(R21)(r1)
> -	ld	r20,STK_REG(R20)(r1)
> -	ld	r19,STK_REG(R19)(r1)
> -	ld	r18,STK_REG(R18)(r1)
> -	ld	r17,STK_REG(R17)(r1)
> -	ld	r16,STK_REG(R16)(r1)
> -	ld	r15,STK_REG(R15)(r1)
> -	ld	r14,STK_REG(R14)(r1)
> -	addi	r1,r1,STACKFRAMESIZE
> -.Ldo_err1:
> -	/* Do a byte by byte copy to get the exact remaining size */
> -	mtctr	r7
> -46:
> -err3;	lbz	r0,0(r4)
> -	addi	r4,r4,1
> -err3;	stb	r0,0(r3)
> -	addi	r3,r3,1
> -	bdnz	46b
> -	li	r3,0
> -	blr
> -
> -.Ldone:
> -	mfctr	r3
> -	blr
> -
> -
> -_GLOBAL(copy_mc_generic)
> -	mr	r7,r5
> -	cmpldi	r5,16
> -	blt	.Lshort_copy
> -
> -.Lcopy:
> -	/* Get the source 8B aligned */
> -	neg	r6,r4
> -	mtocrf	0x01,r6
> -	clrldi	r6,r6,(64-3)
> -
> -	bf	cr7*4+3,1f
> -err1;	lbz	r0,0(r4)
> -	addi	r4,r4,1
> -err1;	stb	r0,0(r3)
> -	addi	r3,r3,1
> -	subi	r7,r7,1
> -
> -1:	bf	cr7*4+2,2f
> -err1;	lhz	r0,0(r4)
> -	addi	r4,r4,2
> -err1;	sth	r0,0(r3)
> -	addi	r3,r3,2
> -	subi	r7,r7,2
> -
> -2:	bf	cr7*4+1,3f
> -err1;	lwz	r0,0(r4)
> -	addi	r4,r4,4
> -err1;	stw	r0,0(r3)
> -	addi	r3,r3,4
> -	subi	r7,r7,4
> -
> -3:	sub	r5,r5,r6
> -	cmpldi	r5,128
> -
> -	mflr	r0
> -	stdu	r1,-STACKFRAMESIZE(r1)
> -	std	r14,STK_REG(R14)(r1)
> -	std	r15,STK_REG(R15)(r1)
> -	std	r16,STK_REG(R16)(r1)
> -	std	r17,STK_REG(R17)(r1)
> -	std	r18,STK_REG(R18)(r1)
> -	std	r19,STK_REG(R19)(r1)
> -	std	r20,STK_REG(R20)(r1)
> -	std	r21,STK_REG(R21)(r1)
> -	std	r22,STK_REG(R22)(r1)
> -	std	r0,STACKFRAMESIZE+16(r1)
> -
> -	blt	5f
> -	srdi	r6,r5,7
> -	mtctr	r6
> -
> -	/* Now do cacheline (128B) sized loads and stores. */
> -	.align	5
> -4:
> -err2;	ld	r0,0(r4)
> -err2;	ld	r6,8(r4)
> -err2;	ld	r8,16(r4)
> -err2;	ld	r9,24(r4)
> -err2;	ld	r10,32(r4)
> -err2;	ld	r11,40(r4)
> -err2;	ld	r12,48(r4)
> -err2;	ld	r14,56(r4)
> -err2;	ld	r15,64(r4)
> -err2;	ld	r16,72(r4)
> -err2;	ld	r17,80(r4)
> -err2;	ld	r18,88(r4)
> -err2;	ld	r19,96(r4)
> -err2;	ld	r20,104(r4)
> -err2;	ld	r21,112(r4)
> -err2;	ld	r22,120(r4)
> -	addi	r4,r4,128
> -err2;	std	r0,0(r3)
> -err2;	std	r6,8(r3)
> -err2;	std	r8,16(r3)
> -err2;	std	r9,24(r3)
> -err2;	std	r10,32(r3)
> -err2;	std	r11,40(r3)
> -err2;	std	r12,48(r3)
> -err2;	std	r14,56(r3)
> -err2;	std	r15,64(r3)
> -err2;	std	r16,72(r3)
> -err2;	std	r17,80(r3)
> -err2;	std	r18,88(r3)
> -err2;	std	r19,96(r3)
> -err2;	std	r20,104(r3)
> -err2;	std	r21,112(r3)
> -err2;	std	r22,120(r3)
> -	addi	r3,r3,128
> -	subi	r7,r7,128
> -	bdnz	4b
> -
> -	clrldi	r5,r5,(64-7)
> -
> -	/* Up to 127B to go */
> -5:	srdi	r6,r5,4
> -	mtocrf	0x01,r6
> -
> -6:	bf	cr7*4+1,7f
> -err2;	ld	r0,0(r4)
> -err2;	ld	r6,8(r4)
> -err2;	ld	r8,16(r4)
> -err2;	ld	r9,24(r4)
> -err2;	ld	r10,32(r4)
> -err2;	ld	r11,40(r4)
> -err2;	ld	r12,48(r4)
> -err2;	ld	r14,56(r4)
> -	addi	r4,r4,64
> -err2;	std	r0,0(r3)
> -err2;	std	r6,8(r3)
> -err2;	std	r8,16(r3)
> -err2;	std	r9,24(r3)
> -err2;	std	r10,32(r3)
> -err2;	std	r11,40(r3)
> -err2;	std	r12,48(r3)
> -err2;	std	r14,56(r3)
> -	addi	r3,r3,64
> -	subi	r7,r7,64
> -
> -7:	ld	r14,STK_REG(R14)(r1)
> -	ld	r15,STK_REG(R15)(r1)
> -	ld	r16,STK_REG(R16)(r1)
> -	ld	r17,STK_REG(R17)(r1)
> -	ld	r18,STK_REG(R18)(r1)
> -	ld	r19,STK_REG(R19)(r1)
> -	ld	r20,STK_REG(R20)(r1)
> -	ld	r21,STK_REG(R21)(r1)
> -	ld	r22,STK_REG(R22)(r1)
> -	addi	r1,r1,STACKFRAMESIZE
> -
> -	/* Up to 63B to go */
> -	bf	cr7*4+2,8f
> -err1;	ld	r0,0(r4)
> -err1;	ld	r6,8(r4)
> -err1;	ld	r8,16(r4)
> -err1;	ld	r9,24(r4)
> -	addi	r4,r4,32
> -err1;	std	r0,0(r3)
> -err1;	std	r6,8(r3)
> -err1;	std	r8,16(r3)
> -err1;	std	r9,24(r3)
> -	addi	r3,r3,32
> -	subi	r7,r7,32
> -
> -	/* Up to 31B to go */
> -8:	bf	cr7*4+3,9f
> -err1;	ld	r0,0(r4)
> -err1;	ld	r6,8(r4)
> -	addi	r4,r4,16
> -err1;	std	r0,0(r3)
> -err1;	std	r6,8(r3)
> -	addi	r3,r3,16
> -	subi	r7,r7,16
> -
> -9:	clrldi	r5,r5,(64-4)
> -
> -	/* Up to 15B to go */
> -.Lshort_copy:
> -	mtocrf	0x01,r5
> -	bf	cr7*4+0,12f
> -err1;	lwz	r0,0(r4)	/* Less chance of a reject with word ops */
> -err1;	lwz	r6,4(r4)
> -	addi	r4,r4,8
> -err1;	stw	r0,0(r3)
> -err1;	stw	r6,4(r3)
> -	addi	r3,r3,8
> -	subi	r7,r7,8
> -
> -12:	bf	cr7*4+1,13f
> -err1;	lwz	r0,0(r4)
> -	addi	r4,r4,4
> -err1;	stw	r0,0(r3)
> -	addi	r3,r3,4
> -	subi	r7,r7,4
> -
> -13:	bf	cr7*4+2,14f
> -err1;	lhz	r0,0(r4)
> -	addi	r4,r4,2
> -err1;	sth	r0,0(r3)
> -	addi	r3,r3,2
> -	subi	r7,r7,2
> -
> -14:	bf	cr7*4+3,15f
> -err1;	lbz	r0,0(r4)
> -err1;	stb	r0,0(r3)
> -
> -15:	li	r3,0
> -	blr
> -
> -EXPORT_SYMBOL_GPL(copy_mc_generic);
> diff --git a/tools/testing/selftests/powerpc/copyloops/copy_mc_64.S b/tools/testing/selftests/powerpc/copyloops/copy_mc_64.S
> new file mode 120000
> index 000000000000..dcbe06d500fb
> --- /dev/null
> +++ b/tools/testing/selftests/powerpc/copyloops/copy_mc_64.S
> @@ -0,0 +1 @@
> +../../../../../arch/powerpc/lib/copy_mc_64.S
> \ No newline at end of file
> diff --git a/tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S b/tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S
> deleted file mode 120000
> index f0feef3062f6..000000000000
> --- a/tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S
> +++ /dev/null
> @@ -1 +0,0 @@
> -../../../../../arch/powerpc/lib/memcpy_mcsafe_64.S
> \ No newline at end of file
> 

