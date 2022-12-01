Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA4863F5A0
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 17:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiLAQsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 11:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiLAQsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 11:48:10 -0500
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC2DB274A
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 08:48:07 -0800 (PST)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-14263779059so2810977fac.1
        for <stable@vger.kernel.org>; Thu, 01 Dec 2022 08:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0KbdoDEh91rw5IA0oIsvOgRB+4YOafY3auigAzlBBag=;
        b=EPKhZXBMmm+34M/64/xV6xZhG1xerm6CGLwtaXkeLtWtvyX4Sy34w1/6qhuA/VHkWP
         erNVVD7FNH5nVwQWwgAaZo/yWktEnLq4byDjsHYTLXKEeqYRBPqZwEpbEQayuA0QaW9T
         71tpa5Wvugjjjx9WGptYLDh48ffcFalHTyoDQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0KbdoDEh91rw5IA0oIsvOgRB+4YOafY3auigAzlBBag=;
        b=QdMK1SiAk7MOntOnv4w3fVcbiOAxhg0AFRMi/TlQ7HxTQ2yBj3RdC42zKimN85c15q
         UzmbnSFsv+4al44eOEy0y8kiwyCxzm1Uk5pbp3vN2Pdnr/QUQjl0wQcYO3vKsA47bUKr
         F8Z9gOxdvmE8HFo8yG/2/zASkAex8iWXrjcSVeLKaxFxPSjztZD8AnOUyNhiDhEs4BhA
         CnXbCR+/rEi5gSQ3VaHllHIRVwwdYFtGCiTgkAe5Bk5sE7T8mivh8cXxzybsUvB1D99F
         rGs112sp4ZA8nfgENDiWI8bRtjO6Dz6veur0HTFJwErqkEbwM+0J+7++Lets91zhCY1+
         6S4g==
X-Gm-Message-State: ANoB5pnMNKTalHkKrt3dQV1PoNeTMNd9bH4bdMfCk3Xrz/7WS6pNv357
        +JWqkJP6NlzK+9fJmTZ+xoevig==
X-Google-Smtp-Source: AA0mqf4/fo9us4v8SKKvRbiImh/8ffy6lzShfRTPXNemoNig9f5abIkulCSItNfCwIzXRSrqETSytg==
X-Received: by 2002:a05:6870:41c2:b0:13c:12cf:174a with SMTP id z2-20020a05687041c200b0013c12cf174amr27094701oac.197.1669913286025;
        Thu, 01 Dec 2022 08:48:06 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id h9-20020a4a9409000000b0049f9731ae1esm1923473ooi.41.2022.12.01.08.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:48:05 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Thu, 1 Dec 2022 10:48:04 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/289] 6.0.11-rc1 review
Message-ID: <Y4jaxBOj1p6Dw+xX@fedora64.linuxtx.org>
References: <20221130180544.105550592@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 30, 2022 at 07:19:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
