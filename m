Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88C9651F8C
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 12:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiLTLS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 06:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiLTLSZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 06:18:25 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC905F9B;
        Tue, 20 Dec 2022 03:18:24 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id h10so11407181wrx.3;
        Tue, 20 Dec 2022 03:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mtoQLOQcMrzMvarcNfJn3CYdynYcRi+UXcHZGS5Iv9E=;
        b=kABbtNC75GxFicSWkl2QLheKTFhLPIaxtsW4wPGRDbjmzXn3Z1esbIBSHk98AaGtHr
         8lUx6nqY4j/NtQJxKg50K0pX37ue+UX90OTbVtQn5M0cnnTLmL9uqI5/mdwL5R6dwHHC
         3jXQuOddLVsCS6yMblyjOPNv1mXbs55XjzWuKHhZBmoPdtEjGRbHXgl9vAdzIZL+H34O
         pNfu+zCYICY3fKUDMq1dA9WLF9yoN7781/KYVrvDWh3OJB3rlpM4+gawFXBBoJX9Du7C
         Dos1JVeqFKdDDsCghpdWZKoKzxwe19BvbwEiNyFf3rC664n1K37DzMLzJ3bBLDuuvUZG
         MjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mtoQLOQcMrzMvarcNfJn3CYdynYcRi+UXcHZGS5Iv9E=;
        b=jo8pxca2x5ASNLxHjElfDRaz5yDLPjx9d+ZF20QriWnFRx9tKVxBsdpmqTRyYVFQDv
         o6Coa4AvkG4IeceTsOgPvjldSZK9dUySE6ghQX97EUA2w17DfusR6xZNHooCAH4UvFF9
         s9ZucpdbSVw2jEI/pv9Be7qBDhYK0Cx3Nm95FaN/83LAKSdDrtEdAU6XlkHFRWVBMSHX
         2YxjTCR8aDGKcbhCtjJ1pRu80BzZbqje7KjQZiUhydRooow0oAaWOAueLkwODTN7rHZw
         TbX2VtEXsupXiZPCSEGaS/qbSz1x65vc7cwutZ7e5+3o6XEPa3sA1RbL39alZeDQvTdA
         bL8w==
X-Gm-Message-State: ANoB5pnLGE0TqFapajyjRbEcsZYrICMk78uri3+VCPj/WT9k+8sG87Eb
        dvg+r4Pn3E3wNlM6d23s/FE=
X-Google-Smtp-Source: AA0mqf5nzKQxGjJrCbgu0kJhJRMCNqeV8ZxKRevg1rDIoBoXvAF9t7txIwXZ8EXHy2bNzm36/LTxZA==
X-Received: by 2002:a5d:4112:0:b0:242:1433:a8ba with SMTP id l18-20020a5d4112000000b002421433a8bamr30717013wrp.20.1671535102555;
        Tue, 20 Dec 2022 03:18:22 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id y14-20020adffa4e000000b00268aae5fb5bsm215451wrr.3.2022.12.20.03.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 03:18:22 -0800 (PST)
Date:   Tue, 20 Dec 2022 11:18:20 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/18] 5.10.161-rc1 review
Message-ID: <Y6GZ/NLLnGD4hOYL@debian>
References: <20221219182940.701087296@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>
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

On Mon, Dec 19, 2022 at 08:24:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.161 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2409
[2]. https://openqa.qa.codethink.co.uk/tests/2424


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
