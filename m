Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A2537520D
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 12:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhEFKKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 06:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhEFKKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 06:10:52 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDA1C061574;
        Thu,  6 May 2021 03:09:53 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id l13so4953252wru.11;
        Thu, 06 May 2021 03:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8sIwEJh4HjlXuG6I4XNP7bLqTcMznE26g5IhwMtvW5c=;
        b=YIwSC+XZecnmT+x6EV3Qpiz3FndgnoWZuPkXqrY3H/crmG6a+I3qGbc2uHu4fqGPkA
         +hvx19W0ApbveVrDS6Wdyr8SyBR+4Ojdopt+GUQJQcUpxVMinxcH0X1I6NoUu6BeZIJe
         2QsD/ijFAtgvlZuKv9rfoTIAap1xDAV+uXL62QDGVsfj4vJeQEXNiXYfkMiKJCxLL64L
         XehX3t42vaGGLGKxtcl0bF6I4j5snjLVPdNcc5g7wMZ5dEHEtzO0eX4N4zcT5W4XUpbh
         SOug6NoJ/9O1tIVPACCOIpV00WnT/hgUIXsGLowe0KRXVxpVm4qFeozADSAk/p+HgD/L
         mpNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8sIwEJh4HjlXuG6I4XNP7bLqTcMznE26g5IhwMtvW5c=;
        b=DAMRxQbyWKEyRWfsmNalJV894XT9X/pBzeWGSBhlXO0l8gCKY0fLQziliWfV90y6aK
         xUqF/h4zGUYERN1kvk9U5o+FJ9hjqYUw68or7caVLnVljbs5CoInsCtztA7EELnJEr9G
         ABYscViQbXn0Ka/5d/USjKZXy048lgiH8IUc1KyMVSWou2rZ4JmddnAWAx5LaHu8JVXb
         tuYMbnbAb8VFYh4hJlOr9jpe75QWvmX69Rwpt9VoBSan6DvwQi6d7kp1I1dIBweMFYYK
         uKkaoVmO7tLm1dFqcOFOaE/rs1icRdYncovEDXbJ6RecgGVxr/dfUmEWUXZj2hZf6H5G
         7ayQ==
X-Gm-Message-State: AOAM531U2oqtmKo9hAwIwUJBWYLOzhgP3gPz9gs4+VYNihiGKLYjtte2
        rSeYFx5lRA2ZcHg/NyBXqNU=
X-Google-Smtp-Source: ABdhPJz3V63K4IRuZCOSXGng6XgNyEpTWXQ62UzhH/bMcyZBAdmADJUkmh0eGhtTJaph9fF7p/YXBg==
X-Received: by 2002:adf:fbcc:: with SMTP id d12mr4063748wrs.151.1620295792073;
        Thu, 06 May 2021 03:09:52 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id r1sm3555038wrx.22.2021.05.06.03.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 03:09:51 -0700 (PDT)
Date:   Thu, 6 May 2021 11:09:49 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/21] 5.4.117-rc1 review
Message-ID: <YJPAbZyzcBUu4OUU@debian>
References: <20210505112324.729798712@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505112324.729798712@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, May 05, 2021 at 02:04:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.117 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210430): 65 configs -> no failure
arm (gcc version 11.1.1 20210430): 107 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>


--
Regards
Sudip
