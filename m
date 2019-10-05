Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A0ACCAE5
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 17:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbfJEPo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 11:44:27 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35487 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfJEPo1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 11:44:27 -0400
Received: by mail-wr1-f66.google.com with SMTP id v8so10498400wrt.2
        for <stable@vger.kernel.org>; Sat, 05 Oct 2019 08:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GxhZIGQC0YnfsQclXBZlcP9R1K3eIyolDGqYgP8fN+0=;
        b=LbmcSrZEZpu7t5BVnv2WLUBYyqyPBEIwayICUZO6BigHGrR7WUHIWFXos0W2+oWzWK
         Nwxuybed31M/UJL/YGkdXezBXwlN11Vq/nh5p7RMgdX1r/Sdn47IX9pPzl+Vq+WiU0Ra
         /d0PkfBLvqQRjSYjcWqlb6hup60yfEHoobjX9uftyHl4CZoJvx07mvbracI4iTPFDwt3
         YK5kF+enT6yEqkmvz00Szp1xSQE4tWQEdpY3hipf07O2dSZ57a46O6VogrWQ86pNlP42
         9+xl0M5swvSQ2zJU6qQOV9mP16SHvxwhyz9C8QAY8rPgCOfR3L4F/NQ5tOs5tHZB8Mr4
         jj/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GxhZIGQC0YnfsQclXBZlcP9R1K3eIyolDGqYgP8fN+0=;
        b=h6GHavI7T2zVyC0xCNcSnxXYuA2WMANIx173Ly+47htUfM+v0Kcv18gu9TJDJ0uNKN
         vJYhc8laFJ8SOFHcAdJvC9egZIjw2N8EKlaBGTP19ZkQ+kLVipGVLZHMxLxboVnUXkir
         qKnoEvQlGYz0mdgzfP7thEbKmc3ryh3CGv22ASwTHLfnX/PHHTcEmJCu3DUziRLKGny6
         sPYQXOV2oz7XhBx1eve5dyMf8x8P1KwpqkNNFzmyjvvgWPPsauK0kuJb9bjWbhj1qL3o
         9qHNMJwSE40Y+HO1O8U+9xqG/7S3CNS47OBUhJmuOmHm5bOVO+ukm45D7AA+JwTlfu6h
         0xbQ==
X-Gm-Message-State: APjAAAXEP9wQL8zNhEF2Q0avqnMtO/F1P25xKCl3ZlLPymc37TqauIcq
        r+EM6SFEFOUjJmNnw5DesIemce0uzbY=
X-Google-Smtp-Source: APXvYqyT2g/HoKIHHZijPkfVfAvi5vfKPyCD21K3cnGEM2wthkQr4aZvXqOCs5S1SQ88RM8OnoSryw==
X-Received: by 2002:a05:6000:14c:: with SMTP id r12mr15780133wrx.303.1570290264877;
        Sat, 05 Oct 2019 08:44:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i11sm10546098wrq.48.2019.10.05.08.44.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 08:44:24 -0700 (PDT)
Message-ID: <5d98ba58.1c69fb81.ae56e.f80f@mx.google.com>
Date:   Sat, 05 Oct 2019 08:44:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.147
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 55 boots: 0 failed, 55 passed (v4.14.147)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 55 boots: 0 failed, 55 passed (v4.14.147)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.147/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.147/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.147
Git Commit: db1892238c55c5138801f131a837ccd0056f002e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 33 unique boards, 14 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
