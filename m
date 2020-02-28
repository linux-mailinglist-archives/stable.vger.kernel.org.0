Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA281741CE
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 23:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgB1WHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 17:07:25 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53674 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgB1WHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 17:07:25 -0500
Received: by mail-pj1-f65.google.com with SMTP id i11so1767149pju.3
        for <stable@vger.kernel.org>; Fri, 28 Feb 2020 14:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=47POdr+KkQqcxB4bpe0pvnsUudmig1GbL+yyZ3vfsJo=;
        b=SNqfgUwG4GFez36RNYUOTqBHEG02PA4ZL3NZl8ud/EhXcWh/9qM408k1xMj2Mj5jXg
         taybpG7T0oqRk7T35tWlpauDGvuxUL1T4YhP4kQkxGuLOwt14dlHZdYf+v7OclCN1WPk
         mEWwaYqirjtt5KskTXmuIMSyGP84gCmnZJlOG8qj/3zdrZ2uqEtHsxsdEd6eYgjJK2js
         UYKT9WvoNkD0fFDPatidx3oVPEabt5hxaKKS/yzVNoUVUM7lb8z+H05GGhbynAfzEmNr
         2Ze9rROFcIdesLNeeC81viNLmHQgEPg2rSjN2BhHzzdJFJEOZySIOJI56sXgLbsfVPzD
         xMHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=47POdr+KkQqcxB4bpe0pvnsUudmig1GbL+yyZ3vfsJo=;
        b=NI2ZNIHHxyAczuk/AmiVLHGoVsHxjlFK4xS9eA2iRAj9Bf6RGd6uLi4aMvdP+eVRyf
         ijFUOouVzAUlbkAqMunAgcfe9CGSnnw1Zlh9pN7RVaC+rXGaiW57Dl6GHaA56xb+IWFH
         UmK74cn1QTZKBrONK7mwGRGiBCFkEbtWjica8nOngwb3EeboSQ9RM97WW6nA9xU9ULXI
         oTzp0obloVfmICs3s+gNJF9sSWERHfr2xDukFwBokTPmHNYidooUZkunpHfJk6EB095j
         0is+f0MnfyPTw8VkJjzsltZLzB0kn50SjjOUQidNkmoCeIzYnBJ1luxd4IXVIO8Lvr0o
         G4zg==
X-Gm-Message-State: APjAAAWk9iPMzZ6slbJAGt0A6XVENqo3ZTnXpk2FXIcZWSvUJu5XQGeU
        MBczjVAlSUkkurCPGVI8zebYsBmTP74=
X-Google-Smtp-Source: APXvYqyaMdZ1W/sW9HktKa+Iec0zfmM+HXnWC2cpKOF5fZ8m0ua72El8tKc1ogaBMrqQk9Ni5z/1sQ==
X-Received: by 2002:a17:90a:8509:: with SMTP id l9mr3925617pjn.43.1582927642498;
        Fri, 28 Feb 2020 14:07:22 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j17sm12461622pfa.16.2020.02.28.14.07.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 14:07:21 -0800 (PST)
Message-ID: <5e598f19.1c69fb81.d1dd4.0e1a@mx.google.com>
Date:   Fri, 28 Feb 2020 14:07:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.214-163-g176b68c72aeb
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 36 boots: 1 failed,
 34 passed with 1 untried/unknown (v4.9.214-163-g176b68c72aeb)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 36 boots: 1 failed, 34 passed with 1 untried/un=
known (v4.9.214-163-g176b68c72aeb)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.214-163-g176b68c72aeb/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.214-163-g176b68c72aeb/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.214-163-g176b68c72aeb
Git Commit: 176b68c72aeb9388264cb988aede542d3275eff2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 26 unique boards, 11 SoC families, 12 builds out of 197

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
