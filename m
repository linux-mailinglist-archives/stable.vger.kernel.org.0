Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5AD6B627A
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 13:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfIRLuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 07:50:32 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39161 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfIRLuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 07:50:32 -0400
Received: by mail-wm1-f67.google.com with SMTP id v17so2221085wml.4
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 04:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ADDEHritjAAyr1Uf8VLuPhIliMxd6VsivOVJPdhBhS8=;
        b=IcsZZtbUEs8jBsoK7KsYNK5cDZzPKSxjZt6+nVKRSgsIKtKwQtdDiHlI0E7ej6vlqv
         7O2jwQDLp8a8q3IFsq42PFIB6AJ8zteplusOeyoe6oyWJsaR/sAefKieVEA2pwwS2Yfw
         7gfvSuBjjktTTKg2sVvoGUFdtd5YUNDL/xiw/rg7nytSt+RKwwxnpKfaMVJtQmmTC95x
         ISv/W0E1u3nNdexT2hT2ZWC2TgHyL29i541ka7pJNQWxwYbvwFLcpIW3u+fAr3QkKl7N
         pOUjeTGuzNPmSUDWuxH8qxkfWfjqGJ94bqwT++SuvtzHlcnuIrR3YUovSsTaoEEn/8gX
         iC2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ADDEHritjAAyr1Uf8VLuPhIliMxd6VsivOVJPdhBhS8=;
        b=XBR05/2UEbAJns+7q6Ho9NCng28BUZSDBnNPc10AreFkkv8JfZybjZQimxhBzFoQk5
         lF+yKV757cc+3nRcn4yg+hxUgv60+0EsgPY4UhIdw/jleKCCwfh7xaAwU9L0pqockVaX
         kEiWs14kqX+n9PF8cpEYYXZ/hJzDps/ggUgNbyVX7uCy3OUbTCiYZfzZmd8PvKN8sCLN
         yW1UG2oWV+iu/6bdTwSrovvRHVxDuouNhW0FWxe5GzT55FDVqXo1+20uwUm90N/fBQJW
         mbzoQQntfvUi7fHPhG5Pymc7Z0RJ0a8ORWN60PNKnBANnfTmyLYZeGzqnwMlzh1wdapZ
         fCAg==
X-Gm-Message-State: APjAAAUPWQ7swS1Ef0CcIpHR7+QA12VdJg2jHuj+ShrsV8M0ku12g8yN
        eEWfyLN2hAUUn9omE++FKikBYuLoo2OZoA==
X-Google-Smtp-Source: APXvYqzhqOBSFHelEoZI7tUiOS21bXjNwbtACdxY4nLIR2UuoFX8yn+DltOqMbFx/9fs0AAS6oSDeg==
X-Received: by 2002:a1c:c911:: with SMTP id f17mr2543578wmb.73.1568807430177;
        Wed, 18 Sep 2019 04:50:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l13sm1508370wmj.25.2019.09.18.04.50.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 04:50:29 -0700 (PDT)
Message-ID: <5d821a05.1c69fb81.a54f0.5e50@mx.google.com>
Date:   Wed, 18 Sep 2019 04:50:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.15-86-g2f63f02ef506
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 145 boots: 1 failed,
 135 passed with 8 offline, 1 conflict (v5.2.15-86-g2f63f02ef506)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 145 boots: 1 failed, 135 passed with 8 offline,=
 1 conflict (v5.2.15-86-g2f63f02ef506)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.15-86-g2f63f02ef506/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.15-86-g2f63f02ef506/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.15-86-g2f63f02ef506
Git Commit: 2f63f02ef5061324ba168b1cb01c89fd89a0c593
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 82 unique boards, 28 SoC families, 17 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
