Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8F58198892
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 01:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgC3X7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 19:59:04 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38958 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729060AbgC3X7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 19:59:04 -0400
Received: by mail-pg1-f195.google.com with SMTP id g32so3431626pgb.6
        for <stable@vger.kernel.org>; Mon, 30 Mar 2020 16:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7wFM+Cb4cz+GQFv+26zYmiHYoUf347S8QA4v3qayF6Q=;
        b=WvCZ8oP3rzrk4IXtUxKYgpFASRU+6JLVQHXjh4t4ScV7RBW6mn4XSQ3OpUlmU1SYNH
         czvnXpOgPuoS3YQEJbtUtL2mLQ9IZtaTTyJCf8Q/k6qSIvvpsQPYjnZSqRB3w7RtzWZe
         kuiWXZ3SvK5AfCqv9xQ3jU3YmmfC9LNrhNHJx/I69OmpoQSABWwbE8ED86PUjjNSAcHA
         q5ObffrXE/2jyBQyZdW2tQwZukT3tF/AJ22u3jQtiPP7uLNOQ/6gdTgf5I88K8zfgqHM
         t9OHHz9EZuT26I908kcKCCSuQz7snRJnqujiKrQ97GL/mm0wG5jJmtzcMkHrbfCIXWkl
         WaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7wFM+Cb4cz+GQFv+26zYmiHYoUf347S8QA4v3qayF6Q=;
        b=chcxpwVwMl1TZJgvJsnLxkKeeLenmLAP8zkycu4+crz0V09iBVnZncy9zmG21RLjCd
         9WfJg/m/gQxp078shGyC5T9oZK9xCRf7T1vmSzsy0mnpPNLnP92l8CPuu41ze1YiiwWb
         AEsw3AHsfXP6dNa5t1gj+wWcMeUzbbd9rLgrhRaFbvLqM1HmV5jqWol48GHDLbB0qnbh
         PzvIi7PH0siaAn5G3tVjgr2UarXhdJrhD0N/U3iaklncqUo6ilIlBwL9GL46vSAQFC64
         PLVg2Mu0JviocQ23jM35JAA1sFyM61zSYQCdg2bGw9V3YucCTdnwpRN4j7nU9Rbj9y1C
         U0DQ==
X-Gm-Message-State: ANhLgQ2yDwl7+9wROCK2SzX59GThlMbhof1ULJWfhp+v/TxnxsG0Vdki
        bpdtlpng0Fx/ma7c1cbCp2TjSKhXVMw=
X-Google-Smtp-Source: ADFU+vsEwdq6cJT8U5R5rJva/0EFjz/+9TvHql086iTv3YzWBE6rJSmYZzAnAq5CAXst8IJt6fVBTA==
X-Received: by 2002:aa7:962d:: with SMTP id r13mr16049135pfg.244.1585612742619;
        Mon, 30 Mar 2020 16:59:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u13sm5574527pgp.49.2020.03.30.16.59.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 16:59:01 -0700 (PDT)
Message-ID: <5e8287c5.1c69fb81.431f7.906b@mx.google.com>
Date:   Mon, 30 Mar 2020 16:59:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.28-135-gfc116ea9867f
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y boot: 102 boots: 0 failed,
 97 passed with 2 offline, 3 untried/unknown (v5.4.28-135-gfc116ea9867f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 102 boots: 0 failed, 97 passed with 2 offline, =
3 untried/unknown (v5.4.28-135-gfc116ea9867f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.28-135-gfc116ea9867f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.28-135-gfc116ea9867f/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.28-135-gfc116ea9867f
Git Commit: fc116ea9867fab4ae88a4059b5a1888ab0f00a76
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 22 SoC families, 19 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 51 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.28)

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
