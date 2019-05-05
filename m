Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47669141CD
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 20:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfEESQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 14:16:09 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:45620 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfEESQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 14:16:09 -0400
Received: by mail-wr1-f53.google.com with SMTP id s15so14320287wra.12
        for <stable@vger.kernel.org>; Sun, 05 May 2019 11:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5xj24/JXSPYnBP7aH3Vg7WmSe+AqryNuPlJ/kyvGqec=;
        b=KDN0QN2SKrz1chKDLXxKl6Nn7gyRuM/rGZAP3pE5UbQyx8HLoPv2Hes2h8L87pXln3
         nPPGPfcgiLZQRP2R5tARNWTGwsxOLG8ZSrQ8sgL4Xm+PoEprSoa226zbpPMaDRFihSeV
         +FHnHOgOV1cNOXpiROQ8cJCnj+ZeE5R4V0a/Ze6s7hJcnHin1ikAckrWJr1DLKiiTM0Z
         ibVhd64Sv7e5cu0RvzzSAMI0qXhbRkcFTRpfYVlKJbFdCvHL+Ui1enkXq7kM5C7Do4Ed
         aqxlJsurQ6SZIleKNdFFS0aFV4LVSzCkx3cH67JcRaKjWAy0ToPVYO3AjrnEy5Ma9xVE
         ddfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5xj24/JXSPYnBP7aH3Vg7WmSe+AqryNuPlJ/kyvGqec=;
        b=rzE3G3usHSzVJWwPcxr61mElrDQHWVBDe6Y5lPYf6mWngC/k5ARh3oq89cMqJKXSIX
         3RbX9IYss6FldNrjYdI44p2N+Trj0MWwb2YUJf53ypjiTmYynzjP6KsfpKl6t8317ugu
         gYznp0PdjHc7AIa2difMFVwsEhmbma0TFkEl6gHPZGdy9bQefAVQtTHeAiXSsF+ys/N5
         MXsnHVJvQUxQVQRGeMeJDIj/BkOhOS/KEVjLJ0SS3uoi4tViAQxrmwe26laTPffvMtNw
         Eul3ukJ2x3AhfzPbfHb/kSzVyfygon0MmdamU5rzsAnzuR9crlOyhgIrE+axr31uYHdn
         sjIw==
X-Gm-Message-State: APjAAAXuKuavNdDbsXiAEOHoUg1F988ISeCc/xmjSVpbP81GqloWJoQj
        hJ7blAzCyoe9KtUkZDG0IoO+C+19nMU=
X-Google-Smtp-Source: APXvYqxjkLZ9jlaI/JEgy6PbTF4EMspBUqhvbJvQH9rxB5xw5eoU0jqb3ByVqZwGha2HwZGFC/KJwg==
X-Received: by 2002:adf:dd12:: with SMTP id a18mr15772535wrm.188.1557080167607;
        Sun, 05 May 2019 11:16:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w7sm10048561wmm.16.2019.05.05.11.16.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 11:16:06 -0700 (PDT)
Message-ID: <5ccf2866.1c69fb81.2f1ec.57b7@mx.google.com>
Date:   Sun, 05 May 2019 11:16:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.116
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 122 boots: 1 failed,
 118 passed with 1 offline, 1 untried/unknown, 1 conflict (v4.14.116)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 122 boots: 1 failed, 118 passed with 1 offline=
, 1 untried/unknown, 1 conflict (v4.14.116)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.116/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.116/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.116
Git Commit: 6d1510d86ef67e5fadb8038671e2ec43416daf7f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 24 SoC families, 14 builds out of 201

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-7:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.14.116-2-g6a60e13ec3=
d7)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-7:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm64:
    defconfig:
        meson-gxbb-p200:
            lab-baylibre-seattle: PASS (gcc-7)
            lab-baylibre: FAIL (gcc-7)

---
For more info write to <info@kernelci.org>
