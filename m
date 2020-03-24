Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00845191166
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgCXNnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:43:19 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45061 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbgCXNnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 09:43:18 -0400
Received: by mail-pl1-f193.google.com with SMTP id b9so7394559pls.12
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 06:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PNo/auarkrr1IZlAMScoMbKDySrF9y1cdLk0roslxTw=;
        b=WThc4DHzExaGel4hUqr6YQefN8OOx7UCPub8AXaBTYxILjX92II/HV3CbOSEYbh5qE
         mvospm7lWFzOp7QE36F8r5jDPAOeqjJy1HRdP11DBD6VClbxABQi9qs/CP39stoFzYar
         bnB0QXPLjk8jcdrXm2eadt2lNBibktIvm/m1seoUZ7e/IncsiKRMWQcUDTYqPhcnxiA1
         bAKmjoCv3t5KgsjegDna9kJ7NmxdOwMJqj4P0pYYAsboVbU7QK6VDEQ2uuN5ebx+PNlo
         xvLrWSqkJvNebf7ux5NIkkNMLEEzDruhMZf7pOuqPxHAp/SwcH34bkHhkuXjLGF4EuRo
         w8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PNo/auarkrr1IZlAMScoMbKDySrF9y1cdLk0roslxTw=;
        b=cxNh+QZa+uYS091f5F3pqqPEjLdGqAqQe+tOpBy316WpR26z0wCqIzyTTMDJonqzL3
         ucBu6EbT2pHh0L7hGKry7+ImEt5DCjFMxvJ6mMnqEl20OeCIUq64OvQeZU8ILz3mPki4
         pEC/oQdZt86BTwxX9xJ9GlclEMGGo4GLntev9CKnlurUlf7ga9RBdtt6/jdAuvESUIo7
         nKH4yR6MK8QOFKsNjouCHR6wva8sPN+uQ63F124Rf9EOoYA6a+ysx9h0bcivbYr25aaG
         FU8A24EOxDURDdsM92jAfrpn6+HkxfjUKUpfYPyYxqnBXYZpHI1QPnP9c4V25PrwJ46i
         B4cw==
X-Gm-Message-State: ANhLgQ3Kgsjc0TZLzAP2eNBSYvYeJdcZaaBblFXW3VpSttz3GgZr3ITl
        4WPndHs7EuoN7iYiRaNw9jvoQwvC+zA=
X-Google-Smtp-Source: ADFU+vvFiWfF+rKIUa0aOC5IyasRQpRB4qI817t8idxJHS4ybk+MCzlw9UDDaSsv2psl5bpwkmOD4A==
X-Received: by 2002:a17:902:b198:: with SMTP id s24mr26016256plr.89.1585057397137;
        Tue, 24 Mar 2020 06:43:17 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 184sm14693320pgb.52.2020.03.24.06.43.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 06:43:16 -0700 (PDT)
Message-ID: <5e7a0e74.1c69fb81.773ce.8f97@mx.google.com>
Date:   Tue, 24 Mar 2020 06:43:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.109-192-gbae09bf235a5
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 143 boots: 1 failed,
 133 passed with 3 offline, 6 untried/unknown (v4.19.109-192-gbae09bf235a5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 143 boots: 1 failed, 133 passed with 3 offline=
, 6 untried/unknown (v4.19.109-192-gbae09bf235a5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.109-192-gbae09bf235a5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.109-192-gbae09bf235a5/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.109-192-gbae09bf235a5
Git Commit: bae09bf235a5a9716c5912377626a912457fceea
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 82 unique boards, 22 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 44 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 11 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.19.109-188-g42b2432a=
2ac3)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.109-188-g42b2432=
a2ac3)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.109-188-g=
42b2432a2ac3)
          meson-gxl-s905x-libretech-cc:
              lab-clabbe: new failure (last pass: v4.19.109-188-g42b2432a2a=
c3)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
