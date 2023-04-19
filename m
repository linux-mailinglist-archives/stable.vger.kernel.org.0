Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B736E71A9
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 05:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjDSDf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 23:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjDSDf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 23:35:57 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA8E40EC;
        Tue, 18 Apr 2023 20:35:55 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63d4595d60fso4172229b3a.0;
        Tue, 18 Apr 2023 20:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681875355; x=1684467355;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g6PuzmuUY8jHhiY7WeAnASdzIf7vjuTT8wHkTuOn1oE=;
        b=DyFBm3PHi8J9g7ZrM8qZjEyTa+Rk8HEiSZ/JmMj3ilMojSjjnJXBCE09vaiXnWoAAF
         W7jpuoY5nw60mbjqvGlUlcXIn7NA2HCp4ik+UjhTX0W9n+vFZoMele03B+4XGP1SDvld
         9LNG/9xNsaPODRiE3fvScUgSmZez93cPCneXXWtW7cI4tmaoaItLT3mCoARBxGjJ3kYk
         9gkK2w1IAT338AIGob+hKVpV7O9h/Maz0IE+yA4XK1icWYxyfgr4E/2eS1XAMYUT06us
         g92eDutPlWYdIK5gf/9qqkA0+CcvQyoaGo1yzDCeiBLlpm8N1zf7lePli5ZJ+PPj1Uo6
         uX3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681875355; x=1684467355;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g6PuzmuUY8jHhiY7WeAnASdzIf7vjuTT8wHkTuOn1oE=;
        b=gcYAo1Y/j3/3Z5ghrCy3tov2zBX29TBw82FhkTZulMhVYK6G2JU7Q2beEo4m1lb3Q5
         4ZwKOzFD2vWE1n0MPofIgU80hS6Hi7V4dGdyg4+yfIQ4R5278VnLXCbGrlQKP/2B2vxb
         fGWyMEssUqncXidyGQCYFwaOC8TySEmRGWBgTaLM1r7Smy5d0I9ii2IjRVwDBABJE/pd
         /zn4oiRVcC6tEm2HxmO798WrCFMfiStU56SnSlpI0ikJkdqf3gSl+lnFuJDJh5ulmIUn
         o/bvHY+2b1Vc/qBxECoPCunmWEE0TK/2IYaadwbXYgqYR5mCLbhbk9CdQormRG3+rykm
         t6GA==
X-Gm-Message-State: AAQBX9eVI/B9I2zo+Zo4/ORCA1sym/52eA/Mbx5D8TLlG02lm0LCl/8G
        d+gYkql+kJstwOwgiPNsFhE=
X-Google-Smtp-Source: AKy350ZpI1YRgG+ADC9n6xsZoNwqBan/C40lNHS6eBFewR0aWxflxerjp5JW5Mb+qc/tg/D0lbJQ0A==
X-Received: by 2002:a05:6a00:4285:b0:63b:8da4:352e with SMTP id bx5-20020a056a00428500b0063b8da4352emr928270pfb.1.1681875355001;
        Tue, 18 Apr 2023 20:35:55 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x8-20020aa793a8000000b0062ddcad2cc5sm10061831pff.30.2023.04.18.20.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 20:35:54 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 18 Apr 2023 20:35:53 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/139] 6.2.12-rc1 review
Message-ID: <090c2946-4bb5-485c-8c55-58e6420a8030@roeck-us.net>
References: <20230418120313.725598495@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
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

On Tue, Apr 18, 2023 at 02:21:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
