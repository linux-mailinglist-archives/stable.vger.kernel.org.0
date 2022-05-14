Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CCA52723B
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 16:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbiENOwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 10:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbiENOws (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 10:52:48 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6447D26E1;
        Sat, 14 May 2022 07:52:47 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-d6e29fb3d7so14059596fac.7;
        Sat, 14 May 2022 07:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3mE5pBypK34WXI2cOdwptYLHYYFJejv53r/03hvG0VE=;
        b=Z80H5xsMJpXgm7sITn6ydA1AYRkA2Mc8s5JHlVAzvlSw7VtOPwegHXzwy09WUPLMm3
         x1UXRgsF+0V4LI/WODk0kS6yCGa0M7DrdMGg73QGGGqyhopDivD40o+SBXCB4BlAGMFa
         fUbwFBqXdtr12w3PMmgvvuflyKEHNpClFxYA2VwPhZXDjmsGJvIE5ZmAM45q3cAwGu03
         kVWMnfbAYSDNp4efe7tD4HPfsUfoT9bL4GgQtDW3GIwkCxToH1CK+3t0jhjz2sgSMcbb
         Z+qXthycrZ6kX8rTRKPurbWtOXLt/BmWpgB1tDmeQ8ojpgIWAH9zneGWHly/QraKPkQv
         CXEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=3mE5pBypK34WXI2cOdwptYLHYYFJejv53r/03hvG0VE=;
        b=OEeaqEX2VFzDq09p5oGRtovpuZaMG3CHXysTrUpZxcyNk0i9IbhsHoe2QQYMUIRd8A
         4xBo+uu27DrrEwCO6F7cEWd3mM6tAVp3M4N58TLPVRLSiSG2ONzd+pNENKPu2rRbpoGU
         A60+m5ah0h+VuH05ch0yRAz6hT0iUvf++GnDYAM5TppAU7vXAS0S5sodSKCtNwRJMvI2
         d/7ARJxlIa29YfhvzmZNWPOVFSbFx/QOBxAo+r32iBMijCZdeNOHCNntPKyx2FYQfXCr
         laUsj+7sTrwnkq1wSvRoLevmFTwOcNhlrG8Velk+KbmgudGgRnZrOCulCtDWJWumuYIa
         0+tQ==
X-Gm-Message-State: AOAM530cAI0AET7ge7e80UWYueOv4jFJqXLPTgxpXaThgffa9PL4vOjl
        GFD/Sfejom1/zD+tOzoxmEM=
X-Google-Smtp-Source: ABdhPJzs1/BQx/1LqBgN1KFISMGPXZxKtekFmP8Nj+qpLH8MHeaun65T0uMEFKCpvcQr5BmFzdQ/3Q==
X-Received: by 2002:a05:6870:c1c1:b0:ee:5c83:7be7 with SMTP id i1-20020a056870c1c100b000ee5c837be7mr5035663oad.53.1652539966769;
        Sat, 14 May 2022 07:52:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x28-20020a056830245c00b0060603221253sm2121483otr.35.2022.05.14.07.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 07:52:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 14 May 2022 07:52:44 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 0/7] 4.9.314-rc1 review
Message-ID: <20220514145244.GA1322724@roeck-us.net>
References: <20220513142225.909697091@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513142225.909697091@linuxfoundation.org>
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

On Fri, May 13, 2022 at 04:23:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.314 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
