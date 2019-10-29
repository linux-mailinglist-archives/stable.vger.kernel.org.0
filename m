Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E177E8A8D
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 15:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389385AbfJ2OQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 10:16:05 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:33244 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389092AbfJ2OQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 10:16:04 -0400
Received: by mail-wm1-f49.google.com with SMTP id 6so2099302wmf.0
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 07:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a1KPVq5Ule+LZmnJst7Utmku2ubl1UFVJQsZkmQszIA=;
        b=tCkhVB268tQ/8H4sEUGhqAqYZ1tiQ3iovq4en9y8uIZJEJJBuAjiwf+jaRU3MZrgbq
         krPy+84yIdOE1uF9CKtlZHaQG3RrEOU3222qt7caG/Zewtv09yVRbdRbpLAMLDXKIGHu
         Rx8I1YWurwolmc1WwpM7MeA2crSxh3oxQ6QPAt/de6dGJNoqnUoM41MUqo85bxa4NYU9
         JZKf129cjnubJ69Lta8l3piFCJ50PoxPKttgjOznbsSIeqtb8PYvskENzwVgZRALK77b
         IcV1saUetlWX7yjX1ZMCr2GhhQhy1crR8WBJJhcdPkmtO3z7ZSmbuU/sP9JBE6jphm+G
         +BUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a1KPVq5Ule+LZmnJst7Utmku2ubl1UFVJQsZkmQszIA=;
        b=TblMUB2a2amz+PM/NZwmQfQY/v8PUB/ttcShzRfbAEsiJNAt5KHAZzOe+Dc+kJoxeO
         4oIYUyhH4WeIKrcgzJEyT6GW9Ln7rdsk222kJbS3XWacwn649YGmhI70ZZlb3YpcOUnc
         MYAcNU7YZGX5P3XFQp+q4ltyqqxebzr5m9H9+3T++TBFuJlMEia92Hdiu8N/EHnwYnou
         AVnOljHxdCHnVC248XDYqcL3YwkRXir3wm6Hu94qrbzeeyeqQgySV1hPQgyoLeVQOUyN
         k7q0bctyrBOqDle2EzxWyWk36Fp/TndkOpr0JK2waqtEQCS8dBqm3Ak9OX+UolNH25ti
         KZNg==
X-Gm-Message-State: APjAAAVrwK9eTYQJl9ZWlN6pH+0fVDa3o81quJPFSgD+uoloVRzlJtkL
        8h++gYlsCuOxZgISLmjwyeGlPTuA5PLhIQ==
X-Google-Smtp-Source: APXvYqx1eubrJ1PtrM4jkFoMl9nq9QbC+kOMykPKg/+yU/kHu/dOobrma6BQLidxZ9EXM0rlOL3zsg==
X-Received: by 2002:a05:600c:22c4:: with SMTP id 4mr4483799wmg.177.1572358562726;
        Tue, 29 Oct 2019 07:16:02 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d2sm3089565wmd.2.2019.10.29.07.16.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 07:16:01 -0700 (PDT)
Message-ID: <5db849a1.1c69fb81.bbea8.108c@mx.google.com>
Date:   Tue, 29 Oct 2019 07:16:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.81
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 69 boots: 0 failed, 69 passed (v4.19.81)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 69 boots: 0 failed, 69 passed (v4.19.81)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.81/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.81/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.81
Git Commit: ef244c3088856cf048c77231653b4c92a7b2213c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 43 unique boards, 16 SoC families, 12 builds out of 206

---
For more info write to <info@kernelci.org>
