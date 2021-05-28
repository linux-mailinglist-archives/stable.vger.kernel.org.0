Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BF139439C
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 15:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbhE1Nyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 09:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbhE1Nyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 09:54:54 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0B9C061574
        for <stable@vger.kernel.org>; Fri, 28 May 2021 06:53:19 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id i14-20020a9d624e0000b029033683c71999so3530967otk.5
        for <stable@vger.kernel.org>; Fri, 28 May 2021 06:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ratv6BUca1F7+J2AtSIDBJ81TFRTS5Nnw/PddyoDNuU=;
        b=JxVq6wCc8vfTqSyQD0W4f87uD71N4V6fNQnzCSHfrgpBN3RMYr7bTdrrJDJ/vULyEK
         icVIfCKUCxBPohN2EhSK7lIZlK1bAg1Y9cH+q9AFEgPAyuB73Pe7TUjR/wn1Flwd+PaR
         J5Mibv3QRVbeQRYyxYlksey8k9ZprJr4BoRzs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ratv6BUca1F7+J2AtSIDBJ81TFRTS5Nnw/PddyoDNuU=;
        b=b6imcPXXSoqAGzzinDRnwt5vZIDQcopn16IDCF7noaVWSJZs2Qc3uFauOzzRy0OkOz
         NlxgRGbkcVfAPCJoWE3/hQYGZt+3zFTN1al4/kAb7+97GyrwKeqPY8o1i6yAELr9UUyr
         /d6geH12hg0KRDcYkahFVbj8M4wj3yInmJ2O08LMEWHMxJKwnv/3+E6q1OpI8MLql/rV
         YyPoWe6HQUimwZmv2ns0MQOmXPYjicsHf6WLsMVdNIvf5nwjuOhNfvsbY4VOCJ2O9UPk
         dV/fIMy2/Izs/Y347cEZ/3NDxteHdgzbxCEq5Yd4cD4jDB1DEcczZMKDYOi5HjroJj64
         s4YQ==
X-Gm-Message-State: AOAM531bvMujQ2hvuN122on9u0MaNWk5YP85yihrxMtYKRShy32Hkrnq
        GNnWQ7HIvqHBbYvdRJBfxOsXiQ==
X-Google-Smtp-Source: ABdhPJzoSjo/06O9XqdUS+WhJSyHxsfhmpdiOliLDv9/z3eE3e2m0M4PWrxiEUG2UFFV/uvmARgxzQ==
X-Received: by 2002:a9d:3675:: with SMTP id w108mr7021666otb.58.1622209999050;
        Fri, 28 May 2021 06:53:19 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id d19sm1111983oop.26.2021.05.28.06.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 06:53:18 -0700 (PDT)
Date:   Fri, 28 May 2021 08:53:16 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 0/7] 5.12.8-rc1 review
Message-ID: <YLD1zKeoht2EsKZb@fedora64.linuxtx.org>
References: <20210527151139.241267495@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527151139.241267495@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 27, 2021 at 05:13:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.8 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.8-rc1.gz
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

