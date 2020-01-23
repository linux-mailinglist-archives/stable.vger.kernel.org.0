Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88EFC1470C4
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 19:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgAWSam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 13:30:42 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36075 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbgAWSam (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 13:30:42 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so4261567wru.3
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 10:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=esSHlgqg2YUA/z9z1WM0mfWRp6EbmHqudZKpgody2D4=;
        b=K2zkIiyBmd4lFvoT1pubd1bNQmFqf8aCrl7zkSWYj83hHOvg3HOc/IKKgfTKJs5DE5
         W2IDH5GOzvVY6YB6YgecQdEHhTank+3EJRGWCsIkkZ9PuJmGVVc4ABYoi58kdLc4r3SY
         mMHBPceePol9myvsPNsGGZLR9UIQjOtxjmZ8HC7e3ft9IZHcCC+XyfOj476zg1MIgfG0
         tZlDIiQ8t9S+UiHDK6JkIno8CPOdVUVfnEI1SEhy6AGX+g0CuVxs7QLFv6Z0BlzWlKRC
         fprQuZoXeTuDM6Xh5VI2Z8iUB01rFaI+DMInFhr9SoXRdg8K6TcoOiUWVoPM5sCt7Vw/
         ozMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=esSHlgqg2YUA/z9z1WM0mfWRp6EbmHqudZKpgody2D4=;
        b=WWZK+rZ7YQjHSHWIS6WR6fVSwpKjBHIizwyOk4UzDOvaj3UApX08gvZsfPJrS1lVto
         MD605yJtJEbVPeBkqIkPsh8JiZcrgJRTcWN2tZFenhD5UYj1q9T5QAAQRpkTqFTSwpgY
         y9mu6NvcBdGvpgyiL88IWntKIg/VMVbnYOca2kS/fj/iqCOFDQNk3bhgXwORBsgngD6E
         qLeqlfBqc8LQVvvYOZqTDs6cI2JLwTHOLbxAHUy9272y/SYQM9rDIdzQ1FF80dE9pvZK
         DcelNiVy8E1xNJ4kMW/qBJzJK252ahUMCF8MW3aVYqzYoU6AeoJJ1DfqjRVNQrFvGNx6
         IR6A==
X-Gm-Message-State: APjAAAWRywbbEBLrRiHWXvcBL2ptX6a9V7egAEuQE9ThPmH8TfHS9X48
        s2aCKSD6TBZuX2Ot4FwQh5lqaiUYOJjDZQ==
X-Google-Smtp-Source: APXvYqyZJsoK0fyJmUmp9eB4Fq0yALZW4+G5uviC8PVz0PLPNKXt8uDNYOXX5t4O0vndh7/PSImo5A==
X-Received: by 2002:adf:e5cb:: with SMTP id a11mr18187505wrn.28.1579804239627;
        Thu, 23 Jan 2020 10:30:39 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s65sm3743533wmf.48.2020.01.23.10.30.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 10:30:39 -0800 (PST)
Message-ID: <5e29e64f.1c69fb81.a7323.fe8c@mx.google.com>
Date:   Thu, 23 Jan 2020 10:30:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.98
Subject: stable/linux-4.19.y boot: 57 boots: 1 failed,
 55 passed with 1 untried/unknown (v4.19.98)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 57 boots: 1 failed, 55 passed with 1 untried/unkn=
own (v4.19.98)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.98/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.98/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.98
Git Commit: d183c8e2647a7d45202c14a33631f6c09020f8ac
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 44 unique boards, 14 SoC families, 13 builds out of 191

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.19.97)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
