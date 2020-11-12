Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9522AFF9F
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 07:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgKLG0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 01:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgKLG0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 01:26:30 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B48C0613D1
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 22:26:30 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id y17so4268800ilg.4
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 22:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pRY9F5vEmgqsG/ZUuRVxpXlRdo2gLYCpYhWbBWkHGKA=;
        b=MgEF7dtWhIcFevgovQJqiuD67iwloFemy56RA9XlzZYa12qwbiJfS3BPbkfkA+CKa7
         oKJsnb4bH9FdvZ+3eoDrBy93lu8Vq9ToDle/UzG58GlNx7Vy2hMLj0kIKFc1FzMwpath
         9JW2H/XNCl43+qrXxSmBBhD9ehE3YKC2zfC56zQXS2rzBZ87SmIiufR5hWMjTBZjo+Ef
         vTovVBLxWGig52BRr6TYz8icqEj0NEw1rCUKpsoJG9XbZVWIGPt3hf4qAxfS8ezypgaM
         bFP9kFIXrxwxEdANGDSDCEk9wU0JbGmABRPHb0eSR4v9XlpTaSbcTu4+9rcMy7R7Fn/h
         jyqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pRY9F5vEmgqsG/ZUuRVxpXlRdo2gLYCpYhWbBWkHGKA=;
        b=J7OArDiLkKctew9HCL/fPTF35H2DYhxGhZnXiR9PBWh2QdAme232yd9iMGzTEgf6YQ
         kaxL2l5aTUHzGI2m+lX80gFb4JZ//iWSOnNUHxjoKip5jvSZYOhMXjMUigiQ5FY2DTPJ
         cvHS0Yvck86LjivIF+dPDIvuhvC+8e7NUS3RJpwf4hukXRARLsU34aQ4ANIzUt3QNcLO
         M2DYkTrBu3ENxlTKn+2Rb1W0sjCDndnKqNfg/ny92x8hMfV1KeVmqDPwiRAZ+jpS+PlU
         tArxZXlY86X3wMyQ7/xiIXVIWfmbwT02Hi6llBdNAYaVRLcB9qSwLoEwQNhTPPzCOBJa
         qTQQ==
X-Gm-Message-State: AOAM5308tcKuSNJ3+A00xxA1jB6cUy8KaBX3ao9K4zRa4kmblfjq/q7a
        P+knxNQ0resBNC/9kwDT5jiedBA75HHgLEtEKz1vMw==
X-Google-Smtp-Source: ABdhPJxOOzi2/J0zYAnrIRfGEnAuRMSqjcq//8DoIIQGnBJW9edIxcpE6lL+BTKztz8P0tC25wtW6Ull4vksQEZWai4=
X-Received: by 2002:a92:940c:: with SMTP id c12mr19513638ili.167.1605162389851;
 Wed, 11 Nov 2020 22:26:29 -0800 (PST)
MIME-Version: 1.0
References: <CAATStaPeE+SEXGNU0kcrsNgqRZgg6+9j1fw5KqLPUoCGjUP=qQ@mail.gmail.com>
 <X6vX7rJmlgjQqvlA@kroah.com> <CAATStaMd772bg8vBBNhb-zTyx-OmvPuNoVfDLtqj6QGcL_RfxA@mail.gmail.com>
 <X6zTDralvod85Z9t@kroah.com>
In-Reply-To: <X6zTDralvod85Z9t@kroah.com>
From:   "Anand K. Mistry" <amistry@google.com>
Date:   Thu, 12 Nov 2020 17:26:18 +1100
Message-ID: <CAATStaPT8wnQXZ2zJdr=z-_2SDD+EU0wM0yVmk0cFjsZr8zrvQ@mail.gmail.com>
Subject: Re: Requesting stable merge for commit 1978b3a53a74e3230cd46932b149c6e62e832e9a
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 12 Nov 2020 at 17:15, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Nov 12, 2020 at 10:12:01AM +1100, Anand K. Mistry wrote:
> > On Wed, 11 Nov 2020 at 23:23, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Wed, Nov 11, 2020 at 11:09:13PM +1100, Anand K. Mistry wrote:
> > > > Hi,
> > > >
> > > > I'm requesting a stable merge for commit
> > > > 1978b3a53a74e3230cd46932b149c6e62e832e9a
> > > > ("x86/speculation: Allow IBPB to be conditionally enabled on CPUs with
> > > > always-on STIBP")
> > > > into the stable branch for 5.4. Note, the commit is already queued for
> > > > inclusion into the next 5.9 stable release
> > > > (https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.9/x86-speculation-allow-ibpb-to-be-conditionally-enabl.patch).
> > > >
> > > > The patch fixes an issue where a Spectre-v2-user mitigation could not
> > > > be enabled via prctl() on certain AMD CPUs. The issue was introduced
> > > > in commit 21998a351512eba4ed5969006f0c55882d995ada
> > > > ("x86/speculation: Avoid force-disabling IBPB based on STIBP and
> > > > enhanced IBRS.")
> > > > which was merged into the 5.4 stable branch as commit
> > > > 6d60d5462a91eb46fb88b016508edfa8ee0bc7c8. This commit also exists in
> > > > 4.19, 4.14, 4.9, and 4.4, so those kernels are also likely affected by
> > > > this bug.
> > >
> > > As I asked when I sent out a "FAILED:" message for this patch, if
> > > someone wants it backported to older kernels, they will need to provide
> > > the backported versions of it, as the patch does not apply cleanly
> > > as-is.
> > >
> > > Can you please do that?
> >
> > Oh, I didn't get that message. I'll prepare a backport.
>
> You didn't have to get the email, but I would assume that you at least
> tested the backport if you asked for it to happen, right?  :)

The conflict was so trivial (a single newline in a comment) I didn't
really think about it. And yes, the patch is well tested against 5.4
(which is my target kernel), and 4.14.
