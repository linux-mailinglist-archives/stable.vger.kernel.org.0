Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F62E48F802
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 17:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbiAOQsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 11:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbiAOQsf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 11:48:35 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9805C06173E
        for <stable@vger.kernel.org>; Sat, 15 Jan 2022 08:48:34 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id hv15so16121281pjb.5
        for <stable@vger.kernel.org>; Sat, 15 Jan 2022 08:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=299lUhpoqER7xMrIi0Rw84PjAHn7RJ9svZvqQZwEqVs=;
        b=x9VRTphRkBajzGQvpAJ/6NHEQqI822f2KyRxkpoK01Tg93uOzH2B1lVFg9FZLhY0kY
         rHwqPNLUF5ITLvNVGwE4g4DtgA2+z/pL2bsykZt61TLkLqCUTC7CciklQHkrXxK5b3vG
         N7VfmqLanhAMhC34MeCv6rYnE+Zeh0bEiz1JR3HR+wDJhCAdxULY738gBUZXGQ4W0JwJ
         j/FLiad7sVmYAipMI9KYQfaeWfF0Vy9wVVA/lJcHtGTqezEYV8FyOePWU3dRKEivgkX+
         leW0brlxRpzVRW5xnasz/S6GsVGfBDtsakoZWjO+AmTpmMbFlbNUGnr+4svzsVINs0qM
         stBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=299lUhpoqER7xMrIi0Rw84PjAHn7RJ9svZvqQZwEqVs=;
        b=z5f95ZuikXTDAgEtTynE5/GFNSpNvBHZ4dXlyLYWscCiG+szT5N9a6D3Q6VtSiSYNa
         Ot/KPNdeUlUaU609AWcWYI+l6PsOlhQqbYwkSYzw1qWO1JoBSzKqVErY8GUmJimn3a5C
         ykJH7r6L87Jdvpr9y+gUdJ18QkVEDdO3vZZ5RDg++DwcBMMIQyLzZQObuEyC0l8Wgm3d
         XnS07ElejyZuCkwrMuOvl+rgv38fbhB85zaiGYUPDPZ+jbz4MdO4fqpc/0WVUTynujTX
         OH+j2qNVgPLJ2HlgtN6au2HK86BXFmSwuXKD3QyZ6QyS7Pa3nsMV+snhEp8RYYCNoGcl
         J8/g==
X-Gm-Message-State: AOAM5336MOqPmYkFX2Yr8yD4on2TMONpzcxtxflfeK2YcBh0+ik0Dk40
        ar3C9ifhSmoagJ4650OQi/4Dng==
X-Google-Smtp-Source: ABdhPJyxCKDMBQxrUyF0Esa1N4/3H0GyDpSwG0a4/kp+LD7FrtMWfypTdDsQywEo3F2QU3Y5V+aD4g==
X-Received: by 2002:a17:90a:c381:: with SMTP id h1mr25949492pjt.240.1642265314444;
        Sat, 15 Jan 2022 08:48:34 -0800 (PST)
Received: from [192.168.1.32] ([122.164.22.119])
        by smtp.gmail.com with ESMTPSA id d3sm562946pfu.66.2022.01.15.08.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 08:48:34 -0800 (PST)
Message-ID: <c2307523215336012a51e03f62f7911a7dc6a51d.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.15 00/41] 5.15.15-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Date:   Sat, 15 Jan 2022 22:18:28 +0530
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
References: <20220114081545.158363487@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-01-14 at 09:16 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.15 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
Compiled  and booted  5.15.15-rc1+ on VivoBook 15_ASUS Laptop X507UAR
. 
No Regression  from dmesg. except  old warning related from dmesg

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology - autonomous
