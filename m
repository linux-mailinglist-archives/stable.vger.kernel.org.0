Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B095228C0
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 03:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240076AbiEKBML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 21:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237603AbiEKBMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 21:12:10 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655B31B216B;
        Tue, 10 May 2022 18:12:09 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id n24so971793oie.12;
        Tue, 10 May 2022 18:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5zL1rvRXChrgrOV8kBBzxhJFHu8SmGG9iJw3K7WpYEo=;
        b=EfNo5m6zs2LTGkiGvVEVeM7t61HsS/1uBbZNOKiebLlDEi4K8YI/7KlKEs6FQLRZZC
         9IHadWterwIt/M9in7EQb6xPMOOhkrgA1Jp1VcpUywjD/A1diNkuYOJxlEJpuah5P41T
         nLAzncypC+3m4wlU1FfD42D6hUll4Vth5jpmpZIU2gTbRz6Q5tzLUUqPMcAWnKQc8r8c
         57ijSQ80lYIInZ2OWSqTLbShsbTsF9KFfY1J0GWjp8ukMESdQ3O8C1DyzCiqi7+UqOwy
         zUbNj7oFMOGgrv0svTvn0AyocudGsKo2XDLo4cuvoBjISMEGvbdJyQwYLZgopS7M+j3J
         Jhnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=5zL1rvRXChrgrOV8kBBzxhJFHu8SmGG9iJw3K7WpYEo=;
        b=TEetBno21SyKJY77A4Zfmqv94VjregPycxMEwxDFEHmO/h3XQEFSMSFnjCPNp37sAZ
         Vh4FWWZzjuDo7oxWaS4FatvfWSxX8wfOS9BIgtXoRHf3EGSzhrDAOJKZ3dqhgLgbfpQP
         KQabDvyXYJ0KV2o0xgb3FKUckiphc7iuUFiWFUwT0I1D/zWAOfk8Sfae2h8PHQsqxL0v
         FEVYxB5MZEZ+gDp1G9meYnCPLoOIXv/qR7j7Atw1S3TD9OxahkCOePAnupjpxHei+EHN
         COaEk9h/fqGtvyEeN8nw3vpbWviOx9NeKtgZFhmUCWr597tryFSUFSzLMJj0g2hgbrtY
         iAdQ==
X-Gm-Message-State: AOAM531pEjnGF0z7DepNCLvLgpVeV/qzI7Me9uOfQksMGnAYmP6Vt4UV
        TYRR2wWsEyjlYI0eBrr7acs=
X-Google-Smtp-Source: ABdhPJzngFIxjGtOA0r7nj9yPDkUXYpJ+UnAaH+jn1I8BWf6abJQywbbx6+BiN8ropHf4579KXDRSQ==
X-Received: by 2002:a05:6808:1da:b0:325:bf8e:df25 with SMTP id x26-20020a05680801da00b00325bf8edf25mr1356793oic.99.1652231528805;
        Tue, 10 May 2022 18:12:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i11-20020a056808030b00b00325cda1ffb5sm217057oie.52.2022.05.10.18.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 18:12:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 10 May 2022 18:12:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/70] 5.10.115-rc1 review
Message-ID: <20220511011206.GE2315160@roeck-us.net>
References: <20220510130732.861729621@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
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

On Tue, May 10, 2022 at 03:07:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.115 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
