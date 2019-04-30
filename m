Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C25EEDEA
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 02:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbfD3AfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 20:35:17 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:39731 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbfD3AfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 20:35:17 -0400
Received: by mail-wm1-f54.google.com with SMTP id n25so1624216wmk.4
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 17:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bT6T0/zLt20nzMKvc+Ukf9PCBgL5+D4ub6UJOGtjJMg=;
        b=X1KcFMdS7uv5x8MUNw2N8Fvp3Rvey15o8q8YsAGY9h2nnbQSBL1Z9+q4MDBrFAU4+l
         a2YbTZODTyOU8/V3VW3PltClZiLZgvBOeurtWbZCWD52waGHhsSifeqUkDf/wvNGtJM5
         JJJ6QTyoNYRH3ZXjevdsXr0zOi41AdcYUL6i4tTP/uGpq7Wg3+wE21QxsdGVknFNpiZs
         fcDwqJCDiQOTfAvEeOrLHqMQ84trMFCRlhQJi5J8AyaK/I66hJ5YsXg9hhr+XE6TjELb
         v2N0dcmtEkCCvk8sBr53KcPPa4FrjI8E1IURcqY3YVQIUPbMFuHLwbNfC1m9ekvz0T22
         ioeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bT6T0/zLt20nzMKvc+Ukf9PCBgL5+D4ub6UJOGtjJMg=;
        b=lqfRIHjbaYAmhHGYFWdNrfrfuCsGXmU5NBDrrEdr2hmYTltWX0OxfiXRSe1+V+OB4g
         8Qptjn+oIlUp7NsLZdX5N6CFSpcN1URAwt8DNwLrubL4oZ5CTMt4bkSb+hU4tDny5IVc
         06fPUOSfk2nD1StOek7HYILW7nNMju4hDNhL5kPztgpxgsYI0B1Bnz8qxctgpyREo6gN
         8ytyJR8h4xekAPbFTjAKwoNUERNxrG7zfywrd5g8UbxWYI6VtjF9r4dOlBaEs1DSY8i7
         778YqfJmDRriYySKy4EB7D2fegrDF33hlTz2F8YWDxFLriQ4gjGK59iITDB2TuHv00VF
         t2yA==
X-Gm-Message-State: APjAAAX6nKgQhIMaiS+kUTLraR2JaWe0/G7BEmEISzt1lOuanCNYywEM
        t7EOL+m7oC1Zo58pcdZnXxFo6LYFLMrJyw==
X-Google-Smtp-Source: APXvYqxPIpr5RmRTdM8DLrLheEGe1FJB8HlohRs4mhi/du1b8Am46oxM4nGa348QPOnRa0/od8IpxQ==
X-Received: by 2002:a05:600c:204d:: with SMTP id p13mr1136548wmg.53.1556584515027;
        Mon, 29 Apr 2019 17:35:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o16sm23452906wro.63.2019.04.29.17.35.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 17:35:14 -0700 (PDT)
Message-ID: <5cc79842.1c69fb81.ddfa2.336b@mx.google.com>
Date:   Mon, 29 Apr 2019 17:35:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.179-75-g060381518058
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 86 boots: 1 failed,
 82 passed with 3 offline (v4.4.179-75-g060381518058)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 86 boots: 1 failed, 82 passed with 3 offline (v=
4.4.179-75-g060381518058)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.179-75-g060381518058/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.179-75-g060381518058/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.179-75-g060381518058
Git Commit: 0603815180589aded1969666555f8de0b0c8a204
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 21 SoC families, 14 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-7:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-7
            tegra20-iris-512: 1 offline lab

---
For more info write to <info@kernelci.org>
