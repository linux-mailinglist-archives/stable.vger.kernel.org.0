Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94430B467B
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 06:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733190AbfIQEaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 00:30:13 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:34869 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfIQEaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 00:30:13 -0400
Received: by mail-wr1-f53.google.com with SMTP id v8so1567487wrt.2
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 21:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AFuIalAtf4mCOInpktBIRNHepJpyhbiFyhVDyDYZm00=;
        b=tfVdjbjGy+xRSrwS1qmMfeUw+bvi8VTEokmlg2Va38r5rrsgCPquxmy9cmcfIFA1SG
         mve8rONDM3RXGwaprKRoors9ZnejTn1cMmVHAPsdCSLlJikv3GUDbBoVICbO6UV8SSkV
         8mQlpA1bYv1TRn4ikFiNo1qWZkAMa54kQsQhgaXgQW/tXG4Fn8sNYFv/aQmibNeqsb1R
         om7Ix634ZRmOZe7ZLsY7po4HJ7dv07tckC7g9iEUko1bIjXInMAJsX18/MLOclCvAtKf
         ZrcSjY0OsjD9WTKlZIki5LFMUkJskXlQeQz7Ask7xaa2tqK0WGDRXBljZYODyPcqCB7e
         cF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AFuIalAtf4mCOInpktBIRNHepJpyhbiFyhVDyDYZm00=;
        b=CG2T3LQEjmrpHZ0w4rK+1IGCCTtULW7HC8ck63vujVMRmQ0a8URmQuzaYbWnxSY4Wa
         iJqFBTN5UDsG8BFP+23vm878Tse656yXqqyDGcK7dbkLMjixFMaMcdEBwHzHgHIQAT/7
         +GZqlKyoFAqK+zTTlpY/aT5VsOB003LFMocQK/R8KqFcNGFmCXrg1a9eJV5jbLZ+5tve
         BKiT3RCak10AGFVywM6iGxmBsnTBdHa+ck8OfrQ8LAERI4MjqR0jOfFuXkjK19zPRPzH
         hOqrKgUWDjD9/c7kM2EndrtcGd2JQk08RAWABuMaHiYzTV2zd5RKUyAIr4EneFKdqCYd
         Nyaw==
X-Gm-Message-State: APjAAAVGtM53lql5kcmmwybQbwo2uyh+PaOfKlGHa3aZFyi8SchBNJGJ
        1qx6WPc0rowFm4bG/rHwILNdyipm0RhGgA==
X-Google-Smtp-Source: APXvYqwrPkhKXwAL46w53twKw6NTGfpjLNYXQnmYMSwtmu1Yg6uUgelgT6fEGB+M5Ik3bGJ5Vx5Aag==
X-Received: by 2002:adf:de0d:: with SMTP id b13mr1287762wrm.140.1568694609519;
        Mon, 16 Sep 2019 21:30:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f66sm1276782wmg.2.2019.09.16.21.30.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 21:30:08 -0700 (PDT)
Message-ID: <5d806150.1c69fb81.8c720.5448@mx.google.com>
Date:   Mon, 16 Sep 2019 21:30:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.193-21-g2b9f5e7cd4e8
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 114 boots: 0 failed,
 105 passed with 9 offline (v4.9.193-21-g2b9f5e7cd4e8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 114 boots: 0 failed, 105 passed with 9 offline =
(v4.9.193-21-g2b9f5e7cd4e8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.193-21-g2b9f5e7cd4e8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.193-21-g2b9f5e7cd4e8/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.193-21-g2b9f5e7cd4e8
Git Commit: 2b9f5e7cd4e8f73a7ee95b5b6a877842e00ea94f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 57 unique boards, 22 SoC families, 14 builds out of 197

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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
