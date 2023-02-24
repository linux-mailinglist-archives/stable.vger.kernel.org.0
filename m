Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0386A15D9
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 05:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjBXE2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 23:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjBXE2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 23:28:19 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A482CC5C;
        Thu, 23 Feb 2023 20:28:18 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id u6so6674982ilk.12;
        Thu, 23 Feb 2023 20:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=acQVstA40t9a/GI3I9ir5bu5ueJ+oOf7iOm5v8V7hj4=;
        b=K9mtWAgHoWDFEvqYNe8yyfThWHZJhDSdFFMBCxW4kwEr15rN+6cQ/toP1P49iRK1On
         BuyawCO46cGuUoPjs45jq41YUUVlKE9Uwu19nrAblx+qVJO3zHi4ubcmzDyP7MzfU8k3
         AS2HQvCf2Q9nRdW5XkD+zBXblHfzkDR/3wfR/WKtsp1uQLmw0fib7/R7JGfLlZfH7s6G
         yN0MVEBG9+1UGNn6SLV/T+0hqJcn8oVI3DlqssEgy5N3/gxVMa8FmmLQSmvcACsnTiuU
         pyhO+8CLY7EdnxlGQAbaubJzYXIMuen4tROGbHY+opWjxnpJ/jv0V5MAHa2kiSUUQTzI
         YCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=acQVstA40t9a/GI3I9ir5bu5ueJ+oOf7iOm5v8V7hj4=;
        b=HBGhcrplO8sOA4KLV0mKaeXuLnDOlVa/8IxxrVQ0JXbRXgNt6qfNL8bUW/iHj0EraP
         sgh4v48Fpel9YPM0nLsJ47yYTOGT/i22zG3+YOOAPlvRmbqmKzIP87HGYkqtBeQf+PKx
         xJKRsx9V+LXq08ExJCAWF53tZe/q/hsQdq0q8OnzbQ1Vxc0VbVItEqZVz73lqCst8rw9
         py3T5FdPA4P5D2OuCqRRlNgJovzSGWIPg/GEYxoviPjv4HOhDSf81HOPS5BFrAan05c8
         LA38akiVz7uEA0ExARZICLKAeUKQUZfGpFjM8mFoROqY4qkxjhQapQNy05rmP7vzcAaJ
         ZHvg==
X-Gm-Message-State: AO0yUKULxNN+VARvwwNwa/kFmBfyWNt4AB3lUnLXoQQLSP1MG1qhvNdb
        v16T4CnRIy2A6LKEudST24I=
X-Google-Smtp-Source: AK7set/PgAmpJJPnVH6rSe4VB4EH2LcUE1RnGs52yQpFjvcENddYqJ/W3Yrqr+KeL4aQzSLXdVo6cw==
X-Received: by 2002:a05:6e02:8b1:b0:314:1cff:75a8 with SMTP id a17-20020a056e0208b100b003141cff75a8mr10261682ilt.26.1677212897961;
        Thu, 23 Feb 2023 20:28:17 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a18-20020a92c712000000b003157ff12248sm3875327ilp.41.2023.02.23.20.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 20:28:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 23 Feb 2023 20:28:16 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/19] 5.4.233-rc2 review
Message-ID: <20230224042816.GB1354431@roeck-us.net>
References: <20230223141539.591151658@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141539.591151658@linuxfoundation.org>
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

On Thu, Feb 23, 2023 at 03:16:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.233 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 450 pass: 450 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
