Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00478623483
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 21:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiKIU1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 15:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiKIU1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 15:27:00 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535902FC17
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 12:26:59 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 130so17753168pfu.8
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 12:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AEzo0Im4rLsC0Jz4I/uQtqWlQCVQMU0Di7BhivJNleg=;
        b=a332E6VYrkuF9zlRA477aAuMJNrBiton1Sw4npiZsoaaeW8kgvFXwDUvTwqW/7Xd4Y
         ZvyW0gqjp92lNld1XYDHIyvCCUfgdM1qbLNGoQL9c8YyP8p4yha9m4ST+twLm4hxVTCn
         /kSg0Ose83LSR+cDDFbbAf4gIf7WRl1VyPMo0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AEzo0Im4rLsC0Jz4I/uQtqWlQCVQMU0Di7BhivJNleg=;
        b=WUZd2jL3mL1ewqYKmToVbqJk0qnIj6Iibzrx3AEWMdevYo5TPCbZ++MymxLRFPO8pF
         tX3hUJ9gsJStFeA6UDwrSDhOftS+azvrljMGYXVkdQ6xXLl/WRgsEXKF/jmaLmbrZ+pS
         BsoDn+nJ7LLJUEps61OPhqLzkftwSF+2jZpprs7dHaCjFuszHPNnrCVbO7MC6WGUEhNm
         V66g0CJhUWHajk3ioG9fWRRlxgIMSKfmAK643kkQgbK204MGjNhjg++kcV0G38fLcj4X
         zLW3qFaV90hJ91ENuDNLqclGQ/Fnq3zIGT2ioimenKDkJ94Wnj8VThKmnAoLjYYdR+Jb
         vtnw==
X-Gm-Message-State: ACrzQf2axAV4ORNMxn3VHFRb5FbbA9CYrlTL4+CKNqsPXvsPxz8QBkAe
        eEnhtSYngTUhfmRapPcdlU2LeA==
X-Google-Smtp-Source: AMsMyM4IjdJUb0+vleHp4Wn+3XtGrV7nxLWGnzRAE/PXG0ao15fsaZcBgJieA6mC86Or1vHKTlnoWg==
X-Received: by 2002:a62:8141:0:b0:56b:c435:f003 with SMTP id t62-20020a628141000000b0056bc435f003mr62551373pfd.15.1668025618778;
        Wed, 09 Nov 2022 12:26:58 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t13-20020a170902e84d00b0017b264a2d4asm9604884plg.44.2022.11.09.12.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 12:26:58 -0800 (PST)
Date:   Wed, 9 Nov 2022 12:26:57 -0800
From:   Kees Cook <keescook@chromium.org>
To:     stable@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Akira Kawata <akirakawata1@gmail.com>,
        linux-hardening@vger.kernel.org
Subject: v5.10.y (was Re: [linux-stable-rc:linux-5.10.y 4906/9423])
 arch/mips/kernel/../../../fs/binfmt_elf.c:823:16: warning: variable
 'load_addr' set but not used)
Message-ID: <202211091218.79009F93@keescook>
References: <202211100224.TrhZPz0k-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202211100224.TrhZPz0k-lkp@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi stable maintainers,

Can you please backport commit

  2b4bfbe09676 ("fs/binfmt_elf: Refactor load_elf_binary function")

to v5.10.y and v5.15.y?

It seems that commit

  0da1d5002745 ("fs/binfmt_elf: Fix AT_PHDR for unusual ELF files")

was backported into v5.10.110 and v5.15.33, but needs the additional
patch for a clean build.

Thanks!

-Kees

On Thu, Nov 10, 2022 at 03:04:25AM +0800, kernel test robot wrote:
> Hi Akira,
> 
> FYI, the error/warning still remains.
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> head:   69a0227f6bd671ba8efa071c58d9f127932e25f2
> commit: dd85ed4af8f5cb42990fb5f42c22d268028693a3 [4906/9423] fs/binfmt_elf: Fix AT_PHDR for unusual ELF files
> config: mips-buildonly-randconfig-r001-20221109
> compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 463da45892e2d2a262277b91b96f5f8c05dc25d0)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install mips cross compiling tool for clang build
>         # apt-get install binutils-mips64el-linux-gnuabi64
>         # https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=dd85ed4af8f5cb42990fb5f42c22d268028693a3
>         git remote add linux-stable-rc https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>         git fetch --no-tags linux-stable-rc linux-5.10.y
>         git checkout dd85ed4af8f5cb42990fb5f42c22d268028693a3
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from arch/mips/kernel/binfmt_elfn32.c:113:
> >> arch/mips/kernel/../../../fs/binfmt_elf.c:823:16: warning: variable 'load_addr' set but not used [-Wunused-but-set-variable]
>            unsigned long load_addr, load_bias = 0, phdr_addr = 0;
>                          ^
>    arch/mips/kernel/binfmt_elfn32.c:86:1: warning: unused function 'jiffies_to_old_timeval32' [-Wunused-function]
>    jiffies_to_old_timeval32(unsigned long jiffies, struct old_timeval32 *value)
>    ^
>    2 warnings generated.
> 
> 
> vim +/load_addr +823 arch/mips/kernel/../../../fs/binfmt_elf.c
> 
>    819	
>    820	static int load_elf_binary(struct linux_binprm *bprm)
>    821	{
>    822		struct file *interpreter = NULL; /* to shut gcc up */
>  > 823		unsigned long load_addr, load_bias = 0, phdr_addr = 0;
>    824		int load_addr_set = 0;
>    825		unsigned long error;
>    826		struct elf_phdr *elf_ppnt, *elf_phdata, *interp_elf_phdata = NULL;
>    827		struct elf_phdr *elf_property_phdata = NULL;

-- 
Kees Cook
