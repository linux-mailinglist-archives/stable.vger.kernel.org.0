Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33076B5BA2
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 13:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjCKM1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 07:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjCKM12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 07:27:28 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960C212BAE6;
        Sat, 11 Mar 2023 04:27:27 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id v16so7456583wrn.0;
        Sat, 11 Mar 2023 04:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678537646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uCcG9r8zvzVa32ACP9pjDJ0u/GOLkhnUW6bBmHPkFUA=;
        b=BOGEDY//pxaL4SCTRH2vyx67C4dYcNczt8afRE0cKxI6FdPArV/rXR6+bJhPgRZQiw
         vTO0rO5KG3YXJbe8rZdnEPuXzP1auxt2qvnkH9FvfBLgPk/em1BPa90EJhzDTLvr1moc
         zXmAwua8R7s5upW7dDpUchKRs1ent4I9a4F90aU4+jUXcQbs2BV6WHfrXL4WKNX4zCXG
         ycn7EzNqAF5FkRnRpO+qPhl0dt28JEKdiBAzTdsijvD6eVScRbjL+wWJn19ncTQ286NJ
         ygTz1V910/Nncr+QGtLs79GUsxRhdjEB1IY0czqd7BDgW/EOYRmV/X5g3tI2n1MnaXvG
         HVpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678537646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uCcG9r8zvzVa32ACP9pjDJ0u/GOLkhnUW6bBmHPkFUA=;
        b=I73IgZwOxuLlC84M6rxNHG8XbWnDjrYJvsdSpj+QAZ9rhsb0p3N/tGm3SYM5WItqqy
         rlsC4UzgrDpK3aGThOJ9xV/1/r53sdMFX5qQsdyzXQ+F13w5/5JD/AomRKCRtZtnDijW
         lawdCWQtJ3vw+Cu/Q9fUn6mHsTxxZgX37gP/hXKeaxbNmitwn4UtueiKksP+Za3227Zw
         wKCMJRBfWcUeSaFKx9Kj0nVfd6tdhzGXHYVhWAED2Veqerw7Z6P7G6RhaV9eF5JOW2ZN
         jJ1UQTnOD9gXV7uYiZdQ3oxYciqlBErWIzbcee2IMknotZMguTHeL+MRYK5YgvH1e/cw
         TOIw==
X-Gm-Message-State: AO0yUKVtUcVVO9q+Ld+BPBLwYhYtAxL/E8xPs3ig7joW1s11hebBDP15
        SuK0diIR8GAsoavv3IPh+nQ=
X-Google-Smtp-Source: AK7set9YQlBu0WUqDjanj5JJDkG3xTc2kmCFY8j138j5Ef7mpCwU5fRxBfA5EEIVlb91ZHDVEBW9Hw==
X-Received: by 2002:adf:ce90:0:b0:2c5:4c9f:cf3b with SMTP id r16-20020adfce90000000b002c54c9fcf3bmr3854705wrn.7.1678537646073;
        Sat, 11 Mar 2023 04:27:26 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id c13-20020a5d4ccd000000b002ce3d3d17e5sm2380854wrt.79.2023.03.11.04.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 04:27:25 -0800 (PST)
Date:   Sat, 11 Mar 2023 12:27:24 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/529] 5.10.173-rc1 review
Message-ID: <ZAxzrMh1zu6WOKyR@debian>
References: <20230310133804.978589368@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Mar 10, 2023 at 02:32:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.173 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> failure
xtensa allmodconfig -> no failure

Note:
s390 build failed with the error:
drivers/s390/block/dasd_diag.c:656:23: error: initialization of 'int (*)(struct dasd_device *, __u8)' {aka 'int (*)(struct dasd_device *, unsigned char)'} from incompatible pointer type 'int (*)(struct dasd_device *, __u8,  __u8)' {aka 'int (*)(struct dasd_device *, unsigned char,  unsigned char)'} [-Werror=incompatible-pointer-types]
  656 |         .pe_handler = dasd_diag_pe_handler,
      |                       ^~~~~~~~~~~~~~~~~~~~
drivers/s390/block/dasd_diag.c:656:23: note: (near initialization for 'dasd_diag_discipline.pe_handler')


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/3079
[2]. https://openqa.qa.codethink.co.uk/tests/3083


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip

