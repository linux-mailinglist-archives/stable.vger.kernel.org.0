Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476C02E0588
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 06:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgLVFDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 00:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgLVFDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 00:03:32 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E085DC0613D3
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 21:02:51 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id g3so6823569plp.2
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 21:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=RpZ+wXfl2QotbYqPhv72PU/yTVx45uHY6nTFy9x2zvA=;
        b=ALTnk7siuh07+b8/NS2YbaHb6lJA8nhq8iRcs3VOa76aaRGvdEuQn6i+3bs5kNbgBe
         +D2voammdOWr66fe4oikCX1fCEvd9h8EUfX9HZQMv5er7CrIQN4J5ZjkkiMsUWrfk6fV
         VI5CQOcExxe31qVzEGqeq3hCLZFi3z6Hu9+Ro1clfFqxMQbuv15DiMoWouT7vm9lzh3J
         Rgqd4Y08TfXC2mphKWhoYVfi/03gtpDUDw+gkV0GNBPFTourrXsWa/rvwL/5+cxWU55O
         wHB74H8I22nYDY/lLqtXyKuz6YwNRz8gNx3OdDniCiDVwgsgxjSmk9q2T37ui3v8Uc96
         an5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=RpZ+wXfl2QotbYqPhv72PU/yTVx45uHY6nTFy9x2zvA=;
        b=a/jnNNnHcIcqamxp4zglCgqyPPSYWSmQyufk1jFr7vfBDKam0aNCKLUSFKauDSDZcy
         pZF0dH2btuW+kmuzaHO7A7bGbPYST+8JnCBIZePiOur9X/+CF9PhR598g7TE0pMAudhe
         ungt/K8ZTDvOQ/BLRgtrNBe+QIz/oSEceAt99qnlH36QDvSAtmHPyviar8djoAJj9oLG
         wGhpIIEg0O4WCxbHHxXMeKxuCnbhcbACl+MrCoZKDN628O+t1xeDx/lTMWLg7+RqDhUs
         ijl+2GvZVoj6Qy5VlVxtX0+adrTU5q12ASUEsRb3gH1xdP0O9wi916H1MD3hw3jk6fxx
         e3Lg==
X-Gm-Message-State: AOAM530NLRxUGrXN+RLHMwI3Zm96gShiXTqYRUJSxoCPQ0jG0zACPipR
        Qb3G+akysKVO8K+WdDq8DrBM6g==
X-Google-Smtp-Source: ABdhPJxd/u78GqOJhoWzNph+XNE99fMyFxboDZVhN/a3J6FYMOa7bgl3N+Fcj7B8erZv7k6geDrFwg==
X-Received: by 2002:a17:90a:e001:: with SMTP id u1mr18321209pjy.3.1608613371225;
        Mon, 21 Dec 2020 21:02:51 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id l190sm18292642pfl.205.2020.12.21.21.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 21:02:50 -0800 (PST)
Date:   Mon, 21 Dec 2020 21:02:50 -0800 (PST)
X-Google-Original-Date: Mon, 21 Dec 2020 21:02:48 PST (-0800)
Subject:     Re: [PATCH v2] RISC-V: Fix usage of memblock_enforce_memory_limit
In-Reply-To: <20201219001356.2887782-1-atish.patra@wdc.com>
CC:     linux-kernel@vger.kernel.org, Atish Patra <Atish.Patra@wdc.com>,
        stable@vger.kernel.org, bin.meng@windriver.com, rppt@linux.ibm.com,
        aou@eecs.berkeley.edu, akpm@linux-foundation.org,
        Anup Patel <Anup.Patel@wdc.com>,
        linux-riscv@lists.infradead.org, rppt@kernel.org,
        Paul Walmsley <paul.walmsley@sifive.com>, bmeng.cn@gmail.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Atish Patra <Atish.Patra@wdc.com>
Message-ID: <mhng-35592185-e0e1-499f-8845-a4026154b983@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 18 Dec 2020 16:13:56 PST (-0800), Atish Patra wrote:
> memblock_enforce_memory_limit accepts the maximum memory size not the
> maximum address that can be handled by kernel. Fix the function invocation
> accordingly.
>
> Fixes: 1bd14a66ee52 ("RISC-V: Remove any memblock representing unusable memory area")
> Cc: stable@vger.kernel.org
>
> Reported-by: Bin Meng <bin.meng@windriver.com>
> Tested-by: Bin Meng <bin.meng@windriver.com>
> Acked-by: Mike Rapoport <rppt@linux.ibm.com>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> ---
> Changes from v1->v2:
> 1. Added stable-kernel in cc.
> 2. Added reported/tested by tag.
> ---
>  arch/riscv/mm/init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index 13ba533f462b..bf5379135e39 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -176,7 +176,7 @@ void __init setup_bootmem(void)
>  	 * Make sure that any memory beyond mem_start + (-PAGE_OFFSET) is removed
>  	 * as it is unusable by kernel.
>  	 */
> -	memblock_enforce_memory_limit(mem_start - PAGE_OFFSET);
> +	memblock_enforce_memory_limit(-PAGE_OFFSET);
>
>  	/* Reserve from the start of the kernel to the end of the kernel */
>  	memblock_reserve(vmlinux_start, vmlinux_end - vmlinux_start);

Thanks, this is on fixes.
