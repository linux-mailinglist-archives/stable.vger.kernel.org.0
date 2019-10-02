Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509E3C458F
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 03:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbfJBBbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 21:31:47 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:38660 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727717AbfJBBbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 21:31:47 -0400
Received: by mail-wr1-f49.google.com with SMTP id w12so17618936wro.5
        for <stable@vger.kernel.org>; Tue, 01 Oct 2019 18:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3sSsKEV5mJ+vcAz9qjdSXOahmf0yveszZzlBV3hkCt8=;
        b=GgZ9tB69+GQWacTcJ1/kazuaH49s2rM8QhN9rMw0ODwrlZC2brIGKCQGmBeQmdvuGZ
         i5K6ArsgAFzHGGsUP2AJzh5wdoJnnC9ufhbryGdliN/XuFoTV3BOHompm7y4r4/9ycQV
         Ayd2ihD9UibxpcNtNYG29uMITwso8OiJaWTKpyj3DUk+SZgHEJjwtTTSs7BhQAhZaXHc
         lS4QpXEoCcyeS7J0l12d4v7kVX8yGCI/YMdKtXD+/kKSwaAnphzkUVy48reKd7RNpR8M
         1j9TJuF6AJBOkTysSMGeO/A/LhxkThnfuO1U5szEd0VLqd9P9sKooMv8CNB3bcrbI8x+
         LOAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3sSsKEV5mJ+vcAz9qjdSXOahmf0yveszZzlBV3hkCt8=;
        b=cTwp+xCKotzjqyZtdO+Ui9GoTbfHvJdrxQizTSfVgydVWfrw1l+oQHsf1TkagalZI9
         cIlEd4oXyvT9G6RiZMExSkn1rBULWF5/b45ZS2UOmEODe9cGRHEE/ljlgATbnzb5zKmI
         E3h62CcmZcQUBf09wh6f/9WTubasIe+4jTqk61rI5a1Ybp0khngflk9Cr2E/tUOPG3jY
         UnqjIYQZn4Q/rjsgtBcoh1m+afGlFOLSLvHN2wLJ/0tn6bPJkd2oQJuv0moVqEL4an9C
         O/IJu0vsEti6wxHOvxM7dqJY7K1Hqdx7pdESqkmC4h8mqOcCIbbuwTDeii/osBYk0bzr
         AXow==
X-Gm-Message-State: APjAAAWiAY4tF2NfAgAby6yiIBpigwsbBMgsBzV54dnhzqz217LW43vc
        L06pwNspCOIP+m0I9nlSeYKGORhJIr8ulw==
X-Google-Smtp-Source: APXvYqyAZBmQG3VuZy6Qr+T3YlWmKVCXvxUb3DyniogfweqaX9LJJhAKZqM/WSkMO+zIrKOXb29BWQ==
X-Received: by 2002:a5d:49c2:: with SMTP id t2mr426929wrs.351.1569979904903;
        Tue, 01 Oct 2019 18:31:44 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t18sm3898584wmi.44.2019.10.01.18.31.43
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 18:31:44 -0700 (PDT)
Message-ID: <5d93fe00.1c69fb81.4b6bb.36f3@mx.google.com>
Date:   Tue, 01 Oct 2019 18:31:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.194-101-g4bea2833dd12
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 65 boots: 0 failed,
 65 passed (v4.9.194-101-g4bea2833dd12)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 65 boots: 0 failed, 65 passed (v4.9.194-101-g4b=
ea2833dd12)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.194-101-g4bea2833dd12/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.194-101-g4bea2833dd12/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.194-101-g4bea2833dd12
Git Commit: 4bea2833dd12a0b9f1a482e01b6d94718fbd6178
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 28 unique boards, 13 SoC families, 12 builds out of 197

---
For more info write to <info@kernelci.org>
