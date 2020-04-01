Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8523919AEF2
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 17:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732861AbgDAPlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 11:41:45 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35443 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732849AbgDAPlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 11:41:45 -0400
Received: by mail-pl1-f194.google.com with SMTP id c12so36543plz.2
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 08:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w7W7qPHY58e50iif4utpYYxr8bUJUhO1IOG+jAWj4Ik=;
        b=HEFUdinyV+YfALKzmjrxiLq0Bu6cCJLJa052LPFuPPYapZpM3RpwyLV2B+SqUds+Pc
         Am6i2azcPPlFqOoNXBPuJXuXxSHNHE+QQ3tgXr8RaSGSX4cuF/bWcTNLbWpU6wTmqqbx
         9IBram3axwU9aKG9n31wu92syr0dYIle39Vt5qXWCQ70gQyetinIFOtIs8Xc2pTzW58s
         hxZiK91Nju5IlbtmTCaQcBrm6D/ujyook3w3GumYHIzmDWYpEjsKczs5JNJBMhh8PRte
         yi1Rs4zmbHA5WoxWCvHnp3h4iX0OWg7sCxpdb1tfg84bW8gsi8njJuIRq3FqHeae0pep
         KadA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w7W7qPHY58e50iif4utpYYxr8bUJUhO1IOG+jAWj4Ik=;
        b=VJMxIvXXyBRwArj1yMu3iyjyiFuERGnENeJp7Gx8vQaGEd+GmblUFIop9ZAOFVQVTq
         p3GrK5mODLYrk0X8e8hCXSG0ZgbF5Jz89aQLTx2KaK1I1syv/JwXjt24QcyCauxQev92
         tFAwbvIHN+jUkmzFWuBOg5ZmIU1SfHm2bBPlCy4EqlwQhfKmYj0HjiXsDBaMVTe4I/SC
         KbDZL0mBAaifvooW1zCcgJu3DxnQG6CM56Nv/fhjVG1y7S2+Wz1f1nwldIzyHlFGrBlj
         kWkj/vC10lB8E/JbpfFqnXS1lW5IISOrWi8s5zjHzI7QJMS87Mv86SftfQalBoyEvtEp
         ouIg==
X-Gm-Message-State: AGi0PuaDA4jtj5Fbmz7N2rvLxAAlFgQ30HYbfobaQm18OxjrONNYmFwq
        cJQI4/IcKYCd/gaFn6Jb2UMjlGaKQqQ=
X-Google-Smtp-Source: APiQypKKTkUEboPWgRLwx03pqYIpYNz6MD0t5edbNSI1oG2YgUCem0YnForhAMvX7SHJTJzStgG4FQ==
X-Received: by 2002:a17:90b:2397:: with SMTP id mr23mr5471932pjb.88.1585755704198;
        Wed, 01 Apr 2020 08:41:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s22sm1786600pfd.123.2020.04.01.08.41.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 08:41:43 -0700 (PDT)
Message-ID: <5e84b637.1c69fb81.2ff55.7e64@mx.google.com>
Date:   Wed, 01 Apr 2020 08:41:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.29
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y boot: 112 boots: 2 failed,
 105 passed with 5 untried/unknown (v5.4.29)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 112 boots: 2 failed, 105 passed with 5 untried/unk=
nown (v5.4.29)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.29/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.29/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.29
Git Commit: 73fea3292b4995fe5c20f774421705ada0e62100
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 72 unique boards, 20 SoC families, 19 builds out of 200

Boot Regressions Detected:

arm:

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-baylibre: failing since 14 days (last pass: v5.4.25 - fir=
st fail: v5.4.26)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            msm8998-mtp: 1 failed lab

---
For more info write to <info@kernelci.org>
