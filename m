Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9EDA4B1468
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 18:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245241AbiBJRk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 12:40:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245239AbiBJRkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 12:40:23 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0498625C2
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 09:40:24 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id c5-20020a17090a1d0500b001b904a7046dso7751812pjd.1
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 09:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=myBRZosts+JYJ5LwNGhf9v9p6lhlpsXAJiru0hFcO1Y=;
        b=aAjlLmerWaHRMPPmnTh/eMVQdksaqsQCPlhAeUmrvIzXcASlboU4inkIhxwnKYimuX
         0GK/6q/yCs/SCXeQKr4c7hI0xr8pT1gDiF1qkPN6HK85ueijua7rkyxNcWmxmbtGYkA+
         XyJijfGX6awchUj1c/r4uFmj8MGuCbhp6wB+uCEp3dtc9bsPBl4JFWBOa1tMRs0P/a9z
         U9lvKPUmipoEAqvwv6YU3Ne/vdwUqpn13CQSKM0n7Wf+QK2z5UXLsoVb60FWIBqEdWiG
         JdqxpprYHd09U2Ql3L5jib441sfzNu0TC/uX+ZPBGXQWJPLCk4tTLMoEzalbHSFlihR6
         nw7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=myBRZosts+JYJ5LwNGhf9v9p6lhlpsXAJiru0hFcO1Y=;
        b=A0B6uLLtcaNmqEd7vFWI5rBI0M60VT15vhmUHqKRkMyPUEiAIQKVRDzJek962Fi3S4
         HIaFN0sck0HCN9DuBYdpEbc/BPHcLTC08S8RXyWpZTELmCa41mnvpZHWeF3B+MqqeELd
         1SRPj9zxb93Hb6Q5eSBgVxj9hLlzDHCSXa2waZoaQ2XR0rtCyG5+rAmt/YOHvhcJUpcb
         lxYamfUrKPcKRb6Gr9fce3DwXVCdHN+zmPM23DjA7t4/SeEBJAtZlrhtpeCIe8ahoy1b
         Wa1cIivd7gjV+B0Dv0piKqcX0dJ4gfg5vxyput9JzFW4MqRs5ZNmE7mIZg6mTdCdj2Iu
         z1HA==
X-Gm-Message-State: AOAM533WHcA1wFogVghKAhQosY+g16A/PYplOlFjBwdj1+pYodVfiXQk
        zqLcIiMM2JxNzC78ydq1tMBXyQ==
X-Google-Smtp-Source: ABdhPJxeY8H0Yf3skfinMnvJcXTVOjBVIkFb5XNq6b1nnadRiC17Tlj1rfV9YuSzkMcJtKm+OiXkig==
X-Received: by 2002:a17:90b:1b46:: with SMTP id nv6mr3878148pjb.143.1644514823391;
        Thu, 10 Feb 2022 09:40:23 -0800 (PST)
Received: from localhost ([12.3.194.138])
        by smtp.gmail.com with ESMTPSA id g5sm23970235pfv.22.2022.02.10.09.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 09:40:22 -0800 (PST)
Date:   Thu, 10 Feb 2022 09:40:22 -0800 (PST)
X-Google-Original-Date: Thu, 10 Feb 2022 09:39:36 PST (-0800)
Subject:     Re: [PATCH] riscv: fix build with binutils 2.38
In-Reply-To: <20220126171442.1338740-1-aurelien@aurel32.net>
CC:     linux-kernel@vger.kernel.org, aurelien@aurel32.net,
        stable@vger.kernel.org, Kito Cheng <kito.cheng@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu,
        linux-riscv@lists.infradead.org (open list:RISC-V ARCHITECTURE)
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     aurelien@aurel32.net
Message-ID: <mhng-f5101f2f-eb08-4e20-8cb3-b7d267ba25bc@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Jan 2022 09:14:42 PST (-0800), aurelien@aurel32.net wrote:
> From version 2.38, binutils default to ISA spec version 20191213. This
> means that the csr read/write (csrr*/csrw*) instructions and fence.i
> instruction has separated from the `I` extension, become two standalone
> extensions: Zicsr and Zifencei. As the kernel uses those instruction,
> this causes the following build failure:
>
>   CC      arch/riscv/kernel/vdso/vgettimeofday.o
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h: Assembler messages:
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>
> The fix is to specify those extensions explicitely in -march. However as
> older binutils version do not support this, we first need to detect
> that.
>
> Cc: stable@vger.kernel.org # 4.15+
> Cc: Kito Cheng <kito.cheng@gmail.com>
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> ---
>  arch/riscv/Makefile | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> index 8a107ed18b0d..7d81102cffd4 100644
> --- a/arch/riscv/Makefile
> +++ b/arch/riscv/Makefile
> @@ -50,6 +50,12 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
>  riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
>  riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
>  riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
> +
> +# Newer binutils versions default to ISA spec version 20191213 which moves some
> +# instructions from the I extension to the Zicsr and Zifencei extensions.
> +toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zicsr_zifencei)
> +riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
> +
>  KBUILD_CFLAGS += -march=$(subst fd,,$(riscv-march-y))
>  KBUILD_AFLAGS += -march=$(riscv-march-y)

Thanks, this is on fixes.  It's CC stable, but doesn't have a "Fixes" 
tag -- I did that on purpose as this isn't really fixing a bug in Linux 
so I'm not sure it's right to point at a particular patch, but I'm not 
sure how that will play with the stable tree.
