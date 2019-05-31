Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 976E83184D
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 01:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfEaXiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 19:38:09 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:54012 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfEaXiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 19:38:08 -0400
Received: by mail-wm1-f48.google.com with SMTP id d17so6986804wmb.3
        for <stable@vger.kernel.org>; Fri, 31 May 2019 16:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U1KkjPDDNgyk6IXWTLG21hp4HCotJxzmW1eaqgjp+b8=;
        b=p04owSOfcbSNRi9q5l2uHM/8KkeuMX83NrXURcoZlWAr5Y3n0yNXkyeGrqFSXCUkD9
         KH3hccXxm6ec4PGL8Mkb7NSPan9WhQjWT51nOu8IMZjnjXPS0KEV6BimVY5u96d4OgYy
         jxS1LHapo9QqL+7KSmE7Q9SiCO/nxZ/2ijHJ65hWuJ43vv2Pz2460HK7mU1IrptKddi3
         J/vSrNbSfB3GSczRNBe9Krs0t8fMiG3uneCrbmOxQTz985JwqHXBTNXiOfwXJg018/e+
         fSXYBIFQH5D0nHAFL5b5VQC9TbuHif80NBhEXFn9m0Kr+LPX1yfL2l9gDmGtcQOFiOSA
         ylew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U1KkjPDDNgyk6IXWTLG21hp4HCotJxzmW1eaqgjp+b8=;
        b=LLzsoZvEf7my9xyFa4J51pLj+facI7mGudFKdhujm4z6LG2LeF2O0CxTlUgvuMpQyZ
         YeoYejGck9vlK+qFTly9kWys7gVNs9dzVLZxTYA7LQCSEhZOJpXuhRrojfHLdcuJ5aA4
         wnBXKNIhR7jf1f7xlpcZ1UqFrbrjeSu4mMAarEuJBdDPwdiMq5g39WAgW34NI07G8mAx
         PYr6ACR0s/9Qmk5H1D0ONWhQ4NImwwdG2XTjY/tgW9nPG3fYBvKJ2o/uBqubBjdui1eS
         9GO9KZzImWpRzm33d1hGnDjWnZ3bmNwcaryE4XESjrbKCfeFIsMJVIq6YTet60QHlk5I
         sirA==
X-Gm-Message-State: APjAAAVSZn6ADEeg5Bt7u8AT1X4QIDrfV63vNo/Hi8HnZ2biW0Ha6jfQ
        FQObQjKCKGGqVVNg9iczLSQGABcU8wXJgg==
X-Google-Smtp-Source: APXvYqzUuyvEqzMqnuFkxwWlhegLetnG+rlCAXrNUoukogfZ3hExBoebk9lc8pSHj4JVP8B5dPr9qA==
X-Received: by 2002:a7b:c317:: with SMTP id k23mr7123421wmj.124.1559345886667;
        Fri, 31 May 2019 16:38:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j123sm12308807wmb.32.2019.05.31.16.38.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 16:38:05 -0700 (PDT)
Message-ID: <5cf1badd.1c69fb81.63b61.1c93@mx.google.com>
Date:   Fri, 31 May 2019 16:38:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.180
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.9.y boot: 50 boots: 0 failed, 50 passed (v4.9.180)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 50 boots: 0 failed, 50 passed (v4.9.180)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.180/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.180/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.180
Git Commit: b16a5334ed1211bf961c5883eb0f3ce35e90b4df
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 22 unique boards, 13 SoC families, 10 builds out of 197

---
For more info write to <info@kernelci.org>
