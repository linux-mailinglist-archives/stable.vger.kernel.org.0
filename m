Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248F91760C
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 12:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfEHKdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 06:33:53 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40969 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbfEHKdx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 06:33:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id d12so6033066wrm.8
        for <stable@vger.kernel.org>; Wed, 08 May 2019 03:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xVtdUK+TpGxlj3pBIdVdDogk1OqnLaMqv2RKH4qzPJY=;
        b=d1wrSAHwBpq93v/dOSUc34WMx9yK0gHVosSFO5muXS+UFJAik1ydwotIzvOTYYXVOa
         tDYUX26hO1Yelvn6HzStcmDXtGYddV368qCXfmtT3nWM6ahttdAN3uUlqVpsn+cO+ZR9
         UV7nALDgVlLlyI19mIcBDRPEVkLrLsozhssHvmBwGOwVqP5pqzpO224mG2si/T8FzwJT
         edKQIJJH7tKhvZwYCUf8aRkmiggScG9ME1lqdBM7U9FGnsx/OFcSYc7eBlxtD7JUX56x
         E1iv7mZCuEbUo/ID6hr82zhE3HJymGVNdeXwXNNha23PZX8SbuJ2NecnnLpRgJ2muaeM
         mW+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xVtdUK+TpGxlj3pBIdVdDogk1OqnLaMqv2RKH4qzPJY=;
        b=WP2953ZAhAuc/Rsnfwi4AjBLMmbv58TY4bucSDLKH46fcU1AyC5248bJzUkWHN5hVx
         NZP8lkFkHDqnn75mVWG+6FuLK7fcMlGy1dV39uplJAOkeEUIMrtpJIsft5/LzX7MOOME
         IILyVBtduUL7erFNSYHXgli6OjYAT8GFe57dn1972wFvxHBgXTovlYIkTyVMi6mjCqeY
         pip2fzTlAI/xKlH0T42v+1Q8vhNL9AdJJ/vtWJn3UAABfFzaNXt+IqeElYes5BoAdymG
         6qRRUyX2okC70wVlslK2okkUrEeu4iwJxXKU3AG0+aKE29ugKBWO3q61UOqRUr6jN0jf
         5DNg==
X-Gm-Message-State: APjAAAVCbJGu7dykaHntSJbrIk9AHx6nerYkuyi6rG7TuYEZdmQRTdrL
        YLnCZMSJeRbZMGPezsNG8Isn30tqllTS/w==
X-Google-Smtp-Source: APXvYqzqvIYofId5dQVaJEh+1DbRQ+stwT2DlMam4MaoitHnrbujjdXrPYH7weyXqx3in/Ue9MLYqw==
X-Received: by 2002:adf:f686:: with SMTP id v6mr4019228wrp.246.1557311631585;
        Wed, 08 May 2019 03:33:51 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t126sm1776417wma.1.2019.05.08.03.33.50
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 03:33:50 -0700 (PDT)
Message-ID: <5cd2b08e.1c69fb81.b2d10.806e@mx.google.com>
Date:   Wed, 08 May 2019 03:33:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.41
Subject: stable/linux-4.19.y boot: 68 boots: 0 failed,
 66 passed with 2 untried/unknown (v4.19.41)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 68 boots: 0 failed, 66 passed with 2 untried/unkn=
own (v4.19.41)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.41/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.41/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.41
Git Commit: 21de7eb67cff193e92a4556ae282a994e69b8499
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 35 unique boards, 15 SoC families, 10 builds out of 206

---
For more info write to <info@kernelci.org>
