Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A473E4BF7B5
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 13:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiBVMDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 07:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbiBVMCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 07:02:54 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AEAC4285;
        Tue, 22 Feb 2022 04:02:18 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id s1so6329821wrg.10;
        Tue, 22 Feb 2022 04:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7Ma767k6yFjdv66g1RH0CGPLu21p2K/cFI7MlrWcs2M=;
        b=ebHsoxV3ArbQY0ATVHz77e/kPsCMZkuHnCu0fiavYh+URIW73pJg26+1+AI32ingcK
         Ck5YScqU5sAKEo6ClLpIjoa9NFSy85niH+dmzEnVgiLvvgm7k+BEF0bfkjqlrQc60u7W
         X39jQD5jhOzD/zZrfT1KzyEbtFkK+by+0RhLo6XBqM0rvPE9k+dMyr8N9DXAAGaM6WED
         nLc+S2cSv0dUP2smkU+TW3NIcQJ+s2JBG5HLRs9mcddnp+lt6i2Hausk7iwvXgsOww32
         Eo4DDAhovuw+phqxNtFpBWwPlRRtlNHOLbKbEwoYSciV/FrdpUu6YO1ne74lYk3xt6Ii
         9tKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7Ma767k6yFjdv66g1RH0CGPLu21p2K/cFI7MlrWcs2M=;
        b=62nlvDIJ/tfFN5JN3THAtblHynSYiP27jWxUPAW8GmSlt4HMPOhqwYIw7F8vU98lll
         j7Xx++8I/gksJ5WLkFzKbRwHuxB8+xjVCi6hHNX/aGu0oXOgaVfDRp1jiYXO+5gYBVza
         d6K8Ei9Q1rUzgEJEplfwyWUJit2L/eFQeY4dJOapPx9bPUDynwaO1tjKQTgs4ShEeM8g
         aNGaCwg+qmqkLJ2ylPsq7JqsQolrq516bUmPuxBUdCmVcXSjDXeU7BdM9DikW/7z9gdR
         L+xa4FFZdHhRHJxg93u9u57yUqCf5XFfvzr7dpF86s9WJ0DnB1UptW9P5NtAs8G78ybY
         o77Q==
X-Gm-Message-State: AOAM531cfcDUIbSOkTdwtT/hgSGS1O73iaFXu6tWDNXnHs8/3kMD9w+l
        1Ovtz4RpTMRoTXV+GiWkRV4=
X-Google-Smtp-Source: ABdhPJxblAov7xcTUdcgoT35FDwWaM9w2tZK2LhfCGOybarTNw0tUmlkp+ypGTDrug7qjOFVw5VhHw==
X-Received: by 2002:adf:816c:0:b0:1e6:88a9:eb6c with SMTP id 99-20020adf816c000000b001e688a9eb6cmr19107225wrm.645.1645531337208;
        Tue, 22 Feb 2022 04:02:17 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id k4-20020a05600c0b4400b0034a0cb4332csm2150053wmr.10.2022.02.22.04.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 04:02:16 -0800 (PST)
Date:   Tue, 22 Feb 2022 12:02:14 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/58] 4.19.231-rc1 review
Message-ID: <YhTQxvoKZn80/KDB@debian>
References: <20220221084911.895146879@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
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

On Mon, Feb 21, 2022 at 09:48:53AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.231 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220213): 63 configs -> no failure
arm (gcc version 11.2.1 20220213): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220213): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220213): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/791


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

