Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F161E9F3A
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 09:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgFAH2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 03:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgFAH2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 03:28:30 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCDFC061A0E;
        Mon,  1 Jun 2020 00:28:29 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id u10so5620941ljj.9;
        Mon, 01 Jun 2020 00:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BBe6T/3LS4JSLNfgPLNajhJmTJr3qtIpazZpi3iyWb8=;
        b=pG3QomC1RJfQ4wefhmHFJsR2DcluF0w7NrqzmzjFCBDjyhbn8Bm1Qs/nKW+yV4fVWP
         viOmsoUUjECk+au/UtbO5RFs4fAW7HQZclRm+WoeMHy9ZdOT1Uq3hy91yiI0ZkuN+9Lv
         Jvaq0NU4BPSCTHtV4gwJujfEDH4xqB/8HpX7VWKwFLGH0THyIxagWgNhUWeqCyWWo4Ic
         d0mWuoFUkFTmOZ4aEpN9f3p2M+844ry9YeNfcBFm13Q0ncT7hBeAcoZgrSD4j+myALgk
         BL6Ci/Fw1qIU67pAHk/S0APvRXW5AyyrXkYbu0qrHUt/tDbK66iRdi1WjdaMn/UiH1Wd
         PUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BBe6T/3LS4JSLNfgPLNajhJmTJr3qtIpazZpi3iyWb8=;
        b=j4uxxPXbWQfnNK5KhvwyModlqSdv8h8WLIsU8Z+hNKBDpQFsIEkGDI8OslFMFMpmfR
         ueFs2s1W+k8MvKo0/Ut+XMeyc1CwX3zm9H0p76UaAX7ZwqSXB64Iq3doWJqRvNqWVtyt
         UK/DzKI3FREEi++58DgbSj4KoVszGKGxDlOxcPzT0tJhoWzh4fkoXRmt8fDb17x+DHYI
         8zZTFjrQWbV2dxR2OR7z2HX2t4juh1N1rQc8jyJX/Vsq/K5RwotikB5nlbgz0UbcpZuR
         Vs2wWiI1UVfR+szN5thO1uWg1FcTzdfRCc+WDjmP/IPYgg5oVWjdF/uUH2niNxErgAgF
         TgdQ==
X-Gm-Message-State: AOAM532aOsaeQGv+ZwcQA1z/yXDvOXnBwl2MaMiOvtHaxOTyww+Fyyw/
        Ui0SoDcMLuf04abFyXX5G0gpGOIEFOiDIfD06kpOwhsL
X-Google-Smtp-Source: ABdhPJxHuJXB6Vn99Phe2TsgG6tcoUL6B/cEvgbi4CzCvlGLlZSYpicDYyOy/nYAXwxOdZuspbFik0jB6Fzn4xxehFY=
X-Received: by 2002:a2e:581a:: with SMTP id m26mr787094ljb.0.1590996508261;
 Mon, 01 Jun 2020 00:28:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200601050656.826296-1-anup.patel@wdc.com>
In-Reply-To: <20200601050656.826296-1-anup.patel@wdc.com>
From:   Zong Li <zongbox@gmail.com>
Date:   Mon, 1 Jun 2020 15:28:19 +0800
Message-ID: <CA+ZOyaixYnRkYGz8LpPdgx7P6s=ZxcXvJh=EUwq9BoY2zxO_=g@mail.gmail.com>
Subject: Re: [PATCH v2] RISC-V: Don't mark init section as non-executable
To:     Anup Patel <anup.patel@wdc.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Anup Patel <anup.patel@wdc.com> =E6=96=BC 2020=E5=B9=B46=E6=9C=881=E6=97=A5=
 =E9=80=B1=E4=B8=80 =E4=B8=8B=E5=8D=881:07=E5=AF=AB=E9=81=93=EF=BC=9A
>
> The head text section (i.e. _start, secondary_start_sbi, etc) and the
> init section fall under same page table level-1 mapping.
>
> Currently, the runtime CPU hotplug is broken because we are marking
> init section as non-executable which in-turn marks head text section
> as non-executable.
>
> Further investigating other architectures, it seems marking the init
> section as non-executable is redundant because the init section pages
> are anyway poisoned and freed.
>
> To fix broken runtime CPU hotplug, we simply remove the code marking
> the init section as non-executable.
>
> Fixes: d27c3c90817e ("riscv: add STRICT_KERNEL_RWX support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> ---
> Changes since v1:
>  - Updated free_initmem() is same as generic free_initmem() defined in
>    init/main.c so we completely remove free_initmem() from arch/riscv
> ---
>  arch/riscv/mm/init.c | 11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index 736de6c8739f..fdc772f57edc 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -479,17 +479,6 @@ static void __init setup_vm_final(void)
>         csr_write(CSR_SATP, PFN_DOWN(__pa_symbol(swapper_pg_dir)) | SATP_=
MODE);
>         local_flush_tlb_all();
>  }
> -
> -void free_initmem(void)
> -{
> -       unsigned long init_begin =3D (unsigned long)__init_begin;
> -       unsigned long init_end =3D (unsigned long)__init_end;
> -
> -       /* Make the region as non-execuatble. */
> -       set_memory_nx(init_begin, (init_end - init_begin) >> PAGE_SHIFT);
> -       free_initmem_default(POISON_FREE_INITMEM);
> -}
> -
>  #else
>  asmlinkage void __init setup_vm(uintptr_t dtb_pa)
>  {
> --
> 2.25.1
>
>

It looks good to me.
Reviewed-by: Zong Li <zong.li@sifive.com>
