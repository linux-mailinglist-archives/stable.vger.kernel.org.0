Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59426423AD9
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 11:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbhJFJvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 05:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237825AbhJFJvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 05:51:12 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A04C061749;
        Wed,  6 Oct 2021 02:49:19 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id r10so6945758wra.12;
        Wed, 06 Oct 2021 02:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MsuQtEChoXXsQ8RTArm2X9b2oKTiPMrHWJ1ndi5wCrs=;
        b=fskZcF1nx08cvXD6AI60wKP2ls/YzpKVOP6d0ZFPxqT0V/XsSwhkjGqMUIjFgfCT5n
         3DAoskUkv2farToUXHn2jZ85ijkdtGXMmxHPwTe77PUJlNBZet+tesyE0q5Qad4IBOwl
         lRFr6Tj0daEoBdNw72DlJZztgieCIT4R6XiSVuP2M+Mngarm6auAyb9qlAirU9ZVPaRy
         APYYAFsQyLtSx7QHXVWdwlOJ46qaUpIyO4Sd5DZoarIBNq6CFfS2+9+23nLcKZoVbZG5
         F2RJldYO1Ki5Q0j2w+LDYCUrq4TbLrunY3yiHmS6IdAYmzTLY/iYTVZzx1VrSUrmSnjj
         kXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MsuQtEChoXXsQ8RTArm2X9b2oKTiPMrHWJ1ndi5wCrs=;
        b=zZJpl6R2VBLdDq2QaXiXnLZgVV12aa+XHAkYpgcBKPH0dAaomzVwyi/7AVPvA+74BD
         dV1BcRLGTq56/qTvtGU2WA4OmMRlfRL4AJYLAXjnBi71VKT6vRnBQY6eh9whFBEUnGz0
         l1r1eMOjDCbx6q3CjSYt4UMghrb42CQKdX973N3HAsZHYcyajapBVv2hJd/+8+BH0CSs
         yP1934Ir+MmvwLaDviLKi7mbqUlNdxJiTNKuy0JYJkQs2Z+XaJOLn/rs+IrbffqR5dEv
         U+tt8bB5zkvuOdzTMeQIOFMTjDgebe4RvonF+r11ilv0wPFVNeDzN32rTQaQ9KCptknb
         vTjA==
X-Gm-Message-State: AOAM533820iI6asNrlQCCkConzYTVMtWrNtSlyyJT9FLZNI1VpRSYSUP
        VoY34oEHEGdWJJxMVjXNvb90EvSX8mo=
X-Google-Smtp-Source: ABdhPJzaNw0csQ74NHWdx7a7mvZ7GbjmCDGS+FUSlAvDcTkFolgbc2qxJBhwWmZjM93y4jyQG1OurA==
X-Received: by 2002:a5d:5234:: with SMTP id i20mr27970917wra.415.1633513758172;
        Wed, 06 Oct 2021 02:49:18 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id r9sm20348340wru.2.2021.10.06.02.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 02:49:17 -0700 (PDT)
Date:   Wed, 6 Oct 2021 10:49:15 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/95] 4.19.209-rc2 review
Message-ID: <YV1xG7fvg1lX26PV@debian>
References: <20211005083300.523409586@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005083300.523409586@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Oct 05, 2021 at 10:38:15AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.209 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20210911): 63 configs -> no failure
arm (gcc version 11.2.1 20210911): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20210911): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/228


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

