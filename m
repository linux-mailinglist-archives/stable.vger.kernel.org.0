Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3FD417F02C
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 06:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgCJFhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 01:37:21 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:56141 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgCJFhV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 01:37:21 -0400
Received: by mail-pj1-f68.google.com with SMTP id a18so916641pjs.5
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 22:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LhD8pa2vcKMr8HTuUefxucYGWlLzH+1SjJSyzH7I/cY=;
        b=EQipM5xh+p4Yd1HmF1pQAIVSAqBbvmyqGXekfZs/PVgK0kKbcOuA4CJ2JiOCNlinwo
         Fm3zt1bc/Bm5QBR6dgllFsjURr2EFiI+HpuvUuecbTnecsotnljg0ARDcmiruEwQMlr9
         MpLUqGRFAEuK/CxqlV2OenuZvCSzRzHUujL/i24ZMgJHEXMOt8Qat6xBj0nWs0OlrPgY
         dbixgj7FS9/a57GBB96RhCYGQs3zgAhw/cFsGnr3iXn+hIc5deGURi9csh5w/yp+o45W
         GnpeNTMMhCau/etvJSN8xyZpv9+pOWvbdLzWsrjl3Lv31PIItA0mJftaDbQHLAKDT3Ed
         FNmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LhD8pa2vcKMr8HTuUefxucYGWlLzH+1SjJSyzH7I/cY=;
        b=clWrLk9ueJ4lDDrP2EnRiK9z0igXWC0NWKcOOMwSrK95sMd6ell0tDfhm031nXyEm+
         xLgtlyiAV6WgV5Hl87w9HXb7RbnNaeH5SDF4J850BDFiNRpTACzuFCAhZlf/OcuQZSRF
         xOk2Pd+0MnRf7NevBg2URwkirqknor/9LHD8UP3EtJnkTdrsiDtoM4JASz9/R27VTeRs
         kU7rWf+x1XdV6BMaK3T84keinCK0J+xGmSLHfFyOURbHM4Yft4NT+M3BXHsLC2qLSNzj
         xFUscb77bEwFbt8k+v2BUuWvtfwvMaewh19oPpU89H2Wz6t3XMZKsbkK+UBVPu4Rb8qB
         8Gpw==
X-Gm-Message-State: ANhLgQ3UkfcK/BDbhNzqc7MzrytC2FEtkxD+kgZEhT7ag5/78FAoO9tm
        zh/IsfH35THn0NQBMT/zbp8juFt+hHY=
X-Google-Smtp-Source: ADFU+vu2EwsT6pCQ1WmFQOzBv23L5qhNtm5MSa68NHOs/1ZKm7Z5ETzaBarEMN47KuOUEpz9IKk2Cw==
X-Received: by 2002:a17:902:bd43:: with SMTP id b3mr17917112plx.230.1583818640209;
        Mon, 09 Mar 2020 22:37:20 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y131sm3304923pfg.25.2020.03.09.22.37.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 22:37:19 -0700 (PDT)
Message-ID: <5e67278f.1c69fb81.54160.ad1a@mx.google.com>
Date:   Mon, 09 Mar 2020 22:37:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.172-114-g734382e2d26e
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 95 boots: 2 failed,
 90 passed with 2 offline, 1 untried/unknown (v4.14.172-114-g734382e2d26e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 95 boots: 2 failed, 90 passed with 2 offline, =
1 untried/unknown (v4.14.172-114-g734382e2d26e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.172-114-g734382e2d26e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.172-114-g734382e2d26e/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.172-114-g734382e2d26e
Git Commit: 734382e2d26e735aa51df0230c1efb5ddd6b8dce
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 21 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 30 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 18 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.172)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
