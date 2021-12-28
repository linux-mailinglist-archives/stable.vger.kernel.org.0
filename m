Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042C848097C
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 14:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhL1NTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 08:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbhL1NTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 08:19:03 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F234CC061574;
        Tue, 28 Dec 2021 05:19:02 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id b186-20020a1c1bc3000000b00345734afe78so10070108wmb.0;
        Tue, 28 Dec 2021 05:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bDb0kJmueK3fnTgDSSIcWoJthheJr9w8Abj9HHv7swQ=;
        b=FTDuvcxdYNW7UadnMddK9oxiBXuuJ5PAmhjpyNfoLFMkbI0SGHcwDTYOZtPh3P4LNu
         SlYeakemUlH4lk+KGt+vVxFkQYR8zQcxx0kPmuUcojedlmoByThe+5n+IMgh9ZBJJeBY
         URxkq+NtoiKXY1IwlSNP1tr7GYSVeHTQfPa6DclUWL0VWMWUGRPs8/QgmEneQS97ujMP
         JSt0+lDCMpoHIwNZR0cYAzI6d4ASWZnnMlFqYRNxmHjCP7fFyqw2vc8aGZaAp358U1QX
         pMWoAUaK47/c450dEoRm8UV9QPn7mZDKsAq7WCIQPgH/1zvsE3ZPVTx/zzRt/2kpbmp4
         GLcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bDb0kJmueK3fnTgDSSIcWoJthheJr9w8Abj9HHv7swQ=;
        b=ie/a4zqRPG6km8WfAB29DNsJC2E864WbDhC51+fPl6OjHUIXviZnY2uXxyiuSsxkQE
         zOODjxid7HxDZ5YlZxOQBdtDPLOQHOM2ozTxAAZZQtKAejyinX7M5WYCsHNVOr5QyDQM
         5HqSZ7WDwu7ZnWuTV7x+h2+eMACQPHlqE5TXcFg80hkPtC4wBYbp8bzbkBzs6FkDPj7y
         ouwjlrZKUcTGPRt5o9Q8LFEbardoRADOhwakUrggRE1l5TxQqrDDG342sLBbmuX9/2YK
         ukJTOos2qOOvPSsviaNqRktdU8qOr0VbZ24A+SlkDpJGY4zdMAZt/ffW3fXFB2muSx8L
         JUBw==
X-Gm-Message-State: AOAM530WY9DAOqNatu1/oDWXeowquP8UMkViiPnjPciY7GHdMOJrlTLa
        r5hySA2AQv7zembXQjSIwnkh0VJV5Q4=
X-Google-Smtp-Source: ABdhPJyiX3X/0tZB+xVwJu3lM6W4EPCt7X5IbOrgwu3OHuV9wg/6pVAniTNqzXAgKA26gOlS8FLLYw==
X-Received: by 2002:a1c:9897:: with SMTP id a145mr17134708wme.194.1640697541584;
        Tue, 28 Dec 2021 05:19:01 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id a3sm20208694wri.98.2021.12.28.05.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 05:19:01 -0800 (PST)
Date:   Tue, 28 Dec 2021 13:18:59 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/38] 4.19.223-rc1 review
Message-ID: <YcsOw/qt1OAp754K@debian>
References: <20211227151319.379265346@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Dec 27, 2021 at 04:30:37PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.223 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211214): 63 configs -> no failure
arm (gcc version 11.2.1 20211214): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20211214): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211214): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/554


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
