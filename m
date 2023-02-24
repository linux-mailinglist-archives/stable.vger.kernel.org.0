Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105766A15DB
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 05:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjBXE2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 23:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjBXE2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 23:28:50 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7760A2A6D9;
        Thu, 23 Feb 2023 20:28:45 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id h10so2440320ila.11;
        Thu, 23 Feb 2023 20:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6J+e0VKbbp3H0TYyNveZYjDHxPFvQQ5cybpNvNw40/8=;
        b=flUuocuFapCrkmQsf3INc/+2ipzpBKBe4QCEdBB04vajQtORxlP0C77/OhTdLBuWEE
         Ww1scnjvjtP9iqJ+uQ0xez16LpwzDuDCc6NpPRiYP0WBHn4/b64ZuvZP3ooAQXW9Ak6K
         MkYW6rdADqTUNak74C9RqKAL9k0HF+xB7tfdROxZc2452Olb4RLq+0vo80hT/kmn+DqG
         EUluk6tfTHuzWuFCRHBfATK2/8kgLcJaPgDUBuXVFvHT5eiDeTNHv+yjCcrTBcVsSarl
         S/zVcYw1LKEktX/+ldSSCGlCQejF+3FMtgiMIfQXCIyVTjf/Jhi6NDD9n3QyI4cY0KHO
         blNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6J+e0VKbbp3H0TYyNveZYjDHxPFvQQ5cybpNvNw40/8=;
        b=G1ydFeK3oLpF1He6NAhe9qba7Xhw/Fy2PB9Y34v5Qvuv09yj1BlL4FPcNX6krknVBx
         u5qK9I55OB2pgGii+qOufdteGPr3r8AJgtub2snAW1m9W40AobpTQpl9uXPX6v7AQNin
         pTh9BDEs/dcFdtN/7917aI9FQJ0qxx84nyoscqM/mO2+v5tAgWoYjxfVzoVZK0z5H+wE
         X1RovHqWeifYoIfmeJRxTARj519IoSPy9Mg23paAEPzhzo0TVa+2rUtr/AIUkfyizVIY
         M28UT/rlS26lMveDewBPCAZqk9ItMnU29GwUvaeTcY1HJ+ANjvhYiTl0vkTR44WqvgXf
         awIA==
X-Gm-Message-State: AO0yUKXKFhnvRmGoc//wz27HRXtqcJsPJ3b8Qqz2gfxhnHj036fC1ltO
        SSj35V9E1fb/UvTOdeD0nbRfGFtJBfs=
X-Google-Smtp-Source: AK7set9bVsbJUcbP7MtVR+cbHEi3s6nLwciWQCP5pLfrhdJqa8lHmec2OApkZ6t2wZ85oxGKIP/I6g==
X-Received: by 2002:a05:6e02:1d99:b0:315:7004:3e69 with SMTP id h25-20020a056e021d9900b0031570043e69mr12271620ila.13.1677212924903;
        Thu, 23 Feb 2023 20:28:44 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v25-20020a02b919000000b003b0692eb199sm2935112jan.20.2023.02.23.20.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 20:28:44 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 23 Feb 2023 20:28:43 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/26] 5.10.170-rc2 review
Message-ID: <20230224042843.GC1354431@roeck-us.net>
References: <20230223141540.701637224@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141540.701637224@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 03:16:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.170 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 478 pass: 478 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
