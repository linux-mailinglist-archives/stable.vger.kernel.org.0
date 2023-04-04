Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9571B6D6EE2
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 23:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbjDDVYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 17:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236560AbjDDVYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 17:24:55 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405201701;
        Tue,  4 Apr 2023 14:24:54 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-17e140619fdso36180114fac.11;
        Tue, 04 Apr 2023 14:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680643493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QOnTaTc+5QrhRyhcClArhfTQwHoDfWNZZzKAwPQKxUg=;
        b=Fn1D0K4W5Gr/EyXlP71+kH3uncuKwrM2hOS8WzUfGnxZfNhQZW96jknFxzimNlu5j/
         AnOBULccDYCEU3sR0N0Wx0Oq9yNKmQDJmWTIvRRLf42gbOn+vXdW1HWXmGdgZX8KQ2B6
         Wd6N/Wna+iEwKd9O0fy9UfbLpKgTb6rjVBA3PsXOtPOupiEpme7H7GMbUEJ/WD8R6Vh+
         5UJTW2ZtpZBXYsORx2BPzwkweyS3YJKiXlqx3f8pGP98/z+rnh6i4TmY9QdwAGZtsYzH
         tWiPijM+dSvgqUEx9lC8NWAu8i1VUOjB3ZytK1Wt4Rn5BU4kc4ABlY2WnKrR8p/u1U6B
         Ytvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QOnTaTc+5QrhRyhcClArhfTQwHoDfWNZZzKAwPQKxUg=;
        b=aTXJKLDtlUTDK9vw1yWf6WbCopMEjkxXCA8mEmVwZkleJWWff4me5NEPDNhn25A/n0
         6iK1f6tiAfPCtUkjH/uVE1UYkwkTESRPMhjAXpHxE7F3WWZWYoMN+xF7zPF46ickdJUi
         IiI8yVNEzJWG7+etVB1dMIsC+aV2wHXI+ATu4+3CC4ZAFI3xjn8QWwCbiqLtgtkExu1o
         vkr6YGSAqJZ/qaL+5kXXQx8cl4Vh8dFx+Ij6w6vEr+KU4Kz6EdamvCD6BM9/HeDIGevW
         ZX65/UPDPQ76xc0cff+KAzEiph9Dw8fRkvmA+iXHoVR6Ac8Kt9f+R1VpjqQO0OZSpKnZ
         jQJg==
X-Gm-Message-State: AAQBX9d82i362NRzTqgTYKlls+AR9IUlS8tqCl9vmCo4Yv84gX0p1Vf1
        PJuzRdAnS63DSFEcMJdDCUY=
X-Google-Smtp-Source: AKy350ZI+t7Zvp//6OObyQ3PeUXv92sErJTJkbMirHF49hpNBWvSFwhoV7S8AtRoUFVSEsAnk+JcAA==
X-Received: by 2002:a05:6871:546:b0:17a:f1a2:c4c7 with SMTP id t6-20020a056871054600b0017af1a2c4c7mr2435640oal.42.1680643493668;
        Tue, 04 Apr 2023 14:24:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d28-20020a4ae83c000000b0053dfd96fa61sm2407872ood.39.2023.04.04.14.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:24:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 4 Apr 2023 14:24:52 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/84] 4.19.280-rc1 review
Message-ID: <86c9a92a-9907-488e-ab7c-66a703f9c15f@roeck-us.net>
References: <20230403140353.406927418@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 04:08:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.280 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
