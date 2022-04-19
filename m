Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D613506160
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 03:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbiDSAyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243125AbiDSAyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:54:39 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318C822B07
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 17:51:56 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id v12so13716544plv.4
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 17:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wM5eGyr3SUizceTOlVsndBT5uQW0eu2dU3LxPn4/Ezg=;
        b=bmKla6x6odM1YsbleTga90WiWlm6jfotsMeZovnJkliWufyzJOrSpUxnJeq7fGZoub
         1jvG/C2AOchIVjWHwDkBU1I8SO95zvpwjRkY9dOXPYAXOw5Pg0RVvI1x2tczyp4+tyte
         nJfeAtwY7QEuQsz5828OOCUINaGj0vCZm25eY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wM5eGyr3SUizceTOlVsndBT5uQW0eu2dU3LxPn4/Ezg=;
        b=uLDzbWK0gJAQxn4Hm/3aW/4BtvXDtkHP/LRmZq0LDQNyZSs7Y+afX0ZFIlrW/E4Yw6
         F8IxiZ0z8Dm8JzZViBD0GTZ6gdwhvCAqTqQDOXQ6BijlnhglpLYiZ8Wmdmykpjoyzpqp
         ojrZUKAtLwyeweD1zVNjVEGUek4NBxjMZh1UtVCQ4TVtUlw58qHPC8uoXrMqFgxHzRV8
         7Ql5TCP5LGPaytbkW2pUdF7A4p3IvWqJ3b3iAuf/x8R7iYhIODJPaqDTS8gVDHnEqcfM
         vr8hbt0TkgNGIIJNx6m89fAPxa937kylKXqPLXJL/dcLIa4guBsNSv874Rq+iMdG8Iek
         TLwg==
X-Gm-Message-State: AOAM531Vu4mojK4YW3p1kJpzM6NV2T6eK3z6zvmLIzrrx7kd3PoH0Wi4
        0JD9jXMGCugp0Si3cCXATSyQBA==
X-Google-Smtp-Source: ABdhPJzfwSwQZVzubG5H6H7wmw5MH51JiZviUnjI+CClpYEvkpzh763G7LaN4m5baw907fRjal73eQ==
X-Received: by 2002:a17:90b:4c8c:b0:1c6:f86d:a6f5 with SMTP id my12-20020a17090b4c8c00b001c6f86da6f5mr21196237pjb.15.1650329515628;
        Mon, 18 Apr 2022 17:51:55 -0700 (PDT)
Received: from 42286ff12e0a ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004f0f9696578sm15650707pfl.141.2022.04.18.17.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 17:51:55 -0700 (PDT)
Date:   Tue, 19 Apr 2022 00:51:45 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/219] 5.17.4-rc1 review
Message-ID: <20220419005145.GA7@42286ff12e0a>
References: <20220418121203.462784814@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 02:09:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.4 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.17.4-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)

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
