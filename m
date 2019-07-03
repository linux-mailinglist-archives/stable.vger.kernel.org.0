Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4515EB76
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 20:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfGCSVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 14:21:38 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:34154 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCSVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 14:21:37 -0400
Received: by mail-wr1-f48.google.com with SMTP id u18so3913794wru.1
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 11:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lLWSYaot9gpdUGMDN4PkU+PEMiJSk1dJkk8VXw4Qajg=;
        b=Fu3ggqu5fSuwxlUPjr7vJ8fogYnVIJhSmWSf8v9MnzzSQ5jQAnty/1PFUbVf3ffWXh
         db1QbfEJ20G6X18qt2ydQvaW55Nk63Y+opJ7qc7mJtl8aQBxCiF5KQ/5mmR74UCbHEHY
         3fgAIQbl6vhIqWF0whF0XJ6ltRCZzWluZEzyKvGLiUvzPY0iVbc1ZghNBbMHDV2cwlks
         m3Z47P5k7/0KtWE600GYbeYW7qMX+y68CQxRCw6g65w0OuIkdYsJVf1+boankfJbu/UQ
         TfhGuVQ1sOX/E9ukAFDL9ZYA1WeaPY+TvG/wd1ZbOOtQkxwFaTU00RxYaTw7oXHOlrQV
         4hZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lLWSYaot9gpdUGMDN4PkU+PEMiJSk1dJkk8VXw4Qajg=;
        b=APN1vZT6bnAnhLV6v64f3kOZ7gJXMupIFtcpMgfmw74GploZ7J1HRGEE8EGv6ReXuk
         iBIU6DKWt1EUOi1A+bBoIfQMFBjkU6K/VzNRwPReZOyp8RGjeBdwaEMbi2nsfTgfqcD0
         6ipbStXlA5EWjb0SD7wAbWhB+zOmaNIdwiz3YNwKKWQyvgveqgHfUdBc5P6V6Kh0sQAI
         Qs7i2T3ykKclTQ4+u+1AXHhoY7flL9zcfWPtqQNq9hHNVIZpGdK9yj61jASscWB48ldf
         ihG/kD0HLw2yj/qWc/ZjjcIj72+q2D9AuxZTg1teTvrXD8yaL/H023SnIHYrvC0xt8/S
         TWtA==
X-Gm-Message-State: APjAAAXSFKDXif8B9VlqPcCJ4jENpORCtAZgMgUk1bVIt2zN5rXkEZnC
        OmvQtrHeAySPlU6j7z3/xLyBdTiBymx6yg==
X-Google-Smtp-Source: APXvYqy5cSXJOgLDfj7to5YRsgixsh7O2H/b3NUMgDZpsy9vFYwSrHB0fqfpopDl4nkheR15nyFikQ==
X-Received: by 2002:a5d:53c2:: with SMTP id a2mr9662206wrw.8.1562178095652;
        Wed, 03 Jul 2019 11:21:35 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y6sm4151716wmd.16.2019.07.03.11.21.34
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 11:21:35 -0700 (PDT)
Message-ID: <5d1cf22f.1c69fb81.ca445.888d@mx.google.com>
Date:   Wed, 03 Jul 2019 11:21:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.132
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y boot: 66 boots: 0 failed, 66 passed (v4.14.132)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 66 boots: 0 failed, 66 passed (v4.14.132)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.132/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.132/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.132
Git Commit: e3c1b27308ae0472f27e07903181d6abfe0cb1d7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 31 unique boards, 16 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
