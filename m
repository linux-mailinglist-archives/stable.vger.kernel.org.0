Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C00B12DA0F
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 17:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfLaQJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 11:09:12 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46013 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfLaQJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Dec 2019 11:09:12 -0500
Received: by mail-pg1-f196.google.com with SMTP id b9so19681354pgk.12;
        Tue, 31 Dec 2019 08:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=1Vld9Wc/9/pjRjn40wy74u5VnLTkJZ//1z3Y8BYIglk=;
        b=HJ85LW8hwnS7sxhfcvYOFpJWT01CuvfeISAS4ElAeXCADuHyghCsHN3+SgLBiy3ocI
         PBiCBKlQ1z43wiplJcib6w5kE9GWQ0tMa2b0aHlgMRqDvPG0vxRfjc/kriDhkvnOIbvc
         9NPgMmMlw96kQOwHViwikmKaLllndjR3ELctWlr67M9dBatu4UYaxqu/JN1FgdBPZYX5
         CHrjiUtvVzk+7aO51QVH5thha0R9uDExVi6R+khLFo2WBmbUQbIp64NTCDeRQ0kaAYfL
         INfJQBr/M5iUTZil8wdSoFIMw/B8+hOtuehaPaUWysXVHASIClNHeKidS+rS6vKczDol
         GP9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=1Vld9Wc/9/pjRjn40wy74u5VnLTkJZ//1z3Y8BYIglk=;
        b=cgGzyt7gS1F4KEDRfs+8dV+aj/wsjyHJMMXS5Zumdfa5ooow5HFgi9HK9hAJjbS8hR
         yKDT0/vUBY4Gg2O48ZX26WdPjGrBi6yXB466nmzJhPU7p6TskoX6VZJ9Dt3yZhKF0PJ+
         hgSv4MU1kw4yYwm1kPPMkiaRKP14FyRTJqmsGI9VHSy20+kMPsSjXFhffOl1Aww9oPet
         kJL4Qo7Jnq3r4VKc0B3h4qx1A8wtH6Gxcm7dz16iSgUufRW0GwWbfo55bc4pvTunVtFa
         2vFrbI3N6NffDg0mQXpry6JE9lEYV58jDXQ0C38Scm2Wk9XKLTSqCuTCIxarC0pI3t9f
         Y1tA==
X-Gm-Message-State: APjAAAUSs1XowFsp88BNrJ9tmp0oo9DHp8wX7qCRxIKcM3P7HCHvMos6
        Niupcs0+T8mV+99KkO+zsQA=
X-Google-Smtp-Source: APXvYqy9jfAD378dZ1Lp3cBiSCbgMsCLQIcWTbkVoF2D2DLn//Lw/olQ/3/WieSEwaJlJqR+jUO7uA==
X-Received: by 2002:a63:fe0a:: with SMTP id p10mr76384514pgh.96.1577808551728;
        Tue, 31 Dec 2019 08:09:11 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w123sm38380680pfb.167.2019.12.31.08.09.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 31 Dec 2019 08:09:11 -0800 (PST)
Date:   Tue, 31 Dec 2019 08:09:10 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/434] 5.4.7-stable review
Message-ID: <20191231160910.GC11542@roeck-us.net>
References: <20191229172702.393141737@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 06:20:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.7 release.
> There are 434 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 31 Dec 2019 17:25:52 +0000.
> Anything received after that time might be too late.
> 

For -rc2:

Build results:
	total: 158 pass: 148 fail: 10
Failed builds:
	<almost all mips>
Qemu test results:
	total: 385 pass: 320 fail: 65
Failed tests:
	<all mips>
	<ppc64 as with mainline and v4.19.y>

mips and ppc as previously reported.

mips:

In file included from kernel/futex.c:60:
arch/mips/include/asm/futex.h:19:10: fatal error: asm/sync.h: No such file or directory

ppc:

./arch/powerpc/include/asm/spinlock.h:39:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
./arch/powerpc/include/asm/spinlock.h:39:1: warning: parameter names (without types) in function declaration
./arch/powerpc/include/asm/spinlock.h: In function ‘vcpu_is_preempted’:
./arch/powerpc/include/asm/spinlock.h:44:7: error: implicit declaration of function ‘static_branch_unlikely’

Guenter
