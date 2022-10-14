Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063325FF69E
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 01:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJNXIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 19:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJNXIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 19:08:51 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0DFD01AA;
        Fri, 14 Oct 2022 16:08:50 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id f140so6213015pfa.1;
        Fri, 14 Oct 2022 16:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z3kS5rGFsI2YgJUdkW41f17zf+Ij8l+OKdaDJItzIOI=;
        b=XPTW8/1Naa0T2abiPFo5+uUGc3pfsyAGhsyxT3MELbJXZWti2hq/DUOR6acONJ0s7Q
         HAQ8LR0lO1NdH4BKX2i6bSVNUduQXcAfZgOq6PFbjq0A4Y2FMmMhB4ZSpUEe0D98C8l3
         o82bkl5l4/NVFqGKAnLCdOWFS3JGYmtLMv8zL8uEo5DcnyrFUyMrDWi33qmDo7UISLlv
         9if5J2vKbJvwZfCvm/vN7yATRWmlrKNHECrVg6FUngpPDcpvlLYKCGvF+oBjQqNj89G/
         iVWamSmM0ccM44rS6YwdOmSCqfmCkwWmy5lu202ydchepahv7MjfQ5Qot2vhpTgRNXh8
         UQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z3kS5rGFsI2YgJUdkW41f17zf+Ij8l+OKdaDJItzIOI=;
        b=24J3/ZZH+3/ZARAMm39OYpi/PvAp+qpCvZwDa6iwvRJivI4DNxnXIRKMmb/YSEP9Df
         Ta5vi1BmWDWmVJD7p7DVUs0Yf1eYwIilXS5DybJeLrsGSluAKcD46RQeheEUkbB+aaZD
         PoWQSpfIvtextzkxKmX85yRid5IZhBZORQIcF74KqtRBJUy9bRJSNCdxrf+d7pZ68DOk
         d56fVOgcbhrFGDhf1PZ5X1y4WLLcUZZThk5mTKnjG44vecR094QG/uLx1E31qHeu4oxp
         VmwD+zFWqpqHhihwuJcGe1PBC2mucw6xyJ8SLw6Nr2BCBkKozUawAa8BbwXQm12gEQA+
         62sg==
X-Gm-Message-State: ACrzQf103yCOnrJ1Ugy+stulTHaP1uHWV1RPrlS6x9pJ2LWzCA9h/YnV
        Iq/KmoVSgy0n48RqSv2908tm+xgt8pE=
X-Google-Smtp-Source: AMsMyM4yUo0vhVyxsc6S9RZYoL3fqGFxOoma08jvaaGGOtIvYl7WeUdA+chaMY5AciiXGzFengTmhw==
X-Received: by 2002:a63:1165:0:b0:44d:e5ba:5603 with SMTP id 37-20020a631165000000b0044de5ba5603mr209653pgr.68.1665788929974;
        Fri, 14 Oct 2022 16:08:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id mt11-20020a17090b230b00b001fdbb2e38acsm5472794pjb.5.2022.10.14.16.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 16:08:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 14 Oct 2022 16:08:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/34] 6.0.2-rc1 review
Message-ID: <20221014230849.GE4126318@roeck-us.net>
References: <20221013175146.507746257@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
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

On Thu, Oct 13, 2022 at 07:52:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 149 pass: 149 fail: 0
Qemu test results:
	total: 490 pass: 490 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
