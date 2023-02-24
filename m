Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6B66A1B33
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 12:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjBXLOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 06:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjBXLOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 06:14:12 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA971689C;
        Fri, 24 Feb 2023 03:14:08 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id q16so3189256wrw.2;
        Fri, 24 Feb 2023 03:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SKRDOn50Fe/CNyx3l2bs2XrZQpRO9QtNT/Gvh1YGQwE=;
        b=k3GkFWnbyNWw4U+CrFtc++dPmQ0/dfG30pJknWe3NEE4NsY0e+d5rAJMi6Jt3Dmx5f
         QS+7r3+uhgt+V3ddBmPHV0WK98xJFoLYi3T+MlgxdJPxLVMXNXW/PNkTvqlxHGQcnSpQ
         73DTZEwxeadnCnQqBQ/AmSiCe0kc2t5rhGDt0i4ZsMLcdsDtR+ug0/qiQaxRXlrcJpQZ
         6TtNa/640SchYLaUbJO4ZN1oc/eFd0EWkhcWTiCW54nABunnLM2uw6XHkwIYm/hbJS93
         HBd4DSNSbWkiahC4IXFnA3AviZ4ZBF8mlDffRR83fARD9kE+UdS7c5HYf1SKug47CUfU
         mkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SKRDOn50Fe/CNyx3l2bs2XrZQpRO9QtNT/Gvh1YGQwE=;
        b=vTLXsNgnmvXfmCJN3wQXB3Awyq8fXQ4u0XFuE5/7WtcAiSLQLks5i0+CPpxFRusn1q
         F0QxIb92f47mxR8Yj63FyR42NEoCHk97C8IaI/8Ju2HzlVmddih9aBN9b40nZHBmUSWt
         SDzVsHKR247Qyh6dHcDIPm/GoX2EXHEtCURE+SnRDBMgf6N9OmbYKhKpSZDYMAl0CFeV
         hZ24Ev12MEonRHnWQbDyXd4qdvrnEgjkY4XOLbIjmYd0mgwJg7RXKSG7tuITp08tkgjc
         n5jNHbFgypRffk67ptRh3SUxPq3RyROs7oq0EBd0COQEiKwrdDOJe2/whu4L4UgUpgRV
         03EA==
X-Gm-Message-State: AO0yUKU3B35XhfVJw16pG4IAudJ6dw6eV8+K1teS07TAz+AyLwbqO5/p
        FU7oErKFUBWSFgjIC+BPCXo=
X-Google-Smtp-Source: AK7set9InYlzh56OehyNP2cFmC8v4kKyYst9z0J09KA9LqrlET1h8ddkYSEy3lLM79IT/P5otdA0MQ==
X-Received: by 2002:adf:f5d2:0:b0:2c7:bbe:456e with SMTP id k18-20020adff5d2000000b002c70bbe456emr6788251wrp.56.1677237246589;
        Fri, 24 Feb 2023 03:14:06 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id c5-20020a5d4cc5000000b002c59f18674asm12287023wrt.22.2023.02.24.03.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 03:14:06 -0800 (PST)
Date:   Fri, 24 Feb 2023 11:14:04 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/12] 4.19.274-rc2 review
Message-ID: <Y/ib/IxdLtDCGZ7s@debian>
References: <20230223141538.102388120@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141538.102388120@linuxfoundation.org>
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

On Thu, Feb 23, 2023 at 03:15:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.274 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2928


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
