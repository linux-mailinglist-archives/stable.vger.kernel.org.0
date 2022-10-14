Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E975FF696
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 01:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiJNXHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 19:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJNXHD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 19:07:03 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9502827DF3;
        Fri, 14 Oct 2022 16:07:02 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id u15so6600953oie.2;
        Fri, 14 Oct 2022 16:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cXVBGKl/yHb8b8Zaf31BzJZAoKiIPZTKG3aJnAMNgWU=;
        b=NovdQnoNgERfINAF/msp7R3xXWkABBO7WRJVzRmIYOi0QcJuJYPj73p1iZw88lsVgb
         jqnggFFImJWAb9EFAhz2UmPbxSbMK6qKGDHDN+o8oNzLmaHyC5Lgeg06EFDecn8uXudt
         X8mZqjmiYUeNJ0W11l8sRBGnRtMDGlkXkgSck7vDcSo+mCORoOgff3q8lPr2ULQ4Ti/d
         eRAPRjZCfSKZ2ZxT+IVkJ3O5N+NizLHAoTTxd8KADDtXyPCcnF0woNNLd/2e7tYPneMj
         Y85uEGXpJrUFnF684q9ch/ikAabL1rhOvD+JooFB4Ec0uciraisN66QwbK7faggzdt1q
         gCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cXVBGKl/yHb8b8Zaf31BzJZAoKiIPZTKG3aJnAMNgWU=;
        b=UlCfGrrTdNXMpDvsArD5yT3t2FA+sP8RPy4zpX/6HtQ/oHv8+vw+GpLBR/k/+b5Akf
         wCX0PzNov5FjU74Qkau/TD5aoK+bhXudWjpY/hdCgaZkYrJ7vwAOOuBujXHr8zC3iBoL
         gDv3dcGoEHhft+FQY2IRmioJYWZbSjVVnSL57ylCKhDL6MT/41yv8MDdB+B0g/eFEWea
         s+gdHwzz5BPdX9kVh2XZBjbVSQEt0DktpfwjlqlAXMHUGjjhxo1FceVLAvNKpwlsIfcK
         b3amr2yEaKO5xX4ouYkgbE8OnceiMK+1Etxx52PQzyKBp+Hwx3PZi1mKIQ3Zp3mWPr9q
         B9uw==
X-Gm-Message-State: ACrzQf3gmRjBBOST5CFVDm9VHxFxqB4DR3/i0gaTapYyTkywokKHKXWh
        Tijbw0HNfYm3lwoFsiFvwKk=
X-Google-Smtp-Source: AMsMyM4N7jIf9HxBb7VZVh8HWsero0n+dADBi2LuA7HilpoacyeHl5xeOvF65hr3XkCSXxW9J6VYvw==
X-Received: by 2002:aca:bbc3:0:b0:355:18ba:8168 with SMTP id l186-20020acabbc3000000b0035518ba8168mr84005oif.273.1665788821944;
        Fri, 14 Oct 2022 16:07:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h20-20020a9d6f94000000b006619483182csm1826890otq.18.2022.10.14.16.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 16:07:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 14 Oct 2022 16:07:00 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.4 00/38] 5.4.218-rc1 review
Message-ID: <20221014230700.GA4126318@roeck-us.net>
References: <20221013175144.245431424@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013175144.245431424@linuxfoundation.org>
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

On Thu, Oct 13, 2022 at 07:52:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.218 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
