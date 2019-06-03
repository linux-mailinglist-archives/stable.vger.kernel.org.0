Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6038B331BD
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 16:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfFCOKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 10:10:05 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:38462 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727645AbfFCOKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 10:10:04 -0400
Received: by mail-wr1-f47.google.com with SMTP id d18so12251292wrs.5
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 07:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fw5bP/GPaj1CKocbHz7I3pjKzv6yysRXh+YxAHJvwPU=;
        b=nmPEg7z1ekqrjEW8dv/oGqFAoBEPg1pTcMFMKA6iu2u1cEWG2tIOvSFWwz1+zR3dvv
         pP66ixpBmRmvhXicMhCpeS05xzmxzkQ699acAMKgO2cAe7q5WpHEFm95CYbEG5FCYNhA
         eL+2m3n3SyxH5HKMCzYcFHhTm261YiqaG+SiCv0MuqXlHT8Ex/FFEOgnGbgcTczLFs2U
         4KlN1gQqa9z67G43eWp23o/Hhic81YnfXGssXznXptNNO3O/B9w2V6YOIsBPrwntK/sn
         9ObhaETn/Cd2j6+nLcH3DhCPtJQOjZLwKYH2noLtnPKES11095QNB6ZPw947CLbA8atQ
         OGoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fw5bP/GPaj1CKocbHz7I3pjKzv6yysRXh+YxAHJvwPU=;
        b=bedY88oRGnM2M6rau29R9ou6IAYF+P5/sMAG7R1u2CfqIgkg0lvcjWi0BbIkYwDK+H
         OfVpRO+Gj7gieTEmZLdQO5tx7daiwUOt3excIiaJP3Dz4LkbcX7HELn0akXYY/XvS2ji
         tksYCL4w+wLMjHFFULyMGl5s9EoYX1SBG4HZ588q/Dy30onnn4jCADFABoDkQ4lnAwKC
         wFcrv7AULyGAcY5kIVmQBAVMfTNy4X8U5wgz1b9l+uGQG0IxnAsUlesPDdLb5/v7h3H4
         tdTnSClBW+Zm/wkihXigElmwU8UV9IcwEA3MFcKNP6rz6ZFrzPJsxHjLCeD9uOEY1Inh
         CaAA==
X-Gm-Message-State: APjAAAX2GlhxDNbONFLvGqh5gzek5nrAZ2Gb/djyShblB9gh8aQfr7Y9
        Hrhy0/7IetSRjGgk7Ixo5R92IDiOp/E=
X-Google-Smtp-Source: APXvYqwDqrz3yv/pus0Q3+ZhY1GzOD5OtnAZO0+F7BosGlw0B2Eb8gDs1hWQ3DnjZrPCYpigl3JFKg==
X-Received: by 2002:adf:f84f:: with SMTP id d15mr16363369wrq.53.1559571003208;
        Mon, 03 Jun 2019 07:10:03 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b69sm11047901wme.44.2019.06.03.07.10.02
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 07:10:02 -0700 (PDT)
Message-ID: <5cf52a3a.1c69fb81.eaf58.baef@mx.google.com>
Date:   Mon, 03 Jun 2019 07:10:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.0.20-35-g53cdc9986572
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.0.y boot: 65 boots: 0 failed,
 63 passed with 2 untried/unknown (v5.0.20-35-g53cdc9986572)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 65 boots: 0 failed, 63 passed with 2 untried/un=
known (v5.0.20-35-g53cdc9986572)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.20-35-g53cdc9986572/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.20-35-g53cdc9986572/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.20-35-g53cdc9986572
Git Commit: 53cdc9986572e3c9aa92e98ce33ec3f3f87c7b46
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 16 SoC families, 11 builds out of 208

---
For more info write to <info@kernelci.org>
