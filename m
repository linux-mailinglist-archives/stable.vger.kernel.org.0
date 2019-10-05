Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E858FCCC72
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 21:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbfJETDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 15:03:39 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38536 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfJETDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 15:03:38 -0400
Received: by mail-wr1-f68.google.com with SMTP id w12so10790733wro.5
        for <stable@vger.kernel.org>; Sat, 05 Oct 2019 12:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eHgyisTXTmMUJTj+8aQiGSmla8e5WHaWc2SZyxt1I0U=;
        b=bmaz6/pTj9Jovbi7NogoF0Yvi5z95kOnJ9oVIGoqLXrps266ozOo64qSNqAPlY0G0A
         aeiUDcZovCElj6gLoRJtuoSFAl/0F0z3u9r7QP8+y7ERtqnUcYeZyP2o9ciAx9oYphaf
         xNqa01Qj7R45hOIiHGC9wJDwLWhD7V/4R6efi2N/lGcZeOYn8kKL11dqQ62JYiBRmjmJ
         jAS4G8tLl4/a3l+E35mNji5PN1aKUYD1u6dSicu87WpX72k7A5RZ10f1ENaIK657de/T
         lVvWWkJMyIhROl3AKYtGy6R8ZOxetYJ1argYA+ElI4zl9JF3ynhE5PzxlLMzmDcJRRku
         64Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eHgyisTXTmMUJTj+8aQiGSmla8e5WHaWc2SZyxt1I0U=;
        b=S2A5Z6kEnEB5kBCIaixnZHLUHpsG6rI0naplbZNJYanqL5kcL0mOqgQNRjIO+beqCH
         QBJSTx//KK/e0GBIl0TmFndfPWegtRY7+/3O2l9tLrczfEXkJhLZb3A6+Wpw9ziPD3LC
         W3oC2NqfS3q/8h6FoPGY4k/mKsiGpomd3WrY+MLX8u9EJJIBjjLzBHJh8Z0WKMvIq4yG
         fYNITSifHNTYJLQ1hjblAWELPAcw9r9ddvXIca++DIwr8kbWA281Ant180APRHJyjaU2
         VUXU74awwGFWuhFAmaT5bj9SNK82Z0aGGQNNs7TTlAUcrN8t0TU52gAdYCoXFkY8fJHq
         KEVA==
X-Gm-Message-State: APjAAAUtWqavsPF7oOT/6YemCb+KSfN8D0VDs+5PK8K1jrAFSePa+CYR
        8bLqq6LFi1mh62nEPbU6/3Mseheicx0=
X-Google-Smtp-Source: APXvYqwIncZUceLdqmUx1/V9dyq6V0P3Qp1KWGeJ0ygB5UH+l+FfTQ9RdFDVI1ePgF0obx56gR4d0A==
X-Received: by 2002:a5d:6384:: with SMTP id p4mr16200053wru.180.1570302216617;
        Sat, 05 Oct 2019 12:03:36 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a2sm11015597wrt.45.2019.10.05.12.03.34
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 12:03:34 -0700 (PDT)
Message-ID: <5d98e906.1c69fb81.92d17.00b2@mx.google.com>
Date:   Sat, 05 Oct 2019 12:03:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.195
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 39 boots: 1 failed,
 37 passed with 1 conflict (v4.4.195)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 39 boots: 1 failed, 37 passed with 1 conflict (=
v4.4.195)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.195/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.195/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.195
Git Commit: 5164f0c3740d357ba460b44222bedfa2475ca794
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 21 unique boards, 10 SoC families, 8 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
