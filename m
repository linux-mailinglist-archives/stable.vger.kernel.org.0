Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736F92CF36F
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 18:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbgLDR5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 12:57:34 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34707 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgLDR5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 12:57:33 -0500
Received: by mail-lj1-f194.google.com with SMTP id y16so7592298ljk.1;
        Fri, 04 Dec 2020 09:57:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oWol4W7FSXhfQUV7PWSmD5xZQbxqH4RX2Hg7YLXjWgw=;
        b=BAxI3XB1fX8/rD7OEfhoi/mROaeoOn7mTtWJkBMZKUbqF8a2CBiZj3qkd86fL1Po06
         mJA6v7HJ9lkEuagmh+cSqwet/C2zaqqIBIIrinnPDuVTQrrEMuIy/+4aeZgqpMGlFfpW
         qE3HhLoqCHdcEMSgh8cAaCvRvVRlTW5V3usTaZQH5OIJIEdNecombLvrX/et2Lc49+yi
         Bj6taXw9GPZEaMpODT4O3dmgfWNPCd8Ypj8HorzsvaeZtmUMMqbCZTY/2F7Qyg3nGWVv
         cQP+3OjnA4CTgSS4Xe+LqQ3+wzVT7m0oiG7ZxKwQCVilAtz2YK3Koz2wfB2uVhWbuW8J
         kzlw==
X-Gm-Message-State: AOAM533U/9risQluxaRwHQLzvEbnrbLeL++tHjDYAzVrxdX4Zj+nJJZ3
        RNe2fR6ruy/TktxszdWWS3O00c02C9ZGVg==
X-Google-Smtp-Source: ABdhPJyeCmiSr2amT47BPn8qa+8npwHHSOXkpyAH2eN+1QstEYb00LRH8ToVcYUuvmBJjHmLNSezOw==
X-Received: by 2002:a2e:8811:: with SMTP id x17mr4198852ljh.37.1607104611202;
        Fri, 04 Dec 2020 09:56:51 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id 23sm1885898lft.140.2020.12.04.09.56.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 09:56:51 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id b4so1219303lfo.6;
        Fri, 04 Dec 2020 09:56:51 -0800 (PST)
X-Received: by 2002:a19:4a41:: with SMTP id x62mr4105696lfa.398.1607104610893;
 Fri, 04 Dec 2020 09:56:50 -0800 (PST)
MIME-Version: 1.0
References: <20201130234520.13255-1-dinghua.ma.sz@gmail.com>
 <CA+Jj2f8ADtb8JPPPzafvgVM0jssk8fz_BS-3LDUaYjZHcouTJQ@mail.gmail.com>
 <20201201150036.GH5239@sirena.org.uk> <CA+Jj2f9=oCxdnaHJTtPXwvwokRX9HRMDYUNrbDASmV+FoTefvQ@mail.gmail.com>
 <20201202161042.GI5560@sirena.org.uk> <CAGb2v64md8HdxzRpwCoTVkuiMFj2BWWoEKc0KNuALVUF83XAXw@mail.gmail.com>
 <20201204174020.GB4558@sirena.org.uk>
In-Reply-To: <20201204174020.GB4558@sirena.org.uk>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Sat, 5 Dec 2020 01:56:38 +0800
X-Gmail-Original-Message-ID: <CAGb2v65mRo7sTZZ65P75vs9os198kUh-OyhewdDCkjyUhXuV6Q@mail.gmail.com>
Message-ID: <CAGb2v65mRo7sTZZ65P75vs9os198kUh-OyhewdDCkjyUhXuV6Q@mail.gmail.com>
Subject: Re: [PATCH v2] regulatx DLDO2 voltage control register mask for AXP22x
To:     Mark Brown <broonie@kernel.org>
Cc:     dinghua ma <dinghua.ma.sz@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 5, 2020 at 1:40 AM Mark Brown <broonie@kernel.org> wrote:
>
> On Fri, Dec 04, 2020 at 10:34:21AM +0800, Chen-Yu Tsai wrote:
> > On Thu, Dec 3, 2020 at 12:11 AM Mark Brown <broonie@kernel.org> wrote:
>
> > > No, no sign.  You can check if things are at least hitting the list at:
>
> > >     https://lore.kernel.org/lkml/
>
> > I did receive it though. Would it help if I tried to bounce it to you
> > and the lists?
>
> Possibly?  It depends on what the issue is.

Looks like v3 was already there the first time though:

https://lore.kernel.org/lkml/20201201001000.22302-1-dinghua.ma.sz@gmail.com/

Me bouncing it again had no real effect.


ChenYu
