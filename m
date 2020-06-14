Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBF21F88BF
	for <lists+stable@lfdr.de>; Sun, 14 Jun 2020 14:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgFNMXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jun 2020 08:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgFNMXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jun 2020 08:23:02 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6839C05BD43
        for <stable@vger.kernel.org>; Sun, 14 Jun 2020 05:23:01 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id w15so7890354lfe.11
        for <stable@vger.kernel.org>; Sun, 14 Jun 2020 05:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Btejqnmh6oqc5bOHtaw+fTSiPkuIdgf4wRXHxvccMSg=;
        b=DyvULmi6BF9TDRk5Wm9KgDEInnqCsRtSlOQotXXXDOOoCg35ZGK40RU2ZmLVS+aG62
         wL/o6Esm2oDguoWY/VB09fqVgUdm0gy/TdCKvF4qsQBRO6T1k9kHRTrxIpZQ5mC/oEJ4
         IRatf1CAud2ioc3J/OcEaSNYuDebzDhobqQrLkCjY+/Vx3I+tMDUEqgtxnFtJ8Z9jT2u
         NbXBqkFn0ZMhCZsQJ9dBtabmEOPR9Ihj756f+2hHBv4A64e9HbifYAfaHZGzjH67kUkn
         kB5cwiRe70UKvmpwTxLT+Qc8H4/zm2RMBA8kazU34A4xA0xgHhgKZaY+j7HJcXAcUNMV
         wBlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Btejqnmh6oqc5bOHtaw+fTSiPkuIdgf4wRXHxvccMSg=;
        b=J5aRZl8yr+CE+NWoYYhgC6BVLVZUG1W9cm7VtmrDXU9ao10nVvhlKXq6EmMVfq9B0O
         HwWOUE4wV39RqBnF3rjoUgGfJANHSN21aneJqO3ShlmTtTWWmdUYC64+1Wtxau4dEy6R
         KFmhAkTJKDUk9O3K+gkIY3xwOHPbfsFmoKEe18LLCVkT/4VxJxItcsF7+csyrMbqDmkF
         syHv3srfEw55/znJ28r00E0u0zi8uNY6gml+5Zs2DPTVk5UWyHrDuMV0LYT+iGoarV4+
         n9aefruUbM7OX/jOu0SWNao99tkWl9ksPKye30L5uOR41/0xn6/1RjBsUojWr8fTw+Hc
         Nmzw==
X-Gm-Message-State: AOAM532S5VeUSR/Lt75GmyMK0IiF3bs0fe/GLw+N2hqrdHesmMROYjnq
        /tGccAYGfkyquZvvJX317qR1L31YfTMOoGc/QEkUTQy4N4o=
X-Google-Smtp-Source: ABdhPJyTPFDQrphOQLurQ7bOJfBlcoKpe2TA8Usj1qoqt/FlwFF5zxiufs4421FdCBQ0Z/sX3vv0e7RotSE+59KiskM=
X-Received: by 2002:ac2:562b:: with SMTP id b11mr11278597lff.47.1592137379497;
 Sun, 14 Jun 2020 05:22:59 -0700 (PDT)
MIME-Version: 1.0
From:   William Dauchy <wdauchy@gmail.com>
Date:   Sun, 14 Jun 2020 14:22:47 +0200
Message-ID: <CAJ75kXaUoedk2UjQ74G2uYkaDUpanvYWtCNU78uX2vVSUVkmjA@mail.gmail.com>
Subject: backport status of "ipv4: fix a RCU-list lock in fib_triestat_seq_show"
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I found the following commit fbe4e0c1b298b4665ee6915266c9d6c5b934ef4a
("ipv4: fix a RCU-list lock in fib_triestat_seq_show") backported in
the following stable versions: v5.6.x, v5.5.x, v4.19.x, v4.14.x,
v4.9.x, v4.4.x.
However I cannot find it in v5.4.x yet. I checked stable queue on
netdev side (http://patchwork.ozlabs.org/bundle/davem/stable/?state=*)
but also main stable queue
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git

I was wondering whether it was an oversight or it was expected?

Sorry for the noise if I'm mistaken.

Best regards,
-- 
William
