Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5221015EA1
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 09:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfEGHwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 03:52:16 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:12217 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbfEGHwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 03:52:16 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 44ysJY12qBz9v0QD;
        Tue,  7 May 2019 09:52:13 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=uuC5O9IS; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id yFfxo6T7vyke; Tue,  7 May 2019 09:52:13 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 44ysJX73Sfz9v0Pt;
        Tue,  7 May 2019 09:52:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1557215533; bh=v6NA55NzwK+qVu67DCAtG3dejyduGQyYNpu105tIJQo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=uuC5O9IS1ZRhjnqrSuAfc89JUVIegmtu/C20wBh5ca8SDTErkUiQ3hsd/VowB2T2+
         qPrvaMLL4Me+wlu34BZGSpCmpQuubdQwQBt8GxH6b7B/JO+68JMKmYIDa6rf0eeQWv
         9lR0JB9h6r66DvbMX2In1V7hbD7Zr1Fg2Khyzs/Q=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id F13CF8B87B;
        Tue,  7 May 2019 09:52:13 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id W3R6lgpBh9Z6; Tue,  7 May 2019 09:52:13 +0200 (CEST)
Received: from PO15451 (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 4FBE28B879;
        Tue,  7 May 2019 09:52:13 +0200 (CEST)
Subject: Re: [PATCH AUTOSEL 4.14 65/95] powerpc: remove old GCC version checks
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sasha Levin <alexander.levin@microsoft.com>,
        linuxppc-dev@lists.ozlabs.org, Joel Stanley <joel@jms.id.au>,
        Nicholas Piggin <npiggin@gmail.com>
References: <20190507053826.31622-1-sashal@kernel.org>
 <20190507053826.31622-65-sashal@kernel.org>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <c1b63e96-127d-98cf-62f9-2e0ee1a434e3@c-s.fr>
Date:   Tue, 7 May 2019 09:52:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507053826.31622-65-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

I don't think GCC 4.6 is the minimum supported for 4.14

As far as I can see, commit cafa0010cd51f ("Raise the minimum required 
gcc version to 4.6") has not been applied to 4.14 and I can't see any 
reason such a commit should apply on a stable branch.

Christophe

Le 07/05/2019 à 07:37, Sasha Levin a écrit :
> From: Nicholas Piggin <npiggin@gmail.com>
> 
> [ Upstream commit f2910f0e6835339e6ce82cef22fa15718b7e3bfa ]
> 
> GCC 4.6 is the minimum supported now.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> Reviewed-by: Joel Stanley <joel@jms.id.au>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
> ---
>   arch/powerpc/Makefile | 31 ++-----------------------------
>   1 file changed, 2 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
> index 7452e50f4d1f..0f04c878113e 100644
> --- a/arch/powerpc/Makefile
> +++ b/arch/powerpc/Makefile
> @@ -396,36 +396,9 @@ archprepare: checkbin
>   # to stdout and these checks are run even on install targets.
>   TOUT	:= .tmp_gas_check
>   
> -# Check gcc and binutils versions:
> -# - gcc-3.4 and binutils-2.14 are a fatal combination
> -# - Require gcc 4.0 or above on 64-bit
> -# - gcc-4.2.0 has issues compiling modules on 64-bit
> +# Check toolchain versions:
> +# - gcc-4.6 is the minimum kernel-wide version so nothing required.
>   checkbin:
> -	@if test "$(cc-name)" != "clang" \
> -	    && test "$(cc-version)" = "0304" ; then \
> -		if ! /bin/echo mftb 5 | $(AS) -v -mppc -many -o $(TOUT) >/dev/null 2>&1 ; then \
> -			echo -n '*** ${VERSION}.${PATCHLEVEL} kernels no longer build '; \
> -			echo 'correctly with gcc-3.4 and your version of binutils.'; \
> -			echo '*** Please upgrade your binutils or downgrade your gcc'; \
> -			false; \
> -		fi ; \
> -	fi
> -	@if test "$(cc-name)" != "clang" \
> -	    && test "$(cc-version)" -lt "0400" \
> -	    && test "x${CONFIG_PPC64}" = "xy" ; then \
> -                echo -n "Sorry, GCC v4.0 or above is required to build " ; \
> -                echo "the 64-bit powerpc kernel." ; \
> -                false ; \
> -        fi
> -	@if test "$(cc-name)" != "clang" \
> -	    && test "$(cc-fullversion)" = "040200" \
> -	    && test "x${CONFIG_MODULES}${CONFIG_PPC64}" = "xyy" ; then \
> -		echo -n '*** GCC-4.2.0 cannot compile the 64-bit powerpc ' ; \
> -		echo 'kernel with modules enabled.' ; \
> -		echo -n '*** Please use a different GCC version or ' ; \
> -		echo 'disable kernel modules' ; \
> -		false ; \
> -	fi
>   	@if test "x${CONFIG_CPU_LITTLE_ENDIAN}" = "xy" \
>   	    && $(LD) --version | head -1 | grep ' 2\.24$$' >/dev/null ; then \
>   		echo -n '*** binutils 2.24 miscompiles weak symbols ' ; \
> 
