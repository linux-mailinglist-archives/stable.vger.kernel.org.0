Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F79114A6C
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 02:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbfLFBUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 20:20:02 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39247 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfLFBUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 20:20:02 -0500
Received: by mail-wr1-f68.google.com with SMTP id y11so5957512wrt.6
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 17:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TCNIueDh4KtENKHBryJCv1cTPm1YDlPvnBoskSSpgRo=;
        b=Qe2VDyCX37j7j2f/nYQakIlpJ1erhK3a4PLWG76Nlim1FpZ5cQhW8BvbS7tGUc3Xm1
         nC0DgxUl64CUcb5P/XzfEYgK8N5QFYtDAD2YWD9JpqFD5Tb5nv4HmZFSY5pgXIKrRlMh
         k/cMSb7/IlpOjZtiNiuj+mKQoRdMUliz9hDOO9NlGC760JZEDki+9P2bpd53cKDGazy4
         Uryxgr+pM7BS3Vn9JijA1DnQXm9Li9rLwWj832KuhFi/qCLps2RVl/uaIuhPA/9JbMXT
         diL8mAjqj47tZIGYcuUL9Sd8N6bTkbgmD8mCuF2liMKa7S+ZBno4mc/uTrEo3IbTswJj
         B0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TCNIueDh4KtENKHBryJCv1cTPm1YDlPvnBoskSSpgRo=;
        b=E5CZEVRtxwiF8Ka2i9XG3Tj1uU7QtBzHgEcozGmXunta6bwmYuirri3shzPknViexB
         Q5ounrknl0ZfEodarQ4rOrscpaRXpn19Fsk+4mmeWN1viM8kHokxjhM73+VOMZsWafWf
         WBhoLGkERLjornBYzQJVfkH/3Us1cYg2C1vZtPzzLpXnJwKPmSoP670jqyzOwH2TLZGE
         PETODwU/JnIe+UO1/jSf63iT28hMYTrU7Zu7H4iEc8eVFm/fYhQ5U5v3D70eOpMHYb0N
         /+2ub6lqstHZ5tCBTzIwIpjKQ34AuFl/DaVPEtN52YJncLm+lpsZINwY1/rZYJ4Ez+IQ
         cbSQ==
X-Gm-Message-State: APjAAAX3MvAvKQS3cnydfDFSHn3PX7q5d8BqInXZuihiJWEoT9cqWCmm
        pHOKt3BL70uvxR/uwnZAIxJH1It7plu+hA==
X-Google-Smtp-Source: APXvYqx2/+imxEqCxF5gZLHKYVNMlKD4KExemG98TDFPWPxLz4mBb9wPrs7kzfMbXYaUJwZRyrR/HQ==
X-Received: by 2002:adf:a141:: with SMTP id r1mr13111507wrr.285.1575595200267;
        Thu, 05 Dec 2019 17:20:00 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n1sm14073399wrw.52.2019.12.05.17.19.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 17:19:59 -0800 (PST)
Message-ID: <5de9acbf.1c69fb81.df4e6.a8ae@mx.google.com>
Date:   Thu, 05 Dec 2019 17:19:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.206
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 94 boots: 1 failed,
 86 passed with 5 offline, 2 conflicts (v4.4.206)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 94 boots: 1 failed, 86 passed with 5 offline, 2=
 conflicts (v4.4.206)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.206/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.206/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.206
Git Commit: dc824ef433c6b378e90bd87bd6a57fd607de7c32
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 16 SoC families, 14 builds out of 190

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            qcom-apq8064-cm-qs600: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
