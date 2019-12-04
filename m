Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66FDE1137DC
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 23:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfLDWyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 17:54:37 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:55660 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbfLDWyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 17:54:37 -0500
Received: by mail-wm1-f48.google.com with SMTP id q9so1520558wmj.5
        for <stable@vger.kernel.org>; Wed, 04 Dec 2019 14:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SZwC+NWXqoDlZJJNQuquDLIjLThAUaxeYbBAemSQa1M=;
        b=GTeHTq1Fk89iL/tBVFuatI7LLAeqmihca9C43fztnDfriD6qRfuay4ZphplXWn/BHp
         EqeY7lR1PXh2HWlM4sAJhMMTV0iXh0l/kPEtBED0tjC2JwPrDJAGucGw6EtkRoqCKNtp
         WlysNikDphHZGgeT3c65vkE02ceJZE/yDquMj3NZiz1DoU3NvHQkUjvvlAbSREb6ciJw
         xvf6orbnjwQmIkgslhrc0D2ATtiIqykVNMSwT4fDgBx9W3AFxHgXYZfK9Eu0w+vLVvck
         m9GrfHc2Q/89hUYcyexCQxhF4p8RpujOFBfySFSbln/U2VKsIps9m/+7UzXZmLwIaNQr
         RPdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SZwC+NWXqoDlZJJNQuquDLIjLThAUaxeYbBAemSQa1M=;
        b=OkPQRQnhixEJsOH+APlGZg9zrUQY97jeW/6f00gYf/t3Pr4eilZZHWBj9dTfxf7kcR
         zsXPMvs6spTM6uKp/pYRrILxRL83PAollLmU2JDtP3ZNecPBqPX9C7bluiOkmujt7oyk
         HVl0OM/sz/ASVJ4uKBeTXnQnR9XwBSBaYleD78Gc0NN0i2WBBbGFYhTVi8deeNI6NOb3
         31/ks0THzWYGjET7K3L1NsOU0btMGCk4k6v3DyYtn8Gd8llVYsyz0JHw9HsafDQL2waV
         9pJCRMdBOo5gu8Jp+BrAXNv1U4OR1Sp3bEp0t/WTSUHVRYT7G1n/dq7G9L7h1qDauNTa
         obgw==
X-Gm-Message-State: APjAAAVfkPAL8DtX3CqTEjgfDSDVSc+41fCAL7xoJdKB/VKlqkZo2U8k
        WgotRl92Jwv0ZaP2QLt3hTJGe7NtuWU=
X-Google-Smtp-Source: APXvYqzrrSTAPtC+IRn8M2wUH6dBzbN4CravEMfZwVdz5tpoawC5sj6tlHQ6D1uTx+S4Hz7Rs6DNLg==
X-Received: by 2002:a1c:1b88:: with SMTP id b130mr1986307wmb.4.1575500075258;
        Wed, 04 Dec 2019 14:54:35 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d8sm9938812wre.13.2019.12.04.14.54.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 14:54:34 -0800 (PST)
Message-ID: <5de8392a.1c69fb81.fc021.1f65@mx.google.com>
Date:   Wed, 04 Dec 2019 14:54:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.205-126-g0cc0fc017aa0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 110 boots: 0 failed,
 104 passed with 5 offline, 1 untried/unknown (v4.9.205-126-g0cc0fc017aa0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 110 boots: 0 failed, 104 passed with 5 offline,=
 1 untried/unknown (v4.9.205-126-g0cc0fc017aa0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.205-126-g0cc0fc017aa0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.205-126-g0cc0fc017aa0/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.205-126-g0cc0fc017aa0
Git Commit: 0cc0fc017aa01b56b9a254fc5dcde637852b0c17
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 19 SoC families, 16 builds out of 197

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

---
For more info write to <info@kernelci.org>
