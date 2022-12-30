Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B147659960
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 15:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbiL3OiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 09:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbiL3OiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 09:38:22 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9861A235
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 06:38:21 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d3so22035543plr.10
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 06:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D0SWZDx0V1D/HIfCQH5ieh3dByUshQE5TdJw3a+TDeo=;
        b=fnfGF6A7esg956mneyuZG42t7fnkhl/sRIHsTvqdDR6SYRfFQs/pLqKrX1ph0kbzrq
         m0iA5PjUwHMJVRm7XnPoMKFHgatU1Z2/zcnJ0+RmKKdEb9bgK3bVVHxDgP5Glhi8gUD7
         tOxrl4tiqnubKOuMRPR7CBWUZrZ50JcoHLSBg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D0SWZDx0V1D/HIfCQH5ieh3dByUshQE5TdJw3a+TDeo=;
        b=lbIvZFQDr0YwIU0yz79Fj/Q5EixYPb5jmPS6WxmFpB5sFJDX1EblK+uEGZQ6dKuAni
         VhqvKP8Kk87nNjPWIkpOpEz1y531RcmGkfsx93rzfWSW9USFb3R5WlrjFHcjfL5kW7TM
         rhu239iyTbhgg5XG72cRDUfLr5L8EgIiJaP8BPEzseba3VeDyY9a1A+wXitEGOmNacoK
         SfgOfePzZqHAXkSgmqo3M7qQRbtksfjnrB72X9owMozaM5S/nqEGGf63aU+TxAESe9sd
         s3+MbwDQxINMACH7wpcXA4WqKGnnrrEIGB4jm6zUgUgBEUmfvZIAs7GJkEILcHBhS/wf
         MRPA==
X-Gm-Message-State: AFqh2kqYXAeZsuzHuLKgSwAHO0+ws3pt9kDDfJMI7xm1D8FbgbBq4Ix6
        psMZ8amINm3RFUB8OQxigLnQmQ==
X-Google-Smtp-Source: AMrXdXsprLveRXW4bK7IbVnhIlYhMg/hTUgGv0jcPjRWEBPmaSlvPmgR8hFmojNAQFDzhv008E0pyA==
X-Received: by 2002:a17:902:e2ca:b0:18e:c6b0:b2f6 with SMTP id l10-20020a170902e2ca00b0018ec6b0b2f6mr29800656plc.14.1672411100566;
        Fri, 30 Dec 2022 06:38:20 -0800 (PST)
Received: from 20bae947266a (lma3293270.lnk.telstra.net. [60.231.90.117])
        by smtp.gmail.com with ESMTPSA id jj13-20020a170903048d00b001889e58d520sm14933629plb.184.2022.12.30.06.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 06:38:19 -0800 (PST)
Date:   Fri, 30 Dec 2022 14:38:11 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1140] 6.1.2-rc2 review
Message-ID: <20221230143811.GA8@20bae947266a>
References: <20221230094107.317705320@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230094107.317705320@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 30, 2022 at 10:49:32AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.2-rc2 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)
- Tanix TX6 - Allwinner H6

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
