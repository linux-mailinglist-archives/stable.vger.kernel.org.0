Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B65D5109EB
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 22:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346891AbiDZUP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 16:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354816AbiDZUPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 16:15:23 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD1818807A;
        Tue, 26 Apr 2022 13:12:12 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-e93bbb54f9so7878664fac.12;
        Tue, 26 Apr 2022 13:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hgE+BdOV573YZ97n5UlVeZRSEGXPDDuZoEL7ZOySdgQ=;
        b=lJzHLhVZBto56sylomxS4NYQJ3l4heecvPegpAo5DN/6gfLhT3Wl5mRsPjcYOPyvpP
         Rb4fSv8Zkd7wlyPWZzjKSjc8EuyPddBNe4ICzryIT1TMrgkuP01A5McJ7SuMEZoiBIg8
         wzhNQOPKw7syWjWQg01jUcP31IIXv6Et/em87pmemj2tcoFJ6Jr4Y6Y9UUi/2Ab8K1WL
         DsQB1go6+BGNSbu2m0dF6+X81KPEdiejQRRqKiIi3teVEG1Xgrfll+m2VjqSgpuyvmuE
         KOJ+0L4fOtzFoNY+CYrg8c+5UlhK31n0fRn2ADNYpbPFUCRT5xQaFR7sys7cWtfFMqsF
         HeiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=hgE+BdOV573YZ97n5UlVeZRSEGXPDDuZoEL7ZOySdgQ=;
        b=2HE30oKxa1IdGd5P6DIBymhTvLfJNQJhFDibgV9tsv8uFl1w6jw+krgL2qgBCrOtuH
         tuDDMJL5TgDq71Np7qlcB2SB0biszcT+uthbkcYiyR0TlqdgK6PmKywCgKrRYyXpmHio
         K6bAhpeFVCpC0SMkX2wF5zd5fMd977z9U0uPvN3pTka+x/jFjDk9n5EPexeN25f+Dmu6
         ONXvbVLo1x+dpDCk/quvaASzQpDsq6MhQBHZRnSCq4ODphHgnlFC7cWqKJL0bGXEpHra
         MQzPTPGVcK+f7BC/WjjouoSC+9vIcIV+sE4jQmb+oUYPIAbCB9/P3zwIiiej0DUh+OpU
         cDhw==
X-Gm-Message-State: AOAM530C5dc9mP+OpJvE7Dr/r+WoFfzqQ0O1EbRLsYYR7xGTdTp1kcq6
        ALtIpt8cDQXfyMPBgdSXdLU=
X-Google-Smtp-Source: ABdhPJxI8DYAof3mcWoPIX2e7SifJbvbYOGrXsZK6b0x3SlsuhMx+CDRMGwqnpvcJuNF5gtjG1doqQ==
X-Received: by 2002:a05:6870:1781:b0:e2:f30d:3a6c with SMTP id r1-20020a056870178100b000e2f30d3a6cmr10326763oae.142.1651003932108;
        Tue, 26 Apr 2022 13:12:12 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i5-20020a056870220500b000e90544b79fsm1137906oaf.41.2022.04.26.13.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 13:12:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Apr 2022 13:12:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/53] 4.19.240-rc1 review
Message-ID: <20220426201209.GC4093517@roeck-us.net>
References: <20220426081735.651926456@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
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

On Tue, Apr 26, 2022 at 10:20:40AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.240 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
