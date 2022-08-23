Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C0559EE22
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 23:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiHWVWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 17:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiHWVWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 17:22:03 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CADF7EFF8;
        Tue, 23 Aug 2022 14:22:02 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id jm11so13916628plb.13;
        Tue, 23 Aug 2022 14:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=LjC43IYMNEf2pVDnTl+cksQfxh4VyZBw6nZxPgO+ZeI=;
        b=U5WInIgT36mTSMtIaUT1F0sf62b0NAe5BC+eXq95YA4kT7/3GTMfBU5YsvextOdLjM
         GQmEH0bTLovrbwR8Yh0zehoXSwhaSNz6Hxq+SAFQlR+bsviQwyRZRgeNoB0ipz6XbChh
         NAXQeRUn5pk20gXx8Wcuggl7cZ0ImxFy6t864WR1lsyyCfmIlvTBMiTUovkoKe0wZkpt
         37H0JUtuJZMD/br6R16tlvZEPSkgC84PXaxD5U72MsJ9xyIx9Nu7U8Gh12lUECsALw2R
         L6GBfFn9Pr/V7eTpZ7Bya7H2v3qtIna36hLAaF7ey/3Ntzq+xgFzTzdAm/xR3vOOx4a7
         1YQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=LjC43IYMNEf2pVDnTl+cksQfxh4VyZBw6nZxPgO+ZeI=;
        b=nn3zvmD53zup0nDb5Vkil6adnBEbv7//0c2LKjZD4LIT8loQtcPB2MnxCAFp0hHj3l
         d8pT//UxZKh/xCtK+uQ1srcA4kd9TVWc27H9QJoEHVYcBt0M7vmJEKyI5C9A6GGGmaxT
         Xv4Dv/BjwQu4Ddrh05bkoxDIiFJcc7mepWjEkegQW0vVfaCpxpd0nzZ/Jr83VRXcEeNt
         XoNuuGV4zRTDT3FoXafwd5dkRieGZkfVEHgHetxrzwTMpNW3+5ZY80MM9oGNm0X5EQ0K
         LdhH5A4vTYBXXMsFEbJF95Kc+ZcQNkSfTvez9NpaJeYtmuGJBFBqEIvztseTeydq3GQg
         FljA==
X-Gm-Message-State: ACgBeo3QCc/nHpcGZEFNLJAc2M6+ILMdO5FwP1x+FhI5plG1P+06hv9i
        kJ10/tlq5KOsQgoTenG+vEY=
X-Google-Smtp-Source: AA6agR6dvnzPFU0GYj2y2bdu36cD5LQIv8BTGe80qWq1NdW6aeyfLNpirkA+aTK/d3QHlS2MqPn3KQ==
X-Received: by 2002:a17:902:c153:b0:173:28b:3615 with SMTP id 19-20020a170902c15300b00173028b3615mr4218901plj.113.1661289722179;
        Tue, 23 Aug 2022 14:22:02 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v15-20020a17090a6b0f00b001fac90ead43sm10355054pjj.29.2022.08.23.14.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 14:22:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 23 Aug 2022 14:22:00 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 000/229] 4.14.291-rc1 review
Message-ID: <20220823212200.GC2439282@roeck-us.net>
References: <20220823080053.202747790@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 10:22:41AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.291 release.
> There are 229 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
