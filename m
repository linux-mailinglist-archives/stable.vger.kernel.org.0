Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DED4515924
	for <lists+stable@lfdr.de>; Sat, 30 Apr 2022 01:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380704AbiD2Xvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 19:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377213AbiD2Xvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 19:51:44 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444289AE6C;
        Fri, 29 Apr 2022 16:48:25 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id m11so10076583oib.11;
        Fri, 29 Apr 2022 16:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kk2BjjMY8FFuo0h0KmFRj/ksU/PaplrAYd2PUAft7Tw=;
        b=l+EseMjdyG6X3AwvbHChODQOsBpkvqU2N7zSYZqth9Gw2OMc17hE9aK+1ouukA8P2Q
         EfybOTmPSZ/skreBBL6X/yHwTW1kPnWXBvtIpSlw5XdcM+WNdCPgQ00P1ar6f7Hgm92+
         pvEb1tqAI65z+c++O0c0FVU6Bk+KK0KUUAh+tZ1aqAaXNN/LwHhVnVse2bQrEeD1nImN
         b/bS+P4gRhVScHNjHRvwnRMF556mV3R4PY90PEKXpSep2WqTgzfid8wOt6zKzTzRTKqY
         FMRM0Z92/Yulg4GzA+MuqaqBVQxLOumJMKTRTAKXFWTZJXskOdc9K1J5uMCC/h5vqMIl
         SBbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Kk2BjjMY8FFuo0h0KmFRj/ksU/PaplrAYd2PUAft7Tw=;
        b=PdE7Y+P6sJ3OsFdhxjXMr57MtdeGIsmJIJczzzu1kogwkGJRFai9rJL5dCP9gMy55Y
         2KuinaEnXBGWUTm+6D0w4PC3UQEsZBqsux+shPh11M6NQAcjIpYFMkI7Q6NAWzdpo7NZ
         LAeoab50SD0WNpcJSrHucKSF2BDA1vv2D73k1XKzWaK6ncjZTKIdrCtp6TnjRa/FfGke
         xhNB7JGIemRMys/ZS9RyIbrXspqbZpAcxJhS7EWFBYmRd6naR0BTJMRL6RIj8MILY0pj
         QNCf0uJ0zdz6SvTNa6VkFaMoqr+1D9oYllg1OlNCsKQLJktKttjmHlAAje7kMFOEpTNU
         yAIg==
X-Gm-Message-State: AOAM531BAT/RcXPJrWc+LgIVo3WFEiiLKpCmv+s64W69d7DAIdZpTRqP
        tJEHMgQ5gZpEC7bcb93gify4RaKyWcznbA==
X-Google-Smtp-Source: ABdhPJwpNkFEE+8cVRFzKpU4jyXDcTahGe40dhvrTBpLphHxTslvhrrMz4NWs7jSB+JrpWpllVLh9A==
X-Received: by 2002:a05:6808:1641:b0:2f9:b0c6:1a5c with SMTP id az1-20020a056808164100b002f9b0c61a5cmr2723272oib.140.1651276104651;
        Fri, 29 Apr 2022 16:48:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b14-20020a056870160e00b000e915a9121csm3879841oae.52.2022.04.29.16.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 16:48:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 29 Apr 2022 16:48:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/12] 4.19.241-rc1 review
Message-ID: <20220429234822.GB2444503@roeck-us.net>
References: <20220429104048.459089941@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429104048.459089941@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 29, 2022 at 12:41:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.241 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 May 2022 10:40:41 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
