Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A91EDBC63
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 07:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732200AbfJRFE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 01:04:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45491 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728559AbfJRFE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 01:04:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id r5so4672865wrm.12
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 22:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Edj87DtRdIx7bc7UIlO5ID6SyCr+Sf3PF1WjbP+0+AM=;
        b=RCFM5R04zBjk8495q8WRkhg2UNF5ed0lFe3l57nQINpVYZCPfqXqcvJOOUeei40s3s
         aos+s8pJ4udmWZoMTfyIJfLThGf5dVGUo0ka0fJBxcUN5sBeWSqkgzuG0SRGDemWa3Rh
         GKgC75pMBPbeUKKW9ETHAVL2E6NJZwdrkCNVlKaB247Y1PPVL+FPNlnPiOShQkSVtx02
         3kYMQlMHGfUBqlUQb3z2gxlYftkI2SFJ8GV5lb+kHn/H5zH6tnCk7Af4rbpUwEe/YW/U
         xomlBQ3uhNK9x/QEbm3OiGJCmNABps/6+hGkM6TfB9ikOXRzJUp59rRAZsOR/PqQl41j
         Gnmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Edj87DtRdIx7bc7UIlO5ID6SyCr+Sf3PF1WjbP+0+AM=;
        b=ovgM0K50C0ILoAVxzqEju1KB77FqV/SqzLtT6d9i3DcuJ4c24nms1DnybOqkPlEYTt
         A+jxf0jkmosMFlrpUzVmqgzzKPNckilpVvZxtM/WRkAAEOSGB7x1XgXlxOOiqwSrAXER
         x2GhsLAartQWtGv9S14qj0UEXob5aQBke4tKsLxye7+ki/oZwPprcXd1GI1CtWe3HiRL
         kd497sNCoUjuawxcKzknu0AeZnIJs7Q7Rta/32teAk3PaZ3PDKRCZ6CDSopOwAnKvgW0
         VArTE7fA2rQdzk4aLXM8RcCMluIm8kI02w1Z3o65jMXPg6UBE3vXJVzOaNmz/Yfv9rV2
         fPFg==
X-Gm-Message-State: APjAAAVdXbtQ4WAhgo+uCouwo8rRXm0M/LiJysQHnP0rbVrQ7aRim5D0
        a/VoQqedJAOXWx80LnZu329CHDJWo1A2Sw==
X-Google-Smtp-Source: APXvYqyFvjHmxpgX4kD0rXg+epEiYhj+xBY3YMGUQGQ1RDT2kvp709amt21QrwFGbH9gEY31sZuYcA==
X-Received: by 2002:adf:a497:: with SMTP id g23mr5685377wrb.135.1571375064403;
        Thu, 17 Oct 2019 22:04:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e9sm1672905wme.20.2019.10.17.22.04.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 22:04:23 -0700 (PDT)
Message-ID: <5da947d7.1c69fb81.90ffc.84b3@mx.google.com>
Date:   Thu, 17 Oct 2019 22:04:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.197
Subject: stable/linux-4.4.y boot: 33 boots: 1 failed, 32 passed (v4.4.197)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 33 boots: 1 failed, 32 passed (v4.4.197)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.197/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.197/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.197
Git Commit: 04858540ca8435e52654680dabfd769056ad9eb0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 20 unique boards, 10 SoC families, 8 builds out of 190

Boot Regressions Detected:

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.4.196)

Boot Failure Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

---
For more info write to <info@kernelci.org>
