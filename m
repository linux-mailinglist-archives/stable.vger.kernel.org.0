Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F761238E2
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 22:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfLQVwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 16:52:23 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53012 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfLQVwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 16:52:23 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so13964wmc.2
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 13:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6FTOqGIOAousFms5mjOLZP7M+jP/moOysKGiGdxJ3FU=;
        b=G6kmQEgwPl9u2OmapDolsiqT9iy5ObOCpK4vsO5kvAzmbcdhgJKnwlmMbw8+fNxCBH
         dbqhPXTf8lY1ZanqBkgG3iFn6xulIfuZ7ZZy/Nb+LL+XeK97cTbOLy7I3BBybQhUFFUg
         fFrIoPGlOSBgNar8CTrroGb6xaiVWY2CCK7ALVMcCrSHM55xMDBgeGvHZsq1/QrQEqyd
         PwSbFNpF/e0/emMesoV6qsz/zD+O6PFzTV5eBDRN7aKqZCwXair2NER7Lcra4SVD2eay
         sSiEElB0ydnzW81N4Neggo3jZQ7ZeOqJurYBe2Vg2A3po23GaC/D2LElqxrCs1pLU4QF
         cf3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6FTOqGIOAousFms5mjOLZP7M+jP/moOysKGiGdxJ3FU=;
        b=OQQJoGswNs5rw6eGU4PRNSzxnE4e85G3kR3/VCidgjmsl5qRJFbcZkNop3bTW7lAQE
         PJL36ANID7wTN7Lkmtf9I502coqC6zIFIBvPBfQ9U5SgmetMNUsFw1g3HjNA9iNQ+B7F
         OAVzywFjRb2tN0qtu/ZC8AbA6Mb/RxxZU5P3PLpwcRvGmIDAT56eaHrBJ2bx6DRNve5A
         m19RTpQ+uwpYwyoQi+HfM//cOgDAftTdjdBHLQb9aFBv+zycIjWBmGzfoFSDaMR0izCD
         s3+N2xeCp5UlwPq1Roa/Dj1xdcHlF6lkWI3oBJOtUVzhq2Tf17Pk/8syROu4DkeRLIjz
         ArLw==
X-Gm-Message-State: APjAAAVxEkIKQFd65ilUldx3zWhfrnPZnFQSA2yoWFoxSeBtzusbs1ZV
        km+JR/yzEYCmX9TFBrfWsaWKILnlBD/SwQ==
X-Google-Smtp-Source: APXvYqxwj+X2GfbXFagU6fCiug64MXknjQr5mICDzC8e1RKWlLoPCgFQQP6vSXwDZRJSjPt3hZP7KA==
X-Received: by 2002:a1c:48c1:: with SMTP id v184mr8139968wma.5.1576619540937;
        Tue, 17 Dec 2019 13:52:20 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n3sm168456wmc.27.2019.12.17.13.52.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 13:52:20 -0800 (PST)
Message-ID: <5df94e14.1c69fb81.3d073.0d84@mx.google.com>
Date:   Tue, 17 Dec 2019 13:52:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.89-160-g5189dfa0aee0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 68 boots: 0 failed,
 67 passed with 1 untried/unknown (v4.19.89-160-g5189dfa0aee0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 68 boots: 0 failed, 67 passed with 1 untried/u=
nknown (v4.19.89-160-g5189dfa0aee0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.89-160-g5189dfa0aee0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.89-160-g5189dfa0aee0/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.89-160-g5189dfa0aee0
Git Commit: 5189dfa0aee003c614906a099d373ab911b84c0f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 12 SoC families, 11 builds out of 205

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.89-140-g9cc8b117=
a993)

---
For more info write to <info@kernelci.org>
