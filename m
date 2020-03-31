Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73CBB199AC1
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 18:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731335AbgCaQEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 12:04:13 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:54369 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731260AbgCaQEM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 12:04:12 -0400
Received: by mail-pj1-f68.google.com with SMTP id np9so1253400pjb.4
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 09:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=29LBCGUo2t8Dglh5G0sWquLf8528pJY/08MW38tkCtg=;
        b=Lx1WDv6v8nZ7AEjuXlMvYfroBwR+V3B+DbVtU04TapUW1q4kRztY/NeviCOgIBxMP+
         i76FdoBkV03voMF5q2TaQFCxK+MHa0ASbPJp9MJJ57AK+46bCfKQso7QIlqZPYtdoLuw
         KIV+zqZr6mc6JIXqnzhTVkB9AAPTUhcrVzo3ju8OnnlDsZsdkQUgaPDLDg09TIoO9Szg
         Tp7Dj5e4aw5M3sajLacM2vPD0D886+rdvkMRahQcjwrKCW4CvYwNdv1uYE6ojh6mEpcY
         DbGDOp3U23kU6TMs4o/7WASrW2i5W1T9dpUg2StrzECUxgKHvvjT4zwS3Np2IFhEtXgV
         BgUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=29LBCGUo2t8Dglh5G0sWquLf8528pJY/08MW38tkCtg=;
        b=h9FzWv7uRbPQ0Qet8Rp3IfPBefTmVPp4VPXuUd+iH9uixkUaPEr9PM4uT/OgRkIP2w
         8sTZt1XZkGhXvjC5Erol07Mjp8hdMkq2sKs2t53ywI3VkhdXm1Ssh1mgXLo4fKJ7LPXm
         xpgjyf5IEG66GJILCuIy9+DmHcUKM7Tt0UvsGckk/vNMpzzVLC6CwaBSM30jVqcBqRwD
         ktjZjQJaD1qBeoMp+F6pE62D6RCWyAUfMou+V3739hbe+jN3DYqprXl1hzs7lAgEbbZu
         z/q/AcGpdHKGjdWZ8mVwbvDg73iCgkA/XEIdMRK1PFQAEACdOR7YYCBf5nPTHcVE71hD
         glyA==
X-Gm-Message-State: AGi0PubvLnghMAY0HaSBYGbIwk4wJ4/SBPv2oORbDTKu3zmDJ0L8SEpc
        cc/rjwOrwV7IA7vPrPeWXjmpXrEYlEA=
X-Google-Smtp-Source: APiQypJ5bv7dMLAKAHLsByMoLgceZ0t/wBZW69CWZmaEbsMmaVCaYIkpsL9Yf2x/QHoWbRCUzXI2TQ==
X-Received: by 2002:a17:90a:8a08:: with SMTP id w8mr4950397pjn.119.1585670650200;
        Tue, 31 Mar 2020 09:04:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y131sm12679591pfg.25.2020.03.31.09.04.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 09:04:09 -0700 (PDT)
Message-ID: <5e8369f9.1c69fb81.5fe9b.8cc5@mx.google.com>
Date:   Tue, 31 Mar 2020 09:04:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.113-97-gaa90b785f040
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 136 boots: 1 failed,
 130 passed with 3 offline, 2 untried/unknown (v4.19.113-97-gaa90b785f040)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 136 boots: 1 failed, 130 passed with 3 offline=
, 2 untried/unknown (v4.19.113-97-gaa90b785f040)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.113-97-gaa90b785f040/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.113-97-gaa90b785f040/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.113-97-gaa90b785f040
Git Commit: aa90b785f0405d6a6780862cf951250a09e58af6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 82 unique boards, 22 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 51 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 18 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.113-79-g8=
1a370c0d238)

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

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
