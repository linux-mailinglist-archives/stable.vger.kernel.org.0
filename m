Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E64F35D619
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 05:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241868AbhDMDmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 23:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241675AbhDMDmU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 23:42:20 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28AEC061574;
        Mon, 12 Apr 2021 20:42:00 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id k14-20020a9d7dce0000b02901b866632f29so14916310otn.1;
        Mon, 12 Apr 2021 20:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XkkvQgfcjHQEpjiPM1SboUkFweftUrw9ElIgdb+4xEU=;
        b=qjOuuLQR8XUEJClHDPTY8WXaGpizDlgkpNRBV/4uY22q7J9PJxxkVNmI7YRQlfR38H
         tJ+DuevvJUZ4nePa6l42GklgSNxITqOo0IrDIGchz/iHsgP1+p/QnelvRJxDAtRGlO50
         HxQufjYNgTedHES/hyqKgFmWhmzsHi7YGt6tAtSqzY5zZoKg4yPaVhEmzsf+zVSyEXPt
         nUK239VrXks3fS72moo+mSpvHrp2eGSS4IP/Tjfhr/8YQ7nlI7N3ChhIsQOiTcQ5H9Mg
         r2p2qgbQZvENMio+xCFp4a/jkaAgGbw+sCLBTMbvKYKyBTN7zvWUQRGxIek+sIzPrRnQ
         nwQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=XkkvQgfcjHQEpjiPM1SboUkFweftUrw9ElIgdb+4xEU=;
        b=b7cTd0LTkjVsHjGdbtdvGFoFTi+rfkDsAhgHdKQWoUBDo72uHPmzt6RdmcJJa+FiPV
         vin3F+sxPzt+x+9l73cWHY9cslj6vLsnzA3699I1a5QUzQVMJz07cz6T1Fj9JoRYfu58
         FlHnKPPp3LrMKnus7nmLP17+dzayYchx6jjXgYAIUI+iyQ1iqaeWcYS9CGE0zaLEzyQ+
         s+Ii1txIP60JFURYNTsJiiWPtRny9De9NRQvW+Q51Fx5f8t+b/8J0OG2wUaQhMrr/XRU
         UIh2sU2VeAkQUWDomU1P/acmfu9xk8rhV6Tigxybrnf50n9bH9QOGoYX0iUKASLatSI+
         ISVQ==
X-Gm-Message-State: AOAM531ILITrI90kwxpZUlvpfmT6TZUXwDawZUyRj+55zVOTwP0Kt2N7
        NLmCxjIG2ZBvRU44VCgOa3I=
X-Google-Smtp-Source: ABdhPJw6TalcEV+heLx4+qc1GbQxvamh3BhYsbEPQQOBujgLoBlGt9km5dkGMa4H2F4qViu0FDdpZg==
X-Received: by 2002:a05:6830:8f:: with SMTP id a15mr26658719oto.299.1618285320137;
        Mon, 12 Apr 2021 20:42:00 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b22sm3168056ots.59.2021.04.12.20.41.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 12 Apr 2021 20:41:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 12 Apr 2021 20:41:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/210] 5.11.14-rc1 review
Message-ID: <20210413034158.GB235256@roeck-us.net>
References: <20210412084016.009884719@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 10:38:25AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.14 release.
> There are 210 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 460 pass: 459 fail: 1
Failed tests:
	sh:rts7751r2dplus_defconfig:ata:net,virtio-net:rootfs

udhcpc fails to get an IP address over virtio-net. I reported the same
problem against mainline. This is a spurious problem; the test succeeds
in roughly every other test. It is unknown at this time if the problem
is the patch introducing the problem (commit 0f6925b3e8da ("virtio_net:
Do not pull payload in skb->head")), the sh4 kernel code, qemu, or the
sh4 compiler (though I tried several compiler versions).

I see that this patch is now in pretty much all kernels, so I may report
this on and off until the underlying problem has been found and fixed.
Until then, I guess we'll have to live with it.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
