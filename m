Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBE25369EB
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 03:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344741AbiE1Bxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 21:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiE1Bxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 21:53:32 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28B93BBEF
        for <stable@vger.kernel.org>; Fri, 27 May 2022 18:53:30 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id u140so5254883oie.3
        for <stable@vger.kernel.org>; Fri, 27 May 2022 18:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FtI25lp7z4LZIoDWgGyoVrLCNBjX3mKlwnGfkQ7hiXg=;
        b=S0abEByizXkvjju3NZf4tXR3OvTpg5QydyKjKnWgPRTcG91ZB0wyHLea9pkTO4K3i5
         FGp1BNNsDNnJ8PmSUEdkf+hWax43dxqPPXWa0fPDwxxOOz0p495QqywLiGnjS5ep2hga
         Z7otyinDIEHZYYA/E8L2pe2PiMQgYWQoDIYEc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=FtI25lp7z4LZIoDWgGyoVrLCNBjX3mKlwnGfkQ7hiXg=;
        b=TYw+Wcn+/JpRBYit3Ty8xDKvTHMxN3Z3qK0HzDwcfxn2GPngZ6EaiNwsDf0Xn8g4CO
         wOOvukBBtHlnx7XqFBZqLyUwCbRctoVP6sWbRFz5Wm5jLBHcBr0V6UN/E4wuTJA3A11O
         dzrJnqk8X1eaVs7ZmwDrzzBmHZ1fZvva+6YivbnqD5uXoPycrWf+tBsK/Nkbu4n18b6g
         PT49vIY3+pG3OHEFqW3cgFfsLq4WBbj+i56i5ks2W76FNg3FAEzLDWMyeM8zM5NEmlSQ
         xo1iZWKUc8L+BQOuCOqi9wM+rnS/d6T81ze3UqeUVpS0g5PAaXiWHJHD4jaJg/38sr/C
         k4Qg==
X-Gm-Message-State: AOAM532td/3WUbtRzhLmfLWOFWi1KgDSrbBFotEdaisxMMuQOyozjFm4
        oUiZXEL1LXSjmpA2XxC+lCfOyQ==
X-Google-Smtp-Source: ABdhPJxHqRn/G7EkUc5FjYjFt7CzQ46NrTCodQCc1OsQ/iro3GEHyOFs/ZTilzitj67zo8Xre1gERg==
X-Received: by 2002:a05:6808:f8c:b0:32a:e67f:d20e with SMTP id o12-20020a0568080f8c00b0032ae67fd20emr5049500oiw.88.1653702810215;
        Fri, 27 May 2022 18:53:30 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id lg11-20020a0568700b8b00b000f193e656c5sm1241788oab.15.2022.05.27.18.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 18:53:29 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Fri, 27 May 2022 20:53:27 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/47] 5.18.1-rc1 review
Message-ID: <YpGAl1lh9vQSxsFV@fedora64.linuxtx.org>
References: <20220527084801.223648383@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527084801.223648383@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 27, 2022 at 10:49:40AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.1 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 May 2022 08:46:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
