Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4AF596EDD
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 15:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239061AbiHQM5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 08:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbiHQM5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 08:57:14 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFCC4BA72
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 05:57:13 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id s199so15288975oie.3
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 05:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=kYVMcc70nCFaHFOhzZqmhFFWh6V1ggsN7VZR4hDDDj8=;
        b=ZuGKm62ZEMuX/I+GI5JIejpRdQvxnRqDlEhzcTdwfo4Pi98S9j2gO08DSKFqj2Yz83
         yGSshjBBMHD2Au58bOv85JIUOli+x+ooP2wLNfAM/OZFfbza8kNnjYxkvPbuSkSMMFIt
         6EnAOMI84eHV6skjZBR/P6k204A7bnrTrfbA4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=kYVMcc70nCFaHFOhzZqmhFFWh6V1ggsN7VZR4hDDDj8=;
        b=ofE4ziV8tzk5+tz8lQ3ZxI8z1+VQCqBjhrjzdt1owGMH2SYZK7WmMU84B08OPMEc7n
         GvtE2jfxJaAbgj63LtqaAIaf4qmX5zSPMY48+k2r6JEE9gEB1dnED9j2Ut+9cxfLiTPc
         sIP4O1kuQBgmuIWLH6unKGv7Y79ruFwMJv9krOlBaUnltaqCGC6LgiFd/JHwoZgAKwp8
         I5MP/li0XjtGs0m3SMsy7Uf9dEzC26/ITpg6uTPICCpB+2ZW5W9FmUAq0/gcTo5beisw
         9Mjyoe2wPFpQfHqWUdCmuHsb4HspLYRjA/LjNMpBb/cHyasSQ+r1ohbQzvbsVNoZM30V
         kyfA==
X-Gm-Message-State: ACgBeo0khVkrJIt/FbL/E9idZkXdDfYG6QMiskA6eKSLQw7QG0kcvTvZ
        jCg8kpRe3SxxAXXEKj7kH6sU/A==
X-Google-Smtp-Source: AA6agR4rAgEDOG/KauWkVFYjNGuS6fuYUzstIMmZICv2eMW37+NrJJEbxBGmlr2+MKDG/qFt+wW/zw==
X-Received: by 2002:a05:6808:1706:b0:335:1715:f33e with SMTP id bc6-20020a056808170600b003351715f33emr1370823oib.174.1660741032698;
        Wed, 17 Aug 2022 05:57:12 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id f38-20020a9d2c29000000b0063736db0ae9sm3325163otb.15.2022.08.17.05.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 05:57:12 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 17 Aug 2022 07:57:10 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 0000/1094] 5.18.18-rc2 review
Message-ID: <YvzlphC02BmJZ74F@fedora64.linuxtx.org>
References: <20220816124604.978842485@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816124604.978842485@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 02:59:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.18 release.
> There are 1094 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Aug 2022 12:43:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.18-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
