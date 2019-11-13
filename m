Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12110FABB7
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 09:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfKMIFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 03:05:49 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]:42570 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfKMIFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 03:05:49 -0500
Received: by mail-wr1-f45.google.com with SMTP id a15so1170113wrf.9
        for <stable@vger.kernel.org>; Wed, 13 Nov 2019 00:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OB2WE++pG6+uxorsmiwQmRHESEGIF8p+pQV79eHXVbM=;
        b=1zg02gQe0Ksx7PSRElZxJCaoZVqnhqdRoUDjpPD4DwfXal70hQA1nsQdJGD0fPhiIL
         JAD/8/xCRw5h1rlvZRk8v3XgEUVYMshi9EnXelcSMVJZYC0dUmWVrLSu1XMIwGrf8FGv
         x2kcX5lWPPUA8SSkeum2V91M7I6SQsOpOflxFu7arrrnS2RH0NIr7+KQtwFtUXOUOXmr
         RueD5okIsn31DgamCfh1p3myZfmfKDaA2R6xVKy0kKThcPNwwS2gx+AZA9Et7EaM/APE
         hAcjaPm1weNHaPUHy27OvRtXZgQ3qWlNlVKNwAghpiJuymWl/vDvvQkaa8nJSTqALdVi
         EkKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OB2WE++pG6+uxorsmiwQmRHESEGIF8p+pQV79eHXVbM=;
        b=O/36Ptj0/lNqLiYPaniIB5HaKwR0SEYOVDPYuBe8DjQXc1K03sy88egO709vxFYyy/
         6liQEvYekL4lsYj7ICVmqE2Q3coly2NUIF3WB6aswrGr9OoeFqfD1Qtl1c1nIjymvYS8
         5u2z3V/94T9BRs8q+MNlz7inagkIz4nu+/BX03GDOpS76xGVAu68XT84zB0h280mlPwx
         UjMTEd4IW1pTwyFuvCgELt9PLxcqi3qssZDDveW40GKi0x0jNPq9U8eV10ZvBFGr1Ek6
         SUV8rmdkLhgEnGRDrdSLJim8OUfajrGCNuyGhr1mhGZzcqHUtmAQTfvg1nVPj+2fVD5G
         GlHg==
X-Gm-Message-State: APjAAAUay2MnIWjthF+cX83X8MP7a0ysHe2zN928hj5TpKoX32T1fwgy
        f7EZoxHm0rko3yCHifd/yDzmHmnffP7cJg==
X-Google-Smtp-Source: APXvYqzsLTKGGa2lWw0r3VNlwUrIfdqjL73hJW7e8aZygaE/OttBCn3l3kARTeZ8+gRCNg0JuLmVIg==
X-Received: by 2002:adf:f10d:: with SMTP id r13mr1376001wro.173.1573632347401;
        Wed, 13 Nov 2019 00:05:47 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j7sm2029380wro.54.2019.11.13.00.05.46
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 00:05:46 -0800 (PST)
Message-ID: <5dcbb95a.1c69fb81.31832.870a@mx.google.com>
Date:   Wed, 13 Nov 2019 00:05:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.11
Subject: stable-rc/linux-5.3.y boot: 127 boots: 0 failed,
 119 passed with 7 offline, 1 untried/unknown (v5.3.11)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 127 boots: 0 failed, 119 passed with 7 offline,=
 1 untried/unknown (v5.3.11)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.11/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.11/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.11
Git Commit: dada86c5aaa8f2305bf8a8bf9014b60603f9f013
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 23 SoC families, 16 builds out of 208

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
