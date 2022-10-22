Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A9B608FDD
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 23:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJVVzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 17:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJVVzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 17:55:12 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F86252807;
        Sat, 22 Oct 2022 14:55:10 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1324e7a1284so7787267fac.10;
        Sat, 22 Oct 2022 14:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ohbh0K9cwBHcWz8JP9WLZfeOQo7fUZuFo1cmJQDfpPs=;
        b=hEEdimc42nyg3eZ5TwCmZGxKG5PAP6SVfmolNTgWNf1NYqyzgzZRFI7ds+MTTGXSuX
         ZuA5XQe/m4ntfzriNM/Zz7ULjWX0iZ7yBXP7dv/g62YeFwQFjrNsOIOixRSHMuBqP06M
         btMU0pwTZ6ZOjXrNJoTwLmKaDenS1WvzQBlU3pLK3M2bsMxlmK7o8IaT5x1TZUtUFfA8
         SK0wijkzbwzF+0vQfBUZd6ev3HtW1EFX8vYyeUmc4xUcFM40yDfutWuL+vXcMn5hY2hb
         bBCMBYH+07cD9+n/d9aX1mCc4EesmL9r2gpzaBENXm54PcLWFqRV8pNXhuFM2KHu5+P9
         fNCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ohbh0K9cwBHcWz8JP9WLZfeOQo7fUZuFo1cmJQDfpPs=;
        b=YuzJgbgfLrcz57l1pjZVTZSpXns+eycWl6BPcQtofaCwMLYzar1uqMdXlVjKKfM5Jy
         pXvS9jQ0TMOT4BS5pLEUnwzTZofZMv3pKV+MWzjsueBuFrWYa3hBzvQHu3yyyA0c7HCB
         RFoH38YT6xC45G9TENSRKS7peooxArh/prKK4pmQ4aN2NCCpm171lRiQPGFUlVGxoy2U
         1r255B6Pv+pP/CI+i8+wQPEIqcxfu/pWDVJzFkE4+mqV41nFHuhaNVFL3/SHcO7KxOsc
         hVJzWQh/p8tYi+m2GY/S3zvJpSyIcUyfxz2RFiJTkE7iOm+m3cLHDWlvnE+2NyLumyRZ
         NtHg==
X-Gm-Message-State: ACrzQf0qvqGkaMtgiy2GV9QUJB4IHLhNosJTAW3+jGKjtNAjVIh4LEW3
        DNXM5xZ9o9MFuLj5X5gYM7o=
X-Google-Smtp-Source: AMsMyM5iaCyxVJWGAxib+tKyqyWbnFqv6RXg3G2CRSFCunLUeQTZn85D3M4ll9mLM3Ie/CUsO9EXEw==
X-Received: by 2002:a05:6871:88a:b0:132:40e6:280 with SMTP id r10-20020a056871088a00b0013240e60280mr32844347oaq.202.1666475709769;
        Sat, 22 Oct 2022 14:55:09 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y3-20020a056870418300b0011f400edb17sm12082339oac.4.2022.10.22.14.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Oct 2022 14:55:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 22 Oct 2022 14:55:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.19 000/717] 5.19.17-rc1 review
Message-ID: <20221022215507.GA2167439@roeck-us.net>
References: <20221022072415.034382448@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
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

On Sat, Oct 22, 2022 at 09:17:59AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.17 release.
> There are 717 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Note, this will be the LAST 5.19.y kernel to be released.  Please move
> to the 6.0.y kernel branch at this point in time, as after this is
> released, this branch will be end-of-life.
> 
> Responses should be made by Mon, 24 Oct 2022 07:19:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 150 pass: 150 fail: 0
Qemu test results:
	total: 490 pass: 490 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
