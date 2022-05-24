Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAA2533223
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 22:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbiEXUFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 16:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbiEXUFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 16:05:00 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E245930F;
        Tue, 24 May 2022 13:04:58 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-f189b07f57so23653548fac.1;
        Tue, 24 May 2022 13:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nRFI9jnT8lMqP8KVBp8u5nfmdIK4lvLT/59EUdC0LBI=;
        b=jqdRDnXDiX1mpvpLJO2E8/x6L+0MvRj2X2FkNqu/jjGkNq7Q2gPSXEnwJgzCYKz6X6
         PZy3C07ry14eCZwGin6Yk7EanXbVhG+/l7VhnEEkj4ZHs4krBpns4t+ph6QRQJ0KhmBI
         5dR9tqT556gcT/Ccto8Q0aWcXHGITrcIaHAf7JjMrcrrqyBaAMLgBl4o7xCDinTZw0o2
         IZS/zZzNA0aAPgruplipDuXPHI/jJtx/94GKme/pm2ME5xfrA5apDu5JtyxlYIAu7XBQ
         xUNDBtP2M+q95bssA/Xi/U2Y4QPbr0MlHa3c0ekKPmbfSZAL0YGNtTMy84I4Q65d2m6S
         DwGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=nRFI9jnT8lMqP8KVBp8u5nfmdIK4lvLT/59EUdC0LBI=;
        b=A2YIJKGKf3l/B/oYeh3wqjgc6UrBDRHKrWrjcGZEDug/lvfb7fvIeq0DCc/WztRYfJ
         r8N/hhmcsfIn5dLBiU7z6dSsqgiA7n2lGZVF0OysRLSzglqqvZHaTO+0+lSu81LplRHa
         0yuJDGOi2VIVVMSueYx2kurbMOnJdqTZlHekr3NiGHAU4QZmbeCy/I6Jd5l2/3tm/zwC
         BvHSVxko1zx5pf9N66k6MlreH4eADfqmEXxzo4OoA9XxlpcVp26qkCCvujHRlwnHiW2U
         GR2TwLr84YqDimjTF4TjvE+jj2udfMl4hGlIBXtzWWxxpsMudSlXCgWZHDi7ZFqXEPFG
         Zp3w==
X-Gm-Message-State: AOAM530uOQWemTHxwgMCI6KoGi3KCOFqVcduGy63IGU78gzPOT6Wisnq
        ZXYtPXF9laBbAEPTH8WsCH8=
X-Google-Smtp-Source: ABdhPJyoTvVt1o6/jAIBWL6hYtahv0Eksto1skxuIlszNdBOXF8XysVIcP94/3LK66ZpnAcJ0Jx54w==
X-Received: by 2002:a05:6870:4188:b0:d9:eed0:5a41 with SMTP id y8-20020a056870418800b000d9eed05a41mr3577540oac.161.1653422697508;
        Tue, 24 May 2022 13:04:57 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p9-20020acaf109000000b003266e656d39sm5590480oih.4.2022.05.24.13.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 13:04:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 24 May 2022 13:04:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/132] 5.15.42-rc1 review
Message-ID: <20220524200455.GF3987156@roeck-us.net>
References: <20220523165823.492309987@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 07:03:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.42 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
