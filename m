Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDD0610ECC
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 12:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiJ1KlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 06:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiJ1Kki (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 06:40:38 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD9B7297A;
        Fri, 28 Oct 2022 03:40:34 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v1so6044396wrt.11;
        Fri, 28 Oct 2022 03:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=npZqZL/yF7shR5Td9quI9yGGYInF9TqZUnTzGHdA92o=;
        b=dg5IsF/H+hz7i3NSGRAlBtEt/wFjyxBAnatiZAqLYMPrycv4DChnIjF0FgBNzyaHqI
         teYn042KGPEW6nLcAgKE99LJ8OtXpLbht/YxfXPKO4wmIsHS1ENgbmn5rchi7G8iEDgn
         uGtLbEzvCfz29cn7OrRc+RSJBdcLWuQCCKRPes7+/RcDKb6L0dkVKwj2fCtwuIN8oPMo
         cAHEvsiB12DsmWBCCJaDhoZ2LUmULE+GYRWQpPX73rzB+eCoXeGH0b1gqX0LhVXSueUl
         9xd7F4+b/Jbw/IUPuT/ukY8Gt5tSvbMrDmVVlpACSRLWvi9zZG1+Ln3rSND5JkrqlNmN
         gaoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=npZqZL/yF7shR5Td9quI9yGGYInF9TqZUnTzGHdA92o=;
        b=MZV2+SV63qA9GGlFwWc1oYEgQhRtuix2Na1KA5ZSYhYVfl0TGiinR4SMCBCiTjDfF4
         Vo5aR/thrEbgsnmm0J1q3+Tvh4+soEflX9HeRvD++rMz1EOi3clBhQtGLRYJZQ1pH8u+
         9Fbf1puDa9ldRmAA5hQ/igjGPtsSTyjj8DzoF1JUpOl6sOvRtN8MsJmnzd0ovCXBXsic
         FSYjjm4itVda1hhq007jnmkukveLwLyhyRTChZW30WrPxOD3OM8EEpReqklwgyRlWPEQ
         Ij4UTFxf3hp8+p9lpcApq92IIF8eOJuflj+quAE/5spGnGZNRxkxhk4sZjeYWQ2SI5ch
         j05w==
X-Gm-Message-State: ACrzQf3Wowir9kajqg9SnrLubhn9nG6VdRPm7ugSd/AzeTtG/89tlyqN
        Yv4Iz7NU9CtxbsQnFJzFtmE=
X-Google-Smtp-Source: AMsMyM4Hp1N50SiDrBY4fxwzgX8dPwHRBHO5mn6WfdGCIXtVUU9b3gbkH1oQ9w9iLeL2nVBQ8WVfcw==
X-Received: by 2002:adf:cf06:0:b0:236:4c12:47a7 with SMTP id o6-20020adfcf06000000b002364c1247a7mr25864128wrj.543.1666953633283;
        Fri, 28 Oct 2022 03:40:33 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id 26-20020a05600c029a00b003c4ecff4e25sm4115128wmk.9.2022.10.28.03.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 03:40:33 -0700 (PDT)
Date:   Fri, 28 Oct 2022 11:40:31 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/79] 5.15.76-rc1 review
Message-ID: <Y1uxn8/y6AjCu4UU@debian>
References: <20221027165054.917467648@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Oct 27, 2022 at 06:54:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.76 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> 1 failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
1) arm64 allmodconfig fails with the error:

In file included from drivers/cpufreq/tegra194-cpufreq.c:10:
drivers/cpufreq/tegra194-cpufreq.c:282:25: error: 'tegra194_cpufreq_of_match' undeclared here (not in a function); did you mean 'tegra194_cpufreq_data'?
  282 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/module.h:244:15: note: in definition of macro 'MODULE_DEVICE_TABLE'
  244 | extern typeof(name) __mod_##type##__##name##_device_table               \
      |               ^~~~
./include/linux/module.h:244:21: error: conflicting types for '__mod_of__tegra194_cpufreq_of_match_device_table'; have 'const struct of_device_id[2]'
  244 | extern typeof(name) __mod_##type##__##name##_device_table               \
      |                     ^~~~~~
drivers/cpufreq/tegra194-cpufreq.c:417:1: note: in expansion of macro 'MODULE_DEVICE_TABLE'
  417 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
      | ^~~~~~~~~~~~~~~~~~~
./include/linux/module.h:244:21: note: previous declaration of '__mod_of__tegra194_cpufreq_of_match_device_table' with type 'int'
  244 | extern typeof(name) __mod_##type##__##name##_device_table               \
      |                     ^~~~~~
drivers/cpufreq/tegra194-cpufreq.c:282:1: note: in expansion of macro 'MODULE_DEVICE_TABLE'
  282 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
      | ^~~~~~~~~~~~~~~~~~~

Same error as v5.10.y, should be for b281adc68db8 ("cpufreq: tegra194: Fix module loading").


2) Already reported by others:
/bin/sh: 1: ./scripts/pahole-flags.sh: Permission denied


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2051
[2]. https://openqa.qa.codethink.co.uk/tests/2054

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
