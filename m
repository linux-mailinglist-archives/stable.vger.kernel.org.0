Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA60859AD07
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 11:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343993AbiHTJxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 05:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343944AbiHTJxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 05:53:17 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82059E65;
        Sat, 20 Aug 2022 02:53:15 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id l33-20020a05600c1d2100b003a645240a95so1209710wms.1;
        Sat, 20 Aug 2022 02:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=yTmsNckNaAZ+29w7J9XGVeljRtaRfGzpOqqruunQXzE=;
        b=AlXZQgqol+ZQyYLLlNe6RE30IbbK4i+2hruYi71ZcbzDIh4uwlmRtZa8ZezQLM9CKH
         Mwfepj5zZ3WB/LnhrR42Hvk3hRAisfyWGwwWuqJmuBXPQLPRbcKvJpHhjN491turXReH
         J3UCfP6Tms2r+AQ6OyzZeEKsHriKLhr78lkJPy4s/z7J4LutVDWnACf6smV/yr+Y6YAZ
         CUI6O4hpSAojf4uPh+9b64DF+Hsq57Yw1z4ROo3tZaK0tWvfGYsCTG+jVPgDCPIayM+d
         u4s7EtO0s0ZhEV4gLLot0HuMfS7E6misvcoed0eIDcFhPPt373QEHVf3oSBknoFxj+1C
         CyMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=yTmsNckNaAZ+29w7J9XGVeljRtaRfGzpOqqruunQXzE=;
        b=DGtow8nFIMdHb+KMZXMAIkDvJz4Fe67efOA+poLCIePKPF/ngi4TYfwxRGqqukCQI6
         7c2TcTu3Bi3D+bwa2UI0b5DyvH4UEvyrIyfOzZTzZj7Xb3Tne9jX5nfegLfcFCSWig9k
         9IZUJUpoYnWFgD88vpkB80ye3iBcpb9GG7ZcwYl0qC/1a6a5reKmDJa3xFoIn50kksmm
         zsbNiDTFmRNLFTbufTccM8hGBi3/GmJAjGyJ4IRj/R5eM+mUjgynEqdwNLD1C4ZKqLew
         GSAZfPjkKXbnSRe49CP2+3vPNvz/xLK8sk4txe9c3VpuN4B4YiJh5PriqOaOv5TuY+c3
         bjBQ==
X-Gm-Message-State: ACgBeo0yflp7OOnv53IyMl32DyZIp/EoKZ1oGVZHUBzIzELPqJf2wkPK
        iCJJLLCPXuiqfO/tU/3iHTo=
X-Google-Smtp-Source: AA6agR6rO4EusgdhFNmVzGx+CBRQxesGceFjy+Mr30QRQ+4R2VVoL76UipBTN+V3VoBepajWSvJxLg==
X-Received: by 2002:a1c:2701:0:b0:3a4:f86b:9d28 with SMTP id n1-20020a1c2701000000b003a4f86b9d28mr6894421wmn.168.1660989193955;
        Sat, 20 Aug 2022 02:53:13 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id f14-20020a05600c154e00b003a32251c3f9sm13609214wmg.5.2022.08.20.02.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Aug 2022 02:53:13 -0700 (PDT)
Date:   Sat, 20 Aug 2022 10:53:10 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.19 0/7] 5.19.3-rc1 review
Message-ID: <YwCvBu9ABJCTKywD@debian>
References: <20220819153711.552247994@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819153711.552247994@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Aug 19, 2022 at 05:39:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.3 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220819):
mips: 59 configs -> 1 failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> fails
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
csky and mips allmodconfig fails with gcc-12, passes with gcc-11.
Already reported for mainline.

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
mips: Booted on ci20 board. No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1663
[3]. https://openqa.qa.codethink.co.uk/tests/1668

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
