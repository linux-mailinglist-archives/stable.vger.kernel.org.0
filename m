Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710C965E16A
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 01:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235036AbjAEAV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 19:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235732AbjAEAVe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 19:21:34 -0500
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76C647331;
        Wed,  4 Jan 2023 16:21:22 -0800 (PST)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-14ffd3c5b15so30084113fac.3;
        Wed, 04 Jan 2023 16:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o0bzxs8vT1edO2FJXRZYVsWw5T2NkBAzXWyaCPQ3eXQ=;
        b=GXTugK2j/bMB/msseOunjbhl8k3GHOWmo8UlmNC7F3jNGVDXFQbCcn0h1zUKXzinQn
         O56/w2TxzzYlu1CA72oTh5U9RzY3lUhA6KU2ylGQLt5om3F9yuZ+b9M8b0sQxdi5Ub+T
         YwSJ6dApX+l8Cy506sgewXWw4OxoFNIPzusUUOe4ShOAfhpT+tIrjwd5zsc+rb9v5tmN
         S2koTLYKjHfYl3lCflH8riMjBygKIsh9MYs3e1X4E7tE3L1WhiheGO6w2aLzTcSE5QQK
         GyjSPb6F4A1s4RHpaTooc2yRGnQv/sU+nKMJiQrcNRvb8Fblf2OutmGiK/hQwmM221/l
         wiGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o0bzxs8vT1edO2FJXRZYVsWw5T2NkBAzXWyaCPQ3eXQ=;
        b=4iMy7yrpfMdE10t2u705LAmy8RXeY/+ffNLsllKMGkdc+3ok/OkqZoOEpUfO/9x0gf
         qI2Y1riPNQiTE6RxlXKrhXXoghpCnqZDcYrLsOVsMR5DV0liQHHgGiKjj8qz5RuXLSNL
         dql8OxkgvKO6R/lsneExkjvHJYFc7nBsh1lXbGTeJ8qAe8QNpKQGR/uRD8Bvn4KazX1v
         L/KhrFwXkCCVJoxp7s0PcmVwFCqqbRcxL/ADd7UpSYkhaFLe+rjaU76FyyifLX+ebTaR
         Z89DDWuiTkS/rLESWIP0+3DKcxioZekReSbW3AwtaM8SZtAB7XZpML/ONxm2kk/n7+tI
         +MGg==
X-Gm-Message-State: AFqh2kpGQ0IoH5n4cpBoXzEdAhLacK4SNU7FCNlfDuMWx1hTA4m5rnh3
        NgfDK0DW30WLw5CVVY9AlVE=
X-Google-Smtp-Source: AMrXdXtqb60Qxb9YJksIcDr1nnNmGMH+8VQoS0u1d2uA1M3akETZT3pTpdG0hc9YF9bV/rThNEiDxg==
X-Received: by 2002:a05:6870:e30a:b0:150:85b9:7943 with SMTP id z10-20020a056870e30a00b0015085b97943mr7589192oad.34.1672878081852;
        Wed, 04 Jan 2023 16:21:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d20-20020a056830139400b0066db09fb1b5sm16634661otq.66.2023.01.04.16.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 16:21:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 4 Jan 2023 16:21:20 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
Message-ID: <20230105001720.GA2458003@roeck-us.net>
References: <20230104160511.905925875@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 05:04:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
