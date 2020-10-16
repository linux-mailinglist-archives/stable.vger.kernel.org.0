Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B203D2907FF
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 17:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409799AbgJPPMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 11:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409717AbgJPPMT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 11:12:19 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349F7C061755;
        Fri, 16 Oct 2020 08:12:19 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id i12so2706757ota.5;
        Fri, 16 Oct 2020 08:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=15AZQELGa3bHZWQjBEdlTTm271UgSrfGat1CSpkMJjY=;
        b=WTlwhJQ7hRB5YvNvAJgPzVTzy6UhJwtrPw1505nBDPtfmD2RCKf6ko9i2pxsNt/hgC
         Kv/Cl4Jf5KndDyPUOsWbTSPLWP+w2cPwez/UwNEIAOsmILfiGOgA2eLaLFEUpxlI/zzl
         N3TxM8RZ+SbujsS1QmTip4aTDq8cP9dBl81z3pcZ1vTSQM7Znl8JVweC8o5aCA7zBp91
         oKOTjClfhglbQs2OQ8mc/zlPtDN7xxWVZjTeqZvCjixdGz507dVRcHk4sov7H7kTPuCg
         hamDSnknRJ+XxdPR5mVHxj4Zp7dP12MR7mtLdBWs38daDbwnkJ9m/e5A0swmhkOn+9YS
         BkyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=15AZQELGa3bHZWQjBEdlTTm271UgSrfGat1CSpkMJjY=;
        b=DohXUBGfb+TG8kk42N1CUMqSOdfvK7C+21cPUJvjuigIEiQ11E74MwT351qcq8y5l4
         vDmhtMvBWkmZAgXC6GIZyshIT46JhyEvLRxDnqckp19KsA8FicogYSRrzDTgVu5NWuDp
         MDVOca1TjLHYIzJOBGGD1su8dvDCY2vsXevUjh9PV5QRLxxdTs3O9uC+f5r7qD8gpZFu
         1Bgmb7FwMV5sE47BzOVgE0T1n4SYAthFz0JO1pl+cUOwpV1CM7ilWaLT6Dt5XFVqEdvM
         /BGg1wqX8ildhgaY8QiaW3s8TxNplSzJt1tbyS1cmmKYh/vwclaS5Eu4r069S4AmK4iu
         WNUw==
X-Gm-Message-State: AOAM532hjZ8g9aCVKHn9GpgKAOQ51rQuu8mgjIvAnj+CA/LFtsagjE1V
        PXJYFu8k5MUKh7fvOsvIWYXLR4+uJg4=
X-Google-Smtp-Source: ABdhPJym32YOQA64lIfIRb7g2LZp2quJHpyiO9PKo6mXHmz4J/raEHvRfpeLxJJ3lVLjXH61Mt+DHg==
X-Received: by 2002:a9d:53cd:: with SMTP id i13mr2847162oth.112.1602861138429;
        Fri, 16 Oct 2020 08:12:18 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c200sm1104578oig.55.2020.10.16.08.12.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Oct 2020 08:12:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 16 Oct 2020 08:12:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/14] 5.8.16-rc1 review
Message-ID: <20201016151216.GA230162@roeck-us.net>
References: <20201016090437.153175229@linuxfoundation.org>
 <7138d7bce8f8da009119f0107eeb7c85f67057b9.camel@rajagiritech.edu.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7138d7bce8f8da009119f0107eeb7c85f67057b9.camel@rajagiritech.edu.in>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 07:41:05PM +0530, Jeffrin Jose T wrote:
> On Fri, 2020-10-16 at 11:07 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.16 release.
> > There are 14 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied,
> > please
> > let me know.
> > 
> > Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	
> > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.16-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> > stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> hello,
> 
> Compiled and booted  5.8.16-rc1+ .Every thing looks clean except "dmesg
> -l warn"
> 
> ------x--------------x-----------------------------x-----------
> 
> $dmesg -l warn
> [    0.601699] MDS CPU bug present and SMT on, data leak possible. See 
> https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for
> more details.
> [    0.603104]  #3
> [    0.749457] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [   10.718252] i8042: PNP: PS/2 appears to have AUX port disabled, if
> this is incorrect please boot with i8042.nopnp
> [   12.651483] sdhci-pci 0000:00:1e.6: failed to setup card detect gpio
> [   14.398378] i2c_hid i2c-ELAN1300:00: supply vdd not found, using
> dummy regulator
> [   14.399033] i2c_hid i2c-ELAN1300:00: supply vddl not found, using
> dummy regulator
> [   23.866580] systemd[1]: /lib/systemd/system/plymouth-
> start.service:16: Unit configured to use KillMode=none. This is unsafe,
> as it disables systemd's process lifecycle management for the service.
> Please update your service to use a safer KillMode=, such as 'mixed' or
> 'control-group'. Support for KillMode=none is deprecated and will
> eventually be removed.
> [   37.208082] uvcvideo 1-6:1.0: Entity type for entity Extension 4 was
> not initialized!
> [   37.208092] uvcvideo 1-6:1.0: Entity type for entity Processing 2
> was not initialized!
> [   37.208098] uvcvideo 1-6:1.0: Entity type for entity Camera 1 was
> not initialized!

That is "normal". I see that all the time on all systems with usb video
camera.

> [   40.088516] FAT-fs (sda1): Volume was not properly unmounted. Some
> data may be corrupt. Please run fsck.

That is a problem with your usb stick.

Guenter
