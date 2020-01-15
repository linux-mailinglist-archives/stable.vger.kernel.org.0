Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4923D13B93A
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 06:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbgAOFwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 00:52:53 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42358 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgAOFwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 00:52:53 -0500
Received: by mail-wr1-f67.google.com with SMTP id q6so14429852wro.9
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 21:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yj9Fsb3ac8CLMeMAQN4Ah57VY515AoUcB41FgcjJ+ls=;
        b=D5dYB9kSw2sdchAEC/keQxTDOKYSrNF17G+kB8n0OCi9+VcEbeC0lsCD36rCnVV7tt
         YvqzpVYazb9B+KvtBdEPmju7TEnDRD9xFHz2JK9gNfXDphrisuAZuPpY8NPBT+c+gZ9B
         6wvCtGbJda3WDVSqnMXTujvUD+6EjO3yNUkhPl7Xqr7mQnzNImcd0HaRADpfl9DFcogV
         7tVrCgUzvtIFhvpHWuenhUM4YM2J8Sl+wh2iRfLdmmB4LWPJuEn9DFcNaJFFWdi5jYMo
         8rc0hcRTyK0EmHhcwjEN3y81NRRs087+do0BHQjhglxFzUiHO16auxyv0cFHez4o8o8e
         1LPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yj9Fsb3ac8CLMeMAQN4Ah57VY515AoUcB41FgcjJ+ls=;
        b=gD7e7FhlI3/+Ahh2hq+1hs53M+SEpTIowz5+6/OIS2UeRCb/CBz9YeN/9ErkD1/Dzz
         Niw1NMnRksW3yYweUdScWZ1Is4r7UXTLpbmkd8/QbtWq6+2n042X4htpL6QmexlnPzRG
         27zQZBctQ4VumPdK51nZ9TmmXC5OwbEpM+MJAk8wUdDfKsZ8tQoJV0hePNbIM9O5iOeV
         ecvyibpObNGiRAUMpYl3eSuThpKmaCGs2xeI5F2gAB3+w1NU9HaL4WmQrnUlSNDxYeGg
         ZQ6tWkg37eYGECiOk3rYcGImvdmK0wYVbD4EdZxlxV24M9S1LJghZqTJbFncpqjFAf4v
         LlYw==
X-Gm-Message-State: APjAAAXzwsrUpxl22W2STfirDthRA/XDzdd1mPgcAyIg1s1XW4IpxQny
        M6ix8zWUptzhN/lKd1fMScUcINrfGDvP1w==
X-Google-Smtp-Source: APXvYqzKJ+4TxZT7uhINba5w+Id0WmuY+eHA8I9hFSUG8ge3d/IlbZPaajwEG1z2Njs1BTQ/k1osSQ==
X-Received: by 2002:adf:82e7:: with SMTP id 94mr29601584wrc.60.1579067571093;
        Tue, 14 Jan 2020 21:52:51 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v22sm21533549wml.11.2020.01.14.21.52.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 21:52:50 -0800 (PST)
Message-ID: <5e1ea8b2.1c69fb81.84310.a046@mx.google.com>
Date:   Tue, 14 Jan 2020 21:52:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.96
Subject: stable/linux-4.19.y boot: 82 boots: 0 failed,
 81 passed with 1 untried/unknown (v4.19.96)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 82 boots: 0 failed, 81 passed with 1 untried/unkn=
own (v4.19.96)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.96/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.96/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.96
Git Commit: db5b9190ff8202b609fe802ccde41cb28669389f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 51 unique boards, 16 SoC families, 15 builds out of 204

---
For more info write to <info@kernelci.org>
