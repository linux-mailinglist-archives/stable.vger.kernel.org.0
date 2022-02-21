Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD574BEC64
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 22:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbiBUVS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 16:18:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbiBUVS0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 16:18:26 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181D4EB8;
        Mon, 21 Feb 2022 13:18:03 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id 185so10777803qkh.1;
        Mon, 21 Feb 2022 13:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dbl2/CDVUZ/klo5IJpBL9qn+z0TGGcp1j5EV8+j5CZw=;
        b=RP5XGU35+7oFbd5pNfje/jlLXAjiTEQWFbeSUB1g07O370h0tgAjxtItyMLrfXApna
         taQGvSvQTK3Oj7zThgKy6rsThJ/7o3+Nwgan4JiJwJjDqr+cKcs3yxLO1HZ2XXJwcbPO
         /r9Hjqu7AnrgvVVQuEbLiGvWugNY7isKzYwCEviMxPxp01saZJlHnOXQgIyNruKQUehf
         z6/5QcF+LZD6wiiaj3cTvVVHaO7EbXZi1MQJmSa71uS1OrYotfl5n/z/k8hDE66o2i78
         Mr+wHjrb3becCLnGtlN+kxJ0KuAvjC0GD+Phlrhr6V+TjsYojRp/7cuG+Na5kj8TY4IY
         Xeaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=dbl2/CDVUZ/klo5IJpBL9qn+z0TGGcp1j5EV8+j5CZw=;
        b=oPzMj7MEjJ8kfrVZsq97pgPMsVxDJjJrThX+EBwDf7cjsSm4kSSto52iA+Ivq2aj8/
         xlv3oYOs7fIWZ+FJ8ZAcDsb3BT94pI8pWAEisRLKr4wBRC5xRoLRUcugpyZygkovYt32
         e9uTqtMyMZEwwMEu2/H7P6ixVFVrsvt3cudRO+coRUFTbMww/KX48u0xi5X3udMe5PCf
         gXYft79fqehu1Nzwq56fgyK4UE0ukEQf6AjfYNx+hBqGR+f8++aee9ftGHW2jP8y5zEQ
         NTygugshTKbYM6YxCSBkOLzYqjV6fi+qQkUSGskT8Ob8pNADxb84dY8i83QfIjM0MMwf
         8HUQ==
X-Gm-Message-State: AOAM531YR7FhfaHME/hOCm5RhGJJCdg7MICtcYXd4QfcAEgGkW9HaHlc
        sVj/tvx+S4VeZba1oPChcKA=
X-Google-Smtp-Source: ABdhPJzb7QkK0UfRcLMtrlh1U15uG9n26wvZjyvlwAInBGBexJjckGVj0LdfxH+YCqGP/aThZIgvMg==
X-Received: by 2002:ae9:f713:0:b0:506:c9a0:b0fc with SMTP id s19-20020ae9f713000000b00506c9a0b0fcmr13690922qkg.131.1645478282217;
        Mon, 21 Feb 2022 13:18:02 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s11sm214086qta.74.2022.02.21.13.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 13:18:01 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 21 Feb 2022 13:18:00 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/58] 4.19.231-rc1 review
Message-ID: <20220221211800.GC42906@roeck-us.net>
References: <20220221084911.895146879@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 09:48:53AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.231 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
