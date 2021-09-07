Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D6C403160
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 01:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347401AbhIGXHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 19:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240690AbhIGXHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 19:07:15 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7CCC061757
        for <stable@vger.kernel.org>; Tue,  7 Sep 2021 16:06:09 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id c42-20020a05683034aa00b0051f4b99c40cso482560otu.0
        for <stable@vger.kernel.org>; Tue, 07 Sep 2021 16:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ssdy/49Y1SfO8KzYgEh8loJoMAipYlwTluSbNq4/9Mw=;
        b=Ch5GvAZLEnqKFOVujGnZnFcH/9qKiEB/1B2j7J27fH6R7fpS8X3NaQL2EcuxeHH3Mg
         CaTghjHIZ0aWaZUhz11vg7yfJW6dNbjSOPpmmvkxwHbk0FZgya+6EVFj0Jfb0Rrke9a+
         32EGy1jinID+/nz85YH4LmVC+V2FrplNbqSHc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ssdy/49Y1SfO8KzYgEh8loJoMAipYlwTluSbNq4/9Mw=;
        b=mENSwCDb5ViQBpxiv8dasl8+4F5wdApBglI+kWLPzwiD6YiWqqN2KMX1TckPOZje6d
         b/kDuLo1LrsN/Ws7fbitl4k2uEG1maPgRdk/EWPONQDZ+x80L3bE4UHwUCZSNm9i9Uo4
         STHu2Df9y22vzo8D4XZ16EFBdMhVYa5+1GWoQUHxhR9z8C7/ROAj7EHhQUuuZr6PeO1e
         3/yGISHh7u+SYsy5e+0d88aE8eLwD/XFGcjH/e5XYqbndyLaFXUV+uraXe6kzf72h2rB
         3LVX1p7Kv1cbrhb5q19BzPXiiQfLudLCOtOm+gVJGGn9FYfCa85pU1oafCUE6UjZK0Hm
         Lhkg==
X-Gm-Message-State: AOAM532Eguk4j/lY9Rgfz84kPIvOVEQ1MGJOzCUEI+X7kC922GsLTSUD
        Ej09cL6ZTOR1Uli1TCRl/NFnAg==
X-Google-Smtp-Source: ABdhPJzeOKRgzSKpfuV5HY2xzJg/+whtqTqin1haumICgX//KgJeXo9laF4OKYeon4fJDuC4bsEfWA==
X-Received: by 2002:a9d:6192:: with SMTP id g18mr661707otk.314.1631055968387;
        Tue, 07 Sep 2021 16:06:08 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id x1sm74198otu.8.2021.09.07.16.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 16:06:07 -0700 (PDT)
Date:   Tue, 7 Sep 2021 18:06:05 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 00/14] 5.14.2-rc1 review
Message-ID: <YTfwXTtNs6yDeJny@fedora64.linuxtx.org>
References: <20210906125448.160263393@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906125448.160263393@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 06, 2021 at 02:55:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.2 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>

