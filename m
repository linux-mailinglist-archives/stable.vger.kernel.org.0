Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D08DBC31
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 06:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395406AbfJRE57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 00:57:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52293 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730688AbfJRE57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 00:57:59 -0400
Received: by mail-wm1-f67.google.com with SMTP id r19so4692133wmh.2
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 21:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3/9IZM67RWv9JNzFN8UM4hZt9GL4WUbPqz1nCBGyoyo=;
        b=yuh3v6mkJMPAn2RBiM9hbBuOdv0fUkCBwHnf8rAYQ5nz6bDhweJ6yJxiRAmMLVAULa
         Ai5Q/ZRM0zvHKmQAbCXw9nq7K0wExTOcYkLEHc6xwx0U+UwwVnmVQy7my2PHTYN65QN7
         Q34JL0Iyu1Cia2MP57+1kLbLezwfMFKjfpwzbewmaLGDsGGpjcyT80LMiV96uFgjcRBp
         V7+YGAo2TDdA+TNVoCRzadnfdet2CARX1qYTwoGVOs8Ck0ssTDnGdKVzwLyW46wKX/LO
         jP2Eh/L++ShNCOMHiyTCjK9CUkSBz1BGlNDD9d3WumiXg/e74z2MTwTStjW4Gynfs4En
         kkMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3/9IZM67RWv9JNzFN8UM4hZt9GL4WUbPqz1nCBGyoyo=;
        b=bfzZP1p0DOMIrQMe+FNPOJrllNeDt4OO/99OQEsgb7z76b672uwhOCR5JCRWJ2OxWt
         uOoY0p6fVS1/G/vqrOmRdreOnyF5ioRVSaZs5IlmJNlefCu3Xc5H0+fguj+0qhnZWJ54
         GRKGnBBWQAEU1ORHRBHeHCO1UiwE4EHkNv6GwqIVA076Wsy8huzAf/YHz5IZEro4ZClz
         xi7Pzaj4Sog9BFjVrS9xJrBtFUXguhjjgnN3z1dWL2zJgro/lUEZPGWjGuXFhgKnGOW2
         8pO2DnJO5DrQyaCJyzb0lFwIRb2GGR/RPuPGFp4Tlnc1GFjMh0sn8krpnyNz9HKmn6EX
         Nkvw==
X-Gm-Message-State: APjAAAW8AJvSU2y4WPDq+UZlxzZncPHVmy3eZ8Kv34tiqGwTo3HxPbhE
        JE4NW1fjHOIwzzlGwIOfbdnqBZIee5zLgA==
X-Google-Smtp-Source: APXvYqx+Rz+ykz5xz/DUwTIOCfNYw1/cotqXMmGodU41N758YOl8oJ13Cc37MsyOWTJMsdLp3XC5PQ==
X-Received: by 2002:a7b:c938:: with SMTP id h24mr5796186wml.117.1571374676076;
        Thu, 17 Oct 2019 21:57:56 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y186sm5314833wmb.41.2019.10.17.21.57.55
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 21:57:55 -0700 (PDT)
Message-ID: <5da94653.1c69fb81.40816.b0ce@mx.google.com>
Date:   Thu, 17 Oct 2019 21:57:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.80
Subject: stable/linux-4.19.y boot: 59 boots: 0 failed, 59 passed (v4.19.80)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 59 boots: 0 failed, 59 passed (v4.19.80)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.80/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.80/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.80
Git Commit: c3038e718a19fc596f7b1baba0f83d5146dc7784
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 41 unique boards, 16 SoC families, 13 builds out of 206

---
For more info write to <info@kernelci.org>
