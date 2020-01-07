Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 003E3132B58
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 17:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgAGQr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 11:47:27 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38749 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728384AbgAGQr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 11:47:27 -0500
Received: by mail-lj1-f194.google.com with SMTP id w1so280758ljh.5
        for <stable@vger.kernel.org>; Tue, 07 Jan 2020 08:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZvoR1wO4oEITSwLk+nSR4iwy2dpggu13mmwT8OJyr0g=;
        b=FMjaeoJA437ug2DT9AkKATKeWYluxfalXHIXuGLsu+H/CQWTMXEXGaJONDmFqkXD9Z
         YIl47qQjL9YED4/QKTQMdRBMaR4UtzhzsUP4vEGJgLYsQ8a2Lh84aBwcaeZ5/Dv4RszG
         GuV9ct7YZJyaK5EC0tdAm/MZa1N1zGPbW9Y1BGjKgKcF6Eaa0cfA576OBqXwRNXvngR+
         q5bgSIUOToJTEtbIQwgXjX7ADRA6XiN3fJ+mbM5GBESF0JdmpNuOlJYgepSHvi/UyCa8
         JcMXJizo1L2IUUuDvh8IEVEK/ct86ME35mNKyCYVQXGlZI1mfCA2nsZb30F/bHp35m1X
         AOLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZvoR1wO4oEITSwLk+nSR4iwy2dpggu13mmwT8OJyr0g=;
        b=uJ36im+vnIxaa0Jg+AacQukv+m7gFlPQXNC1LubG/ut+K0T2HzKqmPpcONR8tNpGju
         35G+JqTSlhrtkIbUadvNBAE9MkPlQHSiSneNRdeeIhCLLBoww/EHNlIyJKliTPKak3HO
         D7uizk+0h8iZLJW9zX1NmXxwOL32LBF2jU21P672oawNz3F0ncZGCchyA1PA9MHbBshS
         esLv2Ff0IDPRMH05wYtWYVcw1z6R0y9biSnnjZMbgEJ7zBEaQdGcz55ZPlkyEIX56YbV
         xZMpoaAG3Xe/L24+TXVsJB7n6v6AKGs+AfkFPD8MbydWcnOZXdx2UIjaXexCiZWBWrS4
         Fm9w==
X-Gm-Message-State: APjAAAVOdszzfENEEmN+jj26CuDAzeikpFk/aDn+eEjVDJNenJ80w7C8
        QTBtUsrLpPEGCJJOw61SA+OF/3sZ/n3eKCgrMs7RVQ==
X-Google-Smtp-Source: APXvYqwIOBpCiKZzxq03MFz/y1i3ELijhWT1WUVjLBovW8HeCR9HCsqvBGOQKdcEH2KQk6TVpk5F1srYFucbjgSGpMY=
X-Received: by 2002:a2e:5357:: with SMTP id t23mr215735ljd.227.1578415644575;
 Tue, 07 Jan 2020 08:47:24 -0800 (PST)
MIME-Version: 1.0
References: <20191210185351.14825-1-f.fainelli@gmail.com>
In-Reply-To: <20191210185351.14825-1-f.fainelli@gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 7 Jan 2020 22:17:13 +0530
Message-ID: <CA+G9fYsMyUWGo8Qtd2UCfYDV2aoH71=hCZKaTurq4Aj2eeZczw@mail.gmail.com>
Subject: Re: [PATCH 0/8] ata: ahci_brcm: Fixes and new device support
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tejun Heo <tj@kernel.org>, Jaedon Shin <jaedon.shin@gmail.com>,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 11 Dec 2019 at 00:25, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> Hi Jens,
>
> The first 4 patches are fixes and should ideally be queued up/picked up
> by stable. The last 4 patches add support for BCM7216 which is one of
> our latest devices supported by this driver.
>
> Patch #2 does a few things, but it was pretty badly broken before and it
> is hard not to fix all call sites (probe, suspend, resume) in one shot.
>
> Please let me know if you have any comments.
>
> Thanks!
>
> Florian Fainelli (8):
>   ata: libahci_platform: Export again ahci_platform_<en/dis>able_phys()
>   ata: ahci_brcm: Fix AHCI resources management

Following error on stable-rc 4.14 and 4.9 branch for arm build.

 drivers/ata/ahci_brcm.c: In function 'brcm_ahci_probe':
 drivers/ata/ahci_brcm.c:412:28: error: 'struct brcm_ahci_priv' has no
member named 'rcdev'; did you mean 'dev'?
   if (!IS_ERR_OR_NULL(priv->rcdev))
                             ^~~~~
                             dev
   CC      fs/pnode.o
   CC      block/genhd.o
 drivers/ata/ahci_brcm.c:413:3: error: implicit declaration of
function 'reset_control_assert'; did you mean 'ahci_reset_controller'?
[-Werror=implicit-function-declaration]
    reset_control_assert(priv->rcdev);
    ^~~~~~~~~~~~~~~~~~~~
    ahci_reset_controller
 drivers/ata/ahci_brcm.c:413:30: error: 'struct brcm_ahci_priv' has no
member named 'rcdev'; did you mean 'dev'?
    reset_control_assert(priv->rcdev);
                               ^~~~~
                               dev
 cc1: some warnings being treated as errors

Full build log links,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.14/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/702/consoleText
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.9/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/773/consoleText


-- 
Linaro LKFT
https://lkft.linaro.org
