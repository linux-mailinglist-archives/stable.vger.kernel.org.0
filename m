Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191D5429901
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 23:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbhJKVgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 17:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbhJKVgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 17:36:49 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133EFC06161C
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 14:34:49 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g10so72117650edj.1
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 14:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EiVrD2iDMBLBuofZXrBJ94/4zVuoaHiijnyH+PFPUI4=;
        b=sUgkyZRXsMgRphN+3Cln7odpz9WBkA07Z7nSznDv7LyV8d71mGBfBYUgBlZe0lIRVA
         Q1Yyy2I91YCTFRsqixHz2O0cXOKbPP/SXZXIwcFpIenOrn+5WHs+Hh3HPqDf9FF4YRp/
         T6mfEor8mUi4tukIbLoifQQv2VW1GLxOJbheoCx+V7JWQQbT+EFGMhMUIy4EH74jiU5k
         3GTDcQlRH4/1Nra5ghsU5kiWJBbK3A7vqOlAfDBQZKLQjbP/o0GUaEGB49OGax+67rqM
         dBDS1wxgcG4mbdENUpPmlvDCJZIUxKFe+AMwkSz5kNlEa9/UXgr4HtjwyH526toiA7Mm
         rsAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EiVrD2iDMBLBuofZXrBJ94/4zVuoaHiijnyH+PFPUI4=;
        b=P3pPit0IL2rnM6wepKpqhuEa/LKXZ14e10tHMAa7LIkkyeyfGfBCrXFlttlNoaHHRB
         Hlxm0c6dw6/kWI7DsiHp/sEwX+XqBObnGTZtAkeAHqHstKcoWVnXO3ChOyTBI0ItKtuF
         un+3n9OofisBYmgRJ7If2yxjmkk4Ge4ageyHhEJCNEEY1bP1aZaTn1WUgLk3se1E23Wy
         xzmpBN9Hom6+rxkn5IxQzPf+ZTfofyf/JMu5sBs66AeFRvSw/m81ftzDKirNNmfLFT7G
         /VMryqiKqyqcOVvFsQMPevdH0P2yrIdqojCbX7MYz59oRy3VkHJ+klLxrAlJb4YQTzm+
         Dkzg==
X-Gm-Message-State: AOAM533sqsS95zpL8uRDif06bFInYTI2sbSDOFptGQ3JfrUCXCJQv9gP
        RlK/Ezqi83IID+PWm9EQe7fH/Ln9jbtygZk/61GSkQ==
X-Google-Smtp-Source: ABdhPJwSiy6AaVg267aL3oPbb2eMX1xe0pHHXkjDBpG2vywKG9+bqelpJKF79VASCUvtV/kmN1sV++sHiqrEcRt1PAs=
X-Received: by 2002:a05:6402:90c:: with SMTP id g12mr5946787edz.198.1633988087485;
 Mon, 11 Oct 2021 14:34:47 -0700 (PDT)
MIME-Version: 1.0
References: <20211011134517.833565002@linuxfoundation.org> <CA+G9fYutz0ZgJ=rrg8=Fd7vh9c7G-SJfF2YoH5wZyGzUHu4Dqw@mail.gmail.com>
 <CAK8P3a3WYDbLm40OEMDcDfBJWRqfaWLvVQu4eD8W=UEjkBrpUw@mail.gmail.com>
In-Reply-To: <CAK8P3a3WYDbLm40OEMDcDfBJWRqfaWLvVQu4eD8W=UEjkBrpUw@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Oct 2021 03:04:35 +0530
Message-ID: <CA+G9fYubbNMtp9XX3AWb-7srT6D1B0rB8BLM8e1HSKeCM75u7g@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/151] 5.14.12-rc1 review
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> It looks like a really long backtrace, and there is something about stack
> corruption, so I wonder if the stack is actually overflowing here. Can
> you see if the same thing happens with Ard's vmap-stack branch from [1]
> or if that shows a different output?
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=arm-vmap-stacks

I do not see any crash on this tree and arm-vmap-stacks branch.

- Naresh
