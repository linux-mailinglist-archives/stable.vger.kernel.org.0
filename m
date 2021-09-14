Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BCE40B403
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 17:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbhINQBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 12:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbhINQBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 12:01:04 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8383C061762
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 08:59:46 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id q11-20020a9d4b0b000000b0051acbdb2869so19167532otf.2
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 08:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pGeychnoyMh4HO0GbmkPBBtAoTgG9ifrVTCPqKN6BjA=;
        b=BaC+FBznu3MFmgRpfyjmYAIABmF6sihvFnBqKyZtCDkGt8NV7xQyGRy63kuqnzrt4W
         iGzpH8nb40JkbfQILUY5QMV1axU4mABiOLpnbMaKioLTiVfZrS9hCuoJ89ogoiBH+O38
         pGBMPfKXPwbtnQtV46vnQdW5U9AKpMuHXFwg4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pGeychnoyMh4HO0GbmkPBBtAoTgG9ifrVTCPqKN6BjA=;
        b=eNmbrEx1d1tXub20mxWfzy3c2+Q1jOdUYgeNUkvwyMEA2LghukzFNW64PLrxXvdo9E
         OZR7f9FgsYonAuR4K49jci1MRYPbjRAYYJlrerAwKMwWqV+lqUtI/VbuR6zOVD1hX/ng
         jwzXQMJXhQOqyoh9O1hL3qq7hFTxTb+zaEhTOoHbmvlhGshUE9A6SbBmaWX7HzYC6nwW
         l+oJzxSNyep51VR8VHHJ8y3HFxvA8OizgUoz4ukH76jTKs7o/J4WAkRFtVxHZGI3B6a/
         4rrdITEs2Cv//LEff2TFOFNY/8HD59RYS/Fsgor4hABnQ4Yo6lhV2VX47M/O98UXn5lI
         rRgQ==
X-Gm-Message-State: AOAM530fZXLuKGunhXOwwTwuIbMciDVuNWtA7dZa51+zqh5mHEJyWs50
        Jy2k2uMULudXzf5pIGP1B58hbw==
X-Google-Smtp-Source: ABdhPJz1FnirNa1wDWKbTHUXRMcYFqXQ/f8cLRBU5XzF6x3sZkft/9b/o/DnwonQ2rZG1/0vyTWbaw==
X-Received: by 2002:a05:6830:244e:: with SMTP id x14mr15449693otr.283.1631635185987;
        Tue, 14 Sep 2021 08:59:45 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id 21sm2710936ooy.5.2021.09.14.08.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 08:59:45 -0700 (PDT)
Date:   Tue, 14 Sep 2021 10:59:43 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/300] 5.13.17-rc1 review
Message-ID: <YUDG79pIpXNBFVOt@fedora64.linuxtx.org>
References: <20210913131109.253835823@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 03:11:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.17 release.
> There are 300 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>

