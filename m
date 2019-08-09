Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782DE886F7
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 01:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfHIXhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 19:37:46 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:36049 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfHIXhp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Aug 2019 19:37:45 -0400
Received: by mail-wm1-f52.google.com with SMTP id g67so6948161wme.1
        for <stable@vger.kernel.org>; Fri, 09 Aug 2019 16:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Pd90CKRmSg16JpCK/MDP+fomIbI6Zq1goCFQS+X7wU8=;
        b=iwt9/g2AQ+QUodtlWYE+iQShBb1ga+c8wDiDZ0N0DnaUmDTiI0ZJaNtBKM388kx/ya
         ngXQaNEvx1wmApTMEVST9OxxkYM2R8QL7GR37lxlWyS7DAoI2HvaM1+Rb/OM0EE/447D
         Kyeyz2etftqi7pmCYHD77L89Mn9muf1dq86rcx5y/Y9z4NZv+q0AQ8UY3TW4qY2w+BW5
         oWoW5BXubfkTkZH61IlXh7882vuRzCU3/8jVE1d4D7/bMiGl58wIWxPvzwzYaETQlZKI
         fiad0SPIAlebkUrIzbCrgSczdJQCjLKq+kTMA2mV888R3DlS62FFRhaGFVviSTvZ3gaB
         VqsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Pd90CKRmSg16JpCK/MDP+fomIbI6Zq1goCFQS+X7wU8=;
        b=NGBLLnVKGMmBb1Y1lChBZInjmcaKR1Kzmk0aeS2adrr0HzKkyM9h0RIgme5LmcVSqa
         NAH9GoclA56D2HZOKE/OzJ145H+lLzT07ijDWEc+NsbNGubkoI/OTuDg/8e1PBBd+3vx
         aNfJL5tETLEgOj63zh6EQDcfOqKV4zu7br7P7b1wHwAxtEhK5bgCTNVSZ7UgmWpGxcyA
         yDfbj1idhqyBGRMTCVDGxlP7jXMf2SQN4l0ZSFnpGB1pldtqD6yrSiTOCigWvrMyQKaW
         lc4Z2vYdYt2qHyGhSskl+7H/er35Kvgu3Ym5Fr3ZVlTUJE3o17TKVze+JfWVeDEHhZoq
         mBFg==
X-Gm-Message-State: APjAAAVqjcZMQhDH6nydrPEE+5f2f6qDs0wHP9bie08qVO6aOqcMb0lh
        fUKORen1u/3+IZdvuFx/euzv6pkH9n1xJQ==
X-Google-Smtp-Source: APXvYqw7bv0smflhO5F+Inai8isEI6TS9jOLRrj21GUM0d2HJnf3WroQvFCdLLbUZkOBnIihA+qd2A==
X-Received: by 2002:a05:600c:20c3:: with SMTP id y3mr13755210wmm.3.1565393863392;
        Fri, 09 Aug 2019 16:37:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b186sm6617612wmb.3.2019.08.09.16.37.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 16:37:42 -0700 (PDT)
Message-ID: <5d4e03c6.1c69fb81.624b7.2dd4@mx.google.com>
Date:   Fri, 09 Aug 2019 16:37:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.66
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 70 boots: 1 failed, 69 passed (v4.19.66)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 70 boots: 1 failed, 69 passed (v4.19.66)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.66/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.66/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.66
Git Commit: 893af1c79e42e53af0da22165b46eea135af0613
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 38 unique boards, 17 SoC families, 12 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-nanopi-k2:
              lab-baylibre: new failure (last pass: v4.19.65)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-nanopi-k2: 1 failed lab

---
For more info write to <info@kernelci.org>
