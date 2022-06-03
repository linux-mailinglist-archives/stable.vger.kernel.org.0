Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4846653D3B7
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 00:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242508AbiFCW5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 18:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234816AbiFCW5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 18:57:09 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338D4FD26
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 15:57:04 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id r206so12218986oib.8
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 15:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xV4M2H0rzmou3qhfz68sQHKbNfHEagjbKOGZ0VFo8bs=;
        b=L+OmDC7FwYS006jvc9HDHowRNj5zeOHWE3rr4Nu5HPVro5DllJvjW9bt1PayKysQ3o
         s7DpQpItSjcfp4iHk2m8AekFpjqF6H3lUUY7badx1w0hptRLcgS7Cl93Y2FmdpHMBLZB
         llgmJATsXYeeCDGsLW6r2ge9c9AmzIvnwumuA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xV4M2H0rzmou3qhfz68sQHKbNfHEagjbKOGZ0VFo8bs=;
        b=CDSCvlyvDe1etWStnz+O9ZztUpOB9Z7wP2c/6CNLToykRogiUqcw+R8xaaHGwSk9ZS
         C0xCmuHLwqlh7WGiOjoaluCk+A7ujPOb/NcnbkxLKfI5MClAUIPiATuAxDJoHEaypi6y
         uaRm2CIOusATqUFEi4O4CSYEiTvjxq1n8FaYktbD2T3whA5iTNUWAxbGOq3CJFMyZs8n
         xwnGDRz+5OtykuCqo6EsWyGwrf+uyALlY1XLYWqPNpsZO/kyXOfwCj66UO5PVpq8ALeS
         9wP7hG8O/v5lbD1LKecYX2bslS9IZvfp09UUeIBhBaUSw0T2r95pKcEf5tAhM4zn700B
         uV3w==
X-Gm-Message-State: AOAM530yROV6YykLCeooP+CZtZi2Y/qzMN0u0xh/76l3+RrvyFjQdfIu
        fNpOZGMr6bhASLDybx+r5aToew==
X-Google-Smtp-Source: ABdhPJy0IEWN2jxFAn0hLFf86E7fhM8ujpC5YR3dEU3A4Tiy/PUSZSHvZ4UqcoUH0ta6gZZk7ANIuQ==
X-Received: by 2002:a05:6808:13ce:b0:328:da83:aba3 with SMTP id d14-20020a05680813ce00b00328da83aba3mr7179295oiw.265.1654297023490;
        Fri, 03 Jun 2022 15:57:03 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id f17-20020a056870549100b000fb2aa6eef2sm35215oan.32.2022.06.03.15.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 15:57:02 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Fri, 3 Jun 2022 17:57:00 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 00/75] 5.17.13-rc1 review
Message-ID: <YpqRvANDbYTPMnSp@fedora64.linuxtx.org>
References: <20220603173821.749019262@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 03, 2022 at 07:42:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.13 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
