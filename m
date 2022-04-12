Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237614FE961
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 22:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiDLUSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 16:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233756AbiDLURn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 16:17:43 -0400
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9954C78F
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 13:15:21 -0700 (PDT)
Received: by mail-oo1-f48.google.com with SMTP id p128-20020a4a4886000000b003296205eb59so2259ooa.7
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 13:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xmRmkkroX/ZukAgPQbgu7GtPsckYSYxEzxmb7aKkIko=;
        b=ZR7DAm07c+QEkfiyPHmQCfDS7timLcGfYeugikAQaMwU5Vit90FIFszf5HT8IqDTN6
         MlDYXRrRhfYEJ4DRsY1nVyh5QoVxbY43AJ2//P+ZernsR/FLHrckT1w6XF1e9+YlnHK9
         7gN820jcbxY2GEZcn5feLjjKV0aY9lY2dtVyU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xmRmkkroX/ZukAgPQbgu7GtPsckYSYxEzxmb7aKkIko=;
        b=u//Z0BhN847nadHQ9jKOv4rUZv9lEuWPkyTEEHodfOcxoBh7+sL7+SwyDIJNBlBYmN
         vxGRAO9C1IL70hXgqVt/WOvZJC+neFXWfSHqwfDzi2nJgKOD6V8YJgx33clxL0jXEMA5
         IqbfG5T8zTmprjfR7+2b7M79mTaLCpTYmMSwA2Q3doagcMT3HckdHWeEAQ+NEXiOg8RS
         Wy6K/sYUeskPI4PHCNd9xyifd8YqpE39gc2gUMvEPIdf3Z3c3mxsjUeTZhC91RniHk+C
         9X+zKX1QK/8H8pLOwegBjjUbHnl74BEEw1zCmiWr5LCbUPSmjposD+s52+SR2NXEdBuT
         Lt3w==
X-Gm-Message-State: AOAM5327MqLTMSFcSy2WzyWvxKWb/hbzhZZoGSi19JGMTE2RP39qxYvM
        /RcoMUr+vFnHS5ePIF70oxoWaw==
X-Google-Smtp-Source: ABdhPJzbwC3w2M+vc7pyB5lM/HW6D/4TCKadUkygTIT+t7hZVldVzOyZ115iTy8XP73vsW0amgCbkA==
X-Received: by 2002:a4a:d109:0:b0:321:28d0:b7fa with SMTP id k9-20020a4ad109000000b0032128d0b7famr12254834oor.17.1649794132285;
        Tue, 12 Apr 2022 13:08:52 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id b188-20020aca34c5000000b002da579c994dsm12690706oia.31.2022.04.12.13.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 13:08:51 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Tue, 12 Apr 2022 15:08:49 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/343] 5.17.3-rc1 review
Message-ID: <YlXcUXUjSumMUipj@fedora64.linuxtx.org>
References: <20220412062951.095765152@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 12, 2022 at 08:26:58AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.3 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.3-rc1.gz
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
