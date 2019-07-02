Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E540D5CFE4
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 14:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbfGBM6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 08:58:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35698 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfGBM6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 08:58:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id c27so10022099wrb.2
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 05:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O5vIxyRDitZp4hef4Nb/tqYl9l2/zRSBwPp/uo0ZsNo=;
        b=MRl56aTQEOVrxuX0nEG+vhcR+duHjL58U5pRmJ3aIXJSRYTMfNLV2obK7ZaAEME7gr
         47Il0uhhF7Vmdp+Ldm61POsDQpOK6zuyfXMtRLsaVoAppHNr+X/Lk+nnneDyGFq9BLr8
         Fyyru78PiwH7YGHWg7J6r8A9mdMmj2wQ0pm27CzI86PfOk27HehUZnYv0tpx203THcX0
         VWAI4O+DKa9mLz7chQFFFSSzM104M2CqldX9O92EoGfL4Q9lDq0t54r9lG1XuUgyM7Fz
         iqBCDeyLBT4ovdWDHLcshaad3IY/mBqV6egDA9BGg5jsKgafpIBUrPD6ZqzMf6lsM3QA
         D4VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O5vIxyRDitZp4hef4Nb/tqYl9l2/zRSBwPp/uo0ZsNo=;
        b=uWO0jNLaCrPkmnqScnf1IixUTvxsJrb6XF9jhAPZHVBM9iVimcWjG24aaMNNFAZt4T
         tG9WKnlg3mqDGVofwqsbtis/7yCvMNHrsVY70gaxVxPju7LcgiAtYwcZEdsEecxmxsVO
         ouoJEFY3+so5WjOymsIrGnIa1yDEyc6qULS+rmoy+mkMPtsOTzbkqRaThc6cdvp1rCFl
         s29ZQaWdR7i6dzFlBeOkoVLfgjsQBDQqOmCI5Qly2c2iNvLChT1beTE3ZkKwpxyuMPE6
         GHQtBW6sI68GPNb8pg2ukqNhwEtP4zJXF/spxVVv0kyaTjVMa/4PMTG36OeEgn8xRIX1
         cnvw==
X-Gm-Message-State: APjAAAVeTMpPNkJkAq6IP3/2obzltj57BSsH7xwT43W78eoA8QtVOCdc
        VX0wvtujCCfPb/6EirjGSkh5YKE5+cPT7Q==
X-Google-Smtp-Source: APXvYqymy5RDnSynn2MSSlfNcb7c3HWFy6uPPT1JSGN/d7JJsig5/w4VoG6HWDmePcnzetVvxv0NSA==
X-Received: by 2002:adf:e947:: with SMTP id m7mr13017206wrn.123.1562072323285;
        Tue, 02 Jul 2019 05:58:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n14sm30204275wra.75.2019.07.02.05.58.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 05:58:42 -0700 (PDT)
Message-ID: <5d1b5502.1c69fb81.8bc73.465f@mx.google.com>
Date:   Tue, 02 Jul 2019 05:58:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.184-48-ge8bf9383ebc3
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 97 boots: 4 failed,
 92 passed with 1 untried/unknown (v4.4.184-48-ge8bf9383ebc3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 97 boots: 4 failed, 92 passed with 1 untried/un=
known (v4.4.184-48-ge8bf9383ebc3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.184-48-ge8bf9383ebc3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.184-48-ge8bf9383ebc3/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.184-48-ge8bf9383ebc3
Git Commit: e8bf9383ebc3547d8fdb5f12a89d2ac8fc0b49c5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.4.184-48-gc9cfb526e8=
ad)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
