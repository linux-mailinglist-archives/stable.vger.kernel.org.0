Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98CF36B5814
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 04:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjCKDaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 22:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjCKDaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 22:30:22 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2479B12B3CF;
        Fri, 10 Mar 2023 19:30:21 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id n27-20020a4ad63b000000b005252709efdbso1084018oon.4;
        Fri, 10 Mar 2023 19:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678505420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RksO9bprUe5tFGfK4HSRowFsGMj7f+lh/jN8XoDWZoI=;
        b=UMZ0+JusnnT6R7rkGWI2kyRnprmuKJXcpPrq9SvQ6Kuj/AfYziL9PDSrtPHo5N/EUg
         fqaf1qvnMR9wPl2bkOGCE9HTH9AlUM5rZ2+O7BOkPklTc1FqygaRmmlFHNbZwrCgn98E
         j+yCDJUCv88p9L4aDdnRsm3o1dYyxJ3pP4fgNrjc3Xaqqbo978eqhk3Ir03OpUgAr4Jm
         8U3QH03BvcakzaRIeiPEuLstLA/DrmsCQtgx8eNXHN5kznfdKXqQdbTumMBPGbJCBb8V
         w8VWAyfZh1KwLB9jmpmxOQDFktCGvMpfsGjvqsBol6TNocHxAePmyXBD4tihcfY/7HWh
         iFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678505420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RksO9bprUe5tFGfK4HSRowFsGMj7f+lh/jN8XoDWZoI=;
        b=Kyhfg9zl743M4RlEM1cGgpJJ6kkFp4W0w6KIrhWrCrslT+tq4iLYeceksf6bTXmMEp
         oy3KFhokar6A6O/z6RgjWwoTBud7KHjEW0xVFQwFia6Ig4OjqMuVsuJp5ph/QGODYFhU
         UGoRioaQwCj662+HjZq0+7CbuwnzEbpESHR+LmhBR0GSZi0XfsnsrxpebUXHyMdjMN3E
         pUMfh5UAyPUW5fwbKXQGUTZY5zY7Ai6F01wwZqN9QUf59rkF5BCPieSoMqu3t8HaT0/l
         SOyuwdB/Ikn9yzXyoqAg0LSu3JgS2YCpI68L3I2VQSeUVKqllWM4+1bz6V0thyrb64g0
         55ag==
X-Gm-Message-State: AO0yUKWLD4CUWIvBeTYwOIX12XimNB7Vk+twGwV4mvVwA6lVfBfuo94x
        T5K7eNi/dFeIK9bqmmmoC4Y=
X-Google-Smtp-Source: AK7set9rv+V8xcHFPaC97QsI73P2OKWMI2AvZeD9ZNvXF36nx5hqS7GAMl/SNbseThTP/TEtgiYOQg==
X-Received: by 2002:a4a:bd92:0:b0:51a:186f:88c4 with SMTP id k18-20020a4abd92000000b0051a186f88c4mr11257141oop.0.1678505420249;
        Fri, 10 Mar 2023 19:30:20 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y8-20020a4ae7c8000000b005252d376caesm659775oov.22.2023.03.10.19.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 19:30:19 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 10 Mar 2023 19:30:18 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/136] 5.15.100-rc1 review
Message-ID: <335b16e1-3907-40e4-a4ae-7cafc78c41df@roeck-us.net>
References: <20230310133706.811226272@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
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

On Fri, Mar 10, 2023 at 02:42:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.100 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
