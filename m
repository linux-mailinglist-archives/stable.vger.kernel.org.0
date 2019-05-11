Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3BE01A618
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 03:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfEKBVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 21:21:08 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:51380 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbfEKBVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 21:21:07 -0400
Received: by mail-wm1-f44.google.com with SMTP id o189so9138269wmb.1
        for <stable@vger.kernel.org>; Fri, 10 May 2019 18:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JX34mGbQNm+/oq2SAy3i8oRfFcksv94/SsCAeDGipUM=;
        b=B2xsw7ILv1b2TnRQuJn4xRP7hFpqXpvGgFVZQdLLoXIsIs4tOy6Dn1kuy/YtzJ0vfe
         1nrCbI7AF1MkcC4Q+Qbm70B/CnWurRVVKY+hd3GfSPw+zPNL6yg5oDMrU/Zke756fOrw
         +YLkp6btzPloCwNch+x1Mhr2zYqViY+fHl+U9HsCbJi0yp3s5Gmezr12nQYZjh4yY4kj
         2VArxwRqQTmLSb/q4rGY28vtIVI3gZjmySj9nFTgnvkpMZUg2CoRPEHU1q439DPqrLpp
         0N6tUJPojfdmWep3YhP24yHC+DVwi9jOVN78pYo78skFkq8sRmQCZyDyvNJ3TChUD6m7
         RpzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JX34mGbQNm+/oq2SAy3i8oRfFcksv94/SsCAeDGipUM=;
        b=VptdxSEHcQsiNXkR57hW3rpbX+QyPCXKIxA6e0mYe9HEIrfQCC5gUUPqf3YgiKIZbU
         zEI6MqiD3a+CkrU5Q4P4M7vZv7s5maUGg0b7dRTyKNXUcxms9v9fNOxtQQTpA46EU/7j
         tcN6az5aeGi4X5HjMO5pfOd+tNNBjRTxnqFyi7LiAk6SDWDyMI0JVmf1pSz77Wb+kuz7
         1suD8pa8+nGBe6uMwEn97s3NGJutTLXeglp0QhWh4zEmuxKcSXIFBJ9q2l++EAxyQ1Kt
         N4KJAojkUCX4UMrYzU1seeAFWM3PZE+KuOaVecbpxcI4iXgMfvsSo2AtgsAdU7qwUL4M
         BLlw==
X-Gm-Message-State: APjAAAVJiYSljh0GbTyaXxBEfhxU76nxEb0eqjh1uDILWOR5NmneMHte
        ZFaVrHT+ISSwYb0d8lZXrXmsjHpm04PKBQ==
X-Google-Smtp-Source: APXvYqzeMCLGx04FdKUhFrqgPVK1+HHW1Rh17lezfQxQKIUMXK3km407KA66CeeSYVOM/JJIYHvPxw==
X-Received: by 2002:a1c:a3c2:: with SMTP id m185mr8249530wme.17.1557537665643;
        Fri, 10 May 2019 18:21:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w14sm5768652wrr.41.2019.05.10.18.21.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 18:21:05 -0700 (PDT)
Message-ID: <5cd62381.1c69fb81.2152a.e8f8@mx.google.com>
Date:   Fri, 10 May 2019 18:21:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.118
Subject: stable/linux-4.14.y boot: 64 boots: 0 failed,
 62 passed with 2 untried/unknown (v4.14.118)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 64 boots: 0 failed, 62 passed with 2 untried/unkn=
own (v4.14.118)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.118/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.118/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.118
Git Commit: d929572d7da91169d3a22dfb75ede8bdced541c2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 31 unique boards, 15 SoC families, 11 builds out of 201

---
For more info write to <info@kernelci.org>
