Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139DE6F3CB
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 16:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfGUO4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 10:56:53 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40648 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfGUO4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jul 2019 10:56:53 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so32989866wmj.5
        for <stable@vger.kernel.org>; Sun, 21 Jul 2019 07:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SSlmzFXjnNa4xV+UX9adDDBTX2M5d9eghdhePWmz0yA=;
        b=1MdUvzsLAGRZic50bqNhoweOnhGatH+CK9cir5aM9jU5dr94pWOR56i22atVFB0wbG
         EYLcuG4wdqL0Oh+PS4N0RzHuZ16pW3l7/sZhKcnthrBDLFiiw3YJbwMaSKdE2lvXHUGd
         Hcgc7mgdm5lBV9zWpM0ajq2G9317oir1ObwVwmcdfD7VdqhFUrRPRC/0nx8Owl/cxulU
         07gftaid32UgiWkGiCFvzJgiONvKXECFFQ7KepDDwL8Ml/cJAjVXoYvV66hXAFmhvd8p
         Rh4dGDtU/YNRlVRQ+pEc9FzBT62Jkb6N77jngXNsGzwmLq+MnFO/eyH+61fBoqenvwRb
         WuIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SSlmzFXjnNa4xV+UX9adDDBTX2M5d9eghdhePWmz0yA=;
        b=LsJQgXCxdn4A+jRP5Rf0EYx3S08hAnpZyV0fsSTM96wgjdJeBwe9JXLAydCyq8gYmt
         9h0NJmwdow6qvJhdUqOrcmI2Pq52zsGlqqRp7+4/fXeY0qUsjoVlz+tOHbkDgVg3Yyal
         eyv7KQzedaFHcxQA/xkSh5PCUj/LyVk2IHYbMmkYfxdy0Rdl/o4C5QELT6cV6Z/n2OfP
         rzT+LgjTO+o0FWwuZ+Y0/pq+AfLNJaxHirXhXsTcIgFpL0iiNg+kLjbg5SdtjphTMcxB
         lHub/OyDYVgop9gQvBVMXIJa+tDBrRS59iaTc+39W6cxkRy9UpcQbhfNUyn/S870F2ej
         ahZg==
X-Gm-Message-State: APjAAAWHeb4kVzN87zOMUrOf71rpbTnC9nuj3Gz3eEWU9vGDsg09AgKL
        M+PiUwki/Nijuxr5Byz2f5dAi71B
X-Google-Smtp-Source: APXvYqwXr6uyyP32qcN4QK7FBYyEMNJD6tW0KuWnd190O7zB8U/bmZ+3CZZJBIcL3WDc7/AnNY8cAg==
X-Received: by 2002:a1c:4184:: with SMTP id o126mr57793495wma.68.1563721010490;
        Sun, 21 Jul 2019 07:56:50 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o20sm92500046wrh.8.2019.07.21.07.56.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 07:56:49 -0700 (PDT)
Message-ID: <5d347d31.1c69fb81.af1d8.ccc6@mx.google.com>
Date:   Sun, 21 Jul 2019 07:56:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.1.19
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
Subject: stable-rc/linux-5.1.y boot: 106 boots: 2 failed,
 103 passed with 1 offline (v5.1.19)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 106 boots: 2 failed, 103 passed with 1 offline =
(v5.1.19)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.19/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.19/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.19
Git Commit: 0d4f1b2afde8df3b0ca79818123a43a184a0e1ea
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 24 SoC families, 15 builds out of 209

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
