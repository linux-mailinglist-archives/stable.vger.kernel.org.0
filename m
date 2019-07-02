Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 126645CF14
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 14:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfGBMF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 08:05:29 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53125 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbfGBMF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 08:05:29 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so597572wms.2
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 05:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CDsS5u+KDTbhhEMFxmDgcX1QIIeBg3cSM1Nwi7INntc=;
        b=g84+4V7DIq2b0AEnSDmaBIOqD8YM4FRN7Gi1J5RST87pUY/a+CjMEwfkt/RJWAG1rC
         VKBnsMpOE4HddaZfSx9XRisrYUedR0dvCPoDJDk/811ibTf0GBzYWCD//UMmC4GxJU1B
         dD4osgyZhmyOY73RHFwL0mfSFb5gIxkL79v5Xy9ULX0HniZkKPGl1oIFowkuZv6qutKK
         cRVYo9gfpmg8Win7zD6rPa067RbiFZ7xLZtvlRPXIFniJJ/nz/N+pCRELy67X6wsUPl4
         3IVnEvxSM7yUInygupbiXmhaTLrQZhuQVzWmVojP9/tzAJRfOpXuvioCCAp849u6a+9i
         I2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CDsS5u+KDTbhhEMFxmDgcX1QIIeBg3cSM1Nwi7INntc=;
        b=Viqb0oJXgazzbGv3Sq1D0GROxJewu0mueUnvXGgTj738zMsYpXOzuuNHu27nmyeM62
         hLp1ctdvKsc4UOoiL1W2Tm84gAq9l/iqCPbiqdJOnslvlprowKkqGmlqPhqBjNs/930h
         kctq8TO/JpR9ud8wx8EY7i8CgN6UbulcLxeEE67JxKpeBOHL2hL+/wTIs8+0ChgfY88x
         LMQPD/qziFkXmi7iGMalSrEqoT5dven0andKFMbx3SAP7dQ7qs2sMqCEGcyYk+9vwqK4
         WoIz2B3w8TtkQ4lcCkoyY0qi6euMLqaqD0I9GiydUCsssc4ZXKLfQGdxfLEMaUC59xrC
         QHOg==
X-Gm-Message-State: APjAAAUk87vltS1PemJrDE5oyjayk+qb+qrOnGZGgbx1wVCImekQWADf
        bAt4XP20xG9hXXHvrqtZfzEm7eV0qWw=
X-Google-Smtp-Source: APXvYqydtO9rGqjQSXImP6BdS341bBWQxfjonKaQN2xLPU8XuQqv9OrV7dGqJAiW+MbRk773qS6LDQ==
X-Received: by 2002:a1c:7304:: with SMTP id d4mr3253148wmb.39.1562069127537;
        Tue, 02 Jul 2019 05:05:27 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s10sm3231889wmf.8.2019.07.02.05.05.26
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 05:05:27 -0700 (PDT)
Message-ID: <5d1b4887.1c69fb81.ceec.3c79@mx.google.com>
Date:   Tue, 02 Jul 2019 05:05:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.131-43-g6fa18665b865
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 128 boots: 3 failed,
 124 passed with 1 offline (v4.14.131-43-g6fa18665b865)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 128 boots: 3 failed, 124 passed with 1 offline=
 (v4.14.131-43-g6fa18665b865)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.131-43-g6fa18665b865/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.131-43-g6fa18665b865/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.131-43-g6fa18665b865
Git Commit: 6fa18665b865d4e0d0bbf1a0269e79a5f0bdc2c2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 25 SoC families, 15 builds out of 201

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
