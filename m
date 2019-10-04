Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D72ACB470
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 08:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388310AbfJDGWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 02:22:38 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46506 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388306AbfJDGWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 02:22:38 -0400
Received: by mail-wr1-f66.google.com with SMTP id o18so5505851wrv.13
        for <stable@vger.kernel.org>; Thu, 03 Oct 2019 23:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rKDZNQHbI3yhJDQcPVxUjNjc9rSkeH/oY75z6ZC22no=;
        b=nTlQ5eNpApLH97DReGAjm0q+mqTQrRawO1lYhilnfJQj24/gio/hRYvWffPeIocWr2
         TA8yQCJSncJZ7MLVGPhx2bu1cEF16vf9BmMVQgA+ZM8KZW6R3PVKNUbQe2+kKv2uJNUW
         s1Req5fsYIrQ07daf78S4heRdbTze2AflpnwVfOLBNAgZ4AHxHbGz6Aojv8LOPETaH9d
         oTJ4Ae0++5UEhD1tSm2usNTNCEH5q1f+uXyuUSaksx4Iz7/0PwqRh6sOzcUQZ9kd9Beg
         t0EGM/rC2dGx1iZ9ovCCDoxq3blydzisCsm9qhz40+THUIvNAPDsvmG4c86YTXfE5YmX
         v+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rKDZNQHbI3yhJDQcPVxUjNjc9rSkeH/oY75z6ZC22no=;
        b=b/1SYwo0AyizxdNxTdEiWAdALhvWNQVfkmSUSX/XSNy0WuCTs06QoUVInA8Ff6F0A4
         OhisHlcsK/8pGYxi/zJngJjXL7qWvDlD492dIv1XxDxcTHdjABdeDilfhr2C2uTBY100
         7xMf/q02k3E497wSWrvxYeodMx4G6ykhINfPNGM9aNk8JEC/ekYBW+8OtFU26Jlsyj/L
         JqADI/tA+iW/zsuU0/eP8MYK7IMRquu2uLZuYuSOnHI7lHbvCY/OncPocwBzx0cgsW1T
         4Otthz4yBl8PJuzd+oqQdw0rcLfQTPec6WqurIUcEGH15nc3KMjt5QaZxQTSDZmg/AzR
         0RPA==
X-Gm-Message-State: APjAAAWJrpg772oded3KP/2GVC0+T3RqhUI13CGKIKXODU7zkoYxCqex
        MkYvBU9eYaGlfT1LxQr7W2SwXUHSiFi0Eg==
X-Google-Smtp-Source: APXvYqwsN1lt05x9aM4FdNdNeDpE+d62OK8BVPIPd7q2IkbnOGW8gDU3VQPmyS3uE+eYO/Bw20mDGw==
X-Received: by 2002:a5d:4c48:: with SMTP id n8mr9750494wrt.192.1570170154471;
        Thu, 03 Oct 2019 23:22:34 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t6sm9230427wmf.8.2019.10.03.23.22.33
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 23:22:33 -0700 (PDT)
Message-ID: <5d96e529.1c69fb81.51d6c.bbdd@mx.google.com>
Date:   Thu, 03 Oct 2019 23:22:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.194-100-g9a8d8139a7e5
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 90 boots: 1 failed,
 80 passed with 8 offline, 1 untried/unknown (v4.4.194-100-g9a8d8139a7e5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 90 boots: 1 failed, 80 passed with 8 offline, 1=
 untried/unknown (v4.4.194-100-g9a8d8139a7e5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.194-100-g9a8d8139a7e5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.194-100-g9a8d8139a7e5/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.194-100-g9a8d8139a7e5
Git Commit: 9a8d8139a7e557ce81c19f467a2a873371e3deba
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 17 SoC families, 12 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
