Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54D33A2796
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 11:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhFJJDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 05:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhFJJDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 05:03:25 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0370CC061574;
        Thu, 10 Jun 2021 02:01:29 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id l2so1353558wrw.6;
        Thu, 10 Jun 2021 02:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4dpwSf8vT6ZCk9fHZ67LbAm98yCy+a/1aUnvXz/Mv6U=;
        b=Yz1qT65yQzMBpxR1aYxjRrHl0iIApV9zHOtqaZ3lve77U97GnP8hNWAX/6IjoboFPV
         Q5eIFN82ivi0n2yR1RuimtiIitjEYy/DZ1tDsXDGnpPrnN6I5Y+PuOrDFjbio5Tp72tG
         q1Vnm7lifanjACQc6Iu0TcM7liBWVxXZY6xQzfahbgFNnrQa1EgpHjvGEk21rj0Iu1sB
         sfaECm+gXIfU/Je0MSlUvS1n8FuATu6VQDYcgEaxiKkV1Ioq1XScgEknxG68YzjWZlcC
         6HIshhR+xZaBy7yTdDWz8by7eLU99tUO3za7gjQtMmydn7p8aDkc6WZi2hNYTItxlhmh
         N5aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4dpwSf8vT6ZCk9fHZ67LbAm98yCy+a/1aUnvXz/Mv6U=;
        b=FjbrAwPUkEf+IioP7f3leg2GxorITHJkft27WbGLl/qcfVPHRq2RsMXDEyoUwNfpnl
         MiHKNlINpmDTKA+crqVk54lJSHyKqan5EkrpIzJ4YuoCpjQLkQHH6BIkWkW393JQABWi
         pRnosWcmHmJFs+pu24RRmSMKhGNaISkmOFA0ZsRW2VK//5r8stXds4uUHSB5XdxlejwF
         Zu+bwKAwy+Gc3Dj0hyKLCSn/X96humO6w8UXCjZ9Dr2kqvQWaGMZ6VvmaF09fjec6fWd
         xAmI4+UxAUYvPZvgyG5VdlRIvSkwHIR8kCqHexd1ciE/HjLvbt1fQzwAjyY/NXtDqi9m
         XB+Q==
X-Gm-Message-State: AOAM533bqkyeaUFdSc8hyehmBaKwJ1+KOZ5H0MrE2taZ/KU28tLt2uK0
        4EGadI0WMtlp7QUScwhj+o4=
X-Google-Smtp-Source: ABdhPJxJC0OUaQM7kH2MWGaNpfzjKP/BY0Gf8wNb38ZzGQBjLb+U3+XCK46503a3DxiUQAFTWZvlYQ==
X-Received: by 2002:a5d:6e04:: with SMTP id h4mr4062789wrz.256.1623315685955;
        Thu, 10 Jun 2021 02:01:25 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id t1sm2663837wrx.28.2021.06.10.02.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 02:01:25 -0700 (PDT)
Date:   Thu, 10 Jun 2021 10:01:23 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/78] 5.4.125-rc1 review
Message-ID: <YMHU4zKBr/JzHFVA@debian>
References: <20210608175935.254388043@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jun 08, 2021 at 08:26:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.125 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210523): 65 configs -> no failure
arm (gcc version 11.1.1 20210523): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210523): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
