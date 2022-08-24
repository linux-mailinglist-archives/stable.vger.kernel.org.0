Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F244659FFE6
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 18:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238988AbiHXQ5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 12:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239415AbiHXQ5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 12:57:02 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0A754CAB;
        Wed, 24 Aug 2022 09:56:56 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id e19so16455026pju.1;
        Wed, 24 Aug 2022 09:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=SceAg9VDgqxW5h5TCnfh6zvPvCZkruQQG8Pk3ldGenw=;
        b=jzYcU7x50T5ITKNUyPEPPDKQNhqw28UUFg5fIN8ELKM2tpPHUcJ6LoSSXfXHqgNF40
         v2leaku+C8o9x1aZ/CxVB049o8GRfjdYBhQr0/hzcNrJweEEEfwf9QdBBB1MfrprQAAA
         qHPHe8VRXpVxJRNFoyOBaK5zA7lkCVmB8cascsRrOjUOT5MwjeSok1o+5gyQaZ90ON+J
         GndfjqRkVZGHFq/0+nBwaYNlRonjjRi+XbILqlWlfBtyrMXZI1xqh2j6xvMS2IXYSfFb
         neekiUkYyRHnASV2j5a2aK0z8DBIunEJ160brYvm0qfPOCXZLdM3nRq9Q9ofDNgbBIwU
         p+NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=SceAg9VDgqxW5h5TCnfh6zvPvCZkruQQG8Pk3ldGenw=;
        b=iuQMWGEFEv07fOK5n9kBzUTM8pRKuafpXLsta69ZdghTR5fdi7gdrpg7zUsI2X4EN5
         m702wYl2KhhDMhRIfYjszySfkpwlQuBcveuYS0UNaFj3gLoX9i9aZiqtkQ9b0xFkmVTs
         3OEhsfX/NpU+7/UDAuHpSh4tOiIcZj0+yuFwFbAkSqepwzFy5NsPZLApJ2WLevd2qU99
         OsfJG0+3xLh2vv0Q5oLG1vAU5j00ZWhG/dpb1RbG5AsLRjqPjDFxGUdGz1b+7JczA1lQ
         MC4gBzM+yjHF7o5Pei27CJclM1lGgf7535XMU9iEmnfI8kQPb4/d8+4HiA+nVkNm+3ya
         EpQA==
X-Gm-Message-State: ACgBeo3+9bb3wYItGFJ7vjv4HunJpYwq29sQ7VK+KD6gq9WQ9EHJcT3o
        8oJryMAfSil0ed5072vk9YI=
X-Google-Smtp-Source: AA6agR6OyxDY+W+dOYp/afoGy57sW0Sc9RTk1lR8reRhXgts88FIasW8hss9eYNeqb65CgVdtRyd4g==
X-Received: by 2002:a17:903:1d1:b0:172:e12b:71b2 with SMTP id e17-20020a17090301d100b00172e12b71b2mr1399plh.60.1661360215867;
        Wed, 24 Aug 2022 09:56:55 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 75-20020a62144e000000b00534a7a127bcsm13199739pfu.164.2022.08.24.09.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 09:56:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Aug 2022 09:56:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/362] 5.19.4-rc2 review
Message-ID: <20220824165654.GC708846@roeck-us.net>
References: <20220824065936.861377531@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824065936.861377531@linuxfoundation.org>
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

On Wed, Aug 24, 2022 at 09:01:14AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.4 release.
> There are 362 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Aug 2022 06:58:34 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 150 pass: 150 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

The spurious s390 build error reported earlier is also seen
in the mainline kernel and resists bisect due to its randomness.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
