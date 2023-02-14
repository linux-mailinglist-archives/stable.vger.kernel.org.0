Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824CF696184
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 11:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbjBNKzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 05:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbjBNKzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 05:55:01 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F85976E;
        Tue, 14 Feb 2023 02:54:58 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id h16so15147070wrz.12;
        Tue, 14 Feb 2023 02:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=593Ua1ec9BiN46mIIKCEZOJtdu3jaaJT05k4osqF/3s=;
        b=bfwPpRL2v1FK3LVE/TMJTevbG2bCeMiSHZXr+3GEa5FBN+Y2H3f82XXq7aqSg4fS8y
         S0eRFSc5QwBk+OBkzl9XKkJX0tKwQijiaoVst8mILz4ORL6cohGH+FDlFJBPmAy5/CJx
         Wb8cXr2Nq9yQqrgh+vkzzywbuSptgVeMmBrCf/dzbPflej5dYRHXVlbQUZegnL8mXWzl
         nYfvsg9CQs1dwuMBlnCM7R9J04WAPyzyzZeHEJBukz780aOQFbihpRJG4tOF5MWw7BbS
         m0bPaDDGlgabe7W8k1L8sj/mlY18GA+wPve0Wcr8j/D4GFEGYVpwxBvzOAF2Qpb+lI5l
         WGVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=593Ua1ec9BiN46mIIKCEZOJtdu3jaaJT05k4osqF/3s=;
        b=oSFYoi0M17qkEc7P2k1wmMzK8osg+NmXQYyotyF6LL0ruOCVOdCBsf5bQAuQCW584k
         9AYfvX73rXCW3DZIV6xhw+9PNAAZc8d/O1Bq6hAaLv8V5BACCjlWS9hfnLcf/2dUIgtO
         kzFD5XR9/ud/+ZuQSNkeIMQKkfkhMyA5vB9gifD/x978MS33D33Jm0s3IOvtNP2vY0M5
         u3SgSa83nmaBXPIZZm+4jI1X/DmfAj+fP/gxm56LDRIgWS9+XRj9FP4AOPzbI2kEMww/
         mTbXuxRPFm75W3vqnfn3MhybQFoQ0uhZrNZP14rxgAVffCm46szGikE7vXSUUjhI68mf
         CcxQ==
X-Gm-Message-State: AO0yUKX2ltwBUcJjzpqS8GESu3z5QH8STFStdKsnPtX3yYrX6cgGEscm
        iGOzP6Dmb8G9XYRQKHotqfE=
X-Google-Smtp-Source: AK7set8ndYt4uzMBrtJbAhvkVV6KGHQzdXXmEruj2r5ReMWY4WhMcxuTnFMquE9l5SCqZCdQvc+T2Q==
X-Received: by 2002:a5d:46d2:0:b0:2c3:e43f:cd6d with SMTP id g18-20020a5d46d2000000b002c3e43fcd6dmr1724626wrs.66.1676372097158;
        Tue, 14 Feb 2023 02:54:57 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id f15-20020adff98f000000b002c5583ab017sm5245346wrr.15.2023.02.14.02.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 02:54:56 -0800 (PST)
Date:   Tue, 14 Feb 2023 10:54:55 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/67] 5.15.94-rc1 review
Message-ID: <Y+tof69qc4g/2RMX@debian>
References: <20230213144732.336342050@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
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

On Mon, Feb 13, 2023 at 03:48:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.94 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2852
[2]. https://openqa.qa.codethink.co.uk/tests/2858
[3]. https://openqa.qa.codethink.co.uk/tests/2860

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
