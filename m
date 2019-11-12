Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98B0CF8D07
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 11:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfKLKkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 05:40:47 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42782 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbfKLKkq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 05:40:46 -0500
Received: by mail-wr1-f68.google.com with SMTP id a15so17900031wrf.9
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 02:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yWNzXKlhZumCYXuzBsEx7JVt+rn1MlZov7MW7LBP6Z8=;
        b=oPxGYiR9G5nq8ImM6z19dmvMd/lrk2GstUTcAq4D4FUb+tl3S8r5MSaD0HcPPHE8v5
         wvfEWNC3tYox0MsF/o2Hx2QCxeyJSYVI9kgG6cV5Icf2ZCeGuvqmIhXShsSKeKTJucvp
         YF/PRCvQrHtTaFW4EfW/ZUKcck2JfqZyjTvq7pis8OTojTlKi/zBfNOSWDSSDIcsR2W2
         vQA2jj56PV9kZW+cSeWcJ6RAzXkM/FuB7A+8ixpc6BpWZvO3PYuDNEhZFtEPMCSSO7Y3
         szQ3a55bvvJ/TzuEJens40U2x9OlT4X4ob3w6ns3wwy1WrXHtPaT0r4ADq8Q8GjNI+nX
         8PLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yWNzXKlhZumCYXuzBsEx7JVt+rn1MlZov7MW7LBP6Z8=;
        b=dMQTDalQF5+jvn+Flp0x9qu0P9iSUD/Q+8aDgoDQs4BdUNhqitJ2dqz7aDPeD6Rap+
         jrr1usJfFssfApRDwCFawar+kjq3K776ifvXIhRgYZwRmWmlqJHlZ4rIrMrKCG+aCwSF
         xP5AUUvtL3iZUpLW3Vj99m1rX4oOFcnKgtu8vDzLprDAmYqfM9RNm3h+6gvRW+fcxoC2
         +dXX+Cy5zTX/JjCXeAvSR8BW9ojjarVjaHNNh6a8C9HrlbcFBP0GlzDQCxxBwptdQALv
         mUzL91svy4q7Y/ygQ1o5AJ5AO6I+lZ/m41nPWipPYH8RFXaLmthaQmHwlu1u6ntphEDV
         Zcfw==
X-Gm-Message-State: APjAAAVq2SRt7DZ0nphIAvG/tHj+N2BTcRBShpqv5ahfEK4NR0yHhCR/
        d1nIP6bKVNi5T4W5LYq0H0xizFnMlvp+2Q==
X-Google-Smtp-Source: APXvYqxZQ0Bbj7wBSSsWZ/8/DLDY8oC+Mi22wlwSWypY5dQcy6xIK1ZMDU2otELiP9/7ClXKEQjrsQ==
X-Received: by 2002:adf:fe81:: with SMTP id l1mr9879074wrr.207.1573555244361;
        Tue, 12 Nov 2019 02:40:44 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j67sm3200678wmb.43.2019.11.12.02.40.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 02:40:42 -0800 (PST)
Message-ID: <5dca8c2a.1c69fb81.43237.e2aa@mx.google.com>
Date:   Tue, 12 Nov 2019 02:40:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.200-43-gca1d1b5f0f2a
Subject: stable-rc/linux-4.4.y boot: 82 boots: 2 failed,
 73 passed with 7 offline (v4.4.200-43-gca1d1b5f0f2a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 82 boots: 2 failed, 73 passed with 7 offline (v=
4.4.200-43-gca1d1b5f0f2a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.200-43-gca1d1b5f0f2a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.200-43-gca1d1b5f0f2a/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.200-43-gca1d1b5f0f2a
Git Commit: ca1d1b5f0f2acd3d552c3c74f44d984d06f2d595
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 16 SoC families, 13 builds out of 190

Boot Failures Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 2 failed labs

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
