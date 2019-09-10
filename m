Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7A9AEDCF
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 16:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393262AbfIJOxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 10:53:14 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:36543 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732106AbfIJOxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 10:53:13 -0400
Received: by mail-wr1-f54.google.com with SMTP id y19so20901590wrd.3
        for <stable@vger.kernel.org>; Tue, 10 Sep 2019 07:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g5zWVgkY6qNg/Q+5RWI4a1zIDHV272feQ0H3ALae/tw=;
        b=XNLonmV/GIEmAdU3j/QJMn2JBRHqcNfMOeHY6DggyEa3fRyNQx3pW5soMiVoAegCWF
         B3eSH0xdXKpTltRT5QpqcglIZD6vPmhYot1v+O55EzIKMIV0G45HszzAveG9wD1OLMIc
         vgGh6cZh1MEynqwR4WfJC4FX18vL7ljdX4LEyZSl/0Xw6YED0668yyKW+hFC96+/kJy4
         RDIoiLopYSpME2vfhgRu55BgwH7p4Fam+b1rtvs7ljYzoYDfwHLHaCdLjGHeJFXhr2kj
         yb1IuaF0xi+56FLTk4t1wBUMYH+R4j6ll4+8P2PZu8NJxEyUCWjC0Ywh6+HS5j6Yi/50
         /mSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g5zWVgkY6qNg/Q+5RWI4a1zIDHV272feQ0H3ALae/tw=;
        b=XE6IaQPTWoEfRKKFZJ9X3sdWwupbKI1enSAX9HN220Ach38kfG5hOgOae7fa0nlfvx
         ij9cdoFHa3e0aBeO+PKE4vkAAPkz7sLobvikwNYOwaieLbm1jDChtLphcI41fs9Yy0NQ
         D+Vb6tjtVzAbYWXRLgXk4rjfYD85962iENfiFVa3OyLirhcUPJwIrDcCnjgVC6pmwPaO
         URvcWNoEUHZgvqNUwEzqHj/YPvgKymM0E0UUIXhsM2BKe9eiSwce8Fy7RojNgzTkP4I9
         IvPJ6k+UDR9BFUYUbPW8wrb4OjU11NJ5lgvqWPhvu9b9SV0Z749txrnzdPYPuhKnaS9O
         DviQ==
X-Gm-Message-State: APjAAAUh0eSbUdP+kN0wYktzQQFA+RpeZgt9MlBIWNyYqrYzM5eQPbQB
        h/CtV45BhXyHH0QD6OQNCqygzpTcCUIDHA==
X-Google-Smtp-Source: APXvYqzaVLXtnJiUmE2160XOIZaTK01lMysvdKlB1gFZGdfT8qLfvBHvKfiVXcTilRqgdoB52YxrCg==
X-Received: by 2002:a05:6000:49:: with SMTP id k9mr6714566wrx.21.1568127190270;
        Tue, 10 Sep 2019 07:53:10 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y186sm4186593wmd.26.2019.09.10.07.53.09
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 07:53:09 -0700 (PDT)
Message-ID: <5d77b8d5.1c69fb81.ffd08.4b36@mx.google.com>
Date:   Tue, 10 Sep 2019 07:53:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.192
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y boot: 69 boots: 0 failed, 69 passed (v4.9.192)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 69 boots: 0 failed, 69 passed (v4.9.192)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.192/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.192/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.192
Git Commit: 5ce2e060020bf0efa1ce8a261a4d51abe70dc9ea
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 15 SoC families, 11 builds out of 197

---
For more info write to <info@kernelci.org>
