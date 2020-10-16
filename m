Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A906F2906D7
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 16:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408607AbgJPOLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 10:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408605AbgJPOLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 10:11:17 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F67C0613D3
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 07:11:17 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r10so1517515pgb.10
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 07:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=sMQ2dMIgMKaSx58zvkJZR+Zaau89AWNULRIULAFQhWQ=;
        b=BVs5BLt8c8o0TolmoLyLq5zl+Oh2F4C9/7OQX3Lmga+kuiMARfVa07ypjnDY8gPgqe
         hYxLKcntwP/OuVYCkJth6rQWsP8K+2Wjqs3eikhad4j2J3R9GqrGTyPxc5l0o6C0BpuQ
         d2Chf6HhGavHXOpZ5aAtjvrsDkmRa44OQG8xxwYeFbtuxK2dlUp45a8e/52h9isGkWYC
         SnDx0MmV8brtesj//Rl583OqO+l3oX9z/eXc5EMfetwnwC/8C1ESIctWJFJofAFyBknF
         ssZ0um/HfEoZuebvTu3uc1NLsBaIdcdw3SY4swj4xr5uXssYQV9FK1JZm9HmWCj555zV
         xoTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=sMQ2dMIgMKaSx58zvkJZR+Zaau89AWNULRIULAFQhWQ=;
        b=Mm2sTikcay6wUuV3IW/BqDVm4MEPR8KblQUfcsO1yZVGbSeC4RjoqZQDK/9zc3MJJk
         DgYDNIIePhibyIwHocq3ELN021zHKK9L+y/pDs7mW2Y1d6c2ygdSFYxDktNVkXFOH4Q2
         Wuw3JTg6w50f7zkgiLFJm3SfY41Ilfd5EyKZ8FHzNf8RL2PgsuU8uIS8C4Ik+v04LPgQ
         /NfLzqeBcnJuYePX1OJXNDT654YPUk6wj0A2BvfCNKL8j2Gl5g6zwmEppukTSIavMf2Y
         Jh46pSojRgoce1b3Y18at9cKZPBP+Vs1SOWUPlbQwSkMI0789k9EL9mK0HZG7ISC1pWj
         mctw==
X-Gm-Message-State: AOAM532KVdQ1n6R5rcNo+xlKl+E6pho0iMEV3FzkuhVTBXHSq9eGGXU8
        lb+VsXmMjyVbgRe4RRoZalNjHA==
X-Google-Smtp-Source: ABdhPJx29URNxem/t+30RTckmeM/Ez+G8pGRwfIwLRIMeQ7mkCeZXBhW0fQG0J8lzwEVBMYXApcCKg==
X-Received: by 2002:aa7:9afc:0:b029:152:9d45:6723 with SMTP id y28-20020aa79afc0000b02901529d456723mr3770149pfp.35.1602857476462;
        Fri, 16 Oct 2020 07:11:16 -0700 (PDT)
Received: from debian ([122.164.16.34])
        by smtp.gmail.com with ESMTPSA id 16sm3334138pjl.27.2020.10.16.07.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 07:11:15 -0700 (PDT)
Message-ID: <7138d7bce8f8da009119f0107eeb7c85f67057b9.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.8 00/14] 5.8.16-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Date:   Fri, 16 Oct 2020 19:41:05 +0530
In-Reply-To: <20201016090437.153175229@linuxfoundation.org>
References: <20201016090437.153175229@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-10-16 at 11:07 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.16 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

hello,

Compiled and booted  5.8.16-rc1+ .Every thing looks clean except "dmesg
-l warn"

------x--------------x-----------------------------x-----------

$dmesg -l warn
[    0.601699] MDS CPU bug present and SMT on, data leak possible. See 
https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for
more details.
[    0.603104]  #3
[    0.749457] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[   10.718252] i8042: PNP: PS/2 appears to have AUX port disabled, if
this is incorrect please boot with i8042.nopnp
[   12.651483] sdhci-pci 0000:00:1e.6: failed to setup card detect gpio
[   14.398378] i2c_hid i2c-ELAN1300:00: supply vdd not found, using
dummy regulator
[   14.399033] i2c_hid i2c-ELAN1300:00: supply vddl not found, using
dummy regulator
[   23.866580] systemd[1]: /lib/systemd/system/plymouth-
start.service:16: Unit configured to use KillMode=none. This is unsafe,
as it disables systemd's process lifecycle management for the service.
Please update your service to use a safer KillMode=, such as 'mixed' or
'control-group'. Support for KillMode=none is deprecated and will
eventually be removed.
[   37.208082] uvcvideo 1-6:1.0: Entity type for entity Extension 4 was
not initialized!
[   37.208092] uvcvideo 1-6:1.0: Entity type for entity Processing 2
was not initialized!
[   37.208098] uvcvideo 1-6:1.0: Entity type for entity Camera 1 was
not initialized!
[   40.088516] FAT-fs (sda1): Volume was not properly unmounted. Some
data may be corrupt. Please run fsck.
---------------x-------x-----------------x-------------------------

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
-- 
software engineer
rajagiri school of engineering and technology

