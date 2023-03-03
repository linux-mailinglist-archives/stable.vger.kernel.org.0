Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15BA6A8EBA
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 02:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjCCB3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 20:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjCCB3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 20:29:32 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FCA3D919;
        Thu,  2 Mar 2023 17:29:30 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id i4so843799ils.1;
        Thu, 02 Mar 2023 17:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677806970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PxQNEiPDmTPJLaIsg96dsFSfhrhfU30ebbBE9xZS008=;
        b=ho28SczbORY4AnVI6w71l2fRc89s49trtyWRtkf/dUcCqtfsC1gBc/TwzwCBc1mm3H
         Wow/wsRQVZUsMewx8vjzYsNiqccs+bOCdd408DDNTuoMFCM7bNgae8aZWBHSBCiSM6Ha
         0STPzlOpHfqKNXDefom/zu7rmcln3dhAzLX2MyYcqedHiLS4M7sFIYDhb1r0aHFy/jpN
         QOJ7rpAfqFYwbMqU9ydQW//tyfcprVr8eHc8KnfiUfOYSvW2rN0IThS9NFnBd1lM9fZq
         FAp3+4B4LkClCXJR//znycJMrsvDP38A8Ie9GKouY4456+/tfur8/HOj/nMaNHfIYbKr
         7npw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677806970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PxQNEiPDmTPJLaIsg96dsFSfhrhfU30ebbBE9xZS008=;
        b=Md0y4ORZhqbbaMVggpYFBM+1zJXR03JSlgpMIw+yzvFZQw9chHRfP7unor5TLv6mZH
         ij0RqTGqXdBgqVfYHaYB69eX681suj7P+h1koyMIFibsw1AdSOnaFyVbRyjyyxMbEX2n
         5MF1b9jDKJZhz6jBmPtn1eQr9ZJBsKyXzgMWAN9yO9SsGR3wBjTSgJq1LbGBMxdvCYUW
         lDsSxjdlywnL+b52KRvCByv49VKLMAaWWlI6zb0NTBsXQbNluDwacre/17R/RiJm/Hao
         bfKed1aTx0AdPGXsrQ6tLoXPdmbLfZUABVDDZgqm+y9nsLCjf/xJODlVk9bMkj+TCjJf
         iCWw==
X-Gm-Message-State: AO0yUKW2doLBkrn56HdOWxvQ6hWiWx10CPRprQiEdnajwrfA3EBL9Z+9
        zUcFcObGA9IMAtke7kfvF9c=
X-Google-Smtp-Source: AK7set+lSm+r4B6lpAtZ1fIuHWIKXpNtAuZBNyobZm/IrUN+9aOIVPrd9SGwZ0UHwt9OolEVq90J4Q==
X-Received: by 2002:a05:6e02:1d8f:b0:313:ee3f:2b2b with SMTP id h15-20020a056e021d8f00b00313ee3f2b2bmr490126ila.8.1677806970134;
        Thu, 02 Mar 2023 17:29:30 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y8-20020a92d208000000b00315972e90a2sm239457ily.64.2023.03.02.17.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 17:29:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 2 Mar 2023 17:29:28 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/13] 5.4.234-rc1 review
Message-ID: <93fe1762-ff43-4e6e-8adb-fbf84235aafb@roeck-us.net>
References: <20230301180651.177668495@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180651.177668495@linuxfoundation.org>
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

On Wed, Mar 01, 2023 at 07:07:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.234 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 450 pass: 450 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
