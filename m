Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4704168A7A7
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 02:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbjBDBuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 20:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbjBDBuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 20:50:10 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6E8A0E8B;
        Fri,  3 Feb 2023 17:50:04 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-142b72a728fso8761149fac.9;
        Fri, 03 Feb 2023 17:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7NHm0AKOe5KR/2Xw1j7bTsvQ+lWtNdjtBx/zsfht8d0=;
        b=llKgGzRo6b4CLPCRhHtJb6unkhcStdzjo5481HR7CWxGKhYwXMgpd+WE89X62QpcOn
         PywPXCqRpdRWZROYxC7Z7Hbdo7Va62+DPHsZ9LnPPjv2QmAoAaBvuNcPAZSiDFnpaU9p
         gFDaBnSNbv/A0BGIFft1splMK3e58GeBim+6BGLDorRoXcuhVbkQAHvDP4kwfiw0wfbJ
         iyfFEeBpvLHpbWQcytk6ov5iY8HCmp41V4p8q8gBthJBpEpZYf0t39oaYuoFnIBcHJGz
         IVHoD/89TtnOsIY/hNv4x429khDMOFcZwfAX55Xd5jUGWO8b0q9tFPRxZvw6D2VLNFkJ
         yo4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7NHm0AKOe5KR/2Xw1j7bTsvQ+lWtNdjtBx/zsfht8d0=;
        b=ba/O9eVjxp7Uk6AesP8ll0V9Uhvk+TRE+wMS4TPPO8yX9cQ6qMEc5WuBfl6Mf1np8H
         nxiYM2y/U8GHvB6HiG1ZRzHX5TWMt/ZgZy8Ab5U8Ke3wy6mSfXFc3FtEOqaWgqcqcH++
         TYuYK+3P3udJ4ViQHqPptBRF2SHqgZpkNxr9vQMeD5Ddnwoch303YH8tdtnSxpZTuDBg
         FPJlfbRBlqRV4Bw9i/cu1Ztbh5dVcW9zXXbzDp4vvy7uFY+UIoCkQtlWZtKQ9okzWLck
         zlh9ZVi2WcBkmgaJKQK0kg7OYO2bj7LvuWmpvNhwkFy0WbDuGiIoUQowyOafx7GhmIBQ
         BS9A==
X-Gm-Message-State: AO0yUKVJB5teIYcU/YUTKQrpDT9DVs3wBSQO1fnB7sq6+tXwoYDMdcJD
        JdhRxXAuhvol6DsQxHCw2FA=
X-Google-Smtp-Source: AK7set+vMfE9u10gbIODpQu7mZ1QupWySs8gsOgacAPk/2p74yzuRpdyq8Zyl0NVIQwR5RSRY9hUVQ==
X-Received: by 2002:a05:6870:3326:b0:16a:1615:3fbd with SMTP id x38-20020a056870332600b0016a16153fbdmr866884oae.32.1675475403441;
        Fri, 03 Feb 2023 17:50:03 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h41-20020a056870172900b0014c8b5d54b2sm1432242oae.20.2023.02.03.17.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 17:50:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 3 Feb 2023 17:50:01 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Message-ID: <20230204015001.GC3089769@roeck-us.net>
References: <20230203101023.832083974@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
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

On Fri, Feb 03, 2023 at 11:11:45AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.231 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 158 fail: 1
Failed builds:
	ia64:defconfig
Qemu test results:
	total: 450 pass: 450 fail: 0

ia64 build error as already reported.

Guenter
