Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1266A1282
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 23:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjBWWCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 17:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBWWCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 17:02:53 -0500
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBD740D2
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 14:02:50 -0800 (PST)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1720887dfcdso17302131fac.6
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 14:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zvydFY35LBk7rNt/h/MORLJxZ1FtIClaMPSTPLJ7SNg=;
        b=KUIF198p+AdXAtvQeCvgTKWPFoCDz6ym9UfJ08/eDhIdUXH1weWTAel5gYLAJGVzB4
         YxJGbtz+2mOSKs1BNs9viRlAO28jj+9km++q9doTo7ECpTvViBjDwQM4CDN2PPGhOL48
         IgXa22NAI+kXDrCjnzmPfMeDTxDbYakFePYnQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zvydFY35LBk7rNt/h/MORLJxZ1FtIClaMPSTPLJ7SNg=;
        b=SjXvZZVWqtz/BMBn/EoAeHyEbnVP/efS4b8WWH0dx1f5kr07VBI9rT4rjmaqvnSM1E
         jkuSEV0YHzfW6Z2xV6h3FTa5XKEKmDCmQlNJc/TAkZyIfXXSH+39NaKy4qeMp5ht0t+R
         O6xuH4chxzGWBjx3xlnmvWHqjNxzVJNVS7mCdpMukA+Fs04J7TmKvHyc3ourribxpLZ6
         4PfvzmPsDkgyAMuSWNCqisASTXoy6ueFbmQaiQPlezfvzcjrvoQs0Vh7ZQzYlo4XfnXA
         P8uJhR62Qr18a0ZaDwzH5GGBWiHxJhItP+dZ4qWlO94FMsIw9rbtxGE2OJDPjGE0u11S
         0yHw==
X-Gm-Message-State: AO0yUKXglFzHXG+UfANGhLbQuqaa9xEukU7ix1nPE04/VFxuNDuWZTfC
        UXFCIUtHda+ULemFZ7LPxxXqxg==
X-Google-Smtp-Source: AK7set/772vBfteGrWHqqXY5znI9DFjNRUvpnHi3krCHidb/B5GX2FvQtSkW1ApRhVNF64BPpRj2AA==
X-Received: by 2002:a05:6871:b25:b0:16d:dd7a:d13d with SMTP id fq37-20020a0568710b2500b0016ddd7ad13dmr12604155oab.3.1677189770061;
        Thu, 23 Feb 2023 14:02:50 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id r1-20020a4ae501000000b00524fe20aee5sm2924839oot.34.2023.02.23.14.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 14:02:49 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Thu, 23 Feb 2023 16:02:47 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
Message-ID: <Y/fihxWNdr4ejNwe@fedora64.linuxtx.org>
References: <20230223141539.893173089@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 03:16:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.1-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
