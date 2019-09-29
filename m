Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5E3AC195D
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 22:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfI2UDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 16:03:20 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36587 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfI2UDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Sep 2019 16:03:20 -0400
Received: by mail-wr1-f65.google.com with SMTP id y19so8727331wrd.3
        for <stable@vger.kernel.org>; Sun, 29 Sep 2019 13:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/38/9Mhe4jl9DtZqofZUrv73uZCiiE1m4P0ihDxlmEs=;
        b=J7iQ2h4L0sUkabTMzZeKfLHvm49CADTeDHzqTHQeXd8/JDZf1OgtcY1YscvZQDAoNw
         OxHj9rYFzKr2QXtI6M1O97gpA3qXG12MR1K4rYUviK8NKPtDpqms7FBVzclvb98xy9JL
         nEtTXalWXKMrdi3b3lUQGroDx0+cxB+QDspjMEFk3qOgNJlt+vtzv4CHYgeirH7bxEPq
         ZEoXnLo84sjgXpRnZVx9iC7WPH5MmHGV24AN0Cg5KOZPEXP7BkgD9ju063Llw/He2TwJ
         1f0OSOyb9TDl+xJcMNbG0isFz005rmy+OC2hTFgXgDzBAOaWdQbaijIXVP8RXhXwD1Nz
         iQEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/38/9Mhe4jl9DtZqofZUrv73uZCiiE1m4P0ihDxlmEs=;
        b=c9NN///tvz//l5135lLjR/JCqq/BFLTs43fG8Pqnj3SpC31pbgLxvDMeoC5zaXBxDH
         wRMBhFcJpofjktasMxG8gY3EFd7zXsxbpbQRo8sqC7HBbVem/5WL+FzkOxO47Op6uVxh
         6sLgoEZkuZPWMgv1Xn38uLiNVNQflXoXXqrF0CA16HBxqAxEGiTnZ6MuCNckRVldWnD9
         n3ooBXCZ6N9AY4Fu8XUd/is5Fo+3j/64ozDzVdykH5GHn/ZInXI05c439nTiDDCYcmv0
         B+Lb4hdc7jeRxNnQdmuKfFI/G4S2jmjcpSjuqrlKjB4w7e3J5+rdZlJhd+/P1KzbpQWK
         5kow==
X-Gm-Message-State: APjAAAXwgdyRyBjj6XKhQfIem7RfviKI7L3CoSbQ3RBMzK9/eaouPoJd
        VusqlHQFMZ3fH7527OdTLrkrx4N3cUY=
X-Google-Smtp-Source: APXvYqy+Tko6L1ICkl8sYzYBCknsyxtoaQ9sqWOYojgz+RmguN09y724OxqsAJfDDs42F3vkCY7R9w==
X-Received: by 2002:adf:e3c4:: with SMTP id k4mr10229463wrm.157.1569787397732;
        Sun, 29 Sep 2019 13:03:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k9sm14476995wrd.7.2019.09.29.13.03.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2019 13:03:16 -0700 (PDT)
Message-ID: <5d910e04.1c69fb81.1e066.19b6@mx.google.com>
Date:   Sun, 29 Sep 2019 13:03:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.146-35-g97aab3ae4e09
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 75 boots: 0 failed,
 74 passed with 1 untried/unknown (v4.14.146-35-g97aab3ae4e09)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 75 boots: 0 failed, 74 passed with 1 untried/u=
nknown (v4.14.146-35-g97aab3ae4e09)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.146-35-g97aab3ae4e09/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.146-35-g97aab3ae4e09/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.146-35-g97aab3ae4e09
Git Commit: 97aab3ae4e09a1c72533790721f393578f3b8d68
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 36 unique boards, 15 SoC families, 12 builds out of 201

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          hip07-d05:
              lab-collabora: new failure (last pass: v4.14.146-18-gf0e4f7af=
6713)

---
For more info write to <info@kernelci.org>
