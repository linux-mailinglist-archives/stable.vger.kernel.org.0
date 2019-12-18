Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070FC123EB9
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 06:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbfLRFPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 00:15:11 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55543 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRFPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 00:15:11 -0500
Received: by mail-wm1-f67.google.com with SMTP id q9so416019wmj.5
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 21:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SO0/K2O9SN2PLyJBtjlnAky4tDhTXq59+4z8jHiS/cA=;
        b=E9VivFQm68TRwD0rPhVzMJqOEBKnQ7rgEYwpo/5MNgBUacGNdGFKkMKziMhuZaFjKZ
         AcAM3WcyVx90Q29t/87AiZj/BXhw+4AaHySefRVqxc2qMR8MAbmoL2TjypsdyeuV2JN6
         qY7B79+6sx1s3ZIUskMMLoqcWutUwoDDN5FpQglSnYbbK+KsJf0ZxHECnI59gTSJhiuN
         soGComB9tfAbvJVPDzOOdpELdiBRks6pNYPGy2Sd9tujeR9L+QdLLs4+vqxamC1wDc6m
         lIgG9vCzG7Oas2iZVFJMs3/qpFIJF6r33NozBDU9oTu7R5KVQhO/O219nZlO4PtFCNTV
         1LdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SO0/K2O9SN2PLyJBtjlnAky4tDhTXq59+4z8jHiS/cA=;
        b=SBdSQ2bVESOZqBKWb0a59On/hXPq/Qz5Owg4h4cXKQqNQuwI5kWwMv5OMFep0hqzBo
         211DrU0qBDgtdo5I8NZ+hrYq44BwtZDNK3kuI/jBxgFQRQAFFzeyObQSRL1NyE1ZOE3c
         zS0c7W56xbCMN1cOqxjZhWOLbNq6kPxuSztCvGQ4k7xA/uwVnAlgcO9XcXioVy85LDa4
         XyD6xb2kh9P/llYSy+mjfLIK/5lwUHIM2OroyRghtioj3r27YzFRGOjyzzeCQSv6/jvT
         JTtjn0bO4aFlCB7afhj9p0X9Hoa5enUc9VCmM2rcRsQ/GT1qcjyztGr/Ksz71abOVSrN
         jujQ==
X-Gm-Message-State: APjAAAUq3jtWsUHr6TMEeVNtJWn2LN7YSdT2LWUxfUicejic5vG8jLZP
        HfWJ8s8UBSSdmuSslKzvJ55oFhTgQRRqoA==
X-Google-Smtp-Source: APXvYqxDJLKaV/58CEZSnduir1C9GUHvRDJ0v48ehw0xXHQ/Sr6lCLOsIxpfxhEO5LLEwWoe6XwoVQ==
X-Received: by 2002:a1c:ed0e:: with SMTP id l14mr696826wmh.74.1576645681798;
        Tue, 17 Dec 2019 21:08:01 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q68sm1283421wme.14.2019.12.17.21.08.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 21:08:01 -0800 (PST)
Message-ID: <5df9b431.1c69fb81.dd54.50d3@mx.google.com>
Date:   Tue, 17 Dec 2019 21:08:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.17
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.3.y
Subject: stable/linux-5.3.y boot: 71 boots: 1 failed,
 69 passed with 1 untried/unknown (v5.3.17)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 71 boots: 1 failed, 69 passed with 1 untried/unkno=
wn (v5.3.17)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.17/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.17/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.17
Git Commit: 5e2cfee1b25c94aa357fca06f30d3be073c36d16
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 52 unique boards, 14 SoC families, 11 builds out of 208

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.3.16)

arm64:

    defconfig:
        gcc-8:
          meson-gxm-q200:
              lab-baylibre: new failure (last pass: v5.3.16)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
