Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0686DA446
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 05:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbfJQDQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 23:16:53 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36912 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728081AbfJQDQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 23:16:53 -0400
Received: by mail-wm1-f67.google.com with SMTP id f22so846135wmc.2
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 20:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wue4+1WiL65LOnNwAOb33+eynN6JaUZJIoye/Z9DXXE=;
        b=kmnb2IPZ+h4gvyUNDwaVEIPrTU92Zc4+2UlcHQ0NRXJToL8ctKN37A3w3k1idwFopi
         fWnjcnr98HjHKfqHxCtVEb3siwnUM7LWO6m4CAIi98r5REphvPyRSRrPBoK4DKaHa+xN
         pbv8/AR39X3HPuR6k99WChZBp1IOqvnm5QHeGMsy3EmGQSer3c6cCy6RAka9sUQH90h+
         dGUK21EfI1YJpbIxKx3vMoPZNyM8PfMA14BrKo5NrXejoDhB8w6FWQbfA2xRiImAoj9F
         h6OH3M9Dfx3ihPJ19IhuVt21Ymt9lLTeydRhWnsimtm2Sa02E7sDCRjB6DM6bHZK+1lJ
         80yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wue4+1WiL65LOnNwAOb33+eynN6JaUZJIoye/Z9DXXE=;
        b=IZ+8m3WFnYuLKVL3EFfXZ81UdBTbAy0G7Kk96BlLfQwKw662y76sHbZcA3vlfuDEl0
         u5wT5/l9kN+YccqOnEJfkeDMtVusl0II3lFcQfTXwi5eIkfCiX5GpYdicsL7UENLwyhn
         3SvtEt1O70UJuj6yuXExa11vU/JbseyGfpQVMDboVrGjRpQo6sAZC5iMpRQrQXtAPIrj
         WCmpYKswoK2yFh7yqihhJ1QW2QT4JmAQfgvIqIBajSYwbDMzDJJefj7kdidenkwS06gr
         Pd0OlgcJKbUg1ebRiYElRc2BW1Dl+di4/glurwRo4d5O4tXDTAqtUtKanKAc6fI5Joni
         JZWQ==
X-Gm-Message-State: APjAAAXrKr3SRFwIu+MZkYCPi+XJV9O6/UFWMqexRM4zGnFay2UY6Glq
        lvF+Aol9Sg6m0CJc2Pdy2TR2JPrBKnk=
X-Google-Smtp-Source: APXvYqwY/X2Czmyl/NUhrZyLapPyNYVZe0yd/7kj6wsFTpdw4b5c4fPJv4x8jYBkH9TYEQxwS+9lKQ==
X-Received: by 2002:a05:600c:2:: with SMTP id g2mr684503wmc.163.1571282210155;
        Wed, 16 Oct 2019 20:16:50 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n8sm957638wma.7.2019.10.16.20.16.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 20:16:49 -0700 (PDT)
Message-ID: <5da7dd21.1c69fb81.860b0.421e@mx.google.com>
Date:   Wed, 16 Oct 2019 20:16:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.149-66-g66f69184d722
Subject: stable-rc/linux-4.14.y boot: 76 boots: 0 failed,
 70 passed with 6 offline (v4.14.149-66-g66f69184d722)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 76 boots: 0 failed, 70 passed with 6 offline (=
v4.14.149-66-g66f69184d722)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.149-66-g66f69184d722/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.149-66-g66f69184d722/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.149-66-g66f69184d722
Git Commit: 66f69184d7229bdf1ac19b8928747553ca3e5914
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 20 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.149-65-g6=
42c3804ba9a)

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
