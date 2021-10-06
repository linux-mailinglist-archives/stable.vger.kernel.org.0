Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272C74234BA
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 02:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhJFADb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 20:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhJFADa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 20:03:30 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714C7C061749
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 17:01:39 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id m20so174940iol.4
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 17:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=NQV2ijUtmD2hl9XjuxnGKiLNYkXrYSdUgnAALPZcSOA=;
        b=Ou/+Bybt3I3Iv8+yZX0Hv7j1zLPUGwYEduxLaIc2jkTyuqPCw54isZyo9Uh0YvVuub
         ILR7n6Y2Qr31tlb314eMjPsSpHtn4fYovsFqbSpDK9PjeiU9XUBoaQGaQmmSgYLH2go9
         tsMSVsdHTYvgUg0wlcEinTiypz+TC7lnEXTiQvnHqUMFXgoR9QWO6fqFPKBD/QauIbnY
         iYorpyzTKfq0NajzgKzfX7bGvrileuqj4/fKiDHPlFrIvfwqQezlsp/9JbFyfH5PH6Zm
         vddlcQ8Kw05QKeHxHH8PhtM7sgaqAqd5fH/nyTRjFlqEtRMI6yVjypim91SfJ3XEFE9+
         SIqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NQV2ijUtmD2hl9XjuxnGKiLNYkXrYSdUgnAALPZcSOA=;
        b=foX0fOENqhaPqp1P28doZE5E/OKeBHU1v0qfGBf8b+i5H8eTosPKNblCdOX/KlxJRr
         jfK1FdtGQsMslCujx5Z+j1mn1BAbNvLsQkLfJXKRPG1wfqaDvZ3Gn3C6ZEcyD4OvLFYX
         hPGlW6ySFVlZqyzVMX777+VSBNJk/MaCE+zMqA2McCM1Hyl4bM7U9UG6drxJBKXpdO5j
         5//46fMN3KFj0bRtXksjDPXGa2CWC5FFRqccAr8pQGq3cMpUssnSaa8x91xywtaQk34l
         ohEM7YPZt/MOTxJbV/PD2pVfZICIAOSrAIV8DUjTwnfZmhWmeA2cEV9wXTcGWGlLYMIf
         h3uQ==
X-Gm-Message-State: AOAM530YWVETSefsI99mtGfZhFSr/Y7YXm9HrBTzjwSqYhbaltH2qeOs
        cZbiB1liAOYCRACbyZLIzEARc7Q1QOqEh8BzB5tpXwUA2Hsa1A==
X-Google-Smtp-Source: ABdhPJzni7g9DETDghsnQiZiFbLR4XK1L1+biePrGxhM6y1M+KN4GqXsEBJ/KWwd4+HQabStPwyhqRVa4zJuYIoYSy4=
X-Received: by 2002:a05:6638:25cd:: with SMTP id u13mr4877931jat.114.1633478498361;
 Tue, 05 Oct 2021 17:01:38 -0700 (PDT)
MIME-Version: 1.0
From:   "Anand K. Mistry" <amistry@google.com>
Date:   Wed, 6 Oct 2021 11:01:26 +1100
Message-ID: <CAATStaPx9tLmkUKAn4R82MKKzr1i3sL-ivgHvFUjf4qf=eSLbw@mail.gmail.com>
Subject: Requesting stable merge for commit 02d029a41dc986e2d5a77ecca45803857b346829
To:     stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'd like to request commit 02d029a41dc986e2d5a77ecca45803857b346829
("perf/x86: Reset destroy callback on event init failure") be merged
to the 5.10 stable branch.

This fixes a bug which was exposed by commit f11dd0d80555
("perf/x86/amd/ibs: Extend PERF_PMU_CAP_NO_EXCLUDE to IBS Op") merged
into 5.10.65 (as commit bafece6cd1f9), and partially broke perf on AMD
StoneyRidge systems.

I've tested this patch locally on 5.10.70 on an AMD StoneyRidge
(A4-9120C) system.
