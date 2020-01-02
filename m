Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8113112E98C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 18:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgABRuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 12:50:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42356 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgABRuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 12:50:22 -0500
Received: from [172.58.107.60] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1in4bz-0006FT-1r; Thu, 02 Jan 2020 17:50:19 +0000
Date:   Thu, 2 Jan 2020 18:50:13 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Amanieu d'Antras <amanieu@gmail.com>, arnd@arndb.de
Cc:     linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] arm64: Move __ARCH_WANT_SYS_CLONE3 definition to
 uapi headers
Message-ID: <20200102175011.q7afo45nc2togtfh@wittgenstein>
References: <20200102172413.654385-1-amanieu@gmail.com>
 <20200102172413.654385-2-amanieu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200102172413.654385-2-amanieu@gmail.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Cc Arnd. I'd like his Ack on this]

On Thu, Jan 02, 2020 at 06:24:07PM +0100, Amanieu d'Antras wrote:
> Previously this was only defined in the internal headers which
> resulted in __NR_clone3 not being defined in the user headers.
> 
> Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: <stable@vger.kernel.org> # 5.3.x
> ---
>  arch/arm64/include/asm/unistd.h      | 1 -
>  arch/arm64/include/uapi/asm/unistd.h | 1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
> index 2629a68b8724..5af82587909e 100644
> --- a/arch/arm64/include/asm/unistd.h
> +++ b/arch/arm64/include/asm/unistd.h
> @@ -42,7 +42,6 @@
>  #endif
>  
>  #define __ARCH_WANT_SYS_CLONE
> -#define __ARCH_WANT_SYS_CLONE3
>  
>  #ifndef __COMPAT_SYSCALL_NR
>  #include <uapi/asm/unistd.h>
> diff --git a/arch/arm64/include/uapi/asm/unistd.h b/arch/arm64/include/uapi/asm/unistd.h
> index 4703d218663a..f83a70e07df8 100644
> --- a/arch/arm64/include/uapi/asm/unistd.h
> +++ b/arch/arm64/include/uapi/asm/unistd.h
> @@ -19,5 +19,6 @@
>  #define __ARCH_WANT_NEW_STAT
>  #define __ARCH_WANT_SET_GET_RLIMIT
>  #define __ARCH_WANT_TIME32_SYSCALLS
> +#define __ARCH_WANT_SYS_CLONE3
>  
>  #include <asm-generic/unistd.h>
> -- 
> 2.24.1
> 
