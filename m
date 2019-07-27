Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B1C77643
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 05:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfG0Dc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 23:32:27 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:46845 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfG0Dc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 23:32:27 -0400
Received: by mail-wr1-f42.google.com with SMTP id z1so56228844wru.13
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 20:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+us6AqwbqMX+MLJbaL3XgRsHGgJRNwI7qojf87YMiUc=;
        b=fkCUSemIz7FAC8c0hIi9JppM1IAKtJCN1HyhXrAtMVfA/WPm1JgX7NFt0QKMQ4kI27
         04Iit1M66FKm7iu8CGviaI97labIsKR8RL0MRNYdBqZwS/+gldELObVvuni4ngsW0hx4
         9cDLDsnwJbqBiTHAKg990oOJgOcvZZmPnwxr/LpCWVIAGOMkxo8bW0rQNZoPReGyLDJp
         /sxfWkJMXnWYK2SgRkf3plRdD7HBN2rIOhKFlv5eB+cjoFP2ah5Yw+VCJugM8fhzDKI8
         3xLsOn0ybA+64kEotf2mOPylCfaXCyg2REy2dfVMtWUxauy1XjEDklpgJrjBzxHMWZIu
         Ikdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+us6AqwbqMX+MLJbaL3XgRsHGgJRNwI7qojf87YMiUc=;
        b=V0akHnAYpCCvz7/c1nHaI0YVBPGnLW2Ddty5hqeT/Rsr15jByx9NiaJaa2ulaRXLSF
         71N/QqbbSI9nOhVVgjeh/LxkVnwwI7SSCzuEv8bvYiIjEdYpn3kJYyheAg6yEM9h+LQS
         xPo6u1T6Rvi9PFXRCGdzOjKl7ZXvP386e6TJrdve3p+FqoxDlzA/gMoswKf7soUriaH1
         4KTpzG33jDgmfyPRKcNISPRREU5j9INGLpJNF+cPmMo+GTCtFLK7McxU+3054jgjA8NY
         iY9KJ52biVGw3QnmwD5WV6KhQIjbNdY/F50U9Ux0eDA3IrDdsoohD1KCu/jaO5RHi3Bb
         4rvw==
X-Gm-Message-State: APjAAAXHmmRrCdwIt5nhufwPQDlwt6CvnA9vhpWVr9z9wcOyMBC/WcPu
        Udz0lBXm+ZHrqMVEhl0IPKF4/MUur+E=
X-Google-Smtp-Source: APXvYqzvnfjbw+cAUrPb6a0F61OD1QEMXitQ1jBqiqfYqY0PyFYSkySRKfvFRzhIOjkWh87vU6srjg==
X-Received: by 2002:a5d:4cca:: with SMTP id c10mr99853090wrt.233.1564198344554;
        Fri, 26 Jul 2019 20:32:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o20sm135392719wrh.8.2019.07.26.20.32.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 20:32:24 -0700 (PDT)
Message-ID: <5d3bc5c8.1c69fb81.af1d8.af42@mx.google.com>
Date:   Fri, 26 Jul 2019 20:32:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.2.3
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.2.y boot: 51 boots: 0 failed, 51 passed (v5.2.3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 51 boots: 0 failed, 51 passed (v5.2.3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.3/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.3/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.3
Git Commit: 577669778464e991c12291f5833bd627d2102bcb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 31 unique boards, 16 SoC families, 10 builds out of 209

---
For more info write to <info@kernelci.org>
