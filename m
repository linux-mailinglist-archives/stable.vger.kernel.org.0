Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A879BFA80
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 22:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbfIZUPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 16:15:20 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:54246 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbfIZUPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Sep 2019 16:15:20 -0400
Received: by mail-wm1-f42.google.com with SMTP id i16so4171097wmd.3
        for <stable@vger.kernel.org>; Thu, 26 Sep 2019 13:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iwcCndOlkgtb7wkHIrKtFcwWN6TEJ/x9N1qUec2UDms=;
        b=Pa0o7Up6/Pa0F44UYQh4PKqF+Ry2Ddp8sFU/OYmFqCBb4oWHixZng45thWZ/hfdvC4
         GBOkQwnZ9ytNQAVmCoAjm/+A3hpiX4OcQvJyQfa4qpjX9QDm0NvcfIH3JZ32tM794/bj
         9ZMrWJbv7oBeXSJyuUXliFAdlIuXZh2wxVhVvKwKSkC9Agr6P5Ht7nNx4t22NTYP0wxa
         gavVk6ANLhDdLx5liTBhL4JlSy4s0sOqEljC23o+QUJuKVtn+31OJwGbAVRd64qUaatJ
         vmwK6rpYVP5S7fEfbb96iHfQfxO4KdwUfNl6QpI2b/2ukivvkM4MGmxErpzVyX4k6+qS
         81IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iwcCndOlkgtb7wkHIrKtFcwWN6TEJ/x9N1qUec2UDms=;
        b=NqHo1sCyV//F7uEFl+tjDY+5ABppkaImF1IdJUig7/QUKSV4ye7XU6df0AZAPete2F
         qbjuXSQxY/u96ZnKKMsAe4S5NLxrOYDIy8wfSFLcPOUcc3VuHk9xz0i8gkBSJ/zFlr5T
         18vj9DmKKMdMILrXDq0TGpdtce4zzkc/W+MNkXfrtdksxyFqVjFvUfNGyaK9r86UJEBJ
         7R7zZl9xLTKDkYfhbpbL/Fs54jcwhLIG68sCCKKg6rncXp/TVX/L/rvk90PKYq8HIKnB
         Mc6YDFsL8NBZhD7wTlQfztvzR7KZUWSdmJ24GXiOhEcX/L2uOHfhcIbQmeZFXp55smT/
         GRWQ==
X-Gm-Message-State: APjAAAWLagDI/AQyC3KaB6I626Gw5yWNPdVBnV8ed537IGhMB645sTHZ
        HY0SPwjCu3kdv4ueuI+PJAvfEEWh7d8OEQ==
X-Google-Smtp-Source: APXvYqwLNi+cW6TKj5vgH69HIbHBaAAIfeJwThLkUxEdA7QpzagCkrgjQHYVR9oVFSBl4hJEUUYB3g==
X-Received: by 2002:a1c:7519:: with SMTP id o25mr2009041wmc.16.1569528917918;
        Thu, 26 Sep 2019 13:15:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i8sm548566wrw.36.2019.09.26.13.15.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 13:15:17 -0700 (PDT)
Message-ID: <5d8d1c55.1c69fb81.74bf4.2ccf@mx.google.com>
Date:   Thu, 26 Sep 2019 13:15:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.194-12-g9938ff6c3206
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 114 boots: 0 failed,
 105 passed with 9 offline (v4.9.194-12-g9938ff6c3206)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 114 boots: 0 failed, 105 passed with 9 offline =
(v4.9.194-12-g9938ff6c3206)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.194-12-g9938ff6c3206/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.194-12-g9938ff6c3206/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.194-12-g9938ff6c3206
Git Commit: 9938ff6c320601144c9eefdbe87b9bf7a2afc74a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 21 SoC families, 15 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
