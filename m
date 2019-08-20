Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 368F196C85
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 00:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbfHTWqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 18:46:10 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36813 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730638AbfHTWqK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 18:46:10 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so167277wrt.3
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 15:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UR3YAsfxd3iOemT/NhCLQ+CsagQyybVBglY8/Y4osVg=;
        b=UTQt78ER3o6haFLWXNcd1TDhq6izfoVW/4QxBV8CypG7q0W93iGnq6wGMPml/y0qtP
         6PLYcHQu+biHlg+PwWpXlTmsCJrxdmeT+3rgSCp/OkQ0bqd67uDJ7XjZLoxKiHCHBKaJ
         p/qpQsnwkmjEBpbNb6G2nkj46iNINNvln2tkfqldeNNG1qlc8VEVcwKS+jsVJn7p8V6d
         qHY5eJm+CYvt6b4LxkR7eUqXIYWcKqrLp2RNRHZfmhYJsyrzxQ7/MuJztlt0FOL9cEno
         amJC76jL5Dc31Ri2Tty3phwv/6SIQSZmeBCtkuthymUbmHgWSXuXTCaS2JCEQB6m+KKt
         x9bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UR3YAsfxd3iOemT/NhCLQ+CsagQyybVBglY8/Y4osVg=;
        b=qeeWF30umQGpoVYcbX+OVgQxsQAl0s5kqatmVyHG0CmlpqXu2ZIF2oQz7Q9YCHdgSc
         beG6YzL7GiFpN8/si0FilXiyw3ZV+36XWe6KwDcJlTvYJ+sSCQD/AkOul6F3AU+Ml7eo
         8gV7uMQegKi6IYIIzCYBTdKMtGl4Rxnzg0bF1o0QMIT/hcQu+AQxYjyIQmo3XsH7f1ht
         L+/jf/MngWgwaQnh/VceBRNpTsdEaeJYH+oRxGbiplLf4N0ee55wgZv4GRyZMhtYyffI
         CDFzwhjhnkgNSmAxpSAbVlAqqX8Gbf+u2mwVlCYVjSzOzt8NbSY8NexDnqLdzILhrSyx
         FG7w==
X-Gm-Message-State: APjAAAXX7VYObNn67dmxEadeG4pD0pzAnt2hr3xuh6Eh55DmnND7hFvO
        RxHHhC2cZGnjoJJ+w9ce7WOiWEI+BsVDng==
X-Google-Smtp-Source: APXvYqx26srWWPo0A+w77+TxezsBeF6P+Ube0p5Vr0Va4hknEiBagKdZeDd8CSTmvJ7i6BQcMWVF+w==
X-Received: by 2002:a5d:4b8b:: with SMTP id b11mr37893801wrt.294.1566341168168;
        Tue, 20 Aug 2019 15:46:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 39sm63898356wrc.45.2019.08.20.15.46.07
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 15:46:07 -0700 (PDT)
Message-ID: <5d5c782f.1c69fb81.a2cd7.024c@mx.google.com>
Date:   Tue, 20 Aug 2019 15:46:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189-95-g392b26f11801
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 111 boots: 1 failed,
 102 passed with 8 offline (v4.9.189-95-g392b26f11801)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 111 boots: 1 failed, 102 passed with 8 offline =
(v4.9.189-95-g392b26f11801)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.189-95-g392b26f11801/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.189-95-g392b26f11801/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.189-95-g392b26f11801
Git Commit: 392b26f118019e3dd03e7a32e0ea050227dc595d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 21 SoC families, 15 builds out of 196

Boot Failure Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

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
