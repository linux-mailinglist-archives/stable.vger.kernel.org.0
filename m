Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44711637089
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 03:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiKXCim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 21:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiKXCik (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 21:38:40 -0500
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B8A6204C;
        Wed, 23 Nov 2022 18:38:39 -0800 (PST)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-12c8312131fso597316fac.4;
        Wed, 23 Nov 2022 18:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ienSnmYCrgek258e+ZJSHsCrXp4Z8ixedL6+majQKqI=;
        b=MIUDvjjrffXPR3iuKDOxkwYikhKDg5EMVkSd2LyOmIlECRF9COb90JCropA6I/Nbml
         KTJDcIoEBSVrP7SuG8vBZ6o1mngq5osfQ3SEsItaSyZEWdL6IgBGzKN5XkcswxPErtrn
         OLM7UtV2RNxx9fz/hNx4hhQ9SIj+D2DnLheTzfUGF5feesh3OxuhPuPNd7Q/UWNyMDsq
         VowyokzDz2oSzHQHfnrHznc3EueKREO8knnCawWhoTvSo8k6KtGMATZx2lelI+grxGQq
         12WLTjAcdRzVw+MebaabT3B6HdueOfxptAYUwkCAkWI0yQvC9/XiLQ24BFgcbCSZoPyw
         5qxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ienSnmYCrgek258e+ZJSHsCrXp4Z8ixedL6+majQKqI=;
        b=LJyXMCrxlwq13u7oIiLyvplq0jhcD4YFZpEJXKylWrHI1pu84Hc1eVuNekpjtmpGTF
         l0+x/IUQtzZjy+t9JC5HlFdSe1nsQr4MD9Hf/lm/8hfsaz2zGiN1HwmGUHOqdsHsxfiA
         Y9Wsre6lq1CqJdJnFErah+aSlSFSHDJK4+c2lF0txTW3pTGztOQZdmPw63d4gmWCnZ32
         jB8x5/qYDAlE/J+drCokamERUHZhtA60DTNPj6oKsPuM4ojbcMqKhSS8CzBO3Ag6DPbW
         prx9c90CpvHTIVRwpv9e3rUupmda99uanZsB9wX5+WITKNSHZSFPtl3nt2I9VERyFjbX
         47Kw==
X-Gm-Message-State: ANoB5pkV2gUIChGNAwdZ+if3VDbzag/posD8+m2ZXJFQ1Tza9bVW93Of
        RREGekG9YMN2nvAhaSzwnUM=
X-Google-Smtp-Source: AA0mqf4jHmc41MB6MLKAyTTdfgojFkTOmYlEpcWfCkFgC7e0drwgP/fbTbE6yoyXYj7IymIDS2bcyw==
X-Received: by 2002:a05:6870:788a:b0:13c:f9d:e75 with SMTP id hc10-20020a056870788a00b0013c0f9d0e75mr7879938oab.27.1669257518460;
        Wed, 23 Nov 2022 18:38:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u2-20020a4ac982000000b004807de5c302sm4888ooq.17.2022.11.23.18.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 18:38:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 23 Nov 2022 18:38:37 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/181] 5.15.80-rc1 review
Message-ID: <20221124023837.GF2576375@roeck-us.net>
References: <20221123084602.707860461@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 09:49:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 154 fail: 5
Failed builds:
	arm:allmodconfig
	mips:allmodconfig
	powerpc:allmodconfig
	powerpc:ppc32_allmodconfig
	sparc64:allmodconfig
Qemu test results:
	total: 489 pass: 489 fail: 0

As already reported, the error is:

Error log:
drivers/rtc/rtc-cmos.c:1299:13: error: 'rtc_wake_setup' defined but not used [-Werror=unused-function]
 1299 | static void rtc_wake_setup(struct device *dev)

Guenter
