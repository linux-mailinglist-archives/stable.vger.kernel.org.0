Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E810616F16
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 21:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiKBUrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 16:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiKBUr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 16:47:26 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9070365D3;
        Wed,  2 Nov 2022 13:47:25 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id d26-20020a05683018fa00b0066ab705617aso10928663otf.13;
        Wed, 02 Nov 2022 13:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jI1AdsKV3wVOr17xjeLihkIpdii2P9AsBZRr09EhVxY=;
        b=OTCxNRcB5vJ4JIK2po7J6rUHopR5fi+r8iKXKfTy/B6tIqSyr04AYFq90dwFdIoUGe
         XFCeIbOUp8IA8V0uvd7jGnL1u4eZu64YiHPVog4M4DthAJhnrRuADiEp6nkTfs2/z4nI
         csoQqGjKbWpPzbKpME0c/J+qG8H++VXsXXxVHFyV1me4mIYz0hvhW17toOG5sT2q7l4I
         w1raecqgtEFXA8aRKkZ1g6zTPdff26KJm9L7rR4spJr7FgCnvXNPSxG1dFjInyYg/vuA
         j99vEAONSYX31a+Yuc2IaotazEUDyFiUeHKFW5Monm1NNttAKrBxZqnIAbgIehe7rgNc
         G+WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jI1AdsKV3wVOr17xjeLihkIpdii2P9AsBZRr09EhVxY=;
        b=CE2JVnREWKc8ryqczh4nWycK5wiYCaTR4HbuUWyGelEr6fMc0/opQP/9gyGyMF66wJ
         Z9ahnAZ6OH6rlI6pzZq6BPEjgrBV8/8uQrHmb+nc8QP6TrKL8R5Mw9zCxggmaNWF5R9p
         0D0JJfU+eACol1hW18+dZB2mY0GXFfSw5ThP5fmqCGokxWpR7q2UD6C+niGNI1PdWbcs
         Pf2QZGBvuCOtoGFFiH9btj2e0k6xbaw8wge/Ge95bNsjPBB92bEPqJ+EuWclMalLDoTK
         ftn0ssRutNccErcJqSKDRbxu6+790I0x5nNpdfgU1dCAzHdSXagiFtTnlmM/PRtv30y0
         Zvng==
X-Gm-Message-State: ACrzQf1tlnkUw5KDYijGc++1zX8wKsejp/rZLgdx1tbTyTFD5sYnNRzL
        bm2NP1G/iVvIUJoU3keEkPjPtVsqiA0=
X-Google-Smtp-Source: AMsMyM4PAVo1QnjVxcmmSgT83sLeyilx+KSzdczzKhWTSIimh6ypkgloK2sl8bz6hAZD4mjio4+23g==
X-Received: by 2002:a05:6830:6303:b0:65c:5bcd:c2d0 with SMTP id cg3-20020a056830630300b0065c5bcdc2d0mr13028303otb.115.1667422044908;
        Wed, 02 Nov 2022 13:47:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n17-20020a05680803b100b00354978180d8sm4927305oie.22.2022.11.02.13.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:47:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 2 Nov 2022 13:47:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 000/132] 5.15.77-rc1 review
Message-ID: <20221102204723.GG2089083@roeck-us.net>
References: <20221102022059.593236470@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
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

On Wed, Nov 02, 2022 at 03:31:46AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.77 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
