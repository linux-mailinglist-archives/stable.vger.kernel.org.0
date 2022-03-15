Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752E24D9334
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 05:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239186AbiCOEHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 00:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiCOEHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 00:07:55 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A7E1D0CD
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 21:06:43 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id kx6-20020a17090b228600b001bf859159bfso1212944pjb.1
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 21:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3TMNtHxozI8oB+z1qPhuCb+opQbKNP8iLpQvJgcHJb4=;
        b=AZXdQd5CrqpNUjcu16jAMFlxTffnHtkltA0D4c32O690li0Is3on6Qr1iU7eCnx1vJ
         213aCtsfyRMgP7Lmp1vVVndipVn1VLj7fa56LwZKB+herfxk1aPZ5oC1zv+9vMf8BXv/
         fAvaDN2vb1QD0yOe59mjL7tRXaU8yzf07/MpM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3TMNtHxozI8oB+z1qPhuCb+opQbKNP8iLpQvJgcHJb4=;
        b=x5vlrnwG2CmJBSVuFE3aSuXyCORcCCaadnCv702WERcY9RWKkTdfBBZ68niVuhdb1m
         g9i5geqxAMMYw/WE+biq7r2gvUFTA4dEHDoQ/UlWiycTAw3kgUhaXqkRsG7Cf6p+UZoT
         IS52JI1O5XhcgB25ztFoBEw0bxYs2Wipnfv9BM9kPvKuXGdoOfpNZdK93xWaDNX9oxoh
         ScnXr/JXAGfz209OAoTWRyXHtejbzLly/On+MMwOAqQNj/9TbpG1ynlz3ZqYQAXt0YV1
         oSapptByj2j6v4fmrUomDESTZJUIRjPxXU3CHO0hjLqZ2lB5yVn7FRJLlllksXwOq4xu
         WEPg==
X-Gm-Message-State: AOAM531s6cZi25T9ooTevmrlvU3NbTzVZuFkVqc/FvEHH8FYcb4JFUcy
        /R99FVFd37Xfaxz6WdUYkeDfVQ==
X-Google-Smtp-Source: ABdhPJxL5rtr/nbC7oeF7qecn+rcYxGdyPDCb2fGQCrNIQ5rh0lliC0+T9/k/09JxqN6W1xZjV59EQ==
X-Received: by 2002:a17:902:7886:b0:153:3a40:fe82 with SMTP id q6-20020a170902788600b001533a40fe82mr17977086pll.19.1647317202777;
        Mon, 14 Mar 2022 21:06:42 -0700 (PDT)
Received: from 76824917ecc4 ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id j9-20020a056a00234900b004f6fe0f4cb2sm23088080pfj.14.2022.03.14.21.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 21:06:42 -0700 (PDT)
Date:   Tue, 15 Mar 2022 04:06:33 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/121] 5.16.15-rc1 review
Message-ID: <20220315040633.GA6@76824917ecc4>
References: <20220314112744.120491875@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 12:53:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.15 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,

5.16.15-rc1 tested.

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
