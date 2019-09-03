Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390DDA628B
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 09:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfICHbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 03:31:41 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40119 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727625AbfICHbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 03:31:41 -0400
Received: by mail-io1-f67.google.com with SMTP id h144so18340036iof.7
        for <stable@vger.kernel.org>; Tue, 03 Sep 2019 00:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WQcHjUhIyykvxyf0B5rmcg1PJO8P3FdNmL23LoF1Prw=;
        b=H3mEkOYVFqhNV+UoiQWONlrqjx1bROERrYWrdH5nAJT0J2aP5wqBZ/0zFPdSRA2co8
         zheeJZDY4Z7xi1cFcCbH+BtZLk0jNuT8nDT5L5Fqk5E6SWCee21F2rT/Jm5KqFmuGG88
         81VqtVfZq8W/YamTp9w5pfn6bjp+LOBgKqC1c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WQcHjUhIyykvxyf0B5rmcg1PJO8P3FdNmL23LoF1Prw=;
        b=PPmb5Cvkoyi/lpA1atHAuILaU+CiKWlmSL8zxto8iFQQEwrQb/xchF8WYKEFQpBO2M
         0snvhYBtHhmRzWsWjzhP4pPuF8z0FQCMwiF0y3JSx3LzYJ6YNsU2mh+iDPesyaPhYISb
         EvtgORXKsJpYXKrdL2Rt8K6eRwhQJ/Y8K03ywih1RL2Mf626c2a5t02/3e6EdHKLXg/k
         uNKH320hmziJX+hz3cMI+xhxmfTAeDQX3e4gXeqGukexA6caoVxMneC1DXCMAtMkGkFO
         DTb/ZracevwuogxbL9bvQPE7bJ5Exs8CJFfwb9AfIo7ffM7Nr39WeohrKeWWKuarjJiN
         n43g==
X-Gm-Message-State: APjAAAVhaLyQycNSQprTw3br3Slg402/ALIP+7ypW/yKxvj+eTzDgSpm
        +5KjuQe/xsYBqDif7RA3uPU2/F/pTVY8kJGQDPGRrA==
X-Google-Smtp-Source: APXvYqzCCZd8wb8XYWpHZ79t+YRe/yJvetmgBZ/bUXD37N+JpwrIqN065yTsFZRINx9dnoBuaycQwH/36BlLS6YAkmk=
X-Received: by 2002:a05:6638:3af:: with SMTP id z15mr35450863jap.39.1567495900451;
 Tue, 03 Sep 2019 00:31:40 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008d8eac05906691ac@google.com> <20190822233529.4176-1-ebiggers@kernel.org>
In-Reply-To: <20190822233529.4176-1-ebiggers@kernel.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 3 Sep 2019 09:31:29 +0200
Message-ID: <CAJfpegvHgcZGFi-Ydyo2j89zQxqAtZ1Lh0+vC6vWeU-aEFZkYQ@mail.gmail.com>
Subject: Re: [PATCH] fuse: disable irqs for fuse_iqueue::waitq.lock
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-aio <linux-aio@kvack.org>,
        Benjamin LaHaise <bcrl@kvack.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        stable <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 23, 2019 at 1:35 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> When IOCB_CMD_POLL is used on the FUSE device, aio_poll() disables IRQs
> and takes kioctx::ctx_lock, then fuse_iqueue::waitq.lock.

Not in -linus.

Which tree was this reproduced with?

Thanks,
Miklos
