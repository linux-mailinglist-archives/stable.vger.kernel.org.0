Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB015843C2
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 18:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiG1QBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 12:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiG1QBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 12:01:39 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B2A68DD5;
        Thu, 28 Jul 2022 09:01:39 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id b26so2794043wrc.2;
        Thu, 28 Jul 2022 09:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=nYvYTv7MPLJmcBpbTO9Uh48dBXSY9pmpMrzrICcPDek=;
        b=T8qGKchryX/qAmiCfLIAIbDx0ixmW6hQTCb0lBg+ELUWJFw1LtwxEypUSeWQn+856u
         NRL7FEzwVBekxZOaTGFvYBIC+M+6Xkw55ct2FRLwMQcbG9p3f7G/UzlMv72HYRGr8Xx8
         64bJBBR6jgBDj88GpQRoYCVagbXF+JNBgvfkBwnVfG7s7bI7QMBVI2cxZyyoq4xaPoeg
         qbdgFIWFGb7Y++JswF4VyPn9UlCV8srRNJX30vgYlvsR0VAf7owNdzuqjC31xp0u3R89
         yUrN2Aivfz8v0pCM1+TBXGVIEon178d9ZtYAHEoSiKfY70jTrmKqo93zo/0xq5Ne/NxJ
         sB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=nYvYTv7MPLJmcBpbTO9Uh48dBXSY9pmpMrzrICcPDek=;
        b=cTJoOTKkPZaVGjT3qM5b/NzkJxtS8PONDdseG0rx05jLBpsKXz6xKL6WkFddVinsst
         STIiC8tCtoBReEiwCFpy1wao8ys87kxwSE2xtyqdXEqR1SbSkZD81kA7gI9BIQfNsw+J
         a2ofj9ToFrfa3TZd4PJwMKY6JHRUit8o8E4D2mUbb2HYEudxIBxAtyDyRq2Ox1zGbVRh
         vxvpQt2o8WTy/dbUTLZqOB0K/zQiPTIp80dx7CNYwJSSOnQSd0I9XBagiICajpmBS3wc
         si7BIwsw4ZLFYqseJxwM88OAXbtXdYyrZSPwJUZQWY8EakeilcKZnIeuF1ESmN0tERxi
         LqsA==
X-Gm-Message-State: AJIora9ry4yjZCyWPA5Po3e24QMmOBEl3+98GsabStg+95S2dlbVvv1X
        4/Yvdf3xmKFqauVcWnkdQMs=
X-Google-Smtp-Source: AGRyM1tSX8UozznvSMXF4KfRUvaIhlN0+3jyMMIBhPUpUucRbL3HQsBGTuq5rHxn4OHQHtE8wz+GGQ==
X-Received: by 2002:a05:6000:1a88:b0:21d:aa97:cb16 with SMTP id f8-20020a0560001a8800b0021daa97cb16mr18199512wry.97.1659024097405;
        Thu, 28 Jul 2022 09:01:37 -0700 (PDT)
Received: from debian ([2402:3a80:196b:933a:553c:d695:8a60:6d86])
        by smtp.gmail.com with ESMTPSA id m23-20020a05600c3b1700b003a30fbde91dsm6618506wms.20.2022.07.28.09.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 09:01:37 -0700 (PDT)
Date:   Thu, 28 Jul 2022 17:01:27 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/158] 5.18.15-rc1 review
Message-ID: <YuKy13TDA5i/cOld@debian>
References: <20220727161021.428340041@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
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

On Wed, Jul 27, 2022 at 06:11:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.15 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.1.1 20220724):
mips: 59 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1574
[2]. https://openqa.qa.codethink.co.uk/tests/1578
[3]. https://openqa.qa.codethink.co.uk/tests/1580

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
