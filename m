Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B046945381B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 17:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbhKPQzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 11:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236295AbhKPQzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 11:55:37 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB6AC061570;
        Tue, 16 Nov 2021 08:52:40 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id t30so38816603wra.10;
        Tue, 16 Nov 2021 08:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7+Jn+St2IjENzpDxhPyfEvI27AjWPnJkawEdwNfJRK8=;
        b=G6AF87R42HEdDV7OfHDvDi5SWQNB8wn2NqTDZDi4w1JtJC9p+5Q+lBf9pgwN4tWiAN
         H0ramcM/9vownJPjh2sUU4TwmzmZn78XywfZf987QHf6GQ/fS5dgwlsDwwNLhx9hHNxT
         R4vUQyccZJW8qHEcT37fzOkrMtIoa71zyYIzwoUT7C1m16j2YFo3PxdgLDvgnVUzyyH+
         ernPRoN+GAHZhvgTdR2YH7Nndf03SCSrI5cmIt9AY5ZdKgTXgkdujpr9IfpGvtWT1FBi
         K9czKifcx/pkGVLwb4PgLCRwDKmtWkaVqJ/bOSXSXWpkxUpSz7KCpS2HOuDjBgc1AHrT
         tfvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7+Jn+St2IjENzpDxhPyfEvI27AjWPnJkawEdwNfJRK8=;
        b=Fb2CgHjiVHgwbEZr6PueHaO0+sbVgcR0uRbhIAtbeyHofXF609nBGcJ9YiUbNfVAvA
         gwLYITS938ElVHiLYKZ2LoldXxa7RyhzaHrTM/+2noIyNok7szh1z0U4bMYJpan7sstV
         8P203QjMC8PN+8hMRipzwxX+tMX+0/VqYk8qoD53st7E5NPYQjj6jkAtTcyPFJvhiywn
         FnWurVg7MefK18SyhjplGdjSTqNOeY9sB+ktf6ztl7p/ZKnlMOnQDY3DdGNv+4JI6MSl
         o6O8D1UbS4A0Euwiu1bvOFWlQhVSzmb27vS1Pa0ZxWGxGL80SaBLoIaqRiyZTawI+qfF
         t7bQ==
X-Gm-Message-State: AOAM530FXM8M+D99TIkcA4NFExfS2vSsMo/YIVnPnt7hjIA748/qcrqD
        D7AYjlsmYb3KK7ScmafnKXA=
X-Google-Smtp-Source: ABdhPJwCLOSlr/fZ5Hvuheowlrl1k4TKX8GCoi/IJTloN4hUmDs2pNYz60NbJlKyiFaWTpfokBFXfQ==
X-Received: by 2002:a5d:604a:: with SMTP id j10mr11282979wrt.93.1637081559006;
        Tue, 16 Nov 2021 08:52:39 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id u16sm2780914wmc.21.2021.11.16.08.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 08:52:38 -0800 (PST)
Date:   Tue, 16 Nov 2021 16:52:36 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/575] 5.10.80-rc1 review
Message-ID: <YZPh1DL4qbf0wluG@debian>
References: <20211115165343.579890274@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Nov 15, 2021 at 05:55:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 575 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211112): 63 configs -> no new failure
arm (gcc version 11.2.1 20211112): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211112): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20211112): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/392
[2]. https://openqa.qa.codethink.co.uk/tests/389


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

