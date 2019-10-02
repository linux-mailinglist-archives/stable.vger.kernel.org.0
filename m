Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C506C45FF
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 05:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbfJBDCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 23:02:02 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:43896 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbfJBDCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 23:02:01 -0400
Received: by mail-wr1-f54.google.com with SMTP id q17so17747169wrx.10
        for <stable@vger.kernel.org>; Tue, 01 Oct 2019 20:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4A2LKf76M9vb22pP1t+xNF1nXyuEgvGB+/7jyMXO0Ek=;
        b=rn3jmw2nTJuSiex+3O5ZjOElVoCCdKtXE9+pCZJvISDM4iC0Eujy3oMopSvnXibBQq
         fjK+qB/+X57bKBGWW/W19DsSrfuQitt+BIjY/RwxvCJFXp78cQYbI9MNtrdH+V3LOBrB
         fzJ8E5wkd4kFplXZTKreSfXM/3NdTZ9U1/F7i50PFFkq49HZt5Fz2pIL97cRxCsGBKTs
         MCGVbNlg6yV1Q7pGjChXy/72gi0QCJ0j/Qg5A+85KiThqMl0utBjRszncbvKfEvN9L29
         DLhu/QrgX/qNt2g8Shf2plA1pI+zZ20ASXfsvNLK5qr9ngxPLlzQNtkuW2GY2exviv8v
         HNzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4A2LKf76M9vb22pP1t+xNF1nXyuEgvGB+/7jyMXO0Ek=;
        b=RZdQhWvGGW2nQ/8gD1SIv5g7QEJfbt2oxzKizVm8G+PPCrxg+PEomeGkAPvb2yQ6Vw
         IboZ+c86ia3pg4eCGRsmd+5qjhywxzN65tmXu10C2YwXQ0w+d7/mp3cN0jSRHEzdo/zI
         niwyGSj8HX7skdtqNqYqTaShRdjRzm7GMEHkegeIzdXK1mepUzcHDiqYLkHNrIyPxCuD
         JxGXa0GQ4bKov1I0mofK201N8nXThCMTpNJxK5K5JLbUIc10jwNFRxRL0MKwH8Q/XAeN
         RVfemAsuwtOMrUXMbMOE5S+BQlqMFw+hy7vejHPdXCMDJKm2qx7j7bnhxDEGDCe1hKr1
         swTw==
X-Gm-Message-State: APjAAAVL56FT3LtUa6rSrcGyLv/eGM2wBwAiXfTMYTPb2IfLBUX5AjjY
        BCqoM4BE7DmuglRPY223hf1qoHxdyvp1vw==
X-Google-Smtp-Source: APXvYqypUWVCWYn5zw3rCqUU4eKlHUFBJZ8uxKC8OArra62upKLkZGcfVy401NhEllkd/Ac5pR+ZJg==
X-Received: by 2002:a5d:5229:: with SMTP id i9mr689004wra.76.1569985318984;
        Tue, 01 Oct 2019 20:01:58 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z125sm7689135wme.37.2019.10.01.20.01.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 20:01:58 -0700 (PDT)
Message-ID: <5d941326.1c69fb81.bab35.6c8d@mx.google.com>
Date:   Tue, 01 Oct 2019 20:01:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.146-147-g990856f784cb
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 75 boots: 0 failed,
 75 passed (v4.14.146-147-g990856f784cb)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 75 boots: 0 failed, 75 passed (v4.14.146-147-g=
990856f784cb)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.146-147-g990856f784cb/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.146-147-g990856f784cb/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.146-147-g990856f784cb
Git Commit: 990856f784cb308bf8e1390f6a6c97e43835e673
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 36 unique boards, 15 SoC families, 12 builds out of 201

---
For more info write to <info@kernelci.org>
