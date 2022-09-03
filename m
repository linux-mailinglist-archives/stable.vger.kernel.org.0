Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9785ABBDE
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 02:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbiICAhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 20:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiICAhK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 20:37:10 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403A59CCC8;
        Fri,  2 Sep 2022 17:37:08 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id t129so3413894pfb.6;
        Fri, 02 Sep 2022 17:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=pB9q3ePwsGpqGBWd7joAem+9iJe8Z7fnHlZmAJbE9JY=;
        b=BIvKWU4Kpfo2ZvNh7BkRWdKK+wqeyfRn/q7St1mwEiYjUFOh11mTxuYRBKFh3d5PWk
         4Nr8jF8BZDaFFn/TazHG5wmhWOMOQHQN/uCa2a8+JBZSxuFljJXuxzVSQh7a8L4hZqaz
         3IFSVazWrQ01s3qvtKBJFqyHcLHa403nK7SYBVrEhmLEgJr51zjs7Bpt8/GEES4VN7dT
         4nv/6iHH6tdVgQKwTyh7Gg91NK7Dh9hjdaVz23hFR/mscaBcZwwcqaEQI5ec4ZyFxPCi
         KF7PMxWduKSF65K1ot4YDgusubf7wZLcDyi4gqaXjlmMVxOQa2FARU0c8saSD9pk+/iL
         Mhcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=pB9q3ePwsGpqGBWd7joAem+9iJe8Z7fnHlZmAJbE9JY=;
        b=NNqQc7rPxi91ei4yMq33ON53OCsIIO2pLhBRxdBbpZqBmn/SCXEIfeMWlttNp54KTO
         DlVRpEUhyIbQ2HDDm4YY/7BhQnxLkIFYzbhtTqRo4fss+2WzKS9k5iqpYBVkBLKCr3z2
         Dw2U6G7quZU9WqHSqNTwlc2mNhLuf4+i/UtSe8lZ+GIFEhQ78+rJQY+VbpCPFWJHMKUE
         htTHCuMiCzz/rKsoS+eJqUUpIJRY3ZVYeJdwxu9a82tQQfBbY/2uCI8uunjOfke4vQUC
         AmUZaH8rUtRPHwoe1Tf4sSFbBuU1OaDZjFGLBRnowoIZGhRGoNqkIX2UyFI6VqNFYG59
         Z0aQ==
X-Gm-Message-State: ACgBeo0wHquZZk6jA3tRMptTMzKIM9Rn/8gLvwZbM1GDjZnGGoDsrw5b
        JYC356kTDxMhSL3JK/dLIkU=
X-Google-Smtp-Source: AA6agR6I90xGVW+MNsV5GKR9+GVNoQ7hCDqhiiEdXh9fsDLmDVQ6oHBSQOUPvqv4a4OVB0vejmB2eA==
X-Received: by 2002:a05:6a00:2446:b0:528:5da9:cc7 with SMTP id d6-20020a056a00244600b005285da90cc7mr39466184pfj.51.1662165427673;
        Fri, 02 Sep 2022 17:37:07 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c82-20020a621c55000000b005381f50d1e8sm2436213pfc.115.2022.09.02.17.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 17:37:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 2 Sep 2022 17:37:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 00/72] 5.19.7-rc1 review
Message-ID: <20220903003706.GG847372@roeck-us.net>
References: <20220902121404.772492078@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
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

On Fri, Sep 02, 2022 at 02:18:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.7 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 150 pass: 150 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
