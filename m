Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405B458ED5B
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 15:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbiHJNc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 09:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbiHJNcJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 09:32:09 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1DC4C617;
        Wed, 10 Aug 2022 06:32:08 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d16so14220537pll.11;
        Wed, 10 Aug 2022 06:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=sW5rzq0xvdGFJpAn8n4rhavThH6cS/CU8oqIrEjP9vA=;
        b=E6WGGlBSIlkaRO6pG0cXlE7uqfAXKKujs72MJh0C0sygaEbJpd1rCsv5StTh7/8l8B
         l2ZTAdPucuHNeRhREOtYDavIW5I2oSrlE663sFy1qWd5AopNVjGIW6zTKiQg27IYrFmm
         Qf34Q8xJDKS7N//8j+5cYtNd0co9ZK/2J+kbFuH6uWvj978s9tMndbEicsAC7qGmXrtV
         ysKHZ5lTJ0TvNGDJ0xAAiL/AoDGVeS1coXfnhLF2Ejy7d24mwwcPBN6XuSPpoTtMKFeC
         N3CPvPcUOV84wGSKArdttrEATot1CGDDTN1+WXJok8VgJMIpN/BJavbnkjf0ouziLqTA
         CPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=sW5rzq0xvdGFJpAn8n4rhavThH6cS/CU8oqIrEjP9vA=;
        b=HSU2ZOhbjB0VtTWyjlfL/e6Dnc2JFhKqP2WZbfk85g5NAeXJGhMBzjnP5At0qZsRuv
         /NOeFAF810rCBFCk+5CHo/NFWZaHxjhSYqHJ5CTxGycu0vtjBi17tdjB68i9YfZKMbwx
         UcALCH3VFVkTLgtY0oZPNWIWzRbVLHkpN5AQnDrO2lBvlkkfa3qEVxZiMijc9AcTjNno
         yWkO6E54QrkONgP/PQbjrLse/C0IDU85aCGuyUHGsV52uFimh9YUQHk99zoseeVJeXC3
         1s0fW4SZNNvXFgtidW4IKYavQ4SDYdmYJLp3eSvWb71xZ9NIo2JAnZXTVd1AScrmAull
         q1wQ==
X-Gm-Message-State: ACgBeo0NLoz0mG+Vb6hzceS0xHXA6z2/NCbDb+ALsQIc/Sk7Yobvx2Zs
        z2fG3SaVW3rZr+fAHkKqT2I=
X-Google-Smtp-Source: AA6agR6YMtHjE9lQTZJAeL2xno/R64oj5TCojj9x5iU28qKCfQFEvhDQhrIgz+2LkRVs17297dzW4A==
X-Received: by 2002:a17:90b:4b47:b0:1f7:2e06:5752 with SMTP id mi7-20020a17090b4b4700b001f72e065752mr3790174pjb.187.1660138328403;
        Wed, 10 Aug 2022 06:32:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 22-20020a17090a0f1600b001f239783e3dsm1574427pjy.34.2022.08.10.06.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 06:32:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 10 Aug 2022 06:32:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/23] 5.10.136-rc1 review
Message-ID: <20220810133206.GE274220@roeck-us.net>
References: <20220809175512.853274191@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809175512.853274191@linuxfoundation.org>
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

On Tue, Aug 09, 2022 at 08:00:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.136 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
