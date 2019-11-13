Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACD6FAC6D
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 09:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfKMI5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 03:57:52 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43865 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfKMI5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 03:57:52 -0500
Received: by mail-wr1-f66.google.com with SMTP id n1so1335562wra.10
        for <stable@vger.kernel.org>; Wed, 13 Nov 2019 00:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZFIOeGNbKLqho/ojKOiILRJxwRRQGj7wHv9dOjtVAoE=;
        b=WiU3Zlt0N9fOncjDAcVxhX59X3QdrkQ2BDk+3DSK8njqn9wHoOGOtCwVZHtq0Qrbtp
         5ZB7zypSch6uGKEx0mc8yUsVjWzhhkPUNj6eeZ/rleGqgNZ0qXMl5AUQ7R398VkrfEtQ
         vNxEhkfkTWks+xVUmw8b/0WgBNSlHWQfHl7ibQU25a8uUCbLc5CCN/aX1urBP2XH9Phm
         H1oMAwB/lhrAkWRNi5fHn+ppnB9zUclBy1WCGJYj9wzdskpFI7RY3NyS5aqMfBBcMSWB
         W7VcAKJ4mvXpdKOiMK50ImBFiMCzUjiT0RDtOiMlj25xHeBG6S7+1Tl38yz3q2XExc/4
         cuEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZFIOeGNbKLqho/ojKOiILRJxwRRQGj7wHv9dOjtVAoE=;
        b=stItNrmJEDsa3Z0CgDOPk6E/dTwoKLVuxsPEGmTuHxvxTetaun6XagDldI2MbEcchG
         lK2HzzkspD2SBV5Q51A0dQt++QhZYCQJdhWLL71n7ZaxrxzJQkom0I76dhWUS1DN/RAp
         uqFWULXXdjJSQEIMMQH1KanT7LPDj26tqOYnrpkx2fx5DnzO93egRR/JbjwJXOFdEGoI
         U61bqKd9+rvI7BOxxGJtM1llxmXWRTViRBViWwYBj/jXhqfN5MKGUiJ/gsme0SVUqr6h
         Wmexm82aD0aUzVeMISeTB4Yxa9OuEg0vIICK78uEaOJvUDLQYvT5w+2ykxOXQRDv/Yi7
         OM9Q==
X-Gm-Message-State: APjAAAWecu/QdmdzcgKvNQvyv3MaohHCxy61QTuizsYXynbNDWlM7YjC
        vXUWjtq/krISa8IoH2d1wUH3Oc6JPxwjtw==
X-Google-Smtp-Source: APXvYqz8ZApr63qKPF6c1ul1kq+bkqvUGqaEtoJI0ObFv4hvLyXtvxjqPNuW+5ejDjk8kMfuY3SCCA==
X-Received: by 2002:adf:979a:: with SMTP id s26mr1743803wrb.92.1573635469954;
        Wed, 13 Nov 2019 00:57:49 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a206sm1663615wmf.15.2019.11.13.00.57.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 00:57:49 -0800 (PST)
Message-ID: <5dcbc58d.1c69fb81.6f563.7037@mx.google.com>
Date:   Wed, 13 Nov 2019 00:57:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.201
Subject: stable-rc/linux-4.4.y boot: 78 boots: 0 failed,
 70 passed with 7 offline, 1 conflict (v4.4.201)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 78 boots: 0 failed, 70 passed with 7 offline, 1=
 conflict (v4.4.201)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.201/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.201/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.201
Git Commit: 6186d66524c25c70d634206dd460bd6388e7e9f9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 40 unique boards, 16 SoC families, 13 builds out of 190

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
