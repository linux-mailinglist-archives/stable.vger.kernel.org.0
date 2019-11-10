Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7DCF6AA9
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 19:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfKJSCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 13:02:51 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35449 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfKJSCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 13:02:51 -0500
Received: by mail-wr1-f68.google.com with SMTP id s5so1117320wrw.2
        for <stable@vger.kernel.org>; Sun, 10 Nov 2019 10:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Elw0Mth/pLBkxyQ3SQrHPrjcEBpO2r+E6o3wZXrGcVw=;
        b=BCrA3mQQ9VhCiR0IwOv9Ju2U18SPKyUXNcoENmvLWaSecm6wMGv2zj0jLk7+cGZjaL
         EJO4ROZ9+zCjEUDrTEqVQD+BZ1PnQKE9zBwUdRzEdP9VwhiYZwVRq107VrH1hoHi1r1Z
         0cMNUdmGFVYuHaApFyZrHe7r+jq3nUL8xI+E+FJEfBBwbqB+08aiKhrpYYDZSyVZ3gAD
         DcwH0Y6goBlr1fvNWRRhtQc+TF2ch41Q/ity0VJgqUaIRnepjeKsyesPMZv4aLQC+Qqk
         OJC7bC071hytGjMTo9f3w02q0UxlwK4/Oz/j9yAWVYpwC+7FVS6HVr0bbBtA5d4yOPVh
         i1JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Elw0Mth/pLBkxyQ3SQrHPrjcEBpO2r+E6o3wZXrGcVw=;
        b=IYWPFsn445vMqxGCJ3spN95FDUXA9c5EMz4WWn4LuQBnBKMm7t8JuXVDnk8BwD7UTb
         SxpE86VECU9/ZJZIbxZIZ2YPGHbXPbdbn748D3ugZ4WFxUlalCSyxbR3A/6YQflq+J6T
         6ex2GxQvUbuiYht9ic0PRkGBalhqIMnxZl0Zv2E/PnhdzGle1dVVmzDOR2xDx2Ww3Y3b
         maLpCXslRyJfYSo7fmwh/ZogpOWVhwLoIQK7pPz0B2WIoBhQ/CURRBLoku8GnjTYlRlj
         kDfKSDcqq6VkmsUYHJGZ7JCdGUYXlc0AYvVLtEcrwTy370v6k8m4hliRpTc9FbSm903H
         v74g==
X-Gm-Message-State: APjAAAUEh7SAjOz2xM+2z+4GNFKXoEZ4bjUZuWfRosbgkCmW1z3u+cMl
        8NTs+tYhRVnVFYTjcH4AZnnX8RafwSw=
X-Google-Smtp-Source: APXvYqxBMec7FldT7H1XOyc2Oizg2YpSfE83P8THPpAfZ4SBrEGTmSlxhUQEdhQbgOVI6FVMwBW1yA==
X-Received: by 2002:adf:f651:: with SMTP id x17mr18515180wrp.114.1573408969748;
        Sun, 10 Nov 2019 10:02:49 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b3sm14908156wmh.17.2019.11.10.10.02.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 10:02:49 -0800 (PST)
Message-ID: <5dc850c9.1c69fb81.29693.6df3@mx.google.com>
Date:   Sun, 10 Nov 2019 10:02:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.153
Subject: stable-rc/linux-4.14.y boot: 59 boots: 1 failed,
 57 passed with 1 untried/unknown (v4.14.153)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 59 boots: 1 failed, 57 passed with 1 untried/u=
nknown (v4.14.153)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.153/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.153/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.153
Git Commit: 4762bcd451a9e92e79d5146d3d4a5ffe2b4e0ec5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 32 unique boards, 12 SoC families, 9 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-a33-olinuxino:
              lab-clabbe: new failure (last pass: v4.14.152-63-g2cfe0b7bdee=
f)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun8i-a33-olinuxino: 1 failed lab

---
For more info write to <info@kernelci.org>
