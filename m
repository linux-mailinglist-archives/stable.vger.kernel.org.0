Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A3B5ED294
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 03:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbiI1BUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 21:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbiI1BUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 21:20:15 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E848C84E55;
        Tue, 27 Sep 2022 18:20:14 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 129so9472624pgc.5;
        Tue, 27 Sep 2022 18:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=EfjcykYysmrMrcVMHc34lacAx9ujj9xY+RuwiF9DCOs=;
        b=V5mpTSUDsMgCua2csoE33irCKMmdwH9BZDlF15Nlng/FPORLrgOQqTJ2yGjeagUOOm
         w8ERDU5oMa1s8H1lDayETwttCW1hH8vT7w8hgcQkfr4ACTt8yNjOuUmwfK4z/BTbkFpu
         VrmWCL1ULxttrof4Jct2fa+vpNWYlmDiaBwq2mxCpswVqvPzGKYF84k3EFEAlWPFhvdz
         BP0ikI9KE/Yfo4TrDtzeE6o9zrWFnpH7xyxCvJpffLogFr3qfpCMNhZsZmolzN8wa5QD
         LADrEYiCjBG6PsnC0miclmvRTQr4/JE4Rhux44HfjQh8DJQMmLQxSuHFKi5ieC8Fa6tv
         q46w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=EfjcykYysmrMrcVMHc34lacAx9ujj9xY+RuwiF9DCOs=;
        b=gAo0Uz4Y4cki/BU/wHmkWZbqNnFGf4YKjqGc5s+E02MSZY6Csi7feg0UW0SR7uYpE+
         S1lEcDuCJCjHjA++e5n/dFJxeiIV4kd/n8jM+KB3KnDTQ27h9LXvAtj7Hz9UPE9LRLE1
         BtI0t95VjVsFeipkJVE8msd3adRHGSaNMigxczLGdkzzVQwrtiAnwNK9w6OjGv7hi58f
         k0UdeDJAmLUAULy5cp2GQsxsoLV507hI67tcFPwfferEYKs3n47pJVzXHyaoz1wLSxUf
         FTbYtd3aKfE1GCCMtPLJDpLNBmY1AuJiDxo6WDH0FnKcWZ+wvbOmP1Tcm5euPgXS2HTi
         NHWQ==
X-Gm-Message-State: ACrzQf37GqxkXPYCATHBaRHij/iXunSM9/sv+ET1sA/pdwvH7w/JD0ZH
        qShZdPiM8Br7m5G0J2K4RGw=
X-Google-Smtp-Source: AMsMyM6T5Auel/zMhPw6tcRQIVVXg8LzmbmFYM2CDXoTSmxhm7Ts5gSJ5tkwO95ygB4yWgUlLLy4Mw==
X-Received: by 2002:a63:fb09:0:b0:43c:b1c6:b335 with SMTP id o9-20020a63fb09000000b0043cb1c6b335mr12582112pgh.276.1664328014095;
        Tue, 27 Sep 2022 18:20:14 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o13-20020a62cd0d000000b0053e439c08c1sm2509442pfg.74.2022.09.27.18.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 18:20:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 27 Sep 2022 18:20:12 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/138] 5.10.146-rc2 review
Message-ID: <20220928012012.GE1700196@roeck-us.net>
References: <20220926163550.904900693@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926163550.904900693@linuxfoundation.org>
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

On Mon, Sep 26, 2022 at 06:36:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.146 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
