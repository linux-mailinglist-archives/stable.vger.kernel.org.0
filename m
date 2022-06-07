Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F981533220
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 22:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbiEXUEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 16:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbiEXUEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 16:04:15 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7A352503;
        Tue, 24 May 2022 13:04:14 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id v9so18043746oie.5;
        Tue, 24 May 2022 13:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yLfeKTjGeNjq4pydb8sIhx4QDa6vKoPJOclK+Nm5+jg=;
        b=qQ5rullHayRf6ZadggOtgs849+Nxvr+E0px5v7txi/F4E7KzwYDsJjCgjb+1xkl4cn
         88pJkSOi+tv62OwYG926VmG67J6OEQX9hx05lMM3AuqF3gNeCrThzdfJD1Y9dhk0jrSk
         dJf9KwV9lAhgTS81HHQJKN9nSpO3EI/hZg5dCgEYral2t1/06LczGTV3SGhYRQYb50BY
         Nnp1w6xKkDknNtAQt0CBS+CLk2gM5nIligaaeGmoHtM6X17+UTMgMSTtAHiMB1B+wy23
         TqH2i4G15RK3UAGIeVXlE/Py1QgIOFiUyXVgBxu6inXvRXSQ/szDdFgoc396YrHy2FKu
         n6hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=yLfeKTjGeNjq4pydb8sIhx4QDa6vKoPJOclK+Nm5+jg=;
        b=oheYUgtJNkItTlhvmbaTuzlRXQ3e4iowoL4dFneYwBC7lEGAbHm6npUbb6LWN7avP6
         ZPwc9hlf7YKycx9EV4OZu6MAHFtm/T5PBVWHaRh7AvgtF2GSEm4TD7qPsKqUwWw0VAlo
         nn8tLh7HAUxH0e4w2P6JwiDt+OpOA+jrm8V9xUyNCi6IyISKrMXgYNgOIJUhqrcZnCzH
         1O0FiuWcuxiTASz6uAOdKQc4u1CQgxJM7of/Rys0s7Y1BkytKIIXVAkO9BLfVawvqKME
         NRAohYrU7zljY9/l879bp2CMK3tgw8CebO1D8RVHTovf2f31jFbCvU/lHc6zu5XY+7JG
         19GA==
X-Gm-Message-State: AOAM531eVVYsMwZBNMNugfwkMqFJG1VDX47Up59wOvbQL3VYUXoThF1G
        nXrDtfl5bFsnPcIJrAROpJ8=
X-Google-Smtp-Source: ABdhPJw1WEUk/qu3M55jm5f4otiTaJ3O627T57dtMNDXyhT2X8FQXz4jO6F8AERrdh9s+zNWI4IHqA==
X-Received: by 2002:a05:6808:1693:b0:2f7:2aac:b47f with SMTP id bb19-20020a056808169300b002f72aacb47fmr3230640oib.104.1653422654302;
        Tue, 24 May 2022 13:04:14 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l8-20020a056830238800b006060322125dsm5511288ots.45.2022.05.24.13.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 13:04:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 24 May 2022 13:04:12 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/97] 5.10.118-rc1 review
Message-ID: <20220524200412.GE3987156@roeck-us.net>
References: <20220523165812.244140613@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523165812.244140613@linuxfoundation.org>
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

On Mon, May 23, 2022 at 07:05:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.118 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 159 fail: 2
Failed builds:
	i386:tools/perf
	x86_64:tools/perf
Qemu test results:
	total: 477 pass: 477 fail: 0

Failures as already reported.

Guenter
