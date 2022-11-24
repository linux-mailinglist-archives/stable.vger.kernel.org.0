Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAEE6376B9
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 11:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiKXKps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 05:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiKXKps (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 05:45:48 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745B114F53C;
        Thu, 24 Nov 2022 02:45:47 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id c65-20020a1c3544000000b003cfffd00fc0so3646014wma.1;
        Thu, 24 Nov 2022 02:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OkVcv1cn9b60nNBS5JVT31BD/8eY5SE8Gy7OuhYf8XE=;
        b=pLEDMS+R4/Jb+gXuhyQpAGnX5fgd33+usIh1Jp073c9tg/xNqCw3SSkFQy/gbQ6yCn
         S4+dp4NycYIB6U+eduC+9lj8lFRl3UzWiPBl6m9BPkpM6viE+LG1uKxUWbbliO0loJUo
         jiuC7KIGBPcOO7JcEJoD/yLhOR8S5i9Mr/IzemM4EzpFF2Y+fKng7A0sU1EK1L+eq1Hq
         TDVkmQHbUVHbc4dWIhh5HxOzQx1DlAoxA9RbhWInRtoI2Zh5Ao6K4Yd078w/eeJsFp6W
         YSmrrExvyKpWo1wr7u5L58JBuwRdd+9Bml5DqUzF6S705VYPneL6It/gFRz3KTX39DGt
         l6Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OkVcv1cn9b60nNBS5JVT31BD/8eY5SE8Gy7OuhYf8XE=;
        b=ghddmuTAmvVEdnKZNavEI0rtRRLbIb92LEz3fFQbHKUPN08cuTx1d6fkX/tf+NyL/e
         wELHT1W0vMDUK04j0LFW9jtcAPctJVMFpbYgKfA+O3DPIo8xWbHlXNan2eUyEmZGL2et
         aNedXCECpFsuuBeFoVomrVLAQbm9McWuZuSpJytMbR7LynB75w974jesCXYQ37BTxdi6
         d7ThfRU0UKZJKn3zSIagkCtTteD2BMFrLesFf80tEnw5so4nrvITY3hhC+xzwYRqqz9B
         1nhVqdNDJJxnlNTplSXmMgggNvPXiMoFccCpU2fOP+J2t28h74ZsCTPppRnmTTtDnvcT
         fpLA==
X-Gm-Message-State: ANoB5pm+au0Yu9EG7KHPjOGRamw/YKvLW9qyOCXczOIrryDE2ldBiYh2
        APwRv5h8+l8ppgpRTDbnQCE=
X-Google-Smtp-Source: AA0mqf5GHAFhr/74O6Iyd8KoLwdozaQ9xytpWWtGIt85IZgMQVqWqm9tmJ4RK/3ZUkEQZlb9LhbNQg==
X-Received: by 2002:a05:600c:3d10:b0:3cf:8a44:e1eb with SMTP id bh16-20020a05600c3d1000b003cf8a44e1ebmr14028709wmb.189.1669286745736;
        Thu, 24 Nov 2022 02:45:45 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id y14-20020adff14e000000b00226dba960b4sm1079481wro.3.2022.11.24.02.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 02:45:45 -0800 (PST)
Date:   Thu, 24 Nov 2022 10:45:43 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/156] 5.4.225-rc1 review
Message-ID: <Y39LV9/xShW88nQf@debian>
References: <20221123084557.816085212@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
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

On Wed, Nov 23, 2022 at 09:49:17AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.225 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2207


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
