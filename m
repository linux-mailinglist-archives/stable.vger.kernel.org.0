Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B0E1B3655
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 06:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgDVE1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 00:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725355AbgDVE1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 00:27:20 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66823C061BD3
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 21:27:20 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t11so470541pgg.2
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 21:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1VTZss1KxRrMJsxUo5qhlxDIB70S3PAmwXKi2s+jenQ=;
        b=1pLPq1+bUSBn4OPMJOLdz+Bqz8u048iCbHv7mO8+QqBlx650WC83pw47UcXuk7f3op
         jcDPnWT4ZQjkolyHcgRPBYN4/USHhkuNNZ+CbUdIrjqj9aAXBrWs6hHSb3SPD0WbUDkd
         UqBvysocUr8jRafOSJia2Kh+dlqHz7BY8VsjuV1LZMxj/3piwsOvzAouAI49b39z8JC6
         U2DfbrFZKEhBU9LjBD65GCDxNAmuU+3HGllV6dk5ftAOT+GcdFzf82aAMGvT40qtiksb
         Q1eCO2GRpDAn6JQOiYwUF542ZWYRUaeyg62benWsrsdFPLODbT7A441FFiuzcwYZd3zj
         gD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1VTZss1KxRrMJsxUo5qhlxDIB70S3PAmwXKi2s+jenQ=;
        b=BPO+YPRuWVeeGSigdgx+QT5JI5MYnimrjt5Y6X+xCK9B0UA2DIlDHrnZR9E+5+8qUi
         /iULePs6qtvH+Tf5CNat9FJZQ30k/wwFJJgjbHTSfnDdIFF0YJJDWsuLK6lzL7TGJtXg
         uz4mHeTo66S7nykhrcDxYdTDQnZSN6QPGPVzlMMsMWdXtIizQ/cwJ6uFJF0eOxiCBEEi
         6m4LJ+qQraoZYx/5ocUQ3Xa6cQmlLBYpnMTOkao5HU1avixqPuiP2Z8hMre0VfGDFlSA
         d6GbLNwJ8lMkvr+9o3W5bmupjtyk+ytjZU1LU2QNnlOkNPZmZN3ud3fTqwUFhspxUb5P
         wihQ==
X-Gm-Message-State: AGi0PuaibqibQXU8YPdDyQequTum82B6GSDlChlK2pdcIEmcdymLvGi2
        +bbxFRqnazo7hpud91nNXmGJDbGnEL8=
X-Google-Smtp-Source: APiQypKXfyeB2LTdTjiizBYf6MVDp7k6+0wT3HYPWWAwrD05UeHbIgYUgWaTrv2GoPa2fu06J6wn6w==
X-Received: by 2002:aa7:9251:: with SMTP id 17mr20645588pfp.315.1587529639476;
        Tue, 21 Apr 2020 21:27:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 17sm3763755pgg.76.2020.04.21.21.27.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 21:27:18 -0700 (PDT)
Message-ID: <5e9fc7a6.1c69fb81.d4539.d130@mx.google.com>
Date:   Tue, 21 Apr 2020 21:27:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.117-18-gff69db5bee37
Subject: stable-rc/linux-4.19.y boot: 87 boots: 1 failed,
 79 passed with 3 offline, 4 untried/unknown (v4.19.117-18-gff69db5bee37)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 87 boots: 1 failed, 79 passed with 3 offline, =
4 untried/unknown (v4.19.117-18-gff69db5bee37)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.117-18-gff69db5bee37/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.117-18-gff69db5bee37/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.117-18-gff69db5bee37
Git Commit: ff69db5bee37bd5f8e4f93ac823ec0bb0fc367d5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 58 unique boards, 18 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-cubieboard2:
              lab-clabbe: new failure (last pass: v4.19.117)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 73 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.116-41-gd=
f86600ce713)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-collabora: new failure (last pass: v4.19.117)

Boot Failure Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            qemu_x86_64: 1 failed lab

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
