Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8C74E30F2
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 20:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345138AbiCUTxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 15:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239684AbiCUTxk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 15:53:40 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC1C123BEC
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 12:52:14 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id h126so30084351ybc.1
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 12:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QvfezOET3lCC5FO8wlzK/F9Hv0UPPErwC2g10ZZeTqg=;
        b=C7S75GM1c5KW3lmmgzpDvrVssfE1dxTGXZBTTaMMZEKb9T3UyRNgsTrnLpBLMrPzTP
         wTKO7A5vgCE8bgVQjtDPqW7z6vOIks4vSfc09J5dt9QDf2ijfvCvcQFcNtzt7nJvkyCV
         DEpcHgshkGccdULN9rKKb2+m40Zyj/jUu57RmGpHLG0ZUGw1M1882QqrrdeQI9NXLJPX
         sst/FAwXi49iC0E7Sg8Lk4oYVRWEGI2Zd6ClTTvHpLkfDKrdNELF6TX+hrwoYkPRpdvv
         h0lW1rrRqHCMHlXBGeYV+kVoR4G7f+zEgoCHCRtbEaqJ2uV4vBC0ogdsIlvQ2jDBrqbc
         j51w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QvfezOET3lCC5FO8wlzK/F9Hv0UPPErwC2g10ZZeTqg=;
        b=nMrNLKjy9xHV0Ug+uwh3Jzhaatwi4sBQHu/zWqZdHkMMVaR/ivqz5Uq3WuYCLwwD/6
         Lt+H2ZOWzu8bt7vSpbTSP03GErGfdEBXtsbL4o3RIXxVArCOPHOXCGiKjRn+rCqMdO72
         cJxpWuLQ7FeWIhDtOgtmD5A/kPv4lFc7zGEKxYImnqTZ/hdZ2IacPpR1itZv8lwox440
         QjAZn1QXtE91C26D5apOdls1rWAh5D/pVx7wU/Kh3ipgP+SBzy2rmulBlHlDgQhRE+6S
         8OYlfu0s19ZNEV7JusEOgdCNkbCyKSbPtwGWFZ7pidtkssb8UzKb9BegWKvb36fza3KF
         mG9g==
X-Gm-Message-State: AOAM530rPEw5YZ7a3y1CcY2CTXtbVutLik6rY9AtBDHDnX5ibrgos2BM
        Y+/Q3amBoRrX8DgrjtKm3OxWVUCP/dTkvQKq2e9jkA==
X-Google-Smtp-Source: ABdhPJxLg2RsCkPd5Fc/l+US1HyLmn9WT4iHloqABdNUZIkhfgg+UffDulpLI3GEMfIDZm+sbazSOFms1Cpw7blOHWY=
X-Received: by 2002:a25:928e:0:b0:633:f370:d9ff with SMTP id
 y14-20020a25928e000000b00633f370d9ffmr8028608ybl.338.1647892334113; Mon, 21
 Mar 2022 12:52:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220321133221.290173884@linuxfoundation.org>
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Mon, 21 Mar 2022 15:51:38 -0400
Message-ID: <CAG=yYw=eJAnZCM1RgKb_oh1cW75AKyV6zR_vn7oMib6oLrXKzQ@mail.gmail.com>
Subject: Re: [PATCH 5.16 00/37] 5.16.17-rc1 review
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

On Mon, Mar 21, 2022 at 10:14 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.17 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
hello,

Compiled and booted 5.16.17-rc1+ on...
Processor Information
    Socket Designation: FM2
    Type: Central Processor
    Family: A-Series
    Manufacturer: AuthenticAMD
    ID: 31 0F 61 00 FF FB 8B 17
    Signature: Family 21, Model 19, Stepping 1

output of "dmesg -l warn"

---------------------<output>--------------------------
$dmesg -l warn
[    0.007168] ACPI BIOS Warning (bug): Optional FADT field
Pm2ControlBlock has valid Length but zero Address:
0x0000000000000000/0x1 (20210930/tbfadt-615)
[    7.663451] amdgpu: CRAT table not found
[   49.488716] kauditd_printk_skb: 11 callbacks suppressed
$

---------------------<output>--------------------------


Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology
