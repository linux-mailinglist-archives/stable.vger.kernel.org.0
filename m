Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E3B6A8151
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 12:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjCBLiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 06:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCBLiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 06:38:05 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0AA17146;
        Thu,  2 Mar 2023 03:37:42 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id t15so16205456wrz.7;
        Thu, 02 Mar 2023 03:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677757032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=poBYxosYo3cIJmxbVSW7d8Wean0D5vMPhmQIYxLgsbU=;
        b=bsGbVVD6XLn6JNBxftc8OzRczWi9O1OfD1UE3j2jEjodMs/MawarT1lEnuWaj3DbbC
         1Zwee7K9771TRiHDPGfbdmmNiF3I2e+vX6W5mL2t8X8jOlCipmhk8YvU33/yBijNnMKZ
         /THhsF0A3LFrt+U+dyEEh1LIpLyGCTzvpZmmXGdG+WKem09L5vMnn4S4lwG/GQhok9Ua
         rXZzMrDy3SWqOq8di77bOc4iBdxTMBA1B9Qp+BDU2xeoFqUY17EIBCtJbSCjqKRGBfNE
         Y3aHhUuNRkCEModYRXFfAbYJLkYDq9MoFV1aZyOLwGllsE99bAYCPmKQxAYmf5MsFt/A
         UtJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677757032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=poBYxosYo3cIJmxbVSW7d8Wean0D5vMPhmQIYxLgsbU=;
        b=PO62Egm/J2LDqSKIY378z49RwNpN8AiHyG3Zz38xY5M/yBCssF60Ks9/EPECZD23Kn
         bWukT9aWaNsI6fHEocZ4eLCXfKFkvXO4JAPosztsSv/NrdQkx50SC7xoO15blxsOLgLi
         EJPH+pIOqMK92ROO4v+SpNDdQILJMSwtLwHWJeaI0RFEm7bYw3iu/XzMnauj7W39z3oI
         fPQdKkXenT2RaTjo0ewfVSTAzk06eb6XKHfbVBr+jEVKy1n1TIayhTwt93JWKhlmXN1G
         KQT9BXGNBuiFbHegt7SuBHB3Qu3RWK711uN1prS+ohaNmEiH5Aw7tK8Oev0HHvNzBIs0
         UOkA==
X-Gm-Message-State: AO0yUKVMgpjzr15ZBakQdf8YSVqEfkH2wxap4kMxaVm8ut9/3Nc+Of7V
        JCcmsdZGSRLA06Q0rrgkzws=
X-Google-Smtp-Source: AK7set/ew3Z9kHlo9wlyyy4gMA9iGuo6DGpOU99m3zjy0BieqaQ01tlswiJ0ZHJhKeYoBvYX5mLSTA==
X-Received: by 2002:adf:e747:0:b0:2c9:23c4:8f9e with SMTP id c7-20020adfe747000000b002c923c48f9emr6699452wrn.38.1677757032055;
        Thu, 02 Mar 2023 03:37:12 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id x8-20020a1c7c08000000b003eb2e33f327sm5459675wmc.2.2023.03.02.03.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:37:11 -0800 (PST)
Date:   Thu, 2 Mar 2023 11:37:10 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
Message-ID: <ZACKZqDji0xzknEw@debian>
References: <20230301180657.003689969@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
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

On Wed, Mar 01, 2023 at 07:08:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.15 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
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
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2975
[2]. https://openqa.qa.codethink.co.uk/tests/2981
[3]. https://openqa.qa.codethink.co.uk/tests/2983

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
