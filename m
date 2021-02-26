Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07A5325C12
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 04:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhBZDml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 22:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhBZDmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 22:42:40 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CF6C061574;
        Thu, 25 Feb 2021 19:41:59 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id 81so4643467iou.11;
        Thu, 25 Feb 2021 19:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mCQzJ4BnfzJvygC6L4CSFnzv06dXPWCKi/Y4pNAQN4g=;
        b=Nov0WF+2nSzbO+VpZ/M57qO8UuDNCpAgGoYA/duFDdN17H+tGpzzuagnQOduM1p9m1
         K7Keo9RwpKM3dYjj70OT7HwCWSuQnQ7BMAt3CXWQKXhoLYLIxYw9RkfGkeScUKXBMRPG
         ma/yr0ME8JGpfDcTjBBcqG8gREEC6pfVlgm9wpNy29cGLJyZyNsmT3KUQZ5b9H+c7LLy
         K36gAXPXoW+RV6a42Ed6KGo3mo/PwvqXfpb39TT31Gzu50vxOOV3ci2btVfQ9oZ5zE9n
         cNGmg5vIW6EUo9so55zHnMRPMm+rRkVRn+KhWGwLv1m0OXpIghSWqKNhPiZeL/9nciOj
         N7VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mCQzJ4BnfzJvygC6L4CSFnzv06dXPWCKi/Y4pNAQN4g=;
        b=b05Rr+SrYm2vfpUYH+nTGKpzsGclH6lyQIQEFp7xRu383Rt6Kqx7Nfotm0l1gv3NYC
         90d4ydyU1vpLwl7/xyYicl+3O8Iw6ETVeZbmpliz5gH50rwU+ZKOx8pGMK3h5bi0a6+n
         27vOlaLsU6i4iJM0fPdEGyZCgVFOAfHlv9KdXmgiKvko1TnWSU+tfGne/YbFjQqbUZI9
         clDTL1y9ic99yEqGlxesoMZ3zIE3s49F5kW92iIsz+ufvnaVQfPKchYCaXM0o9y/UQHL
         lmxwBMg39g/JxugOCSt6lCnC+ojhPGzSjaSgwooNangu8TUhMIAUol3uxFs5x7qYqxaz
         1cNg==
X-Gm-Message-State: AOAM533N9R7rurc2BL2L8Sa7N0SKrxGuXitwrCZXRqMhi+qp2PeKcgAe
        sGLX1ZsryqSxPqnwDpIQZ70=
X-Google-Smtp-Source: ABdhPJzZAizMwX8dj1vRvChevzIebEuCm5zIbuixNyAo4EJpM5C82p1nDsKmJmQJutKJmwdbXXaDQA==
X-Received: by 2002:a5e:870d:: with SMTP id y13mr1141178ioj.60.1614310919526;
        Thu, 25 Feb 2021 19:41:59 -0800 (PST)
Received: from book ([2601:445:8200:6c90::4121])
        by smtp.gmail.com with ESMTPSA id w16sm3959452ilh.35.2021.02.25.19.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 19:41:59 -0800 (PST)
Date:   Thu, 25 Feb 2021 21:41:57 -0600
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/23] 5.10.19-rc1 review
Message-ID: <20210226034157.GB5461@book>
References: <20210225092516.531932232@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 10:53:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.19 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
