Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38439658D9A
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 14:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiL2NoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 08:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbiL2NoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 08:44:09 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2731C8;
        Thu, 29 Dec 2022 05:44:08 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1447c7aa004so21670903fac.11;
        Thu, 29 Dec 2022 05:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p5TdyggQQ831ouqpy9GdepiRIBVOP4+BVRsOEdk0o6M=;
        b=XyxYblCiZYIjAfnLhUh2kjW/c9ssR/PFbnnsxxGBGgJETUFgP9SK9EnMI+TvkfU72Q
         8PmD3QHrKOfdW6M5Yv/HEqCjyvlB2pqED9h6Zgcl1OEij7dM2POWoqPOmtzRlvdl88yi
         VWhuHzhTnLEyGqraKZaDx9mJ47Yr8Q25x1ufPJS2SsizQi9jjYqEGWVbJ1hgUZu4pNEC
         mbZs4kJM78CmG1yZRzqp304kajshuszUUQ8hVB0MBD0hFYc54SesLDgtF+TgI8f89vQV
         JkzBsnJzIweoFbs3rCNWgmZDg7PS17xlh5QZjyrpvMLbVde8skWYKGmXMhc7VzMUI6NB
         EcbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p5TdyggQQ831ouqpy9GdepiRIBVOP4+BVRsOEdk0o6M=;
        b=N5hhMCldjevAl3iIfanCJ/jHqRNfjo7ZaDVXtHksMxtZ6eZvS8wCYU+z8sO7apR10N
         1b+xqK1SWAU5TUfUYrt6kYzx9IHB6qG0E0cJXa0Xp0VZ7rBmX5ROWHMKAtvjLJNK2Ysv
         iRiDx8AcdID7liy39AnfX6E7nECD7d96VWSZrN6Bs/gx8aQV+ZlxVDrDF3G/zgORzxLl
         EIAJ2SlrX3rLDYV93PLZAtiM5rpMq3wxDTFldtWH4tes5F8HwYkRGz5n3NFAGdvPO+j9
         PoNPw9RPjCwtHXj5wDzr59MQGkW46ZARjYMx2R4IE0iRG3xqckml3EsoW2KhCtzkSLlq
         8STw==
X-Gm-Message-State: AFqh2ko29ddTwvb5vBroIq5SUM9zhAjP26hjd7jqDCIhJQDX43oEF5S7
        z/04s1T1zUL0Ipw/bozDU8w=
X-Google-Smtp-Source: AMrXdXtI/wi1CpRUU4wui3GW6T680nHk/LXELiCQc3j3TJAPRrBg910RqlomTfOYb2bwIq15N7pnJQ==
X-Received: by 2002:a05:6870:d393:b0:144:1a42:fcfc with SMTP id k19-20020a056870d39300b001441a42fcfcmr21118284oag.28.1672321447925;
        Thu, 29 Dec 2022 05:44:07 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l8-20020a056870204800b001417f672787sm8529365oad.36.2022.12.29.05.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 05:44:07 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 29 Dec 2022 05:44:06 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Message-ID: <20221229134406.GC16547@roeck-us.net>
References: <20221228144330.180012208@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 28, 2022 at 03:25:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 153 fail: 2
Failed builds:
	arm:allmodconfig
	arm64:allmodconfig
Qemu test results:
	total: 500 pass: 500 fail: 0

Build errors as reported.

Guenter
