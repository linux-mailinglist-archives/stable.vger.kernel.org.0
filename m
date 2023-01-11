Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DFF665BF6
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 14:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbjAKNCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 08:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbjAKNCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 08:02:07 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927631A803;
        Wed, 11 Jan 2023 05:02:06 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id az7so14947314wrb.5;
        Wed, 11 Jan 2023 05:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pqLXNc7RAugZUpob9cm6wuqqrL/nJ70ZfGAMn/EOoRU=;
        b=jWKM+LIMDWA3ZNABfM0jkH79WXGM5ex+Yxt+pWrtsms6QzD3Zu4XK2SZGuYFLr79Wu
         lSSVUgy78X3xvQ1kDZYqsdphDMFrjIB+pdXWK8j/t4Ox0Vy4IKAd0cdPk3NDmSuS/xPr
         IhSgVOGr188/v+wcrtnOIWJ/48nFb1hnIvLfTaruklUNq5QkrQzzmpRWTqzXBBQKnLaQ
         yJJgkUCSQcmlIgPf469+EuEomKEP9NdlrPEhPAwLv9lPJYj3QLBP0Ku10xrEkh0DKZzJ
         xR4egh9T5CpyRlKyKuR9sl9BTUsiypc6UOtS5irHHnz8iD+1rnmkj9+Uc5oT8t69gedO
         LSPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqLXNc7RAugZUpob9cm6wuqqrL/nJ70ZfGAMn/EOoRU=;
        b=07pIXoHlst1n2SXSHl3JKplO5sERzNl6ph38c+0OFerg1QOFR26q1WCvXHYCDwjGcd
         ebxjxz2wbst92scIFW5Arj3/KNFw02+6CbvJuXLa1fJ12UCbX8O3H0rMqg+Oew/iB4Jt
         /nGyOKOfWi++ibVLLnp6MMdX2DDcNh3rvGgGuhZViVkPl7iqcG+4eWW5I13gyCB3mOzL
         RWPVm/L7r8SYozDqOJ9C47RISk7CkVw8WC3i3qbWqgwqWbRJDWwVbC1/+lTAsaYXZ2am
         Y/+1yZ0c+ZCaLiZXBHw422YtV7pdPOXHvp9wZY3r2OBpygsb05vINVfZHzV4ecLldqBJ
         HttA==
X-Gm-Message-State: AFqh2kod1S6PvK83Rdgf3MZtGIJkvGUxfaySQB5sCQ825dOWgATYvxMV
        3MPDbNSyNnLzCnMQ+XjmzDo=
X-Google-Smtp-Source: AMrXdXtMfWw/+HTr5Jegwc181mbmydBXmrWNAXj7eP79GT4Gn2OPcw2S2rWA3O8Do7z2BdGFUOm48Q==
X-Received: by 2002:a05:6000:5c9:b0:2b0:bc05:b463 with SMTP id bh9-20020a05600005c900b002b0bc05b463mr18143511wrb.7.1673442125180;
        Wed, 11 Jan 2023 05:02:05 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id i5-20020a5d55c5000000b002a6f329203esm13875406wrw.61.2023.01.11.05.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 05:02:04 -0800 (PST)
Date:   Wed, 11 Jan 2023 13:02:03 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/290] 5.15.87-rc1 review
Message-ID: <Y76zS/EtFvJhDlQG@debian>
References: <20230110180031.620810905@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
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

On Tue, Jan 10, 2023 at 07:01:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.87 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2607
[2]. https://openqa.qa.codethink.co.uk/tests/2612
[3]. https://openqa.qa.codethink.co.uk/tests/2615

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
