Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 277741520F5
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 20:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgBDTYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 14:24:38 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43875 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbgBDTYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 14:24:38 -0500
Received: by mail-pg1-f194.google.com with SMTP id u131so10137357pgc.10;
        Tue, 04 Feb 2020 11:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a5Iw4+7GJ6slzzgm0iCqz2HJ63btbwexeYhU6/Y4dIs=;
        b=ni7Aww9WoUSs0GKXVt/SoJpWmFbM6lLHH7xWWJFszpNJ36iL47jCP2G4/ebJdwec5w
         Mgl3NWNH3cF+WPgRAcEGgLjtlDF+4quyk3LbK7QdJsZLJAZk7yt3fJVFV6IcUQrYBwM4
         CrEEVIG0iMRUs+8mSAg9p0DhDq01pGqppy6edxKNEuqkQ6XdeKBuRBJNK7bU6JNGopIM
         VUideZrJ23HI4cy9ZWH4jwjHiDGvH2tNleIKPeD1IHuhbY2DbS+nSnXn7UHGietDXl6K
         mCLBDbKGCG+I3UbrCkg7wiDPIRt37uk9H2F4ITdKMs7bho3uOO50Ly9dRo/hr3Q/obrb
         WsCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=a5Iw4+7GJ6slzzgm0iCqz2HJ63btbwexeYhU6/Y4dIs=;
        b=d/VbbW2Wsp+cb7awkKvd98CQE+xasCYcbHF4aPY5l6w+eGqETa56VSDKt4wx9Pc4h8
         Pfohm/4GtyYU03KaEeZ7DBMkkjZZfHCs9Zm2StmBMIFBLPrIwzeXvi4KYVzPgdo/jTP6
         ARy5P8RSMAA3a+1k9oM9b//lc6cVZbOd4PXy5KehLAx7AwNrhhig/e/ku0AH58FiyQBU
         qzT7oYDtG/kzd6NADUw6Q38v/afbMtGMVtKdB3XNwzma/x+GK91fZ02FXUkGUoiGpv/5
         CQB6VxInWvwg1+YZwadEL5EjMtcUKUwp3oPUV9EONg23tZlnqWmYKo/2cCdwXt3A4yqW
         Y9AA==
X-Gm-Message-State: APjAAAWKl1qVnOJipY+J7sQNgdm7/gjnlODMWVFctqEGwiEOC7v870TB
        ojjDGER6R4menbquNJUMbtE=
X-Google-Smtp-Source: APXvYqwcjcyt+DmTT67Ups20XbX66rYF8BCFLWq3BFTc7Exiz2ocFGi39oCvSmvE1Cbp4XuO83wbhg==
X-Received: by 2002:a62:1b07:: with SMTP id b7mr32923122pfb.186.1580844277137;
        Tue, 04 Feb 2020 11:24:37 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id fh24sm4333677pjb.24.2020.02.04.11.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 11:24:36 -0800 (PST)
Date:   Tue, 4 Feb 2020 11:24:34 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: Re: [PATCH 1/7] Input: pegasus_notetaker: fix endpoint sanity check
Message-ID: <20200204192434.GH184237@dtor-ws>
References: <20191210113737.4016-1-johan@kernel.org>
 <20191210113737.4016-2-johan@kernel.org>
 <20200204082441.GD26725@localhost>
 <20200204100232.GB1088789@kroah.com>
 <20200204101435.GH26725@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204101435.GH26725@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 04, 2020 at 11:14:35AM +0100, Johan Hovold wrote:
> On Tue, Feb 04, 2020 at 10:02:32AM +0000, Greg Kroah-Hartman wrote:
> > On Tue, Feb 04, 2020 at 09:24:41AM +0100, Johan Hovold wrote:
> > > On Tue, Dec 10, 2019 at 12:37:31PM +0100, Johan Hovold wrote:
> > > > The driver was checking the number of endpoints of the first alternate
> > > > setting instead of the current one, something which could be used by a
> > > > malicious device (or USB descriptor fuzzer) to trigger a NULL-pointer
> > > > dereference.
> > > > 
> > > > Fixes: 1afca2b66aac ("Input: add Pegasus Notetaker tablet driver")
> > > > Cc: stable <stable@vger.kernel.org>     # 4.8
> > > > Cc: Martin Kepplinger <martink@posteo.de>
> > > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > 
> > > Looks like the stable tag was removed when this one was applied, and
> > > similar for patches 2, 4 and 7 of this series (commits 3111491fca4f,
> > > a8eeb74df5a6, 6b32391ed675 upstream).
> > > 
> > > While the last three are mostly an issue for the syzbot fuzzer, we have
> > > started backporting those as well.
> > > 
> > > This one (bcfcb7f9b480) is more clear cut as it can be used to trigger a
> > > NULL-deref.
> > > 
> > > I only noticed because Sasha picked up one of the other patches in the
> > > series which was never intended for stable.
> > 
> > Did I end up catching all of these properly?  I've had to expand my
> > search for some patches like this that do not explicitly have the cc:
> > stable mark on them as not all subsystems do this well (if at all.)
> 
> No, sorry, should have been more clear on that point; these four were
> never picked up for stable it seems.
> 
> I was a bit surprised to see the stable-tags be removed from the
> original submissions here, even if I know the net-maintainers do this
> routinely, and any maintainer can of course override a submitters
> judgement.

Sorry, dropping stable tags was not intentional. I was trying to improve
my tooling and drop the CC noise from the changelogs, but my script got
too eager and removed "Cc: stable" as well. I believe my tool should be
fixed now and it should not happen again.

Thanks.

-- 
Dmitry
