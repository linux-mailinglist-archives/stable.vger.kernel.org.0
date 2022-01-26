Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8963449C141
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 03:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbiAZCZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 21:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236310AbiAZCZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 21:25:29 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF517C061749
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 18:25:28 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id w133so8040045oie.7
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 18:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4MNxPjIBj2vsU8NN0yvlsN3XepTPMoCqynbtc/TK8wo=;
        b=DAE/etF3znTFSUXzBN/ldKhbyqYhldmUTvcZEAXJZbABmcvdEOEIyfFwSku5jKd2bp
         jdp43SxnP3k1RUR2y+7g6V6Za5TFkV6oEX6HgW0n7f6Gb7EqJMlyNQXcHhdzX19cBJhf
         zFCzGpgz2NUxsV7s8F5Nrc3i2yDXgXBABVrVE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4MNxPjIBj2vsU8NN0yvlsN3XepTPMoCqynbtc/TK8wo=;
        b=jsFsZlXEKWWc82sIcv88hDV8mcD29WfXZW3quxEYsdNrHzwq12g8kNXpweUSWUQFp9
         IuE3GSSRjM2L4Ae3gsx3YYqdr4PMvPOeYGqdunR1KSkdjArwc9vS/oBokeg7cY73uu5S
         BKAOQbLhkVfOTVlSaMDu6Efvo3pit95XAZWjku/91sM8o1S6O6yNaCYUZuIMEPEFbkvQ
         sXqBWaLSw6T4RCgaHR0XRg/NmOWXgmcFr5OU6NQPLsfE/dX2xC/OuWTWKkxtiqgF+8O0
         x5vt1tAHDg3DUPU1HxO52LzUTrOURvzv05Cyqvb7/YOuCKPOsL6PGDm3DO7CFFEJM+WD
         Ojtw==
X-Gm-Message-State: AOAM533Amd0bosme0+MbqcMyawi1St+C9eTeTO/SUrMrLNWFlMkFVVfu
        QUJ6cSuPyOa04sGDv5kJgyVptg==
X-Google-Smtp-Source: ABdhPJxsNVsuhsMqSbYzbdGGhv6nOX1vcyEyH0rkET4bUISHTHLSaaZOd5/k/DKvWyiKPDCq2gjB5g==
X-Received: by 2002:a05:6808:3025:: with SMTP id ay37mr2368587oib.19.1643163928118;
        Tue, 25 Jan 2022 18:25:28 -0800 (PST)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id e5sm5988629oti.59.2022.01.25.18.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 18:25:27 -0800 (PST)
Date:   Tue, 25 Jan 2022 20:25:25 -0600
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/841] 5.15.17-rc2 review
Message-ID: <YfCxFbKNko/gj/Js@fedora64.linuxtx.org>
References: <20220125155423.959812122@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125155423.959812122@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 05:32:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.17 release.
> There are 841 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.17-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc2 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>

