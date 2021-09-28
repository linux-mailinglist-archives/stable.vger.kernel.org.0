Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6742B41AEDD
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 14:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240535AbhI1MX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 08:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240571AbhI1MX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 08:23:26 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC68CC061575;
        Tue, 28 Sep 2021 05:21:46 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id s21so17665693wra.7;
        Tue, 28 Sep 2021 05:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DbV4N5PhqJtlgtuyy0h3X70tpaeuVVIyfxNq0a/QMSQ=;
        b=ORwcHqKhhrxtA8IobMphvT/AJFHPxQ3pNnDqr3il3+NOnuC3ztwAZ6lxVKotK+r6Qk
         sBP+onJaPBGKogK2rH+gQB7CNwFYsiwA5sERxAiMXLZ8e8Egu2X6/g9IkuQVoIWzHnmM
         pwNt3FtqqHAgaXtg6C76HpdKL8znHi2xbgiBgfpV4RcFZZtjN4REEzHuMP7SVnAYIaHy
         dkGlPL/WZ1HuOj9nLJr5FQQsDMayjLlH9q7uDCW7j6+zkQyXOJB157K26Y73XVPkdQPm
         r5AoKVonnpfF7+Oh6Wt3M91LHdFkPpVmQ4z6M2fbWzme88GuLDyzcHRC4n/aN13hoAbs
         K/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DbV4N5PhqJtlgtuyy0h3X70tpaeuVVIyfxNq0a/QMSQ=;
        b=AKL3fx4Z78s4Ykj/vW7wURQQuLllRTkonrmxBhnj1V7uKVEgWwXFvcOX4/qhC0mt6R
         Ul3dlwyamfiIEIFYfAFWKhTIPwWh9DqSltHLDhAPCSvzfeGz3ZyvtVopoi1XyH7DTq2j
         Z4101ZPpVIRkY0/jfAmvr2rAFzBckmkfUP0wEe0+2OLjcku3FbjYQT+2xvF27dE1lzdg
         Zs26MJr0r+4OkujOSxbty2HL6KhLyMDz4LDeqG8XgqiRffW2YKmOEh23c6QFJPqJSA/Z
         TNpcdhcGxF1+sPAfAZYtQ8FFsD+512VyzsSyw9VpirejwupbwHjViU/dNVh5Zu9CPiwp
         DFMA==
X-Gm-Message-State: AOAM533s8HwO7VOQt0/euYP4RMx8H3ectwMn4sbJaKU/SHRZgxdMNRys
        gI/tUfloDGS3nCaDYdsBFrw=
X-Google-Smtp-Source: ABdhPJyu/h5gAqCKXLLsMoqRl57IUXijmIAmlj8gdckjlLxFYIMW9H0ioMaOlasRijdQlLzZMMfbgg==
X-Received: by 2002:adf:f601:: with SMTP id t1mr6278550wrp.9.1632831705566;
        Tue, 28 Sep 2021 05:21:45 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id h18sm19431082wrb.33.2021.09.28.05.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 05:21:45 -0700 (PDT)
Date:   Tue, 28 Sep 2021 13:21:43 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/102] 5.10.70-rc2 review
Message-ID: <YVMI16dlvISnq4mK@debian>
References: <20210928071741.331837387@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928071741.331837387@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Sep 28, 2021 at 09:18:56AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.70 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Sep 2021 07:17:22 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/200
[2]. https://openqa.qa.codethink.co.uk/tests/201


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

