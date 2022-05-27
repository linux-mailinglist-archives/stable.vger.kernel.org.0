Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720A75368E9
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 00:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354831AbiE0Wj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 18:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352476AbiE0Wj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 18:39:28 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FF566CA5;
        Fri, 27 May 2022 15:39:27 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id 1-20020a4a1701000000b0040e90b56d03so1036489ooe.12;
        Fri, 27 May 2022 15:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6tghQDWUjFQAd96YuPjrZW8M2HJ4GUxNfphyXe3eBPE=;
        b=doTEFTI6SAGrMmFVyWhrb4BQAJf3B38NaLL6SJL2aGQpTtAhrfvli3OtYlFBfpSNG6
         V4wyrOXWJ+R5DMinH7upnum4kvurc7O0DdwHMPzfrWHJZqT814BXM7WmqkyIiaGgLJ2V
         sXoWM3UJsvC1X+AoU/mwHuax/bAEQk4QJLSJ3y7DDmpO4v9NikAYo5WgFmxZzlD7nXNO
         xRLE+tp9F2DIV44KP/Iza8wwM3REgczyiX8tXF7/yzfGyLDY/upRoPJZiPSDrLKeuHgS
         qq+SuEOhKO6UOtNvPamoodaNLqU2Qz6a/t0rcgyKZ/G0bolAxrzzWVw9upVF9OVCq1RG
         yeOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6tghQDWUjFQAd96YuPjrZW8M2HJ4GUxNfphyXe3eBPE=;
        b=NRFcMuprFxiLT9T9x4yBBOXFD5f/k/yP7Ob557cwQB6thedbHKESU3hXVdMaLSc91r
         52JoKcY1IaWK1yoDGRGwlogArs7RTvfQ1pDcSjvvaGGGSR4577TRiCPOxFRchaPiVyVY
         nzeGYydJ+u6UuPmNbot42vBSJY5YJ+cCfAHzoKDQGnztNvZy8x8eOFhHzjIUto6VLIOi
         e9Hy2m6XvWEx9+REvpQzcP3eglVjYHhqPwPxaGmrQJg4xVREJMvuhD2AAbFsUksf0/ns
         m49weDAu0gAC2DVsbzzLi6HY/MwYHsC5J0xgbsLhmQEROBJrtjZuXZEzBHQ6P0Sa03MO
         eG8w==
X-Gm-Message-State: AOAM530aEeLSQpo+LJ8y9T4LLlSipb+/7hUb+HErwR3HVdP4WUM2IsXa
        WLwHjwBt+/BrWckz7DImVpvhULK6aJJh7Q==
X-Google-Smtp-Source: ABdhPJyW2lQc2edJ93lFUZpsQFSaoJ1CE3ehLw0Bx6Y+clvVhfCcUSG5NU8cvhgQFMDQvhNMk/d7Jw==
X-Received: by 2002:a4a:a3c1:0:b0:411:6091:9f6e with SMTP id t1-20020a4aa3c1000000b0041160919f6emr1022897ool.16.1653691167220;
        Fri, 27 May 2022 15:39:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y9-20020a056830070900b00606387601a2sm2301518ots.34.2022.05.27.15.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 15:39:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 27 May 2022 15:39:25 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/145] 5.15.44-rc1 review
Message-ID: <20220527223925.GC3166370@roeck-us.net>
References: <20220527084850.364560116@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
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

On Fri, May 27, 2022 at 10:48:21AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.44 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 May 2022 08:46:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
