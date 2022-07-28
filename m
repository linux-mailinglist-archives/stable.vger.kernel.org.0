Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D16158487D
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 01:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiG1XAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 19:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbiG1W75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 18:59:57 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8716FA07;
        Thu, 28 Jul 2022 15:59:50 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-10d845dcf92so4085018fac.12;
        Thu, 28 Jul 2022 15:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZKvcs4aaagkRnAdPinKYgTfXzFMyaAUyAdvgww4NHWg=;
        b=pt1HhZWi9D3EcuSwGOJjc1lYfKSX8pp7FUv8bnREK89KWRveQRWuGRjiVE1vIea6aY
         nTzKZeO+DOG2jNSmVfBgpazcLExpbxl+JM823OK+zfwW1DuSJWOr8Bw/sFduPHGDWh7+
         So+qAbgjlylUyL6Iq5/raDhKtx3dlBLBHn0/RBWBIFs6oBNJcG7WLcyQ9m4N4s6HRuu4
         +BTC6LnUPLBwkdd7MUQUmc5zzp3xPlVDh1BuPY1kypZ9N7ENSceQ0dAf/rrIpyvp+mjD
         XKo0zXQsTmn/WzqmikAd6ZlDeY08InNxG3+gIGpbntVagHMAfqLBOGEq3kyIDoQ3KIvo
         bSEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ZKvcs4aaagkRnAdPinKYgTfXzFMyaAUyAdvgww4NHWg=;
        b=1CTHyOp1gJzFeqUEDfIaXxh4HQIwh9K0uBtS6DLsqrMVgiX6uM1aIBh9tWL+EsfXpd
         5DKPymCL8sCjzuhjtAnZXtHoSfozp5TeZOD9o0/h13lkhnvAln51/HvKVwZN7qmkxpcD
         IMg0uNn8K7EZwIqsI/jsB5pI6XrmFixHkGgnaOY8POf3XKWh/76EH/WdkHnTtwkExOAJ
         TSgrkAGtPVZ671tZCctUVOvQcNLOnbYGpRNHUmBdgDMQlZLFO+PgDxKl16D+s/+EaiB6
         e+oe4ogFXi77WyuWRcAozsyXzTLmQuGfD2KIMpIT0ssjFMz+UFy0i/VhQaQN+GXShMmT
         HbFQ==
X-Gm-Message-State: AJIora/OtpIP6K5Ofz/ShMDUKERfVj4R7+pbqgiS9A4fgOqpSdECmaAe
        q1pF3CxPM72LICZxBihjlHM=
X-Google-Smtp-Source: AGRyM1uTqVrqkMkQY8v0sYMyG8RTgqR4QjormIo6ABVt/GwMo7Y/alnCTRgijZRYZzVKhLKaBdDecQ==
X-Received: by 2002:a05:6870:b3a0:b0:10d:62cc:564a with SMTP id w32-20020a056870b3a000b0010d62cc564amr835527oap.66.1659049189279;
        Thu, 28 Jul 2022 15:59:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a5-20020a056808120500b00325cda1ff87sm757685oil.6.2022.07.28.15.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:59:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 28 Jul 2022 15:59:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/158] 5.18.15-rc1 review
Message-ID: <20220728225947.GG1979085@roeck-us.net>
References: <20220727161021.428340041@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
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

On Wed, Jul 27, 2022 at 06:11:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.15 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
