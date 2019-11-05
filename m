Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB730EF68D
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 08:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387903AbfKEHmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 02:42:46 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46035 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387678AbfKEHmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 02:42:46 -0500
Received: by mail-wr1-f67.google.com with SMTP id q13so20070631wrs.12
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 23:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FywQm0vc8BVrO4PEhiMcRf8eCk2OgV20lI7T1YCiQl0=;
        b=S+x5H6h7Y0fDjFB5WhNC7TpeLRCkcAC5LsTmGi3J46HzsYvtl8S44aBJM0FZMX1xcj
         rrQZcIhub/zcYvAByD2bH48PJ+v4Inj9ie53jguSWyyos9EFjnJeC5u0JNxjkeZBE/rw
         JWU44/tlWUbhb3TwjZ8+UpsyX/6Hs9eI5WnEbb8m2M04sQ8ZAmivdJPQoNkuOkLZn/pO
         MgBAXwRCOJT3/skAU+ORNG8Xj52AQbhaNB64NxzrYBNbTOueht2Z912T1Nh1TY8+q4pI
         DPsd2yJH28eDOr19AM1JOOFSPYZy+U0GQApG53sGcn3fXkodVrWn80bpnFQdNNJcnwJR
         n40Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FywQm0vc8BVrO4PEhiMcRf8eCk2OgV20lI7T1YCiQl0=;
        b=aJ7Nt6gxNRWe5i8nFV5C9RyaW89IERNwxC7pyM9ZlEXqkk7trXjPc59gnvr60QXFL/
         r6WyiOtbE8gsNHx3UYYBLftegryEr2/o2twdkgNHSijWtOU+uhozCFiSOjcQxyXLSguf
         7bivj7nPVYF3U5PtnAuuMbIeOG4mJFKDImLmct6yyjXjg4agx39QA/uZbSjt3LB2l2OQ
         GM1C1Z495qwkkO9aFLK+iQr7ea8DOQP0qR4fTi8ohxByv8RqLiC7wJXi62FfSYDaoDQz
         oJJ0hFBcxiGxNVOtDxO2ORO5P1O0akIjhNzs7YaXzABDCmZ+KOsUK9Wp2wocLIFC548U
         /ypw==
X-Gm-Message-State: APjAAAUFgbI3bS/5GPQmuHK5bjyILJ+KH639FHGMC106Q9j2Gpf0+XkN
        am1qsaWqvBFjnrquNmTvRxBOgbKcoCjB2Q==
X-Google-Smtp-Source: APXvYqwd+MUUkmFKogyc5XZH7Y3T6A8SIcTGehr2JDjF9uqgQdqKhSi/YVM+QNAKMbm0tC9E8sy9yQ==
X-Received: by 2002:a5d:570f:: with SMTP id a15mr18086622wrv.316.1572939764428;
        Mon, 04 Nov 2019 23:42:44 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l13sm6270720wmh.12.2019.11.04.23.42.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 23:42:43 -0800 (PST)
Message-ID: <5dc127f3.1c69fb81.14af2.41ef@mx.google.com>
Date:   Mon, 04 Nov 2019 23:42:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.151-96-ga9ad8ad8b3ef
Subject: stable-rc/linux-4.14.y boot: 108 boots: 2 failed,
 99 passed with 7 offline (v4.14.151-96-ga9ad8ad8b3ef)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 108 boots: 2 failed, 99 passed with 7 offline =
(v4.14.151-96-ga9ad8ad8b3ef)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.151-96-ga9ad8ad8b3ef/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.151-96-ga9ad8ad8b3ef/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.151-96-ga9ad8ad8b3ef
Git Commit: a9ad8ad8b3efffde7dfb6853480bb74579a0b973
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 21 SoC families, 13 builds out of 200

Boot Failures Detected:

arm:
    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            rk3288-veyron-jaq: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

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
