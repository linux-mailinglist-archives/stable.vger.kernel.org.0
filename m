Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542E33EEE58
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 16:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhHQOVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 10:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbhHQOVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 10:21:08 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EB1C061764;
        Tue, 17 Aug 2021 07:20:35 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id f5so28842634wrm.13;
        Tue, 17 Aug 2021 07:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kud0R4s5J4ZxrQy8EYr4HfsL8mUPaVIbcpQ+SJ8a8bU=;
        b=PRTWrzpyr++RKGPEmwcqovtcfGliAFoG6g8y4Mah12nmHPGXaPIolDe4Uq7p/DwZRs
         KEcM4Gt4lMFrB/EcD3zQLqMXGx3daPgVLalh14lcp3p+3VeT5tFBCRmAs8JBsjGxkCd3
         mRbE7va9DbO2Rl8PHPqgZmleHXdTrlmp9Qros4KAJ5fARZrqlMTAOZwELFRzf6qMHTwH
         SwuwQmtk5aCgNXA3Ma5RfkJXkuyRCOQnyshPxahD/QPG7EyLQSzmdlTr5hG1DQcTUzT8
         IoL8cMEj23ap7zBwszuuwj28w49mTS5q6+XXdQigNcaIlFUbZ5bBIqgYsndJ1EpFZkpM
         2ZIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kud0R4s5J4ZxrQy8EYr4HfsL8mUPaVIbcpQ+SJ8a8bU=;
        b=C9LDBlcXSl8zm3s3bbHPBf/5b2zIq35iAyQPVx5KbMYzLDKpJfYmElUTzHzEoXKflo
         CkruumMQmDSEUA3nHD1yjl2/Kre7YsNpw7PbW0hAbxpDVk4geIflshoZVIVkJBg8GP75
         EazDceYl/+UXjNhSLP0khi3Rwm5iacw3JfOdJrdw+CASoG6XFfEOrMRvoHkugs8lxWCC
         dBEXzQj8ZnfbE9//Y817CQu42u4lqj5XFulrfBIJbz76bDBnbNbw/RS6f7Am36i9p9K5
         TNdnefG1O7JOgnqF69Fh0xM47y1Zxujn9hqJQ6xoScHTd7VKZZnWYziqbLktaAUZECOT
         nYYQ==
X-Gm-Message-State: AOAM530jVPwUv3VA7lkIDEytSBHlwp9Lkj6GPn95ENy1uLVNRHpw9NH4
        yxz5Cc5m8nGeTX5j56gdKhA=
X-Google-Smtp-Source: ABdhPJyLLIXMRjmTXVoi576LQZGL5K3naJAapeyZjCq1aE1J5MWhH7vsKsgLOpWV4cvfE54R4nIdQg==
X-Received: by 2002:a5d:4b01:: with SMTP id v1mr4345939wrq.377.1629210033608;
        Tue, 17 Aug 2021 07:20:33 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id e10sm2565278wrt.82.2021.08.17.07.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 07:20:33 -0700 (PDT)
Date:   Tue, 17 Aug 2021 15:20:31 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/98] 5.10.60-rc2 review
Message-ID: <YRvFr3baKTaJBvBk@debian>
References: <20210816171400.936235973@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816171400.936235973@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Aug 16, 2021 at 07:14:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.60 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Aug 2021 17:13:38 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210816): 63 configs -> 1 failed
  decstation_r4k_defconfig build failed due to new binutils. Reported at:
  https://lore.kernel.org/stable/YRujeISiIjKF5eAi@debian/

arm (gcc version 11.1.1 20210816): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210816): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/38
[2]. https://openqa.qa.codethink.co.uk/tests/39


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

