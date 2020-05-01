Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08F11C0DB6
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 07:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgEAF3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 01:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgEAF3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 01:29:42 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAB7C035494
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 22:29:42 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id y6so1937190pjc.4
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 22:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rSDnzE263hh7BnWrRxqLWLnXFcIkBH1IvnRTPrDcWNM=;
        b=g3sDU4xT8LPPRgzeAPOx2gLLRTxeNG/nmndx0ttY84gUAafU/p76WmgnC0F6qU5JIt
         Ga0CMLVyjTxOg2RJAq8VOc30rkbsvgXZHVwLn0678fQmW/RVphpClmUqBMh7nUo+TlrE
         pP7Ggj/XOBKuvkl3GYCOgGuqe61XJe2vOWfL+SXKyr3vzLhepSthSjagpnNOEwi+K4nK
         v070JrAlpRofbETePEkYWSUlU9S9cu9kVAQH0Em7fjghgURL8P1lIRPTymaApcGgLMuA
         pTgVSDbbRFgB8WXHhvMoP36vosKB34Q40hj+xabQZ2EyqnLpdE0J5mFzU9hflrN+SWVp
         7pZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rSDnzE263hh7BnWrRxqLWLnXFcIkBH1IvnRTPrDcWNM=;
        b=QWkYIZP1nXbcvnspd4gpHTKV2yaX99988rXojO9l1rJQBXNg9JN8ooed8f7ZhI/ipw
         CNJAeaF8iG9q8p6zt28L/RXyqY5MJY0oPCR3mY1VAxcw0hRl2ylf9ZPEAzcIa548jYid
         B3VlNWTfL3n5ShFYXFuTSgV41PAIMprv8E7I6TIdONnL9Hk7bVmkBP9P5yXghwzQLylh
         K4/h6Pdyk0wrnIi+FthUgu8XWpnQVKzMk07eoZsJKXMsAUlA+/k/l/2nyvUgI5NXcpjY
         1KvbqxbGHxXYb0H94dPimZO7hf/6srpLKzy4LqMG8h/l595zqBUkU16kOFHjgOfCnXtx
         nyFA==
X-Gm-Message-State: AGi0Pub/unHZEEdshD/PLdbADEWFbFrWMrN0L/gbCj/4DbLPJmRXsIWD
        8miDpUbgI4Uk6N2QCb+iXmVqHOJGLeY=
X-Google-Smtp-Source: APiQypKXqZVS0OPtjRCqh/Wtf+RD5uTzVm6OECAwWqofHt/4cUTs2+YA7faPUiAqBEEl4jQhd2f3BQ==
X-Received: by 2002:a17:90a:7a83:: with SMTP id q3mr2586473pjf.162.1588310981716;
        Thu, 30 Apr 2020 22:29:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w75sm1213374pfc.156.2020.04.30.22.29.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 22:29:41 -0700 (PDT)
Message-ID: <5eabb3c5.1c69fb81.d0859.617e@mx.google.com>
Date:   Thu, 30 Apr 2020 22:29:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.8-68-g8fe1aeefcb6f
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.6.y boot: 95 boots: 1 failed,
 91 passed with 3 untried/unknown (v5.6.8-68-g8fe1aeefcb6f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 95 boots: 1 failed, 91 passed with 3 untried/un=
known (v5.6.8-68-g8fe1aeefcb6f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.8-68-g8fe1aeefcb6f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.8-68-g8fe1aeefcb6f/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.8-68-g8fe1aeefcb6f
Git Commit: 8fe1aeefcb6f3029d70d9ea731359d954526f7ec
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 16 SoC families, 18 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.6.8)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
