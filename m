Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A303E308456
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 04:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhA2DrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 22:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbhA2DrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 22:47:02 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3D5C061573
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 19:46:12 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id q8so10554774lfm.10
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 19:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=mYi1wp0viKza6VgbIIJmkyD/7D5vkrUNAYmDb0nTdIs=;
        b=He6i1dwlHk/bymZGSrUGDZdyalsErm9znqihb1QLbdcGNMEkH7USRCQd9I1USO01d8
         hskiKWYXno9BXFS4utKU7k4LfUR4AiscdcoHVQk8krfWA86hpHiptWS5j8CaMiz+4Fdo
         S96s+LT9yI6WOqHQPC1uJGrBwX5QTVQy7LVnA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=mYi1wp0viKza6VgbIIJmkyD/7D5vkrUNAYmDb0nTdIs=;
        b=q1ABf2Q26e3onPelzm+nYeUt4zU1UgfoY4TaYEsX7oVmUoxQsrxCPxJQl5h/5Y6iBY
         yU+8tzWjUJ0aYjgsaEyc/DFqRwqpLUdq4FaMhQMxgqGQJRhJvoxW/MiPs4OIRSI1Ytp1
         Ea+/OlWUgD5AZ22omEpebNNxaaew9+37DtK+9NwNdbgZeP78V1UJMBBy5bATdbFuuEEz
         AIZhb8y8Y2x63qKKrFDkPW52UTPC8GSeGz8v2wo9yA12gadN5G2H0chKVhCVUsU+Xsvw
         pIteV6ZoVBzG2LX0/XMegGYkM7/+CNp3Q1DW5Wg4t1qurPfMT+t/KGA2qXjN5ZUr+6wT
         OKuQ==
X-Gm-Message-State: AOAM531hXQzXQdV8cRpo7bLL9yYVOhTlou8v4BLLLQZjI1AXvg7rT+bj
        rgrl6OIxRHyZNW/7sQyCf+/4Xusm1FL/+OA1dlMUbMPEARjTtwFd
X-Google-Smtp-Source: ABdhPJxFPqM2itcE3I7A/OwU9HljGCodQa3N+44GOPSFUIcG6V48HNF48Hscs8qCztJaelmrz6kydTnLRrRUg0MU0j0=
X-Received: by 2002:a05:6512:3190:: with SMTP id i16mr1127923lfe.200.1611891970354;
 Thu, 28 Jan 2021 19:46:10 -0800 (PST)
MIME-Version: 1.0
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Thu, 28 Jan 2021 19:45:59 -0800
Message-ID: <CABWYdi1Y3aZNZ5pE8upKz-gaevzQdGeH_H5VyhHJku0VU2ebiw@mail.gmail.com>
Subject: Backport mm/page_alloc: add a missing mm_page_alloc_zone_locked()
 tracepoint to 5.10
To:     stable@vger.kernel.org
Cc:     kernel-team <kernel-team@cloudflare.com>,
        Ignat Korchagin <ignat@cloudflare.com>,
        Hailong liu <liu.hailong6@zte.com.cn>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We're seeing a mysterious KASAN complaint without ce8f86ee94fa in Linux 5.10.11:

* https://lkml.org/lkml/2021/1/28/1344

It would be great to backport it to save others the same headache.

Thanks!
