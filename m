Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABAF64C7F5
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 12:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiLNL3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 06:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238113AbiLNL3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 06:29:43 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B1AFAE9;
        Wed, 14 Dec 2022 03:29:42 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id ja4-20020a05600c556400b003cf6e77f89cso2745495wmb.0;
        Wed, 14 Dec 2022 03:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mcLQq4wc+ePTHz3KFhqZubKSfpBbFf5K0CB+YZPtKSM=;
        b=Zam1SMBfYxcb3eWkKkAgO1GAYvO4X0jSeqgPj4q3NqwLkNqK96FNV+lv0IIxIXkG6s
         105qRPJi5Z4MPvXWUz7JGsoq5Vlh6kqL8z0XBwMSVf4FGLrrJQg2X7tBtD0AwLZMRqLi
         dGTcwwvpO20on6IqRdqTK68AohPuVg7kTTZuAvIjT8vSnvkul/czMpqr3ssfDbxrb4i6
         VsqyfxnMoPsrM6sROKcuO+ZaftJoD5zmMksj3zGlpsV/MeNOLXiHVhEI+a0VFqk6F4Oj
         /T0Bw3/K44w5DKkFlno6xrCTymBYo2xa0Ypp1Xn7kEUEz+oIBtwAI1dOc9JsYcr8nUU+
         MvNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mcLQq4wc+ePTHz3KFhqZubKSfpBbFf5K0CB+YZPtKSM=;
        b=NF7hK3ztvve6uqIijJSNAhQpBQQo34IfChxEIf4+MqodPSCTLGlVvHHTOGa1tFpcUQ
         XpKYgdav0BjmgZnrO23mlKFv0p0sl1xsl6b/gW4cK21DsWB0PBRRbKhUn1OM9IdtCost
         BwVrlzj8QKZ/Y5H4OamjUB0hGqJCe/rYTtMnpWq6u62V3JfE4VRrGC5bU9taVsE9vHHO
         DyJWgWEfQre74KKeULF1MPyMoYtLURyCvY5d2ZegoiOjWMXELuPDrMTIB33SH/iNIrMW
         Z5ICK4CvaLLf4OzTQ9ChAiV60PAHmneimOmjjTWGW0xxGkHCz4oof4e9S7mmkeagaIiy
         nZWg==
X-Gm-Message-State: ANoB5pmBBR+SCW6i2NRUsuMd9lrtY90KNgpGS0Gy0HbDyW/pyg6Mi8rR
        sv2rf+1caZ40/4X/6w1Bhu3mZP1KhpnxYA==
X-Google-Smtp-Source: AA0mqf7lDYYUkK7sP38Nz0FEvE9H0oB0J6UD9QcQDsyawLTj2Drdb/ngTXV5z4/F6MWDtrYnupBGtQ==
X-Received: by 2002:a7b:c00a:0:b0:3cf:cfcd:1f5 with SMTP id c10-20020a7bc00a000000b003cfcfcd01f5mr18075728wmb.38.1671017380706;
        Wed, 14 Dec 2022 03:29:40 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id t1-20020a5d6a41000000b00241dd5de644sm2518985wrw.97.2022.12.14.03.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 03:29:39 -0800 (PST)
Date:   Wed, 14 Dec 2022 11:29:37 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.159-rc2 review
Message-ID: <Y5mzofTHKUW0tRME@debian>
References: <20221213150409.357752716@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213150409.357752716@linuxfoundation.org>
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

On Tue, Dec 13, 2022 at 04:05:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.159 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Dec 2022 15:03:44 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2350
[2]. https://openqa.qa.codethink.co.uk/tests/2352


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
