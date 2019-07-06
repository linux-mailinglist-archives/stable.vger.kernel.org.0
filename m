Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D0A61045
	for <lists+stable@lfdr.de>; Sat,  6 Jul 2019 13:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfGFLHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jul 2019 07:07:32 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:36857 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbfGFLHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Jul 2019 07:07:32 -0400
Received: by mail-wr1-f54.google.com with SMTP id n4so12294314wrs.3
        for <stable@vger.kernel.org>; Sat, 06 Jul 2019 04:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ixr95u5jNxpBOhcMeaIEhPvLK1kIRm692DSdVR2fB8o=;
        b=YYEI+iUxS8IG3QPQrt1njMRjLD3HTQzQvN9sKNv3cjW0m6A0ch5+PsHa1n8K+pNxwf
         JuDvJ5SW3y5wwo3XxXCQU8RVSmYJbws6/yesCp8r40Lfp1CSj45yF+0/qbjMKqhCdSIv
         A++Y2Ksa5shd+3If4++2twyPcjucXqr3tzG4XiWUbP8BqbOb56T9gv07vmNEsBPt9E4r
         jv8j8l7ea4nMUSiyX8uWOctc/1SeqGsG+5RG9Bal7X4/SKSrLi2m61ohySdeHA1KZMXM
         nsEq2N15ahMgkAWAKuu4c3D+yw84wf3w/H+9u1ds7teL9hk+ISqPT4T+i4WVQua+C85a
         mVkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ixr95u5jNxpBOhcMeaIEhPvLK1kIRm692DSdVR2fB8o=;
        b=YuTRS3ThD4D1eOH4Za5LzYS6zU1WxlryRsQcC0wBjFEMZhf9aSsHux6xFk72WtNcDv
         A7d4kXgUHtz9sobzLCN+jQLH2tAoino+OjJmE0I6ar640Sv0u1G3hOLbCCyUzSCdK+TO
         /vkYOYzwzXNO8OOvYdbYGII055jYhRcHgzH+dChlfJSVdxvy2oHhuRqKIEsPIh6rHOvQ
         1ZrTvlTTXYdoNHToc9FEUhFMuMZlv9iPP5A3ZqnMRouyD8rIYDjuvpnwnieJBzJloFP1
         BDSU2Y6Yx0VREUHP1R60ytQdT1Ay9sYqfdEgDlKEUZBf0u1S1P+d5bxPIza5oFS1FIZJ
         Xh3g==
X-Gm-Message-State: APjAAAVMAYrarUS+FsGe5XNAtUT0rGuDFVf4fugsTJiYLs9jylwveOcH
        vKVThr4gOWz1LIWsy6aSyHgEq+qhSN4+PA==
X-Google-Smtp-Source: APXvYqzXVESHvJyvgoB3tUiCTTGsLu2Y0tj29ZjN5rYxlHpSqs+aUS4UIUFlyajSPuJeW8GibPZ/CA==
X-Received: by 2002:adf:e803:: with SMTP id o3mr8883744wrm.69.1562411249805;
        Sat, 06 Jul 2019 04:07:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h19sm26901553wrb.81.2019.07.06.04.07.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 04:07:29 -0700 (PDT)
Message-ID: <5d2080f1.1c69fb81.fb5b0.750d@mx.google.com>
Date:   Sat, 06 Jul 2019 04:07:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.184-100-ga04bcbcf4f5e
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 110 boots: 2 failed,
 108 passed (v4.9.184-100-ga04bcbcf4f5e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 110 boots: 2 failed, 108 passed (v4.9.184-100-g=
a04bcbcf4f5e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.184-100-ga04bcbcf4f5e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.184-100-ga04bcbcf4f5e/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.184-100-ga04bcbcf4f5e
Git Commit: a04bcbcf4f5e60f955eff8266693d9042186a3a6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 23 SoC families, 15 builds out of 197

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
