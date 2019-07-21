Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33A4A6F332
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 14:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfGUMW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 08:22:59 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:44382 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbfGUMW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jul 2019 08:22:59 -0400
Received: by mail-wr1-f53.google.com with SMTP id p17so36517913wrf.11
        for <stable@vger.kernel.org>; Sun, 21 Jul 2019 05:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z0mwsrijvVkLugj+Xwcf5dP3K1iZOPa7qc9RWb/BKcQ=;
        b=eCOepDiavnPdUmWzWlTPcPJuQdCz5kG1y0nXkxDdKkl+KVx9hLKLVNx0JHDWiBd7wP
         PGYG+nic2rAXYu9KA5rxOLrv2xKUxY7j7JcDULpuetqwqSF9h9ejDjpWA5KXiRe5fJXI
         7Tc9r7NFnN7xnfFw3yCexEIylYK2lIagm4ZcmQDPIFQGKHAGcvuWz5FK/MIr/7eHRDjc
         K8IaWgsAiSf3GBHFojWmIPde0GbmvHHrsjNYiOSq+T0xmOTlHCrQICYBkdQMI+e4qaoh
         4dfVzfZetRv+VKTcR3Gq3Qa7AtEmZeWY1z3EPmZj59YB7xoHv7xjC6OkgxwbLkVV2TMv
         yyJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z0mwsrijvVkLugj+Xwcf5dP3K1iZOPa7qc9RWb/BKcQ=;
        b=oOrDPAh1pJ8oXzoVft1mQ0I+d/BFrQEK3XBTQiqdgf+glwcLecP804sylyl5P8hp4l
         o+G2de1LuCYZJBcu/FCXzp1rBB19lBsdTAp8gj/QpDfvdIRACIiq0U/ApSfWu0sMLWdF
         rsIUaCnpsfBDC2g4wUFPbP8MIN6HrpC5Eg1Y1keWBiYw8iEIxtp+yHSzXBceXzG3AWF0
         /lzozZNLzoT6VI+oxB+3CZFxv1g4lHvpLxwOZumQ4yHkeFgVw9nCwGOoIKWowmR15yM8
         DNl5fZ0NdWs4GYIJh3bSlcgoGTzpxsBTxSfXWc6v6a6kDcFOvjIfPO8eQwNCk4sG9iq1
         Zuaw==
X-Gm-Message-State: APjAAAWNEXN0uEXn++QfJF3imvEj8Itfk3NSb/8/WGEER7UY2cgfPlTc
        eQRqdlaNeF+9DiNHvF1pca6bN/++
X-Google-Smtp-Source: APXvYqylP0EP9+a9MkiqLPbBXVoaTZiO5NW+1l1E1lx2hdT/uqjqxQXOIgg1aYUL9NPPERa11JJxjg==
X-Received: by 2002:a5d:4e4d:: with SMTP id r13mr19769902wrt.295.1563711777077;
        Sun, 21 Jul 2019 05:22:57 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o26sm66500478wro.53.2019.07.21.05.22.56
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 05:22:56 -0700 (PDT)
Message-ID: <5d345920.1c69fb81.59e8f.09fe@mx.google.com>
Date:   Sun, 21 Jul 2019 05:22:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.134
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 44 boots: 0 failed, 44 passed (v4.14.134)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 44 boots: 0 failed, 44 passed (v4.14.134)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.134/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.134/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.134
Git Commit: ff33472c282e209da54cbc0c7c1c06ddfcc93d33
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 23 unique boards, 12 SoC families, 7 builds out of 201

---
For more info write to <info@kernelci.org>
