Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD17459B518
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 17:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiHUPc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 11:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiHUPc7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 11:32:59 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1E018B25;
        Sun, 21 Aug 2022 08:32:58 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id bs25so10460114wrb.2;
        Sun, 21 Aug 2022 08:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=8MV32+Yt9m7Si5QwQLa4b3PLlpDqckrFp0ZXYWUDDos=;
        b=NfDG8DsV7gJdva8ZhPOfYP8oH/CZM6cWqdSzl+jQILATlYWT4PXV2EsgUly3TyR1aI
         FQfxS4phuKoDKwRsUBFya4KshB62lJPmuuevj3ihZpD05lr59cRv7B7Fn3UT1vZPWNlw
         nFvxbAl5k9avcgruQQMfqFrTq7W2CtyziaFTg/IRihCih/85DXhxUY0Sajl8eS0AwA9p
         ZGIJ4Ihqg4fx+e1iKXt0cG63wq3cFyUIRNdtJ84W9EaMdfqr3THgJdjUnzliLKUQep00
         yULm20CXE50JSwm9zU20Ub1H++buQ6r26dVXY1J/oD9sIV5zy4PjzoUM1OQSifNA245S
         mqug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=8MV32+Yt9m7Si5QwQLa4b3PLlpDqckrFp0ZXYWUDDos=;
        b=hIP1Tk9qFZpaEBv+5KyusWRV2W3Ov3Puc7nSvcI1TQPh8OyzGJeOeWLviLu4/Ky801
         XOL+mUEnUDDg7Au6qGtHnGjocn7EpoRSUDD91uwtFQyXgQNPvxshrLO7tm+7eqIsddwk
         sDltfhRTO3Es6ADhPm8AJSMiedNEisxN8AYuI6L518R9e+dUj2Lb2TS3mbtgaWeu4IxN
         nhdeAjQc+G59a6nFAcg/pwTSgxxERbnwe3+y7BgJRVUrEWN7b/yLGnNcNzjuthROsRHk
         umzqaSEzXYAkSBfhNiVPcuQ8aKR4JzMg+3J+LQEd0jejcppn+kPU4MjQ3BCafZi6jiEr
         2akQ==
X-Gm-Message-State: ACgBeo1bqpZ5lottArdYUG1AhOWQ9Kpc+N6m+uoVlGVB0X0ufuGG1ar3
        Gx/zPKJH9srW1Sv6btMleoI=
X-Google-Smtp-Source: AA6agR7taoznKUYDE3QoriSpfUsWWleApS9nfWNXRocQa0hmQRiAAOxRR2w4xe0OMrBK/Fm74ZRvyQ==
X-Received: by 2002:a5d:6c62:0:b0:222:cda4:e09e with SMTP id r2-20020a5d6c62000000b00222cda4e09emr8666167wrz.449.1661095976550;
        Sun, 21 Aug 2022 08:32:56 -0700 (PDT)
Received: from localhost ([2a03:b0c0:1:d0::dee:c001])
        by smtp.gmail.com with ESMTPSA id 22-20020a05600c231600b003a5260b8392sm13762440wmo.23.2022.08.21.08.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 08:32:56 -0700 (PDT)
Date:   Sun, 21 Aug 2022 15:32:55 +0000
From:   Stafford Horne <shorne@gmail.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/10] 5.15.62-rc2 review
Message-ID: <YwJQJxpsRDc6dqTJ@oscomms1>
References: <20220820182309.607584465@linuxfoundation.org>
 <20220821120903.GB2332676@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220821120903.GB2332676@roeck-us.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 21, 2022 at 05:09:03AM -0700, Guenter Roeck wrote:
> On Sat, Aug 20, 2022 at 08:23:24PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.62 release.
> > There are 10 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 22 Aug 2022 18:23:01 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 485 pass: 484 fail: 1
> Failed tests:
> 	openrisc:or1ksim_defconfig
> 
> The openrisc failure is a soft lockup during restart. I only recently
> enabled the soft lockup detector, so this is probably either a false
> positive or not a new problem. I'll try to track it down, but it is
> not a concern for now.
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Hi Guenter,

If you need help let me know, just let me know how to reproduce it.  I am
currently working on some qemu patches to convert qemu to multithread-tcg.  I
have fixed some lockup issues, but there are still some cases we get soft
lockups.

If you have any details I can see if it's a similar issue.

-Stafford
