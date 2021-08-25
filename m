Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7113F75AB
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 15:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241134AbhHYNNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 09:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhHYNNi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 09:13:38 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96F1C061757;
        Wed, 25 Aug 2021 06:12:52 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h4so6205791wro.7;
        Wed, 25 Aug 2021 06:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bzl6UgKcYnPjo52TSVopZxKW6cf6P8X5hyvtOE1SC44=;
        b=P772GoMvWV+DmjnCU/9qAhkbWGXTgmb1+OX99jpfZ6wBtsNMnA5KeGsa2F2kDGFgDy
         e2Kx6e9roWeA+jhNBZ/1yrRZx5y5O+Wi12k4Rp82gHAfCTfI50JVZa+Mq5CnXrO1FXLt
         bghX9cgqdMM1V69tidf8U9imvirxYrWJ3MQRMRb1nvsrKtUqKPwQYtsb95Zs+BY+mgxP
         vINyODvFsp09HP8cHsSv6tp+aIL5U9GFfkQUtRLoH81MRO383iwY3QTe8WWklMhZmFL7
         tSiQbqiUct670WDDXBt9mNiVlOVuk/WAQ16WnajPEJCUo70fjz8lPv/TyBOHKcepjdDM
         k8IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bzl6UgKcYnPjo52TSVopZxKW6cf6P8X5hyvtOE1SC44=;
        b=J84m8acZZhCxSh2I9sT6yaiLmMCGmAPrTUn4RH5sGdA2WESIY1HJ4IB3i3g7JqGOoR
         wWMRMiysV7vXAAKdyA+JKMOtp8tUycynFXaIw4yORO7Qy+HETzR1nVsnMvqdw9TjQDnz
         G83uIjk3dXPboxiYaNGdaZA3c7IkmovM8eXOqWLkNWHlGakOaKexLmcwWnPcLCBRdFEc
         3Zpwh8F+PDAyPGIJG/0FoMhllFw4Pid6AaK499xUtR4Cluq6w882F5Fma1MaWt8PpX/F
         7jD1j7FXd+tX17ex341+acX4tArmXsCzLiUxZIuCxYcDTdMN3NgVfMdh40TOQKVNwzjc
         GaYw==
X-Gm-Message-State: AOAM530+HylBK3TDaZ7BFL+QrCZeDI0OGuoTcfmk4JK9KjYCLiq7+419
        IbxS/wSkxdOapRgvuTA1RFE=
X-Google-Smtp-Source: ABdhPJyZcZ+uhlJPy274cyZ8niw2hXYgNO51gq+QIOEgXQuxtdlvmCge3JI6izQytcHABS9Ryh3sOg==
X-Received: by 2002:a5d:4311:: with SMTP id h17mr25129381wrq.263.1629897171302;
        Wed, 25 Aug 2021 06:12:51 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id m24sm1992408wrb.18.2021.08.25.06.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 06:12:50 -0700 (PDT)
Date:   Wed, 25 Aug 2021 14:12:48 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.61-rc1 review
Message-ID: <YSZB0FB9YNd82bei@debian>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Tue, Aug 24, 2021 at 12:57:30PM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.10.61 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 04:58:25 PM UTC.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210816): 63 configs -> no new failure
arm (gcc version 11.1.1 20210816): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210816): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/56
[2]. https://openqa.qa.codethink.co.uk/tests/57


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
