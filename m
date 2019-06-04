Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D77BB34DD1
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 18:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfFDQid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 12:38:33 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44091 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbfFDQic (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 12:38:32 -0400
Received: by mail-pf1-f195.google.com with SMTP id t16so4194967pfe.11
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 09:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fRewquvY8ZwDjq8jTQRXdfIeZ2OMugxwKzgTtmSuTds=;
        b=UpqIWo9T+DQkUI3bhyIj5DJulSKIaQT5ay1o1v1xUQ6q3lBOiTDUIh8ViHWsccJgLU
         1xPFmLkaZomf6NXxh9SRrdCwG3VWpYUu0yzahpLjHvtvAxQOe8+SLn8i7E9AhksXmzyD
         sxFI8jOrMmmr2xd4iPDIyD+IQ4m4b+/m+ckwY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fRewquvY8ZwDjq8jTQRXdfIeZ2OMugxwKzgTtmSuTds=;
        b=g5Z6B8Dp9kF1ArTXhdzFKcupCNBrn5GwtTGRyjWCSsOIH4agKuRGV/we2FnlJjLHJW
         BBplooFAni+uNZH7i+5LSj0tqxSeK6WUF5tBvVpjEOkBPs2exUpUd1F8zIvm7X9u26Lg
         QirmVmsunGcn1O8vYadDSjI72kb1qdPtt+/AC4NFzPwCl/f6G4GPeXKbiHU9E2yMn2g9
         O6269CtP24H9IvdniJqrpdVDn3riJxvYwdLFoJt0n9efY1Mrr5332hyfTqfUTB0PUDF/
         0vEE81enC4Q2sJ93H29ckbUCTwtdgbw9jAlTccB7qOK0x682OUdkSncRSSyIrN34l7UW
         +IiQ==
X-Gm-Message-State: APjAAAV4QXFrkl0C/4AJCpyGKorJCIaGHrLp2P/4+h9qh2BBjDD2iNvg
        qd4iogAN5HOx8clSTvKMY8H2Dg==
X-Google-Smtp-Source: APXvYqyZ/dxuNb05lveC1LCusBWC241ktkl1vFV71Puovwx6TjRDI7AEs6gzv2vbzu43zvhgEPlgeg==
X-Received: by 2002:aa7:8a11:: with SMTP id m17mr40137170pfa.122.1559666312123;
        Tue, 04 Jun 2019 09:38:32 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id o15sm24038156pfh.53.2019.06.04.09.38.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 09:38:31 -0700 (PDT)
Date:   Tue, 4 Jun 2019 09:38:28 -0700
From:   Zubin Mithra <zsm@chromium.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        groeck@chromium.org, blackgod016574@gmail.com,
        dvhart@infradead.org, andy@infradead.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de
Subject: Re: 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap
 1:1 mapping code")
Message-ID: <20190604163826.GA172115@google.com>
References: <20190603223851.GA162395@google.com>
 <20190604123432.GA19996@kroah.com>
 <CAKv+Gu8a77xObE8UPhDZeqzXdm48vxHOqC4resfvRJLFPavgLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8a77xObE8UPhDZeqzXdm48vxHOqC4resfvRJLFPavgLQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 03:39:15PM +0200, Ard Biesheuvel wrote:
> On Tue, 4 Jun 2019 at 14:34, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Jun 03, 2019 at 03:38:52PM -0700, Zubin Mithra wrote:
> > > Hello,
> > >
> > > CVE-2019-12380 was fixed in the upstream linux kernel with the commit :-
> > > * 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap 1:1 mapping code")
> > >
> > > Could the patch be applied in order to v4.19.y?
> >
> > Now queued up, thanks.
> >
> 
> Given the discussion leading up to this, I'm slightly surprised.
> 
> As I alluded to in my questions to Zubin, I am concerned that the
> testing carried out on this patch has too little coverage, given that
> a) Chrome OS apparently does not boot in EFI mode
> b) therefore, Chrome OS there does not use efi=old_map
> c) Chrome OS hardware does not implement 5 level paging

I see, yes, I have not done appropriate testing on this patch. Sorry
about the mistake and the confusion! I'll keep in mind to do more appropriate
testing from the next patch onwards.

Thanks,
- Zubin


> 
> I have done all the testing I could before merging the patch, but I
> would prefer to defer from backporting it until it hits a release. I
> know some people argue that this still does not provide sufficient
> coverage, but those are usually not the same people getting emails
> when their EFI systems no longer boot without any output whatsoever
> after upgrading from one stable kernel version to the next.
