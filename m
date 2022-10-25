Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435AD60D753
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbiJYWn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJYWn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:43:58 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A029EA697
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:43:57 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id y67so16380315oiy.1
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YgIZ1MCTZBEibSbMHUkytkQD0P8jtnB55ZvjcWs03Y0=;
        b=Ug2NqqojYFHitvHk6uAKAT3Ndk5ffagye/IgLQk/qMn7aOmF02GbeVMzrEmnfwt9mL
         RSS/WyhRNA0YojgdYLu95cGeMvGbHr+L5QFHLtF2y97nCcpaOdV4SRbnXIb+EqUenzNu
         YeOt1t8eQOK4OM6mSdMkjrV5G9VSSJwXHGfjU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YgIZ1MCTZBEibSbMHUkytkQD0P8jtnB55ZvjcWs03Y0=;
        b=l+unJq6AKSTI+O8Qeybx6wt5EsBVPHiLpE09BmWQIbw7oN9kbZKw3PbLobTbjcmLVJ
         ODODNaXBHr2/ztHm3lD2di1vRhxpAqVa663hpBYaqc4R0EnwlHnM+u33JMlWY8uNCr/z
         q1UxHoJrjWC1PNAoZuz8Byap03z7e4xwPmnt5gzCQoQYodnP76gXJi8r67QscYphxlSZ
         pBGZmhoITXULWmRbyBZRtAdH3jRxXdjRXUYnhobhPte4TwHORjsS8w5EsHF0fgwXPXwi
         pLz8MNJlyIdYVK/0d19gDYRV4xn9t5DNQpqV2lg7H3/rkJvH+lnPd2luzio9sO7fNw7p
         5T/g==
X-Gm-Message-State: ACrzQf1tsvV6nyxFDDpXBnpgNXTinp9+1M0U0GiJTakrN6Gq8fo9mYUT
        bHqNxbzXEzd5nPoCTm18phGgpcTdHs+rZV3D
X-Google-Smtp-Source: AMsMyM6l58SiPiliWPOD6a7CUxrcFG8qNCwVjdjo/6C8iTfaMhKNjpAYehQKVuhQCoLgmhGvmq9gLQ==
X-Received: by 2002:aca:aa94:0:b0:359:aa62:295f with SMTP id t142-20020acaaa94000000b00359aa62295fmr330198oie.230.1666737836498;
        Tue, 25 Oct 2022 15:43:56 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id r40-20020a05683044a800b0066194e0e1casm1523460otv.75.2022.10.25.15.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:43:56 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Tue, 25 Oct 2022 17:43:54 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/20] 6.0.4-rc1 review
Message-ID: <Y1hmqspgeYLPy5Fv@fedora64.linuxtx.org>
References: <20221024112934.415391158@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 24, 2022 at 01:31:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.4 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.4-rc1.gz
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
