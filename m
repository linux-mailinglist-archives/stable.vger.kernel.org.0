Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 634D83471E
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 14:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbfFDMm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 08:42:56 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:42473 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbfFDMm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 08:42:56 -0400
Received: by mail-wr1-f46.google.com with SMTP id o12so8545192wrj.9
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 05:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3NP078ZMTcwFLvEeNMylESBBzin/sNQeO1WxdnsQwHI=;
        b=vYQ23a2T1hUNj/TGCOyIyi4Vc91h9IIuX+Eyp9bMF1YQyv53i/x3gxlkZZQLuYeeF4
         35cvfSSMhq112Zuv1KxQ3JdvGFTP1JhVLHA7bQfQuuGYSpTZrL2j5wrFo2fz8VmEeX/7
         mdIsM2vgWBr4IGH8HYq2GeLOsGH53TzlBBPDA0YD4pTa7RtXx3h3As+rLvFJw/2mNkV1
         aaYgQhgCjjHdVxRkh97f8zmwXDK0d8bp1P679MO5OdpjWqqeBkIF9tm4kWtdrWAs02iZ
         9UnxuInYP3gmtNG/xm0UFTtYCie9W57OD3d5sDh6cx2bvYnUMsJb5oCjMve6/p+lyVWG
         rE4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3NP078ZMTcwFLvEeNMylESBBzin/sNQeO1WxdnsQwHI=;
        b=Qi7jEkRK8uAInSzhQJYQ0Ph+29claVbwZKODOWbw5ZS/MDP48eYUlbAxqKhEHsFppf
         UeCcXC880qPQ+cvSlHAcu7BDx0GYN8EjxyrIk1yIRflPYtHUSt/V7ec9G4AFDLAfBLMP
         e31yyuALwLhh4nmk6OV2ycDwSN3RFbayaFz5SOaidI8FwMRvwFU6YWr3sbaSZqA1k4Ng
         +k6FT0S4SFW434YLEnxNFrFwL8TynTKZiDmC8y+ewPQiXgDa91R7EDxaoxUJT1OrBbOF
         H+vNW2g2xaqR7QswLSp1dWNqWWiojwb48zHeoYukuTiQchvZUc9jp074oucl9As18I4P
         sNjg==
X-Gm-Message-State: APjAAAXs8tCJ0ojW4SvuR7upddE2kCofXaq7FEHbNCB20XmA9QU7AZl/
        GcdMmw9rtfZNfwuEdue5R7HTyF9O9Yk3hQ==
X-Google-Smtp-Source: APXvYqxuxu4ET5fabb8ITi9iGU9xOolFjbx3BH/FwWdSCiRchR43iVW0gjL6XuW2Cu0CkE1C0kMJyA==
X-Received: by 2002:adf:f041:: with SMTP id t1mr20250017wro.74.1559652174377;
        Tue, 04 Jun 2019 05:42:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n1sm14976252wrx.39.2019.06.04.05.42.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 05:42:52 -0700 (PDT)
Message-ID: <5cf6674c.1c69fb81.fe733.14ab@mx.google.com>
Date:   Tue, 04 Jun 2019 05:42:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.7
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.1.y boot: 67 boots: 0 failed, 67 passed (v5.1.7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 67 boots: 0 failed, 67 passed (v5.1.7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.7/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.7/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.7
Git Commit: 2f7d9d47575e61225bbab561bff9805f422604fe
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 35 unique boards, 16 SoC families, 11 builds out of 209

---
For more info write to <info@kernelci.org>
