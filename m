Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCC6AE6A9C
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 03:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfJ1CBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 22:01:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33642 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbfJ1CBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 22:01:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id s1so8191310wro.0
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 19:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=38vfof48mbSMZzVEHVHHL6gvFaN/yZ0qq3phlAcJ00k=;
        b=Ii1eFuWMTYAXg4lYTRxdrBiItXtYDixUx8QcrS/N8s9OtxpF7tOhGdf69oBu4RZ547
         AZT1ZMspmpRZnwxAt04758MgnwvQ5klVrPAVPAtMGF3ufaXiPTygjaclYIIVAHcAxwAE
         +93EoEDRHWLkjOUMtSFCxf8xfBMkKbOEeFtD3AuLa8LMOqyI7iHHojYmg1CNmYLbrz0E
         VzCJp+VIaxDlg3WZMGOVZp8VUcGsktV5PEj99lsKP56B0lYeQphbASyMI8EML2i31g2R
         CxzYb9a/IyCfff+ygbt5wYYNa46Xm7rhR+DkX5JVtzYVnhzGjE/EJCDyzfVSmhsRS0x0
         yxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=38vfof48mbSMZzVEHVHHL6gvFaN/yZ0qq3phlAcJ00k=;
        b=PnQU1mgToUw/Ph1Sfwuc+tRGpJee1P+RPoEE7LU7Wi8IC9PNpzXoPRQTWUSdhAP2eD
         E6kAso+t6rx3cSW3r7EXWFTLB4IJZ9EACpgjgL9ZxfxW0sq0vjm+2T2IOpGaX76BoGCf
         vbePW5Cs0qxKtyW4EH9cwS7nuCmxbq3Q5ZGCQyfgovHwrLxvu2VkqIXUL20RpZxDa0pQ
         5fc9Oc9jtAevEu1Q8dL//fiQoUwjaPiOLMTXS4sClFlF8cMwtSrdXDxAfJ8QapjTcvGe
         lb0DRnPQ9Qijz3O91yPOdP2mIi4+s8SI558vPgPN632m7tUsZTf87sAXuvBODQlpiIfr
         erjA==
X-Gm-Message-State: APjAAAW/P62M0y4zjTRdLQgaXKmZiDPsWwF9NEWgapCGuqa1Cp7n0Py5
        OaBVwp50hbDyXGsLudMoyWmqXzMukAo=
X-Google-Smtp-Source: APXvYqx1VvnB1urMRDoqHneq3eAYfpZhL/e2xpsd3a3siYlLZpy4xjE/sUgJtJa1/GE5IHnH3gw1WQ==
X-Received: by 2002:a5d:5401:: with SMTP id g1mr13144996wrv.54.1572228076637;
        Sun, 27 Oct 2019 19:01:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r2sm11368322wma.1.2019.10.27.19.01.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 19:01:16 -0700 (PDT)
Message-ID: <5db64bec.1c69fb81.aad9e.9703@mx.google.com>
Date:   Sun, 27 Oct 2019 19:01:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.80-94-gb74869f752bf
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 126 boots: 0 failed,
 119 passed with 7 offline (v4.19.80-94-gb74869f752bf)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 126 boots: 0 failed, 119 passed with 7 offline=
 (v4.19.80-94-gb74869f752bf)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.80-94-gb74869f752bf/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.80-94-gb74869f752bf/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.80-94-gb74869f752bf
Git Commit: b74869f752bfa7ad50c55349ee2f0bbd61a45f0c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 23 SoC families, 15 builds out of 206

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
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
