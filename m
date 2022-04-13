Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7A54FF5D0
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 13:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbiDMLkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 07:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235136AbiDMLkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 07:40:35 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8D15B3E6
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 04:38:14 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id q189so1723296oia.9
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 04:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3/ju3WN6s0uhv8pmBaiBX2cd1/4pEd72BZojvQ2bhxo=;
        b=IqJzaL1rSE3nVx8k1MPaHHdFZQgkrRusk5DDwk3Eyw9Rno8e7Bnkqg6a0rgKccisMw
         QtDxGMAhrjHgE8Owjx7Tp3v7TSK4W1dgFADnYVV3uzQKVvgxdT4NNgwikpv8r4iUDFhQ
         o4HY8E3dMbF5uvS/fdKxc3xCvwBAvg60F6F8g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=3/ju3WN6s0uhv8pmBaiBX2cd1/4pEd72BZojvQ2bhxo=;
        b=vKVM+4//ahXa4KGWNgHLxMp0BSxRWAkFyE+lG4Dp8EfYQP1ktV6b1wDXNTy69SVvI+
         Y4FpZtSc7VeTNaOm6ocLor/416ayL9ougPPPyzDPqRHeOfLbE2r9eNb7UNgSgnBQuH/A
         psVPvyte9dlqOhbdlQ3CRJkL94kAFOt1I0fUno/UC6hkGEYbakKVa63ZDseNxpJLItr9
         5/ZWKZchlN6rkUK3rt9VN7gNaYOBUcbitbxutj4h6v4HqXxbISL1G4bv5YrQ7urZ55W4
         yDNlNDjEjA8YFD0s2oI4bPftGGFnNfZvdyFR/Q3YvHnroNCDHMW/1Am2+cSnsVvXE9LJ
         WWtA==
X-Gm-Message-State: AOAM531v3i50vxJSkBci0cb5Nl0tZCGAiGa8K6Js5tuB0+H0rN1pfMxt
        8EgXmSJrWNlK3m7iE5CAItOFaw==
X-Google-Smtp-Source: ABdhPJxg7ZozcS4h5lTD+fGFNdGzLi4q/n3Iqf7FwV66pRGzMC9VqSznelQxCjaQR8W79O+09OZ9BQ==
X-Received: by 2002:aca:1006:0:b0:2fa:543f:845c with SMTP id 6-20020aca1006000000b002fa543f845cmr2972147oiq.182.1649849893881;
        Wed, 13 Apr 2022 04:38:13 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id q13-20020a4ab3cd000000b0032830efe365sm13453317ooo.43.2022.04.13.04.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 04:38:13 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 13 Apr 2022 06:38:11 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/285] 5.16.20-rc1 review
Message-ID: <Yla2Iy4yS/pC5F7/@fedora64.linuxtx.org>
References: <20220412062943.670770901@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 12, 2022 at 08:27:37AM +0200, Greg Kroah-Hartman wrote:
> ----------------------
> Note, this will be the LAST 5.16.y kernel to be released.  Please move
> to the 5.17.y tree at this time.
> ----------------------
> 
> This is the start of the stable review cycle for the 5.16.20 release.
> There are 285 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
