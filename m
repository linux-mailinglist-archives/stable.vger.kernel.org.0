Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1870E90721
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 19:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfHPRlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 13:41:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52885 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfHPRlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 13:41:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id o4so4663430wmh.2
        for <stable@vger.kernel.org>; Fri, 16 Aug 2019 10:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GXYT28CVO74LAuBGbGn5MM8kZHouOqPbS0fbvUsHJBk=;
        b=SQEzNtHr+tKKQdGzJ6/S9OmLz6yO5YJxV4XHSMvJ+vGZUXrf8SvSyD1OTZHVZGKmFE
         A32m66xF0xUbZRo0QA0tW+j8JgqLjx9qVeDfiwZ6oiBQR1qcsE2IkH2LEflZcyq1bXda
         zDvBn/BQmQsjWRItqeL5RfnCCg2VoEN753UNMOgZlw27VTpbnUPQULneaWa0pjRZCUjm
         tOF/eVxATVFpO+0yFvAoLRFfCvXAkqOt193T8YHb1/7+VXD3M3OADuoTVPRfzZfizJM2
         x0tF978cHPcUrFaUkVAlqdNKYj42boleTqsJ0ifseNw4zPPKmE8lynlyUqMgu9sL7G13
         H5EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GXYT28CVO74LAuBGbGn5MM8kZHouOqPbS0fbvUsHJBk=;
        b=FtzKwP9bHXDfYQicCSM7YpMd5CtCChn0v8YGyUMnhJSpE3yUA+wB6CRuDQHzyJyOeZ
         1SffoUZEbfC9DlTxLxiSceEkRD9bUArXIqj1FsdNuZ1I3mjP4Y312eXvNGLuvpcyRL42
         w/2abhbM85cSa5bcYdR+60WfFwySLSUDsw/y55t3IU86CtlFkJh0H+FZuTxB4gXEFcOR
         krVmiuU2cq1VJjA6LAbc/PYYHGWIUpBrkOYE60lGAuBmmlV5JTrfJmRHxFwoCpyu7MCR
         cwKinb0mADsaQvpJw24PLmO0yroldLy/tnJ3CUSehAOMIPs1Sy5Jt0LR5hXdS+Joa+PQ
         oh7Q==
X-Gm-Message-State: APjAAAVdo2ca9ln2yloMl0ccljW5AsoUhHtEpipdVVAer3rx1Fy7ZzLl
        c0ADmrP+q643cckfUD78RDTw4mZRSZg=
X-Google-Smtp-Source: APXvYqxgMne0NUbN1yxy+UDbbWnS6IlaOcAhgAakSpYIn1AyirjOrXfI9lsXfGvBhGQMP8KMVpg2Bg==
X-Received: by 2002:a1c:2d87:: with SMTP id t129mr8367699wmt.157.1565977307797;
        Fri, 16 Aug 2019 10:41:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e11sm15748216wrc.4.2019.08.16.10.41.46
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 10:41:47 -0700 (PDT)
Message-ID: <5d56eadb.1c69fb81.b4ebc.e8bb@mx.google.com>
Date:   Fri, 16 Aug 2019 10:41:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.8-157-g9e53d01dff58
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 143 boots: 2 failed,
 132 passed with 8 offline, 1 untried/unknown (v5.2.8-157-g9e53d01dff58)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 143 boots: 2 failed, 132 passed with 8 offline,=
 1 untried/unknown (v5.2.8-157-g9e53d01dff58)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.8-157-g9e53d01dff58/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.8-157-g9e53d01dff58/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.8-157-g9e53d01dff58
Git Commit: 9e53d01dff5817f759988ef384926ca6f6c5c47d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 82 unique boards, 28 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8 =
- first fail: v5.2.8-145-g2440e485aeda)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8 =
- first fail: v5.2.8-145-g2440e485aeda)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-nanopi-k2: 1 failed lab
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
