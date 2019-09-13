Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F404B2664
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 22:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730228AbfIMUDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 16:03:25 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:36203 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729118AbfIMUDY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 16:03:24 -0400
Received: by mail-wr1-f46.google.com with SMTP id y19so33229137wrd.3
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 13:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1EXHYqWuYUZbZDvA/e1+2lxe1TJHgdaE/HYVLCwEBwc=;
        b=2Lot7KQ+D+IZ368bHbTlXcxCYAw+igh8s76Vh7gPCOoJB276g/9vnSrDBv1e+XiQ05
         9WfB8xnXGuOnWnno4JsELFjM3DDQqZ6+atYWW0Ry0GDSuZ0Zt3a3zqFi0a+vL6wwWi8Y
         KDYiQukIC1Efi1HoOVbVl6P+pY2wGeRcD6pOEHjfEH8bpx1Wa/pPIsDwG+K+E/qP6oC2
         muTf4A1A2aMUzAGIwG4VsptZ30SNKVNt+FsEY6d6ROeoJAQU8OfA5k2E3I3JCdqI09nU
         w4IE0cqe/Vr9BJf8wi8widNhe/+TGMQVtTflpqkDDP4hu/TTBy3p927Bjk7ta3mK5/tp
         6n0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1EXHYqWuYUZbZDvA/e1+2lxe1TJHgdaE/HYVLCwEBwc=;
        b=XWPLDxBIFzTwOphDfAnPYGggaSMvKLVaAkS6Vyhy3UH8GphfULwP3F1cgwPxmgUn9D
         wbSfPsh5bDXwIgfot6+0S4KVi2Zyj8gQsR+z9kqMcdw7SCXQO7L17dgF4aQc9cV6EWOB
         UbTNu/EADDeEghjd5RH5wCw72P3qt/Ok0+2t4DvKeL6nZ5UghYnXF0zRm8cv0xXQ4STC
         LAih0hm2jDh2flHc9VDLqw7szisNQZDRe+HBP0KE/7QW8S+u/xcOJfOb4ptOFz5W0ugV
         fGF5Xkrf9UxnmJtJyfHYkjKECQZ7IGmaRCeJVKP+67h2kE5/l/S5wzzOH7TbYDTGa7+C
         Z2Cg==
X-Gm-Message-State: APjAAAV3JKCohOUEiHDPG4uyEkxPIIdy580ffc4K+4nUJGg0EuTKKMwa
        R+ZzWL5kbUqJ7yN0PRH8NWrTHRdCSXV2xg==
X-Google-Smtp-Source: APXvYqyEO3kPfR1AtkXJ/7mm72tIe7QiCI8ebEJt3YlXwII6O0ApYfhf3PepjZMM471dGWkNpu0+/Q==
X-Received: by 2002:adf:e784:: with SMTP id n4mr41587522wrm.144.1568405002929;
        Fri, 13 Sep 2019 13:03:22 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b194sm4466264wmg.46.2019.09.13.13.03.22
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 13:03:22 -0700 (PDT)
Message-ID: <5d7bf60a.1c69fb81.9c9c3.6353@mx.google.com>
Date:   Fri, 13 Sep 2019 13:03:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.192-15-g8e25fc1750f0
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 115 boots: 0 failed,
 105 passed with 10 offline (v4.9.192-15-g8e25fc1750f0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 115 boots: 0 failed, 105 passed with 10 offline=
 (v4.9.192-15-g8e25fc1750f0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.192-15-g8e25fc1750f0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.192-15-g8e25fc1750f0/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.192-15-g8e25fc1750f0
Git Commit: 8e25fc1750f0dd9f378c153ecda509a578059b81
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 55 unique boards, 22 SoC families, 14 builds out of 196

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
            sun7i-a20-bananapi: 1 offline lab

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
