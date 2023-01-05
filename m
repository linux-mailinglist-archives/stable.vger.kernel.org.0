Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E66F65EF10
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 15:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbjAEOo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 09:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233930AbjAEOoi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 09:44:38 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5555017C
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 06:44:37 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1433ef3b61fso43099304fac.10
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 06:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=caqkfLJYxEQD3n7JinVpvb0wb3kUB4I2X5RnurYG5uw=;
        b=NNxupWvBG+JgHxJyEF7pjw3m9rgtzzWP2GABvqweFuP+l4pUXiomlAyYmkOKD011kl
         Jj2T9MZF7dzB/lAb0Ab8JVXqwY07HCGi1Qw0k3oRcY9INSZtoZmODVhMi4BS8B5xN5sk
         FAmSBgQrotoFJZzFRQTY8IdX2+zrLQKzHZd90=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=caqkfLJYxEQD3n7JinVpvb0wb3kUB4I2X5RnurYG5uw=;
        b=UgWngWpfnaIrfgtDT4UjodNGLrkW8lSZnPUAHgjJiwq1NFp213xJ70nTzWtv1pYRdh
         o0VX0Ff5krLPszL8uwTOlWxIuzlt4CC01pubddqOA7ibQeA4/CC5LRdr+L71YmwbJD6M
         jrI1eHfaJAjW5qnCTh6m76buWttf0JUaNV+0nzTrY2o1nIbIHRa4CTdMsSs7dqLKiImk
         fZqju2vdfkP1p0CvXLszFrpLckR41YbZYCERmdZFmVgSCDkcWmbLgWCw8bprlH0m8imJ
         inZs5v1Gv4YuicD8+yiUHNfIK47299CI7eeyONJc8B4vETTBUXAdSEZDkwtVshC79ZGd
         YKfg==
X-Gm-Message-State: AFqh2kpQ7apsy8NzJofi7Ig5FtalYXva3cVqqfFOK7NTEU7uqEYyTerJ
        nFyuMAOgBQDDyhV39remHcffrg==
X-Google-Smtp-Source: AMrXdXv8HPBhbJtxCXaO7Df7rsRQdxEn97YzKYKeFtWDbSiyIIbJouVucNhWdbdV20QoqZT9bpTOSA==
X-Received: by 2002:a05:6870:9a14:b0:144:7a85:63ce with SMTP id fo20-20020a0568709a1400b001447a8563cemr29773594oab.54.1672929877087;
        Thu, 05 Jan 2023 06:44:37 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id ej18-20020a056870f71200b0014f9cc82421sm16101474oab.33.2023.01.05.06.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 06:44:36 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Thu, 5 Jan 2023 08:44:35 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/177] 6.0.18-rc1 review
Message-ID: <Y7biU9SSrfgV6iHF@fedora64.linuxtx.org>
References: <20230104160507.635888536@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 05:04:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.18 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.18-rc1.gz
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
