Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8948617C6A
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 13:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiKCMVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 08:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiKCMVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 08:21:20 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EB5B5B;
        Thu,  3 Nov 2022 05:21:19 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id bk15so2452019wrb.13;
        Thu, 03 Nov 2022 05:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6UKiNJebKkHGcQAXA3/jGztnsJvVESsNIXBeqOYqZec=;
        b=JUhF8WZ92kc8FoTHdswOHrOfJJDqAmsPj51nbzYhDweatNVqfCOsO/A28XPgpdECpH
         Fbu493NCbpyF5JBxX3m7jOuVJOnowSi2blpDSajvhDg52GxVbZqBazpoHMMxZ0eC9tRa
         MABpXxCZBySbZD1Cmh/Fd59GV+FXa2Y7vsKx7tucwkTaFJOP9uavUtt51B89wz2sCv9t
         WqGMTOnqXw8snX8caGFEdh5cy6Z60eW81ASp9BFcUq6MYFUlctPGp/maLA69XjQghBQT
         5HiBdd88awfJfpwblvvDUDhvUs/a4450wqqNiz2O+vDxkRrX8L2H1YkQ7iY8K5Wju4mu
         DC7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6UKiNJebKkHGcQAXA3/jGztnsJvVESsNIXBeqOYqZec=;
        b=vyIrN6P5harRvLWzNCVaqxrPNzMGnQ4y90rv9uz6pdeQfdD2A4oeOHJ95Y3vzBeSvl
         rWCdbaV+o3F3v+Ad/NxucIZd6Q20EsSY1dSa52axqDHxIpsPGjtufohlhLLNfg3a5SGR
         k/j9nggfTyB/sDy7DYskPBBZD4DUE9pQi6Pg3qqyL6HSTE7ej4awwEQ2wtci9jcIH8pe
         /WdnXBXa6H5wf+utXvncG2SliFhxaEkryxbg6byGwLkfcxPOQwLO2aYDxbvGj+J1bS9B
         rY4CtKQnb+PrtH5PWhw+LBrHyP4LKqb9apimGaKyU1XEKBf4O7iEbQwrY08PJAKd2RTr
         yVSw==
X-Gm-Message-State: ACrzQf3UF5JB1oNgILQPP2RN+geUJAv+opAmQFouZS/yASZ8WJ3xMTVC
        Lvm72o3xr+RtnRWGBy3gBy0=
X-Google-Smtp-Source: AMsMyM4aiWjdlsSbUGxWYYjv5V5KM4TxKiLa3JNQ1169ssA1M5jjI1hTWLqvkO5six6ipFDZonPCBA==
X-Received: by 2002:adf:f94b:0:b0:236:c825:e2d with SMTP id q11-20020adff94b000000b00236c8250e2dmr14162662wrr.307.1667478077732;
        Thu, 03 Nov 2022 05:21:17 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id bj9-20020a0560001e0900b002365cd93d05sm774179wrb.102.2022.11.03.05.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 05:21:17 -0700 (PDT)
Date:   Thu, 3 Nov 2022 12:21:15 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.4 00/64] 5.4.223-rc1 review
Message-ID: <Y2OyO9DDIf+8iZRE@debian>
References: <20221102022051.821538553@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
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

On Wed, Nov 02, 2022 at 03:33:26AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.223 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2087


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
