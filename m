Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21958424A85
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 01:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhJFXab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 19:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhJFXa3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 19:30:29 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132A3C061753
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 16:28:37 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id p2so4760283vst.10
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 16:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mliJ3L4jhXygNAQVvyfh3C51SF5VAYCq+PUY3yCWUww=;
        b=qi5Ix5Ey0HFp6L9+Tb4s0zGqPaWH11DuG+iN3lkQA45yIab1Igz9/t/wCd7KCEV28y
         JxYKiC9codL3nn9bXsqMDsfa+SeQx8h3Nvr7trPCbJDT8y8sfyHK6MeY640ofUooBqwE
         ZnWo2XX3gmZo9YozyxTto3ZVKMMM8zoNmKa9L9nfcbIevffVD/B8HV4B0AX+IFaDu0u/
         9RLvfgL6PhTG7pbofxOwM2VphykA2gfzrP0NVMOAyQxiNwxFLKJXZE0FiN/gZ0Y4hWbV
         6ehP2QTUVK1K7Ddq+kPCPs28QD5j5PLJ3qrOBNFwhLJ5V9zhf8eM1uCNO6iEZG/pCOFW
         UUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mliJ3L4jhXygNAQVvyfh3C51SF5VAYCq+PUY3yCWUww=;
        b=B5hHBC3pWwl5CaI4GzUwHlDMXUu9vUqFKVpWGS+4E+Qf9YiMcRQ9UeFZQacvwsjMIR
         9cl88zHtQenOWN/nKrzrcyAIGyYu29NDJ9zE7vYtkBPFOZOqhRD3Ob8Sl2vOXHc+3GB6
         WdR3m5Z3CdDH1jrXW60CWU8BAXIJAxnuc5v6z2wDZi5gpz6ReMxUhowWsQm477lOivB/
         xiZ4Leb9Nzq2ivv8BaQKrio4yjxjJJCWoJFZ71Y6JslFFNRAza6756pOHPTmbg5/Fadu
         1iq01L1V7kGg+8XBNxv963+OmMAms8wbaPNqG7GT4qGhdluJi5uWhBfut2ftCp0fbFJ9
         rpsw==
X-Gm-Message-State: AOAM5319CRfXKCjVzAbjXziPCZSZCEQaJqkDeHcmhIt/1l0q9NpPeX/K
        Ki8ySLlYUCV0mogSOtyvF2t39BpjgBJgyoBeJC1V9Q==
X-Google-Smtp-Source: ABdhPJyHZF+bCbZ/lhqhjeh4XfDC8463ZxocSj5ca/etIelqyFKTTO3mnN4tAgT9tT0+uYirAM20MNrBJZXma3nZNAM=
X-Received: by 2002:a67:df16:: with SMTP id s22mr1310976vsk.47.1633562914708;
 Wed, 06 Oct 2021 16:28:34 -0700 (PDT)
MIME-Version: 1.0
References: <20211006224311.26662-1-ramjiyani@google.com> <YV4nnko8rmWAWj2+@gmail.com>
In-Reply-To: <YV4nnko8rmWAWj2+@gmail.com>
From:   Ramji Jiyani <ramjiyani@google.com>
Date:   Wed, 6 Oct 2021 16:28:23 -0700
Message-ID: <CAKUd0B-9ifaMBAxhaUZjppks8PCy4oCy=erRNnPBjrRxOGKUxQ@mail.gmail.com>
Subject: Re: [PATCH v3] aio: Add support for the POLLFREE
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     arnd@arndb.de, viro@zeniv.linux.org.uk, bcrl@kvack.org, hch@lst.de,
        kernel-team@android.com, linux-aio@kvack.org,
        linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        Jeff Moyer <jmoyer@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 6, 2021 at 3:48 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Oct 06, 2021 at 10:43:11PM +0000, Ramji Jiyani wrote:
> > Fixes: f5cb779ba163 ("ANDROID: binder: remove waitqueue when thread exits.")
> > Signed-off-by: Ramji Jiyani <ramjiyani@google.com>
> > Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> > Cc: stable@vger.kernel.org # 4.19+
>
> The commit that this claims to be fixing is in linux-4.4.y, so either the fixes
> tag is wrong or the Cc stable tag is wrong.  It's important to provide correct
> information here for backporting purposes, so please do so.
>

Stable tag is correct; Fixes tag in this case is tricky.

In 4.4 only way to poll binder file was via eventpoll and since binder wasn't
flagging the POLLFREE before thread exit there was an UAF. Which got fixed
by the commit currently Fixes tag is referring.

Later, aio got enhanced by adding a polling feature in 4.19 [1].
That introduced one more way to poll binder files; but it did not include
support for POLLFREE, so UAF exists.

Should the Fixes tag refer to Commit bfe4037e722e ("aio: implement
IOCB_CMD_POLL") [2] in this case?

[1] https://lore.kernel.org/lkml/20180110155853.32348-32-hch@lst.de/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/fs/aio.c?h=v4.19.209&id=bfe4037e722ec672c9dafd5730d9132afeeb76e9

> - Eric

~ Ramji
