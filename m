Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47FF636670
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 18:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236405AbiKWRC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 12:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236541AbiKWRCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 12:02:48 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC8B2DAA0;
        Wed, 23 Nov 2022 09:02:46 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id a7-20020a056830008700b0066c82848060so11587221oto.4;
        Wed, 23 Nov 2022 09:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UkcutNoQNHT0SEKewV5b+U7+CaUSl/CCAj0E129sAe4=;
        b=Pw9aCddYqFM/i+lfl68OL5qgY5DG1TjgLucwc+QHIo2LNS0wRAclUjR/Tui7Ak1zSD
         LuT3ArRzw1jBikSh+PB3tHqeXRhtmZDbic96Eg2ce/mVTCMpNSJXz4XNUODUkv8qLa3O
         4sA2yxSzRequCqVTknSONwrpRUrC36NP887L63/QHZD0RMdWogP9L1Py2SBDex5KkyuV
         C5Ey2tAbWX8ziNmHzVVx9a7Gh0DBvft9GEdB0luK07Dd827TtLi3X7g58e5omVLbOAUk
         HxYF4+YElrBrluC984WBm1JCnn3Xifdbl8FQkvxVXfBnZ/09COpE4gXyH9jyAWaS3Fh6
         JrzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UkcutNoQNHT0SEKewV5b+U7+CaUSl/CCAj0E129sAe4=;
        b=NGV8PwKJKcWq7UpphnxWCZ1jgBGTO5c9YWYsTHAY7ouqQjybbUnhNlJgG8UioBzKkL
         OsmAtEYYFNw0fDfyvbXuSJkAYHyvIrnH9Q9h7XTCSljSJ/hz4Dyp0E3LQ+ybmw5uG+ry
         bJbMBrzBTxvaSIbLs1veT9tNyz2CP/gSiXNaVGlR8heFwmuLrEmSB5O06ZA3Cp4QuumO
         WLBhkp58a2VqpgB+5A18gdwU4ba3GNrFrvDNFTr157hwEKdBp5QjozgYRRC815PJhqoC
         qHbmjx8S0kDi/P8JQm5yNy5c7gK4wHAlZR/HX3L1HrR3VF7f7Cb2IMoojhPcpzyGw9za
         1ucw==
X-Gm-Message-State: ANoB5pm69jHbylgFejwW1oMzrmEa02djhEY+oOhd4eCDW52afibsNpgU
        n/zNCJWEFHYsYPWuRfHVvoxqn7yFeK4=
X-Google-Smtp-Source: AA0mqf4BOTNx3936uKcCuJ/1h8jvtibalq4JjNNo65ZNWJwuzlEAhKRnqAxJewVZMGsiSgw0LlS/sQ==
X-Received: by 2002:a9d:628b:0:b0:66c:6afa:5006 with SMTP id x11-20020a9d628b000000b0066c6afa5006mr8430705otk.233.1669222965494;
        Wed, 23 Nov 2022 09:02:45 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w11-20020a056870e2cb00b001428eb454e9sm8168566oad.13.2022.11.23.09.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 09:02:44 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 23 Nov 2022 09:02:43 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/181] 5.15.80-rc1 review
Message-ID: <20221123170243.GA3745358@roeck-us.net>
References: <20221123084602.707860461@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 09:49:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build reference: v5.15.79-182-g1ac88d934860
Compiler version: arm-linux-gnueabi-gcc (GCC) 11.3.0
Assembler version: GNU assembler (GNU Binutils) 2.39

Building arm:allmodconfig ... failed
--------------
Error log:
drivers/rtc/rtc-cmos.c:1299:13: error: 'rtc_wake_setup' defined but not used [-Werror=unused-function]
 1299 | static void rtc_wake_setup(struct device *dev)

Oddly enough caused by "rtc: cmos: fix build on non-ACPI platforms".

Guenter
