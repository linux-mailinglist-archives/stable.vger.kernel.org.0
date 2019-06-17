Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42EA8495A9
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 01:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfFQXFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 19:05:52 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:39355 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfFQXFw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 19:05:52 -0400
Received: by mail-wm1-f52.google.com with SMTP id z23so1104633wma.4
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 16:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/KC4vDZ+ycH5YWt3nCREwyo664j5FHVxGvScda+jD1Y=;
        b=rbuMy1TdDDA5EnEVpl3GaB8ohQoZtHFEVn+MTVhhz9pU7yUJO1akC8qy5nFeJGNP4A
         oxidwoH+knVefpH5i4BGQdzrUT5pvxaBSBs35fWwDvSU0ulJX/xlfrYeuqZbNF7HY/0y
         e4FXyEBQSz8Fazih6xbi5VViQKhiZoU3+ZrRLfMyqg6Vyyc0ZH+tQi299j2O+jtHxPfa
         h0GmyegU+tmKxKl3rP/DFM4jWyFxHurfrD4lkE71kRxsL9xfzoCwbtXeb7vq3Xy0kpVl
         rCpdVIlGcsImVPpavexOG9MEvA1Qdh8JnhpLz88K5T/lDU0UIWozbzjFsKtoWBx8EGE+
         iObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/KC4vDZ+ycH5YWt3nCREwyo664j5FHVxGvScda+jD1Y=;
        b=E8lUDmSNndfw4l3tIK4ebZlx6TUeRFhHr1zaqBAIhHc/upMVjdvZa5C3U7Dsy+DKLR
         x1cMukYYQConCSF+gcuC0cW2EbcR/DGZPBMrN1WSMPn1mm5imWdmp8x89RmfL0WrpLjZ
         sX8Q1mDz8d/b5Bu55DMI/Dy0Vh6qYhpVlQJW8YrAZqW0u4Oia+ptjIAF30VPiji8pULG
         l0XQRnptFQ1fdgBRayu26nKrxoKsOstzU2EleLX5+DmJrErEKuxwvlrugGePD/ZCR+Gl
         zxo3lcJd6wKCZkcT9viw9tGqEEWvQioU7AjxiGnFyjEx7xzm3FpbFG197m5X0BhK4Wgz
         uwmQ==
X-Gm-Message-State: APjAAAV6RPSSD9018LXybyEHjQJypZh6yjMC8hEinMaI4xz5+p4cXZH4
        AjYFGGUn5qu6eKPZDgtHZ1pMAupvZIs2LA==
X-Google-Smtp-Source: APXvYqyxieimSGhEpl93UBg1GKmML5w8cQiVkfi+mqkEyeox1izP2b1yq1+W1S/3uN6uWb/wkfHxsw==
X-Received: by 2002:a05:600c:240e:: with SMTP id 14mr614751wmp.30.1560812750333;
        Mon, 17 Jun 2019 16:05:50 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g17sm11372082wrm.7.2019.06.17.16.05.48
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 16:05:48 -0700 (PDT)
Message-ID: <5d081ccc.1c69fb81.3e98b.bfe8@mx.google.com>
Date:   Mon, 17 Jun 2019 16:05:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.52
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 110 boots: 0 failed,
 109 passed with 1 untried/unknown (v4.19.52)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 110 boots: 0 failed, 109 passed with 1 untried=
/unknown (v4.19.52)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.52/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.52/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.52
Git Commit: 6500aa436df40a46998f7a56a32e8199a3513e6d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 24 SoC families, 15 builds out of 206

---
For more info write to <info@kernelci.org>
