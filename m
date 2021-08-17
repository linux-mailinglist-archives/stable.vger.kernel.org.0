Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8F03EED86
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 15:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237243AbhHQNey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 09:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbhHQNex (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 09:34:53 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07C8C061764;
        Tue, 17 Aug 2021 06:34:20 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id z5so39501616ybj.2;
        Tue, 17 Aug 2021 06:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BETKMKviZiDMvgtIbHvU34xA814DfYBcLYLezpreZUs=;
        b=pDE48lGfyIr3W0lDNV8OzL6CzHfl268CH0mi9l1JzkmL4Gv1eAkHwZLBFlxPkrmahH
         V2TeptwC1G6qTatG/H1qriYttrNUSpbBCD3ZAw6ydXkKy6gtcgQDb78sfYwQrTo62OgK
         xRIDPhI82KLfNYt4MVx97K0IeVDJSEkPz49FE0frgVXhDudICYhRjm+ayV0FMiowlHlq
         L2Vogn/0A32d7UTxRhh3/LhABZEZGQ4l93Pv3tnhyuRnUqbnIuQssUi254qJF/+Gr1OJ
         JRnLV80ZDN+SwSylfgcqsHgPQDtmJghX9GX8uGdnvNjdWPAhQ38+Kh0TAKbaNg6idysi
         2Khw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BETKMKviZiDMvgtIbHvU34xA814DfYBcLYLezpreZUs=;
        b=ClRK4WytVX3s3UXNPuncB8oDBIQj56AI0xFlrRVS3ZNMqOl5vr5dRUfoNcBjIl5MNq
         EQWwY7JMNtsMsz9pou8bq+gys8+57iLdcga1M1fb/m6iYP7q7DxoPJdkQM2YZcZz4lTp
         DMoB02PFDExAWs26WQubRv2bUKqtOaj2j7eVOXkiIC3H8jh0BA8HK+WRFyr2oiZvGPWp
         oORse3NeAny//kl3YqA8mqNAlkdoz65yT+TjY/tlEiaoMOpQPgSOLhdBjhQ+t4EZN8XN
         OqRARu2+7s8tPdDOVahKBy0+/38h8xeR44Jyrd5/Z16zkUF5VIU3OPzUMnvtuKTsIviX
         B1IA==
X-Gm-Message-State: AOAM533hYpXUxny3Xo4qqFeGcM+NBaep+oOZxeJZqpZZXO0zHVPdDENX
        PKtzxh9R0M5vIfxsDexmDIpx1pc3kSEM4Bwsv/QQx9dhrF7DSQ==
X-Google-Smtp-Source: ABdhPJzil8ThskKau6kBZWU0lc+F5yZnad7GhIzjlHB1Fx85RW5+i7/1AnsiX6ceBlE8uY/iBAt1ZLeF1wdVw/PCjgY=
X-Received: by 2002:a25:aa94:: with SMTP id t20mr4569192ybi.127.1629207259862;
 Tue, 17 Aug 2021 06:34:19 -0700 (PDT)
MIME-Version: 1.0
References: <YRujeISiIjKF5eAi@debian> <YRuxrfYxahPbHmXl@linux-mips.org>
In-Reply-To: <YRuxrfYxahPbHmXl@linux-mips.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 17 Aug 2021 14:33:43 +0100
Message-ID: <CADVatmMZs0GXD8MEEVZGkj9BHtHY+FeWGhE2AuQ9US5E1HeYEQ@mail.gmail.com>
Subject: Re: build failure of mips decstation_r4k_defconfig with binutils-2_37
To:     Ralf Baechle <ralf@linux-mips.org>
Cc:     "Maciej W. Rozycki" <macro@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>,
        linux-mips <linux-mips@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ralf,

On Tue, Aug 17, 2021 at 1:55 PM Ralf Baechle <ralf@linux-mips.org> wrote:
>
> On Tue, Aug 17, 2021 at 12:54:32PM +0100, Sudip Mukherjee wrote:
>
> > While I was testing v5.4.142-rc2 I noticed mips build of
> > decstation_r4k_defconfig fails with binutils-2_37. The error is:
> >
> > arch/mips/dec/prom/locore.S: Assembler messages:
> > arch/mips/dec/prom/locore.S:29: Error: opcode not supported on this
> > processor: r4600 (mips3) `rfe'
> >
> > I have also reported this at https://sourceware.org/bugzilla/show_bug.cgi?id=28241
>
> It would appear gas got more anal about ISA checking for the RFE instructions
> which did only exist in MIPS I and II; MIPS III and later use ERET for
> returning from an exception.
>
> The older gas I've got installed here happily accepts RFE in MIPS III/R4000
> mode:
>

<snip>

>
> It's easy to find arguments for why this gas change is the right thing to
> do - and not the right thing to do.
>
> It should be fixable by simply putting gas into mips1 mode.  Can you test
> below patch?

Tested on top of v5.4.142-rc2 and it builds again. Thanks for the
quick reply and the patch.


-- 
Regards
Sudip
