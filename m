Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CF569617A
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 11:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjBNKww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 05:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjBNKwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 05:52:51 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8385A3C27;
        Tue, 14 Feb 2023 02:52:50 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id f23-20020a05600c491700b003dff4480a17so723466wmp.1;
        Tue, 14 Feb 2023 02:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eSco18981ls5jF3CcUs7/egKpzhGCz1PprX1dwAkO6Q=;
        b=fh1fwOlhWX9SnsClWIGXRycQZ9TPO2fvd9rIzcoESvsVGR1AnOZEyJ5zUlZ+fvxHp2
         e2vN52pWrVPFcxbqMKlX2phnWoIBmW1TDo9qbNfI5h7Pi89iltgkWvYAq1tYISx2Akex
         YbTkF8GBDMPKStigI9/L4ewEfNRwWu81h5O6XGaR8rELPryPFYyRN4OgmVwHugoVTJAi
         uJK8B7c3k8zPDUN2UW7x1YGiwiiISCt/2KjI/utSEal2kT5shRO8RmxRCdRglCp4qO/S
         /uwChq9lJj4bYqJo2p0tCOIZ2l5Jhg4/TTNuK1dEG+GVaJ9TjFIGUeaQyYSaqCjZ+JF2
         ZoeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eSco18981ls5jF3CcUs7/egKpzhGCz1PprX1dwAkO6Q=;
        b=xWiTdHn6i7gSHyC3+IN3rJtDLO/uSD1SzEjGwEVkD1wQC1pE2drcnMMJXiZsQQup4G
         ojGHvu4EFQv7P4cqwOeCtHKoqdkpOchbq7yQaWoITpHAskozpXLb8evnRW0JALdnxaEi
         VPK0W3ozIEAcHL6rBh1DH+LCmuxGzdMIbF7bwLkhiGSiZvl/qTzftiOw8sCHTeQQY2Ce
         e1faBxgVBQbT7UwYOuVc3UKG9jR9N1YqtKnoyJhqSNaUVG/lRRF09Uz3TB+XWnpt2cx8
         3XLnvGzCb3934hx1EeqV0CO/i7vowAQbkfzKvMv4UIoVq3AC4GoFnE1AlKDIrlZb1KDH
         fefA==
X-Gm-Message-State: AO0yUKXpl31vtj2nrjc+sMXz7b+uCqkNgs6oJ+ZZhYbVdPYRLw3Zh9OL
        ENxL2qdbOVAeozZ4PXdNuVc=
X-Google-Smtp-Source: AK7set9e6agz2JloVC++tfnB/LR+dMO8s0mZ1a6OX46KJFwqG/HOWVtNfYG62j7GvQNQMxFSf+OuzQ==
X-Received: by 2002:a05:600c:18a6:b0:3df:db2f:66a with SMTP id x38-20020a05600c18a600b003dfdb2f066amr1698845wmp.31.1676371968978;
        Tue, 14 Feb 2023 02:52:48 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id g10-20020a05600c310a00b003e1e8d794e1sm8289934wmo.13.2023.02.14.02.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 02:52:48 -0800 (PST)
Date:   Tue, 14 Feb 2023 10:52:46 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/114] 6.1.12-rc1 review
Message-ID: <Y+tn/omzYAD3+hoE@debian>
References: <20230213144742.219399167@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
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

On Mon, Feb 13, 2023 at 03:47:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.12 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2855
[2]. https://openqa.qa.codethink.co.uk/tests/2859
[3]. https://openqa.qa.codethink.co.uk/tests/2861

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
