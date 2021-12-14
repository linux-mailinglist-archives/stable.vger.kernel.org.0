Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2B84742C2
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 13:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbhLNMkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 07:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234048AbhLNMkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 07:40:08 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0368C061574;
        Tue, 14 Dec 2021 04:40:07 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id p27-20020a05600c1d9b00b0033bf8532855so13664677wms.3;
        Tue, 14 Dec 2021 04:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dndo8j4UzehaTo5bKy7wwG1lr1AlLkx6PDj4DExr68s=;
        b=Guxxe2oLW4eK6A+3rBC1L92oE8/Iol7ayEgqB8m1Q5SWyIQVssQPEJOtn/Oe9PbsyZ
         b7faUrE12StIJmkTYm9FplnssDslhpvZihyf9fg4ZqiY057GiHbg5302BU6IQkp2sjd9
         yQGjrnLOBEBLOIBLMC8zfy0zQJm4WwOLHxhg7tfkqV3oYd+cxtVw3gszI9XzlCRV5BDS
         TWZp2pazWHpQm9sigJyAfGKx4aH+NolYrrTJi3rpO0Y7b4CmK0/p2xxc8lFwIzSP0kiR
         jA12UoFxSxiADoBaiXjk0uTJtdYmTl5GTUFYaa9vZUgAfdu4O1gOv5m1JHuOg1GYn2T+
         chzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dndo8j4UzehaTo5bKy7wwG1lr1AlLkx6PDj4DExr68s=;
        b=iaqFol3w3/DVYQswN4Zv1co/EcLdw2UUhohYpMIFSFyDmejBiiJGjv/zRNi7h7t/em
         RvCSKUw49FdqRnrpELo+1E44KHOXWIzlcfnvalwraN9YyyHlvP1N5gX6oryMcV0rkt9q
         ZreZbwpEHktX81Z695LzlJ+VlV2cVlOTx+dldpxGvdaAfKj2jeLsqnC20cyyKMf8dboC
         FujGarZIP81ucolRZzplynOzz0GBKY5mZs29qG7rbR2GDhPaRAGET8CptqL2HhFZMKIY
         P/EGBNHpNq8FPKGccoT1BX5d0fJ8351kP8mcWSumvd1E19O+5anqFveom/0KFj3ZpWEl
         F6Tw==
X-Gm-Message-State: AOAM5311NhH7j7TyyuM2tHHix1g7Ouwvm7DjTyr+yUHDAv9zKtuhnN8M
        QFrK5fHUxQf32GD2SUz04eI=
X-Google-Smtp-Source: ABdhPJwVXu4rLY0L/obmsActU03b7ywxHGbuiIXd4S3PnUGsrkBXCuR6sjcY+MCE+IiQCyP0+vM/Ug==
X-Received: by 2002:a05:600c:b42:: with SMTP id k2mr1125227wmr.6.1639485606303;
        Tue, 14 Dec 2021 04:40:06 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id r83sm2037596wma.22.2021.12.14.04.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 04:40:05 -0800 (PST)
Date:   Tue, 14 Dec 2021 12:40:03 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/74] 4.19.221-rc1 review
Message-ID: <YbiQo9FCvYEUtzBh@debian>
References: <20211213092930.763200615@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Dec 13, 2021 at 10:29:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.221 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211112): 63 configs -> no failure
arm (gcc version 11.2.1 20211112): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20211112): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211112): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/508


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

