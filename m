Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 454DA15A4B6
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 10:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgBLJ1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 04:27:41 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37702 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbgBLJ1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 04:27:40 -0500
Received: by mail-wm1-f65.google.com with SMTP id a6so1347680wme.2
        for <stable@vger.kernel.org>; Wed, 12 Feb 2020 01:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FWRy4myWPBFfpd0NoDlinDcd3Qum2BtfPIkPgaWLyyg=;
        b=TAcV2ZlVEXsNBKkq4iRTzzTZEEJEfKubY9oTAs/9CDOUUdS/9bidFEu5baGNXH8+4Y
         v/M4TtwtfPyfwY5gUZZJCK5jLRcUjV+aoetW49SP9Yj/XJDJS4pN2zGkzjTKZftslvQM
         NFp/hbZfUi7wZrMalyyL/ip0QI8+nDwA5v+1MHQ9/INNxH4f/gydpDL2utYgj94Km9xg
         kjUZezgNysBlDEJw2uoroXYL5SIrrj/BjFIEMKx1ev092s5YjoRpfeYiwpemmrbWd95d
         3feDxtUT8UVEyhmk9CNxsFykESBpruQQtm9Y+yoqzq5GYX+MO2Rxyl7qeGPT74X0Jpq0
         BoJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FWRy4myWPBFfpd0NoDlinDcd3Qum2BtfPIkPgaWLyyg=;
        b=Fy639aQRsWxYmY3Ve8mqXen+a09KQ/rnu2yuoQ9sqx3+HVyTmqYhy/wkoBKioTtnAO
         44h2OKk7eqfgVH6k5c/jmQld/DNHXiA034fIoOxqYYwdsmVFlNGVLVS0WbcXbVf34ZD6
         Py2AtIGtaFF0CHgO07/LdSqhdjFBxsmwQ8oIyPx6mYV7/tTmYgn4C9eeIp2TRnuYyXVk
         WicwzM1ft4xcZhrxW4a/Ahkbkpo+wO1//u2R53tTRJDCSqwz/P9dXpRDYSms3pHD3EdI
         ateJle7eaG7llKjNyBkHjqlekYuiJExSJIVTpvNt1TbF+kCsrFLdMdUr93ygmkxOsnsH
         7tVA==
X-Gm-Message-State: APjAAAXeulcoHV/KuXVScDW9ymoYnOYlCPKGMEaSsk1t4I3bAe7mNU7M
        g1+aTTmudYB3AWoDdROW8H7GZB8kmcnAFw==
X-Google-Smtp-Source: APXvYqx4uwcxnWojLZuz3PSXW+ErfWV8sUn4HJvowkJMGqBdG5EndNC1TWnYpkCFTHuxkpoO1pZ+rg==
X-Received: by 2002:a1c:dcd5:: with SMTP id t204mr11651394wmg.34.1581499658694;
        Wed, 12 Feb 2020 01:27:38 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r6sm8999914wrq.92.2020.02.12.01.27.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 01:27:38 -0800 (PST)
Message-ID: <5e43c50a.1c69fb81.2afbb.9ba2@mx.google.com>
Date:   Wed, 12 Feb 2020 01:27:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.103
Subject: stable/linux-4.19.y boot: 71 boots: 2 failed,
 68 passed with 1 untried/unknown (v4.19.103)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 71 boots: 2 failed, 68 passed with 1 untried/unkn=
own (v4.19.103)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.103/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.103/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.103
Git Commit: 357668399cf70ccdc0ee8967bff3448d0f4f9ae1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 45 unique boards, 16 SoC families, 10 builds out of 168

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre: new failure (last pass: v4.19.101)

arm64:

    defconfig:
        gcc-8:
          hip07-d05:
              lab-collabora: new failure (last pass: v4.19.102)
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.19.102)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            alpine-db: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

---
For more info write to <info@kernelci.org>
