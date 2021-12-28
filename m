Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5730480984
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 14:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbhL1NWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 08:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbhL1NWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 08:22:43 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACB3C061574;
        Tue, 28 Dec 2021 05:22:42 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id s1so38441946wrg.1;
        Tue, 28 Dec 2021 05:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u/Y5tryrucMPYkbCTcOCgY/T+rgSAfOTm4FF5yMgluY=;
        b=RnxLUh8IQ2MbLiR/VSwEZHynEIq2UcaTlUr4GhA8bI9tdzJ3wripbsZvUJpHQV3sSt
         eDiWEdVaYpS2Tg3B0fWQ6eHDfEbsHe9qlY3rD2JLHcLz8rbz3aJHkRCQWcR8BETnbQR7
         5k+ZfYcCFesSwk3AVpA6GcZjStUO3VYRuFs4KGjzmp+NZm/A3g/TFPt6Xv4oGM+bf0Bb
         sRUKeWs+KSKXAELigr9hABf11QmNhK6MUi+oto7q2oSHx7t/F5dYxtvjITImpCYtNESI
         xHI98QBcRwF4TT9D4Un0zojLyTtQZDcfgCiUgUx8ZwmrcWQnb7gzqb5Vf3tMbXAWi6/2
         1L7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u/Y5tryrucMPYkbCTcOCgY/T+rgSAfOTm4FF5yMgluY=;
        b=kNZBUAzrohvcBvPbaBpFyIpvpHjgFtaB9EAN3iCVptUgXzxVMsnN72K8T9AtD6RJjP
         JGzEXvtq0N9wkw+JsSjZ3moXC2lE0EMmFNX7G3B7/DqJ6bKxs5mzFnioT1bkwl5fMg83
         1XtMytZqUJ1q6DzwyrGCJmWOvjCRdki8jiJZjX2M4rZQrD2m5IsUWezpDusWrj0GwWZi
         y71xk3/JEQo+SMxTurVAmxsnnA9iUoyIREwn4DnJ+28kO8yP5M4FUVIyrKtogd6JLR3x
         yawN2RASMwIinr/klfqn/J6tnPiKh6ougNSZK166cduPVgLOkF0/5pAG3pLQ9ZFSxMjq
         lzQQ==
X-Gm-Message-State: AOAM533aZ+egj6VJKjgJsaPaWx0brDycZstdbdQXPL00BXf1h5eNIMuo
        bUPT9pQdpIRBu8pB+nbKGl4=
X-Google-Smtp-Source: ABdhPJwHMb+CiMzzlEZwGWAlZpcxTZuCk9UWJXKaumsuE3tUYY79rBoW0XRFfUDiSVIV9tBi5BwU9Q==
X-Received: by 2002:a05:6000:186a:: with SMTP id d10mr16629049wri.347.1640697761359;
        Tue, 28 Dec 2021 05:22:41 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id e1sm18684504wrc.74.2021.12.28.05.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 05:22:40 -0800 (PST)
Date:   Tue, 28 Dec 2021 13:22:39 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/76] 5.10.89-rc1 review
Message-ID: <YcsPnw4seY3sK1/F@debian>
References: <20211227151324.694661623@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Dec 27, 2021 at 04:30:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.89 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211214): 63 configs -> no new failure
arm (gcc version 11.2.1 20211214): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211214): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20211214): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/556
[2]. https://openqa.qa.codethink.co.uk/tests/559


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

