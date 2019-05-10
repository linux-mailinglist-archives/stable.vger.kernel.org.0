Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B711F195F3
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 02:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfEJAKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 20:10:52 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:40938 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfEJAKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 20:10:52 -0400
Received: by mail-wr1-f42.google.com with SMTP id h4so5370781wre.7
        for <stable@vger.kernel.org>; Thu, 09 May 2019 17:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IwwoEHFzreNVDG05TizmZ2F8uUhQM7CPyki3zUPnkio=;
        b=qg/HXXgcrmU5n6o4AEBqukNqPazzB0qX7DNSxwrbuq3mMi+qpvTRJjoRwmVpSqKtI9
         EO5qPQi8oEz63iZla6AtbLoflcVZvi2kU3gOROs4bTSLU5OWo+rEJL/sdp2DWas+oKnA
         1KvMnLglnxDgnjwgpQpe505kZn12SVs/hDd6hHhaFGaf+sfp/QB8uEdfaB55uR6K20Fg
         YmWR/zZOTcTZliVDnalmmJWZXg9qdRMFvG0XfqP/rsDYj4IuhCYF9kYbvQIUDC+ULHSR
         9ND0FdUsSix4SmCcN/ojLfp3rA6IepP+0WCm+Vmx1V2MRYvRvxfkP10ex5rOlghZlW/N
         7i0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IwwoEHFzreNVDG05TizmZ2F8uUhQM7CPyki3zUPnkio=;
        b=MdaWLWtg8EPwiknjck2Mm9ZO7VTMDmRzQ5A6Z+ZT5VAymmCxXrEZR2BLwo/kkmzoq0
         DHRsjn1H7rpjChlCsOMRyibZe7dcZS7m5mahAukYT4RfNxa8oTYoziyQDpWTTAvuD/Do
         5x9MATpTC5WkjbP3M1QffqzBZHNpFzrRlgVXKEAHMHkz18xPF7qA3urssnN69wGIv6wq
         Fbrhn5A6i5qg175OeTnpSNrQ1ftJm09y6w7svmNS/UOr8nvj6BRMN12LelBG4UWspHS/
         b666j3Fs8XouQR4wrRSs7Z7/SlLM8zrsrp6NZBuD8/bMibwrIF/kuswAWRMIHgbMhCSO
         PYAA==
X-Gm-Message-State: APjAAAUDS06g6/fnvuEOtTdmAVD+PPAhdi/janbAUYScHiXujDx04mlc
        IhX5PAd4oT6c23YtRVW2AB4bqEO4n+ii4w==
X-Google-Smtp-Source: APXvYqyh57HuDfZ/NJCo3Fca9lu4szAe0IFDX0tYV4Zaon0gXlnM1y8CsaJMKuAZUjgiKxRFzkwjng==
X-Received: by 2002:a5d:65d1:: with SMTP id e17mr5104547wrw.65.1557447050527;
        Thu, 09 May 2019 17:10:50 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u8sm2191751wmc.14.2019.05.09.17.10.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 17:10:49 -0700 (PDT)
Message-ID: <5cd4c189.1c69fb81.87447.a4d0@mx.google.com>
Date:   Thu, 09 May 2019 17:10:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-3.18.y
X-Kernelci-Kernel: v3.18.139-64-gf6ad567f1ce4
Subject: stable-rc/linux-3.18.y boot: 59 boots: 5 failed,
 53 passed with 1 conflict (v3.18.139-64-gf6ad567f1ce4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-3.18.y boot: 59 boots: 5 failed, 53 passed with 1 conflict =
(v3.18.139-64-gf6ad567f1ce4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-3.18.y/kernel/v3.18.139-64-gf6ad567f1ce4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-3.18.=
y/kernel/v3.18.139-64-gf6ad567f1ce4/

Tree: stable-rc
Branch: linux-3.18.y
Git Describe: v3.18.139-64-gf6ad567f1ce4
Git Commit: f6ad567f1ce462b792c1747195066c73c429f9a9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 12 SoC families, 13 builds out of 189

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v3.18.139-52-gf=
85e9af98591 - first fail: v3.18.139)

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            minnowboard-turbot-E3826: 1 failed lab
            qemu: 4 failed labs

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
