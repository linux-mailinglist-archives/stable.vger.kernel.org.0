Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5860E52ADDA
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 00:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiEQWM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 18:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiEQWM2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 18:12:28 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D4737AA6
        for <stable@vger.kernel.org>; Tue, 17 May 2022 15:12:26 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id v66so548560oib.3
        for <stable@vger.kernel.org>; Tue, 17 May 2022 15:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VcfAZinHlGFZ9Ka0EwGfmwNQcnOvK5QvS3DNltTPy4Q=;
        b=Redk3xYSoZYNgImQk/QEe4rpG0PT9L6UF1pSNMJC0M8QgBbDp66S//563qgFm6rfRM
         FCMsWa6EazZsqYsG7yjH+7WB4WijCqJG64oZpjBJMvBT6gfYLt5rzdYI1Uk+14m9Xen8
         WW1bOOZo26aI/rl/MMumcTveGS64WY0NdYUsM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=VcfAZinHlGFZ9Ka0EwGfmwNQcnOvK5QvS3DNltTPy4Q=;
        b=AkaK3KKFXWD6ZUtGXmvcukJO2JVlF/Osd16MTGmRHdrHVqBBsEGI4MBaPG4WzIQlGD
         SzBT3hJyHGIP8Bc7t1+WPDAGHTZNQ2z6HVXPQCMhLAWWCUfJT7A59Tvp0dHvCkdAcvqT
         ZKjtQC6KvWPeLFrzacXZkHdNujewa7ewHrKeiBfSiBhHNL/p7ECgN+IDiEfstvLZjGhD
         vl903H9TEpJ2RrZtC92o0aglR9bNm0r7cqrhKR9h/rxPUk1bPwJNG2cio+FUuthg6brT
         X6eco3CKyxbqvhXD0aGTOzHTDn3vC3AwxyIAGEp1g+zRfTuVzCmU7Sv3qipokAt3EPmY
         d4Wg==
X-Gm-Message-State: AOAM530atmO6oblOD9AkT7i0tq6YZWZXVB4eN6TtpIVs4bTN/5ZmDtRM
        IUV5YjrnYR0bsDvDHHL19hYY9g==
X-Google-Smtp-Source: ABdhPJxJWNaxLq329I3YOe6hnv9KAKfsG1BPHpCHrkaycjgJnFdd+1ssTnhRHt4xpj7egsSH2Q5cBA==
X-Received: by 2002:a05:6808:ecf:b0:2f9:f0b1:7ee8 with SMTP id q15-20020a0568080ecf00b002f9f0b17ee8mr11365329oiv.225.1652825546075;
        Tue, 17 May 2022 15:12:26 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id n4-20020a9d64c4000000b006060322124esm229794otl.30.2022.05.17.15.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 15:12:25 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Tue, 17 May 2022 17:12:23 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/114] 5.17.9-rc1 review
Message-ID: <YoQdx540mnollWaK@fedora64.linuxtx.org>
References: <20220516193625.489108457@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 16, 2022 at 09:35:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.9 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.9-rc1.gz
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
