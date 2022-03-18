Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29FD4DDEEB
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239090AbiCRQ35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239295AbiCRQ2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:28:19 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2111E8EB45;
        Fri, 18 Mar 2022 09:27:00 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id q20so5138075wmq.1;
        Fri, 18 Mar 2022 09:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bE1h98kHg/vd9+ySU9xBpk1/akQmX3fkJjCvR5e1UFo=;
        b=hy6lTPQIMROkI7AC71s/JdvifauaVii3kjTQSK3CACbW+Znm42bLTWF2PmDxbHqiYm
         pOy3YeWxSgNC+VnRyMpeivw4L4ZhlfD4hybXkRmFbKfuHmzt8gh2Iq+HmlA2bYo0zIuP
         Batd9aytoEpIVY2XRev4uRIGhYf5QwLQQIADqVxin5cBha6RpcZojxZ7QNHOkoJmOO7W
         7oMV6i9ZGbdYmp4qTd29EX60pgGHopH9iR2IbwwyYbnt4i1KCTqSm3p11jq4ayKuwdVO
         5OBgSWBf1wTM4ZmUO7zC4R0e9ea6oBLGkxS5QNqeHuY4CYWsN1Vm8VW1KDIY5qtVKHRc
         I4OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bE1h98kHg/vd9+ySU9xBpk1/akQmX3fkJjCvR5e1UFo=;
        b=4Dk51458T3X58B5oVKebHAPKTg0foYnZ1qlz2SQXZaaOYSHtN0UauFiTHZi8xuY8KB
         qlzEQ7Ydy8KIwNAqMmB7JAWprgaEjjnIrdpdurSzrlDhTHwD8rOMESbTgDw2CvXJPv6b
         e32uIJrptsj2/spuSIOHpyHW+s7WDKvM5RxWk1Cj5armCYBRfBHXy/+LQcbFVcG0VeDw
         Sw3TDpaHOoToDmjo3Pmg2Xk89Ot7nZDONTIDzwryGVghN7iQH0XLrG3LzA+8mBNrAAwa
         1HRmlgN1f5c0bfZRaDLcGYCEzZyJxCdlrzp61wzyN3s4HEf3MXZmz+lGVECKpXqh9vIi
         JjqA==
X-Gm-Message-State: AOAM531Ccl4ekbJnnphE+R+oYC+W/Swk6JXFlNI1aBGNvXvUfuG4/kci
        mEubCMr3Zhpcng1azpkppG8=
X-Google-Smtp-Source: ABdhPJxcHQXFITXUohtVzboQWy1beygU8s+a6fSMmy3ce5G+kY8pFubSZ68W9GwXxJpYfWLZgsfsoA==
X-Received: by 2002:a7b:c8c5:0:b0:389:d4f1:7cb with SMTP id f5-20020a7bc8c5000000b00389d4f107cbmr11847782wml.3.1647620818607;
        Fri, 18 Mar 2022 09:26:58 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id n18-20020a5d6612000000b00203fbd39059sm737811wru.42.2022.03.18.09.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:26:57 -0700 (PDT)
Date:   Fri, 18 Mar 2022 16:26:55 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/25] 5.15.30-rc1 review
Message-ID: <YjSyz74SX8yCrNne@debian>
References: <20220317124526.308079100@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317124526.308079100@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Mar 17, 2022 at 01:45:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.30 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220301): 62 configs -> no new failure
arm (gcc version 11.2.1 20220301): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220301): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220301): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/904
[2]. https://openqa.qa.codethink.co.uk/tests/909
[3]. https://openqa.qa.codethink.co.uk/tests/910

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

