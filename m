Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990782CFC8
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 21:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfE1Tuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 15:50:55 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:46378 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfE1Tuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 15:50:55 -0400
Received: by mail-wr1-f48.google.com with SMTP id r7so21533861wrr.13
        for <stable@vger.kernel.org>; Tue, 28 May 2019 12:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8FTwV548BNk6bA9N3TtjpwgLQsbugeuf52lxFH/qWO0=;
        b=ddixuIk22TG8GjVqHWq8nHlicgV3VeihEL/dnoPIIgM60a1u64RnA7g3mW4/UzEEww
         PD4khOCxQgVzsQp2LlJGuzxnwumeJ2zlsBJ+CKhug73CotXQo0bkNrUzqTfsI/KN0xuK
         c6dzw9Ok66uH9FykGPCIMm+kOfZKssZM/oqZQtTI9sGGq910IjvRtp4g4S7sDfl+/+GP
         eb4AtJEvR/blbjH54GORC+a7g//PffnhoqljQbVXzB8Lflipy2c6KVVxmDgeS8ULDjeo
         4NP7+O31ZYbSIZRFNvE3RH5w83oXUP6s8iFt5MQr8Dbha91vd/WzIwgf+gnUYiwpT2q2
         fLcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8FTwV548BNk6bA9N3TtjpwgLQsbugeuf52lxFH/qWO0=;
        b=DOjUHQNDP9Sr5Tm8C50OquK0/h3V5JVwx42vlE6CQ0quW/Vhu80d7CSQnbDjJ/0/DJ
         /0luR+8flWeTtpdKahWOV/90Cfjb6Ec/RGWzMpHSVxmbZE/g0dwPywlVdaf900tblvYM
         b6OWoHjJo6xjnmIB2nxq9K7lqtCd9TG8YBVj2ZDcjaS1zmweLrG7b2zddDXTmQ5Gb9Aj
         eCtYjBetI4goLfxkRIT5FEKkqebmRSJK6cRaSrPk4xNNVuNOt4PG0cwtXn3gTYzOf1Ml
         429bLdu+S5SYJMJ6TTrezF6YjY6L571HFMmN308mS7VTtzbV1BP7Rs6ZOKn+nFvJx6fQ
         K9tA==
X-Gm-Message-State: APjAAAXWYua+mi8j6F0PFSlcdRRmkzgBIfv9+ej2TVd7BTAZHNJBd6mV
        T9pWloW3PbmfDojXLx+rO+0MwkgohAbv1A==
X-Google-Smtp-Source: APXvYqy4rv4yciO79Be50E9bhYqb8NABFH1eZ1U+gJxqgno1x072DRzEPSrpRNUGtDhdlUzpfPZRTQ==
X-Received: by 2002:a5d:4a92:: with SMTP id o18mr23261862wrq.80.1559073053974;
        Tue, 28 May 2019 12:50:53 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n1sm5224499wrx.39.2019.05.28.12.50.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 12:50:52 -0700 (PDT)
Message-ID: <5ced911c.1c69fb81.f77bf.ccfb@mx.google.com>
Date:   Tue, 28 May 2019 12:50:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.179-15-gedcc526ce9c8
Subject: stable-rc/linux-4.9.y boot: 106 boots: 0 failed,
 101 passed with 5 offline (v4.9.179-15-gedcc526ce9c8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 106 boots: 0 failed, 101 passed with 5 offline =
(v4.9.179-15-gedcc526ce9c8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.179-15-gedcc526ce9c8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.179-15-gedcc526ce9c8/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.179-15-gedcc526ce9c8
Git Commit: edcc526ce9c80ecf207e2feaf4a6203a1e0f8a1c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 22 SoC families, 15 builds out of 197

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

---
For more info write to <info@kernelci.org>
