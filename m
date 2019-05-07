Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E769D16D31
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 23:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbfEGV1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 17:27:36 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:38630 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbfEGV1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 17:27:36 -0400
Received: by mail-wr1-f45.google.com with SMTP id v11so4128201wru.5
        for <stable@vger.kernel.org>; Tue, 07 May 2019 14:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pHJwkeyCVuXqYh/3I/Ii1kdUSBZJVbcGpMiozIqBCa8=;
        b=DwI7sGYMhBce8sLPSfSXB7YipUcpPdbE5q2w+kfemTb55RBwF6CiFKhNDJyQrf0Wpx
         j+xeDZZDuiPtUsjr56FEbt74CZYBpwoc5//VGBLmLHEJmfl+8lL64bC8d6jhPUjrzBhh
         zahJHI0YwTX+TuOaMgSgncIL/o/5CAyMInF/p7RTbDzM7Te1mNx2NLhZqTnJSoD4glSw
         ZNWK26FdXrY7twMrSLVbtmFt0UQig3sMaR4rNTqYgmxna9EiZdE+rCkYDfg9nEKaXfXB
         R3PkaNJvX8L8/BiW5mzR1USfnGuCE6I/d1U8Gp0w2UeZFvqBri6QHBTEbEsEbVbNl2z4
         6L3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pHJwkeyCVuXqYh/3I/Ii1kdUSBZJVbcGpMiozIqBCa8=;
        b=mMkUzE+IbJgZaXc4cDYFXR3JolRgrHjd4KNAGcybXAtNqVCMInJZTdYTHpRdhjMe8V
         d8/UfQKvucvhHUDiCLTrkEjff/boqeC5NCTEfP5bRMHiCEZP3gFmELFQHujmavA/WJBz
         AQ2g/CzrkZU/qlu/Bpo+AJjeYeZe72C+mwTzRU0n5BJJzR1suF6cU4xcocb31OfI5Zsb
         m0DjxQYXHHbSh6n9/6ecR0Tq/2HuitdawshnVemP4VmCgtYjkau7lAvtyySBIleomPRc
         X3ymcybHENYap3GRZ9hzeRCzhRnH1sues60ienYh6AUULX5OFgnBA+/ddR2BtHlz482p
         2chw==
X-Gm-Message-State: APjAAAWoB1l/xey/BGXGl+Vl9+ard8sXxhfz8ILyvRsqc6w3XtKD7l4z
        5eJromV1X8SRA4ms3tMMH6qL5t6ITpVBHA==
X-Google-Smtp-Source: APXvYqzUO5mwziq4yjGqMXVAKbdppJjVBLQrhjMT8uXzQNKomMnc0J8bYFF6/keJ0S+WJ8E9fc27xw==
X-Received: by 2002:adf:e6ce:: with SMTP id y14mr1085581wrm.217.1557264454417;
        Tue, 07 May 2019 14:27:34 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a20sm32741054wrf.37.2019.05.07.14.27.33
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 14:27:33 -0700 (PDT)
Message-ID: <5cd1f845.1c69fb81.fcf99.cd4f@mx.google.com>
Date:   Tue, 07 May 2019 14:27:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.179-143-gc4db218e9451
Subject: stable-rc/linux-4.4.y boot: 45 boots: 1 failed,
 43 passed with 1 conflict (v4.4.179-143-gc4db218e9451)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 45 boots: 1 failed, 43 passed with 1 conflict (=
v4.4.179-143-gc4db218e9451)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.179-143-gc4db218e9451/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.179-143-gc4db218e9451/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.179-143-gc4db218e9451
Git Commit: c4db218e9451b084a3a6c3a4b9d6d84df93fac9b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 18 unique boards, 10 SoC families, 8 builds out of 190

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
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-drue: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
