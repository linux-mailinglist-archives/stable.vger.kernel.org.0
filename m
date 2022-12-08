Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1509646C0C
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 10:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiLHJlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 04:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiLHJlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 04:41:17 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85F7275D9;
        Thu,  8 Dec 2022 01:41:16 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id n9-20020a05600c3b8900b003d0944dba41so584247wms.4;
        Thu, 08 Dec 2022 01:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t/oPdE8gI0My+jyuLY5X8msXAYGJqJBO3dcAoMyxSeI=;
        b=V9YCC1LOdSgHtVHqLHwIGdi/z9Ap2kwdQgcpzzRJx3WDkpvyTH31dTEZRd5OEGcFhJ
         BgOsR/ooYablm73a7xOHX6hBaRLqjpcFeFnmse4P2Sf9Rp73KMcfdbZBQWfhVrJR4/sr
         lnF0uuKKO6ljzpC1zNwdSNGu+phtX6xR3E+n4cTaoyCxWKCdBZ2NtiwIf52Quwwv5QAl
         9UF0DG4BRpJeQ+lXPrnvhsDh8qdOFqE+7tHWQLHWVV4V/2F2pW5k5ytZGMRNwPe0EKdx
         NznCu8lQBjKI2Td4Fr/Q7XZdnRym5eByDc1wgj63GfyBRKTNaX9lhn5wVvsJH7XLwMvj
         zDVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/oPdE8gI0My+jyuLY5X8msXAYGJqJBO3dcAoMyxSeI=;
        b=hffOETFkEmKQYSwzSM62lcBHC+fY6hiZc72RIpegMLuV8ZOGHRV/0pYLzGbwp8cSvP
         w5F03WV5P0ypV4NpCNIAOAxQHB8IjyB4osRgoWB3qoLp+1LlWIptsNoO+5Nb9uniDZHf
         BrG1KLCA1ve2Lpj1cTRpUCKPxGPb++n8fSdiPKDJY5xbK/OBb1r6oVYNW+ryBQNhrPsh
         db3nkZfmT78Isxl88ZcgzolgNZJQTCL4vJ2TZ+6WYqj8p4UFnh0CblbzcRgZSYbYCxxM
         iBgkwCxzR0ZtRG41xMGUAzOp+6CAGm+fMJ3tiEsJpPF6dKapt9XLt9b5Dsh7LAIIKBql
         t8Yw==
X-Gm-Message-State: ANoB5pmBkkarIEK5QZyWzIkwcJ5lLT+P7mnRciUdRwM98+tjRZeQ3EWU
        +scS/fX1he2dsmiNefk56YA=
X-Google-Smtp-Source: AA0mqf50LTcRbr+w2TD++ye3fbkl3KEWmpYtOfrY0O9yaYSbB5UoVo5D0b6TEozCGUCht+jCnsFS3g==
X-Received: by 2002:a05:600c:539a:b0:3cf:8957:806e with SMTP id hg26-20020a05600c539a00b003cf8957806emr1708520wmb.5.1670492475272;
        Thu, 08 Dec 2022 01:41:15 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id q21-20020a7bce95000000b003d1de805de5sm4303221wmj.16.2022.12.08.01.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 01:41:15 -0800 (PST)
Date:   Thu, 8 Dec 2022 09:41:13 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/96] 5.10.158-rc2 review
Message-ID: <Y5GxObmE5m/QyVgQ@debian>
References: <20221206124048.850573317@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124048.850573317@linuxfoundation.org>
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

On Tue, Dec 06, 2022 at 01:42:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.158 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2313
[2]. https://openqa.qa.codethink.co.uk/tests/2310


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
