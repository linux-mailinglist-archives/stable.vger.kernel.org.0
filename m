Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382AE1A606
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 03:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbfEKBBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 21:01:45 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:42087 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbfEKBBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 21:01:45 -0400
Received: by mail-wr1-f52.google.com with SMTP id l2so9562594wrb.9
        for <stable@vger.kernel.org>; Fri, 10 May 2019 18:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=phQqSTo62RdlAseMOSjMj11+HTamzES3ozXGZlyE/5s=;
        b=um6AjAHMswv1CGVvAjIlneWpVcKSdHnLUCJ7+EXZSp5arWRIIIDGqE+XYNUxrulROO
         glAwGFSUTsS0PbCTmUxBHNA0cDRLhKKpHRjat71olB1ZOTX55sE32pr3V1YbRjISPTqN
         iuA3EqtNXsagKsO+edlaR4u1WxaGXy8oDdSyK06pqd7YXswgGqe8Xgdj4/b6r5O6a8wG
         8yUXcdR8pzdZupfxO0/ew4Os0SBAKPwqdRjMdMbLraQw0F8yySlYXJotvAa52oRPjAek
         q1YTVIJc6Z6TycdTQNUm555vTWTOl+Rnu/45a7va/AdTKs7KMy/CveesQptBN8Psan6K
         Dn1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=phQqSTo62RdlAseMOSjMj11+HTamzES3ozXGZlyE/5s=;
        b=I84xFxai8Em5lxC7NDMRT6WnLAPqfO067ispGnGlsL1g7Ds/S5wJlzce3ZdH0RjNPV
         hUrl64kvI+AXP1klBxvQ4iq8bdoHA0bM6guyemXxo9FnnFtWsWTj1lNAYw/z8EOfgqkV
         JmFduzniJintZlEmFjiY2AzgS9QbPLNtGkei+BVzMRIOcyO6DMTFq8s4kc60YB/WDSSJ
         rgFIo9P5H82ooxkr2ct6VbIhmkAR7YBFKnVhYPODSD0mfqy4jhUwpZYsVlEQBDKAj3zO
         uXd5jePctbT6kgXltGy8GfbYtZxX68NjrwfRZAlZd5c5TmCGbtyFQRSH/XgLAEf1ZZBw
         pmdA==
X-Gm-Message-State: APjAAAUEMa4WX3tPPIRkC1aseQBVJY2go5pUHDluxDN9cavJ5mY53Vry
        ZwM9os9/JotEnAscBhFCM72ihE3mh4QK+g==
X-Google-Smtp-Source: APXvYqyNs1Kk4mxvcwhBK5gwSKs1NLsPAcM2bEZFRQ/Q0Gjpm0t7niq3sg3wpoDdS0FvmlRHooYLBw==
X-Received: by 2002:a5d:68d2:: with SMTP id p18mr3868428wrw.56.1557536503555;
        Fri, 10 May 2019 18:01:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k206sm14535695wmk.16.2019.05.10.18.01.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 18:01:42 -0700 (PDT)
Message-ID: <5cd61ef6.1c69fb81.24285.c923@mx.google.com>
Date:   Fri, 10 May 2019 18:01:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.42
Subject: stable/linux-4.19.y boot: 67 boots: 1 failed,
 65 passed with 1 untried/unknown (v4.19.42)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 67 boots: 1 failed, 65 passed with 1 untried/unkn=
own (v4.19.42)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.42/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.42/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.42
Git Commit: 9c2556f428cfdbf9a18f4452c510aba93d224c8b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 36 unique boards, 16 SoC families, 11 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.19.41)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
