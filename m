Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4694259FE
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 23:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfEUVdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 17:33:03 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:37853 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727526AbfEUVdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 17:33:02 -0400
Received: by mail-wr1-f52.google.com with SMTP id e15so20248936wrs.4
        for <stable@vger.kernel.org>; Tue, 21 May 2019 14:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BimdsSwEwXLaOOl2zgkgackprveprJ/BTlp7cMJ1RfQ=;
        b=ZCV0l50l2QZ7fbnBB4nDF9qlC8fn1TQVIN1+svegu/KXC14T/EGi0fzTKXK3t04iG0
         hd2GwmwDd1fFBBR4jXSZx0YpJTeopicWT916YOb8JaFzhHUTsBJuLi1KY+TxSVZeWamG
         alQ6Rlbw8UGTx1RMDJ0F+DymzS3niy/JvLrCvjlBsOHcrawnQIoCh+T/7eWbwG82EgIo
         7dgNQ4ZVMGaGOF67osexsnnGnsKbJtpBIicAaiCDkvk3U7tMRu+T7g1aIUwGUo7ckofl
         eCcpBNXudmgjVR5sc67IP+FZnGPPqbJaeZJN6nu2C5kk27chWn5DBUnkQ/JdPlu7EqCU
         73dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BimdsSwEwXLaOOl2zgkgackprveprJ/BTlp7cMJ1RfQ=;
        b=VkJ391hn0y2RwNnEQ9413AOl9ppyDc+zBRgeFhNdJMctU4A2wrbIJ6oIlDBK0nooGk
         BEsPv6D2BFqP/MpYLqp6wLQq53HDebfH7cFWIZP50JIcU1/qfq4qwH6COG0WnLW94BCz
         mZtP5WXxRu4yyzj2WuHdj4omNmVYq3Zfx0qdovC5Bu7W+gXIz+dhe1WVhpL9y21CB5Et
         OOib5jBtH0JDHAvWp3Zp10WyIgNPkxepJGiD+4gaR/NG3qgOZDhkNbXGxyE1gZZe00Qv
         KomtQX+stw37ulur9xesrXHaO2tcgqz4MR8KBv/PRrv1QIwCXbDjsmCH8tZQBgBQCgI1
         irWQ==
X-Gm-Message-State: APjAAAV10E4s2tcsrwRn5fvcffjJYt3VnjmrAGJTLw6zCK2hsmDoTfPL
        Ie5qhKPqllI9SloLzcm4rUAQM/drDn+1cg==
X-Google-Smtp-Source: APXvYqyjq1onS6VffLUyatuf+LlpwHHzznuWRCBp/flKHPJAnheMMXR4b0dSyVu0LfVn28XcZqd+3Q==
X-Received: by 2002:a5d:6143:: with SMTP id y3mr50380185wrt.148.1558474380690;
        Tue, 21 May 2019 14:33:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x64sm8227450wmg.17.2019.05.21.14.32.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 14:32:59 -0700 (PDT)
Message-ID: <5ce46e8b.1c69fb81.913fe.81e8@mx.google.com>
Date:   Tue, 21 May 2019 14:32:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.17-121-g5eaa7ad66ec7
Subject: stable-rc/linux-5.0.y boot: 126 boots: 0 failed,
 122 passed with 1 offline, 1 untried/unknown,
 2 conflicts (v5.0.17-121-g5eaa7ad66ec7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 126 boots: 0 failed, 122 passed with 1 offline,=
 1 untried/unknown, 2 conflicts (v5.0.17-121-g5eaa7ad66ec7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.17-121-g5eaa7ad66ec7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.17-121-g5eaa7ad66ec7/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.17-121-g5eaa7ad66ec7
Git Commit: 5eaa7ad66ec7e9d1c3e1ef871ec29a5427d05ca7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 24 SoC families, 14 builds out of 208

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.0.17-124-gbb2772791a=
81)

arm64:

    defconfig:
        gcc-8:
          qemu:
              lab-mhart: new failure (last pass: v5.0.17-124-gbb2772791a81)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

arm64:
    defconfig:
        qemu:
            lab-baylibre: PASS (gcc-8)
            lab-mhart: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
