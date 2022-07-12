Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750BE570F48
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 03:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiGLBM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 21:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbiGLBMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 21:12:23 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642F852459;
        Mon, 11 Jul 2022 18:12:19 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id j12so5908275plj.8;
        Mon, 11 Jul 2022 18:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jaQ+NRTvjwMHBHo6BdJFEv2ThphryJBQDysA1mMnhmw=;
        b=D19XcBUDmaJVfJhdg+43kZpPKcGdkVf7EZvaSphv/HfRLHzKK1qNRn9++nH2dyzxxF
         MkEVcZt2QXO8dME340svOc0cNArBV1PAwNQ2RFcMxRp9tP++FJUYLwVxsUE3G6/WpAy0
         l4z/JIZyrl/nWUMqJXTeHChLVsFDAtYO9J9vlkDsu0/oh/9qA7bd55y93v3wNDJvkZWi
         aJYkp32RT8EVWJET1TQ/BOmlQIr31uvqWTeY3yvtFGVEFvZQLDDaanE8ZirPUW5zI1/m
         frq8M6Qa1p5eNKKl5X8E+zSW8Wx7+jfcpTJc6Fhp5XwZjJ822Lt6ATvRaMax9XvPnzhB
         aIwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jaQ+NRTvjwMHBHo6BdJFEv2ThphryJBQDysA1mMnhmw=;
        b=rFdCxS1wzS8dhTb6JaucKUlwzHykQRvzy6dECzJhhKEaUBum49HDBTEQXSY/8fvlGp
         aL2ILTais19mDdC3uHHF9Ac7H0zvHJbZHG2R1a4m00qCyqOJ0G0yUJXaGmJxyGCrY7VT
         9ffoiixxMxFj6okVwo7VwEksjG8ovjfGpimJ2yLdIUEU/HkrbYQT7us4fd9x8Xh3kJTQ
         DxNxfjoLAbw1opJb748bJw1w56cLp+CTocOuLQY6+j07dw6/Acevxt0AdV0unmm2Yog8
         5SaB7CXzYykmxxDDW6/+0oV0Dc5hw+9FXa7GGlW7VjLgK4HecDxEsQDbfOL6Q+dWZ3Ip
         E6zQ==
X-Gm-Message-State: AJIora/neX3eTqnQAMwZvyhqFURoWKl6n8G8ykEPPE1/ABQePg0GLXs4
        KiGKqyk6Ui/6/4T6aLln5rY=
X-Google-Smtp-Source: AGRyM1tcvtl9VBECNZKqOLsNKqnu9YeHb8fLl4zjz/p7/gztCF38kWgJskpzWJb+iGl4kFCxyVRyuw==
X-Received: by 2002:a17:902:e885:b0:16c:4a26:3895 with SMTP id w5-20020a170902e88500b0016c4a263895mr8334277plg.131.1657588338899;
        Mon, 11 Jul 2022 18:12:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z15-20020a170903018f00b0016c066e566bsm5401806plg.164.2022.07.11.18.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 18:12:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Jul 2022 18:12:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/38] 5.4.205-rc1 review
Message-ID: <20220712011217.GD2305683@roeck-us.net>
References: <20220711090538.722676354@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
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

On Mon, Jul 11, 2022 at 11:06:42AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.205 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
