Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0588A25AE68
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 17:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgIBPIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 11:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728161AbgIBPHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 11:07:44 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7B2C061244
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 08:07:43 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id ay8so5254037edb.8
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 08:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iqtdMv3abzowF/OEz4wcuhtXvzAi2z9jpfg2F4BfYcQ=;
        b=WFazUa4N61ifRJlnYQHi8O9S3VgAQMEPTdQEauJq7V2cJtliBhrn7WCgagzenlabh4
         1gyL9aY8crPhiyzjc4af1FEWfM/i9SIIo/I2RHggzET3mAElA8fGdMwWqCHOyf3U7O6u
         Ox0xXERxUlpdf3k+sXglb6ZstIzJuZBn1x2r8/gki55tbfJlgC15saOfBdVXAqVb3+9h
         kL1HEYIPU7O4wZMJtrGoXgyjkYSf8OV2E0mBNOX+KuYEGx2eLgkuuXTH791x5ObpQewF
         aWWYtrIabLPO96AyUveKawZcylp0oO2ZYryhleKlGtWX78aAyfGcbeH2h15f739ZsiBC
         KexQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iqtdMv3abzowF/OEz4wcuhtXvzAi2z9jpfg2F4BfYcQ=;
        b=XZBK7VqeGId/XlGbfFtW0tnqbb38UwxEFIdzZVY6HlZDbJoH2In6TGy8MYT01vAjU0
         4/PA/o7WaxdpQf60XmMXT62LvKI/sqlfYGxx3fRvyQyAZOMF2zQcWW9fSkDezjnOkx5y
         7fMuQQmyae7H94vCR2QHOkc1FOqiF4R+U+lJ5uag6dSTHCPskDBqMtJSZYczpmQE9lvb
         YAe0c9j5M/PN5vXsL7mxlDnR2598MLOU9spZr0Qkvr4Ak43GLd7CSihUqsMVgSN26RIw
         A7VyqhgzW1zrhJGFw9wHs6tuoQDEkaX+oAwRJIHvEH+CTLM7VjOLrhIjKX7SJV7BUVHw
         cAwg==
X-Gm-Message-State: AOAM531SFiqp25LETBXqti7lX25rHyqhoVb0Sk8EG+aI+hMwNkutEmiZ
        QpUFiRSMp5I6acM4q4kt8hE6Ms6m1RtebXAjt+EgMQ==
X-Google-Smtp-Source: ABdhPJx3oPrgloSJR/eq46KKD2oHcFLZPUHKiGlAscJwY6J2sF2WA0sH/SCWXnxKSFhupXpvVv/x5Ynz0s8G3eMIfgM=
X-Received: by 2002:aa7:d4cb:: with SMTP id t11mr473083edr.223.1599059260713;
 Wed, 02 Sep 2020 08:07:40 -0700 (PDT)
MIME-Version: 1.0
References: <1599040779-41219-1-git-send-email-jiufei.xue@linux.alibaba.com> <c278224e-314d-e810-67f3-f5353daf9045@kernel.dk>
In-Reply-To: <c278224e-314d-e810-67f3-f5353daf9045@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 2 Sep 2020 17:07:14 +0200
Message-ID: <CAG48ez1MLMDPLA28HhRLcp+skk8KBawMq7qLv91kNY_prkZ4uw@mail.gmail.com>
Subject: missing backport markings on security fix [was: [PATCH] io_uring: set
 table->files[i] to NULL when io_sqe_file_register failed]
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 2, 2020 at 4:49 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 9/2/20 3:59 AM, Jiufei Xue wrote:
> > While io_sqe_file_register() failed in __io_sqe_files_update(),
> > table->files[i] still point to the original file which may freed
> > soon, and that will trigger use-after-free problems.
>
> Applied, thanks.

Shouldn't this have a CC stable tag and a fixes tag on it? AFAICS this
is a fix for a UAF that exists since
f3bd9dae3708a0ff6b067e766073ffeb853301f9 ("io_uring: fix memleak in
__io_sqe_files_update()"), and that commit was marked for stable
backporting back to when c3a31e605620 landed, and that commit was
introduced in Linux 5.5.

You can see at <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/io_uring.c?h=linux-5.8.y#n6933>
that this security vulnerability currently exists in the stable 5.8
branch.
