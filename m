Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D655FF698
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 01:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJNXH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 19:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJNXHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 19:07:25 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B6F40BE7;
        Fri, 14 Oct 2022 16:07:25 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1370acb6588so7539455fac.9;
        Fri, 14 Oct 2022 16:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aGN90qXUtT0hNhNf1Qrc4rMUhFacnFtNoa5My8horJk=;
        b=W9UEpY8lBMmgevSq7kcjP1VUWOGQN1V1R6WK2YRGHJWIp7xkp8pgjOOaSzRCqOQzNF
         cpT+foY0yFRasAp7u7CFnx+obsToe311nY7DbVFIhgkfu4q954lNsmzKEdd2QRBI119I
         kXoGf8q8dQgR/1M4MQYTfmrmeLXWydGoDTz78DldsfIy3os1g7KHnfi8qJdQeQmGzb4p
         vB3mYq4T73vdiVoLicnoS75XCnULxQTWUVtnUADEtuZAcTfqkhsbsO+tLROLc1Cj+Jk0
         zhHWFxGsLaVhHXx+tdQHcbbe6dMAlWbe/Y6Uzo1Lm7YwARkR+m6dX4pgM5kP9OJcRLji
         0uMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aGN90qXUtT0hNhNf1Qrc4rMUhFacnFtNoa5My8horJk=;
        b=OHSgKTLBWAL3hU1o0wDF+ikSitlhvnLGMIzYvZo3hcYE8sOerUXYyL7rQ0RFlPhK2d
         mhzeQ1yATbaTV9YxLHtChXCEtWrsoDxUrEOfrdnGBEL6yVLxRwWVESRyjkiO3MRGphnj
         MDoxm8y5r9XxbCyG50jHEvpCAXSb2ER9k/ykPlPK0abKNKbeOKX/VVxgomf9Gm0hiQHk
         gILXwwfDDdisUDhNtcUrqpRz+FMEv8BHQ5e2DL4E1mcAcqaR7RDw3Lubirs1oP4YErmP
         Bg58WKovSYUzHBxhKcgzGCh3RvLvzaLYmocl8uFBB/TIt3OwfTOvxFBmnMUBKPpePLQ7
         Tn0g==
X-Gm-Message-State: ACrzQf37LLwv8/ZdDZZTKQkbuPOvySP2gj9sDib3THPk4f2QpdKz67Z1
        jOgikjQOVcj8s4Hh88rwU+glVicRNOs=
X-Google-Smtp-Source: AMsMyM481CPPFlCvYrf17jIyCm91Peg7rkzEH/5yltbOJhgHrLqJlP6/N0PuAQj/ZVGGnVFPqifgvg==
X-Received: by 2002:a05:6870:c897:b0:11b:de9f:57c2 with SMTP id er23-20020a056870c89700b0011bde9f57c2mr9269190oab.267.1665788844302;
        Fri, 14 Oct 2022 16:07:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q28-20020a05683022dc00b00661a0a256ffsm1778236otc.81.2022.10.14.16.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 16:07:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 14 Oct 2022 16:07:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/54] 5.10.148-rc1 review
Message-ID: <20221014230722.GB4126318@roeck-us.net>
References: <20221013175147.337501757@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
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

On Thu, Oct 13, 2022 at 07:51:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.148 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
