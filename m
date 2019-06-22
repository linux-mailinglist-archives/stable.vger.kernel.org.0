Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F27F64F599
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 14:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfFVMI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 08:08:59 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:38249 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfFVMI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 08:08:59 -0400
Received: by mail-wr1-f46.google.com with SMTP id d18so9053126wrs.5
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 05:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7eGs/XxGpffMx11AutghmdgTELILy58aiQZoMWo8SzY=;
        b=e9a5I0wIWkcT/mNzbC11kggD8vK/UPY+dIK4XMuKB+tlLARYWUGM5kGXHDIbkJh5bK
         td4mFOlBFyDtzfK1fyj3Ed+dQIqZPTEaAEzBgxAwyl/GpcBNxOaz3G++DAWB1s93+aLH
         HuMmfVNgARNq3m0qbHK9ZDr9NhEdqnoZJybrdzQBMWy3xfZ/xIWT9EPTP2lj6yD6TfQn
         PrHZo3O71elW6uZOZxIzQ1KNecek7Tsl0deS6u/F9MPiXbcI+8/iOVcr63Aq3bHM9i/V
         fyxUWM6xfcNLz7l8LD27dT6fRmpI1XOzm7cxsut/h4m/AumPfrOfTkunXoPUDXsTiM0N
         vE/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7eGs/XxGpffMx11AutghmdgTELILy58aiQZoMWo8SzY=;
        b=j8L0V8XzWw6QlYTz8A9fCGRK5Hi0SdIBPTVSKTQUUIMdETufmgKxyjC+iJ/DPBp8DZ
         Kaw9HgAG38OMvMSR53XOQLGjDRC4FyHkEAq9y4ldz/tJPONEqJEk5qE1TpUwqYmaNy9z
         OcNu6FFd+oN9sQsjEhuAr8TSE6llZ+sRpBGImib5bekOJTbTt1Z5I9v8bKcayVWrKPAp
         DxIY2ZPfmoscn4O7jzN6k7PlhBL8nzavMeSWEkJ3z+u8DdrxfLRENCVXKjliGuey1mOP
         j5l3ERvqTLB2UsYbtUpVh2JvNCF6ZN96I+DZlvWvsFn50vsRkkqfElT8n5rbNFkbdJh4
         hURg==
X-Gm-Message-State: APjAAAU8KS687NNOc8cj7hC8tvtV0I2uxjyYI3obGin2zAzZlfj38w2V
        +EjfKiVz4oLVQ7NiFxp5w4+DRAEr8fianw==
X-Google-Smtp-Source: APXvYqzp3NTobYvGI5TIod0amRoHucQnJ1Qwlp14xl4414tUq6hHI0yixvd/FnZDtDjpG9AojUReAw==
X-Received: by 2002:a5d:4f8a:: with SMTP id d10mr18296375wru.13.1561205337011;
        Sat, 22 Jun 2019 05:08:57 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 5sm11244023wrc.76.2019.06.22.05.08.56
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 05:08:56 -0700 (PDT)
Message-ID: <5d0e1a58.1c69fb81.eef13.ed80@mx.google.com>
Date:   Sat, 22 Jun 2019 05:08:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.183
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.4.y boot: 55 boots: 1 failed,
 53 passed with 1 conflict (v4.4.183)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 55 boots: 1 failed, 53 passed with 1 conflict (v4.=
4.183)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.183/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.183/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.183
Git Commit: 30874325504004c57f7b4f7163cead251a91662a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 21 unique boards, 11 SoC families, 9 builds out of 190

Boot Regressions Detected:

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: failing since 10 days (last pass: v4.4.180 - fi=
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
