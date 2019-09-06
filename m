Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55FDBAB003
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 03:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389504AbfIFBHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 21:07:19 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34012 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731344AbfIFBHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 21:07:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id s18so4761494wrn.1
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 18:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RwkhPj+npDWnxB/JM2cQgLD0zDvS5CFzo34xu6NBQk0=;
        b=C396GsWSK0j+4VUEOMTMob9/jO4uYAD2xxyaEDAqLnERzCLLo5ZBjivslJGD2nwPW9
         mXQrZUEIOCZ4mwx+ZI70WQySz9nsttcHGTDL9vYZsqQ+I5Q7+bVrf+XKRGmPfIaG4gvD
         m8OkO5hLX4OlnfR3q6SAyEGOIeCnrJgjoS82Er6WaN8S0PlfvTFhENgkE/5Ex5g8EpUa
         9sBbGQjqe2ROfI9tA/MlTah3ZQ5l8gs9vHnugdp/erk2WukE5Ng5wqizGdgi47azPfR7
         TPUubDo3nOO9FwSmDQkJTB9Cq4cmQOEiToLltvvk2ivNrJkT2OOzpfKzwgWl2AU4WSMk
         8gew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RwkhPj+npDWnxB/JM2cQgLD0zDvS5CFzo34xu6NBQk0=;
        b=VF2WkQGsddln04Gn1Uhl9FQ9YaBjh8MMZM7mbbAnVqMALsIKRroVJG2OLbOigL7RxK
         Izzd0S3bcGtV8oF0WfZNHne0Wac8od6/nqQEVkoi/SXWVLwJ+qaVb20dElx69NcWi9B5
         gAN8qmllxi6YTHWwHBs2NXr/Qa0M0L6nDSLFM14wMcpVDqkjXu3a93PBhYXM5BbkpCZj
         IoIFtysi+Nq7wZD+Afb8zA/WyKQMZ5CTVfqRFpJ7gHUT+jup9dfT4zqDpdrJEzZW3ZqD
         h2DDeW1TIRAq5t1xoY+G8FMF6sP2Yqj9DzVp0TmKC1LBlhwrxVPeOGN/owxv5+80QuFn
         BSjQ==
X-Gm-Message-State: APjAAAUIdFjtvAAzmxxY6lVZ3W084b1GxxE5YZyO7cNeX3YfU57xsMio
        WoNZSDNBuiNWmaHbsUiBRKLhbrzVyG7Mrw==
X-Google-Smtp-Source: APXvYqyoAjTvuUMA5oTqD3cEkhZ6dEwuYLz5mHBrL6F+cuiixRVwR7WyCWpt19MC3waZuTejMTpyjw==
X-Received: by 2002:adf:d1a4:: with SMTP id w4mr5237973wrc.331.1567732036845;
        Thu, 05 Sep 2019 18:07:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u83sm10106461wme.0.2019.09.05.18.07.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 18:07:16 -0700 (PDT)
Message-ID: <5d71b144.1c69fb81.65d23.25e6@mx.google.com>
Date:   Thu, 05 Sep 2019 18:07:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.190-84-ge4396f1fe8b1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 129 boots: 5 failed,
 116 passed with 8 offline (v4.9.190-84-ge4396f1fe8b1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 129 boots: 5 failed, 116 passed with 8 offline =
(v4.9.190-84-ge4396f1fe8b1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.190-84-ge4396f1fe8b1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.190-84-ge4396f1fe8b1/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.190-84-ge4396f1fe8b1
Git Commit: e4396f1fe8b19e88dd2d2f99ef4459376c56be46
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 22 SoC families, 15 builds out of 197

Boot Failures Detected:

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 5 failed labs

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

---
For more info write to <info@kernelci.org>
