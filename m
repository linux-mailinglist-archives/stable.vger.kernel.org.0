Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92241ED5C
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 01:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbfD2Xhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 19:37:45 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:35260 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729063AbfD2Xhp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 19:37:45 -0400
Received: by mail-wm1-f49.google.com with SMTP id y197so1522303wmd.0
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 16:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wr4uqHuoD+/y5p3zk37iUewkWY0octkzIYWfowSuzKo=;
        b=X6lFT/v0/6SP1sANJmLTKwAlMrqoGZZbPCznat9vLIrM27y7kLOyjfbHk7t0pQffyi
         UmXJnTQxvsOv2yAnUWqRWSO0lt6ekjgWuM7UdieD8pK853DOI7MDccLn+Z4cSwtM37vU
         /bHtIizWJPQGEoNguk23T5gfYyHkc/EXNI/x8xWoCMoWJZRHpixm3+iGY0zuC7Q9utdX
         I90yyKI+kHifYrb7CFjONk8kTYaxCuHo2mHzt+WQsYuY+mHFDrU8iO1lMERsPzwJ4zyd
         Q2jXyWGJi3kVeUPSHuHw6ccC0Ddctdyz6ZvfRDwTQsS4qIl3p4MkN9MHDImkRaaXDx2V
         jp3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wr4uqHuoD+/y5p3zk37iUewkWY0octkzIYWfowSuzKo=;
        b=NT88XccB45a4C9PJmUz9PJeaZhKuDACJ6QS3x7FpQOtzaWkOxSQ41YZO1LG96dgrXp
         Ugnjfp5RIlNlK1hkp8xfAfaevKfNyRt2UZ1nBoouQOPJrSoOmgKBUV8/RxQhfPt0dL5R
         WSYrD6mAAWXUfqaLg0GS04uf6ePlB5fBJelcLBEHeJmL5wv/t8b8+6ABXwphTm9qOPB2
         N7pCCxfi94xTVTJFzcTcpGY6Fw/3GcPwjR3nt/pT6CFr7o9l4ZpHRXzw2u6t2jGdelLJ
         6GfxQP/ila0oPsfdztQxc2yanlGdNkvG8BQJduB3RpfoculDL09HbbJ0WBTDWzzI9cx4
         92Pw==
X-Gm-Message-State: APjAAAXzbHWUj7EBBzSP59SopPl+YZhYI4CLisWwZ7ojtFXTcAH1dqZF
        KYpbg2Yj/jS2qcgV75sp4W5HDMhGunVGfg==
X-Google-Smtp-Source: APXvYqzINq0A5gTJ5e8EjmP/9JtG72MlJ7AOzhpDs8xZGURx2PVnEWRpqDkaqd4ySpHJkYAlyoIc+A==
X-Received: by 2002:a1c:cc15:: with SMTP id h21mr952030wmb.85.1556581063719;
        Mon, 29 Apr 2019 16:37:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u5sm662047wml.4.2019.04.29.16.37.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 16:37:43 -0700 (PDT)
Message-ID: <5cc78ac7.1c69fb81.cb4c6.3d30@mx.google.com>
Date:   Mon, 29 Apr 2019 16:37:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.37-84-g91bb4a861b13
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 121 boots: 1 failed,
 118 passed with 1 offline, 1 untried/unknown (v4.19.37-84-g91bb4a861b13)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 121 boots: 1 failed, 118 passed with 1 offline=
, 1 untried/unknown (v4.19.37-84-g91bb4a861b13)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.37-84-g91bb4a861b13/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.37-84-g91bb4a861b13/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.37-84-g91bb4a861b13
Git Commit: 91bb4a861b1348dfdb5663859e8b4790a3c07aa6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-7:
          meson8b-odroidc1:
              lab-baylibre: new failure (last pass: v4.19.36-99-gc60b2d434e=
04)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-7:
            meson8b-odroidc1: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
