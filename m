Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF0C257BB0
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 08:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbfF0GAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 02:00:18 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38077 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfF0GAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 02:00:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id d18so987124wrs.5
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 23:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gmrlYM3jE+VrIxZcLlfIIVt64mO4bMFfwqxIRRispzM=;
        b=RazhI6og1PXKl2PPN+iV8rzogZI5aHEoDdLpbek21ZSCdV54MSl+kODA8D3ZnG3Uz7
         IlKR5bhmYhuU6rXGXFHfw6DMLZdV6GazplQwUQ3Nx5fytcMJgZTMSNT7REGGWl0wNcUD
         Ou2KmDMHkVL0l8tKbSsWxCG/f8cDS4aON1Zc31FQLUYiFjx3/OzSFw+3JBHgVWh9EXFu
         9vfwqd77DYnvTzb185AhjhPM3Gy+ohP20R7EoWjb02Frrzy8eXz1QZIXZXDPtkBFS5CN
         1q7OLrJQijCW/R+YkKlMxL19xFmPp1rMj7w6Xjkpf9IsdfzeMQr+7d34SdLbLkx4jYO4
         ZPOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gmrlYM3jE+VrIxZcLlfIIVt64mO4bMFfwqxIRRispzM=;
        b=nADg5AfVkM1MgblaUhq4BL/5jq0HW+tBzzPfVVhe83C3Vd3Rm3uruv3KSbOEnRHFxT
         ND3tAwmMGCPZ61gIbh5rLbbVzVllK21rkY5/vruBTBU6q+XXQNVuccTVZUCXwICaNeQe
         dVKRQmCBAq7/lD5ti2O9cZivMAgeZaiH5TLLQCiJRwmekRnNXTBBfCsg7M73bBSCLHzf
         ZVR2UynLbigWhAM8O+4yaj7cxHbf2hqpni7Qjce8T5pJ5KlEypwpzpSPQGt1tpn36JT/
         BTmz2cmCZnfWbha1jiW/dBkm/E0OzAHS/gjr1RucQlGY8iwieeitM/yDPOBRs0ZCeUvz
         B+dg==
X-Gm-Message-State: APjAAAVUN38q/GVQ/jfpjt3Wej5hSC1WEf1ZtFwNhFa3g6FFihOucAHt
        f3M9oCnapdKHW+0szkUAgx++sV/0Q8IYrw==
X-Google-Smtp-Source: APXvYqzskbsEieOhPIyiQD0obu6YTEkFmOlxy83Wm1fGwzTL99TRxovAfXGeGxXsxmKEuJL5TkgZoA==
X-Received: by 2002:adf:e442:: with SMTP id t2mr1477610wrm.286.1561615216725;
        Wed, 26 Jun 2019 23:00:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z126sm5992354wmb.32.2019.06.26.23.00.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 23:00:16 -0700 (PDT)
Message-ID: <5d145b70.1c69fb81.91bf9.04f6@mx.google.com>
Date:   Wed, 26 Jun 2019 23:00:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.184
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.4.y boot: 50 boots: 1 failed,
 48 passed with 1 conflict (v4.4.184)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 50 boots: 1 failed, 48 passed with 1 conflict (v4.=
4.184)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.184/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.184/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.184
Git Commit: 72d1ee93e9311c88809585a114c138bc6a43627a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 20 unique boards, 11 SoC families, 9 builds out of 190

Boot Regressions Detected:

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: failing since 15 days (last pass: v4.4.180 - fi=
rst fail: v4.4.181)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
