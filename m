Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614863D396D
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 13:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhGWKpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 06:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbhGWKpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 06:45:41 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5172C061575;
        Fri, 23 Jul 2021 04:26:14 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m38-20020a05600c3b26b02902161fccabf1so3301004wms.2;
        Fri, 23 Jul 2021 04:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xwHUId3Owuh/R7H+8Rhy8RonM2a/Vt6Q48piROjEFzs=;
        b=mhPSNxLS5zs/OwRLtsk0ZnQ9AEh8bjKhSy6MIZS/qlNqOye3zVfWWSc45eK1ZoAcCV
         KSgabzUGMd0rYWj/jeYFSC9u8gpLJDQOuUE3ZiWLVgcGFNWqSp8Jmt3QrDeRcld8fX84
         wjV+X+ns5PBddyEFRMlB1EaQ/AfUctcIXIGqLz05jyXCvWTdecAg8zceAMVxPE1LdP1C
         2YDh30lxh9cMGSxg1IDmoiX3tAKYu/+H9H03JnAo8N1OGiy6HEsIN8mzRxByjT416XGF
         1TPpbUSHcjQ9Y/3DwjccGTMk0cGKm6jEe+ptRM3K/PE/y9mAmNgsqQTioE4NwrBSmHJo
         M4dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xwHUId3Owuh/R7H+8Rhy8RonM2a/Vt6Q48piROjEFzs=;
        b=p6iUtwq1OLjGBQcLlev6Z+4mOx8USjjrWpo7ZAJm02SbFTaXpe+//437MFcbsduBYn
         1T2UhygtCJb/IFn/QrIktgUYW2NKHLZ+DiE59wgeN2oYKlCjihzCdwxofdrcNZznYtP/
         gMpYwbC9uinT8SCPkL52F/mAvp2ijDL+4R1UPStHx1ab8tfRLr9SApJ5xieih+xM9CT0
         RgsxrVN9aLnkTmpsEeGS/9mLzJXpS3CZq4mCVXYn1djYIRpzitCp6jtcqau3vSuumhzz
         2dEon5TNihE/ii4ACnmIomT8Zq2O/Pddcgb0sz+zSwJ+2tcv1vqTXu28FU9YMiw7HFXd
         sDWw==
X-Gm-Message-State: AOAM532EDuy8+8WZkpdTOLasI5decRwKTtQuu8jzINGovO0qMm7RAn2L
        Vo6tgqNjuWPBYkNmxJpZqCw=
X-Google-Smtp-Source: ABdhPJxIy9AuEheYKCGgPyeKVBkUixd2Ks9D0b53PYiPtkW4DWT8Q6JUMQhrSUvZhjGrrh+OoxYZbg==
X-Received: by 2002:a1c:acca:: with SMTP id v193mr658665wme.107.1627039573231;
        Fri, 23 Jul 2021 04:26:13 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id b15sm38331857wrr.27.2021.07.23.04.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 04:26:12 -0700 (PDT)
Date:   Fri, 23 Jul 2021 12:26:11 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/123] 5.10.53-rc2 review
Message-ID: <YPqnU17OOfPhJ73j@debian>
References: <20210722184939.163840701@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722184939.163840701@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Jul 22, 2021 at 08:50:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.53 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 24 Jul 2021 18:49:19 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210702): 63 configs -> no failure
arm (gcc version 11.1.1 20210702): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210702): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm64: Booted on rpi4b (4GB model). No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
