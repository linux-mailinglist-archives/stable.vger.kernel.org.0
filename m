Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB5EAB07E
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 04:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404312AbfIFCCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 22:02:40 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44994 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404307AbfIFCCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 22:02:39 -0400
Received: by mail-wr1-f68.google.com with SMTP id 30so4792968wrk.11
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 19:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tz0ba8wuHkjmV5f7ZGa8qK9xv8ELkUP7mCjvQnWZMmg=;
        b=afycwoQpHZ41qzD1wbQdn0cq/BtGP9sSUlE3o80ffIOAilu8KUJuz+FDRgmNlN5A7t
         XHRwTJpI91LslmLBhdIPxnIeGihk0UneHj5c9tc2Yxga+/k085PhFBemiec40S+UuxtM
         +i68gmDqCt33taYz/BNhgoF3V1uLqMBzqkGVs7UW8O6ArPyNezkubn3q9Qu43yZyqaxO
         U4wnXysb4KlbycspRPUjB7CXvwOy8Q0H1FKWA22oqFI3cku6+uZg4Q+t8jYRDwM2eRJz
         JrMHIMfpbZTBFcIU7R35L3ZLJPlm+eBlhoWWX+vLxZrNk5tmg3BfTMXi8X/6JJXLANVc
         nXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tz0ba8wuHkjmV5f7ZGa8qK9xv8ELkUP7mCjvQnWZMmg=;
        b=SOT8ANrv1iUWpvAreAAjRRZ+U5qF+s4Ja6WdUlZ9BvrVhpKKbO7bRjsbEyf4qv85q3
         TDOBhTSVVY6aVPn1yOggX0EOuUh88QQ/awdITs2eCx8mlzwxIpjb6alJN17yWujkNJeY
         QmPwdS4wIBPYC5ai6OQfRsN+H2T9X8w6W+JkzGIPEgX9XmuBr83KnFHOPcplBzwKNNkD
         QC/ANjS+hMEDUvCCE8q+p0BOo7lLPkco7zfg+ULGakLJoCLH0l5IHjBKM2QWHoKm83DC
         3Fp0hIBgFS7ftjjsj7+sf81NJ0rQVi/WCkbknljR3bu16zh9hDLAT8DRtbAf1+DuILSW
         8VZw==
X-Gm-Message-State: APjAAAXkHXAHXrXxYXyDOI4WkOQTXVq3TcHocfWLtJYdLpQmVv82qOEm
        VGLSpj9im1gt32CJQjyZv8oHIQpHcuThiw==
X-Google-Smtp-Source: APXvYqwvQhddvP24TMgmaBX84SxacteNt5CyiVn6gIRWHs/wPUVJs5RvjWS/85nyLmrVe8Yh4T2c6g==
X-Received: by 2002:a05:6000:1632:: with SMTP id v18mr5424026wrb.61.1567735357512;
        Thu, 05 Sep 2019 19:02:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c3sm5039627wrh.55.2019.09.05.19.02.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 19:02:36 -0700 (PDT)
Message-ID: <5d71be3c.1c69fb81.b7926.893c@mx.google.com>
Date:   Thu, 05 Sep 2019 19:02:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.69-95-gec954fc4f700
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 143 boots: 3 failed,
 131 passed with 8 offline, 1 untried/unknown (v4.19.69-95-gec954fc4f700)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 143 boots: 3 failed, 131 passed with 8 offline=
, 1 untried/unknown (v4.19.69-95-gec954fc4f700)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.69-95-gec954fc4f700/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.69-95-gec954fc4f700/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.69-95-gec954fc4f700
Git Commit: ec954fc4f7004b23a33c283f130c9684ebfb01b6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 25 SoC families, 16 builds out of 206

Boot Failures Detected:

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 3 failed labs

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
