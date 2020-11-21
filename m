Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C892BBABB
	for <lists+stable@lfdr.de>; Sat, 21 Nov 2020 01:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgKUAON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 19:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbgKUAON (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 19:14:13 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B56C061A04
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 16:14:12 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 34so8696856pgp.10
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 16:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=uKqWBXY7mffdyrXuPqWycdmx7WjMxlzQo4Hepbp5MLA=;
        b=MGiQ7+/4djIxMNoiGQ2HQ5FgX0BiX7MECdXbKPZQNck9BCSf+vD2+mluHPNMzxP+cG
         RI0JpcoQox5J9JpacWYIlNvbSs1OrmSiauOJ68nqJB8tYnVuKuPBYc8FcY1jjqvArHkA
         I6HVsM1vDIu+1mfN0Wl7aQWjh2gsxwta3wtgwqJ9oZ+fcL+3/zZ0LOLgvGnvXFaqMwCj
         hL03GrfM7phnxuW/StGxVHtcBP2ondXPfL4j3l6zj5t+qWg1haT1vASUsL4Qti5hi+nw
         5coIoF1phUpLhxGUIGQtFXzot8Pa+T381k+CAFNX/BgZfUyxMNe2Zr9rrHM2tF0Z1vRx
         MYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=uKqWBXY7mffdyrXuPqWycdmx7WjMxlzQo4Hepbp5MLA=;
        b=qaAhHRtPSnbgRjnnv1R9/3nkWSB2auIOsy1oyymLbYCBNkEfFGdZNS/ue3Il77py0r
         laXCv0CuZZGYFT9P59XknY/KlUA+lPxGGa0wO0abXtA970pD5SveTaqtrPUdHcGgMFXv
         b48U1t695YCpD/95rOj12yuJv/KDXdChZUkB2CTVP3YPIJZ5QyoFdgUaGgHFioHskqBa
         t1E5N1xc1nHZQeu86qxCTCFxInKTqpllDah9aIPpVU2u8jydmDUSs2LHcDgV/+RroQkX
         0tKU4GODxxfgzxCWWkQTNd9oQAffdiYA9n8UAJmn4bqiEg+mQM/pYo8ZCvm0zdgzb0Qo
         OcUA==
X-Gm-Message-State: AOAM533rfIRGtVibQcxkPK3EazxIQdxFIDUIZVl1/WR0gtPgnQNEHYPd
        elJvZAfUCAyQy92CPSjaoN+doQ==
X-Google-Smtp-Source: ABdhPJwimHlEuo6JCbvv0hg1vOC1+1xFeCDf/huX/AovS5V1x99g1hDelggACAaCxCijehAiqasUPg==
X-Received: by 2002:a05:6a00:1684:b029:18b:665e:5211 with SMTP id k4-20020a056a001684b029018b665e5211mr15948880pfc.20.1605917652295;
        Fri, 20 Nov 2020 16:14:12 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id s4sm5432591pjr.44.2020.11.20.16.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 16:14:11 -0800 (PST)
Date:   Fri, 20 Nov 2020 16:14:11 -0800 (PST)
X-Google-Original-Date: Fri, 20 Nov 2020 16:14:07 PST (-0800)
Subject:     Re: [PATCH] RISC-V: Add missing jump label initialization
In-Reply-To: <20201106075359.3401471-1-anup.patel@wdc.com>
CC:     Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        anup@brainfault.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <Anup.Patel@wdc.com>,
        stable@vger.kernel.org
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     Anup Patel <Anup.Patel@wdc.com>
Message-ID: <mhng-f4c607c8-ecf6-4eda-88de-4011214fcb33@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 05 Nov 2020 23:53:59 PST (-0800), Anup Patel wrote:
> The jump_label_init() should be called from setup_arch() very
> early for proper functioning of jump label support.
>
> Fixes: ebc00dde8a97 ("riscv: Add jump-label implementation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> ---
>  arch/riscv/kernel/setup.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
> index c424cc6dd833..117f3212a8e4 100644
> --- a/arch/riscv/kernel/setup.c
> +++ b/arch/riscv/kernel/setup.c
> @@ -75,6 +75,7 @@ void __init setup_arch(char **cmdline_p)
>  	*cmdline_p = boot_command_line;
>
>  	early_ioremap_setup();
> +	jump_label_init();
>  	parse_early_param();
>
>  	efi_init();

Thanks, this is on fixes.
