Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB476D553F
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 01:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbjDCXnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 19:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbjDCXnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 19:43:22 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194EF2D4D
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 16:43:20 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id bl22so9065172oib.11
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 16:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1680565399;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j+kZVt7LtKE+lA5uejWYYqCOFw5NZiSEn6sJt5bKfW4=;
        b=TUawIrXcpmq/iw5q9PtohrAmgkDgEZBYtVVR96KdKQQNNkBJYHYHmdicMv7agXuQeF
         UrB5riSK32nY/uCtqoztRRSJhqkVZgHpwVmcT7/6ft1XweGjgOMfJtJ3bqlvwZ4Bhcgo
         nyvIEs3mMy4Gd4FyrpYwagE6AAk7GARodPbEo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680565399;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j+kZVt7LtKE+lA5uejWYYqCOFw5NZiSEn6sJt5bKfW4=;
        b=nD68s7KHo5KTveuKTegK7DSXyHhFIwXPmCruJSR/IBNsFqUpOjc23bG0/ucU5nnq41
         /PGIztOCjHjwTMDvTDTTEDyP3VS/+Z/b3nIUFSuKVfxeb1ISk0vCCXI/51+Q7fEZ3BlW
         4obWXaJIuzu6bwCcdzLzikPH74Gtv5+mez+6gE05i46Pez44AnmFKiF1zHGAjGdZ4n7V
         i3FpZrWTIbgsFcKzjjf0ewMuA2A18FPgpbPUgHfMI3cFLkpD5Yv9dOKcAlbnNiPfqTi7
         15wAu94bOlZvoEN26SRuLb97Sl23UY/2g7QCT/OZ8BAXeOY6OxRT+YCxPqD8UevC2LLJ
         qcPw==
X-Gm-Message-State: AAQBX9do9JigmY++P80otEoFRbZCZaQup6FLnBf+MAurm23wwO2LeSj2
        CGKA8Q99kn4glGFOkDZJs+J6jw==
X-Google-Smtp-Source: AKy350a5pL6MDx68qE1GhzBon575/IUkWBkCH8YZMmi7kAVkxJvXGksTgIBibZWQCKoe5kDiwSMiyA==
X-Received: by 2002:a05:6808:2104:b0:389:340e:be43 with SMTP id r4-20020a056808210400b00389340ebe43mr638647oiw.48.1680565399370;
        Mon, 03 Apr 2023 16:43:19 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id w10-20020a4aaf0a000000b0053479edbc17sm4609530oon.33.2023.04.03.16.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 16:43:18 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Mon, 3 Apr 2023 18:43:17 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/187] 6.2.10-rc1 review
Message-ID: <ZCtklaEG7OmJgFNi@fedora64.linuxtx.org>
References: <20230403140416.015323160@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 04:07:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
