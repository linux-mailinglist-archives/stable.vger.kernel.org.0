Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6841AAFF5
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 19:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411200AbgDORmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 13:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2411435AbgDORmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 13:42:18 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1B6C061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 10:42:16 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m16so273635pls.4
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 10:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pdrsUmPvMfwD/lDZfnnCN98c3Jg88gBO5op8Rtz/2hI=;
        b=SSIcIrB6jb4R+SD57YOTVWijQ3rVsfasP7L8frtkLi/hxHDn/qmV0lDQg44mZeSD/g
         Ugro6XkVSkz9DOk4c+b9mVF94nF5n+rNcFgVKvVoKGnn/qr1I2MKjqvGsAW6fw7WLbOF
         7/l8J2g6TgRiQt8nxBP5yl5o3kqQ3XJsDB6CXZoR4kT05YubVzLvYdb70TQSKG5lLtlX
         upkPo6vY5FHqNrmFJQuM8TUPZeTiEMiINCw4C4LPPMfNIrpx7IQfHPRnqerZMu7+R4Uf
         CfM+K5AM6+JY+UPW6SG5UB+edEYbKY8RdDJ7+iX4PzagXCFNCdLnEPh/2OeI0165ReBu
         bdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pdrsUmPvMfwD/lDZfnnCN98c3Jg88gBO5op8Rtz/2hI=;
        b=HJvFDtmfi8TI6ZM1HHhAorBdJxDsrG3OmbiAg5TlxnNYSP+Bc+7huUf8X6yPMqcLxy
         hboOZICCxqZeM7IN6A3JM8gHsWpvRU+iGEOgxLPXQf91ai+OkGdGbrOQ23qLVQqGvPIv
         +1X92Mv0FZi+Z1OE6urVNtCYNwUUgscvi8KG2r/VEsi6hsYNx9hXhFrkvTPAuX6mmoXd
         MTsM9vkjiEDWVlNl3OgyaN1tTz/dhLy6vXDo42WLK6CFlbwz8ywjYtUtk7UyppXCovVX
         BE4eDEYaWORV+uNuuOmTSz4s9zrRfWFGBTTpt/KUfcN2tQEsigPcfegMrh77T0axq777
         yqBw==
X-Gm-Message-State: AGi0Pua/8AMpBZFJ6MSFSzQC/5uHwwV0pieu6MkTaWyRrIla8Q0CGIf7
        eyhrgcDhqxCwa9eSw1mIoLzSIZhibB8=
X-Google-Smtp-Source: APiQypK65KDNxqmMjyXINNRxACuec7aZo+JldCcslBHVXV9BcGJ/yeI53IPdR02v5QioJh/GOXMFgw==
X-Received: by 2002:a17:90a:8cf:: with SMTP id 15mr406725pjn.136.1586972535587;
        Wed, 15 Apr 2020 10:42:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6sm161378pje.37.2020.04.15.10.42.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 10:42:15 -0700 (PDT)
Message-ID: <5e974777.1c69fb81.99e61.07f8@mx.google.com>
Date:   Wed, 15 Apr 2020 10:42:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.218-92-g79de6a233fba
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 72 boots: 1 failed,
 66 passed with 5 untried/unknown (v4.9.218-92-g79de6a233fba)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 72 boots: 1 failed, 66 passed with 5 untried/un=
known (v4.9.218-92-g79de6a233fba)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.218-92-g79de6a233fba/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.218-92-g79de6a233fba/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.218-92-g79de6a233fba
Git Commit: 79de6a233fbab627c6a8dc94993148b77b3bce71
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 37 unique boards, 14 SoC families, 16 builds out of 197

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.218-33-ged218652c=
6a6)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
