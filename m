Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04920255D58
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 17:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgH1PHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 11:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgH1PHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 11:07:37 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B284C061264
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 08:07:37 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id b79so1209630wmb.4
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 08:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=cMJCZef88/76+ydnINd6C6es1UNf8bWnUyw44uCVnKA=;
        b=Szc2Haw1YoVJbeJE/ybhscJG6KSmFGrOtSrYs1e62sY1LkQv6iOaTsRHGaaOgFBCGU
         Gkq4fQNkPWFo+638vx0a5BBr51QqNivxwWN16LGFO60QL9DKvWIKWpb5M3MHnSoHPjD6
         JKnWCpjM3cT3hu71Jy1T9Y5gV2UdbSrQXZAyDiUluCbNGM4MHX3g63jHsJQIVocAIe0L
         l9N1iUjCFk4Vx/uWWUcy2I9HpkHz+oPLroPXhk6WD77Lsmp3KJdCHlStD1G1/+U2dceH
         yA33JxTgIPCcp/bFneYLT+loG4seRrO9PNDjGgy/IHyNq9hN96SZuDTWbATNpldmkljA
         5YfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=cMJCZef88/76+ydnINd6C6es1UNf8bWnUyw44uCVnKA=;
        b=KpKXGqNfppeyp0oiErWSQc2W2OAhgBZK/TKOx+YKe9PeOZuIHWu7RjjyKVO2sw3+Le
         +Pz68vSd89iLxY+ju4lyQ/VPCgU08pcY+FyklkAbuK2YzZPt4pPXJ860WceSsPhqZsy0
         HjIXE9yi3I4YzbTPibx0Y/CA8WBsm5yoMpbZ9cyb1Gr0hzV4kyEjwRB3TvT+/CKtjx3v
         BdeN5xj79WZKqN562wI9Jdt8vR1R8UvBTX6+fzUbsCFd05nOOjdlgEN//d8ur4RBaEpj
         vYmz22chR90ROOyhU0oXerHQBnoWLgNJFbiCnveHCY1GS4FbN6eRrMpSzmDLyByPTMmN
         CJYQ==
X-Gm-Message-State: AOAM532VPy4XWsnty6ulfF5VCzTjYJSo+8Mg7hVeSq3/l9DVwLOMARwZ
        gnWwbK2JAFsHO/VZa1JqqU1pRvS8eUiBGaEuKbuVtnZShbM=
X-Google-Smtp-Source: ABdhPJyVY58JJ0srpWzx8y3m63bFzlYvxqdiddHi3ECrGCzQkmMwURHT6NnVseflLn39Rv0FF6BGlfP8YF05/DLolOY=
X-Received: by 2002:a7b:c401:: with SMTP id k1mr2024756wmi.18.1598627255429;
 Fri, 28 Aug 2020 08:07:35 -0700 (PDT)
MIME-Version: 1.0
From:   Nick Lowe <nick.lowe@gmail.com>
Date:   Fri, 28 Aug 2020 16:07:24 +0100
Message-ID: <CADSoG1tJ5sujd17zZ2CV4gNLKwVrGkRxw09qvfB24MOLOr0_oQ@mail.gmail.com>
Subject: Stable inclusion request: Revert "ath10k: fix DMA related firmware
 crashes on multiple devices" for 4.4, 4.9, 4.14, 4.19 and 5.4
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please can commit a1769bb68a850508a492e3674ab1e5e479b11254 be back
merged to the 4.4, 4.9, 4.14, 4.19 and 5.4 LTS kernels to resolve a
PCIe hang with Wave 2-generation 802.11ac QCA chips?

commit a1769bb68a850508a492e3674ab1e5e479b11254
author Zhi Chen <zhichen@codeaurora.org>
date 2020-01-14 12:35:21 +0800

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a1769bb68a850508a492e3674ab1e5e479b11254

The issue resolved is that a value of 0 has a different meaning and
instruction depending on the specific chip. Wave 1 and Wave 2 QCA
802.11ac chips use this differently.

This meant that the original commit introduced a regression for the
Wave 2-generation 802.11ac QCA chips when seeking to resolve a
firmware crash issue affecting some Wave 1-generation 802.11ac QCA
chips.

This subsequently has only been partially reverted via this commit,
specifically for the 10_4 target only via TARGET_10_4_DMA_BURST_SIZE 1

The original commit that caused this regression from back in 2015 is
76d164f582150fd0259ec0fcbc485470bcd8033e

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=76d164f582150fd0259ec0fcbc485470bcd8033e

With thanks,

Nick
