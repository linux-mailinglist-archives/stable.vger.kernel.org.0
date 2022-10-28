Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B4C610EF1
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 12:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiJ1Krd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 06:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiJ1Krc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 06:47:32 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519A4754AA;
        Fri, 28 Oct 2022 03:47:31 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id y16so6044006wrt.12;
        Fri, 28 Oct 2022 03:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bZv3xe99I0nEe32L6nfXcN5gC17kri0ebuJE/A25Q8k=;
        b=I4HJb9lV196cv2WwDCiZd9zgZ+PZTX147z9GDMAX+Qh1gES9BGYOO+K0obrtLTXviV
         6D/8CHz+iOjfeprKH78+KbAklC7b7hvfSqoiGEjnEG2Ur6jTu1j5JbtojKjOlJ4x1+NB
         1wf6o2fGWIW2VO88QgKXT16yYaUpZ1uEXMNj9AoNmNTn4ciqyOKnRrSnCCqfs1EVOkHu
         8BTv+PNy8YBu6qlrQzsSfYHVG9y2atFwXuw/zSFFnpaBflWaCe8TypmamQs1YV++ID2w
         xmBL9bH9zJIrTjhBUw44T6WQZuk0f15M2KTobyMvz0K0er7uDUwaxUlPY9rQn32mYm3i
         eLYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bZv3xe99I0nEe32L6nfXcN5gC17kri0ebuJE/A25Q8k=;
        b=k07VketX/v2bFbHGlbpomceBkLutK4xM9NwKpy3h6nFe4y8gzTvjHi3DOdb17uGCD6
         TzEJ5iMLb3Sf5jcxye/xdsPe4Jeux7cbN0BHF915X9y+09C3/C/xiOwrDvRYtQHrh5wG
         MfhXJVUQ3E94QPZSWeQX4P2jkt7RwxQOQyDhwjaGvt4s7u3zAlBW9cBnZmQbrdoh9IyT
         nQ5AUfrnV2U1IO6iM1oIvyOyJIR5AKM4oH96LhLDVW7BXhF+Srzdcy7tZPAPXvy5ivbW
         QlP0JrQ5UsbIZKajjYfy68/B0UKKVXLsByTutasqjKIDFnQ7Pcp1Jz+GfG9RSnezl+0w
         cTGQ==
X-Gm-Message-State: ACrzQf1knTmhy1eydY8oAFgIbtL/6RWnoOXbiAQTKAt6xa/c03bVy2ne
        JRdvAylI0alfXw5+vOeKtWI+PE8GPiw=
X-Google-Smtp-Source: AMsMyM4EnIe36SdbTUZxD5Pl4sYNC1GRsKYx4h/V01jucFOG7DQZOrGlrDGeSZuN7ihSYvOCcSLKnQ==
X-Received: by 2002:a5d:484f:0:b0:236:9c97:6f85 with SMTP id n15-20020a5d484f000000b002369c976f85mr3538969wrs.636.1666954049776;
        Fri, 28 Oct 2022 03:47:29 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id k21-20020a05600c1c9500b003bfaba19a8fsm4232287wms.35.2022.10.28.03.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 03:47:29 -0700 (PDT)
Date:   Fri, 28 Oct 2022 11:47:27 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/79] 5.10.151-rc1 review
Message-ID: <Y1uzP3FJibb1UIlt@debian>
References: <20221027165054.270676357@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
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

On Thu, Oct 27, 2022 at 06:55:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.151 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> 1 failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
1) arm64 allmodconfig fails to build with the error:
In file included from drivers/cpufreq/tegra194-cpufreq.c:10:
drivers/cpufreq/tegra194-cpufreq.c:245:25: error: 'tegra194_cpufreq_of_match' undeclared here (not in a function); did you mean 'tegra194_cpufreq_data'?
  245 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/module.h:241:15: note: in definition of macro 'MODULE_DEVICE_TABLE'
  241 | extern typeof(name) __mod_##type##__##name##_device_table               \
      |               ^~~~
./include/linux/module.h:241:21: error: conflicting types for '__mod_of__tegra194_cpufreq_of_match_device_table'; have 'const struct of_device_id[2]'
  241 | extern typeof(name) __mod_##type##__##name##_device_table               \
      |                     ^~~~~~
drivers/cpufreq/tegra194-cpufreq.c:380:1: note: in expansion of macro 'MODULE_DEVICE_TABLE'
  380 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
      | ^~~~~~~~~~~~~~~~~~~
./include/linux/module.h:241:21: note: previous declaration of '__mod_of__tegra194_cpufreq_of_match_device_table' with type 'int'
  241 | extern typeof(name) __mod_##type##__##name##_device_table               \
      |                     ^~~~~~
drivers/cpufreq/tegra194-cpufreq.c:245:1: note: in expansion of macro 'MODULE_DEVICE_TABLE'
  245 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
      | ^~~~~~~~~~~~~~~~~~~

git bisect pointed to a327a52c9930 ("cpufreq: tegra194: Fix module loading")

2) Already reported by others:
scripts/pahole-flags.sh: Permission denied


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2047
[2]. https://openqa.qa.codethink.co.uk/tests/2053


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
