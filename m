Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E80D52F6
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 23:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbfJLVys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Oct 2019 17:54:48 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39525 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfJLVyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Oct 2019 17:54:47 -0400
Received: by mail-lj1-f196.google.com with SMTP id y3so13068689ljj.6
        for <stable@vger.kernel.org>; Sat, 12 Oct 2019 14:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rDB8l9J6Biz2wG4THVAds8NGgCuohOX5ac1dNgK0OxI=;
        b=KUDzzr50TDNQAq5jOaGfTQPxnfDoEhZz/0HwUfK8x/gj5RGHMHgik4T1UE+gZcwoLA
         xT9AlbmymTxbwB6hIrMgHwgqx1RgpKqQLxfNqqku5/JLFLLtR7HcYVfy3ofVc0qOlYXp
         U3Nqywzx4SM0H1xTBXd9IByzRn2M8GwdYf5Yk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rDB8l9J6Biz2wG4THVAds8NGgCuohOX5ac1dNgK0OxI=;
        b=HB4tYgG0L0oxjrQ0eLy1J1rHC1ulUVUkMUANXnqehctXF4299COAIiDtfQi2dLPRCo
         gNqc+3FN2mq7ky74nro8tFS+N2OvQWIGJNLN7AM4AtdTU/qmme57kzsQSIapV20w4mVk
         ShDpzu+ardyyy2KQI6O7PeGh7RHLnCFnh00Gbs0kUdPwvd5UOLAo7XwQ18fCz/6Pjjs0
         f93FS2tz4E+o3P0I3F7CxO2rDuzp7F/6wA+R7Fkj3ETIdoDG64l3oGDkNinpYE4XziiF
         OdJ+8FwniwvZHAfxICZVmq/IEOmZ1ASLTY4YDeCDeDme0uubgygtyTIR7H4qXW+DmqHV
         AtpA==
X-Gm-Message-State: APjAAAWbEHC/djMRjsaC7sCnzAAHPQR3gau2C2+CW8WUkXyGlY9IVY01
        rQmEUGZ6btQqxQfiGJBbbDRqBQpG3rY=
X-Google-Smtp-Source: APXvYqx3BbpEYkyLC7vk2kiNapv6JY5m6VDt1RhuzlMxcE6UNYfUz06zFCbbrefU/pwBqKqdO1YNVw==
X-Received: by 2002:a2e:85c1:: with SMTP id h1mr13315053ljj.169.1570917285356;
        Sat, 12 Oct 2019 14:54:45 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id 77sm2999165ljf.85.2019.10.12.14.54.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Oct 2019 14:54:43 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id t8so9295339lfc.13
        for <stable@vger.kernel.org>; Sat, 12 Oct 2019 14:54:43 -0700 (PDT)
X-Received: by 2002:a19:6f0e:: with SMTP id k14mr12632033lfc.79.1570917282692;
 Sat, 12 Oct 2019 14:54:42 -0700 (PDT)
MIME-Version: 1.0
References: <157086827811218@kroah.com>
In-Reply-To: <157086827811218@kroah.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 12 Oct 2019 14:54:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiE8oFcPHCMM11j0svKQWwM8nuhnQ9R1OdLbfum5ALvOg@mail.gmail.com>
Message-ID: <CAHk-=wiE8oFcPHCMM11j0svKQWwM8nuhnQ9R1OdLbfum5ALvOg@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] writeback: fix use-after-free in
 finish_writeback_work()" failed to apply to 5.3-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 12, 2019 at 1:18 AM <gregkh@linuxfoundation.org> wrote:
>
> The patch below does not apply to the 5.3-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Hmm. It looks to me like 5.3 doesn't have the use-after-free problem,
and that it was introduced by 5b9cce4c7eb0696558 ("writeback:
Generalize and expose wb_completion")

So I think the "Fixes" tag is right, and the "Cc: stable" is wrong.

            Linus
