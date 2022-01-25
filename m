Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03D649BC51
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 20:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiAYTm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 14:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiAYTma (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 14:42:30 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E2BC06173B;
        Tue, 25 Jan 2022 11:42:30 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id i1so2678641pla.9;
        Tue, 25 Jan 2022 11:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kTJVFwQiwO8BLs8+JSIrt1xbVtpPlaHIF9g4dJgPwyg=;
        b=SyXfO+Gr4ipD0NgzH7yFZK+MKSyx/TYpzEWenjNrvAJK7/k8Sv1e90gy8KTJ3cafxv
         i4vXkUY+tbYbZzpzNTc41vQae9avLgqw3V2ws76+cxDIzrM6d6Z4hDa9uABSSXus5uw0
         KB538qzdLugNghL1YT0N0OdEP/U5sAB2tQI5PDJAOGEHVHeHM8bEmeHRJCgzTgAKB0gN
         HTLeC0ezktnwu2QaQWk/xmpqnXXFo+MFI2AxCoNBQpzFOXehl1OCvRJRDwMyq5FV7ias
         eb5stz1lQcZ7kARQ5sZTuoYJwbHUkEjC9hiojwcEB/w0sd0qc/UWDjMy9SUMNxioBJjH
         0Kmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kTJVFwQiwO8BLs8+JSIrt1xbVtpPlaHIF9g4dJgPwyg=;
        b=TMddaNlHTxNlTkSv4ERVS9VbDhA9Nl5xrnqgsSeC5jHqZ678MxQdjYC224jKFKbM9e
         gxyvT6DFdM5qjEkc30f3RzP22DCRX+U4d7aTX9StBOFZ7ss/5PiHW4pWNuouel4wVXAR
         m4hobJy7Ek38cQtkIO6NpGhbeEpKYdeJ6eu8a/iOe0z9Ofr7Y92XfKiY5SggHPFteb2C
         QMaQUJ/aPepDc2g4vGY3SygQ+RpMjb3wf8mdLa5GdAYgT2PjqsCq9x5kB5QVWHStIoKb
         dDdae+x+kcgLVL8zmDDR35EzpoUVCiGU0z6YSRcBaaUx7+TS+ZM8m3I4TiuBR0XCn8B6
         xzQg==
X-Gm-Message-State: AOAM532BhBreD+BGTx/Spdu7sVU9eVMW3HEVjPlXM1+y80/vUg66eL2i
        /SjFMJqHkj9BW61fvaGZuGkk8TnemCk=
X-Google-Smtp-Source: ABdhPJxuJxb83PUP7ERdwGGSRwW06hDJbWyMuOkH4UW2Zs4HZhWJdCDZl8gnu3XQqPk2WL2F8upHUw==
X-Received: by 2002:a17:903:32d2:b0:14b:612:7fae with SMTP id i18-20020a17090332d200b0014b06127faemr20140195plr.80.1643139749065;
        Tue, 25 Jan 2022 11:42:29 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a1sm15087343pgm.83.2022.01.25.11.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 11:42:28 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM
        BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE...),
        Linus Walleij <linus.walleij@linaro.org>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <wahrenst@gmx.net>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Phil Elwell <phil@raspberrypi.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-gpio@vger.kernel.org (open list:PIN CONTROL SUBSYSTEM),
        linux-rpi-kernel@lists.infradead.org (moderated list:BROADCOM
        BCM2711/BCM2835 ARM ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM
        BCM2711/BCM2835 ARM ARCHITECTURE)
Subject: [PATCH stable 5.4 0/7] pinctrl-bcm2835 gpio-ranges bugfix
Date:   Tue, 25 Jan 2022 11:42:15 -0800
Message-Id: <20220125194222.12783-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

This patch series is intended to backport the fix from Phil "pinctrl:
bcm2835: Change init order for gpio hogs" into the 5.4 tree since the
blamed commit:

73345a18d464b ("pinctrl: bcm2835: Pass irqchip when adding gpiochip")

is in 5.4. To get there, I did backport a number of changes in order for
the commit "pinctrl: bcm2835: Change init order for gpio hogs" to apply
cleanly with no hunks.

Those should have no functional impact since we do not have support for
7211 or 2711 in the upstream stable 5.4.

Both the pinctrl *and* the DTS changes must be taken in lockstep
otherwise the GPIO pins are simply not usable unfortunately.

Thanks!

Florian Fainelli (2):
  pinctrl: bcm2835: Match BCM7211 compatible string
  pinctrl: bcm2835: Add support for wake-up interrupts

Phil Elwell (2):
  pinctrl: bcm2835: Change init order for gpio hogs
  ARM: dts: gpio-ranges property is now required

Stefan Wahren (3):
  pinctrl: bcm2835: Drop unused define
  pinctrl: bcm2835: Refactor platform data
  pinctrl: bcm2835: Add support for all GPIOs on BCM2711

 arch/arm/boot/dts/bcm283x.dtsi        |   1 +
 drivers/pinctrl/bcm/pinctrl-bcm2835.c | 209 +++++++++++++++++++++-----
 2 files changed, 175 insertions(+), 35 deletions(-)

-- 
2.25.1

