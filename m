Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAEB7BE5F
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 12:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387457AbfGaK1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 06:27:11 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:45539 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387431AbfGaK1L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 06:27:11 -0400
Received: by mail-wr1-f41.google.com with SMTP id f9so69043207wre.12
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 03:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xzIhDKRZkJuJuShmRdI8QiQxVbqsszrwNcPJs5nPA6M=;
        b=eQE4sucam/EU3TrTrG3pRPmyVNSOo2+ctGKkWW+1caOG84nlgY6aQQeFQ7TdBz01Lk
         zhdMSCUlLIbUn23JDtcrr6TI8SQjDAPJ/n1bqOaPMJSQlUDW3OhoEW3upUaumS3m7gbB
         BR4JyuiCEmN5WTvMz/RFyK9MEl9i2NAt9QCw/mSTkiom0asjtt2L21jYfw8MGMtLP5kw
         X8/hOArMgt6BXGWTlw+F0ImRfc4v87M8TB1Mm0sxBDIO20Et5Imu7JJw6jkn6NvnX+15
         uxr40W3Jkh4kKk1qhY6vRaSW+81LrzbLMMIgb5oHt1OOy2Zrwz8bX5wHmJluosTxPx1Y
         2XmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xzIhDKRZkJuJuShmRdI8QiQxVbqsszrwNcPJs5nPA6M=;
        b=K5Rt1MFRJyyZBJzj9vGSKE/Loinx0z9DkRk6ptCwHb1CT+j6EOfN54dWD/mhZXEmep
         EOWkL8yIYl1IyMlbLn3NYN03iAuqZKQU3y/GHSdK2Uvf3kI8FeIyu2ap1Zdx8NETnw7f
         fNmDPZNlRx5xt8PaHNxWIhm2HIYwQ1JPXFgaRDwQ9KMSzsnLWFapdGlKNz3tHrSUntkg
         I0RkSAHv9wXMR0uYTz9m8QkN8JL+bUnY6sBZLcgTALVPi6KENNL9qP0PFW0Iy25UnHTI
         17eqUpUocH8oaSK9LZUm4oZEGPc+qtwEawX2AI7VfNXuSR6Qyq4oH3EwUAoF9jIfWMct
         Z/cQ==
X-Gm-Message-State: APjAAAU6+y3V3USt78QOoic2oYq04kfK9wMmKw3SeG5UQ+7Ty3FWGPwd
        2/gphbLwre3R15BskN55RS3+a4uZN1w=
X-Google-Smtp-Source: APXvYqyVlUuzz2Wvt+Jsub+Yp4/jxFn9mwevx5CG0sJjLD2sOIoX9Km4+3qW7gExns1TpoRhINgpqw==
X-Received: by 2002:adf:80e1:: with SMTP id 88mr46579884wrl.127.1564568829203;
        Wed, 31 Jul 2019 03:27:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y16sm147658523wrg.85.2019.07.31.03.27.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 03:27:08 -0700 (PDT)
Message-ID: <5d416cfc.1c69fb81.39b2e.6a06@mx.google.com>
Date:   Wed, 31 Jul 2019 03:27:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.2.5
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.2.y boot: 71 boots: 0 failed, 71 passed (v5.2.5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 71 boots: 0 failed, 71 passed (v5.2.5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.5/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.5/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.5
Git Commit: 2519374d2a6b8aa5d395393f21e74232409c2e82
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 40 unique boards, 17 SoC families, 12 builds out of 209

---
For more info write to <info@kernelci.org>
