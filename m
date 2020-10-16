Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8982904FC
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 14:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407452AbgJPMVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 08:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407451AbgJPMVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 08:21:24 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F580C061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 05:21:24 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a17so1304611pju.1
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 05:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=NMI1sFtLzmFm3k0JvXz7PfONg0lcw+c3PkRnORn4L1c=;
        b=xs+TCkQ7Os08tggPr+Zx+DT1oAfLBiwXPDP8aJsIszDRhXOMtO2shEZ0kj9ntAjpmC
         euuAvdgWzJRvWsS7mGtDx2wbmvRQnYkZeT/cgiJjNVqQ+LXRgV4/Nz8H8ik4gMSIn4lW
         8dDuQLpUuWcoOM1uv/tiMOutHZDga3iNGTMaESuPV2q9tB+oYodtaKAMQj11QrBJ8dOT
         H+nLdqrmDx9Nm5mLGLb1rdT5KxOs3zK+koPcX9Uk+nYt6LSdR6yFu+xv+ZUqxyOZpw8k
         q3Qq2SvDw7Pz2Ka54WieH+qz+vjFBl65SHNvvZcSSp4ciwe4zCxEyeR5atZdfAAc+40G
         JSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NMI1sFtLzmFm3k0JvXz7PfONg0lcw+c3PkRnORn4L1c=;
        b=mHY9eT7BW8ouapGlKYmz7/xGxEb++OsvtxhEV3ca/OroBcA/RBNnYvb/ExtLvJiAFO
         9AYqOw/j6QSCVVFbnvlhTCeuRC18U0SR8pRbHYsbrutPYYLKdaW4JnLJi1coDfryFfdu
         OiIQ8bwpyNYsxY6vlvKAUXrZXN8hEw3fJqHV4vsY4fDbTiJD55k+hXz193rwD/a4monX
         c3Y628CxNjovmB70N1yYMbQ59oQID1I/JN7YxDTX76WJzoovohkSsaWeDZAMLySC8rHl
         cI0OIM2b39cJ4yTZ4nZqhpndmpSlRDh26wtQyMbWwlhhHB6xk7ghjtXzWe2CtEx0E+Sv
         DVlg==
X-Gm-Message-State: AOAM532nqiG5nkEja81KkyRlb31z8XAxciOgMzuPA3posI66ZGQo6ykf
        mnH/QJ3VqsMyRrazrVhVIxSs7xeYLpIRnQ==
X-Google-Smtp-Source: ABdhPJx7dIUwIqI13LTYrLxyYi+ODJh8MMmAk3MQO3ExsLdnRixqVibKP9T5FDr58JtuQkM+Og4+Fw==
X-Received: by 2002:a17:90b:11d6:: with SMTP id gv22mr3890864pjb.159.1602850883810;
        Fri, 16 Oct 2020 05:21:23 -0700 (PDT)
Received: from debian ([122.164.16.34])
        by smtp.gmail.com with ESMTPSA id p6sm3055692pjd.1.2020.10.16.05.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 05:21:23 -0700 (PDT)
Message-ID: <8b3c1958864decc8d1d9a70f4613b0e06cc6a0b2.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.9 00/15] 5.9.1-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Date:   Fri, 16 Oct 2020 17:51:18 +0530
In-Reply-To: <20201016090437.170032996@linuxfoundation.org>
References: <20201016090437.170032996@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-10-16 at 11:08 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.1 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

hello,

Compiled and booted 5.9.1-rc1+. Everything looks clean except "dmesg -l
warn"
This kernel like 5.8.13-rc1+  shows issue related in warning.
Please see this...

--------------------x-------------------------x-------------x-----

$dmesg -l warn 
[    0.589254] MDS CPU bug present and SMT on, data leak possible. See 
https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for
more details.
[    0.592523]  #3
[    0.735219] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[   11.454156] i8042: PNP: PS/2 appears to have AUX port disabled, if
this is incorrect please boot with i8042.nopnp
[   13.519401] sdhci-pci 0000:00:1e.6: failed to setup card detect gpio
[   15.518853] i2c_hid i2c-ELAN1300:00: supply vdd not found, using
dummy regulator
[   15.520777] i2c_hid i2c-ELAN1300:00: supply vddl not found, using
dummy regulator
[   24.934891] systemd[1]: /lib/systemd/system/plymouth-
start.service:16: Unit configured to use KillMode=none. This is unsafe,
as it disables systemd's process lifecycle management for the service.
Please update your service to use a safer KillMode=, such as 'mixed' or
'control-group'. Support for KillMode=none is deprecated and will
eventually be removed.
[   38.110160] uvcvideo 1-6:1.0: Entity type for entity Extension 4 was
not initialized!
[   38.110166] uvcvideo 1-6:1.0: Entity type for entity Processing 2
was not initialized!
[   38.110170] uvcvideo 1-6:1.0: Entity type for entity Camera 1 was
not initialized!
[   41.031588] FAT-fs (sda1): Volume was not properly unmounted. Some
data may be corrupt. Please run fsck.

---------x--------------------x--------------------------------x---

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology

