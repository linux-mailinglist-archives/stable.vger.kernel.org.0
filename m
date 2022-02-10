Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4494B1762
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 22:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243229AbiBJVB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 16:01:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242886AbiBJVB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 16:01:58 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E351100;
        Thu, 10 Feb 2022 13:01:55 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id i5so7412322oih.1;
        Thu, 10 Feb 2022 13:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rTL+jOIx0ycbc0ZqdvH/HmJ9lLyD9R34MHhndW8v9To=;
        b=fBQUDVQN1fmY8ERxtvCU2OQlzj8stU3CMX4XG9gp0LoGsU1ZuoCWxDXeK4cZ7ozWl2
         Z+63qCCWjnYkVu0H7Cbgwm/ruX9T937oR6XZ93wWb5A/d7ShCw2CXhMXkcSV1SuF/Iym
         OvQMUc4eiRVdMDvuKGvqXPj/Eg58HCSHJzBiCUvWFXsbMpLG9r+OAk41MtxzHl2VDUQg
         hW1BnO5httG+te9YraQRDolCUpEXtr1tBX5ufJu/Wxr77mrhTeXvbsN3z7SM/mM4M67/
         o3MpOT0RDzQQc0j4YffegrF7Ac1UQHMkPVKMw+Kgpd21nuHExdbYHDQDAUYfIbD6CUzd
         im9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=rTL+jOIx0ycbc0ZqdvH/HmJ9lLyD9R34MHhndW8v9To=;
        b=fD+AXXTH+2CNZfXcK0C8rq2qf0XWVEwulMEKeXR4dcfNDTkvJvnKkYf9crlYZpRzqP
         QPZz67BziPUV6yURFKgboKv5Jls6IRMQG0EygQByu7D0objQqZX6YEfwS0OTlKG1aql4
         5+wfwYSS4FlI8lFLxtHhaPfAZrup5F03Qg78EECBcVqHR0ugePeFy9v6IQBChMY6sBtR
         ztgBEN3G2mWb/67brp4o3JRES6kJGEUS4CLUWSQsHI+SqNA2De+74lZiMFAnHm5c0Na8
         C/xWt3JtpNV9CpCx2R2cUkRCcvkvDUYY/4h3FT1k2TeBs2kTrNpiM51pY+ZlagDryZfq
         h9uw==
X-Gm-Message-State: AOAM532C8xK4p1F806J8H6x3ZTumf1ocv8LpYdMqhRLkOG/zfBsu878l
        O6h/uUIHIfPRKJdS4cvsVgc=
X-Google-Smtp-Source: ABdhPJx7cwwCxPG+l92HyDw3J3ZBQ6IFrnOnR8+LDOY5krywxDKt8buxaKe6SnU83Za4sMe9IlyE4w==
X-Received: by 2002:aca:1b05:: with SMTP id b5mr1856428oib.289.1644526914296;
        Thu, 10 Feb 2022 13:01:54 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x12sm8270632otq.6.2022.02.10.13.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 13:01:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 10 Feb 2022 13:01:52 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 0/5] 5.15.23-rc1 review
Message-ID: <20220210210152.GE2963498@roeck-us.net>
References: <20220209191249.980911721@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209191249.980911721@linuxfoundation.org>
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

On Wed, Feb 09, 2022 at 08:14:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.23 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
