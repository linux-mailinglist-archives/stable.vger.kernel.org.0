Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88EC549699
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 03:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfFRBN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 21:13:57 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:54357 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfFRBN5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 21:13:57 -0400
Received: by mail-wm1-f47.google.com with SMTP id g135so1310020wme.4
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 18:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U3YA36iSQ/DrG2Mki6dRHnXw/I/GcA23oMKlseIgPBE=;
        b=a4J5xWhPocjD1DO7TpZQ78rwW7C3kpx8Havl8zVSEcYvLr5q3o/pFkMVlSjm/sxoss
         ldY8B0TX+GnD4jZGf1Euz2Gu56OSjpYkXbL5R9gW2y82Jq+O8XzCN+TGy3acXhwcsSNF
         XQKT4RlxU9rQaPgRpJTWY7qKfiXBlLSUuQeg70Kb/Vv7DajCT/fk4zPaVlcOvnbj7z1x
         p2VZw43okSrAc7bB6CLKOkvf3Ly3bemyvsDrQOZ2SFPsNKoSD54f/DRN+x8vuuVg4UN4
         wizhlq/71x8cjII2xxFV2tGRRnI5MzAdZiOEcfg91I7CrrGUButPQtEZIuGmutRVckO1
         z7vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U3YA36iSQ/DrG2Mki6dRHnXw/I/GcA23oMKlseIgPBE=;
        b=HQllPiOBJTE1NQN8dlib68XDI3FM9c4+WiVPZPGiB+Df3oH1lP9TlvVMdBMmE3ujZU
         Xqq+I7jknTzZOz47xMbG77OS3RoXNyDYXBhqJosI3QricsPyCoFH06C3szUSZhdhharc
         AAOotNq4ppgW9+JmAsJEeIzxWuk6hUJ7nUzW52bQVkTqUGTms9dPoKzkHGpQtwn5h4xb
         8bj+K8PgI8GhrEcUG8/wVKROWOm9gqHPnLX0Yn5CoNvU/+TvGolGj/Kg7qgR1WIi5X/J
         wnP0UgTeuyXBO6gdjoiSs59HBCTLdDsklvLZC8w/CTeOjewNqQUqidAYFLDWaxd8SsXK
         rYGg==
X-Gm-Message-State: APjAAAWiBrOjVUGnNCfyzrd6pu3EKPOkX3HqmUI2NaGrCSFWDgZweo8B
        SQbkT5arqGDvB1EBJ6u4V7peCfv2DPwPIw==
X-Google-Smtp-Source: APXvYqy3xBK6dfEF87oKxXR+tvAdqxar1TOd5s4bXRQYR/fEkmL4ajQ/IPoBPhkEKuOHOc2uMAJncQ==
X-Received: by 2002:a7b:cd84:: with SMTP id y4mr910994wmj.41.1560820435548;
        Mon, 17 Jun 2019 18:13:55 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c11sm10097443wrs.97.2019.06.17.18.13.54
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 18:13:55 -0700 (PDT)
Message-ID: <5d083ad3.1c69fb81.c8c26.48ed@mx.google.com>
Date:   Mon, 17 Jun 2019 18:13:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.182-90-g518562d36e0f
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 88 boots: 0 failed,
 88 passed (v4.9.182-90-g518562d36e0f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 88 boots: 0 failed, 88 passed (v4.9.182-90-g518=
562d36e0f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.182-90-g518562d36e0f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.182-90-g518562d36e0f/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.182-90-g518562d36e0f
Git Commit: 518562d36e0fece01bc58f8f627b429c38c6f963
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 23 SoC families, 15 builds out of 197

---
For more info write to <info@kernelci.org>
