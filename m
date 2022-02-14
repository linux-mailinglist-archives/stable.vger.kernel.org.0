Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0E04B5B30
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 21:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiBNUo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 15:44:59 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiBNUo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 15:44:56 -0500
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA73158E9F
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 12:41:29 -0800 (PST)
Received: by mail-pf1-f175.google.com with SMTP id c10so5649371pfv.8
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 12:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uNlqPYCMD53jWiyYXdw9aak0gXKhbsSuXuZhyXCyHmg=;
        b=NoQiEClPzkJ+XRi6hmHI7774JKuLP1E6J/oyoThWYOq5Le9xuEEagPZFK5pGpZUwfd
         xHznHquGdtKJtk87zj95OL5aTurOmtI0yHvKo2bXXPrg9MdfzJmjHopMYad/7c+xl+sO
         3v+rVvU8U1FDaPm1J0U9rDeyUq98GgoNviIWM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uNlqPYCMD53jWiyYXdw9aak0gXKhbsSuXuZhyXCyHmg=;
        b=eppEyH3Ty4HwdSLmqRpY7TWQcLBsQC71BWICF5kYwmQzhPrOJg0f3vyMcaPaTfTFhV
         NXAdO9FVQkH+y2EWllBaG/0U20TdGUGCrDaiDZYy5P1+Te1OEIHh07w7lZnEeaJ2b9jR
         zLU42tBndDdJpO9h6PEuzpA6Wqdwi4Wl9HWjufGr3FpllO5R8dP2VLdy0GMtG9TdWqpH
         wS7oOLRBkg9efJ40xf0pLbxgpfOtEDpzh5g8jtyRJqC4D4etIJmXwbwo4PBctNWhXtv7
         wwADHbWdbpsBdET9oqt3h+0ra+0al4Dd//sb+BD4MgGPuIAVbbvguxn/0j3cG6lc0MW7
         kcxw==
X-Gm-Message-State: AOAM532Z55asyd05xWCnDQI+LtKUX/NByUnqRfatBcq6xPI+oWI7JHwu
        y6z/i6MLOcbVMVuRrmKxZGhX6wwnvw0mvdVi
X-Google-Smtp-Source: ABdhPJx3g62mmoCZharDwWks2mvOlhT7OdG28aRRlZ9wCSL27LNKps3w44wRU/SPAObV5Cqn4ljM3Q==
X-Received: by 2002:a63:d90d:: with SMTP id r13mr621700pgg.129.1644870621248;
        Mon, 14 Feb 2022 12:30:21 -0800 (PST)
Received: from e29534637f20 ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id g126sm389283pgc.31.2022.02.14.12.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 12:30:20 -0800 (PST)
Date:   Mon, 14 Feb 2022 20:30:10 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/203] 5.16.10-rc1 review
Message-ID: <20220214203010.GA7@e29534637f20>
References: <20220214092510.221474733@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 10:24:04AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.10 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.16.10-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)

In addition - build tested on:
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
