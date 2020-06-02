Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A4B1EB30C
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 03:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgFBBe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 21:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbgFBBe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 21:34:29 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4977C061A0E
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 18:34:28 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x207so2402704pfc.5
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 18:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2nCB6KfGE5F7dL52MonketMWVqYEUfX3t2dozAragFA=;
        b=XXvPjvV4E/eSVojHsimMMUQYk75iNnQqtX61FmkSF81rvozmQ2yR8PhP4f6BYuTk4p
         Y1GtEjsOIMRVDzIXB9I6yG/RUbIcoyXDgFJ6ToSSA6hKgKNvFCfSHiY0iBEwK/ggAJow
         BrZs/qmkAeo2mZymzE2otVwFeklzqWp4vu89avXuhSY+WkI0GvYD19r64pS/3Gvm+knU
         fdg4kgCKkNAi2Pc3nMbiDSyY/8oB9D4pYWprmoZBjabN3e/UGmIoDWOLx9f7PwCHzSNe
         k9CZ7JR7WAGOKCViEhioeCozKCYyjI2J+s35Am89eIwiOMjE2gZsBk1gm+odiKtvZuks
         6tig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2nCB6KfGE5F7dL52MonketMWVqYEUfX3t2dozAragFA=;
        b=HnWwZuUfOmBgJXognygUrq5yEoHPJpcjbYwjzL7fVv8VgOdolPvDUjTb6RKY7/Umxf
         94RWa8BKz2vGpzhO1Fdn2b0XazyQl3anFDjmbaNjHFqwO6pMdBBnfE1CsUP6WuPMlQwZ
         7pGYV1/vcvKpYezpdtTbD/Pn5Zb0dnO53HG7TM9eVyTlGPZk5VDY6lOk4vHTPnUumRl2
         4fnpGa/uzrLy6ORhGiZ3vvt/rnFtSQ1tLE3D0R75eSgKJnAw0Zvq/YYIY8mo6vMQaqw1
         OsLHQiyEpzRqdW0JE0q7Qdy0vXmZYnmZt92Er0Djr9x8mby3rgHnoSAfYboJI5Y+bJY7
         +reQ==
X-Gm-Message-State: AOAM531QfCdFed4oTQ1JdmCJLkNhTCj/G4c26SRxEgxeKoNuUlX55P7K
        AKtdwNKm7tj1rSboEOU9OnhtkcN8uBo=
X-Google-Smtp-Source: ABdhPJwYv5b4pDSBOaxZtqZXNgRGsG9X49C5A4Q7AjngmIbirOpEuCDA5eoOIsqj3vct1AfHHWw53A==
X-Received: by 2002:a62:194d:: with SMTP id 74mr478274pfz.21.1591061668080;
        Mon, 01 Jun 2020 18:34:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w24sm556475pfn.11.2020.06.01.18.34.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 18:34:27 -0700 (PDT)
Message-ID: <5ed5aca3.1c69fb81.84db2.2731@mx.google.com>
Date:   Mon, 01 Jun 2020 18:34:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.182-78-g9093a4315f91
Subject: stable-rc/linux-4.14.y boot: 55 boots: 3 failed,
 52 passed (v4.14.182-78-g9093a4315f91)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/kernel/v4.14.18=
2-78-g9093a4315f91/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.14.y boot: 55 boots: 3 failed, 52 passed (v4.14.182-78-g9=
093a4315f91)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.182-78-g9093a4315f91/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.182-78-g9093a4315f91/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.182-78-g9093a4315f91
Git Commit: 9093a4315f917688b56194625b7ad0e407705072
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 13 SoC families, 13 builds out of 146

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 102 days (last pass: v4.14.170-14=
1-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
