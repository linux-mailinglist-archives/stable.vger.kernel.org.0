Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F5DE6B80
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 04:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbfJ1DqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 23:46:21 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38536 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbfJ1DqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 23:46:21 -0400
Received: by mail-wr1-f66.google.com with SMTP id v9so8305995wrq.5
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 20:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0vLsyW8NZdsJrokYW5bbOufgyVkfiUX005e5X8CUSXI=;
        b=B9OwIGuu+lk1h5zWIlRN/LS1UqtJhyOAfa8XToCU7hNvcMg/5UVoppZjAkIdXYe6c8
         +ne9L2+/GWxBCD8GXs+eXM/0iPYoPzP+cSym1pvy5VQ8P8oWqJeSCVcId22IuDEE9GHi
         8UcZSkal2k0eG8/u2LNPnxgFDrYTyZfihxbNEo9XxhWNEGvhfVVt0jgIB5cSeVhcV71I
         noEN9ul/ysk3K64GYvhe+dyJhfCoP03NkDXey8ILq5FEpYr3IVOooaYDvIE3zo5KF0bO
         rinICZ4TKlPfAHDx43NgwWjQCsjOh5pgtDGCzOKin/xYnlQmy26MqtgMRkTowDG9D8j5
         aXqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0vLsyW8NZdsJrokYW5bbOufgyVkfiUX005e5X8CUSXI=;
        b=DcUZO9Tv2AavtT3x5GjTYXFxNlRXZYanabTHipdwMkL00+lEC2SE/qV/ZhYWr11f3F
         +/42cOAVnDC/AQ4HO4kA8wGz9FyVIXDMZse5khelaZAhcAZQtDPO9hQ8SkTAE7xqinJl
         vYRmyLU8OvQNJVJcT7ASJGEEuoASGOVsufFGFO+a/ZMT2xwZzubLRavAkwUmesFMiOOf
         m3rIxlZQ12GZ5H872pQbdDk1n5bNO6qL2Jigc6bq13GcKAFepKj5QRZIlvVnwqGs5ThM
         DzpbRYmI4ZO6P4INFrCfea04jqIkc7Et/KsQ+c/ChMAD/BZr/B5O08K0b0YludMp0NUX
         Z5ig==
X-Gm-Message-State: APjAAAUuwmaz/1ekfqvZGdZ2BUHdWQ73XmMEfkshj/qPDok4Al+PHOmC
        8PXbXXYsj2IzUvtFhYJ8Wb7S4EmCfRk=
X-Google-Smtp-Source: APXvYqyl0mVOVJRvC3gl0p/MeL3YiHNxW4K5IWLkd37xObqo2NQM9zjJo8e3lP7dOKlWrZcraugYYw==
X-Received: by 2002:a5d:51c3:: with SMTP id n3mr13082207wrv.5.1572234379437;
        Sun, 27 Oct 2019 20:46:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y13sm14995661wrg.8.2019.10.27.20.46.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 20:46:18 -0700 (PDT)
Message-ID: <5db6648a.1c69fb81.8a78c.b7c3@mx.google.com>
Date:   Sun, 27 Oct 2019 20:46:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.197-42-gc1c6537ef129
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 88 boots: 0 failed,
 80 passed with 7 offline, 1 conflict (v4.4.197-42-gc1c6537ef129)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 88 boots: 0 failed, 80 passed with 7 offline, 1=
 conflict (v4.4.197-42-gc1c6537ef129)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.197-42-gc1c6537ef129/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.197-42-gc1c6537ef129/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.197-42-gc1c6537ef129
Git Commit: c1c6537ef129f3034eecbe2f57b332978eae2d2c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 17 SoC families, 13 builds out of 190

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
