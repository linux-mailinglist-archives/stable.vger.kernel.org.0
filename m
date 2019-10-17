Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB01DA4CF
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 06:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407777AbfJQEmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 00:42:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46355 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404642AbfJQEmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 00:42:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id o18so626778wrv.13
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 21:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=FeN1uImmkW/5svFPNeJ8S+pwMABF7Pq8US6YmpdEvHM=;
        b=N8KqaYCcgNZ1PLNJ0jl0sL+hJfMalVxkH8eBtE4YyJKxE3t0ayhlg2ZH7I1KtYyRor
         TjniFk1L7AS2TdkkzLd6t2FQ0wC2NAs1v2BlawWopqYLYciOjZ+0EUI0feBakmDGInAw
         uRqM+SnQQCEI6DU/Mw6oPpcPAFh9x9CUZ2dkalVp431SUvZWwrggX/zsHOpUus88WG4H
         1Xy9x5RfUnXHiwCQLm2KRU4j5/Po9TDiqkbutBW0upl7PSoZ867zc4/1wVCIieyg9kpE
         PMWnJlIeEA324yiRtywj4L044Rhw0k9pFTuNEtdOZ0v4DrChIuvxEk11R0cwf9MIgLnx
         O1xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=FeN1uImmkW/5svFPNeJ8S+pwMABF7Pq8US6YmpdEvHM=;
        b=ZImRUqQsZCQQ4UOb5MZ7CkrngY5hAtpZUr3uzytz0ZOxVOmnhKVd6A79GMkOWE01+j
         QT7iGBG+HTNMWoEv8It/r0T+G/Dn9SLj25qDEAnYFhZ0RwTeNS0rywamXHDadrLIqWbl
         0xAvrJCZwL1IuIN+YN+SSFaVUBDgHXkM7vd6IOps/hxg7wUvlZ9KFRt9/V+x1DbjvfG/
         yjfkp3W3NzCBVzeMIPu6qTubBbC7vAPRjX8buA3X1kzzGzKo9Zsaz7o6Xw1omGjF1EV2
         VbSVzbFu3Q0w8nVhqsnZEhg1mZZsc1SGtIcEUL1wOotiVMxNpiG2Vs182Byc6ax3EGxe
         H2Lw==
X-Gm-Message-State: APjAAAUtaAJ+OZOCCXJZPQRHHT1HTMmtcvJfGorrJyzgS41PbSQhIjFL
        LaUa2wKDaWOhRke2k3JQowBqog==
X-Google-Smtp-Source: APXvYqyRgLA0YsHBhsmE0gRlgCH2mUpBqjA5s6uY6vRMib6ZlHLGLLw6Fa2SbQn1rlxTZJHTGhrFMw==
X-Received: by 2002:adf:fbc8:: with SMTP id d8mr1089002wrs.205.1571287331374;
        Wed, 16 Oct 2019 21:42:11 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n1sm933941wrg.67.2019.10.16.21.42.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 21:42:10 -0700 (PDT)
Message-ID: <5da7f122.1c69fb81.95db3.3e85@mx.google.com>
Date:   Wed, 16 Oct 2019 21:42:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.6-112-gcbb18cd3e478
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
Subject: Re: [PATCH 5.3 000/112] 5.3.7-stable review
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
