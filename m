Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD096A77A2
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 00:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjCAXYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 18:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCAXYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 18:24:06 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D986199E5
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 15:24:05 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id s41so11402310oiw.13
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 15:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MBy37NoOiV44ZXQw10RgXnBxTEBWUevOWxm5PdpkoeI=;
        b=HGErcMlSAlTgH9cBRiSikCXGpHFgm8g1JIxHvOWfrNvR670hkZilAUeEe14dJY4bB2
         uWS3ELx4eMx4H4N32DDrDNfBbSJcRY2fZzYlgnYxB5GnJ+JyhpCY3ZuGuhXBGD1WOkjX
         HlU9C50iB2s4G3PWHJ6gcWwxzq1Ar8AzDDNyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBy37NoOiV44ZXQw10RgXnBxTEBWUevOWxm5PdpkoeI=;
        b=dz13oIl6yeNQdSF7iVNApHWln6EUqaF36ff7RBJ7faSnoNp+71XeTX75ePhxJZpGt4
         CF3PT5Msu7JNpH1w0rvc+LLZ+sKvzWuWJBLrfqu0CnFpSWXjcsQ5wbmOte9VF2p52WoK
         AQLqJTI8cqOQi1TWs+teOgSyI+EPQQiO11mmiQ/Zmu8SBL7Rs575DNXTIiwEGv0D3oaW
         /yiz6NKycDvVxVWPdq8cVhEZ64ZN45xs/Le55/UM/KRYZwfiMot0ElK7ug8IOxKCEXm/
         2o2tAS+R90GTVvmrXMEJPUDzxTi87kyI8n+8G3pGO7hZ+89EVdYcigSEhxcEXBCxonfF
         gvNg==
X-Gm-Message-State: AO0yUKUpw27erOlRXgkwSlCNUCSYrO66ttEW+def2cO5ZBYkUwIgFYKV
        4focEXey7ppXSaCPNgAJYUHpZQ==
X-Google-Smtp-Source: AK7set8/pItrW8pjpdC5op9qqcqNb3wEilvsaJasloBHbzJntz2oYBL+QjHtnKSOy2h18KARhdqhFw==
X-Received: by 2002:a54:488c:0:b0:384:8a1:c14b with SMTP id r12-20020a54488c000000b0038408a1c14bmr4304349oic.31.1677713044362;
        Wed, 01 Mar 2023 15:24:04 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id eb3-20020a056808634300b0037d8c2ff0acsm6367101oib.12.2023.03.01.15.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 15:24:03 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 1 Mar 2023 17:24:02 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 00/16] 6.2.2-rc1 review
Message-ID: <Y//eknqY6WbJeXWB@fedora64.linuxtx.org>
References: <20230301180653.263532453@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 07:07:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.2 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.2-rc1.gz
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
