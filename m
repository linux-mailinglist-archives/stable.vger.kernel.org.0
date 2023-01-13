Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E175668BC6
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 06:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240043AbjAMFw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 00:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240048AbjAMFu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 00:50:59 -0500
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EAA65B0;
        Thu, 12 Jan 2023 21:50:58 -0800 (PST)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1442977d77dso21291523fac.6;
        Thu, 12 Jan 2023 21:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iN8PdIKfV8SEKLaPgSGNjfJOlVqIKSjOMfZfusWY68c=;
        b=TOdoQKFSh9QLIKZ9UKIUHB11V8GV9rSUvgvYQszZAZfMMr7mXM/W4gWfg1zOkHkTdb
         ViGDRgPR7fHzdB84PFLAViuccuO1UKgc01q9+hOSyRvvSVWhIbfr6ItSRuNSrkoiRVNm
         GPyy/WA4/g4C1rPjXCZ8ikrNBu0WH0yVl1PqE+PcPLOYH4bIof/VpSU4f2dkp1Xcyayr
         AscTdwaI9EseYcYsU+sAM8IKggaxAwlt9JZLEQl33PVZfSlOUctA9QyWPIkRQa+k1hrC
         9JdZAIHuWtNYCk56POWdtDBBhQcM1c+2HUBlfmlO1lMcmdS6ekBUYrFZ3jKMmGjEEkKT
         7NAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iN8PdIKfV8SEKLaPgSGNjfJOlVqIKSjOMfZfusWY68c=;
        b=PLrWdkH4sdzA3KGTqzuNhrcbMldKV3k7VIKpf8SNTtWCT59lr4q+1OZ1++yjZ/O6Na
         WFveLCeJpIJm3lWCKLuQaTRHX25S+fohgLGyHy89NJyXOKiz/6OPjUlR0Hm2wdK2jfzX
         1BK0dEFxSxywG9FzwGCXdsUIqExVeYJasZ0CqHTa+AH73gbPoouB+E3DCZ7tc/p5Hh8c
         Vgt1njd8KM8k+aScDFtQycf84CbyVzv4JjroOQcwzBTtw0XPHZeyb8C4YMOkEc1FhHxj
         hjCb4sv9qATLrfmDoPRgLosVCwNOZ3jJm64wd/EHrVpAozSxp9e/bWVlp3LkVePz6jlM
         Gndg==
X-Gm-Message-State: AFqh2kp56wOYInvIdY5OeO1tr/wpzJYpSBoj5i/NGBEt2yf971vHqKhz
        gp7sRU56QDle4lcM5ClAmqc=
X-Google-Smtp-Source: AMrXdXtOHm66t/4MOBAVhbrRMLgtWb8X57fr5JgiJCuq/WQ0ZvGlykZgR/EXqTKsGt1FryOToOV3bw==
X-Received: by 2002:a05:6870:fd92:b0:144:1fa4:dd81 with SMTP id ma18-20020a056870fd9200b001441fa4dd81mr37570454oab.57.1673589057269;
        Thu, 12 Jan 2023 21:50:57 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f18-20020a056871071200b0014f81d27ce3sm10137861oap.55.2023.01.12.21.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 21:50:56 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 12 Jan 2023 21:50:55 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/10] 5.15.88-rc1 review
Message-ID: <20230113055055.GB1591011@roeck-us.net>
References: <20230112135326.689857506@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 02:56:37PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.88 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
