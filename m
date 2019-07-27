Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB6237756C
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 02:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbfG0Ach (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 20:32:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36154 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbfG0Acg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 20:32:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so56106832wrs.3
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 17:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p5nvPAk03or00LVNoKLhjsB3mVndeePjVcEKYezM+8Y=;
        b=iyWIkVwjvae9cFKkXVEde9usYKi8RuTkgHn+zoLh6h3zfDz+D60uYITHbICsKWBPUo
         FcNFYgi14U+Kln0hQQNzW2YhMqonK+wgYevH+yVqTTLsvkW1u1jyIQlhyBiTT/ASP1Dr
         juRxpZRUVyRCK2Sgj0pRPC43GdB5hP3P+/gGfK75vA0GOZWOHvXN8UuBcbvf8e6SAcp+
         0+bkZQXB9FOTt2mTlxE7Q6Ee7up0Wc0yPn+0Ge08o4rPabcKGLcWvSdOMENSs9/Sn9j9
         UtGbSUod/1nFKZ5iB1DkLnnqLKpYhkcLAZNdiQBaq80TnPrdwiUM4jnLgpN/WITFKYc6
         UfMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p5nvPAk03or00LVNoKLhjsB3mVndeePjVcEKYezM+8Y=;
        b=VjbCE6p6uUGphHMaZcCgSqJbTOqMz8VcBo1uNGva4LCQl1CsywwquPBJ/szP7keNxN
         5emxLThr/rxFtg/tHCK50mofzJIWc+WJgO7fuvXtdWJnT7+4XIdzZlXu2lUv87FeW1Uw
         ZxqLFfqBzIGM1MahK7cS8i6J/zJAPyYVSJccafumi3aDA21Cgi8gm24ZOb2UPAx9eNiX
         HYGC/DpuZt8QMTvdFUz/+kNQsw5J+uE+iF507sXlUqVFBpY/y+uDmom39wWywJRZtBhl
         K2cSm7t2sLfldnijtPQSZ6/fsxVirURbEjRGsgqKEH2RDZb/nVdxsrtLw9ID61PLzvhF
         wKpQ==
X-Gm-Message-State: APjAAAVpWAQPu/x+sInerBbbkt6OvD+AEsInV0IXMrHAIHyIpGbfijD0
        FwNLM5ul7/mIbHwxsbx2/uQTe+MOoGg=
X-Google-Smtp-Source: APXvYqzm0hnEsvRgGrGPwgQxYKOwxjaf/B6hsb8WleNgLVROnLlBTWMby/q+ICBcldCfM4GxuE7REg==
X-Received: by 2002:adf:f601:: with SMTP id t1mr7721974wrp.337.1564187554652;
        Fri, 26 Jul 2019 17:32:34 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f17sm49858258wmf.27.2019.07.26.17.32.33
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 17:32:34 -0700 (PDT)
Message-ID: <5d3b9ba2.1c69fb81.90047.5c9c@mx.google.com>
Date:   Fri, 26 Jul 2019 17:32:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.61
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 60 boots: 1 failed, 59 passed (v4.19.61)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 60 boots: 1 failed, 59 passed (v4.19.61)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.61/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.61/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.61
Git Commit: 7250956f6eafc6edf2ad9a1cccaffb7f16c7b38d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 33 unique boards, 17 SoC families, 11 builds out of 206

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

---
For more info write to <info@kernelci.org>
