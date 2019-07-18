Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828306CAB4
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 10:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389194AbfGRINh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 04:13:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41283 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfGRINg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 04:13:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so24409027wrm.8
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 01:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=m6v76uLNAhe76m2yoyYYvuAgJjHyuB/rHa+1oEoNBb0=;
        b=pRCoCqYGnIQwmZu4xVl7CEXyBEFk/9L0iLXjR7aGAB2vp7+gw67o20do9fAeksGocd
         XbbBYw/u0o0JqIqJnv/pPRlIkWaw165VoRkDSjS5Fm7jAdP72ByfEM1tlwyL2VVre1Dp
         4k4WdY2WjNeC+2ifTAHxlY0nxKhPBLfkqY7xlEzcGivTGSYcaLhLW8TN+ebz0T/pjRyw
         X0uWiUCSKqapLajTWydLgUvK927yObzfQYhBqWTj2mf//7Hn7MFdesuPwcbSzytvldor
         S5qcAXtf1LATqgmz/0pyeSGQDtTTqrM5XcnSAaPJhh+kG4NfFjFw77t7ELcl07xE9v4J
         9nWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=m6v76uLNAhe76m2yoyYYvuAgJjHyuB/rHa+1oEoNBb0=;
        b=LJ8iVYXRZ0mPOeuw4UhIyhzIchCZj6ek9iUZIppWpnkIJ52v+ks7d1UJb6p0eEoH9e
         877PrJNtZ+at0S0/T7+DyfLM8qqHl2Xj+rjqqUpBV24SmRgSfYWDJcdrtdk8o+sZb6Zk
         JkzGtp3tunYQYAmHuPl1YR+Byniuyq9JC7yNL7cb14UB2ge9ciQXJLvAtQ1m2Me1XMzp
         cVfQbJnk3b3snugt878DQB1eV8VTS9Vqr8SgjI6EdFJYxU9UmS6hd05+EHxKRDpp0uSC
         PseuDlAANH6dRBFftFv2I5rA0f1C6hzzzZ1c0Xoet1HQzcjwMWjdr7gE1wycDIT0+/DE
         OPzg==
X-Gm-Message-State: APjAAAULuxVkzQyHcpMNfulR4aj3CLbgM+38hpjgBrwDuOC9351CX9l+
        mBAp3b9Xs/Wlm0XJPCG3ok8=
X-Google-Smtp-Source: APXvYqzcyeCwvwpGtTktRsBdDdXx3d36SaER6ay6RWE/VnDIbQzRaUsqvGTHkb/TyzNnkKTK5xdCwA==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr48994744wrt.84.1563437614808;
        Thu, 18 Jul 2019 01:13:34 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v12sm24741416wrr.87.2019.07.18.01.13.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 01:13:34 -0700 (PDT)
Message-ID: <5d302a2e.1c69fb81.c9c31.a2fe@mx.google.com>
Date:   Thu, 18 Jul 2019 01:13:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.59-48-gaa9b0c7579ba
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
In-Reply-To: <20190718030045.780672747@linuxfoundation.org>
References: <20190718030045.780672747@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/47] 4.19.60-stable review
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

stable-rc/linux-4.19.y boot: 127 boots: 1 failed, 124 passed with 1 offline=
, 1 untried/unknown (v4.19.59-48-gaa9b0c7579ba)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.59-48-gaa9b0c7579ba/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.59-48-gaa9b0c7579ba/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.59-48-gaa9b0c7579ba
Git Commit: aa9b0c7579bacf570e7e430fa563e52b6b4ab15f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 27 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          sun50i-h5-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v4.19.59)

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
