Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC06DF6A9B
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 18:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfKJRpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 12:45:03 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:40362 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfKJRpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 12:45:03 -0500
Received: by mail-wr1-f43.google.com with SMTP id i10so12175508wrs.7
        for <stable@vger.kernel.org>; Sun, 10 Nov 2019 09:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AaehLr+UzkqB1pqp3mWDuXpsMjSh3Af6z1+brppatXM=;
        b=d3L6q82ec2dBkPyql9Ns1dhFa2hTS7voLoTfnzgYCrk6xnXZy1RQ9IuA7GvBuh8mUu
         d+dEXwNlmm+0VrKV/Igatnj7YycruFhnWZB0TAf3xjGrhx0m2LczuyWsa2gUEbEly/Am
         u5R/L5gxknpOFEfR84MYXTlkqYibKzMvmi6lOBmNX00Tc69ELsgU4zhJVHpy1QY7UOTk
         qpWsrPkUFK0Ft01qcD/swbrMCNOK5O6FuS6b+jhTaEH5ZBLnINgC66Vg0CeAbfeL3F29
         RORt1V88EKZRXI2xLPOkHe0itaNkJuP1CuBWDJW5srejpVdBl4PU4Hu1CCOvAkboRIXl
         e4xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AaehLr+UzkqB1pqp3mWDuXpsMjSh3Af6z1+brppatXM=;
        b=hMEgwqQ3R31T5UAhPAeflFWk0298A4x7FY6AU8JUgZfSB8xDpkSNTKvdBsJB62aeb5
         /rEuiWfxzJdt0S7cXP3rN60rYvBXc7sS2q7v1JNpy5xJdd3G8K5ozRKBmviKRUuoRQpm
         xTRFdubsi6gD0x8at8wXd8Jz9zvCUo91xn0f0syMPHNeu0KbaZTxuS4zpCAvmN5USJZd
         N9y2z9uBP3QDVnjfJx4xDIHWJYdu0GRAXDlE3lm0c0v2s0gKgugrrGjvWy0ITcLnUVR3
         d89caZOdC9ZCxAaPXR5gDN9tsb0dkt5p4trzx6b/MrcDRaKmYoOf47H91oabAi+FGOWe
         AaAw==
X-Gm-Message-State: APjAAAW/xZo47wZ/j6N91j5NXETSuLmxWALwJlPln+YgoDOawoOt+vX5
        JJ6jWjnHUsr2BCOCcTtF12Z0YrrbnJI=
X-Google-Smtp-Source: APXvYqyk6ojbRaiwHwp6S/57mlzSLSL5czEkrPE0OuWepuElr4K++QAvMPQgRvgCzOP5heJMYDIMeg==
X-Received: by 2002:adf:ab41:: with SMTP id r1mr18616965wrc.281.1573407901041;
        Sun, 10 Nov 2019 09:45:01 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s9sm10964520wmj.22.2019.11.10.09.45.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 09:45:00 -0800 (PST)
Message-ID: <5dc84c9c.1c69fb81.b057d.49d8@mx.google.com>
Date:   Sun, 10 Nov 2019 09:45:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.10
Subject: stable/linux-5.3.y boot: 70 boots: 1 failed, 69 passed (v5.3.10)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 70 boots: 1 failed, 69 passed (v5.3.10)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.10/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.10/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.10
Git Commit: b260a0862e3a9fccdac23ec3b783911b098c1c74
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 48 unique boards, 16 SoC families, 11 builds out of 208

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: new failure (last pass: v5.3.9)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab

---
For more info write to <info@kernelci.org>
