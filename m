Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6F46667F7
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 01:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236461AbjALAlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 19:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235699AbjALAkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 19:40:35 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345D11DDCE;
        Wed, 11 Jan 2023 16:40:33 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id e205so14112086oif.11;
        Wed, 11 Jan 2023 16:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gmm3Kka8nPO6cOZbO1FBl6SeSZ30du4k0AiQMDwpj2I=;
        b=mL8zKn2DSYyQ/FIcpmI/WpJPMFqMXQ+g32HMxe+smn4iuXjDrcKWmVVfVZw5f4Q7vK
         5pNahLYCwjg2VkR+QTq4UV+mv/DxYO8Bp3ksfY7rg+erqDNc4G4xLbNdscI+zbo+eniY
         emW/ZLjvdGH/eSDwQsDVxzp0TZW4sm/J0Ox36maB8nQ6NtWGActmVxXyZLXXTxucKUVo
         QsHMOOqPAqHoHNeETr7oxx5dVpsYpnpiciUzFuAQuW2qEpuM0dT+rmcQNyG1/VeBTk8x
         bEIt5oV+M0AO57ZcD2lUD3RTKy1+Djl48CkClClQILCa07zzmViKFiItE53hwebknTsU
         ZN/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gmm3Kka8nPO6cOZbO1FBl6SeSZ30du4k0AiQMDwpj2I=;
        b=hO6obn0JUJaLUPNa+gWQsAv9gRY5x+/6HZeus9w2JjPKQAmz5OSuy40qHU2eVIz9BL
         LS7UG/9IS9wc344wHBvxKGGt/NXw0EffZkQb6uYBdjyJ5OMj856bir1f/VKPq1JpgPFo
         dfJvhHqtVPffHBzK9fafs4FBPOQ4W4zAPpz0XBKmFAbYVEOhgonSXknwKFNkYK2jnjKy
         I96y8PbjDYcMeWvq+vBWACB5QQk9eaXFb+91/xIeYPnXO4xtjsuPI/KtFfXMlL1Yrsom
         RoIpK0/E8dj0JilzQDGODj9f12e+SM2H1EbnDTRcqECTDchPNPzg45YCmS6rfr12S7hS
         UhDQ==
X-Gm-Message-State: AFqh2krVX7k1G6m5+QxYBfcv/P4M04ttOwn6/fs77X8sylO/eMuu+dUJ
        rwjF1Gm0CdMmSNIENYIh0Z0=
X-Google-Smtp-Source: AMrXdXuMKt/Fz5Rsn3/w68ycL7qBeSDUdCor8hBlrKV49vdgAPCvjbfvkAaK/KAwC+T5i79Mut6k7g==
X-Received: by 2002:a05:6808:bd0:b0:364:5d10:71fa with SMTP id o16-20020a0568080bd000b003645d1071famr4440565oik.1.1673484032514;
        Wed, 11 Jan 2023 16:40:32 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 15-20020aca090f000000b003509cc4ad4esm7280627oij.39.2023.01.11.16.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 16:40:32 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 11 Jan 2023 16:40:30 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
Message-ID: <20230112004030.GC1991532@roeck-us.net>
References: <20230110180018.288460217@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 07:02:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
