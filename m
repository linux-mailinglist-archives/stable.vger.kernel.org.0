Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490A662A01B
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 18:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiKORTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 12:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236873AbiKORTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 12:19:12 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6209A1580D
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 09:19:03 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-1322d768ba7so16982936fac.5
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 09:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rWVr3Bm3ZsOWguCOHMhSWPkWa2JP0/lqzzMZ6exDEOY=;
        b=TZ+1EZrzdouLdTqi7sb/sJwGi8pulf/fd61zf35O8Y7QO+893QhyUI3HPuCPUBTkLG
         atVdlt+YEJBGLb57maB9j12BPmLbj3o2yt9eayhi2XFexidWzXE3ZQDO6ncLEfVIK84k
         RW71x2N3p5K4PG9K7cgt/bSVGIOPPByBzbi30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rWVr3Bm3ZsOWguCOHMhSWPkWa2JP0/lqzzMZ6exDEOY=;
        b=Khy18ee+YDEaoT+9RxiQa5oGSq+5CC8PbYp9nMa91IeLg4rSPRn8xBu/RHM5LLpkAJ
         2dBk7Va0E9CJVYzfFJaA2SgBrOs6ph1r+MNJrg5DrmYrVDWyf0+75lz7487t1vYpOkLU
         EtiC/YhYGEClpbEvDLJ8BX6dA9xaHHM2cOZUIlBIEZxGM+BG9jxYPvZryaZ7FomrXa4Y
         VLY8nz0ne23INW6Mdc3QA31xziP5HEI8EE2sW57TfZsUTBri+9+gscA64LJ9+X+aScky
         ejHgJdrvd1mYIh+YxkdOlYIcP0PHvfyOzfkOYh1ufCltk/07ge1R28BVIUZ11DrzM/zi
         DBWA==
X-Gm-Message-State: ANoB5pkwcljNoOkuhM4g2XesDOcR7pflPeSOzmrNjVLODkAPsjp3QpNV
        KnSyqc1SY/EEBLX8nQNX5imQFQ==
X-Google-Smtp-Source: AA0mqf4v4jolSKH87QearLWdn3ivgxw+V0w2ABmvhy54GWkXvmlb6RMJfYb+UBwZScSygNsGEbmUzg==
X-Received: by 2002:a05:6870:4944:b0:13b:1584:4743 with SMTP id fl4-20020a056870494400b0013b15844743mr1598223oab.230.1668532742370;
        Tue, 15 Nov 2022 09:19:02 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id be20-20020a056808219400b003549db40f38sm5094887oib.46.2022.11.15.09.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 09:19:01 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Tue, 15 Nov 2022 11:19:00 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
Message-ID: <Y3PKBFFw6Qu1PlX7@fedora64.linuxtx.org>
References: <20221114124458.806324402@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 14, 2022 at 01:43:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.9-rc1.gz
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
