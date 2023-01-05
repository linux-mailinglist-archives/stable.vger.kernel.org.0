Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1008A65E9A1
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 12:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbjAELPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 06:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbjAELPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 06:15:12 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A148574D2;
        Thu,  5 Jan 2023 03:15:01 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id bk16so22553742wrb.11;
        Thu, 05 Jan 2023 03:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=86+q+Qg4Mtt40/M5jVCX/R4x8CTXT7lPu4cQ2thqb54=;
        b=NfADKSaeWac47xmY5tV2DJYIvVmBqPQUCTLMTzIIpGNF0g4v3IwpQ2aN5hw2t0BTG4
         xIINOPf+cPbYWgkZ+71/IJWzWhMGRdXd7RlD67P5+48oYXtFttjM5xCp+PbUshXw58is
         Hr/mgxae7ChT+7yRfYKSZeGBnTD6joaizJCXOCQS9ftIetljdUsYkPlT+NrhqDWb1BbO
         Le1hnlur7Ywyteqi6X1yVVkMAPNdzr3rxNGthnHj5QVMggbeQ6QQQxaQA/2CzDHNKBKv
         AbPxZsI4t1aLcmG0YbimV603ruadsbQdgk3PBYUqDzDgAYh87v+Y4Ni2N4a1tmqOv43Q
         A2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=86+q+Qg4Mtt40/M5jVCX/R4x8CTXT7lPu4cQ2thqb54=;
        b=zRxBDuxNl0bKA+qcLVRf7oSi5FJ640qmX5iL/dOVkZYSDhs5ZPcwVkhNqC/394fdGZ
         6RDVtv1b0A02ddOHEHUOL0TRHCTJBv/TQEJJyHyWRLIxSActLBQtJrgw0wLKDqf/8C0V
         vZZ+w8o2baeAs09mSCWS23j+U8za7eD3K0eCb2oK/6R714XxPAfjJsItp+wX/NuggquP
         e1vv1lnhTsYRRFjWUaIlM0nZcoVp7R1K67u7N7tNT9Do3YZI6YlsIZtjy+RPDvJx8Nrk
         gjEflVJJGS6Jl/ZKzVKnvzDMGt5fcFb/DCoEMH/2jFFqiLQSWWnoFWQ+MMFF4r7RWEJT
         k5yw==
X-Gm-Message-State: AFqh2kqQf7oEac9F7q5WbrX9nUGKD+aVTTZzouJwpdPx6au8gH0E/LHl
        CaUWxM+n0mLv8FfzltFRHJs=
X-Google-Smtp-Source: AMrXdXvT+YBSRy7nCyvEbQI6Ep3rnuWCLY9a8Hc1SArTdh63c2Svif4IsSGWLaW0MG+/k6AUEwyktQ==
X-Received: by 2002:adf:e78d:0:b0:242:5469:55dd with SMTP id n13-20020adfe78d000000b00242546955ddmr31114084wrm.36.1672917299600;
        Thu, 05 Jan 2023 03:14:59 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id f8-20020a5d58e8000000b0022e57e66824sm41581877wrd.99.2023.01.05.03.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 03:14:59 -0800 (PST)
Date:   Thu, 5 Jan 2023 11:14:57 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/177] 6.0.18-rc1 review
Message-ID: <Y7axMUGRQCJXt8pp@debian>
References: <20230104160507.635888536@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
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

On Wed, Jan 04, 2023 at 05:04:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.18 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2559
[2]. https://openqa.qa.codethink.co.uk/tests/2571

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
