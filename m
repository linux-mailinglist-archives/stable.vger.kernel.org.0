Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A10336CCEE
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 12:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfGRKoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 06:44:30 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:44304 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfGRKoa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 06:44:30 -0400
Received: by mail-wr1-f53.google.com with SMTP id p17so28102355wrf.11
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 03:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BZhk3I9YopZBEm/G2sJlkBFEM7T3QsUlbWV+Bwbj0NA=;
        b=mVehOzrQoYzivp+ylxCpKdKdTI1yFhIjMn8h71uzM93cWfMDMrdJa8avJnE4nWttZA
         KylkkhMSIjBWedF3zKU+uAo5y2sOw5RMT19/gJLAI57KbvHWbUfOShFAtWrKZF45FpsW
         UqQ/S+GaJdHQM1BNO79ITJEhlCaZfLwgTH8+tEaCEyJK+9aHWOeQirkg+PFsWcirThM8
         TgLFOaOj5oAPRWmY1U/ftT7d0GLGScmxiE2n6VM2REu+xwuaPRiEJvrhz0aYuANpiTDh
         7xSTcjgJQHllQIh0sk8eC1zH+vY9ThPYPCPy97yM4FzBtPGCqMTcEKQ7rSwWpn10M043
         rlwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BZhk3I9YopZBEm/G2sJlkBFEM7T3QsUlbWV+Bwbj0NA=;
        b=GAGEJ24UadXYM3b7ikcwaPDEgWZi3rRBiPqUpKwhum5xyFbiOlGS/EGu2t3b775JlX
         ojkyZ9PMkY1w4XWMH+Py27fjl7OwIPzYqG2y1CVHv4lP2EANRotbMf9+IVOy+9koQgFr
         OaRV5OTkNtCx8j96LdC32Sq8Rb65TD+Olbo9fhC9taIvpTVOA+6dvy/RkdJVbWZcwqrq
         wOGlmpHI9VXAsgK8Qb/sGJQRSHHA2P92cFO+/E+lEK/fbuH+jin/jVF1YtBVUmXL1uzX
         9QqsQOlGWgmkMqH8l9ejf4r2GCu8ag9Y+vzZiZ4Sd3wB1EAMWo+fmb6Gg+WNHxzg/YQd
         c/ww==
X-Gm-Message-State: APjAAAXN9eW+Q6XpQJix7pRUX7a7lCkK3/1W9dnNZIQBL4NKZzyTSAzT
        1Z7NpDmxo/7qMznvcckN/3Ftw/IPd2g=
X-Google-Smtp-Source: APXvYqyjlRqFQ8oHnbqtUni+ZiVukcEYTt3AxD0l+4pB+zYYkddj3AkpKDpQPQR/nqpUfEbpiWmNwQ==
X-Received: by 2002:adf:fb52:: with SMTP id c18mr48969156wrs.216.1563446668225;
        Thu, 18 Jul 2019 03:44:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v204sm24669482wma.20.2019.07.18.03.44.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 03:44:27 -0700 (PDT)
Message-ID: <5d304d8b.1c69fb81.d637e.ad60@mx.google.com>
Date:   Thu, 18 Jul 2019 03:44:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.133-81-g2c7e97d1f95d
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 123 boots: 2 failed,
 120 passed with 1 offline (v4.14.133-81-g2c7e97d1f95d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 123 boots: 2 failed, 120 passed with 1 offline=
 (v4.14.133-81-g2c7e97d1f95d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.133-81-g2c7e97d1f95d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.133-81-g2c7e97d1f95d/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.133-81-g2c7e97d1f95d
Git Commit: 2c7e97d1f95df23feb292eb770c22e0b1472edd6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 26 SoC families, 16 builds out of 201

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
