Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37FCC21202
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 04:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfEQC30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 22:29:26 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:45129 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbfEQC30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 22:29:26 -0400
Received: by mail-wr1-f45.google.com with SMTP id b18so5343423wrq.12
        for <stable@vger.kernel.org>; Thu, 16 May 2019 19:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7eTkygYX6CGbUAoyuJg0tAqwRepdICedloIit4m8QgE=;
        b=S1C3Ubbo6ii71l0+QuG0QgKFumZBssPPmHh35yrtq/0A9GRKILwqXKbcZ4ckqkSdo6
         Ib5Xb6THsGJk3tzCd300h4TUBG3R2zsIFTej8TQXt4Q7TucDPEPt9DBa5ZuIpU5ue9ix
         /zmfHmlzUIF7C2Utvuq1PFuYZn20Sc/S/gKojBdESGFYmMqaswkxg7A6ludb+3U89jk4
         NjGPeoISlq6Xl/MzRdjumXzI+2EikEk0UBkBtrJDZ3jPzDrYcALL6/497oHKEOxEcZr/
         U4Bi4vT2w2NQXP5DuEcWyDPc0Y9v9Y7EMg/qSi4RtSH+LnpoHLSWkGSBN5yg1eqk94w0
         PoTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7eTkygYX6CGbUAoyuJg0tAqwRepdICedloIit4m8QgE=;
        b=nIXP1S7k0xtKrJEgHsi0ZPwghLiqGEkkgyrK4crYR/gLdJi7zrFJd/WV3Uj+a1IuiC
         4rs9tmRcnrtZt2drJ8ZJs0Rm9MWqYEJz5yKUn8Ky6IlFzVkkLlf2T+lo9vOOPkx7Zdg9
         AzBxRBkDek20M4pQQ/7Dbg1H8zB69WY7AZsWMHKUvRccPs6yFhjMLiD7TPGgSvbs4fQT
         NqQ+yVMrsubvs7uzyS3Noy2kPmtIzSNpugNjz/ytU7/t3k8XnNH4+9fHGfGyhg9Y90Ka
         71xhI1FApwh/rVWpz3EyQtPPl/Hkte7hwu5AF4tOEVQnhKD/mOcNYm93yWkhrFADCMKN
         Y+XQ==
X-Gm-Message-State: APjAAAUILgz+8CFI9r6/bclvd/as6jMsqT4IkySMjx+wWw1762MeFeVE
        IwtwkwjOm0TgYWsmMbBVhnEntl1KiwGMpg==
X-Google-Smtp-Source: APXvYqx+ccNQ9fEvlqXqjahVOXW5CR1Jhh+X2YIWtOUN9+tSzhNUzvGmSQQ1oIxpeKEV9qwWgzXC+A==
X-Received: by 2002:a5d:4b0b:: with SMTP id v11mr31553982wrq.317.1558060164790;
        Thu, 16 May 2019 19:29:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v23sm4943279wmj.43.2019.05.16.19.29.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 19:29:24 -0700 (PDT)
Message-ID: <5cde1c84.1c69fb81.3d459.b493@mx.google.com>
Date:   Thu, 16 May 2019 19:29:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.17
Subject: stable-rc/linux-5.0.y boot: 133 boots: 0 failed,
 130 passed with 1 offline, 1 untried/unknown, 1 conflict (v5.0.17)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 133 boots: 0 failed, 130 passed with 1 offline,=
 1 untried/unknown, 1 conflict (v5.0.17)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.17/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.17/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.17
Git Commit: d59f5a01fa438635ae098b2e170a18644df73c06
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 22 SoC families, 14 builds out of 208

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.0.16)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
