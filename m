Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B6E298963
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 10:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421923AbgJZJZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 05:25:37 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45554 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1420953AbgJZJZg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 05:25:36 -0400
Received: by mail-lj1-f196.google.com with SMTP id a4so8977353lji.12
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 02:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ILBEi7HhY+66PFbpkznsafcADsz/MB/PBpRDU2DSzE=;
        b=Zeqam8u8BZg9/+wfMgKJwNlh80GLDU0U6bS0FaSWSZbhLNDAASKv1Ca9VdjBKolTcf
         oSGon9v1u5P1XZlzM9lq5e7lHCYvENaSBhByRLgzID/yYCS/Q5MUxC49drsi/vTf1P2m
         10XWUTdrjA+qsTJv0eaBZJEgBWKYJiXWQJ7z6EpI5ib0arNWmbH6mcXHc2P92cQPtS8p
         bzU3gdQnQNZzc/G5sEEsRB8jzkP8dogAS+Q5y3YWWYRVlgw6McBOfx+dgWiziUN4txpD
         GiBiUhK2YKfNXRyQWjo3ZJjR5s6x/l2ddwYbsRxFu05dTuQ9k2JWMA/Vlzv1Tjm86Kr5
         WTmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ILBEi7HhY+66PFbpkznsafcADsz/MB/PBpRDU2DSzE=;
        b=AV0jubqvRreaZKLQJZGU0b3NaIiblDjiAeyo+TdmYCu+48M6OErAGEWA1OmqPPfTVV
         mCS/VTJhGHSQgi8VZX4/g4NjGA+868NjWn60Mf7sZlURvrNqxs0Ae0osn1VhN7WsU3ne
         cVMW5AeHWEX90wZZn0P4dxNWmR/B3KzOFEWW4sbrq+pJPKtlgFkf82i1ZoBZJCCEEdOW
         jXI5yQAUOne8A6miup2cMpFU9Mf3Q4VI42LsAIJclk7pNXOKc+qiOpB5kK07Y2vWOO1J
         UGBxWQFRQEszDVjPA3V7z9araMBJj9v5IN5kUauXLX+JJ9jprEf7mMi7t3SjUA6/JFkt
         4R/A==
X-Gm-Message-State: AOAM5311A0pJSYPGlA5ZSyheXGKfyqVeaJnAp3QIpVOuTnEXpmUDfwsa
        hWuWO41tld/3KlKnRyd8gvqreo5pR3MTtJTIOfoWDw==
X-Google-Smtp-Source: ABdhPJwDDhW2zv9RY7rTyrATYgLaJHzvlGHLA7SRVgS+VsEi6M6/s+yJjd7nf1so00HvHsY0zEr8hQZjTr31Zq7GW2E=
X-Received: by 2002:a2e:9c84:: with SMTP id x4mr5164448lji.326.1603704334301;
 Mon, 26 Oct 2020 02:25:34 -0700 (PDT)
MIME-Version: 1.0
References: <20201026053052.9CB982085B@mail.kernel.org>
In-Reply-To: <20201026053052.9CB982085B@mail.kernel.org>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 26 Oct 2020 10:25:08 +0100
Message-ID: <CAG48ez3gb8E34ePqSmmqhadfLMsLFiNhX=fmCRZKNfSQztXcMQ@mail.gmail.com>
Subject: Re: Patch "mm/mmu_notifier: fix mmget() assert in __mmu_interval_notifier_insert"
 has been added to the 5.8-stable tree
To:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>
Cc:     stable-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 6:30 AM Sasha Levin <sashal@kernel.org> wrote:
>
> This is a note to let you know that I've just added the patch titled
>
>     mm/mmu_notifier: fix mmget() assert in __mmu_interval_notifier_insert
>
> to the 5.8-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>      mm-mmu_notifier-fix-mmget-assert-in-__mmu_interval_n.patch
> and it can be found in the queue-5.8 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

This patch has no reason to go into the stable trees. It just makes an
assertion stricter (mm_users>0 implies mm_count>0). It only has an
effect if your kernel is horrendously broken anyway.

Please take it out of the stable queue.
