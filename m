Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FB51E713D
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 02:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437668AbgE2AYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 20:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437659AbgE2AYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 20:24:11 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEB8C08C5C6
        for <stable@vger.kernel.org>; Thu, 28 May 2020 17:24:11 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ci21so339875pjb.3
        for <stable@vger.kernel.org>; Thu, 28 May 2020 17:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NCRYOipOZOFRQZxkWR3WPl30ZiL0jGuOj0nOW6OT1rg=;
        b=StAUGOFDaLwfBHvTe9CCVxLYk9K6pl2E60hEmIcdJXouHoO8irp/iYWn6KELwcj1w4
         v44aMvufv+3raZE+aGp95TfvEqTvxS/DlQz0L3vnfI/JFcq1GxNyJC6xkmU+5rurJpSa
         9hTdrpRfRHayWpo8XagoeuHQztKmU0DDIrOiScEnSNCB9hqEQ++EU2IoRUdPZTKznSsV
         d6/IJwUX3vVlGBpj9W+YWFxI7rAg7eOqHD7LMDDpadg1pJ6dtZiBeboDq2qcczp9Hnae
         27dKi2T84Mn/gHnDKYRF/MK0qL7fFaQx1w1dKgQ23CsYuAryLfy4QeDlKkJVALSud3oq
         gliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NCRYOipOZOFRQZxkWR3WPl30ZiL0jGuOj0nOW6OT1rg=;
        b=oEaTyKBq3rnPS/YZrhmTjRjjJX+CQhbg+D6uSjR9wrTQdR3y9W8+W8jJZ3GrNp97+J
         bwChNiY0nU4MQp1bI3YnDyYSzDD77AHQC2NhqhjUmFXcsuD+L54+Fx2HL3jGNECnqKFK
         PKGFS4bB4ANeDReoruaY4hR0sFqNlW4ZBKjg2A6tKU9Axfx9qotOZd9CSIURk72NBfAq
         zuZVMFwD+3D3W4Px4bNhYMq6ytcGlyf6oBPcw+4ewKb8qO0cNinQdhmtRK2EMgKotITZ
         AZyr7oN74DRqV7F1l4DYn2lCYkUUsOsusERUIowAOCCLfLhs8nzIZCG/8WLbwHRid423
         wH4w==
X-Gm-Message-State: AOAM533i4mr33PKVHjRUWJLTm3E/2XvrHgK4glD93t4n5+P+WT74hBpW
        muN2SIaARVIMCEw4fmyIWtiuGIuGbrA=
X-Google-Smtp-Source: ABdhPJycseW8tTaAK34ze7wHuCPNeJj4gFLeSUo0lQU/cnQn0xDImUwQI/9ExYzgbytbgo8YvmM2gQ==
X-Received: by 2002:a17:902:fe06:: with SMTP id g6mr6110280plj.118.1590711850283;
        Thu, 28 May 2020 17:24:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a5sm5668711pfk.210.2020.05.28.17.24.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 17:24:09 -0700 (PDT)
Message-ID: <5ed05629.1c69fb81.83c22.02af@mx.google.com>
Date:   Thu, 28 May 2020 17:24:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.182
Subject: stable/linux-4.14.y boot: 79 boots: 3 failed, 76 passed (v4.14.182)
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
https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel/v4.14.182/p=
lan/baseline/

---------------------------------------------------------------------------=
----

stable/linux-4.14.y boot: 79 boots: 3 failed, 76 passed (v4.14.182)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.182/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.182/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.182
Git Commit: 4f68020fef1c6cf1b680ffb6481ac41379283ea3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 46 unique boards, 14 SoC families, 13 builds out of 161

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 126 days (last pass: v4.14.166 - =
first fail: v4.14.167)

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
