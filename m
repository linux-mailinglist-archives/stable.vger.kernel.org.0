Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7204731FD7
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 17:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFAPuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 11:50:02 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:37436 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbfFAPuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Jun 2019 11:50:02 -0400
Received: by mail-wr1-f44.google.com with SMTP id h1so8412756wro.4
        for <stable@vger.kernel.org>; Sat, 01 Jun 2019 08:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JKzxXCcJbcD0OigJObsO5vYAUriTzeCaSlKW/Gh1gOM=;
        b=Mc0AP3chJAWydFdBVRdtzG7HLCFOSr0Fhylb8yA8rWxEk9pLK4oZJmej/Kl60wgL93
         YfYz7qlxkhBNnzEUzpacjLjANsJ48sTo8MqrEyrLbJgbzNb5qyDW0DCrj38iOsOUjiBD
         DIVswORvNAkUOPMv24M3bZQTNipcelqZEAkGRdJrL3Ckn6JKaAcxFhBOpfKmm0JkRFDC
         E5THhLrdN0a2equcTTse568py28CWFjDX9xL7ClgYy3tVIKkunn7+AckLp5PmSHwbTx9
         4oGX8946luCJlvPVaTPeaOVDKUqmmOpNed5I3Bf44K4zFka28hGxr+oNMma5cp17L1hV
         PX/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JKzxXCcJbcD0OigJObsO5vYAUriTzeCaSlKW/Gh1gOM=;
        b=OEjuOAroBwLVuRRvQ9j+umLX+0vjdym346DBSmF1o39MVQkUF4jhIBwzGmaNfiC6bp
         s73o/qGD9cBUxGCHQHJjFLA8V1Cs3/otpzPPCAO1g9MTX4lsv04wTP0d+rif2rVg8yk5
         PjjmR785fmuwWCByhn4747VXDl7YPyYDLD64elQaMLwOja5e4i0jeY567ScHQ17/0TYH
         g+OA+CpWniivhKxxADOJrmWIPfEn6jmQ3lrx8+RUeoSYir5HZx7DhIKe9Gq3o8A5EZ1Q
         zOGmM/gZ7E0VuSIsaeRU55PnPYtlO9y5FzAPbVa1aaVvaXkMxnzruT9OWGWWAarKJGjn
         8C7Q==
X-Gm-Message-State: APjAAAXRddigz58jUhHNJKFMAv5HKQaYEhTIEX+4rUNxUqjv8bWnCf3R
        4p1AQb1t2Pwo8kVkudz/8Sd2KS9MK7tqbA==
X-Google-Smtp-Source: APXvYqyux/98UQ0Gbp1sVESs3r5iLP16LiGnOj5BfUDGsIzzjyL3skYdB97J+HzhuNe3LaOrLwXh2A==
X-Received: by 2002:a5d:55cf:: with SMTP id i15mr10379754wrw.351.1559404201048;
        Sat, 01 Jun 2019 08:50:01 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f3sm9989684wre.93.2019.06.01.08.49.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Jun 2019 08:50:00 -0700 (PDT)
Message-ID: <5cf29ea8.1c69fb81.303dc.3ad9@mx.google.com>
Date:   Sat, 01 Jun 2019 08:50:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.123-17-g62cda54b22c9
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 117 boots: 0 failed,
 115 passed with 2 untried/unknown (v4.14.123-17-g62cda54b22c9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 117 boots: 0 failed, 115 passed with 2 untried=
/unknown (v4.14.123-17-g62cda54b22c9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.123-17-g62cda54b22c9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.123-17-g62cda54b22c9/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.123-17-g62cda54b22c9
Git Commit: 62cda54b22c9526f64652f7b437a878811e03c0b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 23 SoC families, 14 builds out of 201

---
For more info write to <info@kernelci.org>
