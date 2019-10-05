Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35FD9CCB17
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 18:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfJEQ1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 12:27:45 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50499 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfJEQ1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 12:27:45 -0400
Received: by mail-wm1-f65.google.com with SMTP id 5so8583457wmg.0
        for <stable@vger.kernel.org>; Sat, 05 Oct 2019 09:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BlgwBREJEVLXBDZipmYjXE1d36+g/kHjJCU/6cfj0Ag=;
        b=AveaVogoORj2AtXFzqVOT2RBvDqV78Zpxj2BChW8y4aHcRWzgnkCsAz6oqbyRVjKaH
         EsJLYfjRW9AdQRj7AGe/K/FeyL+R/cVFpMkCJ9aCQdLt9V4x8wLVmYVtrvjuaEfYyTLT
         QVgFe1D22eFlG4Qey5PoUHqEPIp6uQI9XYyIjxCJJ7nUEz96mo5etJJXjbUhmf/qJ9xZ
         ZGmyCOo8uIRtqSGHB/z+QCp+O+VF6es1Y9CfXHhChSvMjClso6D1IHsAzGqFe9zDUgMc
         GuI60aT4NR4KFJxpZsIvGzqb1qlMXdinSoMZlhUBZygNU7isjW4SStkP/vuerLny+ocV
         0QpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BlgwBREJEVLXBDZipmYjXE1d36+g/kHjJCU/6cfj0Ag=;
        b=fN4tKa+rIwLAvDm4pHr1P94CVOfINlbdDGHpSY9g4EtHC6hmg5cf6wuglF4KHDu2vh
         QVeldZTSbvl0AD8YrwOYU6QyDjhZv697dizfIUB93ZFoYXFaEX+Ri3mmWSbE9YCW1ZOq
         J0/kcODbCYHKUwp/3IXJbuwxhlc5OotEhuytY5lMXfMXCwG5loV0eWSOTaxVVoRlqhYL
         84RMx1JAjYyBATfwXjt4WNHuZpj2m95CYG+XR4EfHCWNqZ3ELnVCkCVWCi+Ft7t8WvMw
         hf1gIJuY5XW0EULV61nbhkNghmSV+27xqUitnH8nAMB8FlaGBYuBP0UKpupWP4gTPqjt
         YpoQ==
X-Gm-Message-State: APjAAAWmqIMphRef9vou8Lptg15snzAElPUFEszkw6PuRHioj+BN9PDF
        MFHgLWAoTkwIWxI6GyhSQla3++bmTqA=
X-Google-Smtp-Source: APXvYqxJ5b0GL1YQAsJH6WGDJx4Tbz+6LSlX3K7BqnVCfh4kZCJ7XgP1gPSehqTB15inB53pUWp14w==
X-Received: by 2002:a1c:7ed7:: with SMTP id z206mr15761124wmc.124.1570292862858;
        Sat, 05 Oct 2019 09:27:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o4sm12604596wre.91.2019.10.05.09.27.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 09:27:42 -0700 (PDT)
Message-ID: <5d98c47e.1c69fb81.cf4b6.4c28@mx.google.com>
Date:   Sat, 05 Oct 2019 09:27:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.2.19
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.2.y
Subject: stable/linux-5.2.y boot: 67 boots: 1 failed, 66 passed (v5.2.19)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 67 boots: 1 failed, 66 passed (v5.2.19)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.19/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.19/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.19
Git Commit: 076d9f965e561de3557c0cf9263b157b1c7380b9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 48 unique boards, 17 SoC families, 13 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          apq8096-db820c:
              lab-bjorn: new failure (last pass: v5.2.18)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            apq8096-db820c: 1 failed lab

---
For more info write to <info@kernelci.org>
