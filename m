Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECB07BE9F
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 12:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfGaKtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 06:49:55 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:40508 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbfGaKtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 06:49:55 -0400
Received: by mail-wr1-f50.google.com with SMTP id r1so69121852wrl.7
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 03:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=T2KUV+rLJCFifWdaYBxw3F9qzgwHXvW+7kzhDZg8Zjs=;
        b=m44oxK4ceoevEB8z3ajEChNha183BhYSdvuLDPfgXtDbhN1pY6WlSNsIdHJkIQXx90
         NvgmjNpH4Z5nd8WrgOy49s9HEHm+bODdiEyuDUewBQuBFsRQvuzj6UF02JH7lEgoOGnI
         ECJxajTqXwDibGlsqb+P4bFbelFzwNwozf3peKHrMDQ9DWE1v0IJ/Z/N/bC1hjE3km9S
         10VjputJLm4IBrrSNLY4C3+JLHRkyd6wD/8xQjj/9yTjeIfQIGbiTTiK2qmzNbxRditp
         6OiHDyl/9VnQRt3vCnBPmG6h9sJoGoynrs1Wx4N7TNntS8W/T287goo+qs+oEblyVnOo
         MRrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=T2KUV+rLJCFifWdaYBxw3F9qzgwHXvW+7kzhDZg8Zjs=;
        b=iaff+D22qeCk3YceEnuY1swUFwbe40iuC2HE9uOjSFYbM8qbfzLjLS9MPFSnjCD5U7
         zCHbyR2/yHglFH+TNRVpMju4UUkF9Qsb6EqG+40HxiR3xg+QvRLaKeSU5PW/9cVyEmtR
         Siqg1WNJMeNdjL4egBrylQQQUGFLPSeJCVivaSk1oD1fp7GquXlu1aw753bORSjDkd0x
         tD+1ONrXFgXQKG4soffcdPhhVCb+IbnIC1dq3C38WBJaatf63cw8hxIu32zAPSEjFY6Z
         kaL49xvjPIYzvVwgqV1BXZm8IECNHEBiVUOdHlUYsW/1/Hy8O2lMaLFw6hZd2wDWZDBY
         tJSA==
X-Gm-Message-State: APjAAAUP7RdV8eAqQrfK/uf6uK9GwbjWeeQS9Fx7W0cAQbvWtYj3l+Y+
        y6YZmdnjvnxGxYMVD3D1NZsimOKw6hE=
X-Google-Smtp-Source: APXvYqwwMMKCEzFzM+rdiOnbyqSC4ZYlSe8HaIk6Q4fuOHYI/JP5/XQvavIOE3ooRcs7usTS02PyMA==
X-Received: by 2002:a05:6000:1186:: with SMTP id g6mr16460452wrx.17.1564570192998;
        Wed, 31 Jul 2019 03:49:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u186sm121220368wmu.26.2019.07.31.03.49.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 03:49:52 -0700 (PDT)
Message-ID: <5d417250.1c69fb81.d5363.9681@mx.google.com>
Date:   Wed, 31 Jul 2019 03:49:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.135
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.14.y boot: 61 boots: 1 failed, 60 passed (v4.14.135)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 61 boots: 1 failed, 60 passed (v4.14.135)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.135/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.135/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.135
Git Commit: 10d6aa565d0593fe4e152e49ab58f47a2952f902
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 31 unique boards, 16 SoC families, 11 builds out of 201

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

---
For more info write to <info@kernelci.org>
