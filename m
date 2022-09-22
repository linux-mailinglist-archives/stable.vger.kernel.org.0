Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45E55E5FFD
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 12:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiIVKfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 06:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiIVKfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 06:35:46 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981BFA99EF;
        Thu, 22 Sep 2022 03:35:42 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id n10so14748843wrw.12;
        Thu, 22 Sep 2022 03:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=9v6mVU1WqfKgswYBiMMty1DU6X+u00sWAmgzz2dqVp8=;
        b=p70rBtPOpb1zDNagtYBY6UUzK4yFmaK4pd+6xZfgEv85Bc9Avws8YLyOvZJ9+u/ZH/
         jCr/QIKPvPPv/05m/R8WHawzD4hIEuN2nJF6EtRu4CXwMhSwm4QaX0T1BIhk/hFKF30S
         Ii5z0GCXEhzknRf7GPqJtZnyR8KWtErep9bYOCxz720rU6D5GUMQ+lWfL13jYqgAkocT
         3uZCN5hsr28euXwU88TnXNa6FhdoIWwWcHmuyDhsk/tHCeBZG2Hb3/DPG6qS+TDun1UL
         tgwY/4D5Pof0VMdbiuiawEXjdp/qpBPo9uonRyKqPS8RVVoLep5SAC6uPDa6h7sM3FoJ
         Lt3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=9v6mVU1WqfKgswYBiMMty1DU6X+u00sWAmgzz2dqVp8=;
        b=HXiLEHOkwI18/B3DWhIsyC3glL+Yl+h3gP+vvMRTNYOor35m/AMOn3a8jvHRiOEkCE
         Hbb2QJi12fx9/XVQEMCRKYu0wDMmsJpARIAPu2Y0+o/x/idjd1SFm2Z/2W5OmaqVNIbH
         nNVE2ATU1iIVaTPCSCpLa6Kjgsrwm9xnWwhh0r2Oj72u687kqRM7qaEApsGHLh6uG4RE
         9UJGdGGUuzv6GG3D1KwlxKBaZZ2qLXMx+Ab+zirrgMHT0IsJF8zZNHS/QRWHxGaULmgC
         k6sJa68wTAjlcKL2k4vKa+fnSUpDzSwXfgR5iJ8jC/qivmrpQfqb0+8DF4CDCj7mPlqi
         9aFw==
X-Gm-Message-State: ACrzQf0MokubLJZ1/8DEm3M0LmvExDQirEso9BhGzwf6xt00s8DVDcqg
        wpX5lhjzbSl2S7FsugMFufw=
X-Google-Smtp-Source: AMsMyM4qsi+ChJCCUW5N9lDZDTIqfVepWxsFvkm3FLzztvxcnsqIu24cpLVB+ZpKagyL10UXMNx5Og==
X-Received: by 2002:a05:6000:1b90:b0:22a:c3a9:6567 with SMTP id r16-20020a0560001b9000b0022ac3a96567mr1557915wru.118.1663842940905;
        Thu, 22 Sep 2022 03:35:40 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id w8-20020a1cf608000000b003a5fa79007fsm5449474wmc.7.2022.09.22.03.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 03:35:40 -0700 (PDT)
Date:   Thu, 22 Sep 2022 11:35:38 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/45] 5.15.70-rc1 review
Message-ID: <Yyw6es9RdujAwChq@debian>
References: <20220921153646.931277075@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sudip,

On Wed, Sep 21, 2022 at 05:45:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.70 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220919):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> 2 failures
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

arm64 allmodconfig and rpi4 config have failed with the error: (fails with both gcc-12 and gcc-11).

arch/arm64/kernel/kexec_image.c:136:23: error: 'kexec_kernel_verify_pe_sig' undeclared here (not in a function); did you mean 'arch_kexec_kernel_verify_sig'?
  136 |         .verify_sig = kexec_kernel_verify_pe_sig,
      |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
      |                       arch_kexec_kernel_verify_sig


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
mips: Booted on ci20 board. No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1873
[2]. https://openqa.qa.codethink.co.uk/tests/1881

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
