Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 491AE1514F1
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 05:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbgBDEZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 23:25:28 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55482 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgBDEZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 23:25:28 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so1673180wmj.5
        for <stable@vger.kernel.org>; Mon, 03 Feb 2020 20:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FYAvEd0dWKqIVgutrAzYOFnAmorZjStjveW1BIar0Ls=;
        b=v8+QK0D05I0YW3CdtQ/RuNNC/QpsNjv1vuq6SrRoH4ULpB/PLN8pZqWtgfzkPd/0I3
         Pfep1CRLJMV7PUCuxiXXrEBRsVOAFpSUCRrhN3Pz7bRFJka4sk/j2LZOGhWfVrnI8UiZ
         zi5oukwh7718/w+AdxcLuF2JE9YmO77kNipTRHe66odlPO8vwsQoIIeEHE4xOFshi3w3
         +iK6Sv57iNj2pxukKo2898+JMVYaSMreB5h6XyJGGqZVjbzpkswmaUGRSGjeg28YwuT/
         ddZsQRR1weF3cpN1StuYhiS/UIaKEL5gttyMyHdC0TFMyJqh8wcM8oHdLViFUb3CRVjC
         yEng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FYAvEd0dWKqIVgutrAzYOFnAmorZjStjveW1BIar0Ls=;
        b=XTl7ywe0azfGuswvFQjWCHFU9XMyKq2StQKTOXZvmSdCQP+mkYNnCOZgfj6xZ81cf8
         b9R0BUScmBlsxpthsnSexLivUE8BrLWoMSyG+82NMNzTCB7NhhW8Yv9SsLIFCPSQJDRH
         av21D0HiwK1xSDTde/SY6CpE3CcKFH0eiTyl3rSweSlZxQeztzSPijyuwErgVqNcOwk7
         XmoPtigWb9eMajk6aCzBPpzITOvUu+mqWleq43T+ezyzOrtUWq9R4M4Q7jLoNmfKEbck
         dF/tNH+w1rAaoJKTijmnRAAYLYTSq1LsYYC6vOxRwsp+BDMtawaPRFOFHH3c6xs1oM23
         mEeQ==
X-Gm-Message-State: APjAAAVgugyzgIxTYk5/YEt5h3FD77Fh/PacqMBYNlh5fezcY4fqoXdD
        xnCyqMpJUOjOrrTld3/XSlmF56h0b4tb8g==
X-Google-Smtp-Source: APXvYqybwk3TxOSOSs/O+9toGYtGjtLbrGguDTjuK0k31f1Vw4r+S09/cy1DqTa+PvPsuSPNNCotrw==
X-Received: by 2002:a7b:c847:: with SMTP id c7mr2827042wml.3.1580790326452;
        Mon, 03 Feb 2020 20:25:26 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z8sm28166215wrq.22.2020.02.03.20.25.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 20:25:26 -0800 (PST)
Message-ID: <5e38f236.1c69fb81.22b4c.9fa4@mx.google.com>
Date:   Mon, 03 Feb 2020 20:25:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.169-91-gb5f2cca4b424
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 72 boots: 2 failed,
 68 passed with 1 offline, 1 untried/unknown (v4.14.169-91-gb5f2cca4b424)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 72 boots: 2 failed, 68 passed with 1 offline, =
1 untried/unknown (v4.14.169-91-gb5f2cca4b424)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.169-91-gb5f2cca4b424/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.169-91-gb5f2cca4b424/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.169-91-gb5f2cca4b424
Git Commit: b5f2cca4b4242901ae09e17d595a27a298bb83b2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 20 SoC families, 12 builds out of 170

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

---
For more info write to <info@kernelci.org>
