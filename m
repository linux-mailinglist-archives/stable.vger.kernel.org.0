Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3865B19B6EB
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 22:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732720AbgDAU1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 16:27:07 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41430 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732385AbgDAU1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 16:27:07 -0400
Received: by mail-pg1-f196.google.com with SMTP id b1so689929pgm.8
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 13:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HMabI+dzEhqP3Ci1TUF+X1pey5bQc0FoFjr3tMHU60I=;
        b=VSJVx9ATKGZNi9HbrNlJKfUfUg4b2PQAQjm8Vj9Gm0bi6xn5rsaE41s2E3TBPtobXJ
         fstSGnA6SZNbk7VBed/SJybrRhtb/YyC1UepbsAzjNhDbXKFtICOUiTUzMha3KTKRk1B
         MHLgNGRw8W8L6CVJScpmVeOs350ce8ee9Xm1mrrspRkZKA+m2XrI6nW3weROnJ6ReWfw
         Dv5JzSZmIWOMpBMJ7mgRsGB9emm+TwJOcavcqpcBIb4HrHb6dimMz6s+NJah0qZDgn0R
         +V1SddWrIHLFzBesrHIN0tJpivX/SzYeBJPcEvwTnutwha/3ZmscLAQB+T7cqkXuodBq
         BCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HMabI+dzEhqP3Ci1TUF+X1pey5bQc0FoFjr3tMHU60I=;
        b=blSQk5Rv3YGdw2MwMl1X5tvY9JOutYfpG36Ku1Yt1k4pOMqvqHG2DHzfdQi4OUreVl
         n8EW2QdMWCZnrMNHmeEVN2lYh/CSDciJOIuFKUMiYXv6y+2a/pv0V+wCMnKUqN1jre5o
         0wT+uTq/FrAsGGVcnXA0f9Gzlh+FhhIudFvLU2LzARK6Icu+7bldsCSeU0Gv2fnq0mJD
         4x34KpDUX25AvaNxyM9jBStO3VJ8ZT5h4eDfSfkBVMBYMEgTSYKk3xNZpdrEV8whXTYl
         M6yBkvuV0pHJrNFbB1LutPjVBJLQpN1p3xmSX7ZIifGL1eyuPr78xsemM2OuMq8ADetT
         PYCw==
X-Gm-Message-State: AGi0PuZ0mKX8XJMxxZBJqAjnY0ZQDhfjmIcfdRzYe+wpEe5hyFPbIxzJ
        diwLEsvk2wb98rBbkYqGIz0QFSnt4yI=
X-Google-Smtp-Source: APiQypKbkFwxLEIs1U1creUuGMCF+QKlyzI6hafZOUx0p+ixHGTPnHys/ouHWzNKlSYU2HI83/NtwQ==
X-Received: by 2002:a63:2057:: with SMTP id r23mr16192197pgm.232.1585772825617;
        Wed, 01 Apr 2020 13:27:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e6sm2071509pgu.44.2020.04.01.13.27.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 13:27:04 -0700 (PDT)
Message-ID: <5e84f918.1c69fb81.fb26a.a927@mx.google.com>
Date:   Wed, 01 Apr 2020 13:27:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.29
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 168 boots: 2 failed,
 158 passed with 3 offline, 5 untried/unknown (v5.4.29)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 168 boots: 2 failed, 158 passed with 3 offline,=
 5 untried/unknown (v5.4.29)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.29/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.29/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.29
Git Commit: 73fea3292b4995fe5c20f774421705ada0e62100
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 102 unique boards, 26 SoC families, 21 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 53 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 16 days (last pass: v5.4.25 - fir=
st fail: v5.4.25-58-gc72f49ecd87b)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.28-157-gfae891585=
ecd)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.28-157-gfa=
e891585ecd)
          meson-gxm-q200:
              lab-baylibre: new failure (last pass: v5.4.28-157-gfae891585e=
cd)

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

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
