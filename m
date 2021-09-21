Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA680413A78
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 21:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhIUTFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 15:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbhIUTFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 15:05:23 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4481C061574;
        Tue, 21 Sep 2021 12:03:54 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id w29so42260942wra.8;
        Tue, 21 Sep 2021 12:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n7GWCKg3cCOwiG9pm53ht4H27XBUoaE8taZqWcN7rMg=;
        b=ZFxXAltSR4br0PvNGxEk0+VvMfrnbmZJDUGW0xusLKWg14d9nE28iyhTpBjNk1ZjIh
         MUfYmAvePgINK4Eb3iP9PLispHVXUSfePIy/Qok1wut8mYK78DbC0MrAwOhY+oDX9zv9
         5kpLpJyNlAMqztl6I+yhR1sxrUlc7UmVcul1Un24kovGLVz8hYNh/n3dsDKHnBVQ6Pzk
         F8J/RmFp3yy2VrIeDu1+MIB2GF+CBBiZoiOQwoe06uL2phgSby+7p2/TofiFlxbWd/Jv
         UDPuxNPrdSw1xwUKThZGvEG2emd+Jmayw2o9cIBbIrP6CjcAUs3Z52F2G/3jLQbkBXzN
         POEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n7GWCKg3cCOwiG9pm53ht4H27XBUoaE8taZqWcN7rMg=;
        b=6RdVn60IL0EmGuO1gPJJgmFdctHTwQNwSj4AZ+siGIZCoMWEoxnPkghTERsjQzYIH8
         0JAQ4fgI184q31Q6mOP+pEk4DLVSHC8efo8viB+Na/LOQhrRhMf/B6yr1yvx0dPV4ZXq
         HJqTU27P4Lc9uNYk8fzLxvGyjLSFfU/Izza2GdQHdWyuaCi3dqSUA0OSK9t+jRNVv6Aa
         9CKu6gWh8VLTQxrlXH/WoYgpkBKuyuULKP+TeTYkIdautyTLpRnXcJVmCbD4S1uPejPu
         trq+3w57Owju7s17ZRhn3ITF8einjmYyak0g5bUfj/zaUOi+FfAS/VFSHegcwygW7bVg
         782w==
X-Gm-Message-State: AOAM530ufwPV79n39dFC4RvyD6WL4c3+fwJHXY0q++9+YepELaEM1Hbq
        hgg5Kn4sgQiG1b0f2gWMh/fN9alOhso=
X-Google-Smtp-Source: ABdhPJw7SshZdH0jr2I+omxee8Q246hpurK7ngvQPx1mRAlUUoQWIj4y53VfPJX7XIw6WypqV44Puw==
X-Received: by 2002:adf:e646:: with SMTP id b6mr9609933wrn.153.1632251033208;
        Tue, 21 Sep 2021 12:03:53 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id s3sm18871216wra.72.2021.09.21.12.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 12:03:52 -0700 (PDT)
Date:   Tue, 21 Sep 2021 20:03:51 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/260] 5.4.148-rc1 review
Message-ID: <YUoslxy0UxJ0Pq0h@debian>
References: <20210920163931.123590023@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Sep 20, 2021 at 06:40:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.148 release.
> There are 260 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20210911): 65 configs -> no new failure
arm (gcc version 11.2.1 20210911): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20210911): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/161


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

