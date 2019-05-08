Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7FF178DE
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 13:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbfEHLvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 07:51:11 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36440 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbfEHLvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 07:51:11 -0400
Received: by mail-wr1-f65.google.com with SMTP id o4so26825781wra.3
        for <stable@vger.kernel.org>; Wed, 08 May 2019 04:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dcXRWe6bC6aBB/9+h+05Y5su78G3lmqKg/cTGvhQgcg=;
        b=FsBmzLM1Vo/oKq5ej3NgDo3wVNvWVg7QcLzZaWvNYThFqeVFt23nwer0HkT8uEPRzT
         AWB039AoN+PemZ39ec0xvoUHG77xn7LhQQ5RaZZU/KL6GqsQNauC1C4kyi7uV7YzEae9
         4yyM38yxjbFqvYiU9BkFKuumbBW9ICEq4Rsv9Nn34JtT2HyVkvQ4aczNyoR2xb3WfVuj
         X4N2sYCRkmki2qq89j14fhjVtMtBC1CNTzZRehRGL+Ivykb34cETZpnTCEk8l8IDjb/w
         omxInLkbLNwCh4HE3XUB/qKkBcPpDsOCs6lxBYMCKtoLGoVqiGlT7BBmgYeKbmvaMx1x
         q6JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dcXRWe6bC6aBB/9+h+05Y5su78G3lmqKg/cTGvhQgcg=;
        b=g5CHSxh5OyUOFx5x0oyWjfY1LkeQAaJLh9XI3YHxEfZgsciwKkXJ1VNiimj6DLM1o9
         1Zbt/SK/Mp4BA8vgNwQYJw0rFVAxpPDaP+lh+j8WL6YYy7G4FPsZ42Hq2KjbMtEyz2Pb
         EfvUu3Mh3o0F0ytduswvjNg1J1sJMvjUjXE0pFDDy5aqkbF/unmuTWFvdr6M/LsJ2hpi
         kViUhS4zRKugMlusDHaTx3Jl6Eg/bHU1K+pgyXZZDdDN7LJd33839sypvQJuhv0CZWEq
         4Uyq4pWRc9bmgMwwdIGNqnV8EEfZ/sGDxCb+YRV4I1xeHUFUWU5AgddKJZAluvM01ZLV
         5q6Q==
X-Gm-Message-State: APjAAAVvoPh9b93TFhYCfhghVdDjijf7IDYYnl9eJbYQB/kYI7kvN6d1
        9p7q9yToRkoft1FOepv3B5lpTiK+2cAgYg==
X-Google-Smtp-Source: APXvYqwm1jBsVEWy2JkOqneygyWuHsAJ2rFgjA3mIHZfVla1Eoz4d1RVgF8irCby0aDkCj7+pqLgYA==
X-Received: by 2002:a5d:4348:: with SMTP id u8mr28114140wrr.129.1557316269511;
        Wed, 08 May 2019 04:51:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 15sm4322887wmx.23.2019.05.08.04.51.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 04:51:08 -0700 (PDT)
Message-ID: <5cd2c2ac.1c69fb81.c2cfa.35d6@mx.google.com>
Date:   Wed, 08 May 2019 04:51:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.117
Subject: stable/linux-4.14.y boot: 64 boots: 0 failed,
 63 passed with 1 untried/unknown (v4.14.117)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 64 boots: 0 failed, 63 passed with 1 untried/unkn=
own (v4.14.117)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.117/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.117/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.117
Git Commit: b4677bbb658d54ad29c8122d61bdcc0f878030b1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 31 unique boards, 15 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
