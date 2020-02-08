Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB997156549
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 16:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgBHP72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 10:59:28 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46876 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbgBHP72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 10:59:28 -0500
Received: by mail-wr1-f66.google.com with SMTP id z7so2328073wrl.13
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 07:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aqXHOxxw3tRZvyJEAZhEKlcBJv7tDrFSqKFi+jkmOss=;
        b=KSsSAZBYcFEssjJBpqCCXOlHWjvBB84Zt6BHG4mkYFhJ4DMBa6gFOS3F+NEUAqExu4
         IfTopcZe53qJsc/z9NemTk/1Ir6RIWiZLXB5H3LNl8wvppUXjZr10ZRQwDU7c/b3dbRN
         8H6jwRjZnH79gBlNUdQ96UDU5L5YqVlSR+v/q7eUU31JEHpfBTGxoR3/0J5eQuONIo9t
         HdPS8HrBzXCL0Z/UHqtGDsju+F4BcZQFuQx/3Xkp1tM7gwx9wM/3660nU3I+z0zPkNQH
         czi96xnRDGyfLz0O/80igM7GfvzuX/QIaftwn3tuHZDURT+XCYzY+ZlIjb4nHPBmIND8
         azkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aqXHOxxw3tRZvyJEAZhEKlcBJv7tDrFSqKFi+jkmOss=;
        b=AuCxOju5FT68uxYR5C3ZcH/YZlL1LPwG9oplP6a/sd36fqzojeLwmUEFug2rnzoi0j
         ukFxlM7fmPxX0QPbuzXDlOmnnGKbk9Nv1nB/mduIzkCApwkDjGX4GrvB3ZqmH9hkpl8u
         2bEVINKroJ9Th0ybzLtUwVnrK3LEdrXTo3t8has/SxYaekvBi4aG5uHDK9LPK27VsaqK
         KOvWM2a5KZGSqTZxT0h+0YKanj1Zcq94fIfU9K3LwQPG5TAds/WRIIPzOe1MaTDUKVy4
         MavX27VFFVtqH6OaEaqtBtv9LYeKB1wTuycTOGDBKuWiE4Nq3hG6kQ9ImpfDE3BaIasr
         VVnA==
X-Gm-Message-State: APjAAAUrx1Mk/zVphWO2Nx9/gShMXGGOvHSxuVQjyzHiTjhjelWKi/7d
        AX5qk02lXvfZmmooT/qPWD6swmRrFl8=
X-Google-Smtp-Source: APXvYqyFkEndCkrU8wMQG6CEDNweRAG6YoahCE9sIxU0agi8mzQM/K6OxJ07pVhVFTZn/0wTR8zb5w==
X-Received: by 2002:adf:f0cb:: with SMTP id x11mr5942842wro.421.1581177564799;
        Sat, 08 Feb 2020 07:59:24 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t81sm7857346wmg.6.2020.02.08.07.59.23
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2020 07:59:24 -0800 (PST)
Message-ID: <5e3edadc.1c69fb81.fbb53.106f@mx.google.com>
Date:   Sat, 08 Feb 2020 07:59:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.213-37-g860ec95da9ad
Subject: stable-rc/linux-4.9.y boot: 20 boots: 1 failed,
 17 passed with 1 offline, 1 untried/unknown (v4.9.213-37-g860ec95da9ad)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 20 boots: 1 failed, 17 passed with 1 offline, 1=
 untried/unknown (v4.9.213-37-g860ec95da9ad)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.213-37-g860ec95da9ad/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.213-37-g860ec95da9ad/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.213-37-g860ec95da9ad
Git Commit: 860ec95da9ada58204579ee8bba33b5f317476e3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 19 unique boards, 10 SoC families, 9 builds out of 140

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.9.213)

arm64:

    defconfig:
        gcc-8:
          r8a7795-salvator-x:
              lab-baylibre: new failure (last pass: v4.9.213)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
