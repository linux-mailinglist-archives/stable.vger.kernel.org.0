Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2624E210B3
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 00:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfEPWr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 18:47:28 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:51325 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfEPWr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 18:47:28 -0400
Received: by mail-wm1-f48.google.com with SMTP id c77so3649266wmd.1
        for <stable@vger.kernel.org>; Thu, 16 May 2019 15:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z4y+oBse4h2DIKq237jGw6N+8ppsiQQOm5pBTMGW5l0=;
        b=Bz85tydsM6Vh34iwO1Fb9c1EIpPJTtbYj7+qsU0QH1BBPw+hlvVYstKElYl50i3nI9
         FB9n62fr62VaL3gMQknmGBPi/m6qT5SG07wFj/ONHNJuP/H7aZoloV2OkAIAw8GpxYTZ
         wmypyJ2/glU3Gf0HdB7BcuDiEqZMi5mUwwW3dMj9okht8YvlP+s7oDWeWIXWz6rC0Kv4
         yyCaU26VQib6dvBx/O8a4sa5v7un24exQHiY1FzXj4bhJhboujKTAs8FM3OpcwSwACi9
         PGB9DOiS5EmUnou1p7aTareHvecfIsyy5SBi0bM82ChBbBcpLkV7NYEKC4BOdPhHh0mI
         2uyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z4y+oBse4h2DIKq237jGw6N+8ppsiQQOm5pBTMGW5l0=;
        b=ZmyEvzry13hUR10lLyROEQKtHXA68q8ct1XcETzaU5stA9z5ZL0NC7ye2VBCF2zsHB
         oRhKBaiUaV+mOcwuF/IrnpvZXNep2TPS3MTysN1E9Yq6zMQjzTRje/dZRZH5eCUqUjHK
         Och3dJODApK1BprrOjcb/5L8yM1HZYQGDSwI6YuIN1AB0YM660Yd0fpivXpzNhH7kkVQ
         V8mIyKw0u3paPBPLC5wyDTAJjIUpnktjx2ptvZEWmlxEPePLMoWzg4abf+YANZtv54Gf
         6Zk67nn1CJpwIT1cjv1URuy/K8bwugze1SPB4IvEu1D/XtUBdOoTVnAZBhViIZYuX9/q
         1o2w==
X-Gm-Message-State: APjAAAXPXS7dCFkm26AuvI0SnJLoewqKGxx7+V+zH8w7pMMALL2U26cS
        Yrw2JdjWZWJ+ETfJNFqOnctrt5BuDvajaQ==
X-Google-Smtp-Source: APXvYqxJlSFPqUmAv+bVnARvdCZJcQTS1KwyNYJXRbCS9XnhzJ/ciUzZn1z5FRGq+4ZxTJXLssa16Q==
X-Received: by 2002:a1c:40c6:: with SMTP id n189mr81963wma.65.1558046845712;
        Thu, 16 May 2019 15:47:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x22sm7250204wmi.4.2019.05.16.15.47.25
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 15:47:25 -0700 (PDT)
Message-ID: <5cdde87d.1c69fb81.64c1f.b378@mx.google.com>
Date:   Thu, 16 May 2019 15:47:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.16
Subject: stable-rc/linux-5.0.y boot: 133 boots: 1 failed,
 128 passed with 1 offline, 2 untried/unknown, 1 conflict (v5.0.16)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 133 boots: 1 failed, 128 passed with 1 offline,=
 2 untried/unknown, 1 conflict (v5.0.16)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.16/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.16/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.16
Git Commit: 89e11ec0280be9132b81e4cba5ea6c10a8012038
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 22 SoC families, 14 builds out of 208

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v5.0.16-138-g174f1e44d0=
16)

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v5.0.16-105-gce=
dd923508e9 - first fail: v5.0.16-138-g174f1e44d016)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
