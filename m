Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2361335A3
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 23:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgAGWYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 17:24:00 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51859 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgAGWYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 17:24:00 -0500
Received: by mail-wm1-f66.google.com with SMTP id d73so499510wmd.1
        for <stable@vger.kernel.org>; Tue, 07 Jan 2020 14:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jUf7kZo8IMxwpyLev2Zv/J7+nVXux28o672EY4oPy90=;
        b=xaMNq0QeSV7Gdg8iWFkePMxdmhTleRizcbvLRSJ9VSaJpXnvDmVLsGfIeDit2Z+w3F
         3McZkXa2BS6El8PyYXIk7dJeMDfIrL3i5st3nRy6MESlS/Yr+/JWOhIUJ5c3GUCG47PC
         mPKypfzyBb/k6mz8R3bv1rN3HwdORYRZ1Lb3mvWtOgbhEKS6Msznb4kbviRXR+MNMdA4
         MfRRum/Tc9J8rBW3m5juUMebMAnEJ79YN9zhxosu9YayQcxvXF1bMbALT/9qNWoRWt6E
         wBj3X+VVQOwyYGaGmT/SOBxLoCJko8Nm/r1bTDHG7dag63c4IGl/E0BU3rgIrzL3m2Mz
         VfpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jUf7kZo8IMxwpyLev2Zv/J7+nVXux28o672EY4oPy90=;
        b=B+imAAzkjLgTEvvsEkAIwRYsXfFsMSovU+n4t7W2kowGvpMQs8fri0ILfjbPKtotCW
         MTjiNnjuFkPVfrpDJdt+x5ZxDyzy1ngUcOEhZFetANrFlcSxkComDwYPgkTHgUmDK9RM
         WnENOdZafwYN5LCBMLrHfdzL1zcbaKj2P146Y6kMHhan40Gn+uwQX8NtVboTqTvGRhwR
         0zYhGe2bx3Iu+apLhvV5xxUJngZ4wfgu6eGilmFUY6OngXywEnat8Tk7gHfK3Z1J7Vqe
         s9X5Eupr0Mw3PIS9dfyq/900TxXSblT6JXYzp9xYd1+7R1grVEBo0aGxgBPsYU7mUQId
         WbKw==
X-Gm-Message-State: APjAAAVO99Is4FrRt7Ta9GW/7fcAC1yr8TISYZAy4eCF0lzaRZ1OQXxE
        jyfLB9mA7rly9pEdvmbF18ItFpsovjNlvw==
X-Google-Smtp-Source: APXvYqzUMJ+HqOQ/8MGX6yW1areemc8i6jDl9HFPrVv1IWEJfzgdAIYtOe1sWOjfFiPy7dgnbXwQnw==
X-Received: by 2002:a05:600c:22d3:: with SMTP id 19mr491489wmg.92.1578435838076;
        Tue, 07 Jan 2020 14:23:58 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u16sm1209520wmj.41.2020.01.07.14.23.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 14:23:57 -0800 (PST)
Message-ID: <5e1504fd.1c69fb81.84682.6630@mx.google.com>
Date:   Tue, 07 Jan 2020 14:23:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.92-198-gec409c0577a7
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 54 boots: 2 failed,
 50 passed with 2 untried/unknown (v4.19.92-198-gec409c0577a7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 54 boots: 2 failed, 50 passed with 2 untried/u=
nknown (v4.19.92-198-gec409c0577a7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.92-198-gec409c0577a7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.92-198-gec409c0577a7/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.92-198-gec409c0577a7
Git Commit: ec409c0577a786efac650be33aeb59fea89cb950
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 13 SoC families, 12 builds out of 202

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: new failure (last pass: v4.19.92-113-g2686842f2=
160)
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.19.92-113-g2686842f2=
160)
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.19.92-113-g2686842f2=
160)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            bcm2837-rpi-3-b: 1 failed lab
            meson-gxl-s905x-khadas-vim: 1 failed lab

---
For more info write to <info@kernelci.org>
