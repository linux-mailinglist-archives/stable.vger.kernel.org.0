Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19B2EE5B3
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 18:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfKDRUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 12:20:42 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45390 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbfKDRUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 12:20:41 -0500
Received: by mail-wr1-f67.google.com with SMTP id q13so18040889wrs.12
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 09:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1/arzv8mEaZvcM+k6J5ABrFdA7HPFcqvkghBWw+jOm8=;
        b=Gm+Zy3GkkaGu+A3bItxxBDwsSlwByLxo2WzyhsNJwu2i44UUUqtXZDDQRD91771A+9
         nEw/9dNrJF9E0q2BO0hF9bBg+T/iW8xOgaAADRTsn9sgQwonsabHjxPXhZFXyhaCnTkj
         2a+OMsZerFxKaPTFh3JmFEMzxGUV43PT1FLbUCtj4NVOEIPMTMKC1pytn4hNZfirrr+y
         T2iC1D2CqgNOlwfPcc8N7PTAXueJ+gjEyoQehrbE56aJxVrwtJkdZ6yio0f5ZtLANgnx
         /Eiqbi5evWL8WDsdKTsDXbILmADf1hiuhTU+nXIDB3raBIH8U/d8uIgd3wUbv0TiXUps
         QTwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1/arzv8mEaZvcM+k6J5ABrFdA7HPFcqvkghBWw+jOm8=;
        b=eVt4u3Cpc+WduOWwD8MfbDMhfcuJL3CcRSAwOKWH7hH43Fa+qEAMghbV+EM+V7neex
         hbE+pcNtu0gGDeezff310AvbPVfIPmipQ7T/rbDIEbwMBwr4IDzC1JzauB2iqkvC+NiQ
         Vb3BvHvY2NBtWjewH14JegmL8EkBQ5YSH41ZTi8kbXYYS6+i8fAHh0nIqgDR204IlvxF
         Ztw4qek349ZDPeTUeUu0aH1Vu3PCXNjmSyXnGgIS8yjSfsE7fNU+7/7U1nEoCQT/DQUk
         +wBQt9hxelSjc4+i7+iNvJIJXL4JztaMi1gqW+GpZ57zqqIOiOnGw0NFIDf+KP937hv6
         8K+A==
X-Gm-Message-State: APjAAAXR/ZAOiPRkZ2rcN0g82Sc8ywOiDNkkw1ysevQNYQPHBBE/uy+K
        LwXvaBw1nu1bKW+Tj/tQ1EZ7RrTIYs5QgQ==
X-Google-Smtp-Source: APXvYqw7q9xCxr68XVFY9OgzAXSsspMFFOtKMms+MOwMo89epaWdyAZmQzH3n8SPgNzmlFcfWbUoDw==
X-Received: by 2002:adf:ea07:: with SMTP id q7mr23520866wrm.102.1572888039755;
        Mon, 04 Nov 2019 09:20:39 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d202sm17095518wmd.47.2019.11.04.09.20.39
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 09:20:39 -0800 (PST)
Message-ID: <5dc05de7.1c69fb81.b8a04.0d45@mx.google.com>
Date:   Mon, 04 Nov 2019 09:20:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.81-145-g7d816e1d91b0
Subject: stable-rc/linux-4.19.y boot: 10 boots: 0 failed,
 6 passed with 3 offline, 1 untried/unknown (v4.19.81-145-g7d816e1d91b0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 10 boots: 0 failed, 6 passed with 3 offline, 1=
 untried/unknown (v4.19.81-145-g7d816e1d91b0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.81-145-g7d816e1d91b0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.81-145-g7d816e1d91b0/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.81-145-g7d816e1d91b0
Git Commit: 7d816e1d91b01911392b7f8f93a4a153b9af60d3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 10 unique boards, 2 SoC families, 2 builds out of 206

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.81-114-g7db85d223=
311)

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
