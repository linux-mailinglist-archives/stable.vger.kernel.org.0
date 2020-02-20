Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9D26165726
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 06:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgBTFrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 00:47:15 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:33748 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgBTFrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 00:47:14 -0500
Received: by mail-pf1-f180.google.com with SMTP id n7so1361266pfn.0
        for <stable@vger.kernel.org>; Wed, 19 Feb 2020 21:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZvKPKg37kB0ZcrzNfmO/gsBx5FnqbsIo1CdbcXJ1JUw=;
        b=G2GojqlUhSueHNz30L+wACPiTZBUTPWRz4wGFvDvTyOOQ6WvZRRsvWzvq1aqGSyjpu
         Yoovy2nqIctA6BBvtuMF6qeoDMyvL9+NCm/mZcem8IwdpcbRb7u8vz1OAhZqyE3QSKpn
         DEjZ0T1k+Bv6zJZKwNeZkOdQBdea4G+kgak02KDa/YyhYkjCCKazQBXfDoTEzcmbK+y4
         BGMlhlZqe1MT8K2MmUkYf7prkrQkCTmPrUsE6J8CpZVB6aPvOsZ0mM6UJyFdwaFU4fWe
         bR3kNdbMrw9e0pUp0omuSieVcaXRMwRFGbcUY7JWYtRbiRk1fRhn6ghGH2tf2pRmGwe4
         UE8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZvKPKg37kB0ZcrzNfmO/gsBx5FnqbsIo1CdbcXJ1JUw=;
        b=XCjJhtt2SqvS5y9nyTmvtY1roB1pLlufSFqbVzZfiMVCJm+7mZ9TLZTipB+Au0qhF4
         Kg2u/OJjKacgR4H6DmFjAh4HBlNceylgPyZeQvYpKVmb8pFn7YEHurX10L3nFWRZyKOi
         9u3srWh2o7zxQydJ0PWl4X+j8rlCAdIGVGvuiRC6Qguoy8nPYFiUIW6H0KDq2KvscygP
         cvuJGymc3g+Wym1hdwA3Qa397nt99NMyRtRLIEdm0GHwSicKkM+mNQOCEgVdA+DAizsQ
         o44FDN9351lmliQV8UhAIg5mdiG+RxEwqWt3Xu+0udJH0lr3vMY9ETmFi1+K8KWQO7Rp
         yPyg==
X-Gm-Message-State: APjAAAXibWvrYIvxAG94KREshv71YEvIJpzqemWk6rFMXwxjQ7B0dQvu
        VxVZf8Ut396DlpcNxmiILxPXeILSu/4=
X-Google-Smtp-Source: APXvYqwuCP7YWKBtVwrA8ia1l1yGYeqMtjS58Yu241wGZJu+4ZQSxZhPNvsdjSNYMc5RvSKDSFJvDw==
X-Received: by 2002:a63:f454:: with SMTP id p20mr6803287pgk.149.1582177632511;
        Wed, 19 Feb 2020 21:47:12 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gc1sm1568169pjb.20.2020.02.19.21.47.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 21:47:10 -0800 (PST)
Message-ID: <5e4e1d5e.1c69fb81.85153.5884@mx.google.com>
Date:   Wed, 19 Feb 2020 21:47:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.214-15-g4d9c5d6bb1c1
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 25 boots: 0 failed,
 25 passed (v4.9.214-15-g4d9c5d6bb1c1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 25 boots: 0 failed, 25 passed (v4.9.214-15-g4d9=
c5d6bb1c1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.214-15-g4d9c5d6bb1c1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.214-15-g4d9c5d6bb1c1/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.214-15-g4d9c5d6bb1c1
Git Commit: 4d9c5d6bb1c1317c4286e13a557dae7b295f23d7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 9 SoC families, 5 builds out of 112

---
For more info write to <info@kernelci.org>
