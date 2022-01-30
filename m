Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6BE4A350D
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 09:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242378AbiA3IHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 03:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238784AbiA3IHp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 03:07:45 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40201C061714;
        Sun, 30 Jan 2022 00:07:45 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id u15so19383380wrt.3;
        Sun, 30 Jan 2022 00:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xWLXnegr6qNbt4MHDjyTJqZDV0X5yrkaKELa5TFQ/S8=;
        b=JB58ifro8/DGyF80lrbVTuv7Y6pS8yUyIWxx997a6P6YBs62LG6+BptHfS5mg0l5K6
         lB8X3usilq1yuW9Np94UOjb+HDFQFMgGpgi4ItKNyzkzBKYfO258Xze0kfbKcyGGM1Vf
         mu00o7XD+zWK62diBSzohPu2fFExQGan1usf7iNk1VPr09iqCdybKOwDH+nloKm8enX5
         rfDs7+2CVWziWQMLk/541jgCCkiUknPQBJ41ce+gwG3a+RDzKf1tMRyX88hyfIDp2h0Q
         +e9RqyAH2rU1C5z3lvYMSfgRzsVJfNq94dHYbonMCsdrMsEgn3/5EfEQIwM1mP8VHN2s
         1iXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xWLXnegr6qNbt4MHDjyTJqZDV0X5yrkaKELa5TFQ/S8=;
        b=LufBMrXDQo6V7dZccfCfQyKQJop310pSqPcrGF/jv9FwtnMaCG83yGOE1LbZBhK5S3
         HOwTSp1YwJxveOMk8rkJMWwjn8OUFgLiqRYZNK4J29h7zWIzNdTRIQBvyln4qZgUZ9Mn
         yL0/s7Xlxb2X98IZwG+t9aw5UZrtnldCUB7GJ1YTwGZ9vvkW9GyxY2FKc0YhFs19CAvR
         Ztv1HS9D4Ds3pXK4/CC8CJjBMS3f4Xi0mmPBaGvWuKoqtnnUGPrr0raP17BjAs1KXn16
         qeWhfuLfbYriWxP2GXeurHxI49zse7gphpvXadStYGQVTvMM7eRchE6B3+PJclN+XH2b
         SKmQ==
X-Gm-Message-State: AOAM531KPxZcxK3dGXZOrTuU8hQH7Z1/CyQE1xEvXqt8RxYeUhBNxy2q
        kMhng3/ehApgSloAUf/fIjGFv4uFk32YIm5uvuDxiSZa/6A=
X-Google-Smtp-Source: ABdhPJyT/L19+SeWYIdoW01PcDx2TDReWbLH0WJhUU6ZnT/IxK/MP1vq6D0L77jgtY8yT4L4stlUAoR1ismnyRB0seM=
X-Received: by 2002:a5d:4e81:: with SMTP id e1mr13024621wru.513.1643530063688;
 Sun, 30 Jan 2022 00:07:43 -0800 (PST)
MIME-Version: 1.0
References: <CAMP44s2vAmfHU+h5bSp5FJvks7T+b_tpdU1U4pBvK9jFF6C=eQ@mail.gmail.com>
 <YfY+C9hiX2V7LnT6@kroah.com>
In-Reply-To: <YfY+C9hiX2V7LnT6@kroah.com>
From:   Felipe Contreras <felipe.contreras@gmail.com>
Date:   Sun, 30 Jan 2022 02:07:32 -0600
Message-ID: <CAMP44s0b93nO9uVYB3_p_c=cq8BR3WCtnQA=7jJxyAxYC6rxNQ@mail.gmail.com>
Subject: Re: Regression in 5.16.3 with mt7921e
To:     Greg KH <greg@kroah.com>
Cc:     Linux stable <stable@vger.kernel.org>,
        Linux wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 30, 2022 at 1:28 AM Greg KH <greg@kroah.com> wrote:
>
> On Sat, Jan 29, 2022 at 01:05:50PM -0600, Felipe Contreras wrote:
> > Hello,
> >
> > I've always had trouble with this driver in my Asus Zephyrus laptop,
> > but I was able to use it eventually, that's until 5.16.3 landed.
> >
> > This version completely broke it. I'm unable to bring the interface
> > up, no matter what I try.
> >
> > Before, sometimes I was able to make the chip work by suspending the
> > laptop, but in 5.16.3 the machine doesn't wake up (which is probably
> > another issue).
> >
> > Reverting back to 5.16.2 makes it work.
> >
> > Let me know if you need more information, or if you would like me to
> > bisect the issue.
>
> Using 'git bisect' would be best, so we know what commit exactly causes
> the problems.

I know, but it has been a while since I've created a decent config
file to build a kernel.

Either way, I pushed forward and the commit is a38b94c43943.

Upstream commit 547224024579 introduced a regression that was fixed by
the next commit 680a2ead741a, but the second commit was never merged
to stable.

I've sent the second commit to fix the regression.

-- 
Felipe Contreras
