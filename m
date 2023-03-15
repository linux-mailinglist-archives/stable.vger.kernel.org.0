Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF806BB5E2
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 15:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbjCOOXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 10:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbjCOOXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 10:23:43 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5507A1EFC0;
        Wed, 15 Mar 2023 07:23:29 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id a13so4039915ilr.9;
        Wed, 15 Mar 2023 07:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678890208;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=rhGIf71XNMbSQYsIlu2QGVy+/bw7XEJxRW6NuKNyMUc=;
        b=nbmpyZujintm7OAS/LjGOGkGUoDbJxnBCWZho0e5oML/15cTKCZ83FF7NiydxTwYPm
         /i+vHoamCgmfbUapspT+sVSc7x2fvxqzB+xg+laNMiNpffmp7oD9zdkZcQ1elRpx/mDE
         rFZI7nuHslxql9S5XKZIeBrVTRszeEo/U5WRyrxM0vRM/1Nmcq0LMVyM92pka9WCaNPS
         uBw86bIs2nFY3rvL+5hR3KuG/J3ufXHCq/PUGAk9dxyzWcMphWsUKEpc/5zdOfce/IYP
         KiCy8irMvr1S/qR4KUkLoxEG5i5wNfd4xxFLI8s9EOlRElE3og8MMR3fZ27Q0P/RsO9a
         Zogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678890208;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rhGIf71XNMbSQYsIlu2QGVy+/bw7XEJxRW6NuKNyMUc=;
        b=FX5tn9qHog1dWhTKdo8d8HyFkt+TqXML2RfVkPSUbuoqmnxEDjitdjGQ8E0fyBWg7S
         vIMnyb13j9IWLnir3fCC0H5eyeUrx7TsfBuj3rtTNzqV/4AB+4lKipsJd1qH4+WmbpRg
         /ZwmlzPVD46X1ClxBABBJMibeN0Xd2bII5REyaEKlEFIrvUGeUDkuiH7+CEXWNeTZUsC
         8G3+XtGuxYzb/yt9bBwt0dLGyR5mbmr7pbdrZJK4YkThYNN6z1olkcKPQ6pd/rshCVPn
         xSjSAmLhjOAzafTQp2auD0W3MZmhfKOuuu3yEObCetlHUEtlLhCgk0U54cC44Xzvyp2c
         TTcg==
X-Gm-Message-State: AO0yUKXQvvO8BaOakbgRJO8FrN6NOK9yd8s0N7M0Q7JycO4xMKuUVpSM
        ggCEczgUY+ohhCUdvACf7Gw=
X-Google-Smtp-Source: AK7set8iGk/H0LMTn6r/zDTe89x8jUR+c67UFN52D3vq7WBa5IZUV4nCdaRqTLURFOcAK9Zu5hyq4w==
X-Received: by 2002:a92:7f01:0:b0:314:1b08:c19f with SMTP id a1-20020a927f01000000b003141b08c19fmr4493772ild.1.1678890208544;
        Wed, 15 Mar 2023 07:23:28 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k2-20020a056e02134200b0030ef8f16056sm1634436ilr.72.2023.03.15.07.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 07:23:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <233afd55-6198-15e5-f6aa-b462ef399cff@roeck-us.net>
Date:   Wed, 15 Mar 2023 07:23:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 000/104] 5.10.175-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115731.942692602@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/15/23 05:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 

Building arc:tb10x_defconfig ... failed
Building arcv2:allnoconfig ... failed
Building c6x:dsk6455_defconfig ... failed
Building h8300:allnoconfig ... failed
Building hexagon:allnoconfig ... failed
Building i386:allnoconfig ... failed
Building i386:tinyconfig ... failed

... and many more.

--------------
Error log:
In file included from kernel/sched/core.c:13:
kernel/sched/sched.h: In function 'cpu_in_capacity_inversion':
kernel/sched/sched.h:2560:27: error: 'struct rq' has no member named 'cpu_capacity_inverted'
  2560 |         return cpu_rq(cpu)->cpu_capacity_inverted;
       |                           ^~
In file included from kernel/sched/loadavg.c:9:
kernel/sched/sched.h: In function 'cpu_in_capacity_inversion':
kernel/sched/sched.h:2560:27: error: 'struct rq' has no member named 'cpu_capacity_inverted'
  2560 |         return cpu_rq(cpu)->cpu_capacity_inverted;

Guenter

