Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7BFC1A3B2C
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 22:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgDIUMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 16:12:10 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46261 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgDIUMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 16:12:10 -0400
Received: by mail-pg1-f195.google.com with SMTP id k191so5457254pgc.13
        for <stable@vger.kernel.org>; Thu, 09 Apr 2020 13:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WFrvl9fyXVTH8MC+bpemcG4hmQqXzIiDWoTmQZMEnu0=;
        b=grg9WjbLnwaj6biWaBVPGzxA0/nKVsLVjDA0HK5B2KVUJp2h2V85QDaRW51nh9KxZD
         ib6k1BxOTDPPU8hHft99gDqKby0lGxPBcxh8/jjhJe/kRQvQG70kpLdKxkUBMNj1UET2
         sBrtZH36LJoDWs8ZqWXW7r4LPMtjJB4lcVA2NwA1QbqaeWQEjQ9kZW+WWrWPM+VlO8nU
         l01TT1Hg+g7PLI9IXui6OxQDshvwfYFsuNBBrH2HatARB0mWELbTZlrTkAlw8Jx/sLjf
         9Q9OFNsEQW+omDqsd0hq3TbUIPd8znO/rkahQojIQ1+kwGNF3/uEx+LMlvuRDPUietf/
         pSFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WFrvl9fyXVTH8MC+bpemcG4hmQqXzIiDWoTmQZMEnu0=;
        b=ntrl7bKmQNZ67+mqqLEgc0bkXeXoR1bNaGmjGVv8fYQuygSje758g+YidVDqUwxaaV
         +kbHwW2BQZqxwhlhWCRDS7i8gBvnF0x4ol5wB+AzVB2p0Ojg0427fajuJgkZNfK602Ve
         TqlxA8rcXbnBSq9QAvuwVckYtJ5c9/rqMJvksImhCRSi2qlp5254nqBr6pJGOtRxSUvr
         ydUpnhqA3hH0o9q3q7vgLzHHEkS9Quv0ouXe4HERCvtNkyYrZpakQsWGqkfQj9FyudUP
         5VgsUtMx1B6QWMeGJwZrnv5CKtLixMlnEcsGRcBxywLUzuGHu5qDKrwLDVUkOvgxmGml
         YPQA==
X-Gm-Message-State: AGi0PuZt+v72lyMZmhTxXvrgLWEPzSyzg3Gjl0j8knM6MgZown0BOxKI
        E3CuB0WG7c7rX69wAgWxbYFP5Iofrko=
X-Google-Smtp-Source: APiQypL3a9Rgd6393KHuFgBYeKjh8L3XwsmAbhAAz2uIGEIE1tlX18sC42kZi1hUNSzvoMuqwlZwBw==
X-Received: by 2002:a63:5fd0:: with SMTP id t199mr1134091pgb.207.1586463127368;
        Thu, 09 Apr 2020 13:12:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c83sm19644112pfb.44.2020.04.09.13.12.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 13:12:06 -0700 (PDT)
Message-ID: <5e8f8196.1c69fb81.439b7.6295@mx.google.com>
Date:   Thu, 09 Apr 2020 13:12:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.218-19-g8b0440867da2
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 96 boots: 3 failed,
 87 passed with 2 offline, 4 untried/unknown (v4.4.218-19-g8b0440867da2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 96 boots: 3 failed, 87 passed with 2 offline, 4=
 untried/unknown (v4.4.218-19-g8b0440867da2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.218-19-g8b0440867da2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.218-19-g8b0440867da2/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.218-19-g8b0440867da2
Git Commit: 8b0440867da246ba6a2e4512f6643702f698eaa4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 61 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 14 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

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

---
For more info write to <info@kernelci.org>
