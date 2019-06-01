Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2E731FAD
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 16:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfFAOUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 10:20:31 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:37645 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbfFAOUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Jun 2019 10:20:31 -0400
Received: by mail-wr1-f52.google.com with SMTP id h1so8325403wro.4
        for <stable@vger.kernel.org>; Sat, 01 Jun 2019 07:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KQPxMxGUjlJSACfRinLVYx0m+kKV6XkO1GJUf5reDe0=;
        b=UuNP0UxLPgFlCr3uJv0n0bfuBg/VWTqZ1isB4FUjRaEH6bKZDg76hS0txBWDZS/m8g
         ob8IxtVZpIbVB+WxYllpGFZX7AJ5y2UeF6Cf+6qGCTpXsyU49DNVFPQjweOgBFMmtOOW
         pTogpeYwiU+oWokKXgTn3mcGMS56vryiX0MimcIYyN2FzhAQAu2X8DbS9I7j5Lj6m6MS
         kVrVuuTddXpivpwf8r9hRjESLWzpVXLHHPQMhlKN5PnrLbQLdrImYb6ZyqikKwAu0QAD
         ZwwZpWpKR/wFh9iq9TGyilEhYf7wd8HpreRTxJJfDiSVVSXifdPnSYMgSoqPEHKNTZ+u
         2Dgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KQPxMxGUjlJSACfRinLVYx0m+kKV6XkO1GJUf5reDe0=;
        b=ZeTlagFaf5vknAOneJqx0wGq1vp4kkCFY6pfOm2FLv3nIMozzk2ql646VSn/sJjlyU
         m+dIesjpdKWVstBu5Mqe1Mvo+XdEUgRUVBKMR1PoI89OdKX5xELJEYWu5QeWxh4wN7n8
         1sw6iwib82sEqLGu6e2nsRdcpXlZVjVY8u817p2VpRu5YbYiGVGa/+0cEUgIGS7qdBic
         wqSitHObs/1dOt6qLG9V7I0FbHL8txRNYmZzQbPbUaQ1JUanW5KYXftxiblcEn47H4MX
         BdMaMdCse367rIA+HvcLBIKJKNOWR3zPFjPkRhd2vJfpIQn+vfTyZxtLiYPwMXRXxtJS
         U4Kg==
X-Gm-Message-State: APjAAAVMX0WuPEMb3Hac8gPNgiezAM/v5eAzGpP5SxvoskJ7htVzVzmc
        toJ1ORFeELS5aVGLXJQgEXMC2twzD47m2A==
X-Google-Smtp-Source: APXvYqwzaeAmDJ6ZeY4ZytbOQRPd9n2CMz/lmkJQYSYZ+M7mxzHoTTnImApkzTKD2R8cGy7ePfHp4w==
X-Received: by 2002:adf:d851:: with SMTP id k17mr8280428wrl.114.1559398829906;
        Sat, 01 Jun 2019 07:20:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q20sm2668186wra.36.2019.06.01.07.20.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Jun 2019 07:20:29 -0700 (PDT)
Message-ID: <5cf289ad.1c69fb81.160f0.e287@mx.google.com>
Date:   Sat, 01 Jun 2019 07:20:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.0.20-33-g41133dadb524
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.0.y boot: 126 boots: 1 failed,
 125 passed (v5.0.20-33-g41133dadb524)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 126 boots: 1 failed, 125 passed (v5.0.20-33-g41=
133dadb524)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.20-33-g41133dadb524/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.20-33-g41133dadb524/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.20-33-g41133dadb524
Git Commit: 41133dadb5241f84655886618743c7e063585163
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 23 SoC families, 14 builds out of 208

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v5.0.20)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab

---
For more info write to <info@kernelci.org>
