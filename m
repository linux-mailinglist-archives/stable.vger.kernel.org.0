Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CB3423AC7
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 11:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237928AbhJFJsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 05:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237978AbhJFJsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 05:48:15 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77806C061749;
        Wed,  6 Oct 2021 02:46:23 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id s15so6935634wrv.11;
        Wed, 06 Oct 2021 02:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BzWBpymszbXLBVKCCmBTZPMuMqlMXUjDg4ggXrWcMdI=;
        b=A+LLsREHB+a7WU+bMYHFG5TQyj4f10l4PvfBk7CXz+8Q7oeXH2zNSoP8xheeRV+Ujg
         GnYnZKTrdpEyVbwE9aeGff1C4SDkGcsJjQQRYpZCWvTe7WdNThZVxyPFJMsgZuxXQxEa
         LSvRq0IunRq5O2hXHViU5IdY7GFbG1bFnCDBpIcV4gTGVFsOXsFOqmq9ppQ+t8pKk2Li
         hBSQtphG1NKQT+PZV+S+dZJ7vVyMTNT2JW3fUABF0yZmGovtVV4GKAisv+vu29AMybFC
         QHJF1vKhMumZK5m5bHVuwxaCDm1klc8WDPS5YjyXwPTsl0pYaZQT7g3wWLTIRZkszW3x
         sykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BzWBpymszbXLBVKCCmBTZPMuMqlMXUjDg4ggXrWcMdI=;
        b=TJ4uq0aNvbC1xqthpeO4a0gXsAiF3aduegILqBigTuPaM+1G3Qhjm94NQ5SpovgCi9
         hcdA3i9kHUrXgrkEIQTAtcGwqlMhZVG33y0jclTC1E/JD1DGaxxHIfn0ZlrYv/XEJQq8
         FzUrGUcjOAGhwJ2kTr8A78RUPcTQSLESGm6Ly1hmOVNPzkryWQgL0CQjHexGZJ4rOCuA
         8DSafZ7Mu3SU1C/fb7AGI5t//jIduO271xqCjUGw32GBMedRl+3mweb9byVV6Ssxq0Mw
         i+ctVt+zlYD+QbI0H1sTYMo/UyXL7fq37HOGyhRCWDTXXJ8Ur2sZW1cuCUqI2iuY44sr
         iSRQ==
X-Gm-Message-State: AOAM532L8hyc0pn3F30OuiebVAs5uPMrR2gn3RxqetZJ38WOQlpbNebb
        uW7fGommgzHWwyxzmG0LXuc=
X-Google-Smtp-Source: ABdhPJywZXqagcoPprdfpYtwDuWfCnZ36rhf7Vp7D3wGosYZuRDsVVs4kCOuu7tWoIS03b+o+ThaOQ==
X-Received: by 2002:adf:a2c4:: with SMTP id t4mr28225468wra.296.1633513582039;
        Wed, 06 Oct 2021 02:46:22 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id x26sm1224874wmi.30.2021.10.06.02.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 02:46:21 -0700 (PDT)
Date:   Wed, 6 Oct 2021 10:46:19 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/92] 5.10.71-rc2 review
Message-ID: <YV1wa+V9BAXUTKTK@debian>
References: <20211005083301.812942169@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005083301.812942169@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Oct 05, 2021 at 10:38:32AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.71 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20210911): 63 configs -> no failure
arm (gcc version 11.2.1 20210911): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20210911): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/230
[2]. https://openqa.qa.codethink.co.uk/tests/227


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

