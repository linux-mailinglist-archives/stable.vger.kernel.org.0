Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5357649C886
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 12:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240625AbiAZLWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 06:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbiAZLWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 06:22:06 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEAEC06161C;
        Wed, 26 Jan 2022 03:22:06 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id c192so2117788wma.4;
        Wed, 26 Jan 2022 03:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=htc3FEW6U45e7eGmBICjLPQtBJO885eqDPGUS1h2BH8=;
        b=ftYYUMqx2/3aVFnBOQKnfdDOqjj7peBH2uqWnfO9sxwuTbLAvBPJED7R2NdvTQFFLp
         r+Cc0EkSlyoSMlrJtw4EvGeNEv8DMoJ8k/5r8gw6d0PdEoU153WKLPShvLN7SpQ+6OsF
         BqI5mOxr1SpWOH/p/GEcaQ1RT0DFFtlvHBu6jp1cb5SG4ELJpVji+LGNkWGOzVJVDw6c
         MnxG9Xgxlq7MxfPh46RMGbvPcr3YVbdncpV47mNmMnXPZ9jG34fmhmDbhbaRCQi+Dyjm
         08MznjucVNWNsvG7V1O5Zq7IcDl1YsBfdnb024P9omQ6fXw2RNlSYB/6nOhTEpiSOGsa
         iKFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=htc3FEW6U45e7eGmBICjLPQtBJO885eqDPGUS1h2BH8=;
        b=gKASktb5Jf9tGBX8HC0FHJAWotMCBV6JA4LDLmzhYjOWzLsdhqUgENBB5zEpKQ6RUg
         xHg6t2o/E+LgdUvnI1Z3GiN8RHtpKmT949TnDcOPZF+1tlLF9NGEJwgRH/bmI9mnrjk2
         dl4o91TGJVJi9PbamImGSC1IEjbx+I6izFm9ufivzMzPBWiBVemqGVy3S9/tPgnosp8c
         bnbvaP6sgs8uWQweebGVP2g3BX5+dCblWrNbfULmXusiYMrp0LCW8SgHpQny4oicfQ0N
         nv9R8qmKHRGLxPyfiheCJyHCYG2KdIQPXIwpfJuGmtTbRUqpwrg+JJGW0/G7WPuvmcy1
         m0nA==
X-Gm-Message-State: AOAM530va7l7+K1VgT79jActRdXRzuHAAbz4XTT7iwg0sqUuUkI/DT7C
        nEcP28QbSyAKUKIE+uq6+qA=
X-Google-Smtp-Source: ABdhPJzWbESM74NMiobRCtslHqMsmdmqXpDQHza60W3VPZMlbAFKNAi/3a2apDHj+ZjwGF6E6T6ZZg==
X-Received: by 2002:a1c:721a:: with SMTP id n26mr7108624wmc.118.1643196124779;
        Wed, 26 Jan 2022 03:22:04 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id y14sm14903309wrd.91.2022.01.26.03.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 03:22:04 -0800 (PST)
Date:   Wed, 26 Jan 2022 11:22:02 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/841] 5.15.17-rc2 review
Message-ID: <YfEu2mLqNZmyMUBA@debian>
References: <20220125155423.959812122@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125155423.959812122@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jan 25, 2022 at 05:32:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.17 release.
> There are 841 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 61 configs -> no new failure
arm (gcc version 11.2.1 20220121): 99 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/660
[2]. https://openqa.qa.codethink.co.uk/tests/661
[3]. https://openqa.qa.codethink.co.uk/tests/653


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

