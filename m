Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953ED68A118
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 19:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbjBCSCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 13:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbjBCSCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 13:02:15 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4083C39
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:02:13 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id 14-20020a9d010e000000b0068bdddfa263so1592834otu.2
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 10:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ElhPdy3HZ+tMC66D0gemUG0NJ36awklBIZwajDDuj7s=;
        b=f0AK8r8vs8eozo/g9nuqIK/W7TzHFx8/hO/ZKJ+fWZfQP+Tv3O9nMZj9A3cH/ZhOh+
         JUXUqzbvQBjhduPyOXf0iK3vHMnRAPgoKG2PtrQtgaShqDyYGzv7AH6r3Uie+uGN4bUd
         qkqwoNMd782+neKg69YbNKNj9tyjKX5Fn1WUM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ElhPdy3HZ+tMC66D0gemUG0NJ36awklBIZwajDDuj7s=;
        b=xgaUCqwTlC+lv/MfGO7tlPP+gvkS1zV4q4UceJYGE5H5b0n+TtdaV0YHTghu/GtcFx
         AlWd8LtNmCykgdFtH6VYTvAwU/NxFT0wfDIXKEZO1NYAD0jJSJoJ5+N0VAvNBH8X1Evn
         k5saaA13r5wm+3zjlR/7VpxGzEZihQ/eR4v1mS3mekrZD+Etf4k5qGcvAvXzzYpamfBU
         iS8Si2z6z/g38+NG7X4lIH7e3r6Y6vdocEbMlW2iCcNbKxLUNiIeGHGAIQohKYQXHt//
         dY1sNF1rYnIPMH/zaNWQPaLz63HzxlGyztgPqSKWbfwLNylQEf16zhHhY+0iqvR9gR74
         zStg==
X-Gm-Message-State: AO0yUKVcuw7fcS2gZij/JhuYz+Wh8WJ+GgDclh6F3MNQv6qIA11frHc5
        bwtsSKHqtZsVL9mFAteo6kPv9A==
X-Google-Smtp-Source: AK7set+RTVC00E1jPHi1Tlxiq2+cviCtfF+wr4WU3fLv/XOzfcmGOLhrWp4yINiCB07leT5sNOplkA==
X-Received: by 2002:a9d:758d:0:b0:68b:baa9:cc95 with SMTP id s13-20020a9d758d000000b0068bbaa9cc95mr5339413otk.5.1675447332290;
        Fri, 03 Feb 2023 10:02:12 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id b9-20020a9d6b89000000b0068bcef4f543sm1382571otq.21.2023.02.03.10.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 10:02:11 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Fri, 3 Feb 2023 12:02:10 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
Message-ID: <Y91MIjq1Bgyq7jHr@fedora64.linuxtx.org>
References: <20230203101009.946745030@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 11:12:48AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.10 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
