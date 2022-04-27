Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680C15115C7
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 13:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiD0LOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 07:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiD0LOb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 07:14:31 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B31A140C5;
        Wed, 27 Apr 2022 04:11:18 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id t6so1995875wra.4;
        Wed, 27 Apr 2022 04:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1g4WCJ0Q/BrceckKVbgJk9nyZ51QUQwb7Bu5pYpxn2E=;
        b=OmOv1AZOfAcWEPZw9DschLee0Np1zgEtU2For0uxqycnxc2nMnsQx8zxrIuWWsNcrc
         LjpwPwnXOQcouPVYYOC3hPZf2B3gGrNQZ8Wx7IZGAuTdIY1xkLablk5i8z/wlNqb87e4
         Qxc2Rn41WYSuh7J/1fPExQo/rzNIxu0ZTdGMFxc5zycpcAPocbCtb3VvlfNC4r11lH4r
         OvYzbC46oivOaMVAMR9jslyQXgvJjIQRg/iZIcCGQpKYNXNPKiC8sZMAqET6nubijb+Y
         TS6BwA8HwyyTFbObIgRb7VVMj/wFyCBb0YYYU5B1/U6T4OIrXWS8oNe+tMK5eS5WCgdS
         p0kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1g4WCJ0Q/BrceckKVbgJk9nyZ51QUQwb7Bu5pYpxn2E=;
        b=RKNBkQezxTKZkAYrtokTFWp+4rg4Y7zu7GGJaIta2fCo6ZfVDwmuE01OyJsP7YSpal
         yvJj96im3Gc9iWWTl9h/Bf4XxWFnSWPMlZd32kPdGP7DvJQIEoPZXVmL4Spp2b4NF+PM
         ohmOIvqohb/0l9ukSmPSiKOJGfwFJegq5T6rMHwAeEXlaCOaTv6HcczbC/L3W/q7hIMW
         /IKL3fdhPZ6pDeyjFf1YK+LfQOazWwd1XxSJKs2Wu3lDh5NAfweevlWTud74J8W959Rs
         ys/MkCNmSrbuu/jGhlXxcg25eEUSNdUAcbJ7DeV7vd8U1EWhP01mE3btruze4F3QoXIM
         sZYg==
X-Gm-Message-State: AOAM532Wjh4WiMRryidke6hUlip0J/rBxuWRWQ/Yy6BOXJ1GMKQeIuJ4
        Nc5w3kfBXX4sMTyi8cC5X34=
X-Google-Smtp-Source: ABdhPJz8kqbFUIEX2JTc5yimcFIgQVg9voBFMB1zFMSOU3e2w0OK/44LVd7q0Pq1G9BI0xKaWkE4hg==
X-Received: by 2002:a05:6000:1369:b0:20a:c68b:7275 with SMTP id q9-20020a056000136900b0020ac68b7275mr22505324wrz.158.1651057877020;
        Wed, 27 Apr 2022 04:11:17 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id k65-20020a1ca144000000b003929a64ab63sm1358095wme.38.2022.04.27.04.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 04:11:16 -0700 (PDT)
Date:   Wed, 27 Apr 2022 12:11:14 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/124] 5.15.36-rc1 review
Message-ID: <Ymkk0jqtprJT95ZY@debian>
References: <20220426081747.286685339@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Apr 26, 2022 at 10:20:01AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.36 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220408): 62 configs -> no failure
arm (gcc version 11.2.1 20220408): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220408): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220408): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1068
[2]. https://openqa.qa.codethink.co.uk/tests/1073
[3]. https://openqa.qa.codethink.co.uk/tests/1075

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

