Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16EC46462F0
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 22:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiLGVFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 16:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLGVFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 16:05:17 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0DE716F3
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 13:05:14 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id v1so7967908ioe.4
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 13:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AdwiBta6Dmh/OYr9T4sarFHL36j6yKAVLPCIdX41e8E=;
        b=iyOxLy9XHzFy2XbMQGIodfZwE74F2VQH2uw6Bajf8jyz3A4AAae++mdUyn3jXnEZwE
         2R8olZssDCz82JVkilXJq20A90qXgGw/mu64hQYfp2GRa6GtFbqd0m0DtQU9Kmny7THl
         muz0haDH8RD0Irkt7Mtqm0sVN73tJLeVnWmpg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AdwiBta6Dmh/OYr9T4sarFHL36j6yKAVLPCIdX41e8E=;
        b=OinJV2o6OnDvwbqVjJsKr0Ina0jGzu2GZa81Wpcr7LksD6yppf8rlkSBgDHxHx/Hqc
         ZWYcf/AdDoB65Z+uF6tNaFZcBadpOe75al0l1ra6nj75Q+Mv7Jk9wnxZPIArj6xDnVZi
         VIlOO0SvPZQ+42jXITyo9SLZJxXgaNhX0INTE6mxn/QmdLkis1VApfQYbSRvXMDmYkge
         RGFHGpsCqWxM1e0/UjUzurx1dyT7u48rd5UJme0gXf+LQRXIvsZj2WYCqgTIb4ucsDut
         PG4ZgeNvs0Yb8JRmyRjVd4xlZoPjRzZhxMIhTIkKxRCCs1cPU/gzTpP11uYJAPqX+uS9
         VuTQ==
X-Gm-Message-State: ANoB5pml8Fi/yEUrB+Q0wW/bT1rm+Js7gvJp5hVdOWUUQoYshMjO6WV2
        DzLu00ncvJRBPkcLq4fuxpzKWg==
X-Google-Smtp-Source: AA0mqf7+fo5y7xXq0Es3jfEYzCY+qMiBTplapo9Q5usgMzeur5M/qhUHuIanSgxE53hS1CuCZ9d9nQ==
X-Received: by 2002:a02:954d:0:b0:375:569e:fb3f with SMTP id y71-20020a02954d000000b00375569efb3fmr43537632jah.200.1670447113419;
        Wed, 07 Dec 2022 13:05:13 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id q28-20020a027b1c000000b00349c45fd3a8sm7971766jac.29.2022.12.07.13.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 13:05:12 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 7 Dec 2022 15:05:10 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/125] 6.0.12-rc3 review
Message-ID: <Y5EABpt77+wwnGLU@fedora64.linuxtx.org>
References: <20221206163445.868107856@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206163445.868107856@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 05:39:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 16:34:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.12-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc3 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
