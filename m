Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1665F180835
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 20:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgCJTgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 15:36:47 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35667 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgCJTgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 15:36:47 -0400
Received: by mail-pj1-f67.google.com with SMTP id mq3so877707pjb.0
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 12:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oQ+WZAqmrr2ZTToD6iS7C4mcuaiRDRAqxVOyt2Q8zX8=;
        b=vNsLnu8PtLwWVHCx6HNMu8HEpmy/rGfJYA/f0WY3YUUjghuZ07NNlasL5pJuOv/cvF
         5VIafzgrFnrn/ftpC3zqqW0VGrTChHxAPPseKXYSyvZrwONcCPyKbfq+sfTnwlVNLufQ
         m+aLr2DBUfYsEgY8wQUNb0H+yPc32YuPK/ILsRh7WFEDLWqTRlQkw3Szrb6SSLvsiniT
         oQ9ShQ7etHvMAWhL7ads+lGJ6P937wEpKorXSMLtn7NcQPCu6BCZbkZLTiwBcQNaZl9D
         hRJpCazSg6tM3ivBDefAVzZcXNyDMu3qM3H5iGNS5DA7k0cHPT7G4b8XPhc3yIb1fEN8
         nrNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oQ+WZAqmrr2ZTToD6iS7C4mcuaiRDRAqxVOyt2Q8zX8=;
        b=WhDBphjqYKr/9apgsjrwOq/d5cHFLWTtIgKRuUWrbr3txPSCdZdw3hvZ6GYrnnXlaM
         iU6yBlHXYs4o5SBum74Fv4CslGs9/VuAc9sE1QirPmNWWHYzrxVDjMpxZtGVesRPEfa0
         dS0FQDaAbr9uJXi67j0XTkuEiiHsRd2Kn7nozYeuKYIi4zJqHBTQVU+bm+kcsCGz5l6F
         uJTq0+Acj66CGwieFqeMbG/hHrigAjE1oyNgK3YLMlyP0zO9qB0uZ4OP6rgr0GtpAPg1
         o/eLndas0BfVYbca2WDABA4I/b0y1ITDlaC6Xnp5B/vbCv6JppxVe+gx1XEg6PJsSdyc
         nWEQ==
X-Gm-Message-State: ANhLgQ1oHvJ2lTY6e1MOsD2HXj3mycGgTOduTH/1JDH2eE1mE7mzA5Sh
        CRFIWOzQDnfDGUW8ZsHwjUG7ZTZRnIU=
X-Google-Smtp-Source: ADFU+vtzqgKV1In0j//fK4FKnEi22XWl5Shx5jV/tLJwhYFcvAWxqW5/Py04poeFUMtF9yXSXuYGMA==
X-Received: by 2002:a17:90a:c396:: with SMTP id h22mr3361333pjt.128.1583869005319;
        Tue, 10 Mar 2020 12:36:45 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d3sm2134065pfq.126.2020.03.10.12.36.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 12:36:44 -0700 (PDT)
Message-ID: <5e67ec4c.1c69fb81.5fb48.5fdf@mx.google.com>
Date:   Tue, 10 Mar 2020 12:36:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.172-127-gd5b7f770c4ed
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 94 boots: 2 failed,
 89 passed with 2 offline, 1 untried/unknown (v4.14.172-127-gd5b7f770c4ed)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 94 boots: 2 failed, 89 passed with 2 offline, =
1 untried/unknown (v4.14.172-127-gd5b7f770c4ed)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.172-127-gd5b7f770c4ed/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.172-127-gd5b7f770c4ed/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.172-127-gd5b7f770c4ed
Git Commit: d5b7f770c4ed8ec0f3efb2a110406d2199fab05e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 21 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 31 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 19 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
