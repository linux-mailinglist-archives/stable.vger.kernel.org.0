Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA2D69E2F4
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 16:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbjBUPCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 10:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjBUPCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 10:02:45 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD94B83CF;
        Tue, 21 Feb 2023 07:02:43 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id iv11-20020a05600c548b00b003dc52fed235so3250737wmb.1;
        Tue, 21 Feb 2023 07:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TkM/rKx6BKDw2NTG9Wlpe47dRHkurVcHEfekPcsHiw4=;
        b=l8Sn/OkgI92MpvVZ3KVSau/sh6Iz/1fvpLLlnAdODElEg0vMVJsHgkeUODsJ/ctZWU
         WDop2A9bmYp5yMNjvcpwWPq/woACJIoq6IJ8kfCGS1fyJ2mJsyJR/IFoEaEqENJppBq1
         Q+GR7qyFuYp+vqJlMXQIPJ5QzdlWcJJiQmZf+XI8vJVdrW+Qf9arUc+sLEuu2o8Do4I+
         AiQF+23xYyl5CCU9eRmqhSttNQh8MhZ0fryiqgTfmvQhe9kxjh71M+NbATihsdwNhojE
         p+WotO1n/SJV5up1optpMwkN9hSjO6mAE8Fon+H2avssKwcthwO7z2ri3aYFRyOvaysT
         g3UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TkM/rKx6BKDw2NTG9Wlpe47dRHkurVcHEfekPcsHiw4=;
        b=1e/kdFborsPpHUl/iYn6mtrse6pitY0OVgS/6gRI6Br60aUCvum4QGpjP6VuYZDAua
         NCyHJWx+7tep0ShwmtIWHgqZBDzh4sm6RtQM1UN4mK6cbKLkUF5SWRg5EmeskoSy9FAW
         rezzdydWDWama7rAe0HffPyr6SJ+R6umi+v5/Rngv9RI9TPqZ32u5hE5pSCV7ODTGXnf
         PRepAFdkH4dfoUZrfjQFRSqK0xqLrZmkJDnZaN2oG5Z7JujKVzu29xsYUKFF7PtAnaEI
         /lcBg5LR//iJ8uJTFBMvOfvRBJq+FhpmUz6n6xWzWUI/2rOH6Mfq78d7MbWYYmtQ7iDU
         7ujw==
X-Gm-Message-State: AO0yUKVoh9TM/aLbTPzzAvYHHJIjVqgHZYXIhe4avuHFIl4yrVacjmZN
        g78FarxVFFyeeNDdM+0s50Y=
X-Google-Smtp-Source: AK7set9qPnhdz0+Gn2CiKXm3CyLfmuYvYrCIm+cUKdvRO6er+3NZoxYTMxy5onPu6ykkCPzc6nn2AQ==
X-Received: by 2002:a05:600c:4b1b:b0:3df:fbc7:5b10 with SMTP id i27-20020a05600c4b1b00b003dffbc75b10mr9576946wmp.0.1676991762078;
        Tue, 21 Feb 2023 07:02:42 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id h6-20020a05600c350600b003e0238d9101sm5508047wmq.31.2023.02.21.07.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 07:02:41 -0800 (PST)
Date:   Tue, 21 Feb 2023 15:02:39 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/89] 4.19.273-rc1 review
Message-ID: <Y/TdD1BOQm/2CcjW@debian>
References: <20230220133553.066768704@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
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

On Mon, Feb 20, 2023 at 02:34:59PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.273 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2904


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
