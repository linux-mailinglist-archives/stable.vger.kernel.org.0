Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74DA6C3E52
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 00:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjCUXMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 19:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjCUXMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 19:12:36 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA5658C3D;
        Tue, 21 Mar 2023 16:12:35 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id r4so8997702ilt.8;
        Tue, 21 Mar 2023 16:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679440355;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aT9QAWb2N3Cl9PNqz1T8q5HyOZdF/U6pbqVGEeaogMU=;
        b=XMHbfGp6KgnR9xCfDh7D6f+AWv+93I0dCBfDAjqyD07JFT/Uq0rGSkr/r8SVucF+Sm
         1FgvkU5K3mClxt11T1aWICszr0+7QB1QOTLfbzqAmkDo/jFWT/zVHPhhrV6rqYUArQHo
         bjcEk7oD9yv0oHomC/4QqrtZPJkyUQchZPouNGA5TdozkXUotM23WETNNegWCPUnCENN
         7Mdrk/YoD7iwDesU7O1KhBBGfqUOvNQZiqZqYSsSKdoUBN2knAUh54fS1gP3Gf6mzxV5
         BRmTEH2WEu+13l0FZsDlOeFlBKJY/u4gFuAYtW8Ba/gAO0G4XU8Eu/mPB5D0XtCggu/h
         QJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679440355;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aT9QAWb2N3Cl9PNqz1T8q5HyOZdF/U6pbqVGEeaogMU=;
        b=6oiUrwyMAfpguh7kILDnALTqMzHbZz3xgpbBMKBlx8fd+hiSmLd+zFZKDtwr1S4PxV
         D5WLrAnPo8wSES3UV5OyIH7xqSGxmITjrF7wn+aJwEh76UauNqRoObNP7yT46BgMdDtU
         tMZTyGircUGHK5q5KcOnBA/t+RmvRgs5VYUnCaEPy9rQiH4gtpGJ+zvB31N2r5UmSqEE
         vrN5aslg3qm4l372v3wy8kaG3erjfkrg3FcE4WGzu+QCAlVNV2ywmIl08ePSisJ9+Ges
         +mkcY9xB2xmGyvyPRk8PbEXbNkj+6TsaqeLhKN0gE6KyV5UdTgjFvGQoxu4W1MaaEO2d
         3+hA==
X-Gm-Message-State: AO0yUKUdRi8Aly1zkMlKCQtYxA6yhRG3PT5YVhVCkljUctkt/BBv2FwL
        fU+CQoynD9CMOKJ2EWCuffdVT1lZGtg=
X-Google-Smtp-Source: AK7set/CUPlNqLHXRRkRwnqohqfZBGWTyduS3uxVJc2LJwQu2wPQ4A7pf+D7otm254JsLCRgq3/4LA==
X-Received: by 2002:a92:d78f:0:b0:325:b9ac:9451 with SMTP id d15-20020a92d78f000000b00325b9ac9451mr707349iln.28.1679440354694;
        Tue, 21 Mar 2023 16:12:34 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s7-20020a056638218700b0039e5786d7b7sm2810138jaj.18.2023.03.21.16.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 16:12:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Mar 2023 16:12:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/30] 4.14.311-rc1 review
Message-ID: <ec3c43eb-ff2c-40b8-8078-53cd28362e0f@roeck-us.net>
References: <20230320145420.204894191@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320145420.204894191@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 03:54:24PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.311 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
