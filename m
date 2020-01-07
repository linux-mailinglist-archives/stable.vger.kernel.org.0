Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4813133723
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 00:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgAGXPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 18:15:24 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41829 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbgAGXPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 18:15:24 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so1401404wrw.8
        for <stable@vger.kernel.org>; Tue, 07 Jan 2020 15:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=shJ1g8+UhlVzNXS1CEW4BcaTYz0Y21MywhYArfyxndk=;
        b=EgfPDpZhGlBUAYEp/PRTpZUo9MjoPZW6ICnRcIGc+m4VoQidfkc1TMrJbUqfqKN7fF
         EWhrYphWMaEGrvXxPsBMrwbne1SV1Mt45UJE85N1KCre1oJeHlD68Zg1LLSt2MqDCdV9
         TnKX7mwa2p3tMuTNi+i55vdIJ+jfZZzTgkVZ2epePy6PYPoMvVB0UBrYlweyx655felI
         3zbTew8D9tJaDJizBD//ZdlrsAvjp0o6uG/QrEXKCpaECBM71aBRJWRK1XYnZsQBSUEq
         WBys5LqspJ+Qap++hQfS3j1iXDysfqj0wp/KDXfrV3Mi9IW9AjcKoik7IF0rxhM+t0CI
         CWvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=shJ1g8+UhlVzNXS1CEW4BcaTYz0Y21MywhYArfyxndk=;
        b=OifeNamvl1bDDoHxcNPSRIRMGUT+vUtlrFjMfjNyLGOsDSEQwWZ2sb/vOSpvN5yJVo
         p+gLuDHa7XbsgwTgJIa1BwiJNe80ThVA3rldMlraiW+rCDw+gx84658lXyDN0BujyZJQ
         QVhtUtTROmfpqDDBEtVwjeBkBTEXixILRAPY41CHsudb1X4BwL4zr4Gdqu1qaXRXTsix
         vs32ARWlBMivXr5UDqlj8TT6S76aZy6Kb6Ho2HDe8Xwfph+9Ygs7CDJVHwh/opA+hlMd
         P9qZ7mCImg/sdzeTiOvEhmKF7ys8tO628/EntVvMuIK2NlhOwLGJoNm1vUjd25wq4js3
         TtVg==
X-Gm-Message-State: APjAAAUBQp94SCSb6zE5wn0bMx7fLrWO3O6BXPlAnp2q8i+7PTcmKyJi
        AyY1QJjdUatj57wKXK5V+R1snqtwMacrBg==
X-Google-Smtp-Source: APXvYqwM8J6PK+M+RWJhV1sJz40gBtIW2jzM4uwM6Cv7eSbZayDsOcnaMxczHJoDgH/SqqPvWdGVbw==
X-Received: by 2002:adf:fe4d:: with SMTP id m13mr1215292wrs.179.1578438922308;
        Tue, 07 Jan 2020 15:15:22 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i5sm1796051wrv.34.2020.01.07.15.15.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 15:15:21 -0800 (PST)
Message-ID: <5e151109.1c69fb81.db363.9540@mx.google.com>
Date:   Tue, 07 Jan 2020 15:15:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.207-160-gd71a25a44549
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 46 boots: 0 failed,
 45 passed with 1 untried/unknown (v4.4.207-160-gd71a25a44549)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 46 boots: 0 failed, 45 passed with 1 untried/un=
known (v4.4.207-160-gd71a25a44549)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.207-160-gd71a25a44549/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.207-160-gd71a25a44549/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.207-160-gd71a25a44549
Git Commit: d71a25a4454908ef8d0a2851e003e180ca1cd9e7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 9 SoC families, 9 builds out of 190

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.4.207-138-g8eb04883f=
217)

---
For more info write to <info@kernelci.org>
