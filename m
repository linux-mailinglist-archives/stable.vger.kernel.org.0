Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 789AB108F4B
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 14:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfKYNyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 08:54:07 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:40676 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727609AbfKYNyH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 08:54:07 -0500
Received: by mail-wm1-f50.google.com with SMTP id y5so16039774wmi.5
        for <stable@vger.kernel.org>; Mon, 25 Nov 2019 05:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=evptul7kVBn5fFlescDSwpCxkVdHMtmZwublR8Xe3ts=;
        b=nQxteiW3er8bUdN63ekaQJXS/AuLeu7u4SmJZ78cvX8DSpXU4NtMTJrRApT6sgoI4i
         5aZxeu5NG7O/HpR7iXZbNYpMAygbeTBR4FUuyZcEGHbA2AuSMKJeweszP2fjVEC7Ci/N
         KkOfWjvXwCNYyEpZjTRm5/F79B8PgcuIh0Prdud57wmz11yYevSAsajnJkPTrjmvfMJU
         Wf1/+XVDUsviY/xnuIOXXp//w3OdXbzsO6mZQoLk9JIpJhc25Ya1WSdEVgel4GJXFx1S
         osb5j84cE33d796sWnYAolacSrsq4xwAevnvIPUFrwx1UNJXbsfIyCLaAoFsbWZvLRAJ
         IPyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=evptul7kVBn5fFlescDSwpCxkVdHMtmZwublR8Xe3ts=;
        b=YPkBJsuemPOPHl3jsZiDWlHPqIIRVel+sQV9ff8eZ0RJfYJglU1C2ZfGA2k7+maXFK
         vtuTcyjRgn6MZqVzREpcxGJGKuxjLOc0e7eNjyDzCg38En9geqm2rQwk0mRqpULyuv0I
         He2YRA0eoLRjiswNxdtVqs+wajKW+g/EFDcm9DgaT/S32FLSVq00podkR+tkPOEm+t2j
         /EyIeNplEJUWj+pzcTKTooOpwB5tQ3c0rhjfb3BQv9I3Q2B1ZFgtFp8eftxyrD7ve+Ao
         Gngw1UE53srjc/SCsdjlkpX2bdAGBmp8w0odCKVe5lc/J1mc0HF0gsphVKLbhr4Z8uGC
         njvQ==
X-Gm-Message-State: APjAAAWIUmLuIKHxDvQmUej67ADSv5Gr9Zf4xa0iw0pVZ5q81a2xNfCK
        qtPe7F74Ts8kxd8poYOghrh+G2inItIONQ==
X-Google-Smtp-Source: APXvYqy2QPN7y2tJpCa/I2xqrSG4lMoDtXMTUfMg/O5HKXXio2JEuntylFh17Dclx49UevuUWJdFjA==
X-Received: by 2002:a05:600c:2911:: with SMTP id i17mr28307111wmd.83.1574690045169;
        Mon, 25 Nov 2019 05:54:05 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a26sm8118125wmm.14.2019.11.25.05.54.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 05:54:04 -0800 (PST)
Message-ID: <5ddbdcfc.1c69fb81.58851.8ef6@mx.google.com>
Date:   Mon, 25 Nov 2019 05:54:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.203
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.9.y boot: 51 boots: 2 failed, 49 passed (v4.9.203)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 51 boots: 2 failed, 49 passed (v4.9.203)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.203/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.203/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.203
Git Commit: a777e9dd40fe85dfd0cc5cb2b6c22a9cd1d08c0d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 28 unique boards, 14 SoC families, 10 builds out of 197

Boot Regressions Detected:

arm:

    tegra_defconfig:
        gcc-8:
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v4.9.202)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

---
For more info write to <info@kernelci.org>
