Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C366D1D8EBE
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 06:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgESE2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 00:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbgESE2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 00:28:22 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B297C061A0C
        for <stable@vger.kernel.org>; Mon, 18 May 2020 21:28:21 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s10so3565266pgm.0
        for <stable@vger.kernel.org>; Mon, 18 May 2020 21:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4iyMhNBWU5P+1t3mbVf/+TkjU8XKxCU0YGLabis9RH0=;
        b=ir8tpFuRYX0vj69j304b8V097Qlc94QlgGuF5cvvc9Gfzp3D/7rIV35PYD/6mujtM+
         IRw5RORaO+CywjmPQ/pxqVlOfg0H4gvqCOhfYSwqtDPwBd/4fdhuc9eoYJNMnQIOjBCJ
         KXCQj6i1vpKDFkEbyUkapzj4/YfTulCRWcylUKTkFtv+wzPqFmBO4h0qgvkElnfdPbxX
         eH+5i8pXsCvzuajIlzIKkjG+Sk4ELOTGSF/JDJTcQXXtxyRwSYc0pqrjuRCr5R3nZzmo
         U8Pa63Tsgjj+k6M1LV9PSthmMXk902tufIfZWtFZ6ES3oqmrh/XzCyCSHsAIWB2dxvP3
         +RlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4iyMhNBWU5P+1t3mbVf/+TkjU8XKxCU0YGLabis9RH0=;
        b=QEsL99kVfyMg1x/1dpO51igiMbDhI4X54J1/BOzvV3XwixHW+SqAepaqr7EmngFPV8
         GBfhhVSDsa2YsYqGdPmt6TZzF8r+ENNM/czMB6UO42unTgs3rMcMGHQ7XCeQEWCNOR/o
         fnsZvYFiJqMdPfQUAHI2vHt5jPPTnhGTterYLAb5A9YIFnSGB+rK0KYPwUj2E+KCbjyN
         dKhQSXLRRd40RNiKZ8yuElnJumQhduZuhr7jB/rI1F5EdTsjmr44bdmjHuN8c7UinsUt
         OH6QM8wm+Zfxmw1ECrlChdf1A+whZQxM3t0FsilvX5d3MmXskPGzz4vbJebLWW87a+QT
         9vyQ==
X-Gm-Message-State: AOAM533prFjsN3R4QGImEG83Ys1ppK9LlmPFCKjZpCqu+t2DK+kjlx1H
        Ez7nTnW9JbWqFQU0w34fvELSsAzIxTY=
X-Google-Smtp-Source: ABdhPJx0gUeBlFDnatBB354fPZDIThve8pt1v+1URVOhdaQmltc/5Frra3MyBfMH468Ny8yyiAfHDw==
X-Received: by 2002:aa7:9ab6:: with SMTP id x22mr19947699pfi.136.1589862500183;
        Mon, 18 May 2020 21:28:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e12sm8927819pgi.40.2020.05.18.21.28.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 21:28:19 -0700 (PDT)
Message-ID: <5ec36063.1c69fb81.3e76e.b3e2@mx.google.com>
Date:   Mon, 18 May 2020 21:28:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.223-91-g7cb03e23d3f5
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 113 boots: 1 failed,
 101 passed with 6 offline, 5 untried/unknown (v4.9.223-91-g7cb03e23d3f5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kernel/v4.9.223-=
91-g7cb03e23d3f5/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.9.y boot: 113 boots: 1 failed, 101 passed with 6 offline,=
 5 untried/unknown (v4.9.223-91-g7cb03e23d3f5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.223-91-g7cb03e23d3f5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.223-91-g7cb03e23d3f5/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.223-91-g7cb03e23d3f5
Git Commit: 7cb03e23d3f596ac9f89bee7cc836eb292321418
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.9.2=
23 - first fail: v4.9.223-25-g6dfb25040a46)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.223-41-g1ec0b5b2a=
219)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
