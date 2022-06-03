Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC6B53D3BE
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 01:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345245AbiFCXAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 19:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242087AbiFCXAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 19:00:40 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9291357119
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 16:00:39 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-f2e0a41009so12462085fac.6
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 16:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kBvfi1BxQjAKFqWT0+hwPhstcKDSCnM0PpUhSzvHoLA=;
        b=FjjniqyNCK+sFvyKNnSTDInkvEHv9NGw3G0mNg64FWZSGAKZw5u15DQ/htoYdIwqh/
         HPbDXR25iZZXfykZqVakUVqH9WAu8aBg2uDaf0xnHoxM/4iOwNIJgQSxeKzVqnmjBVek
         R6w7ujMX9+J5MpuDyNnwW6UkfdIZ8AJyqCKKk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=kBvfi1BxQjAKFqWT0+hwPhstcKDSCnM0PpUhSzvHoLA=;
        b=eLXXm2yKj3jltovc7OPf4FY+UCW20wvQFjpXhtmDboWJSosINKzLHwpB5HBpgnNqLb
         /xDApkj+VnOZO0yDIVAQ/fr+Eq0I2YdZHL8A8jsxrpSvdIm2+jGmUQyWwAPe/Ywfi9sY
         l4h2ObWzVpTQxee9KQeb1rZY9dLYBvbiME0ZLGtlZa7r413+TChUiYkxWoBuhRYc3r2T
         SESuWGJVjX8CXL+w/FQwGPyCvCun9lbmo7fqzWtGunVeLBqh/sq43XRPp+GpOu1wBO2n
         N2ur09XdAcX9EF7eiX11OOftnq2IsogEwCQK3tPebJLbMoDynOfyTHwd4YPYMocylrd0
         yGtg==
X-Gm-Message-State: AOAM530hbNb+9TyZEyus8qkXPESPgg9pGYB7Sr96CEX0E9hyUF70WSDr
        vrDdLNHFIelYh3mMf0LCusaiiw==
X-Google-Smtp-Source: ABdhPJwl3cGIGn2LcpZBAlX90trk1q7fB7R1to92m7vxyDEULHqWfn7EDOsXjLS4QIP/wcW2jhvX2A==
X-Received: by 2002:a05:6870:ea8b:b0:f1:f46f:515e with SMTP id s11-20020a056870ea8b00b000f1f46f515emr7183182oap.192.1654297238441;
        Fri, 03 Jun 2022 16:00:38 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id bq9-20020a05680823c900b003263cf0f282sm5262376oib.26.2022.06.03.16.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 16:00:37 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Fri, 3 Jun 2022 18:00:36 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/67] 5.18.2-rc1 review
Message-ID: <YpqSlD0IHwKSo1Nq@fedora64.linuxtx.org>
References: <20220603173820.731531504@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 03, 2022 at 07:43:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.2 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
