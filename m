Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECD4767EF8
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 14:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbfGNM2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jul 2019 08:28:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52551 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbfGNM2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jul 2019 08:28:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so12586054wms.2
        for <stable@vger.kernel.org>; Sun, 14 Jul 2019 05:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qOv9pr14tER5KSJ9Sym+4xESbqnq5V+SIM15jIseiyM=;
        b=z1ywx+TuE7uSeL2UkeQZDKe6QNAiCXWxD1R0IcD8jbg5k+smdI5nkwjajsYXfnqyTq
         S3czblcfIoaG9JIMc6kMewUvz7Z0zATmi41MCsdjF0RS9+zv2tvHPwQ0bukpJNwvHd1x
         coybHVtiF0/435wmX61GMkuIEkDansUUJricWLafmUyt0GdxSked2/QQsPruoPDpq1HL
         RdiNGVqNHLK29NyHw7qD+vpvVyTTsudVjnjpqxhZEvBl7zifKZwKgu2O4Gled65iItSd
         gJD4dlDxe4T66hhwKdskFi0oTcEXZuTZ9smAMCNDGHtebcA9aDJif3hVdKbjLZMlRS8S
         xFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qOv9pr14tER5KSJ9Sym+4xESbqnq5V+SIM15jIseiyM=;
        b=R1cxDg/FB3r3sPVdl6OchKlqmvvzj8X3orfZWov/qbW0msgWhCqI1E5Ec5SYNiMQMw
         S9aR1TTcM1X1ZKWywsk0DTjgZtLkkQytJM1PxRq8J+9IdjsEc+95DamZScjyIOTVkPXG
         kz4G7tsY23wId4aKnDCVajNcDUB8AKmNmfTOec65gT1MKkoj+uZ9Gx02iSSH+7QJQBBl
         F79Hf0Tt6NlakuQFx4SYkMQj1s0VOWN7Sd/kBMLKJBWBIycmWUnEF/n/0Vtm7+5XS/cE
         f+jIlhyJSd136uv93G2i6elKIIhhgje+DNWnn9Fj0HkOeyMwP7ZnoI2RuyO41DwsyATj
         DeSA==
X-Gm-Message-State: APjAAAWFKcYwJmSzw8HMLtPLJzHkrfS//+JmKBJPzn66BqMtz0/ZKmcT
        2ev6upUmO0zw+3CdO+JHkavHM8jC
X-Google-Smtp-Source: APXvYqx6hLWJh7tDXk5BQO/eCRQOgzJA5IWZhXYfAzkBF+RpJXunkhP0+OQy58o/rfDpltdZDFO7gA==
X-Received: by 2002:a1c:ac81:: with SMTP id v123mr19937855wme.145.1563107327614;
        Sun, 14 Jul 2019 05:28:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t6sm13955896wmb.29.2019.07.14.05.28.47
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jul 2019 05:28:47 -0700 (PDT)
Message-ID: <5d2b1fff.1c69fb81.8aec5.09ef@mx.google.com>
Date:   Sun, 14 Jul 2019 05:28:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.1.18
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.1.y
Subject: stable/linux-5.1.y boot: 66 boots: 0 failed,
 65 passed with 1 untried/unknown (v5.1.18)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 66 boots: 0 failed, 65 passed with 1 untried/unkno=
wn (v5.1.18)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.18/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.18/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.18
Git Commit: 22bc18377bd45c060733e1ed09f34b769e4b4bef
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 35 unique boards, 17 SoC families, 12 builds out of 209

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: failing since 3 days (last pass: v5.1.15 - firs=
t fail: v5.1.17)

---
For more info write to <info@kernelci.org>
