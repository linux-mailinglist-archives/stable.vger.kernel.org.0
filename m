Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642C5D4BBE
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 03:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfJLBRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 21:17:18 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39746 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbfJLBRS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 21:17:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id r3so13687511wrj.6
        for <stable@vger.kernel.org>; Fri, 11 Oct 2019 18:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZANAQlO2/x6nsydQD4t42egzzhe7vfAAFxBXQ+GHT7c=;
        b=1Uog+ZHMNWscBvxIY0dNgTagdw6lCvaHwJOofmGW0fMOzf/0VD+qAcsTGfA4G6mdmw
         eCk5u0Kb4+Ugm+nfizIzAxnB/n9Dcndi6aC56kOCu7kHKQ6xBRABS10aeXK+ae9C7R3c
         1/8VdiByhRMlWfPsxVgFCbzPQUius4FwqOVJAS0AH/AQJ8xKYCFc8CRkTtXkwkPx3Ngb
         7KQnnfEyXx/5Gr2LA1avpHTYyuP1ifxST4BWcWizcXMFGATFwriQD1vgqk5GkD7WdDKZ
         QsAgZZ7czRvjGeOnIWDzWoAd3VKHM7mDdQO0CDEaMWw0vZjt6MXJysuryKPVDBYi5MzF
         5wqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZANAQlO2/x6nsydQD4t42egzzhe7vfAAFxBXQ+GHT7c=;
        b=AfQB2Y0FVM/TMpKo0mtBySB+Sr39aWuXyiDFl1ZdB3qWwFOE+u4zXXxW+gBXzKDThq
         nvZG0QqaNzHhWKSGkOnuGIxypFPd595v8V1kmR8PMp9q84gAbL1IR9tpDZaA4oJrFLi6
         i2Y2coKUR1jpPEGj2KP0iQd5+qpSO9rczDVtp6bxx1o8AsUhFrMGJgEJpbFFIW0o0jvG
         lfoElSNqRjA0xHWoYxflVMVO5tc7uvYoGMh3zCBEumlOHJ1uhp8Itny7PAkOTX0lkZeN
         rDgFGLiA7Fqb90S8Jbe765DKwPXrkDYhhQ98HNspCfiIe9Ybbo0RYGD4ouc7QU0iOcFf
         giig==
X-Gm-Message-State: APjAAAVESsK7+L21iJUJtow7It/22JUqKHFmrdDW2fZY6TblkuaHumCf
        F9eHlDGNasxDqdDPCn+2MzbYGGCc4eVGrA==
X-Google-Smtp-Source: APXvYqx9+trPTPYsiv2npd4rlaYW0/XS2IqIZaiF+At1F1QIPXQ6SWcENQ3a4lWzR8xcRQmTku7SKQ==
X-Received: by 2002:adf:fe42:: with SMTP id m2mr15118586wrs.321.1570843034944;
        Fri, 11 Oct 2019 18:17:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o9sm17827835wrh.46.2019.10.11.18.17.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 18:17:14 -0700 (PDT)
Message-ID: <5da1299a.1c69fb81.cd934.770e@mx.google.com>
Date:   Fri, 11 Oct 2019 18:17:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.6
Subject: stable/linux-5.3.y boot: 83 boots: 3 failed, 80 passed (v5.3.6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 83 boots: 3 failed, 80 passed (v5.3.6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.6/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.6/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.6
Git Commit: a2fc8ee6676067f27d2f5c6e4d512adff3d9938c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 58 unique boards, 18 SoC families, 13 builds out of 208

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          hip07-d05:
              lab-collabora: new failure (last pass: v5.3.5)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            apq8096-db820c: 1 failed lab
            hip07-d05: 1 failed lab
            sun50i-h6-orangepi-one-plus: 1 failed lab

---
For more info write to <info@kernelci.org>
