Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4594B4FD38
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 19:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfFWRK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 13:10:56 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:33932 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfFWRK4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 13:10:56 -0400
Received: by mail-wr1-f42.google.com with SMTP id k11so11379635wrl.1
        for <stable@vger.kernel.org>; Sun, 23 Jun 2019 10:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sRMM2oJYJ37NVQMiCAUpDUrMI584Zm+7qU489aXqNqI=;
        b=VMAu/Zb9gikVXRDCao2H4dsDR59RiUuUtZJpgKWZb4YsMSQnOsCd1j8048Nl5vaFaV
         kFp6/xAZOZaMrfqiP0ygok47eaHC6VWXR7GwMXAPG6D1QYl8ZtUhQ7kPd/OKmP+PBYnI
         miX/m9zFyMO3NLn3J6UuW02tebA8/jAN1muhH68LiwK/GIGtWb/q+RA5jaOIPpk98TP/
         7EGOivENLcu0IyvG9hChHJjKw520kcJW6hwhgsFNMdfd22nwRlHCawy1uP0XMDFSSMlf
         iF648V0/EF4KwSzbME/0R8VjCFCRji2wRNdO340lKbpjjFioQdiNqimAv+k5pR4IAT5c
         kR4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sRMM2oJYJ37NVQMiCAUpDUrMI584Zm+7qU489aXqNqI=;
        b=ps/HrhBnSAldqsNfkKkaxDpNU3/3ExmBpvV4Wy1ZvtHgTXHonHNn3Szo1BNjqfL4fX
         JVRuX8gtdm8Cyqj6S7RCobVsiBVHP0g4+uvrF7QYOpxNZ6pBzhdb5iUw+H1niNGJ2eMW
         CIFLUqBLoVNCnn5obmCLjzHfPxbCfgOtd4RgOKmudQTIm+NAyU+/LHSdXUFKMEgyrF3l
         PJ//9Uk+NTbX0XsuYjNhTLiIANyMXDShWuquKAGm2uba8VDXfXslB2vU+crodd5t9vmn
         gk8NfWhksH9E6mhlEkoA0pU2ftIQc+QnQB5XAhJUxmIGt7t+QN/pyoYHP4qIhFDyYLg5
         m+LQ==
X-Gm-Message-State: APjAAAXkLY4KLbAvFpOzNoMxzVceZ+E4gYOnT+jh2xdRr1ESj/87gWnY
        C3RtIiAifVsEtluAODwuohdxqrhzDxM=
X-Google-Smtp-Source: APXvYqw5LNxzBsVe0ZRVdrT8OOs2ay2mQCp+xb7ySlRmyRnodNIeT6bZAQ3kah4k+TgIhUEU79JILg==
X-Received: by 2002:a5d:4950:: with SMTP id r16mr61496561wrs.136.1561309854255;
        Sun, 23 Jun 2019 10:10:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x129sm6975636wmg.44.2019.06.23.10.10.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 10:10:53 -0700 (PDT)
Message-ID: <5d0fb29d.1c69fb81.58cea.548a@mx.google.com>
Date:   Sun, 23 Jun 2019 10:10:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.183-5-g57beb40d75fe
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 6 boots: 0 failed,
 5 passed with 1 conflict (v4.4.183-5-g57beb40d75fe)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 6 boots: 0 failed, 5 passed with 1 conflict (v4=
.4.183-5-g57beb40d75fe)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.183-5-g57beb40d75fe/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.183-5-g57beb40d75fe/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.183-5-g57beb40d75fe
Git Commit: 57beb40d75fe16597232bf33de8aeb08360e242a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 3 unique boards, 3 SoC families, 2 builds out of 190

Boot Regressions Detected:

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: failing since 2 days (last pass: v4.4.182 - fir=
st fail: v4.4.182-85-g847c345985fd)

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
