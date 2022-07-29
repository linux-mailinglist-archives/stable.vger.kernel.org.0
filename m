Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C9658502D
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 14:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbiG2Ms4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 08:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbiG2Msz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 08:48:55 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B56B1EC7A
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 05:48:53 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t2so4532993ply.2
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 05:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=criCOKgOnbclJXExnk9/rAhCES9E1xQAICosEXkQlgk=;
        b=AQOxqn3WfdKYhTN8dl8NN48KQjmRar0UCBn836N9CcR6adLEz/6+3O6fI4gbWmhsqW
         EuAyUM51WDYGxzlO0Akx7R5HR+AZ03sw3dZafUPlcsDKb74hgx4fuWkTmVLebYqmujm2
         deFbKJ6BXLARK4361iqtK8sRCm62YhJWLsg7U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=criCOKgOnbclJXExnk9/rAhCES9E1xQAICosEXkQlgk=;
        b=azrKV0QjfgMxZ8Kc8d225NsA0Vm7yh4wtxwLldVTppPcZq5deq02CxssACsfHhful/
         BZUDLSWbBOXyNBq6B7ClYt8QaC2xb5b5bKiq2K9iikoRjSD48XoLrYyTP9bjxhoaR98x
         lu48v17XuGSotw7CrD5yObNwZo7WOTZ849FcmNSe20XHDVfRsD1WntVFA4OCjfKOfuQY
         9gOejC4uOBvBbD17nOYwo97LbOvMvfv/iIq2XFeW0FQVRcCB54WyJyfdDxH7ZRBATJTl
         7x7lXOokxjwyRE/lZo+gLHUpw+XGBCzdZNBP8qUh348H3KjHF+7vNDPUJ7VQHoZH0CiF
         Gj/A==
X-Gm-Message-State: ACgBeo213T4CwG6a6Urxbs2nBj83ZjDrt0LuHptNyNRe0ohspEbMP8Yw
        n1CC3+AH3dtkV9VP2ruONMQ9ew==
X-Google-Smtp-Source: AA6agR7QSTf8+Vd4t20cIiSvl/n3kRoho/P0qEsdhCOoydFapA1heQVAFkcmkOy9SEjIOVFkMz23aA==
X-Received: by 2002:a17:90b:393:b0:1f2:4f10:d74c with SMTP id ga19-20020a17090b039300b001f24f10d74cmr4701091pjb.102.1659098932638;
        Fri, 29 Jul 2022 05:48:52 -0700 (PDT)
Received: from d2b5364403c2 ([203.220.223.63])
        by smtp.gmail.com with ESMTPSA id jz21-20020a17090b14d500b001f1ef42fd7bsm5844772pjb.36.2022.07.29.05.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 05:48:51 -0700 (PDT)
Date:   Fri, 29 Jul 2022 12:48:44 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/101] 5.10.134-rc2 review
Message-ID: <20220729124844.GA8@d2b5364403c2>
References: <20220728150340.045826831@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728150340.045826831@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 28, 2022 at 05:05:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.134 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 30 Jul 2022 15:03:14 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.134-rc2 tested.

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
