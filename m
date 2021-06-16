Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75373AA68A
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 00:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbhFPWUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 18:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbhFPWUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 18:20:35 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BF9C06175F
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 15:18:28 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id z14-20020a4a984e0000b029024a8c622149so1080337ooi.10
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 15:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tflQamYotEMMY4iyVpYnVixyOMyvyVjPnxacDH10P44=;
        b=TkgGrXS3is93kbsdDGEq1rdddVweZIk2GFi0kzkIqrmNGT8TGE3iMTgCnZUXCgNA2k
         SpSE1gOtOTZEh2NtB4ZolEyjSFZ7qSDL7XZ5sVGomU1HCQk+oFjcKalBxV6bv8BKz9rP
         U9xn4M8A/NWzWzn5zJgdXw6carq1kxdR+vhwM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tflQamYotEMMY4iyVpYnVixyOMyvyVjPnxacDH10P44=;
        b=NWCyyYJYA0amOsiN4rKtJe3md0FKS2BpTq5cQqFePZYyoFns+tAB+TZHhi/QDHbrtV
         xtthxizj+/TMNy+PufBwBbVilem1gUx1FWykuPiw5Lo/A/RNxgpVF5DBmBnfFyTXqR2j
         Ej2NmxXXcZT/RTs66fA4h9zPsMXmhtPtoi68KNFy0AQcrdTcWtg3QPpVy/Gvf3xLX24W
         z5bv/w9D0yCPyIjzjZwd5wMySHM+4FSETJ9HRmPe3uTfhuuoP2k9YMHLPvLgxXVGmiV6
         1Y+HBobKEq2vydxOVkmgS1JNjjakMg3JLoGWBYKuEmfwYnqNTndlXwZWubrcSvTVLBbo
         iNVA==
X-Gm-Message-State: AOAM532ggwwQ4+tNBs9qtPmaWVjSYSqcQGxgn94WKWl9eubd2Z2R+M40
        z0TRuWQBCHunRRlLUJg6JYHAyA==
X-Google-Smtp-Source: ABdhPJxyxw2TQ+fTBSNsIXpKOWzzM3SBBJJwgolQz9B0ChaT4gL2wen7bUQ4mAGwO/PWV7ASDEH+Ng==
X-Received: by 2002:a4a:e6c7:: with SMTP id v7mr1830336oot.86.1623881906711;
        Wed, 16 Jun 2021 15:18:26 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id p7sm850944otq.9.2021.06.16.15.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 15:18:26 -0700 (PDT)
Date:   Wed, 16 Jun 2021 17:18:24 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 00/48] 5.12.12-rc1 review
Message-ID: <YMp4sEJHQfcXiY2t@fedora64.linuxtx.org>
References: <20210616152836.655643420@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 05:33:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.12 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
