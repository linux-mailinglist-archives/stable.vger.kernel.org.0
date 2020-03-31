Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96057199951
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 17:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgCaPNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 11:13:06 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35379 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgCaPNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 11:13:06 -0400
Received: by mail-pf1-f195.google.com with SMTP id a13so425870pfa.2
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 08:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=B5K8t6oLSXlJIYpU3juBloo0EifArRvuE3xhNtL82uY=;
        b=ebWL/jLZ3qyP1TkTMmDa+SzMVrglaEEic6dHlDaw+KeJAzDa44rEVXEbOTUFcmKoRb
         nMqEmUgZZlH50YTGZzv8ETEMS9mJCGO2JNwmGqoePEhQ8QMfnSopEmL6ywjH3lXyauN7
         G7R+GAgF1Nikpqa/bVHLU+x5jtxLlGMUyRSJiO+YCoOxoxNKGLXC5H9rIup5Em8G/qUn
         EcH9y3skWPRWkbUuteSkP1D/lPfMNJbYuHUzhiINqNGVNpFogVorw4ro6yRVgO+0/NWF
         JY+qyZU6iLQ7i9WKrqdWhTj4Swi9FvVzOeY6/gGzwyJQzNvldWkqA8KXLiGnf9ccy0nA
         0d8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=B5K8t6oLSXlJIYpU3juBloo0EifArRvuE3xhNtL82uY=;
        b=bGZFnyXYD+XQ9KOoAWlkZ2r7ckZOOCOAWtvrkmLuINKzb7Rz/NFN/AQWzJZSNw2rxj
         1ONXPdsZKKwg8i5baSU185IodTUu0XMrH5Jjjd0Uev1F/FHPj0aQVlo1iNCTf1F6fAJH
         vQBYg4nelbaX0oBaeX5MAU8n3r8zlrVUbU0mncJfY8xfNlFQATMVJFGaAMdMw9xkG6vN
         Y/fLM4S+SfO442aeIhP2CA+874HAQB/VIvcXttyjvJjUEnbF4ORv1d98xbu4czjcH8KN
         Am8ubP924FoOooVez8QQ+MIhK/oa5QjqY71gHdukAMXtl9AZYngC6Lj/HW7MHUEq9P/K
         /0KQ==
X-Gm-Message-State: ANhLgQ1SqlR4B2cGMSYpQczkI6FM57yP79+gt/OChae6OuYPz45ghC7i
        EfpvV117tdhea2OWcmX3x9YCiu9P/6g=
X-Google-Smtp-Source: ADFU+vs67YPRoaOhKPfOAictwj/NKblehV0Ngp3E+x9l+MxmZMu67s5dTm6KOGZpdz7GqWqNjQVRaQ==
X-Received: by 2002:a63:7d53:: with SMTP id m19mr19188752pgn.274.1585667584415;
        Tue, 31 Mar 2020 08:13:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m68sm2282968pjb.0.2020.03.31.08.13.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 08:13:03 -0700 (PDT)
Message-ID: <5e835dff.1c69fb81.86291.8c17@mx.google.com>
Date:   Tue, 31 Mar 2020 08:13:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.28-156-gad8c851af8dd
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 158 boots: 1 failed,
 153 passed with 2 offline, 2 untried/unknown (v5.4.28-156-gad8c851af8dd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 158 boots: 1 failed, 153 passed with 2 offline,=
 2 untried/unknown (v5.4.28-156-gad8c851af8dd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.28-156-gad8c851af8dd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.28-156-gad8c851af8dd/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.28-156-gad8c851af8dd
Git Commit: ad8c851af8dd71602e714ada9fd2bb8526ef36b1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 101 unique boards, 25 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 51 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 15 days (last pass: v5.4.25 - fir=
st fail: v5.4.25-58-gc72f49ecd87b)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
