Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F266BDC0D
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 23:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjCPWxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 18:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjCPWxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 18:53:34 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3946113F6;
        Thu, 16 Mar 2023 15:53:32 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id b5so1544678iow.0;
        Thu, 16 Mar 2023 15:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679007212;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8oRFDkjTItmRARF9MPboyy5pcC53D8DFiO7r4AdLOx4=;
        b=Bd7/3V61PyyseMyST3POk/iFFLs64mcNtbzneGvgXjwAHwoN787AWd0WkqLWJjPuea
         5z/MBP8WbYF8fdGz+tNmL7FgRsUIX4a2JjqxvtEslsvAL8Z4njloFPDndQMkLTl1xVc2
         NdvndADX1rsLdLPYVN9WvYFn8aHHIGI0LnoTveiNMXERXKEV47iGwFLQyMW46uuOeEzJ
         YOzByngT3mNfjkFKtppIJ38MwPabqkBn1zbanif+wLmKRxyh/Wz8F+WJcXUcMoT8qU69
         cEFSfaDGBgLL4kfeJuM74OLZ+ebCNT4SWshVr9XjEBC2x2Cy1PEm46MhKa7UvjmhLasw
         Ia0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679007212;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8oRFDkjTItmRARF9MPboyy5pcC53D8DFiO7r4AdLOx4=;
        b=0j0ps02GoGrn61eN26JbpQ6v0U+gHVAPkxRrWKOIJhjai1B2HQpmSxpp15PIeioyS2
         6XvgEfugXejd6G84V/XppfInB/72HRBI6BShPFIWgjqneyxBBM8fUgFGYFkuEWzMdkvO
         pxVAMmnM6Umj5VDj/6KjQ708/rrcsHROOwCW+6NJTLp/y9SfmzZSyNHGGQkhb9rRF4D9
         mdxJhMPT0QTp5yDkBiWLKsZ2uXdyAPHgIjyhYkRW+oiyGFsAR58gUl66JWXIFaVSikYR
         SaA5q61y6EFQ5JPF7sNktXX2Vyh8bDBRZcfX8fnCooG5xNXFqAq1CpHNEh30ZQtR7oQ0
         PoFQ==
X-Gm-Message-State: AO0yUKWwDc0sodztRZM8T76L6tTE/VGTIZlxFa0JpLKOroF+fgEjgK18
        Qm0DxxDzvOCK7ZyjzX36QUc=
X-Google-Smtp-Source: AK7set8TbvIiZSVTbzgAzem48+HVV7SREKPoXRfSJh69O43NHm9hgkjAEBeUv0X7fxe5D4kNPO+Phw==
X-Received: by 2002:a6b:4a18:0:b0:743:7742:1bc2 with SMTP id w24-20020a6b4a18000000b0074377421bc2mr364810iob.16.1679007212010;
        Thu, 16 Mar 2023 15:53:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g13-20020a02270d000000b0040306bfd949sm181096jaa.21.2023.03.16.15.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:53:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 16 Mar 2023 15:53:29 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/20] 4.14.310-rc2 review
Message-ID: <8cbf73b6-f9d4-42d4-9dea-545caa558958@roeck-us.net>
References: <20230316083335.429724157@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083335.429724157@linuxfoundation.org>
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

On Thu, Mar 16, 2023 at 09:49:41AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.310 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
