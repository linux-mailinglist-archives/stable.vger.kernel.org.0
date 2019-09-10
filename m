Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A386AEFC1
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 18:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436785AbfIJQk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 12:40:57 -0400
Received: from mail.skyhub.de ([5.9.137.197]:50220 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729580AbfIJQk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 12:40:57 -0400
Received: from zn.tnic (p200300EC2F0ABE00F527A81DC3416441.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:be00:f527:a81d:c341:6441])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1A6891EC0A91;
        Tue, 10 Sep 2019 18:40:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1568133656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=XtHKBvvT6hRDvVQrlI/kCAwmX4eSzoQdN87+l4zR9TA=;
        b=WblFv4yQtTjDzBQUuW+wU5Tfm7msSatpYprxSfEBMe8cL+IYilTHDGd4VwIsGXUoTFnAHl
        evKBQhw14L6MTWSYRt6givb39YdZptEJNFcoFmORgRT+5vUgnjwO6xWmAZywu9Kk4uAANz
        aWdSfim6rEHetCZOWghaBKh5d4UOnp8=
Date:   Tue, 10 Sep 2019 18:40:51 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Mike Travis <mike.travis@hpe.com>
Cc:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 0/8] x86/platform/UV: Update UV Hubless System Support
Message-ID: <20190910164050.GH23931@zn.tnic>
References: <20190905130252.590161292@stormcage.eag.rdlabs.hpecorp.net>
 <CANiq72nTKbNEKezoy_CqdFRuQ0SD2OsORV8u=i_1g=2atkCRiA@mail.gmail.com>
 <797654d8-562a-6492-79e1-65a292157d04@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <797654d8-562a-6492-79e1-65a292157d04@hpe.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 10, 2019 at 08:34:44AM -0700, Mike Travis wrote:
> Hi,  I'm not conscientiously adding any attachments.  I think what is
> happening is some email readers mistake the '---' to signify an attachment
> follows.  I see the "staple" symbol on some indicating an attachment, but
> not usually all of the email I send.  Thanks, Mike

Btw, is there anyway to fix your mail setup and not flood with your
patchset?

I have received your V2 patchset 5(!) times yesterday and today. All
separate submissions!

;-(

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
