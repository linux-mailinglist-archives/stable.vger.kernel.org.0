Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03CE625A61
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 00:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbfEUWkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 18:40:45 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:46430 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbfEUWkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 18:40:45 -0400
Received: by mail-wr1-f45.google.com with SMTP id r7so47704wrr.13
        for <stable@vger.kernel.org>; Tue, 21 May 2019 15:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A/NTM6JZzotXS9twj7xzWTbpTUvMjueY4e6uzN3h0o0=;
        b=ZMKQ3xGJU2AgAI5HZpuqQOxfCKmSn1gq+Mzh6DnQpjOJgbMObTm2F6iG4+MDp4zWLA
         bubUN2vzRktyBOfoKF9WJn9peMsKIK+KA3TYe37mC27/3xE3H9eFpKNNKP8slWOC1PXU
         FmXdryRmrcg0tIz859LHsEiKiI1+xRHVYJETzGsulrePNJ7oM6hQyj1kKoUOCPi6ibWq
         InfHGmJsvdwv+kWZzhSsD2PRGzst08tuNQDdWQmYMLaT23uu+s6Q8dlpCXuJTeRy8lUM
         ymfpnIyP6JP+bzpj2J/rIyZ2MwykNLnJTd4wVYKNHmI0AqDXv+Jn64W5eYAVdum1lBFP
         S4PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A/NTM6JZzotXS9twj7xzWTbpTUvMjueY4e6uzN3h0o0=;
        b=iopHVKZon9CPS0tOD0Hb4BZZLsMrk6Baa9lIHWAaQxP21ZXde1P19ToDhiPD45CG2Q
         WG7MbS23Qh/aleTUCVJhbGi+NKQFYgJ7h0I+HP84+rWvuKkLc1/iivXwjj9XwgSUi7Yy
         2Z6PChYgpIoelcA5aM+OYttZwDwHmXHw3U5UpodWSQYvDo+lXB0Q47lj90K+97l7VdVX
         B8bCP4NjsB7E4PpdP9K6Bbwd5mihiVtbmyDuBsykFek3c//AOme9SiIpPKl6Mi7ztvRh
         +yoFxv9y7v2TpXhfZ12W/hyeU4OxVZVv2w8gFXWCsqWRJ/Wec0sTKB1gm3cLxLOpjTkV
         d1wA==
X-Gm-Message-State: APjAAAWs5x+T4KsCUETtUKmaNhM0GioEeu73F+S/Pwv58vXIC3sVLGSQ
        H4mwtuz9bXuOr2nsRIkSaSxaCW18EwDL+A==
X-Google-Smtp-Source: APXvYqyJR2IH+Heg/ZZRz5y3OGosDM6ROUJBGB16dP8MRoeeI0MyLYsTlDUBffH8DYFHBpnKiAjaew==
X-Received: by 2002:adf:f74f:: with SMTP id z15mr25456190wrp.282.1558478443854;
        Tue, 21 May 2019 15:40:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h11sm29292022wrr.44.2019.05.21.15.40.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 15:40:43 -0700 (PDT)
Message-ID: <5ce47e6b.1c69fb81.f599.e8d4@mx.google.com>
Date:   Tue, 21 May 2019 15:40:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.121
Subject: stable/linux-4.14.y boot: 50 boots: 1 failed,
 48 passed with 1 untried/unknown (v4.14.121)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 50 boots: 1 failed, 48 passed with 1 untried/unkn=
own (v4.14.121)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.121/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.121/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.121
Git Commit: bbcb3c09eae4cc8d33415c29816debbec20a08df
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 26 unique boards, 16 SoC families, 11 builds out of 201

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 4 days (last pass: v4.14.119 - fi=
rst fail: v4.14.120)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
