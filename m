Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF0C514F27D
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 20:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgAaTCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 14:02:20 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36905 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgAaTCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 14:02:20 -0500
Received: by mail-wr1-f65.google.com with SMTP id w15so9942661wru.4
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 11:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/VTJZGfu8pO/Z6KGYLotlOfAleRHjdKalKOlsW1qzNw=;
        b=Oxv5AZWQYmaJUXPEZigY6BiwC+qlyedYxsTukjW5E5Zl3bCI5FrFCOPMHkTlDz/za6
         Wsj7cFygZFtjJFGlIohbVkr+j+IHmHgd4hm3lZpTKQZCVmeJL7v6Rs+f7S4hD0h+czx7
         q8NuzqgKeQcbYERjw2QR5IsIUwSyLR+doR6dEsT1jIlg53up6CoU2IovaBnVXH9NLc8E
         elpLj3V/pLM+SkZ8bsPrEIwD/6pZ6ZLAP/4i8DaLjcjMbOWXoQqSHFdGpWTfXYl2Z4mA
         KDNnzJ0yDkZtPiEwKMxg+1gW5EmyWpG/ZcUzF/aWPFwRcHTbjUrO0g++5wrAVHaEx5LC
         Rz3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/VTJZGfu8pO/Z6KGYLotlOfAleRHjdKalKOlsW1qzNw=;
        b=CONETYs7aZqFg8A8EMyhvzhfG2JI4tn9MKi43wd2Eqvu9En4Ivkd7c9QGhGOk68ubr
         FjNVPjXyNySgvuSwxxftFeWxSXJdX7gh9qKQt2B9S8BucMw8vYYTbF/D/sg/jCPgCMyH
         UTIB8gDP8iBGjB4wgViUkVkXd3cmXj1RNXkCbUbmbv60DGdvJY3hZk02T7ODKsMMl33C
         Aj8mJtzXazsnAtK88GQuOvlW9PzmT+eM1uif+8IdL/BOg+b584pAXOFryqKo8GhRxs3+
         2zUkRmiNj5kKHCGYTtDUoJgiPUI+Yo0snsgRhetxDJS0Nf+yEvzmTtnsohmFXMjxfjYd
         jXgQ==
X-Gm-Message-State: APjAAAWaXKmLYcmt5YxtVj4Kel6aVyBtYzFyAWxtc0u8DgCeR8qdDQ4i
        jalqhtDpvsq/rT0GPrrFgyXkmS+/EtbxDA==
X-Google-Smtp-Source: APXvYqy6j4lPXwhlS6XJO4+MZ9gaxCp3ZUqK+c/Zi8DtC4UGGR4j6fYZmGIrbtmfV7bN1Mb4AIsu6g==
X-Received: by 2002:adf:de84:: with SMTP id w4mr12851978wrl.97.1580497338858;
        Fri, 31 Jan 2020 11:02:18 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n16sm13237086wro.88.2020.01.31.11.02.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 11:02:18 -0800 (PST)
Message-ID: <5e3479ba.1c69fb81.5dfa.c1aa@mx.google.com>
Date:   Fri, 31 Jan 2020 11:02:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.16
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.4.y boot: 81 boots: 1 failed,
 79 passed with 1 untried/unknown (v5.4.16)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 81 boots: 1 failed, 79 passed with 1 untried/unkno=
wn (v5.4.16)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.16/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.16/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.16
Git Commit: 60b6aa2b71efa7e0bd5393ce292ace4a0cf2e71b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 58 unique boards, 16 SoC families, 12 builds out of 175

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.4.15)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            msm8998-mtp: 1 failed lab

---
For more info write to <info@kernelci.org>
