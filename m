Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B95DA48D
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 06:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbfJQEXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 00:23:13 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45111 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfJQEXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 00:23:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id r5so598687wrm.12
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 21:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FeN1uImmkW/5svFPNeJ8S+pwMABF7Pq8US6YmpdEvHM=;
        b=VlY4QfWovqk6L35frUmK5z6maqfxaOcFIFX6KFdaytKhtv6BpvSvo5qZts5h1nXxOB
         VtlE55wtZLyvbqc/lE1x0mdNRXrZJq9b9mQ3zK+h6mgonxLnk2Dug8AnYFfxNUZYqO35
         K3VBHD2VxDQCwUVHXI6iwGsexWjeNi8Wq4fQ+GQsuiOWli/9IFt0732vrD8HMNmqJbUz
         azvTHBnK1ABYZ6kqTk7DQ9ooSonmgNf5aYuDme8e+RxX2EcgtsnVziZ+1MeU5gx14dnb
         oq3vX1U2nAb7SE2bKgNb7AHLDtrFjp7SqWlymmy1CGpBnUddx20Cnig0g1HndyHblTUc
         dgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FeN1uImmkW/5svFPNeJ8S+pwMABF7Pq8US6YmpdEvHM=;
        b=rfvjMqR8Dx1hIMNosfcV014STzQ7YQJbanWVrKLWJHfdQvXl73+aQlD3P5j6VQAS3Z
         TX9NUZXfyefpBLF+XZkvxLLpC2ggX7gxAqpr0mtM1w0kWo+eGMvHKZ6Ub4vI5rDtmlvi
         Xxh66jT0kn/HJBmh6Z+HRjnhxen2yQs/5oWGxe+K2+E7yCCdYDAzEU5jJYqSVWrOnvzw
         ZfQ18CekbZaKuy7lB72Qug+5elXO9lmM4ZJ1xxtn9JDVY2npHvfnjHzh5vsY55M/MgL6
         lvNQT/M1aKNCiCT6rCSpL3zbBLYHdETdZCqiy2F70lh0T7tmNbgiXbc7Nqa7iQH+pKdu
         Xl3Q==
X-Gm-Message-State: APjAAAWNOB2IZearcH7SRoky0tsfersvAyacn+oMp+pq4E4Wq5VwuMhQ
        XQ5Y+d+76narDkSia3I+aVSO9Z605pg=
X-Google-Smtp-Source: APXvYqzkV/YjB3tQZhxgNgYXW1tTOoWBfrlhmZGZpqOf809OMTRnrKszCZGeb0xfgeNkszoSEd5kJg==
X-Received: by 2002:a5d:6189:: with SMTP id j9mr1016741wru.21.1571286190991;
        Wed, 16 Oct 2019 21:23:10 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t13sm925807wra.70.2019.10.16.21.23.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 21:23:10 -0700 (PDT)
Message-ID: <5da7ecae.1c69fb81.51e05.3c4a@mx.google.com>
Date:   Wed, 16 Oct 2019 21:23:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.6-112-gcbb18cd3e478
Subject: stable-rc/linux-5.3.y boot: 118 boots: 1 failed,
 109 passed with 7 offline, 1 untried/unknown (v5.3.6-112-gcbb18cd3e478)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 118 boots: 1 failed, 109 passed with 7 offline,=
 1 untried/unknown (v5.3.6-112-gcbb18cd3e478)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.6-112-gcbb18cd3e478/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.6-112-gcbb18cd3e478/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.6-112-gcbb18cd3e478
Git Commit: cbb18cd3e47885e336b42ce05d553b44e1e3a7a0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 78 unique boards, 25 SoC families, 17 builds out of 208

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-khadas-vim2: 1 failed lab

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
