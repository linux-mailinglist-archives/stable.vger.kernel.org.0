Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496EB62224B
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 03:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiKICys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 21:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiKICyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 21:54:47 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7592322BD2;
        Tue,  8 Nov 2022 18:54:46 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id cn2-20020a056830658200b0066c74617e3dso9451123otb.2;
        Tue, 08 Nov 2022 18:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZI91qSyXBgg5eWntb5w7n4ZnK6DuW9VOjYf9yRXokSE=;
        b=cXMFmMvjmVjDuBDmuK1SNRh4KiUO3IUSV0k3dSyNVmXOiQOr6uUqKMJPmTd9eASZw4
         sWVyHI0WnT8Lort3i7atOLWQSrj4PFbSAiLTO4rn2EYzgDwq0HCdaFqtzdgtE0+DLNbA
         hc+fTdnAwIZiO5SSzfOu64mG56V+9/V0hZ9AS9xUUYiKCuexjhViEpDJcbGBfEz8JoXZ
         LRTFv+b06lpAP+jDhr7SFsIPLIXdXc9mtMJ4kBLKz8A0nRpoS9iXftewIs9CDxov0Hfa
         /fiV+lziClyW6UPeXY8Cl+j5TN/nXmGwjPzxd1DN5fE11FwSXZOsFD1KzhqvORx/dol5
         gTww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZI91qSyXBgg5eWntb5w7n4ZnK6DuW9VOjYf9yRXokSE=;
        b=fVN0dXR89wuEb5eRi++MjM1YB6leYDkC90SEDhmfKfOOo1BKlEywZRI+PfstNh4fZZ
         Sc4t5FgjHNNomy5X/IAAvr9GhiZjd1aJ939UZ9zbBvtI/urSXpKTSsSNRzowz1WLleuV
         /9VbY9zFdV2MtL8sDNVb3fUAp2GS/7lsNh2rlHrbbuaCaJJxxHZW7mrQvG5bvCW8ODSA
         EJfwYgup6g0ALhffSnjoCdDmmAhKI+BUzy+z78qtJ25qCLARrfvx7gYxsna7S0mVd0wz
         Ck4g59PYG78YB/4bhR8jU2tuUgOFWvRGjLrP2ajGjs0gjGpkmrgDqW5MIVGLZORSSN8N
         4edg==
X-Gm-Message-State: ACrzQf2ApXcUy7Bt31VnTZjzwxE00u0w7nWgl2+dWh4kR90WCzIuVQq1
        r79zHEXra5oAQSRCuT7FP74=
X-Google-Smtp-Source: AMsMyM5GNCN92gKAwahnOWtJcYJg8dzgcv5QRL2staVnafL0b7uBDsOXWSq4dS4g96zgJpsJk1RoeA==
X-Received: by 2002:a9d:4690:0:b0:66c:5830:426c with SMTP id z16-20020a9d4690000000b0066c5830426cmr23853563ote.144.1667962485744;
        Tue, 08 Nov 2022 18:54:45 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o84-20020acaf057000000b0035485b54caesm4177955oih.28.2022.11.08.18.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 18:54:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 8 Nov 2022 18:54:44 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 000/144] 5.15.78-rc1 review
Message-ID: <20221109025444.GB2033086@roeck-us.net>
References: <20221108133345.346704162@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
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

On Tue, Nov 08, 2022 at 02:37:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.78 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
