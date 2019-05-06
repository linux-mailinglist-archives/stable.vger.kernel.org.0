Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E345C1492F
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 13:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfEFLzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 07:55:20 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:38124 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfEFLzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 07:55:20 -0400
Received: by mail-wr1-f44.google.com with SMTP id k16so16879622wrn.5
        for <stable@vger.kernel.org>; Mon, 06 May 2019 04:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3Q2a+soMHGpqpCo5KvQX+6KGqc6mJtzoMwcrmOzT6E8=;
        b=eMvBniUVweLbPQrtqxTP9Djzwuu6ZeFX139sNjgCfblIeqXBAgWxiWg6pHtppBVu1S
         /Hh0/DC3BWzYIRr6QrUhEH6/dSrM7g9fLeG+UWIbpIFE1dqmIKwZOq5Pqnj1jfz+/5bT
         PIE9OkA26ubw0545VTDbdzE2HbF63saGTu//f4W/oqh4S0/Olzj9KKoOwikbV2F1QLlA
         1B3PO5uiOpIp1MuMbd8/xgp+5LPt/4J4AAzHfbQG7mRwkdP0D7wbDLZA028ys87nPTY0
         Nj6IM7TzkbZ0yWjR6ZVUsaXvrBY72YOZPq3Za8klPdFIr4YHGRm55vy4ncbrbwQjqvPm
         StpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3Q2a+soMHGpqpCo5KvQX+6KGqc6mJtzoMwcrmOzT6E8=;
        b=cph6iN6KelXtjsOWP5m7ClCcVDwNkODzzKxaDIQrGtLad+TmD1ZeuwjObz621h7imo
         9RELGQ7fhKYXZqIGiA1cnzZYr+2s7Tfy5cFUuxIKYuGLbp/IA183XqOY8CZNrgK5QHW4
         DEQ0vwgEWJm/dEvZ5oN3pvjMN8gfRSm80XqLsN+e/IALwdIWY+6VtTH2RkbTF33Kc6ch
         AmYt3FyPNuOG98+RcedZYEOgIMR3swI/MgXg0EQWRV+g6m5C5S9wsVqOvli4PCBoW/P+
         FeRvutCjuPW9XKbpBM08aztg6t3AEa5cqgDqkp2bJ+sKboEttV990cjHbAw3oAPMIJ3h
         0y0Q==
X-Gm-Message-State: APjAAAW61omIoihwkm7b8jOtludUOkn/9kirPeT3Ma2ry+U4YzijirF5
        a95udhUicPdFjM9yETcj9ZUs2u8U4r258Q==
X-Google-Smtp-Source: APXvYqyNQiqQDNGSLYxjRDWTKT/V4GPv4MqrKGEMv7wKdqIAgr7+H7k3s7PFNqKeovV06nQq6UsF8A==
X-Received: by 2002:a5d:52c4:: with SMTP id r4mr13386363wrv.79.1557143718531;
        Mon, 06 May 2019 04:55:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l19sm14017858wrg.29.2019.05.06.04.55.17
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 04:55:18 -0700 (PDT)
Message-ID: <5cd020a6.1c69fb81.8e3aa.b257@mx.google.com>
Date:   Mon, 06 May 2019 04:55:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.179-136-g55c41b0398ac
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 91 boots: 2 failed,
 87 passed with 1 offline, 1 untried/unknown (v4.4.179-136-g55c41b0398ac)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 91 boots: 2 failed, 87 passed with 1 offline, 1=
 untried/unknown (v4.4.179-136-g55c41b0398ac)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.179-136-g55c41b0398ac/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.179-136-g55c41b0398ac/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.179-136-g55c41b0398ac
Git Commit: 55c41b0398ac4f6332d362d8078739ef43b99f4d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 21 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-7:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.4.179-120-g2f22b9644=
d76)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-7:
            omap3-beagle-xm: 1 failed lab

arm64:
    defconfig:
        gcc-7:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
