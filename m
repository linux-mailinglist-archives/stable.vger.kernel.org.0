Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487D2527240
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 16:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiENOxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 10:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbiENOxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 10:53:21 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAD717ABC;
        Sat, 14 May 2022 07:53:15 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-d39f741ba0so14019968fac.13;
        Sat, 14 May 2022 07:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=48MgQAzUXegHD5XRY7NujwSFppfJ4jf1CM/UlJ6YWN4=;
        b=DF/tsQDtd55/iof7ggY6ka15plQZ7nD78ElOTE4u98vdwLbvCxu2db56yf9RBks+fn
         bpkjt2UfmypZHzoPeRsUP+qyyHi/S3yQkDfECsputttDpy6MvgrtNJk505MsG0AYJCae
         +X7dj1hXhiSE00wvZhb67Wi67GdSs0En/7LuAKhahghQGlXVYWDiw4LCC+2Q2PAK0uNF
         XHbgTa0cSjZLlFaeu6uNAisGYYP4xEmSQ4MN+cohNexQpySyWvKNeflb9lqJD9PmTkvs
         loKPwvlwBrpSfvAtQqR8/CTVszNwLqmOjK/XhS3AyYU/VoU4F7HrDsq+EtdHBcxj/a8e
         SWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=48MgQAzUXegHD5XRY7NujwSFppfJ4jf1CM/UlJ6YWN4=;
        b=12jrBlD1iYcN0ReC4Xst0yp8F9TaH9o14MdeTDAAk/TJ80TncoAT6h2abZdMp+94GP
         dmJfu5+CreTSKQhHuHSG0LIlaZToYn2Og0McFb45G0KHT8G58/t7Dvdy/T+uvwXvkKoR
         cLOUzkPnOuuao8g6Pjg+LaMF8OQtijStwKuRDyQrauyb+adDkvElA7UHFutwTs74eYMt
         CuQFci5twcW8mZIoznHeefVSubwrmHcb3xUfaL7hDc3KALltZcFmqsm9EmCUEzvg4wBh
         ti2uCH9UWPmxrfwBhrTwY0rc+Ln9Bl5kBy8xC8Pfx+m6lwz5QT0r6vxJXRZOElVKxKp/
         M8Ig==
X-Gm-Message-State: AOAM532bVmSIBtLB3CLB60ZGVp9XFk0443ALwIYz8EnP4lABhF3WTEo+
        KMwINcKSLLLMKrwQNrFHFKM=
X-Google-Smtp-Source: ABdhPJyokogdJfNsUyOEfdMmJu6L6Hlhe27+dfyNI9yya/f7r7MjRx+xcDC55IAjKB7RD98EFKj/vg==
X-Received: by 2002:a05:6870:7a8:b0:e5:d471:1e82 with SMTP id en40-20020a05687007a800b000e5d4711e82mr10821016oab.138.1652539994488;
        Sat, 14 May 2022 07:53:14 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u30-20020a056871009e00b000e686d13883sm2406156oaa.29.2022.05.14.07.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 07:53:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 14 May 2022 07:53:12 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/14] 4.14.279-rc1 review
Message-ID: <20220514145312.GB1322724@roeck-us.net>
References: <20220513142227.381154244@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513142227.381154244@linuxfoundation.org>
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

On Fri, May 13, 2022 at 04:23:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.279 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
