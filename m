Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9AACEF49
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 00:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfJGWyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 18:54:54 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33312 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729244AbfJGWyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 18:54:54 -0400
Received: by mail-wm1-f68.google.com with SMTP id r17so1047618wme.0
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 15:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/WY3GJsaD03TGUFE3bcHQP2eK+Hyvfy0O8cuv2gajZQ=;
        b=h5xKbXqYE1k25O3KJrxJcpINiaqiDTHix9gz5m1LzLj4ckB/u4EDf+Zj7I7UzpQs1N
         szdgNdMIsm3zv9/iLcLIW1HXpe4JIL7jbkgbCgA5IMbG0ofMIhw+vg6beUk2YEvafvZP
         2qAfIDaqKmsxn2hQ2ypS6pAF3I5RYTYRR1zB2f05sNyM/xxGtVZ6AD3ijG5jS+ETL/h2
         VbnIMpsOS0s0xrXPMPmCmqleR3+0Rw4xrNzttZv4PScq6tNT4ivvQoHGCtDtL9qUowhq
         SveWvvMgd71eHNA3Jq7cHZ5dHYrRpej9Phe0NLqMRTRsNcS/VWELW3XonEBxcxS0pIPM
         9Y7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/WY3GJsaD03TGUFE3bcHQP2eK+Hyvfy0O8cuv2gajZQ=;
        b=BK8ZdqK7ndyjAksbI4kt/xaASa0E7MLTSNfuF7PPo8F1DHaE7y5bviJEbE6H56iK+Z
         lg50zHxU/+ca38tEzULVDIMfjTzDWAe2AB7pYyqU4752+ZNHVUj9dM18G+NyMnkkdrdX
         gBX9drgljGg87mMDFo/WPPNBZb+ZLBYpZuWrAAU6EoTzq+95b2B6vILnKlNXhjcqUWOP
         hubmhm8pdmEsUZ+2OElxLiLMDnnfupvfp+w/oWwAz9wZbElhPHOfloti9nUnstBc/fOL
         4R/SgRP9GmtsX1aIJcN0meos4Zx180TFiV4E3Tqk84sv5j5FDy0kSZ01/4t+6UNkup4f
         oAfQ==
X-Gm-Message-State: APjAAAWDflVTEfs9vPDaMt4mxd8F/m9jNRkSkj8ASa5RjgvvD7o/EcKx
        fLb2IZeYkW8BQcUhCmGV65fE4wmeXmVlWw==
X-Google-Smtp-Source: APXvYqyO4HUjtWxeGhqweKCqLMEQmS3I0qTZiwc7Xm6bPJls/isYCuSmpIhkkI2OOWSLtR6cfvdYuA==
X-Received: by 2002:a1c:cc0e:: with SMTP id h14mr1200788wmb.117.1570488892346;
        Mon, 07 Oct 2019 15:54:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r10sm1907139wml.46.2019.10.07.15.54.51
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 15:54:51 -0700 (PDT)
Message-ID: <5d9bc23b.1c69fb81.e7a9a.a4df@mx.google.com>
Date:   Mon, 07 Oct 2019 15:54:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.78
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 66 boots: 0 failed,
 65 passed with 1 untried/unknown (v4.19.78)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 66 boots: 0 failed, 65 passed with 1 untried/unkn=
own (v4.19.78)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.78/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.78/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.78
Git Commit: 58fce20645303bee01d74144ec00e405be43b1ca
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 45 unique boards, 17 SoC families, 16 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-drue: new failure (last pass: v4.19.77)

---
For more info write to <info@kernelci.org>
