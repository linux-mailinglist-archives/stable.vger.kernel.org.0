Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A84F567529
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 19:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiGERGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 13:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiGERGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 13:06:48 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9C3192A8
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 10:06:45 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-10c0052da61so7142376fac.12
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 10:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WPIMENGp4bXPFbinmL/gsx/9qor/mNBafiC18YluS24=;
        b=RQg5BdTVlBRNmA0anLA/AEfBvZsCPnGPLvFVs8JzPWMVbAEI3TAXZqnOpwEHvPxc+V
         F0I9+VxrAog75zIGBXbdfFD1tRtVspXAn1xbDNCV+rl/TejNg7J+u3jy6Oen0DpzgBP2
         SxTARrs/vJ+0ufSsu4GIejAcN5/ee5aE0SK6I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=WPIMENGp4bXPFbinmL/gsx/9qor/mNBafiC18YluS24=;
        b=m9HfBLUaqs1heimmkhEPNaSg1B3CBu7oFzccVvhVnqmZZgFKWLY4P5BYldXrWLCBlO
         HBWunIHChnTsbkf1DmZQ7kqSCBk/0CYZqKKXAkqw65NbJRhip5OJbP/op9JI2KzPDXhD
         Y8yMtUDQ8Q1a0cpx/rjQZsipafqUK1BIMAcl2e6kG2EyBWpuLe7zyjxkpib/3oPxF6td
         2fV4OKGu00As1bbsFr4bA2LPQXBK+LJmFMyVlz53not24SaPoKdOjLi+sczmN+QthCqU
         umcxjbsvmDKdOrm/AtmnZSej7kMtfP1c9wYPSxcqWTo+FsO4XH0eYteFwjgLLGe59RR3
         l5XQ==
X-Gm-Message-State: AJIora9b9Zqp2BKCVwbTasPk11RjhBFVTUR35FPL0A1eopDcQE7mhU81
        HqiR9/iGxxzEh1aGuEmcWdurxA==
X-Google-Smtp-Source: AGRyM1tMNvmcCLUj0HlDUkFzzeB6v75SVTqcP11Hpv/RLbzqfbN4e0i9hHBWVxBReDceKATWT0IYoQ==
X-Received: by 2002:a05:6870:1c9:b0:10b:ef44:3c7e with SMTP id n9-20020a05687001c900b0010bef443c7emr9288413oad.231.1657040805081;
        Tue, 05 Jul 2022 10:06:45 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id h26-20020a9d3e5a000000b0060603221255sm16378453otg.37.2022.07.05.10.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 10:06:44 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Tue, 5 Jul 2022 12:06:42 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/102] 5.18.10-rc1 review
Message-ID: <YsRvouhNos6sGjiT@fedora64.linuxtx.org>
References: <20220705115618.410217782@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 05, 2022 at 01:57:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.10 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.10-rc1.gz
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
