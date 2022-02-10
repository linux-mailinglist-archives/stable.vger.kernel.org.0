Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F554B10B7
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 15:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243106AbiBJOpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 09:45:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243105AbiBJOpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 09:45:17 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F202C4C
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 06:45:18 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id j26so5214020vso.12
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 06:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BmUeuK9aVMpjbFZ/smVPoevWR8+GiP+XuBiB417bv3I=;
        b=fkmRKS31vly9dxLeyjM8/W7Phgpz0iQilQwns/LZl/8TIWBqf68b2cO2QyF/aSMUvz
         QJaBX3C/lJLSPc+qoc3W+QiWT+kQsqlWjrrakzfaJe1UOmDUK9LC2PxYW/qFXfy6dW09
         wYTfK2XWXMZ82MqVFVsgZwcuMd45VsS6DeA6D6jrHHFk0AXzTNy9USBbmsw//a4a50fR
         Y6ewJnCWHNV6p3Q7Sj9QM6oAj+quLn3GXnssR+msMFo7I8hbNf9DKWxvgn9fdCloYHnl
         G7rFum6yvzWZ2Y5I5jTDqQZU3RafvL8/o/F0s7AD5P7XpXV6SoBZaRUmhz9rD74yZXNp
         LGCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BmUeuK9aVMpjbFZ/smVPoevWR8+GiP+XuBiB417bv3I=;
        b=GCkrAxxiLhvUDXW/tpO0ZbcUxah5kRJpwKrRVXNC9SmzrxhlG91H1xuT78sQGUBeGx
         /vk4xn8RJfGoGM7Okoo4KWU8RmFArlg/YgmIA8reabnOM4SJ7IsJhOUlEgT6r9p+jzGS
         ScyFGYcw/2kt2RzA5LO6vaRwnny7cFG3j/GkXwA4Rk1rOwAOnGFK9b0+/9FgO374uguj
         /s3m1SRbLI1PP41mQqxSLYEKSor5+IC5Zk94gkjQXQLfRD1DGyjwIDGiknOnmUaeQYxr
         5tSYPMeP5/VNpsdZKCt8uhDykExGR1XLmi5I+1My0YYth+1bBL6ag5z5JKAAVJsx05Bv
         34cw==
X-Gm-Message-State: AOAM531z0I91JwS5DPErCNxtXMn3PBQ5OAPjCNSoAIq/RYhtl8WxYH0o
        JF2i8la6AvsIZ4BcLYsBKykBvIke0C3Xh0cbdcwt0w==
X-Google-Smtp-Source: ABdhPJz32YcC/PDUI4A+wInxpNkrGO9FAyPi/OwpOiDoxDD4IQ18uhmxYCzEjpDavPZ21mDkCwNdh3/60HQo4YOsk4o=
X-Received: by 2002:a67:ff0a:: with SMTP id v10mr1483386vsp.3.1644504317195;
 Thu, 10 Feb 2022 06:45:17 -0800 (PST)
MIME-Version: 1.0
References: <20220209191249.887150036@linuxfoundation.org>
In-Reply-To: <20220209191249.887150036@linuxfoundation.org>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Thu, 10 Feb 2022 20:14:40 +0530
Message-ID: <CAG=yYw=bh=piFrPMGSebgwtZfv-ChGx2-yj2__ozc4nDsD1HJQ@mail.gmail.com>
Subject: Re: [PATCH 5.16 0/5] 5.16.9-rc1 review
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

On Thu, Feb 10, 2022 at 1:05 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.9 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

hello ,

Compiled  and booted 5.16.9-rc1+ on  VivoBook 15_ASUS Laptop X507UAR.
NO regressions  from  dmesg.

-- 
software engineer
rajagiri school of engineering and technology  -  autonomous
