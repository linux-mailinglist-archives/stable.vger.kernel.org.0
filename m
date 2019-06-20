Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 178524DD04
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 23:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfFTVvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 17:51:04 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45642 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfFTVvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 17:51:04 -0400
Received: by mail-wr1-f68.google.com with SMTP id f9so4483180wre.12
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 14:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=hRfNWLmAN1kN9+qUVVhKW3SVXeFOGVUJPL68CIg8o+E=;
        b=u27duObejx4JNLGQLCsLfLy4LVeKNKcJZD0IyVD4T9c0XndFERVY/RqvBo2pYtGs23
         1haMSzqNGqI2a6+thGSYGd8EDrSwUU7nBkcp4GQCuaxZag4Ji9/ETB8VwhV7IUcWcRlF
         Z4mFq0DwaEnqULtnp1+CwUBFKmVLy2rFdW6tOnGmyU9Gm+XzIP+WhCHAMVO5sRwDO5pl
         DY4+t7ElJLE0Q4qeVMFqQ2Axrv0fk7dyYq5fYtvdN8BmLfPEB5BvREh7KYUUlAfaF6fW
         tshEhYdmlfU/RvcjsItOB99sUbDNoHg0uRcBgDoi47FPLiJZZPKMSGaC/qBKRVD2QJz5
         Ybpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=hRfNWLmAN1kN9+qUVVhKW3SVXeFOGVUJPL68CIg8o+E=;
        b=J49mbpd3f+uRdrwHLP6KYsmOZdcQGylyUC54FK7uxdGF/rD5931oX+V88txPAabirp
         V5ICvk/0WT9IanTOR9Pfbra6F0oIlF1pwKRr3QpZ9FDXwF6/6+LohyrBAoPdf3/rfS4q
         i/0VNFLftbVSmv5NPxCRB8Or5QdPP4BXoCiz9XqAH5BmtWJsmeJMkUQ6RYxnBe6hloS0
         eZBf5hM3Et9aUL7dMl9bSFy6OYVVXNmgO//ZcfuX8DcEVezH7sgztTY2ob3MRLW14bwv
         GPkXVozgAZsJXb0lOg+1tmCdmOV3G4nU6lBh0t7EQF+mD+F58hsOXA0Jcp0pdzWRnKHk
         YQWw==
X-Gm-Message-State: APjAAAXKMixkHfGWmhF8DZNwqjXeGLeu9IzlkgHFdHGJydCnGzbQ2m3E
        PbFu4fWRkA7TJMKA2Xwqq6KrFw==
X-Google-Smtp-Source: APXvYqwF8kwk69GoEVRPbky5+oL7qWCG1rkDbKx10SP7jMbBOiViweq9xq4+PuSQZ1JYcRqDUKIf6A==
X-Received: by 2002:adf:e8c8:: with SMTP id k8mr65161424wrn.285.1561067463063;
        Thu, 20 Jun 2019 14:51:03 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p26sm1698396wrp.58.2019.06.20.14.51.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 14:51:02 -0700 (PDT)
Message-ID: <5d0bffc6.1c69fb81.b2a7c.a927@mx.google.com>
Date:   Thu, 20 Jun 2019 14:51:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.128-46-g593d1fadd024
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190620174328.608036501@linuxfoundation.org>
References: <20190620174328.608036501@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/45] 4.14.129-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 118 boots: 1 failed, 112 passed with 4 offline=
, 1 untried/unknown (v4.14.128-46-g593d1fadd024)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.128-46-g593d1fadd024/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.128-46-g593d1fadd024/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.128-46-g593d1fadd024
Git Commit: 593d1fadd0247d5932dd5e626b90fe30984c2ae5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 23 SoC families, 14 builds out of 201

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-nexbox-a95x:
              lab-baylibre-seattle: new failure (last pass: v4.14.128)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
