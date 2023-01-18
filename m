Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749F4671C45
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 13:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbjARMkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 07:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbjARMiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 07:38:14 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B9D95147;
        Wed, 18 Jan 2023 04:03:27 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id k8so19202313wrc.9;
        Wed, 18 Jan 2023 04:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8nhezqflOATFFNnPhTotRfG2qXe/R2C82GK9147Uq6k=;
        b=ZPXzjtrQKfSffr6NP3Ie4Q9762h40A4UqbVI+8raOIk6IgOVQ6vukTzwDDe4zsMWRD
         6IdD2apgtz7nW7I6KFbt6OHNfU/l2lEkkF4Gx58xuTedkizhD7D+F3czue3cpbUKnUX5
         p+DRU9uhTjjJ8UtJVzmwMpjFJ4izt21ieLZS7PWR+uA2x5E7jF8XDKggj08T0I3Ju2Js
         VK+9xJlqPw4pihZw5xoitjYRERpT8PeZreewTVHPv4WTj+O8esxrteopYIB5uQ2rusro
         x4EzWG1ZhSVXu0xrWsDYZGtxpykyERBBKgOsTpSw/qrWW2JbGJBmtVSKqwlBvoAKITyk
         1v7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8nhezqflOATFFNnPhTotRfG2qXe/R2C82GK9147Uq6k=;
        b=rrN8da5IV8qDbsFLDiz/ad+Duve4ufLbiAR0C7ontHtfG5B3zZKLtZpHqwdtm9rMWf
         w1TfkmDG5+tsAyKaEbK5gxUJDRKOWk7gxgKit3X5hjMntmmG4MDcw/FOcBRPL59O9eSH
         oyKwdbEulg1D6R1nGrROHMtf3ZQ0ANoXtz4XpgCPDnDLoIu2QIDN3vipQqJIHTRgdww4
         s0F56FhzyRTcFj7tYF5w50bju/NsGSxGOeku+5wYTIk9AGOxzlkzc9wl8JO9+3Dc3igN
         GeYi67nnTVTR6lcKfrSS6l9qYqaVoyd/VWmNFEf5p100P6tF4SfD2c/hSFn4/vsgXKQb
         nYkg==
X-Gm-Message-State: AFqh2krPOnfgA5jKTksKlie6OuX0T9DyuAX4L2jrnQTGe1D+TR1Gadp/
        UouyPKmrho0BByXpOCYYN2A=
X-Google-Smtp-Source: AMrXdXvNmRU+xYMjcdBGpUG52jhIDjjbp9w8DVYtmASVRK7Yt61KX8EkAymfdItkn4V2AoAXEr1Bug==
X-Received: by 2002:adf:f0c1:0:b0:2bd:e7a0:6b5e with SMTP id x1-20020adff0c1000000b002bde7a06b5emr6223464wro.40.1674043406275;
        Wed, 18 Jan 2023 04:03:26 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id y18-20020a5d6152000000b002425be3c9e2sm30535321wrt.60.2023.01.18.04.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 04:03:25 -0800 (PST)
Date:   Wed, 18 Jan 2023 12:03:24 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
Message-ID: <Y8fgDBLOMgZGerSZ@debian>
References: <20230117124546.116438951@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117124546.116438951@linuxfoundation.org>
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

On Tue, Jan 17, 2023 at 01:48:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230113):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2679
[2]. https://openqa.qa.codethink.co.uk/tests/2680
[3]. https://openqa.qa.codethink.co.uk/tests/2681

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip

