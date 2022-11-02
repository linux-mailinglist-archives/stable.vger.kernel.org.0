Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D61A6161B6
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 12:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiKBLZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 07:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKBLZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 07:25:17 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE526248D9
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 04:25:14 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 130so16141797pfu.8
        for <stable@vger.kernel.org>; Wed, 02 Nov 2022 04:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tyecaq/gN+qBEfIyj0l1+MIZmCqNuoZxcsqFQnGuP3E=;
        b=AwEB63N3WrXRyhF2CPiGYeaTfqhycU8Ov/kFpAUKHKJ6nlf8jfcmtxqTps0tTQKhrx
         wPBd548bkip0o0OeQgXPt40CfzF2ta/RJxncB29ivp5bd4RXsZQW6QQhFEEYW74mFAkz
         NNS9QCJLoUCEPikTa8bEBRAMtOszT8oFuHMKE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tyecaq/gN+qBEfIyj0l1+MIZmCqNuoZxcsqFQnGuP3E=;
        b=nIOVxWRaThA6S36TJdkRsUB4FpFrKnQnYeJBoTJwLSH4lOHnQvl++Pum/uERRF5tPi
         qb4i6l09CihAtN7djz84JtnZ/IKQixgFF18LQQdeoY958V0aBcysaBIyUcQaugKBMXPi
         hze9r1RkyFNosrkA+4j6YnUWylzdVBAYlHrETXkpmpQAtVCaQW3UFaKpHy1V+JiA+tTH
         1dcUZ5QkBeZ7HmzsX4oGSljimc5R2rVCaE/+aNZpHqa1aYoCOBjiPjebIqoMhtUqsv80
         bBVbtsO9GbSmQbKylbRQRdPuj5FJnG49C1hnh76j18ykscA2R0uh21qtV588gbv7KfM6
         OpDQ==
X-Gm-Message-State: ACrzQf2SAugRi4hvk5wNYf+iX8SC78x+TN9IYyXEKjw0/e9Ckrhshbi8
        /+Ia0m85CZSoZK+YScItcbczTg==
X-Google-Smtp-Source: AMsMyM7j3EzDQ8PvsNYxU5vH9j9hXlsXsRx4PEH6xdQBdsM/nwMQbNzO3gaLU5ujJxJNI9w9RwacPQ==
X-Received: by 2002:a63:ce54:0:b0:46a:e2a9:c7f6 with SMTP id r20-20020a63ce54000000b0046ae2a9c7f6mr21073216pgi.264.1667388314312;
        Wed, 02 Nov 2022 04:25:14 -0700 (PDT)
Received: from 77b1786dd767 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id u4-20020a17090341c400b00187033cac81sm5067558ple.145.2022.11.02.04.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 04:25:13 -0700 (PDT)
Date:   Wed, 2 Nov 2022 11:25:05 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/91] 5.10.153-rc1 review
Message-ID: <20221102112505.GA934867@77b1786dd767>
References: <20221102022055.039689234@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 02, 2022 at 03:32:43AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.153 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.153-rc1 tested.

Run tested on:
- Intel Skylake x86_64 (nuc6 i5-6260U)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
