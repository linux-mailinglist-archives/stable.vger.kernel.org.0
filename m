Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7252A8EE1
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 06:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgKFF0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 00:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgKFF0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 00:26:41 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A027C0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 21:26:41 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 72so257754pfv.7
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 21:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=EkQLhkGZHqpvuQT2CFN2+E1nRGoyf455nd9ZLIW66dM=;
        b=kHPaqhNUPrft4bDa8rGifjMcUdpz202rSSaV36nVs/Hru2LoPXEWCRkzDvufyB9fzW
         NSoIP9+mGKO9emMplFGwv88J9odD3J+C3hnsgl1EFQh644MZcr2/UFrxZQVSqpdOru1D
         Cmrl/jkn07BuKlQLVcijDNoSqnDsg+zhyE9lZE6A/7Ls/DXa0twaXKON0tk6fOzMdLib
         gL6msyEqIGKNhU5JC3o91m1M+BlvLluct1HU7J7JIrtMk9GwU22+beqtoLMAWoO4OSqQ
         OB3i+sdARPUIfQbirFuZ2Wep0ZTe9EYYEVKQCLpVY6L+cbPRusdhKmqOFesXtZC533pF
         /3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=EkQLhkGZHqpvuQT2CFN2+E1nRGoyf455nd9ZLIW66dM=;
        b=sw4n0YOwRvIw2daLgA5sALUk5nY232314J8LVgD/y2mAuqpks1eRzny4rH4LMCtHfw
         4mrKbVQIRwZJNb3ePyo8CeTKl/58tlxaHB8cZ+Nwx0rNgsO4DcEnfIjZOhQ7MylWBSAe
         EN34WCFZAQVlmc74ib+radd851gHgs1jmPZCpY5B8CNY+8b49AIfKVCvDWjxQaH+K/Kf
         nZs6tXK2p3LosURVEzvLrELbiDLmlbfOgwWpZhN8CM05cHgtNEcgK1fir3tEkiuLRSLn
         /O+EzVOBvdHCX8tJW6Z3OcFg4+P0Z0ThvRyRbM2hXOjarUGvT402S4gEqmXgpTccoq0u
         p4DA==
X-Gm-Message-State: AOAM5312H49gLYiP/W/hCf22DwaEjbvjV7844NFmILjyKm15dHEKZdXw
        6yE+df/M2CjqTRyuxEb27atWfw==
X-Google-Smtp-Source: ABdhPJyX2PZV+nlWTOdRmguB30haDCamIKp/V4ktqSQVJ6fCG/rlsMyBnAkVJtH0MnxR2zUHOKWEUA==
X-Received: by 2002:a63:db18:: with SMTP id e24mr312795pgg.155.1604640400933;
        Thu, 05 Nov 2020 21:26:40 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id g7sm499742pjl.11.2020.11.05.21.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 21:26:40 -0800 (PST)
Date:   Thu, 05 Nov 2020 21:26:40 -0800 (PST)
X-Google-Original-Date: Thu, 05 Nov 2020 21:26:38 PST (-0800)
Subject:     Re: [PATCH AUTOSEL 4.19 28/60] riscv: Define AT_VECTOR_SIZE_ARCH for ARCH_DLINFO
In-Reply-To: <20201027000415.1026364-28-sashal@kernel.org>
CC:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        zong.li@sifive.com, penberg@kernel.org, sashal@kernel.org,
        linux-riscv@lists.infradead.org
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     sashal@kernel.org
Message-ID: <mhng-2b910e68-c031-484b-9d19-5c845f9c65f4@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Oct 2020 17:03:43 PDT (-0700), sashal@kernel.org wrote:
> From: Zong Li <zong.li@sifive.com>
>
> [ Upstream commit b5fca7c55f9fbab5ad732c3bce00f31af6ba5cfa ]
>
> AT_VECTOR_SIZE_ARCH should be defined with the maximum number of
> NEW_AUX_ENT entries that ARCH_DLINFO can contain, but it wasn't defined
> for RISC-V at all even though ARCH_DLINFO will contain one NEW_AUX_ENT
> for the VDSO address.
>
> Signed-off-by: Zong Li <zong.li@sifive.com>
> Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
> Reviewed-by: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/riscv/include/uapi/asm/auxvec.h | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/riscv/include/uapi/asm/auxvec.h b/arch/riscv/include/uapi/asm/auxvec.h
> index 1376515547cda..ed7bf7c7add5f 100644
> --- a/arch/riscv/include/uapi/asm/auxvec.h
> +++ b/arch/riscv/include/uapi/asm/auxvec.h
> @@ -21,4 +21,7 @@
>  /* vDSO location */
>  #define AT_SYSINFO_EHDR 33
>
> +/* entries in ARCH_DLINFO */
> +#define AT_VECTOR_SIZE_ARCH	1
> +
>  #endif /* _UAPI_ASM_RISCV_AUXVEC_H */

Thanks.  This should have been

Fixes: 2129a235c098 ("RISC-V: ELF and module implementation")

which is essentially all the way back to the beginning.
