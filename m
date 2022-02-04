Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B1D4AA48B
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 00:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbiBDXl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 18:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiBDXl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 18:41:59 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8163AD2E9593;
        Fri,  4 Feb 2022 15:41:55 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id m10so10383796oie.2;
        Fri, 04 Feb 2022 15:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pYG4wmk/hkyJhyn3f7GrGpM1zSwfY2NrMgkQsh0N4TY=;
        b=lXBJAgoA/3d+110DRlLXgJHcnsHHaglb5YHWoUdUWW2gs0j32f848HQwTcPt5c+ZCP
         3AKYegYlpU7VZWcB5Ixh5/A8xOzOf6TqioQOBMj/rXiTm0CxaL050e/GTODOh9LOw7bG
         qv11aCO4TArIv7D7Dr1Mt1BVBH1bYLyVG0VGldSLOPZoDZVQP9xRJKFE9j34qad6yKFE
         glUJ4oTaAYmt7AaWKU6RuRMNCjN7pQxvuIFB3kQNdTWRf2Urdvn+gnvrk2E+TCzk+OPj
         6hFpBEDIUGajimM//R+nlpqPYzdwGvffh8kN5uv/Z1zkPcoxY0AthwL0omL1qZyWqol2
         a77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=pYG4wmk/hkyJhyn3f7GrGpM1zSwfY2NrMgkQsh0N4TY=;
        b=Ev87xnMICqGp5RKhgGm1BNb/YcQihisGs3CVqz8ylMTn1gi6BdQtmBV8T3n/8jutak
         U6cfA8hWnKSxzZT7rNLcEBKvOJ5Y8Lv0i7GUmotQbq6DSdMYuQkERYvTawGiXjm6Mfo0
         3B5zZ7H8J9QTkwaNkrXyS9yts0PkF7s8vHSiFktniaV/JJ7E9JnYqHe+a6C1yIWNT68n
         xGjRB3t6sCME0GTmLq64Vp/anaSxvjWALkIvg79PG+tmoKlED+Zs0SbDSNsP5YSHDTFZ
         cEcWLrtJNqj2Jjm0DLkxLDgD0ommE3WUg8TTbymfXHMZQnWxxL+5UUV7Qq2/Bu+1P5Ov
         I7SA==
X-Gm-Message-State: AOAM53084+bcTT/9KXaTv3CchxUSLCfdD8I8SRTP+EmAmMi50JHreNGX
        l9mRI9Mh000FvKq/aO8OVwc=
X-Google-Smtp-Source: ABdhPJyTi2+uson0JzHtwkNVxrCDKCNUbzOJJ8Q9D4npSYHHcdzu6rdvXz8Kg83EK416xmaDWioLVg==
X-Received: by 2002:a05:6808:ecd:: with SMTP id q13mr2087339oiv.72.1644018114908;
        Fri, 04 Feb 2022 15:41:54 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ek4sm1102162oab.23.2022.02.04.15.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 15:41:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 4 Feb 2022 15:41:52 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 00/43] 5.16.6-rc1 review
Message-ID: <20220204234152.GA691909@roeck-us.net>
References: <20220204091917.166033635@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
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

On Fri, Feb 04, 2022 at 10:22:07AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.6 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
