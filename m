Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31514622AD1
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 12:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiKILnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 06:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbiKILnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 06:43:40 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557CA32BA2
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 03:43:10 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id q9so16446013pfg.5
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 03:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ODY7XT88Lb/pdMVorgr1Omr1Qh/cJGNYn8iuRKgv224=;
        b=TQeFk8oIslS+EyBWdOSfSVTuEjBkH5kojK+B8JLwLu63A4au+NOj11SlJAA1xSSnts
         ct2+ElU3SbvA/KJtVFIUK+NS9TJaDzKoTMM186g5a2tpJlFqPf8vWsHBndzu7+FNhhH+
         YbV46mjcs5aSmOCbqznnKJ0GjKpmsFzpHIO1c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ODY7XT88Lb/pdMVorgr1Omr1Qh/cJGNYn8iuRKgv224=;
        b=77AsDDTJuIcPfscP5RCiX5Mf7RH11EIcmrKSrm8Njg5kch6Rxy2n6T7rmW2iGhMfDa
         YqXr8zSh/J8YYu1ItMcbBfzSSusV3CX2UHjyQLlaYt4ZIU/q9udFgbQPcQcUhT9kC1/u
         cjk2b6DFnz4tehXEb4OYVMs7qw4CnJHEMO7Z0OcM1v5rtaeaNyzf48UBpOODj5L6tvgP
         p5MHOdtIHyzm8MUqSCqa093SJPMeHGXzY/OU8ljb7sZdHcHE1MjNm8S8ARD2kBs5MOHF
         ILQbYnKGcUpbCCiIr+D2UbnDqvf5Qw7dGitozAbYHrLdfyXeHbfXpVOv+F8NjzRox8H3
         BANA==
X-Gm-Message-State: ACrzQf2bj8nvYWWpYSv5S4QfjR26XpCva91rS16OXMqPfdW3N+24/uW/
        RQRlg3XEP/K6IB4fQHOhKjWC6Q==
X-Google-Smtp-Source: AMsMyM73mE2Qn0THhWKZ+B2kaOit8E5j+WJWTTZAQ4xn7qeVjcQkQ3W283GCgJZSHbaaudluG9eAQA==
X-Received: by 2002:a63:1748:0:b0:46f:18be:4880 with SMTP id 8-20020a631748000000b0046f18be4880mr51454952pgx.128.1667994189740;
        Wed, 09 Nov 2022 03:43:09 -0800 (PST)
Received: from b0ad8707f47a ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id mi3-20020a17090b4b4300b0020d3662cc77sm1010624pjb.48.2022.11.09.03.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 03:43:08 -0800 (PST)
Date:   Wed, 9 Nov 2022 11:43:00 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/197] 6.0.8-rc1 review
Message-ID: <20221109114300.GA3493079@b0ad8707f47a>
References: <20221108133354.787209461@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 08, 2022 at 02:37:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.8 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.0.8-rc1 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos5422

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
