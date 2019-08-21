Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8EF96E77
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 02:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfHUAkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 20:40:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42236 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbfHUAkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 20:40:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id b16so307864wrq.9
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 17:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qAT0UmnCuLH986QggjXFNUwZ5buzyydOQJ+56ghcoy8=;
        b=uQDuKHh8AEyDZJ02TH8mzoK8luQtGQdxgv6HBM3mV8TeO8D2m+60+Bd34iQ9Cy6M47
         3I76gznN8bU8fXPjCJpMHT8QTvvi/TPzyAQPN9VPpfgfVIhlrM8v/AZ2RUWB5dKTzxXb
         AX0ZuqM6guObnLCS/9cQ0Kb4+07D2TpzqM5lmoxL98ZgBik0C8StFi1RDKcxwdoFuq7W
         74bvc+3Rrzezzyc9s2ht6zLPijWHFyTqBJD+I6CnZEkWOO3DOMat6iSaeC9lMMx1K4Bv
         8/cdvClRnITmRTFlOde2xek+PFgFENip5Pts+gPwIrsMoF9nCcFbClLzTwshzmoNX4+a
         kCNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qAT0UmnCuLH986QggjXFNUwZ5buzyydOQJ+56ghcoy8=;
        b=GIYSI+pA0Q09Ka1eL+DpDZY+xDmSv7PLig6kjKf0dExVUh2d5QGbLch3btOdw46+NE
         o/7dkTQ4ZgINDKWKk0OmCbhK6K6cPM7VlWJI8pPDPp+c0f+io07OammxCl9JVKgS2B/5
         B3PTJsDcvvHX2NCuows81uXnxb1Xgxfcz/37XDB4mKR3owzMu0bH9NMJWo5ep2y21tKz
         BzlKlql2Gx2IpRbrTMfH7/T1dO3QeE95OsJ0DEBYjl/5goQxoo5QZRfUTLRRAt0z/LEm
         ASWvvkUFzICK1WF+OJUsUnUhboI94iDrecPlM6vgvFfh4/t5P+eVdmQN23WJboxpcsy/
         qKAQ==
X-Gm-Message-State: APjAAAX863MUmMJFOFkAKUJmyt3lyxc3Ric9pniQKXZBzmsbfeuxqjIu
        kTK4A1JVhaW7denTHWz38sOMJ+B7J55dgA==
X-Google-Smtp-Source: APXvYqxN+YkIvD/BM6AbbC5BkYAu76UW7fX1DH+NTyTc5ocnljKlcJaAVYmAqfykYPUQoCOA/CDYMQ==
X-Received: by 2002:a05:6000:10cf:: with SMTP id b15mr36869635wrx.180.1566348010019;
        Tue, 20 Aug 2019 17:40:10 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x26sm1028008wmj.42.2019.08.20.17.40.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 17:40:08 -0700 (PDT)
Message-ID: <5d5c92e8.1c69fb81.bb71.492b@mx.google.com>
Date:   Tue, 20 Aug 2019 17:40:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189-67-g2903ceafe8a3
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 100 boots: 2 failed,
 90 passed with 7 offline, 1 untried/unknown (v4.4.189-67-g2903ceafe8a3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 100 boots: 2 failed, 90 passed with 7 offline, =
1 untried/unknown (v4.4.189-67-g2903ceafe8a3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.189-67-g2903ceafe8a3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.189-67-g2903ceafe8a3/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.189-67-g2903ceafe8a3
Git Commit: 2903ceafe8a3f0517be4ce88bbffdb8b45525d5a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 19 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

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
