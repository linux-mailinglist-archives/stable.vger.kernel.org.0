Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6345949324C
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 02:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350666AbiASBZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 20:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343527AbiASBZC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 20:25:02 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671A8C061574;
        Tue, 18 Jan 2022 17:25:02 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id v6so916771iom.6;
        Tue, 18 Jan 2022 17:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5AW9Z4kwtigmZlvXFV6C3nqO95z1jlQmfrRad2xB9KQ=;
        b=GM6JjOJnfhwTnn+J+CgROFHqHgDmaJvm8HWBGpjBLNs9b3xfHawr5wrJYYcRjRmUo+
         2ts09jPvpYehlee6Ixcq3dVMENVGJ8g7V4NcuRdyqr69p0AvuZmplXLWsprb41V18dUc
         tlwxTxIItDU6wWkczmOXa7VLk1R/OCOYZTjvj1xPwQsUpJqjQP//Xsh5TJ5Ehi2XTyXl
         b5/b0OnPVj3M2lokKdUmNcitk5J9gAuozoSJwOD8YEbQuEAS8YGHmsk9xGzrwYr/mU//
         on8aERBBXzUrswpC5dkGK7isfKYMbUj7Rw9PXStf4YUFCSo4tS7YseLIC8WY8S8Ff8SZ
         e/xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5AW9Z4kwtigmZlvXFV6C3nqO95z1jlQmfrRad2xB9KQ=;
        b=yLNI2haCrvd0izSHVcD4Hl+u4itCb9fFjSrrrAgBn5QNBH+k+rl8tNFjMC3wC035t6
         RPiGMBYvNL1Pt82+RQcsJFIIlpSd8Ik5IPhJkwU4/27aOm2Yr8xVPNrd9QGG/dOKi1Q+
         KQWmpwmUaXLZ4ehF5ljNFv0gnRtW87r8dhYo3Oyk+43TRYBt/ZnrCfYrUrPOpLDJ606I
         002g64Qqy5YNOIa9ZdLTzqml4H/QlTXd0gbDiQW/mJLUe/do8foUh4lyTi3JENWa7fVP
         PF2U8Xeci50EBBI5D4v/bvplqo3FfFzCiIAnzDZMF1KV8in8vuaM5frI9kv8Cui2CyB7
         zfPw==
X-Gm-Message-State: AOAM531uK4XGJa+5K00YYUhct8n78ra/T5N7DqtgOlIw5TQd23f4R7tn
        7zMIifCfL36vVW/jiPtU/Sylz92RG/JT0jueJK+bBJx93/DLRQ==
X-Google-Smtp-Source: ABdhPJxQJdCAsLPZXMP59+eo5PpGTaYxpfJ4BbOdU8iAOxeKjSZfrbMQqv4UqGZshIzD9q40iVvrtCCAlW6i8Ak+qDo=
X-Received: by 2002:a05:6602:2e82:: with SMTP id m2mr5245924iow.209.1642555501810;
 Tue, 18 Jan 2022 17:25:01 -0800 (PST)
MIME-Version: 1.0
References: <20220118160452.384322748@linuxfoundation.org>
In-Reply-To: <20220118160452.384322748@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Tue, 18 Jan 2022 18:24:51 -0700
Message-ID: <CAFU3qoZq7eWxF4Wtp6XJsasws55f=d4p9ksc0=25XOZue=W3pw@mail.gmail.com>
Subject: Re: [PATCH 5.16 00/28] 5.16.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 9:17 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.2 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Hi Greg,

Compiled and booted on my test system Lenovo P50s: Intel Core i7
No emergency and critical messages in the dmesg
I am going to be running perf bench sched from now on and I will
report any regressions

./perf bench sched all
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

     Total time: 0.437 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 6.919 [sec]

       6.919489 usecs/op
         144519 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
