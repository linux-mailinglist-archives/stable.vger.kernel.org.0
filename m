Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53184BE7CD
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379961AbiBUQOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 11:14:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379953AbiBUQOF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 11:14:05 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6154C13F6B
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 08:13:42 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2d6d0cb5da4so88599527b3.10
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 08:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WXjHQX1AtlViHFaHWd6Iva+LTxgoLMRJ8aez/lEDXws=;
        b=H29Z+yo8CnxLWxuAHti4RuiHYpPkOmKT5Q9C9W/QzMzIxgoTQRRazAZMYv6iGkxDD/
         RZsqiQqSHU8PBCbKORaDfFJYwAOUlcfHB5RQ8Y+bW8kVSfPPmTvEpqijsfqk2tr5KNBL
         Ms/zzzK0auvHhSbEcmmLuWf30ymx51y94UKRMJKSICUJ2vESLM8n/M35hJ94761Q1HeA
         jzYX4iIm4m6Mxj8koAVOn3c0JhMNX8us8n/H4ypGL+NjWDT+fcek2WLQKlapkI/CQXKr
         E7D/hAUb2r8v+qwectFWhQ6EnG2TJA6yfOkHkT1bONQ7nDBMLro34ct1yMQ1KuWiOeFz
         eOqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WXjHQX1AtlViHFaHWd6Iva+LTxgoLMRJ8aez/lEDXws=;
        b=qVJebjOQfw5Q6ZSplDyLY8eyDAyam8/SRI7gFZbOfafhMC5aSUxq7KRyEHWd3+NQ2E
         zZLbi9lCWZMJ3FbbTYL4sttpV3aAHbNMZQfejM0NiOeTxwhihh1nr2ExKnvNhD34mmdk
         OOrV49ZFqm+tHABhIfO7DQl36aS6WG1bkh4J7vemU0J6M8VoP9qh238Bf/4wjyK+CM9L
         kuTIkIIFZf6VbZ7o6PgENgD9EtyKf/5XtvvOK0V3q3P0E/+MJ/K2fwGQmaWCDzZ5kseV
         OH1jR0zGBfH34y24A4c/pyULNyNs/yhWHgbde5a3SH6Dw1+lazl5roVvw/ftLRUqOzQS
         Vd7Q==
X-Gm-Message-State: AOAM5305T1DyichWjRpogGxxeAsYt2TNZh4ylHd2AWqCBmQGf/acIasR
        EFWzOfHpJnwI97WgCUyvDTuQO+AvQQiBb6bSBcBZoMBH6BjStI6t
X-Google-Smtp-Source: ABdhPJw5U/qXF+ljM3+m5p6sV0+H7RK8foGv2De7rZsl9ijk7+Y3Lz4D947ss/tnnBgFW7icUbb8tyBd3qbBzkTfY1s=
X-Received: by 2002:a81:1408:0:b0:2d0:7c31:97dc with SMTP id
 8-20020a811408000000b002d07c3197dcmr20092237ywu.216.1645460021600; Mon, 21
 Feb 2022 08:13:41 -0800 (PST)
MIME-Version: 1.0
References: <20220221084934.836145070@linuxfoundation.org>
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Mon, 21 Feb 2022 21:43:05 +0530
Message-ID: <CAG=yYwnpcxnZ1yXQSHHa-6SEUv60PFD48w8K9sVPU3pROCn0HQ@mail.gmail.com>
Subject: Re: [PATCH 5.16 000/227] 5.16.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 3:13 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.11 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
hello,

Compiled  and booted  5.16.11-rc1+ on  VivoBook 15_ASUS Laptop X507UAR.
NO new  regression or regressions  from dmesg.


Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


-- 
software engineer
rajagiri school of engineering and technology  -  autonomous
