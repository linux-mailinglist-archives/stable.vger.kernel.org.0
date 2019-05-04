Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA5AA139C5
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 14:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfEDMam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 08:30:42 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:52299 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfEDMam (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 08:30:42 -0400
Received: by mail-wm1-f44.google.com with SMTP id v189so1310652wmf.2
        for <stable@vger.kernel.org>; Sat, 04 May 2019 05:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n/CnZqQFA8qcQo4I60T5J5Yx+vODIlNztTuqzdr6c3M=;
        b=r7Lmnaqi26fFz7AdLXluJSEx292sfmNyMhYRBKE5bmVBumnx/wcuokKYqcAiHWCvOG
         nyCsGJ7KW70jbeAqOf1HCvVpjnOPzQeTtK6EDgyvVv9Y4dM8A9W+LK+wh7Mx7D88Eck5
         3yDksc39A4bG9y+k94mxpyzaXiZEAnY8rmFmkwhP4IfSvFNtQprItrMPA6tE1nJSnchu
         syTzpkt9KWUqBbvaAdBIug3q6A8mdwkbX3LQsEWgnarTnDRDBhO9OwTLAdPPG83P36wc
         sYDFGGrcRoSqpeqmv6TIGvDOa/s9Js8b9i83prf5faSNR/5sXsm4zfOzkiI8DIDpFOIW
         3CBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n/CnZqQFA8qcQo4I60T5J5Yx+vODIlNztTuqzdr6c3M=;
        b=Dx2cRv4z/TKYNtHTtklalNbv44KPO3ZP9cJg2QEQaXUVuSoUFl6x5pDAzzmILZPWi3
         jJlGiNxu+MVEbyZ4arLXbEDhs+p+EigTC2+yQzxqzhYZGdxASPEbmSIDIMZlyxCB+XZz
         xEWTRuCv/bpzZb/+fz3zkDR/caUuug+HezsB8r3KHlVTvLeLRjKTGMUSwsC45aJagdfD
         R2D7QG2WYatTIupgnmpVKDm5nwERZlgDIwj5wJDu8csTQtIIjRrNUhEnNBAFS6WYdlVj
         IDwknmnhKAvLAjNIwkQLbhY1AfqVFDpAkt3FGt9NNX0rhp3lO9xq1AGaLXaBWZpXXYyN
         AJLg==
X-Gm-Message-State: APjAAAWVtD8qmU+CQeIh+X7pq5z4Fqua4uCjnzWPwC0Rehjj4bvepPKY
        fXUcDmnFqySJgBAF9HMsl7I6sMcnxvnIgQ==
X-Google-Smtp-Source: APXvYqzDr2FsuXCMRBNPEIIFX6zHB49GRBju6Yx9BAMkwJwgv//YpbVa3BQQOnUduRBLYg1pqnZ9bQ==
X-Received: by 2002:a1c:14:: with SMTP id 20mr10534781wma.66.1556973040647;
        Sat, 04 May 2019 05:30:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v189sm8492006wma.3.2019.05.04.05.30.39
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 05:30:40 -0700 (PDT)
Message-ID: <5ccd85f0.1c69fb81.5d408.09ec@mx.google.com>
Date:   Sat, 04 May 2019 05:30:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.39
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 62 boots: 0 failed, 62 passed (v4.19.39)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 62 boots: 0 failed, 62 passed (v4.19.39)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.39/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.39/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.39
Git Commit: ad119c970bbe966222eaeb063138e430a78ee27f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 34 unique boards, 15 SoC families, 10 builds out of 205

---
For more info write to <info@kernelci.org>
