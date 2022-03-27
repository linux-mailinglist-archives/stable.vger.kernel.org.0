Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6704E84F3
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 03:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbiC0Bje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 21:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbiC0Bjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 21:39:33 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3321AD
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 18:37:53 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-de48295467so11858957fac.2
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 18:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q69hN/ppK7TtcW1j6kBKZgV9STG2WZFvOUKaGB8HOrY=;
        b=YC6JUzcv3vsA01QNQrv7g/vh8ab11+mCZMHMY117NR+CrBKfB8Ix+tcr/nbBkCaoll
         nzuxNoK5joKvFgBWmGNd3isd6EWxZ7wc52g5VC1L4Omrx96Jyc55kzTx+h7PqjufqlP3
         U62u9HoqY0wJ2yZFKUKVUaEKnoWCQRAiUHF2Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Q69hN/ppK7TtcW1j6kBKZgV9STG2WZFvOUKaGB8HOrY=;
        b=koySkfHLhIW/8zgIMPuDnJncxsOOy7Xo+aX3b9nG3XFzToT3thN1YbgaTqe+CRMAuq
         nboykahZYuuRfdgTAN98tdWA6V8P8sGvUVIO1KCP7okuzI+5v83MzXv01WxzcmMnUrw+
         JEN+cQ+GKcPQMO3OfccJRlqJsznAEtbsX1RTZk7wYoEjuyW3TskcIWKVdomUYIr4x3u6
         rohpOVD8XK8lnAUyuXnTytnvtnPh3ECbPLFtxu8xEGq7vIWszXD5rJK4MMgzXDq0q0VO
         8a5l0mBXXNSEWOWRtQQtcCxmHQii2AjhKunIF3SGz/feR7nBV4uUhaWpU3clEJBmc9QC
         b8Fw==
X-Gm-Message-State: AOAM532Bm92i+IT+P1GQNwGWmuULiJe7YPnO5wDaTLKpptvemjhneOs6
        BYQhtideqZeR/iPRlRI/E1zZ+0+qylOs/puc
X-Google-Smtp-Source: ABdhPJzk5EFvf1q1Ne6Ghcsw+ZWUOI88cF3yWOp0YQDmpTJ0M4ZHXm06hNa7o4d5oodGdSi2HbrSXg==
X-Received: by 2002:a05:6870:e88e:b0:de:4705:7fdf with SMTP id q14-20020a056870e88e00b000de47057fdfmr7486112oan.212.1648345072061;
        Sat, 26 Mar 2022 18:37:52 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id k124-20020aca3d82000000b002ef4c5bb9dbsm5170097oia.0.2022.03.26.18.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 18:37:51 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Sat, 26 Mar 2022 20:37:49 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 00/39] 5.17.1-rc1 review
Message-ID: <Yj+/7UCtRCV9ojQW@fedora64.linuxtx.org>
References: <20220325150420.245733653@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325150420.245733653@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 25, 2022 at 04:14:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.1 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.1-rc1.gz
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
