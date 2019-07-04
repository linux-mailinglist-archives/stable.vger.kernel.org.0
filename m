Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B57DE5EFEB
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 02:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfGDAGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 20:06:55 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:40335 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfGDAGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 20:06:55 -0400
Received: by mail-wm1-f41.google.com with SMTP id v19so4109755wmj.5
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 17:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MriXJA2yihEAdbWOB9691dhhPFJzBQxQjowAN2PmhM0=;
        b=uSpdmX9Ha7UfMAwiM9R4etl5by8mgzdsVihqEFpBtfLO1hK/s8xls4kdA4p9xF/hK8
         3gfUr3esgE/FJaZ914K7gFoC5xUPUpwjMaBIGCy5Z+ryT4bn6e3+veF/CXrWfMkNys4H
         +YhTLWbsaMLlNAOAlyWvYafsVEvjeS5S5v6xhoEJ6Zmnu4X/8ROIcWHTcMORmbuLcNfZ
         241nQ/HFejg7IapF8ZnNziH1uGametrP4F8hRo1vrTNKpf7lssxF2naYnTrYDMGQgHXD
         LR2AORn5hGGch18Q368g9eLfHfRYPB3LGFmfmWBLLXRP0GVemKuyy0XgpwQtkeioA6zF
         qZCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MriXJA2yihEAdbWOB9691dhhPFJzBQxQjowAN2PmhM0=;
        b=NmZUY1R9Ah+XiOZwnwo/Jrst/gWwHJeLH4+BjDIyRpkI70mcEUC3TiPxG9PXMFms1c
         Eva6paQgUkmGztSCy3HX8/LzszRgqzYtyWDq1twmeFmrIsE7yWVW6NHHRs2Bh0X1Npt5
         48YAt5MLELpS/YKZkRVxA/LAX3a527pbiqjLys/DPkCGJ9Ex/Hta9/D50h7E8BcXZaoC
         dIOQ3G9ONT4JN4RuaOCq4tm25advKh2prp63+KqAva6w107ZE4Fkaj2Kg6kPr8mEdNR3
         Y5g5OSqN6As1QDvCswZHAmCb+WrPferR2QM/Pwn6ollMZjGvCKVhGlytHwP5TmgUU1Bf
         GL3w==
X-Gm-Message-State: APjAAAXBmqZDXni7H2QIWc25d+NOAiE2DS+q0I9JeS3Y5v6HDsUPWmhV
        77Rmt2V7m4h93ruKBRgUnwdsWuWmTEAkeQ==
X-Google-Smtp-Source: APXvYqzwgPbhsPrtPd0jU4xLVKIxKzIBW4wjZqRKEtq4+0UmAceEUuHTFrv+5BZt8JuxSXYVlhZzSw==
X-Received: by 2002:a7b:cc16:: with SMTP id f22mr10343254wmh.115.1562198813394;
        Wed, 03 Jul 2019 17:06:53 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o14sm2198478wrp.77.2019.07.03.17.06.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 17:06:52 -0700 (PDT)
Message-ID: <5d1d431c.1c69fb81.b049b.bf78@mx.google.com>
Date:   Wed, 03 Jul 2019 17:06:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.16-8-g57f5b343cdf9
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 139 boots: 3 failed,
 135 passed with 1 offline (v5.1.16-8-g57f5b343cdf9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 139 boots: 3 failed, 135 passed with 1 offline =
(v5.1.16-8-g57f5b343cdf9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.16-8-g57f5b343cdf9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.16-8-g57f5b343cdf9/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.16-8-g57f5b343cdf9
Git Commit: 57f5b343cdf9593b22d79f5261f30243c07d6515
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 78 unique boards, 26 SoC families, 16 builds out of 209

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
