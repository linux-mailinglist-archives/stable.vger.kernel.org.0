Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 811B921183
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 03:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbfEQBAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 21:00:31 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:46973 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbfEQBAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 21:00:30 -0400
Received: by mail-wr1-f53.google.com with SMTP id r7so5210070wrr.13
        for <stable@vger.kernel.org>; Thu, 16 May 2019 18:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w3Z7PmHa29xhrJVUi/VyH0iprxtJVk6BLzcvQcsIlS4=;
        b=EA9+kAXC6f4mrqaSondQK0sRRM6VkkTuFHukQ7hZkdGMKi4WUaddrqlkwir263dXq0
         jLmZh+kefNlm8zq6ox3QWgJYOpo+tpA1cT2kNdjV/HnbpodGc+N3drz1x0m/2ddXMiux
         n+SJzhlVu5P92V17xnDllMfXQ3V4d1e0nHiWjqChPHlYUODFwIk/L0toFD9GlMWFIyt6
         6qABuUGaX0nCtczKRf+c/BETjx5pJq7LfsJ1mSU9nrq6SQI51qKvq0HptG6laPNQYxD9
         +bNzp0nq/EH4Nso0QX3ejE+Gg6sOIgISxVhfn+Fc5xNhzg8ap4IvSE2EufjoasgVbsdc
         3QKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w3Z7PmHa29xhrJVUi/VyH0iprxtJVk6BLzcvQcsIlS4=;
        b=eGnA54FussW2/ftzUkSA83JGbWWAK+x6dQr52hhyRjfHe3W5KNJg8wafK4jM04gwW6
         cuhiIeqy61kzpHOx61Le5ahyqqIoT3Pe7J8VOilp8POZN80nMNuwkyij96Jmm7T7NebF
         Ppzam4QERRJF0soKg6woPI5tXicU1Pr0kOVxi+PuJT31jQUI+fhl37Sq8n3WLzEkml81
         9lcUAbxLjgWPWojFhacsqcP/dvr1kpG7e+m3i5BDrvhigAve7Ct56PCToGRcC8mpQU73
         sQSmcFnt5CblRwSrUNgjRvSxTAkYsU8HJsIY3ZvhqoWpYoqtLDDgKwdo2o1GKBQM7QXI
         4+Uw==
X-Gm-Message-State: APjAAAV5KefHV7yWkOBScXPU9gxv2vfyDAKkDOuoi0IVN4RQ5Yg0OZzW
        vjXnsAWQ/PL8dvOWdB35/H2QNtaWmq1p8g==
X-Google-Smtp-Source: APXvYqzUCXyrAivsQdWUGiJdTjXHcrnyI+j3fDm5zx6E90RFrr8foTa/i/w+rIfwP8ix4MTKck9+cQ==
X-Received: by 2002:adf:e584:: with SMTP id l4mr10652828wrm.54.1558054828637;
        Thu, 16 May 2019 18:00:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u129sm636857wmb.22.2019.05.16.18.00.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 18:00:28 -0700 (PDT)
Message-ID: <5cde07ac.1c69fb81.d1d5e.39c8@mx.google.com>
Date:   Thu, 16 May 2019 18:00:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.177
Subject: stable-rc/linux-4.9.y boot: 109 boots: 0 failed,
 104 passed with 3 offline, 1 untried/unknown, 1 conflict (v4.9.177)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 109 boots: 0 failed, 104 passed with 3 offline,=
 1 untried/unknown, 1 conflict (v4.9.177)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.177/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.177/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.177
Git Commit: 8baec4ebdf084961516f17cadbad14cac082ee4e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.9.176-52-g2647f24152=
a7)

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
