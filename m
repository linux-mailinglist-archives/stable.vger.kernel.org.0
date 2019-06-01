Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5D2319CB
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 07:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfFAFti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 01:49:38 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:39576 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfFAFti (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Jun 2019 01:49:38 -0400
Received: by mail-wm1-f48.google.com with SMTP id z23so7122209wma.4
        for <stable@vger.kernel.org>; Fri, 31 May 2019 22:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YGyIL8cjN9Q8AU3MlAsa9qNhpLsGmXRCsv5M82McPnw=;
        b=kSKFinfnuDSQ9O27B9KpjHOxfFUQXVS676DL4fhbO0Ibapeoue9R4KWDz9x/jVHX9t
         wcwRKeMkVq3kmIPc6eWn8zHinmuVQljTxhb7CRl/LIRDr3xS/eadt8tmKh6qVPObb5uD
         cNE+m/cb02m0dKcD9FoQ1JdywBl1CQoyoB6yCfS+gnoH26g3JJMts8aN5fHnUycNZ0pY
         71Az15j4MAfhuP6ahQVauj1Z85z64KpdQuW6vTMEE/IWIXehR3f6/eHBddvi9K1cDA4H
         rSc0lBEq7VmAQH5KknS6dGI6t3O37wEqRsxbianE4MXUaGdLOvDSAwhMUUJa/tvdJpkH
         EjpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YGyIL8cjN9Q8AU3MlAsa9qNhpLsGmXRCsv5M82McPnw=;
        b=BSkXR1hxtsld4pjMf1aqVfpJQDtp4u2gf3W4hVdmNMiiEXEmdQ4J6gOvVYIYEfkPOh
         ABYdr5knU7LCmMrRFVCz2Li6TWg/VFNqheztzzjem5qjF1MJdtqKjx2MxXBWLVcgyWin
         JCo/rDz5tzOrO+z9GCuu3hprTZ1l5T4JGZfwHOYzGOHicMLjTctrPsgqFxLTq7lVp/aT
         5vYIkN236Tdm/VdPD/Wkz25/s9bAreIuUdx3hJAQsM4KuJ179tb6yLaSSEgdcubLHwX4
         zpdfyVo7A5JCa/BBVFk86qVXOBEX5I7RByH1CtTI7oB1xFXXPQ2n3oN/ohoHsPpFMWHD
         p1aw==
X-Gm-Message-State: APjAAAXsAvOuQ0N3FhxrM9iYfa11eUNlGgtyDeApoEMyNexTlftJq+ae
        IaWrQZhh1DSogkdgDUGVFO+koMgrTn0lxQ==
X-Google-Smtp-Source: APXvYqy4oHFgnMo9rZdon5D/xRGPkoAqs4AznTfVmJ7H+CncbcT44jPC7HLflh0MEZuQ2AtFQ4rrHQ==
X-Received: by 2002:a7b:c34b:: with SMTP id l11mr8073600wmj.69.1559368175867;
        Fri, 31 May 2019 22:49:35 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k125sm18555499wmb.34.2019.05.31.22.49.35
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 22:49:35 -0700 (PDT)
Message-ID: <5cf211ef.1c69fb81.6dd14.cefb@mx.google.com>
Date:   Fri, 31 May 2019 22:49:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.180-14-gb172850a7710
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 104 boots: 0 failed,
 104 passed (v4.9.180-14-gb172850a7710)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 104 boots: 0 failed, 104 passed (v4.9.180-14-gb=
172850a7710)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.180-14-gb172850a7710/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.180-14-gb172850a7710/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.180-14-gb172850a7710
Git Commit: b172850a77105c892b4983590a2c786bb4a0fea2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 21 SoC families, 15 builds out of 197

---
For more info write to <info@kernelci.org>
