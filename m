Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263F1563185
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 12:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236388AbiGAKge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 06:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236408AbiGAKgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 06:36:32 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC847969A;
        Fri,  1 Jul 2022 03:36:31 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id v14so2586657wra.5;
        Fri, 01 Jul 2022 03:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YF6ze1P16YmlMQmbhhioBfEbiEPGqEgt0Gtphq7ZdFo=;
        b=faN1lzccH+gifJpVfK7P+Pmz+ZHko4mleew+GsrNw7kcdjBASwP0L5BUATXGxFC1jj
         u5CaKLPmM0oJsxJmoRxMfNjGpuBvh74BkR76QD/jeVYh8WSQAtNEMYJzbmFMDAAQOE0y
         /JZVxNDzrdTs7Dglq1QOZq1PKQTtTu7m6sns27i4VYscQViQUyKo7IVKUHNH1NWTTeS8
         JEisFmbueKS6LZaPrfsQHYbO9m3jFxV7HTGK0ZAUJoOG7I6OlhXR+TWI9Me2OxlccBWf
         wuZRtWLVIaH35PtTCg5K7jl6SBC4dBk7cKtcsYW+aP4Xez5VoTO2UOvUfuhCYf4EQSvh
         +oJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YF6ze1P16YmlMQmbhhioBfEbiEPGqEgt0Gtphq7ZdFo=;
        b=wkMyjb6C1X7JOAue3fmgzh4WgSUy9o3QJYWdQrDbWWpU2eMuhx11vWZN1ZEsBwRNIX
         AG1brYEfLKdVvlybIBP+RFHsIW1aFlsVs2ARkkQUxCtqizT/hLpuR3zCyNvvxMl+dL3h
         Kmq/II0H7BSZLHZfP8ptyi9ogbEwJNHQDf3s96XBoTSeAdhJUqrYHikIwTCpkxCHKMM/
         7H1IO9SKU2MmhLFlbD1NBj6KXbCxh27Fk9JVJTHGZgPhwXov+CrUE+KOK51rVZFdqyS4
         q4oLyjW4lKBV0GdabMbo8mgaNH/QCxxvo/2gGqDqGjJwQ29np6qj/uSVIZw/03/F+9ZR
         heGg==
X-Gm-Message-State: AJIora8mCYuseXrg3WuWSRyhozrfV4K3UI48FrmAB6MnLc5TUtUT6Mh9
        gPEP8IeUeADlQZJrRJ85p04=
X-Google-Smtp-Source: AGRyM1tlFFaHWf8Js09mD6ejcpGZSEF2P8LCDOqZV+GM4jHmPcSblhYmbhVDhVpsViDca3oyZbnf+g==
X-Received: by 2002:a5d:6883:0:b0:21b:9408:8ba0 with SMTP id h3-20020a5d6883000000b0021b94088ba0mr12780440wru.419.1656671790579;
        Fri, 01 Jul 2022 03:36:30 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id l21-20020a05600c4f1500b003a02b9c47e4sm7501127wmq.27.2022.07.01.03.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 03:36:30 -0700 (PDT)
Date:   Fri, 1 Jul 2022 11:36:27 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/28] 5.15.52-rc1 review
Message-ID: <Yr7OK3KafCKsBwzk@debian>
References: <20220630133232.926711493@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
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

On Thu, Jun 30, 2022 at 03:46:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.52 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220627):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1434
[2]. https://openqa.qa.codethink.co.uk/tests/1437
[3]. https://openqa.qa.codethink.co.uk/tests/1439

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
