Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05FF6156EA2
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 06:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgBJFQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 00:16:37 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:38254 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgBJFQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 00:16:36 -0500
Received: by mail-wr1-f49.google.com with SMTP id y17so5849365wrh.5
        for <stable@vger.kernel.org>; Sun, 09 Feb 2020 21:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zb5XdEMdVR225eCBYiXk/1HUa1GBjssndx9S5a2BoMc=;
        b=tgDpNcljEoNy433GYGGtHBn4whsm2Ll5bYkAuQp/KFZ5E3l+n7DBVwwU34lsfsIylF
         h4pxNcQlbmawdIiTLAWxbQ/2WPGjlCBfxbSBBfNXTW5GCLi59rCd4OYj4vQdoXzWb4YG
         aA1qNOFbY7XV34wLHkcIutDf12RLerg1VIE2p4tplnMltIG2dpkwbP5cVzxFzHH4AD3X
         wx0o88bZDkuvQc5qvBUSX7lweuHpjo7trOS75LY+yl/3NKadk9w99ethGFPSiwJchRkm
         B9aUgipapOLcNV5loM5s0v3Px01cJystd2Om3fh+Ooa9kziO+lgNQvCDeCqIAll6r47n
         DdIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zb5XdEMdVR225eCBYiXk/1HUa1GBjssndx9S5a2BoMc=;
        b=Ttd2C+tIO5UM0kT7itTU2j6SSZwAdA/eO+3CbbXa/Tv1jUw62RpVZhyoy8I8BfP82z
         pihrS/+uNw7J0HutNcvqZz4DTGbq06ZVkRjivcLmn2Hm2ppL/s0RJ717ZEHewSAf1+LA
         gIYa7ICaKrckt3glzNo0gIaLOO7VDvQCAgprFKj4veV9VSE8rtBAQSkwLQ6o3vT7Vu1B
         O3BcDeTdVaoPU24NwdC46sglDHeMbT0oyyG4zV6pCjGR0WwyBrRk/p0WqnGG8OT1rK/f
         cwNi/ic3EW2f+lCccdS/lEDa28QfBpXcuytO4Orc80IGSDsWTN2UGlLyiV15sfykuB8u
         1QIg==
X-Gm-Message-State: APjAAAUQScrdrBPSLFqtdpfWpO9rJj18eWlRrN50tgkwixu1BdRQJJz/
        gLDPDGQKMnDfSFKYG3uYq1BIfIvwszw=
X-Google-Smtp-Source: APXvYqxejPL7n6i6+I0l2djkyKr9pLZJWhKotLEdR1EFelkf8SZRMqakGmzABjSdPg4D2i10+zP3TQ==
X-Received: by 2002:adf:f986:: with SMTP id f6mr15309460wrr.182.1581311794583;
        Sun, 09 Feb 2020 21:16:34 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f1sm14613584wro.85.2020.02.09.21.16.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 21:16:34 -0800 (PST)
Message-ID: <5e40e732.1c69fb81.9d4f2.df73@mx.google.com>
Date:   Sun, 09 Feb 2020 21:16:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.213-80-g5eb5593c7143
Subject: stable-rc/linux-4.4.y boot: 7 boots: 0 failed,
 6 passed with 1 offline (v4.4.213-80-g5eb5593c7143)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 7 boots: 0 failed, 6 passed with 1 offline (v4.=
4.213-80-g5eb5593c7143)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.213-80-g5eb5593c7143/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.213-80-g5eb5593c7143/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.213-80-g5eb5593c7143
Git Commit: 5eb5593c71433de621eebd96ba4e06632da3fd9f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 7 unique boards, 5 SoC families, 5 builds out of 119

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.21=
2-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
