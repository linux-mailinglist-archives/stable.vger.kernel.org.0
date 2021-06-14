Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDAF3A6DE9
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 20:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbhFNSFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 14:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbhFNSFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 14:05:08 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0F1C061574
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 11:03:05 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id j2so22377302lfg.9
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 11:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hth5OJx5DLnrqVkGsO9sFZaOxm24SUjgcf7q16vYO9k=;
        b=SYh2bWEUABHXqRB6ouYLMnFXIxkuBj3g9OGoJcjymr/uDkZ0b2ocpQIxY7OD3aoqry
         y/WDysWKakiopu5mag8D+4V2VdjD01blp+N5edF/BQ0EXgzT8QLbBsWXILbf7+h84XUb
         ftZIOw1NIhwgxMzRUzmXKeXGQC6u8yO//bp98=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hth5OJx5DLnrqVkGsO9sFZaOxm24SUjgcf7q16vYO9k=;
        b=BUqF80kmA4jALA8PlTVSDxZfugC88WqZu8kdipKmH9j5mweoN7zCfT33y0zzVKNtCc
         tg9t6V7yY5aVOsIbu879Mj5jZXwvUI95AJzT88Pzd2sI3B/e4Kn5/wFkz3+xRj6PACv3
         ZKYHZt0QxvBgcrSArTiW8tGGEpaFI1E6knEeNBLnnOMbc1UNPOe5LDprK3fmm7nzxABR
         pB1Yb81c0p0SIx/o3hj9yK1k4/Fw3doPAbPKRRkzdY3z2PVs3kzO0fIo5F+OSdo2aeeo
         X++8OK8HJppNNbrfBXvpV54rCosedrXmjAhXc8PwjQ+FjYZ3I/XKx+aKuj07WkN9Z4Zi
         J9lg==
X-Gm-Message-State: AOAM53102vQC88GuqUkoybcG82cta6rFRT5mNuUomknbfMuI4n2pgypb
        VVNwmNvZUoUjm3CI6d2uujdjg4rTfCemxEmRyvs=
X-Google-Smtp-Source: ABdhPJzQyNws2e5kGo/3/6Z0z78DvukvUvbsgQsnwegwVOVEkozJ6ZRYOXyq4tmDJfW+CdqNXUzQew==
X-Received: by 2002:ac2:5612:: with SMTP id v18mr13278436lfd.385.1623693783354;
        Mon, 14 Jun 2021 11:03:03 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id d2sm1542770lfv.294.2021.06.14.11.03.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 11:03:02 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id x24so16901835lfr.10
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 11:03:02 -0700 (PDT)
X-Received: by 2002:a05:6512:3f82:: with SMTP id x2mr12358175lfa.421.1623693782157;
 Mon, 14 Jun 2021 11:03:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210608171221.276899-1-keescook@chromium.org>
 <20210614100234.12077-1-youling257@gmail.com> <202106140826.7912F27CD@keescook>
 <202106140941.7CE5AE64@keescook>
In-Reply-To: <202106140941.7CE5AE64@keescook>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 14 Jun 2021 11:02:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=whLBq63v_h71YuBM2aNjCSBprkBEO3fevbWnkp8TDeh5g@mail.gmail.com>
Message-ID: <CAHk-=whLBq63v_h71YuBM2aNjCSBprkBEO3fevbWnkp8TDeh5g@mail.gmail.com>
Subject: Re: [PATCH] proc: Track /proc/$pid/attr/ opener mm_struct
To:     Kees Cook <keescook@chromium.org>
Cc:     youling257 <youling257@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 9:45 AM Kees Cook <keescook@chromium.org> wrote:
>
>         /* A task may only write when it was the opener. */
> -       if (file->private_data != current->mm)
> +       if (!file->private_data || file->private_data != current->mm)

I don't think this is necessary.

If file->private_data is NULL, then the old test for private_data !=
current->mm will still work just fine.

Because if you can fool kernel threads to do the write for you, you
have bigger security issues than that test.

               Linus
