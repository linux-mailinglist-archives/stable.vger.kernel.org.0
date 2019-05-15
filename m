Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C50871E663
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 02:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfEOAsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 20:48:35 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:38127 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfEOAsf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 20:48:35 -0400
Received: by mail-wr1-f42.google.com with SMTP id d18so124681wrs.5
        for <stable@vger.kernel.org>; Tue, 14 May 2019 17:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iq4k+Bw0TY/n1PwGa5fsTUz1ZAOPYY3bpBeir4zVvV4=;
        b=dLvW7ErrMlOo55uH/Beig1uqQH2dEXrlX52JJVMj/quzuXP3T/eulPiC3FZzZ1ivnJ
         87+feQrp0irCntGGtTgwr16Lti4CRAdpfq6jxQZgHfiB2wGZWa2V0WKIRtXxwAOrrK+c
         iJeMol+A8FmN96D2Pp2B16nr+ICEqHI3limrExLHRl+nqgkcDW+m81wj+SicWjQbzFEL
         jQJYHEwHwEecygvruCjjaMa3IX6mJBTUwAyubCyIFEKZmxqNibhzNwh169ZPNJuZk1wi
         cfhNMvxSQtkUePQz+3ajnS95YJ0k5AxlxwBrtyAkQUg+GuwS77VKg1jeg+OSr00bH0oD
         j+AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iq4k+Bw0TY/n1PwGa5fsTUz1ZAOPYY3bpBeir4zVvV4=;
        b=fJtCmRhoRbiyzhoypEzl4i64+h+Un4I7frmqzjp/oYHRCvFTt6K2ehmSEXqRzSpmYr
         kTxStJGVzsUCgaM/tkxEfxy+wM7zneGAh/x0aLoGvyHfyQcLwHegMPy2WJMF/JR6VVpt
         FB7qC0hTskK1RZ1Hf8lH2+wLU29VRl9EdEnMkfEouZFYuKqfioNfKAijc6VJdBwgwp3G
         sFkT7cmGLmkal6hbtIolLt9LjqBlCnAQjpJxoFMT1jxSfeBsKRq3o7llDVm7ASGoWdAP
         3MIfPkAvfiTBpHa7/07KvZJNoPNm0JYKUc1JLPp5XB0/3o0UrgQ6C5YiA40uHskDHlqd
         l26A==
X-Gm-Message-State: APjAAAXosJqMuWgEUosR6A5sy8H9xEAoHzK2kyU/d8T1w1L37BdvTa78
        mqBj/9g7iYF2gTdp1rTXPvziCt2jEnTE2w==
X-Google-Smtp-Source: APXvYqyNNjB9nSe+TUcMg5I0UGbZsRrvP7FMm34y4CJAvfpjI57oTi/Z+SaZNaY8OrsOWShSX3NQFA==
X-Received: by 2002:a5d:624d:: with SMTP id m13mr23208737wrv.305.1557881313336;
        Tue, 14 May 2019 17:48:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s13sm379980wrw.17.2019.05.14.17.48.32
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 17:48:32 -0700 (PDT)
Message-ID: <5cdb61e0.1c69fb81.a5b77.20a2@mx.google.com>
Date:   Tue, 14 May 2019 17:48:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.176
Subject: stable/linux-4.9.y boot: 52 boots: 0 failed, 52 passed (v4.9.176)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 52 boots: 0 failed, 52 passed (v4.9.176)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.176/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.176/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.176
Git Commit: ffe8cffc8be1ae47c08cbc3571bed6b5b0fa53ad
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 23 unique boards, 13 SoC families, 10 builds out of 197

---
For more info write to <info@kernelci.org>
