Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E236ED9AA
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 03:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbjDYBOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 21:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjDYBOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 21:14:41 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFC85269;
        Mon, 24 Apr 2023 18:14:40 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-63d4595d60fso32121387b3a.0;
        Mon, 24 Apr 2023 18:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682385280; x=1684977280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n2bQyMry/9kSseFNQy1cBpWwH7AVeOJi3gZtdTMmTCg=;
        b=nCNcHQo5PbPYzh7MjyO2ZOQb3SP77sL8VfN+AoaNosvUCSJJmXhKydJfvdR1hjmKcp
         z+2S2WYpNgkOMyhOgxcpBR8jTi3gghJ+CRhQx1lpg+BGKR73PI4RGdCGCZ6muFcif0ZC
         juSlzE6U9LRzVkTGYdT3R0JimTiPQaYJoGIRu/fw8Y6c1z89JjoTARmbyYWblc39qeLf
         FMxUGRbC+zv3F2hLueEXhTas6OGI/PX/kbe206ubDGaJKea4sGgaQsfqssxevQeXURWF
         wmWHMHUBkzBwy/c3M2KOO4evUrjPtqYpm1w0FSPbESnbe2hHBami//Wqgb5prec8rvf/
         JIwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682385280; x=1684977280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n2bQyMry/9kSseFNQy1cBpWwH7AVeOJi3gZtdTMmTCg=;
        b=LBuh9mVMNus/On/F92t4VtXPb3c5508ROTw9r1URxjDedS4VjCKNQSNjJeWsuRsgGG
         H8M4jP/S90KbKeEDszTZPwsvyAszp7D79YCQQvvSvCO99rWnt8HYijb1x+Gpl/KSHH9l
         SN1vGDiMFgnVnEdqbWlBKcvEjZ4D9HvuLDEejwITAbFMaxfeyvyZEhVNvhUeHwSYQl/9
         z8heRvSySJ+QczUe+BftZqC++2KCD1wXf85QXrV94UFj74kqC7ErD7v44vbeKEPYejeX
         JFvbRDjAjGWM8PMXzDYeQwOz3l9uTixmFxvk+6Omkagk8tk0K9pup35sy8vBKjv3djY1
         S20A==
X-Gm-Message-State: AAQBX9cxQ9HIw9PnRcwwKvQnots39VhIHf3KMrHRXbAZOKSUY/Ubxzu7
        1ZRIxuMSe/M8HPioCBdj5xo=
X-Google-Smtp-Source: AKy350ZasDNSaksLDrr3nAEgu2HhY1yXh3Dlz2qR4UYh0a0ya6SiQ47yY9iOtvM7KfHiM4bGmrMJBA==
X-Received: by 2002:a17:902:da82:b0:1a0:76e8:a4d with SMTP id j2-20020a170902da8200b001a076e80a4dmr23434574plx.14.1682385280267;
        Mon, 24 Apr 2023 18:14:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x22-20020a170902821600b001a24e2eec75sm7062491pln.193.2023.04.24.18.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 18:14:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 24 Apr 2023 18:14:38 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/73] 5.15.109-rc1 review
Message-ID: <0f1a684a-0d4d-4dc0-b99d-339f6559b87f@roeck-us.net>
References: <20230424131129.040707961@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
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

On Mon, Apr 24, 2023 at 03:16:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.109 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
