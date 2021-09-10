Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43564066DB
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 07:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhIJFhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 01:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbhIJFhF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 01:37:05 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A2BC061574;
        Thu,  9 Sep 2021 22:35:54 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id x10so852234ilm.12;
        Thu, 09 Sep 2021 22:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tLXBpSkKxNkrugueLnZmnSC7kwKwOUit3SCtO4MJFbs=;
        b=TXvA2GU/R4DmCZJMTpXr6A2ouW0uChXYTZQwYaGRYAqtjfw2x733rQDGUUxMfemy0C
         vFNlh7gsI2GKyLHSIITVtgSQnP6Pmz4Cs4hbKlWQsKTzomZFr6y65RVNTMrWhrgYL6So
         pIwSIEK2TLiBw05/lgfs1wvsoiw+vL6gTU4thyet/ADY6mQkIPK/oiIjT4CVcCwOp6ep
         BWtIrzdcQCE1GDE6cSQSv2qUsTUceBIZUq99C6WeSUms2Ch8UZDGjbDWc1V8MJaEJDZ6
         U9N8yUSS3Pz39Tj374CmHpDksJ0QnZ+DuOjyhgKW6b32Rxm+gejC5uDGd1tfbdtxeFfk
         MzuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tLXBpSkKxNkrugueLnZmnSC7kwKwOUit3SCtO4MJFbs=;
        b=Ts2dwuLI6kLaj/ja6SRoq4ZsEKSebT5L5/YqYGdeCp+/5nWrN4vzj9sFe6jKTPoZe0
         7JmRMUgn7NwJrwETOT7PnRgkckDpASgUqfKDGn57YJfYXspY+SYZlPays5uSqtiN/i+g
         +2OnDtD1fTGLf2aROQZQxQAyJ2ScImDkSwwhD74lyLxE9lvY6hQp7AUlPft5qJLI4MOM
         B0MmxNA1/J0iyhk13hpTnfl3yFw4wqTHO6fexUDYrinfvISskDnv7X3IxtGkJBqCHHWi
         MznEoK8SPn6HC68/b17CzjPQrRtV2IQ49cUFK/Nd6hgDVZmgaZiWcuUs6LQkzYw4wtOE
         IPDQ==
X-Gm-Message-State: AOAM532sERxr8x2wqpsWZgAE7azWEyRjuFYdHbNcs5gdfzDEhI7ehGsQ
        Ib4J/Wa45r6ExNAh40eALis2czisPjBfzRc+m3cLTNrDQdI=
X-Google-Smtp-Source: ABdhPJx4MM8hv+bkFDlbeP67z67/hbkMekdbNTplfGHmIuMSnCpsD1nCMu9r6al3tvxi9ctE+dSJLICqxe2F/8c2wiE=
X-Received: by 2002:a05:6e02:198d:: with SMTP id g13mr5184331ilf.319.1631252153979;
 Thu, 09 Sep 2021 22:35:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210910001558.173296-1-sashal@kernel.org> <20210910001558.173296-46-sashal@kernel.org>
In-Reply-To: <20210910001558.173296-46-sashal@kernel.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 10 Sep 2021 08:35:41 +0300
Message-ID: <CAOQ4uxi8Ae8Pk1bUDNmQgCvEn_SoXXeW4HsNV5k2+ceejevrLQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.14 46/99] ovl: copy up sync/noatime fileattr flags
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 10, 2021 at 3:17 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Amir Goldstein <amir73il@gmail.com>
>
> [ Upstream commit 72db82115d2bdfbfba8b15a92d91872cfe1b40c6 ]
>
> When a lower file has sync/noatime fileattr flags, the behavior of
> overlayfs post copy up is inconsistent.
>
> Immediately after copy up, ovl inode still has the S_SYNC/S_NOATIME
> inode flags copied from lower inode, so vfs code still treats the ovl
> inode as sync/noatime.  After ovl inode evict or mount cycle,
> the ovl inode does not have these inode flags anymore.
>
> To fix this inconsistency, try to copy the fileattr flags on copy up
> if the upper fs supports the fileattr_set() method.
>
> This gives consistent behavior post copy up regardless of inode eviction
> from cache.
>
> We cannot copy up the immutable/append-only inode flags in a similar
> manner, because immutable/append-only inodes cannot be linked and because
> overlayfs will not be able to set overlay.* xattr on the upper inodes.
>
> Those flags will be addressed by a followup patch.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Sasha,

I do not recommend applying this patch to stable.
The value/risk ratio is not worth it IMO.

I don't know of anyone who ever complained about not copying
the NOATIME/SYNC fileattrs specifically.

This patch is more of a complimentary patch to the IMMUTABLE/
APPEND fileattr patch, which is not appropriate for stable either.

OTOH, ovl-update-5.15 has this patch that was not included in the
AUTOSEL batch, even though it has a Fixes tag, CC stable and
very strong hints in the subject:
52d5a0c6bd8a ("ovl: fix BUG_ON() in may_delete() when called from
ovl_cleanup()")

I suppose AUTOSEL leaves these sorts of patches to Greg's scripts?

Thanks,
Amir.
