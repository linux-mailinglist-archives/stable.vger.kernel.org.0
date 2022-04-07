Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73FDE4F7944
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 10:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbiDGISO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 04:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242894AbiDGIRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 04:17:46 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBEA1F6F18;
        Thu,  7 Apr 2022 01:15:45 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso5169957wma.0;
        Thu, 07 Apr 2022 01:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bcoyl5XqH4z8VxEBlzhREhx7GTTi/uuEf6fqQshLbzc=;
        b=Hk5gGqsSqmpmPZcZnWkQOh9oO6hu2wcpXcwovEsgXZwDb82nY8qk6fFWJBSDq0GaNN
         DGchLxemD7txMyXneLe6h1sidBi1GfxeiVTx/mqY6Xyi3uzDbTjN5cHDV8VYRPt5Ug0T
         OGdO35WzrkDMO/NTVT0Bw5Jlb+gK4dJwaTclpBSObhAX9zx1gH+BtmWZJK9n61mehS2o
         JTDRqopulY6j4ay17GVFwxZk5jbkHzqosPrPI8hc5P35E7ANBQkUb7q3aAEoSEkmGGwg
         KnjPQeCNP6xLIcAbBmdrdhnuAj19j+FdHA9B78+CeDQmxLCR5OUN38R0aV0GIVBM341k
         lYmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bcoyl5XqH4z8VxEBlzhREhx7GTTi/uuEf6fqQshLbzc=;
        b=dEbLd7Mp0dZHL/MVSiAkjN+vYxViF6aP9aPAGYmRDs/MOKnXEvbyJTCS4+7vUaESen
         vcCWY//THIHYenlHpJ6G3Fl+32TYkOYxyJ57B2zpkAttXp2p+ZNaxqFpZtigfAHFUYXU
         m/gwE8Nh2Qn8jIBLw2d0wiH8v6brEB27CapwTiqlSQVvEO4ajMMXtwdXSa5D3WfhEG1e
         qOUehoQF7B5POHbHoQa5yLZXZjqV7lTmICevGpVYwj6xQ7L0vUR5v2CHWtvsfNezdAPE
         yJHl45r4O7evIV56WKRl3rs2i8Dwfv8PVhI4UYGUMbJqUS16D5imTz0OvYGgkTd5ISwq
         cOxA==
X-Gm-Message-State: AOAM531gntyBPqzE1SuzWZRxcwCIUNwb0IJMvaryOJW3ObQNE1CRefKe
        UezdaucAR2L6VYMCzk91mEg=
X-Google-Smtp-Source: ABdhPJylYovmzCq6x6w+MzkdxGMUvL5fin5v6H8TP/wYw3cAyAK1+NlDwsaRKtMRYWBWX93hCNAsCw==
X-Received: by 2002:a1c:f312:0:b0:387:8bf:bd3 with SMTP id q18-20020a1cf312000000b0038708bf0bd3mr11169302wmq.112.1649319344101;
        Thu, 07 Apr 2022 01:15:44 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id g16-20020a05600c4ed000b0038ceb0b21b4sm8557631wmq.24.2022.04.07.01.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 01:15:43 -0700 (PDT)
Date:   Thu, 7 Apr 2022 09:15:41 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc2 review
Message-ID: <Yk6drSoASaEkzopi@debian>
References: <20220406133013.264188813@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406133013.264188813@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Apr 06, 2022 at 03:43:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 597 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220314): 63 configs -> no failure
arm (gcc version 11.2.1 20220314): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220314): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220314): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/988
[2]. https://openqa.qa.codethink.co.uk/tests/990


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

