Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3776D7F6C
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 16:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238569AbjDEO1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 10:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238585AbjDEO1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 10:27:41 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C0765AD
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 07:27:14 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so39688929pjp.1
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 07:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1680704833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n5Q02pfG+OMk1kh4JZ7k9vPqYbgDWeWrEDJEsiquIG4=;
        b=OKG4h15dRFM8loga0ZloBGZgnF3LHC7oXhkOBfSthdmOI1EvekxAnPab3OhpRM4ip7
         oYkUFKrGyJ9t91H2ZZgyogELlpEPRaxyzj4dgYhEHQtku9+aw/+4mGBSuyILq75Helph
         jIBLEzMI4bl5eJG5iSZmAim2Il85wh5bnxi8Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680704833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n5Q02pfG+OMk1kh4JZ7k9vPqYbgDWeWrEDJEsiquIG4=;
        b=yO7R7BJMLeQfRJFUP3miLNbOM1udBaPPh9qpWrbZIgL+3ul08povtrBTacQYcyqy1V
         Erz8RGYhAg8A/0Hi4mQPYnPQDNZfc+3G2x7o79HtfCPXTTCPAHTHjCdDYdgB19ibk82Q
         j1oqRhXhaOYPYbz5BtxWtM/i04AKXPmap+vYeomb0VImbp909x056Fi/mMp/UQelyU2A
         rsxJNlHbh6VR25tUIOTVTzx4F0tF+bb2/jZanTJWKc4VWiT3z3LiPjKy6Kh57ua+lLpU
         lTrxFMyxeLEiPzt0BxIyXAA0sU21aP0xHgxSqaGBgm245T1S5gibC3UP/3KnTHhmCAjv
         sbOA==
X-Gm-Message-State: AAQBX9dYimwWd1cxhVDGiAkp4RTQqYCACJKF8T68IcyNFOJRFe/f+bpy
        nNAEM/oh9oj0s26BJBnv0dTBqw==
X-Google-Smtp-Source: AKy350bdTWZsUp46cZZT7/E0Gnd1Xdy0heFNW1jSTFgn0+eJMFdjYMnZCiPf6VmMUxVQNMG5RAZeDg==
X-Received: by 2002:a17:902:db10:b0:1a2:8924:224a with SMTP id m16-20020a170902db1000b001a28924224amr7755865plx.25.1680704833368;
        Wed, 05 Apr 2023 07:27:13 -0700 (PDT)
Received: from 90aff2bdd59e (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id j11-20020a17090276cb00b0019e5fc3c7e6sm10224782plt.101.2023.04.05.07.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 07:27:12 -0700 (PDT)
Date:   Wed, 5 Apr 2023 14:27:05 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/177] 6.1.23-rc3 review
Message-ID: <20230405142705.GA8@90aff2bdd59e>
References: <20230405100302.540890806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 12:03:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Apr 2023 10:02:26 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.23-rc3 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
