Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0C53FED2C
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 13:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245623AbhIBLxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 07:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234069AbhIBLxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 07:53:14 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31146C061575;
        Thu,  2 Sep 2021 04:52:16 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id t15so2457901wrg.7;
        Thu, 02 Sep 2021 04:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=REU/zWX2TwsWxawKdowJSturRLawxrdcJa2xlpzDP3o=;
        b=T4KW8fWe//wfjeDeS90FONrdpKo+3S0vJU0QAvnJF/Am/s3sHr7Ish4t9RjwG4ewFL
         tn0bcMQfBNRYaWCgsIShd2MAKdXqW5Jbwv3Gab0X1jEw72SdhH8yE32UGdx+nVuz/TTy
         7IxQxu3yZhuNVRH+q7yw0o1qNuIH2HX3d4lXixfzk1HuKSM+Rems48W6baBPf+kvVKnR
         A6FDEx2JyHCGhSQZSbzBmGYmrCQ/7kbM5gCmW+8vcjt/iJzkzjqs84Zuzm3UpOFn3yRi
         AXlsyGZ8Q0igK0g1kY4LVxG7nTB9rsiPCvlVLzFQN4nxmN6ZbwKRlCnpQRAOIpylftgM
         brPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=REU/zWX2TwsWxawKdowJSturRLawxrdcJa2xlpzDP3o=;
        b=HUUmJeXkYpO9mMa5sbalryI3Z2PZ8rz7KJ5bCE+UXnn4lG5GwQBxQs+8EQd93mAd+x
         C6l4I8Eiz1hR1iiBbaULNx2GsQkhviP7hA55g8lRrCZvDkUbKiZR0zzkhdRkmGEngKHw
         21A47pHpuCDey0e3a6a1hHUP+BL4d4Cvg5NXi2ynXVcXh4WDoic2dSNMNGOxnLutneOQ
         LEqrxnYWfFJfQTSKgW82i796hqEkC7Xg0WkSj2aKDl0Cr2phhnP8cgIf4bhIOz6oXM6V
         MNIXO/Gipe7GFTqZOyWV2PZzo7MOAxCZEGyR5YtvC1YQPKjlEm6GZbDnYWdsnRmDreQx
         ZwZQ==
X-Gm-Message-State: AOAM53370IwkAZMxqtipwLK9/2+x8H2tD9gRSW/SvExABTMJg43cgwes
        RYTWxGrSnOttflUkAIBVG2Y=
X-Google-Smtp-Source: ABdhPJytIG1qFQAfI2jjv/w/FiVbhDrQ96A1WinKU4Cdey3syfW62d844bzvS5kKnfRFA6x3bjjrNA==
X-Received: by 2002:adf:8064:: with SMTP id 91mr3222399wrk.252.1630583534802;
        Thu, 02 Sep 2021 04:52:14 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id y6sm1889629wrm.54.2021.09.02.04.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 04:52:14 -0700 (PDT)
Date:   Thu, 2 Sep 2021 12:52:12 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/33] 4.19.206-rc1 review
Message-ID: <YTC67Ofbc0PTKjhY@debian>
References: <20210901122250.752620302@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901122250.752620302@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Sep 01, 2021 at 02:27:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.206 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210816): 63 configs -> no failure
arm (gcc version 11.1.1 20210816): 116 configs -> no new failure
arm64 (gcc version 11.1.1 20210816): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/78


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

