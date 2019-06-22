Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 668C34F82C
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 22:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfFVUcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 16:32:39 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40349 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFVUcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 16:32:39 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so9649342wmj.5
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 13:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yiO/q3OqU/BvK1Z+Upd4kGd0KgtqhNg/pRb3QZV5J6c=;
        b=ccluU9w0hU4Gsmfmb0mj4yBXMlof4nK2MB9VR8FuKu6AEL2ILayCqs/uw9c24OEU7j
         yX0CXx+tnBGbzHqnOW6eQrySQQIWq2WZIu1GMPLbBHD4HHOYKx5XzzvVEEegf8WXM++7
         B+CV3eK/HIejxG1RQQwQ6Yh9Vc5B9/aWxRdJJpmDWCJaEHP3VjA+bqq06ZuE+c5qU/mW
         ncwb2UY/B6J4CWYUKjJhYLKdwE4nOREwg6mdmR11uPx5iL5+KEQa3pSubPfmEnUbo3dF
         1fHkepWiKtU/O/ZU3YgS1+j9bE0tpYI/glP8aMY8GUafc4M8Hcs9Hp6kwUTXZarMVseD
         nCIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yiO/q3OqU/BvK1Z+Upd4kGd0KgtqhNg/pRb3QZV5J6c=;
        b=Q4LfujmqGpvcd7jSyhFkR/5LD0ugF75oRSBXCBe7igWRJLWhjWiRvPiw72y10gQGbH
         34SL76M3zsRBrpIHKhDO4OeS2FunsrwHZ3ziizh+Vn4M/pBUf2FibAyKFroeYoM88Eom
         YeKoE/SC34ZK16JHsmFRdMptM7IKCqiQsST4EF33w5E8t8o/T1VQ7ou5Ayb2m/6wkqjU
         GYmVmGGiusx84ImFnIlFJPjpNrpu02JnhS2DiLQ8OIz4Bu6x+svdGGmgfSjIOHxJE1iW
         T5TMdJ7u8fR2clUtfAiqmcaKU+QzUvyscBm03/0ZmIrnj7AgVRVScaIhCsnaRUii6Qyj
         jhqw==
X-Gm-Message-State: APjAAAXomjgXQZjNvNV8jkvWDIHskAqPDpOxMCE7Kn0EaqFs5JdPv3+T
        Eh0+s4dVSSgj0ZgXGRZFwqVvuzqDKHY=
X-Google-Smtp-Source: APXvYqydMZ6mMWlKD8KFqn/wb7ap+pHKjNDwxEUKvRDWUQnVJsF7hCQ5dqpkBfvXS9mNVlaCpOSrOQ==
X-Received: by 2002:a1c:2e09:: with SMTP id u9mr8905511wmu.137.1561235556985;
        Sat, 22 Jun 2019 13:32:36 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z76sm7018808wmc.16.2019.06.22.13.32.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 13:32:36 -0700 (PDT)
Message-ID: <5d0e9064.1c69fb81.673d5.5fa2@mx.google.com>
Date:   Sat, 22 Jun 2019 13:32:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.55
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 65 boots: 0 failed, 65 passed (v4.19.55)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 65 boots: 0 failed, 65 passed (v4.19.55)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.55/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.55/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.55
Git Commit: 78778071092e60ab947a0ac99c6bb59aad304526
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 33 unique boards, 15 SoC families, 11 builds out of 206

---
For more info write to <info@kernelci.org>
