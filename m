Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9E16BBF57
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 22:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjCOVrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 17:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCOVrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 17:47:42 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7280D9CBDF
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 14:47:35 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id bi17so26597oib.3
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 14:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1678916855;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XNu/ZDxd1c/2898bC2pLvfVOQzHQvYoBI/Zo5PqnfbQ=;
        b=ZYA5aFwKbsbVsNtXAHs6cAkaw0w7EOg1zjhs+M794aOamSW/TRd+V0NONSBmPL9alm
         nNz3VG9ItXgvY87IrtgzL/bWuBi8MxsiHWPHXIXLJrpBHk8dIYudpF14aVtxkS1uEgG5
         64ZhuDD1A2NfeNINR56jDSjnzF55vnfed793g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678916855;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XNu/ZDxd1c/2898bC2pLvfVOQzHQvYoBI/Zo5PqnfbQ=;
        b=0faeOVEgXaYi5oDtWbk8SfbYYpLmxRPEF9HRNr+Q58akIOKqjFQXdt8r5Xkj1riYXJ
         uV9TBfi9gUdIrrvqa4fiLoo+J+dz716Xd747yQkqsoc0FwyhLfJtmec8NVy9p75j874v
         ZoR8aTlpUW06V+qOSymEmaAC/V9i7mcZ95CZUs3VKfy576DQt0dEwKTUQpFjoWR1uTdg
         AMFj8HeZrE60m7C/ALgbFod2F9kWeo6T9cg/3/PIKjSDZbEc3D1n5S5JKMT00RdE0zrF
         aFTdAIl0Wa5tt4jg0ev8BP1K9GZK3jhWJcxc4KW4PH7n7+4bVn5ssiPlwv/IKPloj4mY
         v0DQ==
X-Gm-Message-State: AO0yUKWXyvvOgIZ6uMNzQ5ZxdH9PP3eIcwUfDnv+gFJbdcuzNvFrCQEi
        A24XardYeenC5USKdaMMDsaqpg==
X-Google-Smtp-Source: AK7set/1wOi6EX3ewTUrlh0Q+V7z3U5I3m2dJos4Lkw3/kNs4+4AWTV8MxqaKkoV6Egus8jGerD2rQ==
X-Received: by 2002:a05:6808:298a:b0:384:dfc7:7d84 with SMTP id ex10-20020a056808298a00b00384dfc77d84mr1844506oib.58.1678916854725;
        Wed, 15 Mar 2023 14:47:34 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id r140-20020acaa892000000b00383ecd10ea6sm2654963oie.20.2023.03.15.14.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 14:47:34 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 15 Mar 2023 16:47:32 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/141] 6.2.7-rc1 review
Message-ID: <ZBI89ARxCFkPvm7/@fedora64.linuxtx.org>
References: <20230315115739.932786806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 01:11:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.7-rc1.gz
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
