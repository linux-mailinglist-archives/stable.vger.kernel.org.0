Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3B1510B13
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 23:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355286AbiDZVUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 17:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244733AbiDZVUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 17:20:08 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C29EC1CA3
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 14:16:59 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id l203so69892oif.0
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 14:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z4Mcj3qE3FABBr3ceQyAVJGsIOmy0ODTXxNYrqMyZWI=;
        b=BD4ZBHSw7m9GKQfPqpRuEXNNFQfNYd+y+Ll8Ansi71HgMJzE+lebfpk48h8pDRw8Ru
         lyff8qa2ShUoLeuM/5XVP8PiYFkPcWVIuZlswE1z3MFqVrKKkpUS+ZUEVv+WPvmbHWUU
         zanJcTJltehcTI3Uf5T22s2aeGHTQfrC6yOvQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Z4Mcj3qE3FABBr3ceQyAVJGsIOmy0ODTXxNYrqMyZWI=;
        b=XXfl8NXMyTfaIp5z0Z1otMu9XMNqG68myRIi6T1dJs/plY5o/xhCP2RfwK6UTDhSQh
         7h3yb1ggdyMLFrNFwvfuPr6DCa2cEy4/hZGKLdswKjiuYYo6c77uGShVt2aDTTtRHbMY
         mC3epxuSSeeoCWjh6DRgiwdn2JrItv17jQtDrEV/gnAxcYNgq97O1m75Y7eyyvlZzXkn
         +bEJQD0KqWdIsxdmbyD9fI1Zh6Va5Ez4ZlczP37JZNtwdR4T6o09pWkIIQCsz4LoY0y8
         guGnNNMaeLKcMiezwxIsHiGA5zX7kBTOTovRqgMz/uwQeTycCWEzlv22Fubwx5+Jy8TM
         g0eA==
X-Gm-Message-State: AOAM5301yH24L3ARLBgKw7to4HiVsgfT8fp5oJOfy6DdnY3vxkbunXYv
        2QE0u7Y33ZF4x1vgP29NWEjAZQ==
X-Google-Smtp-Source: ABdhPJxv3SiRXLZffAGNHrKHgjqZol9p0iZc/GOVD7mILmdRVlOvGch854cRHTcU0QOyV5BWSqVuFw==
X-Received: by 2002:a05:6808:1911:b0:322:c4ec:85e5 with SMTP id bf17-20020a056808191100b00322c4ec85e5mr15933810oib.12.1651007818338;
        Tue, 26 Apr 2022 14:16:58 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id n21-20020a9d4d15000000b00603fb46ddcbsm5247384otf.65.2022.04.26.14.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 14:16:56 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Tue, 26 Apr 2022 16:16:55 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/146] 5.17.5-rc1 review
Message-ID: <YmhhR213tAjEn+ij@fedora64.linuxtx.org>
References: <20220426081750.051179617@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 10:19:55AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.5 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.5-rc1.gz
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
