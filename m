Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 206D21A15AB
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 21:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgDGTR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 15:17:57 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45238 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgDGTR5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 15:17:57 -0400
Received: by mail-pl1-f194.google.com with SMTP id t4so1583944plq.12
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 12:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZXjifujj63i2RG2QYTbc/w5z4N95UgDvQHyIKa2d6Vo=;
        b=lGV7VyeE85VyEuvNN8+shQJDDkAEr6OKTE22nRJp0f3cN+fnYYKdhY4N7B/dMMTnT9
         VfsZUGnPcxe3gZiqv3Tyzx6B/cpF0pgvZLiWOOsI7iyDam0OXd8GU8iGCKzWLuW68RCe
         Py9joKD56IC9NNVNgA7B44kw62d8HE7pLjD1XWK9NwtCyl3mh4qEZEHLcqx2nb1f4zW8
         jxgQKGduaK2sbNXv5lGvB0BIyOS5l7TJ7uhKEVeArtgS4DpW5hhm3065DRPCOveoulOE
         sU45dXDV8ARy8JBRzmD5Lx0zF2N1PbLcXrAQTIndTlPyp4QYaOQoTK/WroF7IO0MDy4z
         Qg1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZXjifujj63i2RG2QYTbc/w5z4N95UgDvQHyIKa2d6Vo=;
        b=BhTUFBQUb/IrC6IiBUE+sKfM3FvPIiuf7mx+kbKQ/kj7xoeyyyuJ7K6F7JEgE81nwh
         yO0w46PwGSXrxhQAib3fVbJ6B5DL37F842nALY2cgbT3qIJ4MKH8egrgEO3io5ZOjRLK
         FGu6m6NtsrGtKMwzdTpB08Pt5jCQwrJ2/MkbQMGW2V76rH+pCPCTbBKacbLSJtwXhRGi
         DkWOpRYpiDxCEabLS4DeqauaYqxIoRJW4ikx2q4TkglSYIcS+1OyIA1gwfRom9Mf9cOt
         fGIlhnYM6jrgX36SUD6yps6eCgmtBw72Yjg6KacMbmh9o9j2KnYA1yhnVRzFQEGlDLNC
         angg==
X-Gm-Message-State: AGi0PubggvxFY56he4ZeJGqF0oycdjq68BgZu4edZEgHlLq9KjBsqAjC
        lCKBPqD4qhmvpkToeD/2ng9zAqXBAV0=
X-Google-Smtp-Source: APiQypJCJPfXNinRpL3SIWBVoGkzbELQUQlBgHNqxBNOWLbiTkkHAZx/Rlav3jahGfRwCPePuHXjrA==
X-Received: by 2002:a17:90a:757:: with SMTP id s23mr918087pje.166.1586287074359;
        Tue, 07 Apr 2020 12:17:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mq6sm2400506pjb.38.2020.04.07.12.17.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 12:17:53 -0700 (PDT)
Message-ID: <5e8cd1e1.1c69fb81.728eb.8873@mx.google.com>
Date:   Tue, 07 Apr 2020 12:17:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.114-25-g1afec3f9643a
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 145 boots: 1 failed,
 137 passed with 2 offline, 5 untried/unknown (v4.19.114-25-g1afec3f9643a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 145 boots: 1 failed, 137 passed with 2 offline=
, 5 untried/unknown (v4.19.114-25-g1afec3f9643a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.114-25-g1afec3f9643a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.114-25-g1afec3f9643a/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.114-25-g1afec3f9643a
Git Commit: 1afec3f9643acc147d62dd896399f7c77fd13808
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 22 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 59 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 25 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.114-22-g6e19c6f2=
d265)

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
