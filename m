Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0835956B45
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 15:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfFZNve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 09:51:34 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42115 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbfFZNvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 09:51:33 -0400
Received: by mail-wr1-f67.google.com with SMTP id x17so2822812wrl.9
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 06:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=lQ+kH+8OcyY0c8JYG72kvfeQsmfca58t7L4uorcaVGM=;
        b=AZdX9lcI5pjztVWxh656eaPnCtDHPZIem9X1kHLHfQTwUBsdYtK5oOQI27PKLVQBAG
         tGieFaS3NaXfIKUVngX/yG7F/MsF1abmxcDVGjGl8LtqM4Ft4xNanGFiOHur+L4fMzni
         4SIBrex/1DpF4X2ieQFR18ORpZDkUZZ4/jJG51g1n8a2DCXWxXWBNEUO445g+xvQxG3r
         ZYGKpOSi3j251UPTv+4v3y99LtOniPLV79FBnhV0kgk+vLzFe/lBc68p0GIGg+MC3MDK
         /Yi0ArFLRfUh9HOjNNsOgtueVIVs3NDhdJ2k97FNPxB1vvF8xcCGiI8tD9XmwbeSlfTc
         coYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=lQ+kH+8OcyY0c8JYG72kvfeQsmfca58t7L4uorcaVGM=;
        b=UxVAFCSF+vosj0iOCKjas0AevceK0WnUjHJBjKJSXSNXBvwbBnwSrYmeI1KFT037Qy
         E/9+I41cZsr9O1ewGOG7AK5iuFfZlql2H18F6DzS26cPaMAmOQ4oDooSAYTbUGQ9gcum
         5Ivu/PqTAoTg0PYRFlALkRCf3Q0LbTcs1cTGjgld+Fq9yQCT6nItX0VwBofOSO5LaBhA
         kbZJJE6184Zm2Fen023i1E+zwOs7uoFHhCEpbJBzmk4pSzgfjQgcC0FFAk86WO6g5Td/
         AYYxj1EhiLzjqTFl1LpJ6S4Gt6n4Z3ub9Dto8Sj1Q6BkraKk0q8Wh4htxi6YTPv41on1
         MOTQ==
X-Gm-Message-State: APjAAAUwfXIiVLDDqfYxvdsPYz9gnJwLGYNaAmVR955n69nbY7IlhNH5
        QvYnpgbXGU3Bm98M/OtLhkfAzQ==
X-Google-Smtp-Source: APXvYqyBmr+Lzsm4/mh9XTKT8ZZbwyUyCiiwkdjHz6yVHf2At2LeK/udBwT33alRB5RzAif+CCgxqA==
X-Received: by 2002:adf:d081:: with SMTP id y1mr4067653wrh.34.1561557091538;
        Wed, 26 Jun 2019 06:51:31 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h21sm2991135wmb.47.2019.06.26.06.51.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 06:51:30 -0700 (PDT)
Message-ID: <5d137862.1c69fb81.609f3.fa81@mx.google.com>
Date:   Wed, 26 Jun 2019 06:51:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.130-2-g2f84eb215456
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190626083606.248422423@linuxfoundation.org>
References: <20190626083606.248422423@linuxfoundation.org>
Subject: Re: [PATCH 4.14 0/1] 4.14.131-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 129 boots: 2 failed, 127 passed (v4.14.130-2-g=
2f84eb215456)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.130-2-g2f84eb215456/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.130-2-g2f84eb215456/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.130-2-g2f84eb215456
Git Commit: 2f84eb215456bfd772fc0d9efc8446a66a3faa1b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 24 SoC families, 15 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
29-52-g57f3c9aebc30 - first fail: v4.14.130)

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
29-52-g57f3c9aebc30 - first fail: v4.14.130)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
