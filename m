Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75B163FDCD
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 02:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiLBBpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 20:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbiLBBow (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 20:44:52 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B97D3A21;
        Thu,  1 Dec 2022 17:44:49 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id n186so3962926oih.7;
        Thu, 01 Dec 2022 17:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hvv9FXRsemW4l4PI8H5cpdCXf8vmtqJ7GI82fIK6u4o=;
        b=PKiIUIpGAFOfhhBaT8KJAuT9pkwk93cvcGzaJtFpLZUJF70Zv2fJDVc9qwuc6qr1OI
         WjRNy/ZmJtDIXrWNJSdpPGGcubnY2qSxNIkoPqQu0QSQ9QI6+NxtotZ2lj4lwsYytWxA
         RbzSVODbUVVNDMNefGRPppaWp6m2CcvVDg/usXYTWngWX1H+wy3WwbaAeSHH+gUMe3X5
         AibEVd3pXFnpOpRF/ZInKk3lj3SVKgiakgGR49RHxLQYUisjdie0pV2xp5KuHtzcrAbm
         Kj5rjiXJRJywaBiR6wvioNJ7ugWen3LZGmTKRuDWT8KOaTjednTOhEDAhhRZr6PXy4TQ
         EP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hvv9FXRsemW4l4PI8H5cpdCXf8vmtqJ7GI82fIK6u4o=;
        b=lIMDiIYcuuqwBps7xOP02V1nMliXOCy5Ay+L5BdDJlklBKilMnSP7aLq+TeUAuh5UQ
         dwGYpOWNfLT7tFCcxwCHOitYtw/yhL2zXZZsrStcw+7bbmIXkFhP/aLaBZTP+bY1lQJE
         lETXe9eCLoqDQLGOE/XKuRZslDxVRPvlJHFQ3ONnFnUji5fcPePVX23aWty1gn4IkNXb
         QLWmUogHiuaoscikNOnsBu599Kyz1gYc7VsR6FweJP74qJyc9/MjfEwtbQ8Xn8L3BOSe
         Zbp/tE5f4cigpJ8I9d3D3p7De0/yd5QfJKrwEQKlQMl8XfBqkmE6oreGQJ6y0fd5QXZ1
         qCdw==
X-Gm-Message-State: ANoB5pkqXHg5Ox2bmRPbQTEVbDunKu2Lma2sP6PMUOYapbaqujJ36acw
        MNJJ6fH7Uk2AsqDUGQgP4PU=
X-Google-Smtp-Source: AA0mqf4H7tZ+qhYY4A8AFKeW70Jbj/ilQpfMxewTYF7ODE2Dx5NyfcWB3E0hJ8I4FtZ8AHyRrhdlYQ==
X-Received: by 2002:a05:6808:138a:b0:35b:29de:da29 with SMTP id c10-20020a056808138a00b0035b29deda29mr24974660oiw.55.1669945489271;
        Thu, 01 Dec 2022 17:44:49 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o6-20020acad706000000b003549db40f38sm2441136oig.46.2022.12.01.17.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 17:44:49 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 1 Dec 2022 17:44:48 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/162] 5.10.157-rc1 review
Message-ID: <20221202014448.GC2255418@roeck-us.net>
References: <20221130180528.466039523@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
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

On Wed, Nov 30, 2022 at 07:21:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.157 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
