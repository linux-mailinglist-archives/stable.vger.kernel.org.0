Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9B33CC525
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 20:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbhGQSHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 14:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234554AbhGQSHL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 14:07:11 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC11C061762;
        Sat, 17 Jul 2021 11:04:13 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id d1so9741493qto.4;
        Sat, 17 Jul 2021 11:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j/SWuIdnhGXsNdb79VuXvyClkL1BGz4T4VnLn5ehZKg=;
        b=bwI4Srj6licUIRfOckftERRtEuhgZzz8r3jOCFtogMyI/m2jhIAUoy74FfF0umg95t
         q5A48FljX2w6s8eNnpJ/SP1RE9ooh0ZbnRSU6wsGucnhA3CaFkMP6X7m3LIyuo5Vgklm
         AEpyQfxhBknCjkpsnafmW7dEZ6zAPnJcV8bj3faIir3u1PkIvNGK7yV+dT+/SLHyN8X0
         S09NbpqZtBNLEIPg0nmnlXF/oe3yxqvjsY/63wsEwKaRJxooUt0jDjSVub0dxZUHUH2A
         o1P6sPArRe1m3fjGFiAruzIbyEjAPWYpAcqcow80fYdxxlTlkl6WInDGKg/fC5PKdc3M
         2IEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=j/SWuIdnhGXsNdb79VuXvyClkL1BGz4T4VnLn5ehZKg=;
        b=pFTKyxb2hjd5vG7ACoQE0dqUDBj1OZRf0XXbcprlRTjDmfQEalMfHTC3QLc+dfwisx
         y4ycPLVXh3Cj0vudejNuP1ZJvSSWSdkfHUm9ZItIbmtHNb0e3sX9Vx2ikZIzoXNFDi+f
         U288TacgJp09+GJrrpDMAt7lvUBTDZe/MSOVT1cggl8qZMHjiSt1OJz4cugbLVCLyedb
         LQxUkUdQWaecC1reTQHfFuGvqZDXT3u9AP7CPh5lTmThQJZb5iwdZ92asSy2nWdgJGnc
         IOqVj3zagXRe3W097v+cH9Jt7s8hClxDu4N7CWza9lqLrNscIdTYzMUMaQoy+tMJ3LS7
         lCrg==
X-Gm-Message-State: AOAM532LeIml8fWG1CE2qR1oRd2p5eHrLJvrcLuimVNDNujbr8np1Z90
        BJyY0OM5lo0RxZPAdQrNT0Y=
X-Google-Smtp-Source: ABdhPJw5n+D/2y0t13untjOumi7/m4BHSM2Qn5teuGswHlbRqRKw1LkwYtTlfpUR1YrFCK6Is1+zhA==
X-Received: by 2002:ac8:140a:: with SMTP id k10mr15144458qtj.190.1626545052587;
        Sat, 17 Jul 2021 11:04:12 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r2sm5487441qkf.94.2021.07.17.11.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 11:04:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 17 Jul 2021 11:04:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/212] 5.10.51-rc2 review
Message-ID: <20210717180410.GB772394@roeck-us.net>
References: <20210716182126.028243738@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716182126.028243738@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 08:28:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.51 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 457 pass: 457 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
