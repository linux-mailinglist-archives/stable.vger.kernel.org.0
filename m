Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03785130573
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 02:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgAEBjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 20:39:37 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45052 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgAEBjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jan 2020 20:39:36 -0500
Received: by mail-wr1-f65.google.com with SMTP id q10so6981478wrm.11
        for <stable@vger.kernel.org>; Sat, 04 Jan 2020 17:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SYN6XEWWuZfA2mQZNtKCFMW5oW0g456+H1WTTvUimiE=;
        b=oBJ3oUMWJwdbx7OHAAXe7IHib3lH7pWywA6l7rT86USmxZnKu1PXrFw9uYOvxo0Qj1
         sh/T5Yui5OyYn8j6G9qAwS6h6nbnuW8XynjMLpdMPm1+pK+a0KaX+JZ7FZX/cNP1I3NH
         6C3MeuIDBoHq5AsO2LY5tGGi3KLrEaZ9qrIM4I7FWFLJMYiZgh5lA8rG9h1Mw/LXDzKt
         77hi8JRW9tk4lMAFZOg24G0bQRq4dSB0kX3PTT4t3cl35On6fcIgQTGO16CLFcFt+RQ1
         wvKURCoAXj5BFt7GBbhNdNFhwZZXoG1YFMN4PmhO69d12GcsGGbPSSt4sndUvEu5pglH
         BqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SYN6XEWWuZfA2mQZNtKCFMW5oW0g456+H1WTTvUimiE=;
        b=ntSo7RyqZLZmFTUTf5nTm2ohqStedbD8+m0b1bjK6C+o4/ef4Xu/QyRCDRby1KHWAl
         xNU68ujPO//ZbIhy+1lmHFKDStFc+3isyPW96lrLDJOZs0gFjXzXWo7i2nqo/XYMA/I0
         au55ewerYbC0xTwmcJV2RY5M1KOMQ8RyVuxvd/32AcZODQUmsayKFsAfT2lzrao420AV
         P9skqdtJoyMnqQtdyUHGBq9/1D+GHN1nwW0OMY3Y7Da71f1hh8hyK6Y2BX5DwbDouQiF
         r1CY1k8rvYtT83jMjUESpPgLasZyxS1R2xs8ddv17OyYHp/Jj1dMN3AqAGJm8ZKfzEM4
         6elg==
X-Gm-Message-State: APjAAAXPMqVHXyscC4HgclPreyt43w8B6oRwxGuHDeEs9+frsK249abJ
        QjUUKYqY7ys7ffl/AMUmxYWWbrr+mf8=
X-Google-Smtp-Source: APXvYqwDFZSLWh6YzAmj0b49mRS+mRW4P8DCaQNiOR0lnEESAHGPesNxq6p2j4j38CYMoqOUH1iPEQ==
X-Received: by 2002:adf:f78e:: with SMTP id q14mr94995190wrp.186.1578188373678;
        Sat, 04 Jan 2020 17:39:33 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k13sm66201832wrx.59.2020.01.04.17.39.32
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2020 17:39:33 -0800 (PST)
Message-ID: <5e113e55.1c69fb81.9d345.d665@mx.google.com>
Date:   Sat, 04 Jan 2020 17:39:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.93
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 78 boots: 0 failed,
 74 passed with 4 untried/unknown (v4.19.93)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 78 boots: 0 failed, 74 passed with 4 untried/unkn=
own (v4.19.93)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.93/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.93/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.93
Git Commit: 3d40d7117e353b84627c1e8c5ed9ae0b1237ef5c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 49 unique boards, 16 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.92)

---
For more info write to <info@kernelci.org>
