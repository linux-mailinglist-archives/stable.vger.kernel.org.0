Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6E83D6871
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 23:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhGZU27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 16:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbhGZU27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 16:28:59 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB39C061760
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 14:09:25 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id c7-20020a9d27870000b02904d360fbc71bso11264104otb.10
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 14:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oST7NN+/p0LRcIhqUqdYn3VEegia1ZeufQUkm3W6JME=;
        b=gJee7bE8xcEX/DphCsiQqGXKmPt3eaaEFdyyBXJE/W3YzbPU+SI9GC2T/22oyzG6Du
         EhbdFftWwhRft9kU4c8MDTJKK1QQvHxKhEWlbmVfsavvYWntIrYS9DMi8tWuB3/XBf7E
         qw6LyjFLNAbXkCDjh5jlBQdm/jKOHDessLclg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oST7NN+/p0LRcIhqUqdYn3VEegia1ZeufQUkm3W6JME=;
        b=d06L7hIPw06PsGSS+HqwcXKpsfUNs83BdndeN1apEQ8e96NL1owaKcaQXMZdZKiLeS
         BMkWEfQoB4yZPbwOCG9Dxn3AUF0TgecLqqbPm1UczlqPBKIsyp2fYC35aoUXLeQ9NnUl
         ur3AsaBgTm7cGiJf8CLZxOroh5EEPF1vcGUtga9pfnyd4/V7I1jJhXTKygoJx0IbpOn6
         XVRKtZWnYC6LyHAIFfHr3b5g0I3VP29hxkh2DyAiarDDQ5mQ0dXknra7T1WtYp3Us7An
         eIhbvFr1cg/izsl9F5psHuplSC+3l2Zu2y9W0Cu4y7C6jcGGblwhFgmdL+9MZ99MEN/n
         0smg==
X-Gm-Message-State: AOAM533jdtsfOO8xrOTURqsuvlNYhEQw2CYfo+5nsypwIlsjjY/rycfP
        N4FPwermyOJEV/2ArKlTJ9VOzaGJXrdxzXiw
X-Google-Smtp-Source: ABdhPJzvwmpfdHXkdEPnfD16MsGZyHqO2xwJ+xXXtwpv1QUWF6NPOD2DkEOxui32X8f4Erx4NnrCTA==
X-Received: by 2002:a9d:4d03:: with SMTP id n3mr12919993otf.223.1627333765110;
        Mon, 26 Jul 2021 14:09:25 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id a7sm193445oti.47.2021.07.26.14.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 14:09:24 -0700 (PDT)
Date:   Mon, 26 Jul 2021 16:09:22 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/223] 5.13.6-rc1 review
Message-ID: <YP8kgm1IAb+l8lZz@fedora64.linuxtx.org>
References: <20210726153846.245305071@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 05:36:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.6 release.
> There are 223 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>

