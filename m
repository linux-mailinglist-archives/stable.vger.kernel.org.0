Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA07536A0E
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 04:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbiE1CA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 22:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244826AbiE1CA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 22:00:56 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A3D5DBC8
        for <stable@vger.kernel.org>; Fri, 27 May 2022 19:00:54 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-f314077115so510851fac.1
        for <stable@vger.kernel.org>; Fri, 27 May 2022 19:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iPbXkcLbQ4X8axGLAMQzdWp3mU7k/e2Nfqkwli3cCcA=;
        b=O12hRDx1czOFcYjWN1pkNwT5Oq2V92Cte9x3UUQUcxy6Nz0cFB5C/ZedGfclN4IMgo
         ITPdnXEtSuOAjRvfJbaoECCgYddqkxAMsgAXpgvo5nPsbDRPrtkR1MDrEF1g2mkKC7pG
         rp2JLYty+i0jpXVsoho0pk0rLmlsG+NvgsRSA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=iPbXkcLbQ4X8axGLAMQzdWp3mU7k/e2Nfqkwli3cCcA=;
        b=b6ECGSSVcoDMqyG5hDDnxAxignlxMv60FCyrADZ0MUrOu4yeUSkc4exDVpLOY0T+6+
         fcM/rx8UJVcaIbqaJfidzb1hvxyEczQt8AoZVfCWtxdxTj0wHhX8/Xt2owA3FjW5WNba
         IIA/0f0ZgJP0vzBjtTPk8QeMVezkNYni8ghrgpSfarMl5hbXeXI/ia74ldNaq6wF2Uzd
         rJV93sFNw80ICq+7LDnFl3rAKao31eVMIo91gqyz1onpFhnu0Yu4G6QWsayL0pNta2aV
         iw7uafCFVBE/oyE5gaTaBMEoP2cua1LblBhq3Qw20LCz0Vtk0622zWERJpnA9mbJ8Jd5
         4HOg==
X-Gm-Message-State: AOAM5302KvFmVQtqRYnZ4NjOdpdQfDKVqNMjHDjs3l+m/YaHNkcJl72V
        M68HHsgZBO9wigK/ZAXrlL6Nnw==
X-Google-Smtp-Source: ABdhPJyFDMuuHXQiGMljrcllRO3B/P0zoAE8+QvgbJHyp4g0NrMAosEupa0yh0raWZkzyS2uKF1eKA==
X-Received: by 2002:a05:6870:fb89:b0:f3:923:643a with SMTP id kv9-20020a056870fb8900b000f30923643amr1535882oab.177.1653703253383;
        Fri, 27 May 2022 19:00:53 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id z20-20020a9d4694000000b0060b66b6641fsm798871ote.5.2022.05.27.19.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 19:00:52 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Fri, 27 May 2022 21:00:50 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/111] 5.17.12-rc1 review
Message-ID: <YpGCUsxqcsfjq5qH@fedora64.linuxtx.org>
References: <20220527084819.133490171@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 27, 2022 at 10:48:32AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.12 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 May 2022 08:46:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.12-rc1.gz
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
