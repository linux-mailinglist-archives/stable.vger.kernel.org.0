Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E983236C8B7
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 17:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhD0Pfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 11:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhD0Pfc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 11:35:32 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC336C061574;
        Tue, 27 Apr 2021 08:34:48 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id h15so7675464wre.11;
        Tue, 27 Apr 2021 08:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FDAFvGPq6M9RVg8MpP4qaKMb1OEi5PqKteG0o+lAPY8=;
        b=OxPUzvzgu+DTH6rA2wGRrP6kgpvMBwZhsBXxOgdUxdxiFrjRV6hl9d4BCeriRTL0dq
         Vc4witzcE4yh6CwReCfI2YVK7aBDiZoQhjvPYfmSnc2LQNUFZYldj3921eub/TmoHHUZ
         A6bk2VPecdN0EpLJ/YXQmd2ACXuee68LsdtTwa6rfbZz3Ov7WtWlWlvf8uF8lHMkXY+j
         OQblEpTxaR7gX7A22DVdB9BjSZmpC0tqDh2OKvI3Yi/Z4Qwr7qJkLHKvj7i070oDGbdj
         EWME+VBJlnytQRd/J9wlMzQkqwBqWUKs6w+p2X0TrcUj5ShDJn2icgj6aLA8DG14O0TF
         NJRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FDAFvGPq6M9RVg8MpP4qaKMb1OEi5PqKteG0o+lAPY8=;
        b=AzkC91VyXURAXxzCXHUHHYrrEpZAZRNXGiunQM8rQ/GM6nF1DnY/jyS+4X7a/KMCZ9
         IeBOBvCtcRic6QCgdi7TVZ5Y2ddsNiZgBicEc4M/LBi3OmhPkFK954egLDoF59y14i6M
         ouYVSfy29s9nnnAoVyAsN/vY80m8CDLbd+KxmZvdA6+Qc3Y3yDwCJXthJiO/l/TRpSLY
         hBM5dqOUKHiO8NF/z5GlNHW2zehdmjV0RopIoxoI7M2AkVs20IZexHGPd08BG1Yh5y/c
         b7ikkGqlQ7vnCNEeLiwOllM4Sr3alTT5NLHnBWLtPzyX23I7mkFMXoNc28HaoWXbeYfj
         c88Q==
X-Gm-Message-State: AOAM531eBbs9XGfwv/GCQ5HINTYfNjvtOrnzBxAeks1aOzPZRIyrsFmc
        XbmUtcZrTj24yQhlbB4QZE4=
X-Google-Smtp-Source: ABdhPJyBXPBds+pY9vPjPP1EWpfT/0m142c1RFp20ioGRL1PVc/ibFMWinEZX4UGdF51tL1fwhKncQ==
X-Received: by 2002:adf:9d48:: with SMTP id o8mr29720116wre.183.1619537687420;
        Tue, 27 Apr 2021 08:34:47 -0700 (PDT)
Received: from yaviniv.e18.physik.tu-muenchen.de (dhcp-138-246-3-172.dynamic.eduroam.mwn.de. [138.246.3.172])
        by smtp.gmail.com with ESMTPSA id l8sm268920wme.18.2021.04.27.08.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 08:34:46 -0700 (PDT)
Date:   Tue, 27 Apr 2021 17:34:39 +0200
From:   Andrei Rabusov <arabusov@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/36] 5.10.33-rc1 review
Message-ID: <YIgvD+TnjnpkCmlE@yaviniv.e18.physik.tu-muenchen.de>
References: <20210426072818.777662399@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 26, 2021 at 09:29:42AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.33 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.33-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I tested 5.10.33-rc1 on i686 and x86_64. Works fine for me.

        The short outlook of the test results:

 +------------+---------------+-----------+---------------+
 |            |               |           |   selftests   |
 |  arch/cfg  |    compile    |    boot   |  [ok/not ok]  |
 |------------+---------------+-----------+---------------+
 | i686 lmc*  |      yes      |    yes    |   [1433/82]   | 
 |------------+---------------+-----------+---------------+
 | x86_64 lmc |      yes      |    yes    |   [1573/74]   | 
 |------------+---------------+-----------+---------------+
 | x86_64+tun |      yes      |    yes    |   [1575/73]   | 
 +------------+---------------+-----------+---------------+

Tested-by: Andrei Rabusov <arabusov@gmail.com>
