Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E14559EBB
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 18:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiFXQjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 12:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiFXQjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 12:39:03 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A50450B2B
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 09:39:01 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-101e1a33fe3so4455442fac.11
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 09:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5z2nLOtXpA1PnyAJ24lCDoKulYwTsdoh4Z/bl5fMYbY=;
        b=CPfhThtYSJyF3rGdX/URiSXwu73amPJtylpyzw8wohwe6qKwYNO2P0N+ywz7i++XR4
         wM/yWj+SL+BD7Rdh8hoxjv6NWM58TUz5ETgaUge+Y/Mger69H0JyOf7fQc/2CVwmkVEI
         9Mjm6LZRS4x/Z3ZwWzN41VsKGlGwXIHnQPV7c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=5z2nLOtXpA1PnyAJ24lCDoKulYwTsdoh4Z/bl5fMYbY=;
        b=pyuY4mFMQcub25QvnN5iS5+ap/SQDK6YZKPXKaiI5n2hlWXIwWdkhrAziy7B6Q1UsP
         5/SIcYCho3kN5oAibZ6Z0N8PuslaDjiBEdYMKFs+bOfUvrYzJfapkJwQV4NKLcALf0DT
         TNQCoK6jN9SjWeQTxx1OoVdjkhr9DzOjAuI4L4xBPRzV6BY93NIfj4tcdsRqCRtW348x
         7yYfquUk7OULDJjdQeiRKSa6iwpmI8A8wwuQ85WuFe/zQYx5a73yQASvtRlUwKKlimpg
         a45QxYxZ3A726wD8Pi29YKRB8liVyFSlr/OTjCZKCs3eQkKOQWQz2PRpxvCwGuCgLwPI
         RerA==
X-Gm-Message-State: AJIora84Dmmxm2zbKCgMApiz3lMLhDQpMi6iEUuV9Z1+SekeYVNVKNVi
        tEan5fp5K+/rnynzU+6t/lmIUw==
X-Google-Smtp-Source: AGRyM1sG/WPM8a/Xos4uv/XnsHNlRp8vE+kDtGM7pQCZspLHf/tZVtoCFC10XBsQBOpYLiAhFTD6OQ==
X-Received: by 2002:a05:6870:538a:b0:101:a393:4c6b with SMTP id h10-20020a056870538a00b00101a3934c6bmr2578401oan.11.1656088740814;
        Fri, 24 Jun 2022 09:39:00 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id g15-20020a9d5f8f000000b00616aaefb6bfsm1107028oti.28.2022.06.24.09.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 09:39:00 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Fri, 24 Jun 2022 11:38:58 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/11] 5.18.7-rc1 review
Message-ID: <YrXoohPVoqGgABuE@fedora64.linuxtx.org>
References: <20220623164322.315085512@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623164322.315085512@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 06:45:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.7 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.7-rc1.gz
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
