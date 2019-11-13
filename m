Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD1EFA075
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKMBuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:50:09 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:40778 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfKMBuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 20:50:09 -0500
Received: by mail-wm1-f50.google.com with SMTP id f3so222439wmc.5
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 17:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/SWLnsYc2Gllr0kpg6/lmFySznq4hP9OUX6yADpjIwc=;
        b=BI+EFhaJmirhFhb5QsI5MFGRCjpWu72e0fF56cZGuPC9I6bI20uO8PSA3Hoc1X64kL
         MlucQj341/4onX4hVJnc9nZFBRteRJpZNUGlm7wFV/7cSimUX1JnB9EjpP4yAPgLolyL
         wVzFLgrhaGBpxc4NRCgo9WH85AeMVEp8op12wJ7NYlaBEskqkmec0PE+ahzJzUASsB/X
         U5SDeMv3CrD9Msydvm5SzNk24nqgFPAvd2oxHohNtl0JUJm85gO/WNFcZOfJg8RgNtOy
         IvDQn+LayHiprFsmxE0SeP8EgCaA+Tg7jfYKEkfLUipCss0rVN0M/CXrthXrVCthtU5m
         wDxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/SWLnsYc2Gllr0kpg6/lmFySznq4hP9OUX6yADpjIwc=;
        b=KWS2dKY5s/WHy5SxHiFM334hzMHci5zisxInhH16BHVHTZxSpLhpbuCtN4hoCMJt3E
         nz/LTsAV/ab7x/uXYS3vS9wmdqV/vTmbaFdfw3wkv4g20f3u2ZSO70XyusYIf58rPb4U
         14jej0JBInSw8SwFE+IBzLetJaE8Ad1SoVplSEHIadaxPJ4dqnIgndC4qcMyB9qJMcTc
         jJQltccXbsq8Ia2bUlJ9pbeyXFg3Fl8BEWxGunbHbjl4DTsZU5zny+TMPOqybd1t1SaJ
         aLxBWocKqHTVKD6+scpxzTzmTc1hWYPAq9hQs/GFJ5qwN7n5Qm698que4V51J1SiKR+w
         k14A==
X-Gm-Message-State: APjAAAUncBxabe0S4aQN4RQRyJ4sGw7BrwTtOA1mGvYqeV/M3w5t09KJ
        EwCtW9/wqygGGcA2sBq+4ksghy3g6Q9DGg==
X-Google-Smtp-Source: APXvYqzhyOPT+AshT7RIAjCKGOylGF6qmqgQFKLcMHy1nQZqhfcnKRiSiVDsGtQnQocW8megFzv7fg==
X-Received: by 2002:a7b:c7c7:: with SMTP id z7mr336368wmk.133.1573609806643;
        Tue, 12 Nov 2019 17:50:06 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y78sm572770wmd.32.2019.11.12.17.50.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 17:50:06 -0800 (PST)
Message-ID: <5dcb614e.1c69fb81.88744.237c@mx.google.com>
Date:   Tue, 12 Nov 2019 17:50:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.154
Subject: stable/linux-4.14.y boot: 54 boots: 0 failed, 54 passed (v4.14.154)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 54 boots: 0 failed, 54 passed (v4.14.154)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.154/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.154/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.154
Git Commit: 775d01b65b5daa002a9ba60f2d2bb3b1a6ce12fb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 31 unique boards, 14 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
