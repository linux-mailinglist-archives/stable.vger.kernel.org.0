Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBB20107CFA
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 06:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfKWFWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Nov 2019 00:22:23 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:46028 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfKWFWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Nov 2019 00:22:22 -0500
Received: by mail-wr1-f43.google.com with SMTP id z10so11064230wrs.12
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 21:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=r4L3/gvCvw+MsLY0dpOKp75/5FXyuiBYTHevKmx+NdY=;
        b=agtD+q374C4VCJIuCgM9jkbdkuPsuPrz3tM6+rvrD5sj87oVGnk1QnfdsXj28lv2hJ
         nezCv5wYvyg2MTLMbDpOkSNolSHWf4ThCTuCVN9hBrXpDS58NgtyHAvGcxmqMKMLCgdN
         QbiQhXzjOD1w/pqaV7FgIPna/9wYIwtYwHdNZvkJB31lplLYfNL3krQ17CtYBkQYzeW/
         E+dVZROkdMcO32ovlhUx6jtpc2vdYWEv8jKo83oE/QmcjBDRDtNcYzswEjOnpctgn4Wk
         A8Ps45XAL9q+9p+EusXH9f7TLfox0tkscGT/MlqJqgqkFA0fIFnbsTG6Je40LmZwNJRo
         8T0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=r4L3/gvCvw+MsLY0dpOKp75/5FXyuiBYTHevKmx+NdY=;
        b=RlunCUeB90nJU21btKU2cc3DC3IxvBrNNx3KOcCTVKdWD1kUkiAoydaPPIXbliLPpb
         eaA/sOw2eeVn1jN7J43LMGrtjk6oYrj0nB4meAvUCM1F4owzOmWC1C0f3MbXsTIFZ7RB
         VgZTnEf9MiSSQmY2c+UvJ3Cwg2FNsxbPB0J8HOTru0RoG2N2EvKWHYO9q6QM59PPrnX7
         /od3JGC0xTRb9mSJzknn/tkSdirKY71UZlj1g9f/7AV3LN0JfAQa6MH5QJ0OH1qe4t/4
         4v8Qc8s/snIXYG1LreDBbpsG8GVy2Ijyoaa6/W+ThQfLpQPAonMOa2kXMF4DuhwRLn2w
         2u3g==
X-Gm-Message-State: APjAAAWNKBA108fGvoK2yuI5XPHdp4ApE6YlgkmRV5o8azK8etO0+9Z6
        7HT4PnNBLO/RvnNlv1qGKndfwls7v4K81Q==
X-Google-Smtp-Source: APXvYqy+Is24U+DOqlAZqS0udEHP0D8cdgUcxvQ7z+mm5xlHWMrrbp/HAwDjs093u9GM24wtH/c8uQ==
X-Received: by 2002:adf:aa92:: with SMTP id h18mr21710579wrc.150.1574486540834;
        Fri, 22 Nov 2019 21:22:20 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z7sm579398wma.46.2019.11.22.21.22.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 21:22:20 -0800 (PST)
Message-ID: <5dd8c20c.1c69fb81.debd5.208c@mx.google.com>
Date:   Fri, 22 Nov 2019 21:22:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.3.12-7-g6b14caa1dc57
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.3.y boot: 112 boots: 0 failed,
 107 passed with 5 offline (v5.3.12-7-g6b14caa1dc57)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 112 boots: 0 failed, 107 passed with 5 offline =
(v5.3.12-7-g6b14caa1dc57)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.12-7-g6b14caa1dc57/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.12-7-g6b14caa1dc57/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.12-7-g6b14caa1dc57
Git Commit: 6b14caa1dc5788cfb139f0bf14b311fe815f3549
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 23 SoC families, 17 builds out of 208

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
