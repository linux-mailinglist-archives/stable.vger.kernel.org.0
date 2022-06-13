Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C3D54A1FF
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 00:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiFMWQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 18:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbiFMWQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 18:16:17 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D8E2CC9A
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 15:16:16 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id bf7so8215961oib.11
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 15:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qEev10erEneQmA1DgMp9mcw1x8w0NcNzTwamC5M1bN0=;
        b=d+VrueJXaGfEIw3LFcLx/J5VhwORuYPLS9IpauRWNMgAk9v+gW/rztHRJB5dLavsv9
         wLgXDBBO5lpTYca6uMe9YkMMFy9OThcpu7h123oC1vy12cCUDsNua6/3Liavi1bE8dvy
         04RW5TeXFKv3aXsuxbDOKABpgYReo6OxRgiM4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=qEev10erEneQmA1DgMp9mcw1x8w0NcNzTwamC5M1bN0=;
        b=X3wBfKfI+UxC5lX2MsI+2pebXUHlnPlB1MzJs0IEZ2Ppwbhm7m9OkzeWI8rmtfcsp/
         K9HAFC7mgnStSHQoIpa1Px3CHYMM8h7SvWQ7dYI2/4nhP1YlUQW9qPnj33K3zT/f2zty
         aaiy+BQ42Dzlx8hJ/Tjc9tWrUjYetNX4MXBoKic6kutb+RBAyRtsayIgITPpmDtPdja4
         jrtdM6wb6mcwEky65OBgr8TivJUM/98B7Umdlv3KLiMOQHsY4X5tylRT8ftUS5xgEYYU
         lcMub40fIbciY9Qiv5qnsmV6ivICv+8+oiRtmucB2AXVIr1yDNhajlAatykJIOShTm0k
         +gHw==
X-Gm-Message-State: AOAM533V1/6+KMSv35NUJ+gUsddMeilSgSxugKisEbBo6auXRlNTDrKz
        zyqUVo1/hsIr83qZWJdoNeywnQDRp/8nzKE0
X-Google-Smtp-Source: ABdhPJw3xr0o6RM2UhO9DG+xeIt9l+iCkcm9vmONHb2yku5hHGzf3N3RMXW26n+4QpUuzwc/0YJ/LA==
X-Received: by 2002:a05:6808:2114:b0:32f:18f4:d8a6 with SMTP id r20-20020a056808211400b0032f18f4d8a6mr469120oiw.189.1655158575911;
        Mon, 13 Jun 2022 15:16:15 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id h28-20020a056830401c00b0060bc92bf0c9sm4047972ots.20.2022.06.13.15.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 15:16:15 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Mon, 13 Jun 2022 17:16:13 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/343] 5.18.4-rc2 review
Message-ID: <Yqe3LWZSfGEbMF7V@fedora64.linuxtx.org>
References: <20220613181233.078148768@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613181233.078148768@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 08:18:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.4 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:11:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.4-rc2.gz
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
