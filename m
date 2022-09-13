Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912FB5B6C46
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 13:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiIMLRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 07:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbiIMLRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 07:17:52 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE3158099
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 04:17:50 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso11005058pjd.4
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 04:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date;
        bh=C/+G5dQIx4kTVg0j6GrOWzwaZxaPXzGpPc5JIVptdz8=;
        b=iK8bVfjbTJRxm9QuQYo45CMXd8mMSO1TzZbZTdlYfGqtNca/McckN+iFozGRgskvc5
         SrkR5MfBRo6zf56E3t6RHPznd0iGoF0QqARAnkey2CNl7nivK+yeMoy29WZLUkSSKyO8
         RSyF9FoMgNnR3viueo+jCCNlJbI1YMOtuqjqPWiffIBfv9QYeBs1EzhJnmAZfdFiF2fJ
         tJ/jLU7mIiEUuwoZslFLWejd8P9W2klmfyTFhdBh5SoMx+rqsVOnrKAxZYhvuJvqW3d/
         5mfZZ0/bs3pG2IDNH6d3jRqFahDma90yvCbmMrBsZEapsTTir9h8Wg40qwB4PJz91mZP
         fIlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date;
        bh=C/+G5dQIx4kTVg0j6GrOWzwaZxaPXzGpPc5JIVptdz8=;
        b=d13mQ5F+ZXiSgfr+MYTwNfrNKbEQu6kNnEeyCHvHRgi+dkw5GHWHkUItLUAvwI3lGa
         vs8dY/BAi/2vAQFCsyQyNregqymd3+XjV7+uHDge18g4yfDyk2iX89Nv6l/u7mkxQ/N7
         o18xOt2zFrlq8to9uLlvIfft7yCQhST3PhV6MTAnJK60C+on970t6g7Wer6Z3ip6xeBq
         2Qe75JFflAjRb5ExewHv7vLFkACU0MoDlV/C8O761Sm/mgeHk2cFLokwFgk2Fq3XWeyh
         W2LmeFp3wxubUy8Z7otV4CIEZyw0HVJHlte98PhOGw6tZ0E2m9zCP0pIWO12WIp4+JgG
         SW5A==
X-Gm-Message-State: ACgBeo1WncP+maTrFZodjksBOw8ipLLlPwiDHndJ7QcpDWZz8W0T3ym2
        XEbN1T0sm+3QgRgBDJG3ssrw3A==
X-Google-Smtp-Source: AA6agR4CZ3zGEyQYswTvvzdyV0E7DKCMjCk2JlJw0ZN0gs7VE4u3ZOXADy/XvXGgn+JXpLrFX8ZLSQ==
X-Received: by 2002:a17:902:7b8b:b0:170:c7fc:388a with SMTP id w11-20020a1709027b8b00b00170c7fc388amr2409619pll.29.1663067870216;
        Tue, 13 Sep 2022 04:17:50 -0700 (PDT)
Received: from localhost ([185.122.133.20])
        by smtp.gmail.com with ESMTPSA id q5-20020a63e205000000b00434760ee36asm7278389pgh.16.2022.09.13.04.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 04:17:49 -0700 (PDT)
Date:   Tue, 13 Sep 2022 04:17:49 -0700 (PDT)
X-Google-Original-Date: Tue, 13 Sep 2022 04:17:45 PDT (-0700)
Subject:     Re: [PATCH v4] RISC-V: Clean up the Zicbom block size probing
In-Reply-To: <YyBQASDHnbEd6aMq@dev-arch.thelio-3990X>
CC:     mail@conchuod.ie, atishp@atishpatra.org, ajones@ventanamicro.com,
        anup@brainfault.org, conor.dooley@microchip.com, heiko@sntech.de,
        jrtc27@jrtc27.com, linux-riscv@lists.infradead.org, lkp@intel.com,
        mchitale@ventanamicro.com, stable@vger.kernel.org,
        Atish Patra <atishp@rivosinc.com>
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:     nathan@kernel.org
Message-ID: <mhng-d301ef20-cef6-4b10-af21-532227c6f0c7@palmer-ri-x1c9>
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

On Tue, 13 Sep 2022 02:40:17 PDT (-0700), nathan@kernel.org wrote:
> On Mon, Sep 12, 2022 at 11:48:01PM +0100, Conor Dooley wrote:
>> From: Palmer Dabbelt <palmer@rivosinc.com>
>>
>> This fixes two issues: I truncated the warning's hart ID when porting to
>> the 64-bit hart ID code, and the original code's warning handling could
>> fire on an uninitialized hart ID.
>>
>> The biggest change here is that riscv_cbom_block_size is no longer
>> initialized, as IMO the default isn't sane: there's nothing in the ISA
>> that mandates any specific cache block size, so falling back to one will
>> just silently produce the wrong answer on some systems.  This also
>> changes the probing order so the cache block size is known before
>> enabling Zicbom support.
>>
>> CC: stable@vger.kernel.org
>> CC: Andrew Jones <ajones@ventanamicro.com>
>> CC: Heiko Stuebner <heiko@sntech.de>
>> CC: Atish Patra <atishp@rivosinc.com>
>> Fixes: 3aefb2ee5bdd ("riscv: implement Zicbom-based CMO instructions + the t-head variant")
>> Fixes: 1631ba1259d6 ("riscv: Add support for non-coherent devices using zicbom extension")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Reported-by: Conor Dooley <conor.dooley@microchip.com>
>> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
>> [Conor: fixed the redefinition errors]
>> Tested-by: Conor Dooley <conor.dooley@microchip.com>
>> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
>
> Build-tested-by: Nathan Chancellor <nathan@kernel.org>
>
> Thanks a lot for continuing to chase this!

Ya, thanks.  I was actually opening my laptop to try and find the build 
errors for the one I just sent, but this is way easier.  It's on fixes.

>
>> ---
>> Hey Palmer,
>> w/ LPC etc I figure it's highly unlikely you'd have this respun
>> in time to have it applied this week. I dropped all the tested
>> and reviewed -by tags since this patch has been changed a fair
>> bit back and forth since the tags were left. Checked it on my
>> D1 to make sure nothing blew up.. if this could make this weeks
>> rc, that'd be great so that the clang allmodconfig builds are
>> working again.
>> Conor.
>> ---
>>  arch/riscv/errata/thead/errata.c    |  1 +
>>  arch/riscv/include/asm/cacheflush.h |  1 +
>>  arch/riscv/kernel/setup.c           |  2 +-
>>  arch/riscv/mm/dma-noncoherent.c     | 23 +++++++++++++----------
>>  4 files changed, 16 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/riscv/errata/thead/errata.c b/arch/riscv/errata/thead/errata.c
>> index 202c83f677b2..96648c176f37 100644
>> --- a/arch/riscv/errata/thead/errata.c
>> +++ b/arch/riscv/errata/thead/errata.c
>> @@ -37,6 +37,7 @@ static bool errata_probe_cmo(unsigned int stage,
>>  	if (stage == RISCV_ALTERNATIVES_EARLY_BOOT)
>>  		return false;
>>
>> +	riscv_cbom_block_size = L1_CACHE_BYTES;
>>  	riscv_noncoherent_supported();
>>  	return true;
>>  #else
>> diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
>> index a60acaecfeda..a89c005b4bbf 100644
>> --- a/arch/riscv/include/asm/cacheflush.h
>> +++ b/arch/riscv/include/asm/cacheflush.h
>> @@ -43,6 +43,7 @@ void flush_icache_mm(struct mm_struct *mm, bool local);
>>  #endif /* CONFIG_SMP */
>>
>>  #ifdef CONFIG_RISCV_ISA_ZICBOM
>> +extern unsigned int riscv_cbom_block_size;
>>  void riscv_init_cbom_blocksize(void);
>>  #else
>>  static inline void riscv_init_cbom_blocksize(void) { }
>> diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
>> index 95ef6e2bf45c..2dfc463b86bb 100644
>> --- a/arch/riscv/kernel/setup.c
>> +++ b/arch/riscv/kernel/setup.c
>> @@ -296,8 +296,8 @@ void __init setup_arch(char **cmdline_p)
>>  	setup_smp();
>>  #endif
>>
>> -	riscv_fill_hwcap();
>>  	riscv_init_cbom_blocksize();
>> +	riscv_fill_hwcap();
>>  	apply_boot_alternatives();
>>  }
>>
>> diff --git a/arch/riscv/mm/dma-noncoherent.c b/arch/riscv/mm/dma-noncoherent.c
>> index cd2225304c82..e3f9bdf47c5f 100644
>> --- a/arch/riscv/mm/dma-noncoherent.c
>> +++ b/arch/riscv/mm/dma-noncoherent.c
>> @@ -12,7 +12,7 @@
>>  #include <linux/of_device.h>
>>  #include <asm/cacheflush.h>
>>
>> -static unsigned int riscv_cbom_block_size = L1_CACHE_BYTES;
>> +unsigned int riscv_cbom_block_size;
>>  static bool noncoherent_supported;
>>
>>  void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
>> @@ -79,38 +79,41 @@ void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
>>  void riscv_init_cbom_blocksize(void)
>>  {
>>  	struct device_node *node;
>> +	unsigned long cbom_hartid;
>> +	u32 val, probed_block_size;
>>  	int ret;
>> -	u32 val;
>>
>> +	probed_block_size = 0;
>>  	for_each_of_cpu_node(node) {
>>  		unsigned long hartid;
>> -		int cbom_hartid;
>>
>>  		ret = riscv_of_processor_hartid(node, &hartid);
>>  		if (ret)
>>  			continue;
>>
>> -		if (hartid < 0)
>> -			continue;
>> -
>>  		/* set block-size for cbom extension if available */
>>  		ret = of_property_read_u32(node, "riscv,cbom-block-size", &val);
>>  		if (ret)
>>  			continue;
>>
>> -		if (!riscv_cbom_block_size) {
>> -			riscv_cbom_block_size = val;
>> +		if (!probed_block_size) {
>> +			probed_block_size = val;
>>  			cbom_hartid = hartid;
>>  		} else {
>> -			if (riscv_cbom_block_size != val)
>> -				pr_warn("cbom-block-size mismatched between harts %d and %lu\n",
>> +			if (probed_block_size != val)
>> +				pr_warn("cbom-block-size mismatched between harts %lu and %lu\n",
>>  					cbom_hartid, hartid);
>>  		}
>>  	}
>> +
>> +	if (probed_block_size)
>> +		riscv_cbom_block_size = probed_block_size;
>>  }
>>  #endif
>>
>>  void riscv_noncoherent_supported(void)
>>  {
>> +	WARN(!riscv_cbom_block_size,
>> +	     "Non-coherent DMA support enabled without a block size\n");
>>  	noncoherent_supported = true;
>>  }
>> --
>> 2.37.1
>>
