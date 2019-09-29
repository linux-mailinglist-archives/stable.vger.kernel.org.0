Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF07C17EA
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730355AbfI2Rkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:40:41 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38021 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730311AbfI2Rkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Sep 2019 13:40:40 -0400
Received: by mail-ot1-f65.google.com with SMTP id e11so6402907otl.5;
        Sun, 29 Sep 2019 10:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ve7rxB9ZMj5czSYDaN0Uxw0Wby0sNRvwLMifsqGb/5E=;
        b=i0gN/Ywyd/RAVY4l2++/ZIbrc2zlSzz0S6PMEow/C9Cis53XK71B86z1OOLipDbzah
         P1yZXo5amWuEwq/+xPi2ddKuJ92fA7es4S1U1Kcf+b1ApxIkFhlSlTTy4a0P8RwBjjIe
         DH4OWvCCJufq/9DVq9gRRl+FnFbJ7QRyi/HqBeLsZBv0NSUTZtqQLlSlFe+F/xWIm0Zr
         +g9AF5imAjKuYt5T70ZOxsMyS+c2K4/CsqeiVl3mx9NHnWF4U1G0j+uJgCZz7y5Vn5Ty
         HRCuu2GICvoIAdqmp2vycJV1LDjd1kkgoDHYqYsl5URLAI9Kl5ioKgV80Sb7WzhQbCRP
         A+UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ve7rxB9ZMj5czSYDaN0Uxw0Wby0sNRvwLMifsqGb/5E=;
        b=MBDnipn16snweU3iMNJakRV/7DbNQfxoLiSZmH64KdNWced5092WuvcXETQZzxodlB
         gkK28MwBfKHlwmBUnNgKjhr2qvEC7h/c2W+AggkzLQMKeAr2I9LIA3m8umIENi9+WRqf
         UtkPduXIkkyytd48vI8Tk0/VW2izAynbQcO6GneSBYill8nK263NoPbqSWbIePppptu0
         LG8ixqHVnmFe573NNjOPr4+9huOp3HptioVGEac87r6fPRZQrpwBlxlzB7SWJEjXyauX
         iquEK7hvV5zMy3umcZibmOUsLOiH4Fu+XqnPPmYPGdUNIQW1uAEcfqRQ1WL8q2PvD7FC
         sziQ==
X-Gm-Message-State: APjAAAWixcUGmmHJAOfbQSf7fZ6CsGhZnh77KM1yl66SMdk9jcYfqgSr
        bTpJFEUsyAIFHKVHOZhlWK5xw6VmTpXNc7ZCf1s=
X-Google-Smtp-Source: APXvYqyliYf7E6e63O3yuEHXFLrTlJJOrAJSWsAFPySRd/cXNEzeORMhus38zd/8ZCg3GqF77TIq4/6waS7YobDUdPs=
X-Received: by 2002:a9d:6d82:: with SMTP id x2mr10522191otp.42.1569778839479;
 Sun, 29 Sep 2019 10:40:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190929173424.9361-1-sashal@kernel.org> <20190929173424.9361-12-sashal@kernel.org>
In-Reply-To: <20190929173424.9361-12-sashal@kernel.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 29 Sep 2019 19:40:28 +0200
Message-ID: <CAFBinCCD7xTnektDhDa+wRsAWmyzMwgfou59Y3=Qf8b2utaciw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 12/33] MIPS: lantiq: update the clock alias'
 for the mainline PCIe PHY driver
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org, john@phrozen.org, kishon@ti.com,
        ralf@linux-mips.org, robh+dt@kernel.org,
        Hauke Mehrtens <hauke@hauke-m.de>, mark.rutland@arm.com,
        ms@dev.tdt.de
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Sun, Sep 29, 2019 at 7:34 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>
> [ Upstream commit ed90302be64a53d9031c8ce05428c358b16a5d96 ]
>
> The mainline PCIe PHY driver has it's own devicetree node. Update the
> clock alias so the mainline driver finds the clocks.
the mainline PCIe PHY driver only made it into Linux 5.4
I am pointing this out because OpenWrt uses an out-of-tree PCIe driver
with Linux 4.19 and this patch will break that if we don't do
additional work there

thus I would like to understand why this got queued as backport for
various -stable kernels


Martin
