Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6771AC44B
	for <lists+stable@lfdr.de>; Sat,  7 Sep 2019 05:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389089AbfIGD5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 23:57:45 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:50444 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388510AbfIGD5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 23:57:45 -0400
Received: by mail-wm1-f53.google.com with SMTP id c10so8373678wmc.0
        for <stable@vger.kernel.org>; Fri, 06 Sep 2019 20:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ixs7eVnFU65MxOvPB8Xerz6PO0dPjXQx8/x6i+KTazA=;
        b=O9TusLkCPaxBfzlBPTmgdtW3b1RrCd8lv5XtBiQnE0KyqOc/cez87mHr1CX4wB4s0L
         4VjHjqhCeRST25wE4uwEiD+GF+VgIeAjswzHG1bHM6I1lVVSHRfoCiDGi6nOedELn+EA
         n3twN6qYiesBIA9Jh19Qiv6h2HMHMD7HtQ5tsrrPX3MQCNtg3sPXEQwbWNM3Dy7ogf5a
         DoM+XBLkubkBY8Wc43XX0lj3bAR0oGLdMDg1K9e8fnDf473p/EfrK3dM7lLa99zn0ckq
         p4seQef0nZGLi1xvve0UcV4O1+nGlAopI8DuqBMNESLXWNJt/38G6metLh9N1maI6BQN
         6+GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ixs7eVnFU65MxOvPB8Xerz6PO0dPjXQx8/x6i+KTazA=;
        b=ZJqYb9/V9iMLekUHEJmy/3xsb4jJK9s2EJ1/SDdqYu9vfyZhB8Ac5oVfttDZHtLL9m
         l67tV1vuiMifx0aVn1vnK2MrETuzTelLdHTmPiazE6y/QJB/7zO302Qn1ubrLcTQ9VCl
         D31Yrlj3mFWIS09g5e98lVecgXL8D9z7T7lyLgtWxs8fOCQdOPfKSsqCnt7lciOCTi7/
         ntEl3NKkY5czxUxrVP4QRJ157Q6R+IDNxAxtaAzfb07K8tAzMPACuwTrlSd2p5h9oovw
         At4ytf5B+NzZk4Qg67evwpOUSHMJQmYcPrxXEQRzh1uPdvmqgWcl27rkj4MG43ilE/N3
         2EOQ==
X-Gm-Message-State: APjAAAXBj4iQFOtw5p86HKSVUUtLNsbDq/Q91lJRkmLU7TLb/if43DMa
        nSUpSD9Ml4EVQo1V0sS6rVWf4mi9p3L24w==
X-Google-Smtp-Source: APXvYqzItW2beL2xcm3xfnj3EDQTxqKlBoZRpPDJsyaOxTdd+XGy3upaSvcPvVo0uNLlxJjBwMSL1A==
X-Received: by 2002:a1c:1dd4:: with SMTP id d203mr10170560wmd.45.1567828663219;
        Fri, 06 Sep 2019 20:57:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w8sm13754452wmc.1.2019.09.06.20.57.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 20:57:42 -0700 (PDT)
Message-ID: <5d732ab6.1c69fb81.6ce59.4fc3@mx.google.com>
Date:   Fri, 06 Sep 2019 20:57:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.13
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable/linux-5.2.y boot: 99 boots: 2 failed, 97 passed (v5.2.13)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 99 boots: 2 failed, 97 passed (v5.2.13)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.13/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.13/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.13
Git Commit: 218ca2e5affedf0f98e371a15aa56574a18109f1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 55 unique boards, 18 SoC families, 13 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v5.2.12)
          meson-gxm-khadas-vim2:
              lab-baylibre: new failure (last pass: v5.2.12)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab
            meson-gxm-khadas-vim2: 1 failed lab

---
For more info write to <info@kernelci.org>
