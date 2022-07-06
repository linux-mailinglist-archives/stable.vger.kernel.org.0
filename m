Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28583568552
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 12:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbiGFKVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 06:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbiGFKUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 06:20:51 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE5C28701;
        Wed,  6 Jul 2022 03:19:50 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id h14-20020a1ccc0e000000b0039eff745c53so8701869wmb.5;
        Wed, 06 Jul 2022 03:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IRtZa4W50+1PL3vwAzMF6KhFeVCThCx8Lk3NGVi7seM=;
        b=lWDDpIfEx5ebFp2irfwkm9CCyzzmJiMkpYn3Ue9N8UMT/OCrEnaxVseXIhkIz+HSnt
         E3YOC/xNJ14iB3t97OMpBAw2LPvoOmWrNZi0FUM6QJUce2Ptq2EDewhsSN5u48A7ZfqE
         tFZ7lj51UQCj0td9G5MwbpGDSylsWYAiYv+IYngMYOOIPrWVLKc3dxcWPVVNRMuK7KyS
         lQAFPEHBmwvfqUbDkp0JHLO5PSO6dWlrzaE2oDAPp36Kl5iDhr4SbAfL32KU9D9qaehE
         ENwrr//muBtfbCfMghKgcytkczqPxW664gwJwYR1lZ6388pOd5Wy/mc6Ce56p+DriRS8
         vD3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IRtZa4W50+1PL3vwAzMF6KhFeVCThCx8Lk3NGVi7seM=;
        b=hz4TV48uccAFOZ8xrOCRERZklU6MrFhOptkCOvnpkOBpuZUYNFHoW8cf+BB2jZcoCE
         3MPefHzpC9YquLt5SnRnpBdZhpuaf3E18M3XaLtzEQme0ovftQbkx9lG9kMxZztfqvOA
         HJlDLf5xHyTdfzHi+OKNr+5MAMXuoq6TzgHGJuyEUnFG4FaGHPPdUnhpPFBoTYpIQyWB
         QDYC0ZZBnkAQXS6k/sSFGAZzRlRUfY08D0XLK0o5WJImHkjavLDgUJ/sCjm4+8YG3oLr
         GDEsj8rwnlUSxJNeQvQo4jvYLdhAuKfZk2lbno92J/Bo7yE8dstol+IkU1gYmckcYcx4
         QEiw==
X-Gm-Message-State: AJIora/jL/M7FbqtyGNfXe6gWObQKbH63WmR5aLI62myhpVjZY2Ld2nB
        Jqa87s+lQ2rqLXHow10aOvI=
X-Google-Smtp-Source: AGRyM1ubExqJXmOSHLAon3XHW+QSRBmtWllxIfYGEAnsyCqQdgC5xDGz5P6U6fqp2i7ewkT+Rp5Yrg==
X-Received: by 2002:a05:600c:19c8:b0:3a1:7399:861d with SMTP id u8-20020a05600c19c800b003a17399861dmr38802430wmq.170.1657102789374;
        Wed, 06 Jul 2022 03:19:49 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id u3-20020a05600c210300b003a044fe7fe7sm25014451wml.9.2022.07.06.03.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 03:19:49 -0700 (PDT)
Date:   Wed, 6 Jul 2022 11:19:47 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/58] 5.4.204-rc1 review
Message-ID: <YsVhw8sYzZiC9L/A@debian>
References: <20220705115610.236040773@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
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

On Tue, Jul 05, 2022 at 01:57:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.204 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220627):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1456


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
