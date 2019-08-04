Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339CB80AFE
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 14:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfHDMkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 08:40:45 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55047 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfHDMkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Aug 2019 08:40:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so72245792wme.4
        for <stable@vger.kernel.org>; Sun, 04 Aug 2019 05:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tlDFNSQqg2iQG3SQ013mxDdpOTbjHu6dxMCjZe+hh6s=;
        b=qn2xTyLqoK8pqL10qKBmZtgoLlGqKSSTz3H20vVcxWtfw8xQO4FtQsah98xO8dKwLW
         Yui8K8l3k3hk4V9yiiCyFfIQ+n4iLYHygNcBdbJ7MiAqh0zkJt7meI183bZMu55Xug7l
         LhsnTuYhU2V3FKb3A12nOHRG2tMjIbY793dxGGrrerwLbW5xiLjG0GDVV0LBc7vJl3i/
         a5z52wGOXObZxZIJ6/g/nOr89nNQWi7XVuP2vbEoLrzORnt6T20lnjFdRhJI2QG4YFSS
         Kzv69OU/KtCx9qmy4oHfFZcju0a+uE09IyRMNXawxYMrTidLdU1KAtYQj/N5vjhKISmY
         SGRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tlDFNSQqg2iQG3SQ013mxDdpOTbjHu6dxMCjZe+hh6s=;
        b=tMi5X2FIxH3IiTUzT2VfxwEmr5OcelNLJHhNTNXZ9kqVMUm+l10k2yCZZeNd0+kEcT
         9QoJ5d+flzaFCSZt/ARQvWr7H8/ci2EziKlmROT1yqaleOUVlC0CwQT1rhC3Qwc9cJm4
         zp3ultsgADCGd6OfcEjFaa/UIHYz0nFBAvV9UgCigjUILgWGq0tsFGlJNQpjkP3Gp7ug
         sPCj2rWB08X/6t6jP0vkJ2PivNCx/c1e7VU/uq/OMIO/NzbQDoEyDwHuFeZK832Ss+VO
         8rPnDnKhEVFXuAKlisR39QJqUUdG/53HJvOF7E7lDkxYiJRv2/gCqiIFjpQw5W1b1+sM
         Lktg==
X-Gm-Message-State: APjAAAXiveKWxbmd2q/33pJt3bDo8Wcoi1c/zVC9J5jSpQPb4jBgKwVL
        BXW3/2UFUqqOD2U/xpfKCsD4/cOuLXw=
X-Google-Smtp-Source: APXvYqygxxFNhYQPrWBcpGvTnD3wv4F8hJR/lQY2wzynBDYF3PXVKhS8YeWtrhhhgo2KB5tuYYsmOQ==
X-Received: by 2002:a1c:6504:: with SMTP id z4mr13549564wmb.172.1564922443012;
        Sun, 04 Aug 2019 05:40:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b203sm115448792wmd.41.2019.08.04.05.40.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 05:40:42 -0700 (PDT)
Message-ID: <5d46d24a.1c69fb81.6ccb2.6743@mx.google.com>
Date:   Sun, 04 Aug 2019 05:40:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.136
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.14.y boot: 58 boots: 1 failed,
 56 passed with 1 conflict (v4.14.136)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 58 boots: 1 failed, 56 passed with 1 conflict (v4=
.14.136)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.136/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.136/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.136
Git Commit: 7d80e1218adf6d1aa5270587192789e218fef706
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 28 unique boards, 15 SoC families, 11 builds out of 201

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm64:
    defconfig:
        qemu:
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
