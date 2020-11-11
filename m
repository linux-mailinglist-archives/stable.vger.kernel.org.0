Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787672AFCE2
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 02:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgKLBdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 20:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbgKKXMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 18:12:13 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BDFC0613D1
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 15:12:13 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id y17so3555608ilg.4
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 15:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZxvxgaqpV+01SBn5+Xh2aD0JmbBQFGOqf/DCNbPRSaI=;
        b=Yvq6+ofd9rTOtO5H6XFAQUxKv6xuQcaTlrfDLMdUHTxfaI8GKuZn5aAnnQ/kwl4kWC
         RUFIYNmF6jytDzXn4yG+GTdgjvzbGtMmrYouNqBvrYg9XtUM1TVdKJC0oyu2OP2vx3sM
         3QV+72x4uDkLr5F/L+JKHAsfK0y0H7Be9cykdGp9ASneSie5WIOAKCoPsn4wkA3N8C3S
         sj/EDRCWKx3SbU/K8Vvel+fE4x6Edns4zMC6JqZZgnG5MY8YBR1kooI1enw1h6B3V3Ii
         injZ0tGnLw/J0dmFee2kLqdak/WFrJ3/kqarjWezLYnXUI4UCGFZ32ySwtHjr20zKyZB
         RP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZxvxgaqpV+01SBn5+Xh2aD0JmbBQFGOqf/DCNbPRSaI=;
        b=T1kAuZl+ZfAvISveUtVM9cD1UnSNh0prHUjJ+4sYFq4oD99RSuWwDV4o13UlisayPJ
         6QGBOoc11IGfVFDeHdoOSrq5EoTbMyplreNWQ29mAGUkdzZONOfgU1zN0rcdQIFSAKnT
         oZWFAdYPGFluOABkdzb4RH0GfoK5SSRQW8vl1OhVFweiGpCv3FGswo5DZGDS/d1mgEvT
         MW/dQrA1wf1GuC8ta/gAeWzbS8NU+Yv3XawGD6C+Kdd+aoRPEBZkNz+1qql90zSPA2Kc
         EBJeAquYQo8pUz7CTQHsNdtTmAM+eu58t3AfLdqRset9dqUdSxhaIupKXssopsd2W35H
         HTFQ==
X-Gm-Message-State: AOAM531rKH8Fca/x/kL1ph6I2nyju11GYxNdydTrdxZ8yHt3AftMRSd9
        9374ZEMuLobZnQ0K/u/BipNkc/EbDlIEP22D79Ponw==
X-Google-Smtp-Source: ABdhPJyMNdvhtPkh5uXML7VQUAfOM+TFjwDVjrcPxpl/VrUoI5UBlL4qQbU8FwaMpIIaGqAMUtsI/SYy3Hfx0i9CeVI=
X-Received: by 2002:a05:6e02:c:: with SMTP id h12mr21711605ilr.177.1605136332544;
 Wed, 11 Nov 2020 15:12:12 -0800 (PST)
MIME-Version: 1.0
References: <CAATStaPeE+SEXGNU0kcrsNgqRZgg6+9j1fw5KqLPUoCGjUP=qQ@mail.gmail.com>
 <X6vX7rJmlgjQqvlA@kroah.com>
In-Reply-To: <X6vX7rJmlgjQqvlA@kroah.com>
From:   "Anand K. Mistry" <amistry@google.com>
Date:   Thu, 12 Nov 2020 10:12:01 +1100
Message-ID: <CAATStaMd772bg8vBBNhb-zTyx-OmvPuNoVfDLtqj6QGcL_RfxA@mail.gmail.com>
Subject: Re: Requesting stable merge for commit 1978b3a53a74e3230cd46932b149c6e62e832e9a
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 11 Nov 2020 at 23:23, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Nov 11, 2020 at 11:09:13PM +1100, Anand K. Mistry wrote:
> > Hi,
> >
> > I'm requesting a stable merge for commit
> > 1978b3a53a74e3230cd46932b149c6e62e832e9a
> > ("x86/speculation: Allow IBPB to be conditionally enabled on CPUs with
> > always-on STIBP")
> > into the stable branch for 5.4. Note, the commit is already queued for
> > inclusion into the next 5.9 stable release
> > (https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.9/x86-speculation-allow-ibpb-to-be-conditionally-enabl.patch).
> >
> > The patch fixes an issue where a Spectre-v2-user mitigation could not
> > be enabled via prctl() on certain AMD CPUs. The issue was introduced
> > in commit 21998a351512eba4ed5969006f0c55882d995ada
> > ("x86/speculation: Avoid force-disabling IBPB based on STIBP and
> > enhanced IBRS.")
> > which was merged into the 5.4 stable branch as commit
> > 6d60d5462a91eb46fb88b016508edfa8ee0bc7c8. This commit also exists in
> > 4.19, 4.14, 4.9, and 4.4, so those kernels are also likely affected by
> > this bug.
>
> As I asked when I sent out a "FAILED:" message for this patch, if
> someone wants it backported to older kernels, they will need to provide
> the backported versions of it, as the patch does not apply cleanly
> as-is.
>
> Can you please do that?

Oh, I didn't get that message. I'll prepare a backport.

>
> thanks,
>
> greg k-h



-- 
Anand K. Mistry
Software Engineer
Google Australia
