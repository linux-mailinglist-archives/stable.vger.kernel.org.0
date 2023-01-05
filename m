Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A1165F424
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 20:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbjAETNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 14:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbjAETNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 14:13:20 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC465F90A;
        Thu,  5 Jan 2023 11:13:19 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-15027746720so28891766fac.13;
        Thu, 05 Jan 2023 11:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l1yEfcKH3h4k7bsnfnEIFWm2A0AEAGBTq2L3pGIOHTQ=;
        b=q3dH2bGhc9ZqFyavB/p3WoehLk4YVFRc6q5xUb33k935303gQW9C98wLmPq6WAPfQB
         /BHvIxCIj7CFRxYm4u9tk3TRMbFaP4+lXz/7TOg4zzqSYm9QXZEHZsEIXOMhJl7M/nnI
         eRIvRYauk6ZptnxdVuSVRNtoQCx78BvrWOSxJX+Q37gsAhM9xLyWcVESbk/86BNMsHzh
         TpjqSX7HsAZO8kkIURmWKSjd7Jty8V9Y2O7D58wnpKnRB+h6+cSs70GOUWG0w61vqF2n
         YCZgtNiPqxKg6WRKrG6rerl7IDpDq3mvt7n+Fc7vAUxHe9n+zqdCoKnXhd7lndeQ5PoA
         HwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l1yEfcKH3h4k7bsnfnEIFWm2A0AEAGBTq2L3pGIOHTQ=;
        b=4GBK7qCXEM65VlydoqmQ5q41j+jxKfNH6ZiCMxcz0RgBpx7nXVVSfndVsoJlCNQggf
         eXbRxH0sYCaTkCNAoh1rQjAzN61DEQyGavtMVNlzYR+NC+euK038olt2kf3znLyJ5qIB
         Z7uvCrHLwaCG0Maa7/hBAGAENV2GbgvDYgF/3tdK/Gl8XdigT3kndxJR2YzLu48r/Vtp
         KlTQcdLzom72sV25lEblezHjfiNzWv62gao0Ir66QeH13Z3V+icoRzIns7IFiAs5TUyZ
         lA3+/TsYgyy6Rgm3n3Th0gc1GaExAjAobdRzFc0V01Vp0scD87M19leVgni77LTihWa5
         uL4A==
X-Gm-Message-State: AFqh2kq3wypqkKP8uI7rLxM6mm8LfMmpi1QcpHEe69CUWaNhGoW5AcFN
        d737mtMFgxKMRlAbdixPzCc=
X-Google-Smtp-Source: AMrXdXvZ6qeozbL87px31h3sndWRTgoAZ+uKYjaMWzH3aQRttuQcghrK6kJ7HKWUUo/Xj2zdYLe+sA==
X-Received: by 2002:a05:6871:230a:b0:150:703d:1488 with SMTP id sf10-20020a056871230a00b00150703d1488mr11934013oab.7.1672945998869;
        Thu, 05 Jan 2023 11:13:18 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s24-20020a056870ea9800b0014c7958c55bsm17452362oap.42.2023.01.05.11.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 11:13:18 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 5 Jan 2023 11:13:16 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.9 000/251] 4.9.337-rc1 review
Message-ID: <20230105191316.GA2928293@roeck-us.net>
References: <20230105125334.727282894@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
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

On Thu, Jan 05, 2023 at 01:52:17PM +0100, Greg Kroah-Hartman wrote:
> -------------------------------------------
> NOTE:
> 
> This is going to be the LAST 4.9.y release to be made by the stable/LTS
> kernel maintainers.  After this release, it will be end-of-life and you
> should not use it at all.  You should have moved to a newer kernel
> branch by now (as seen on the https://kernel.org/category/releases.html
> page), but if NOT, and this is going to be a real hardship, please
> contact me directly.
> -------------------------------------------
> 
> This is the start of the stable review cycle for the 4.9.337 release.
> There are 251 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Jan 2023 12:52:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 395 pass: 395 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
