Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E919E8BBE
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 16:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389858AbfJ2PYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 11:24:38 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43902 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389695AbfJ2PYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 11:24:38 -0400
Received: by mail-wr1-f67.google.com with SMTP id n1so6649288wra.10
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 08:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+9ayP7yV3KvvihMVoA0Lx+j+7pm+dEwg1tGTOpHlVvI=;
        b=u+oTVWmz3BTj0Lek4wofN3i5hCWJTCmgLQLkSOsQwaazuvbL5k+idt2ZRgO9LtXltD
         FlL+JzOS7NhHfTeP7ptRnm7B4AOgHO9YPAYvJJ7Oz4gvkni6eNJWbOP6QT847A+8nOsX
         TROpyMJT20vPmIKxCBu6v0cJ7cU7axSH90FRomcIpp6vFN5IYHdYbgnSjS32lf0FtnRH
         91xNsEKrKYRhn17LknskpwMj46eOsFjTGJ/ux+2epeo1S4iPLrHBbneSDVqDq2FY9lHz
         XlO1gemmEnybYpZtw0c6z8OA0lOGmz65fqlfITMS5h2o9xguiCC/H91Nh+DuLZttpiU0
         Uu4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+9ayP7yV3KvvihMVoA0Lx+j+7pm+dEwg1tGTOpHlVvI=;
        b=BnFrnI53NSp3FL/61RwkIZjHznmXoECw4Q1T2OQ+1l8obJzpcJz9Cdk50674WGolLa
         0s7W0vrmM3ymwrhndsePUnf+pdxDEKQbaJMAtxBNnicZKdt2FrSnPmbmcVOE3upjLvgX
         Mj9Xhyna6Qt0qH7ICZAnVOoMCaEHk6vMT575MXKplYxpV/mumDmhmSq3ZdXvd6gGjE1Y
         1q9C3AkI2dEujzsrhCrmXckL397pEnT6v9+ex5oNZknZQY6NiZNQzfD9/r/dHXCJFpM2
         sUwrD2d0hZBKix5zzYNac1CmlMgrTvojg7Ib/RdWFixIK/9ttyJWsspEv+cTq+jdTyhu
         afTA==
X-Gm-Message-State: APjAAAXj8kUY09ZS7hVYVD8XYHKUeyCbCNziFTUartgmm+SnPR7cmG/G
        NlQ/NI6spTOMSM893Ljyi3Y5Ht8ncGPW+g==
X-Google-Smtp-Source: APXvYqyITEbqAVR1jehRh2wPoTI0EtNpNTsEF201r2pLEN8Q8bIeFZiJ9KC8Sv7xuMwJmO8Q3OD/qA==
X-Received: by 2002:adf:9185:: with SMTP id 5mr21541870wri.389.1572362676271;
        Tue, 29 Oct 2019 08:24:36 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q14sm18692975wre.27.2019.10.29.08.24.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 08:24:35 -0700 (PDT)
Message-ID: <5db859b3.1c69fb81.12fd9.f272@mx.google.com>
Date:   Tue, 29 Oct 2019 08:24:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.3.8
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.3.y boot: 55 boots: 1 failed, 54 passed (v5.3.8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 55 boots: 1 failed, 54 passed (v5.3.8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.8/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.8/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.8
Git Commit: db0655e705be645ad673b0a70160921e088517c0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 43 unique boards, 14 SoC families, 11 builds out of 208

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            apq8096-db820c: 1 failed lab

---
For more info write to <info@kernelci.org>
