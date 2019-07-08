Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85DD062A52
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 22:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfGHUWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 16:22:39 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:55069 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfGHUWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 16:22:39 -0400
Received: by mail-wm1-f49.google.com with SMTP id p74so776892wme.4
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 13:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wzmEXzH9T74IGWMz4zjRsApDPzrU2oRrd662F5Kck/I=;
        b=JGxkZXCgXDH0FegiFwDrU1lgfGFkuTRT9lUXf0zNLz5E+Kbp0gv5f4QgrwGyHIVyA/
         NdD0fMGK9Z8q/rOF/WbFPpndJxnu4dqioEAaD0JRms7aD6sc1/dAPqknxn3sFofeAIom
         3T0u9prkVT/d260ixyl16qS/BPlMWT7Y8hGQQvQD7WSQ9u/yFu/mTFrbmJxW1dg3Pzfc
         TzcpvspzhbSyheH8Ih9axaL5Fx3hclXBiiZUapwGxuipf2urg0ykS/rAnj6RQO5Mt700
         x4+mmMSBxkjDrfV/ZdFZ1/owzpASDSrpGzQI7rAfL3Xi2Qe9MLrIicNBGUoDExi7AtAy
         OcuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wzmEXzH9T74IGWMz4zjRsApDPzrU2oRrd662F5Kck/I=;
        b=AtXHyTuKEM6KIMeV7hD27gH+ypMYoE+HK67btt0I8dZtji4JDH2OSDXwiL42ttvoTg
         oV0nRZqs8TlT5Jw1i/9nJSTuIuOlDccr4h6s2Um82POyxTUmqnO+7ehTjuwom879szj0
         U0oeaxZgU+eKdu75/UtKteZd3bRahDI9jQ1UNMlX/g4WMmpv1u/BZ3w5qI7WQssT/3qm
         cuA/lK7LrGzO8vRKymgVXF09jLafOoBJReiOZDlpM26f8VWNp/AXpW6NUa6X5NDvkMmR
         c6azclpD2r1dkXcbNYgDl/FE1t9N/HJdr5juGbBN+GEJf9CUHhPETnYuB8OUZLcaqzYq
         HG0w==
X-Gm-Message-State: APjAAAWrH5S9VjTlqmP/Zl5/3S2J1/ftuM/htJPa+SyvDoDsHPM5/74w
        QH+lcG1GafkSgi4QDb2u0Qj8SyPNqa81EQ==
X-Google-Smtp-Source: APXvYqx50dlch15CuPm0RIqT2SnzaVwKpQaK5KZAL4eWoo67EjoE4yq/D0ezyXGrz6d8n1M+l9y9EQ==
X-Received: by 2002:a05:600c:2199:: with SMTP id e25mr17439149wme.72.1562617357201;
        Mon, 08 Jul 2019 13:22:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k124sm825877wmk.47.2019.07.08.13.22.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 13:22:36 -0700 (PDT)
Message-ID: <5d23a60c.1c69fb81.dd6bf.4ed8@mx.google.com>
Date:   Mon, 08 Jul 2019 13:22:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.57-91-gc4064b656955
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 100 boots: 2 failed,
 98 passed (v4.19.57-91-gc4064b656955)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 100 boots: 2 failed, 98 passed (v4.19.57-91-gc=
4064b656955)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.57-91-gc4064b656955/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.57-91-gc4064b656955/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.57-91-gc4064b656955
Git Commit: c4064b6569551279bd81da840126527a77b0ad20
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 24 SoC families, 15 builds out of 206

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
