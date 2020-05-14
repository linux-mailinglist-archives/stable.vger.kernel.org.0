Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24ACB1D30C4
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 15:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgENNMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 09:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726011AbgENNMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 09:12:48 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA17C061A0C
        for <stable@vger.kernel.org>; Thu, 14 May 2020 06:12:48 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n11so1226219pgl.9
        for <stable@vger.kernel.org>; Thu, 14 May 2020 06:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ObOO2GPdoF+ScdPnAnyj7COejxQ0CN8Scho8hzIrg7g=;
        b=uKgfLk5yIRVGb/8w9K850OLdZDFhaJB0IQB37Ms9b2tX+R4ZqlTLzjLeHcq9FHfcOb
         hpqy0XM6JrI6wiInt6WL+qF9gVDUjh4MB8hZ8A8QpjcL/c3E1lDxwJiEH6wZfEg9CMm8
         hchWQVyiKIbhrAhsBd7yi3kg32xJVYyTx3N6gx/l+ED1otHZgzsSJc1DKymsNfqbfu6o
         dspceBexyP/byk0wLT+JXZs70ShWTU1AtCm/6vWGZN3Lbl/AMkZwFWsjYR9habrFFtRA
         Gus/wFQJusySocL25hXax6wl+kKbadH71CDTPoADPialk6vdCFcESa3rIYZbMlcMPLkj
         kSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ObOO2GPdoF+ScdPnAnyj7COejxQ0CN8Scho8hzIrg7g=;
        b=kIhxoqAMeHizacuT4xmjVKDc1sKuYRjTZc6d7h3ZwoPNnUq0aZe8UZct0OzB5jM3IY
         QmQWYJ94hru9WB9GxU9urSkB9YMnvjz1URLXsq6sTnAHsbI373+q6gb9P8Y8itvpYTNB
         NM8ecnzxbYHQwHDb9tY0lNKb+fs9xmO5/3wf0YyIYY9usReH63wp+lSsXaBildj7jAkg
         seh9joehmHD/AJiBW0PJDhMIwQvirRSp8K0COIXqslKidVadz1gu+FQ2wxPRyvzyHlDf
         zPQx3Yo1wbXdVQfBT4I32AhZcylOaSi3a22FbXoo4CbNB8Q2nT7+9InaGJINd/Uxf4tJ
         C5ig==
X-Gm-Message-State: AOAM533FDr/TVZKr/1zrSVAG9zj6NrNL4Tcaiq1/YgjQJ3S5gn8LLPZw
        PNEnwIETNesLReqTh/hiVqNC3jrbNtY=
X-Google-Smtp-Source: ABdhPJxNtU8rB7v2N2em19ZN+Gm/pT5J6X1Vd0RgCKwdWb4t4Q8Bp2Ad8xExGfFOJoe+omIxRPuo1w==
X-Received: by 2002:a62:e10b:: with SMTP id q11mr4563666pfh.34.1589461967212;
        Thu, 14 May 2020 06:12:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u4sm5974290pjf.3.2020.05.14.06.12.46
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 06:12:46 -0700 (PDT)
Message-ID: <5ebd43ce.1c69fb81.43bcd.86c5@mx.google.com>
Date:   Thu, 14 May 2020 06:12:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.123
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 112 boots: 2 failed,
 105 passed with 5 untried/unknown (v4.19.123)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 112 boots: 2 failed, 105 passed with 5 untried/un=
known (v4.19.123)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.123/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.123/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.123
Git Commit: 258f0cf7ac3b788a14c0d01aab3c4aea02f8c86e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 65 unique boards, 18 SoC families, 18 builds out of 206

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.122)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun8i-r40-bananapi-m2-ultra: 1 failed lab

---
For more info write to <info@kernelci.org>
