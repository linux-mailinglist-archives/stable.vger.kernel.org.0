Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29AA179C1
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 14:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfEHMvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 08:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbfEHMvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 08:51:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D675720644;
        Wed,  8 May 2019 12:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557319876;
        bh=WFgd7FOMXRMBabJAYM7lx2Yy3vvxcjaRtwoc4EcrLeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FGyGJeWAOfSo+dp1zbIkhSj9++qRrl1+poO7MXog6uDMNiWG7kES6uBgUy2u6s9kK
         9OOacN8dQyLfQWDdydBH8ahumLfbzP4V9rbB4QyVT4vnOAulT4z9ohZjdKmfNIGt4Z
         wqeipADOVjLhaF0CBse92uqjpWLUvToiskXVYs40=
Date:   Wed, 8 May 2019 14:51:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sebastian Gottschall <s.gottschall@newmedia-net.de>
Cc:     David Laight <David.Laight@aculab.com>,
        'Jiri Kosina' <jikos@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@surriel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Nicolai Stange <nstange@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/fpu: Remove the _GPL from the kernel_fpu_begin/end()
 export
Message-ID: <20190508125114.GG8646@kroah.com>
References: <761345df6285930339aced868ebf8ec459091383.1556807897.git.luto@kernel.org>
 <20190502154043.gfv4iplcvzjz3mc6@linutronix.de>
 <nycvar.YFH.7.76.1905032044250.10635@cbobk.fhfr.pm>
 <nycvar.YFH.7.76.1905040849370.17054@cbobk.fhfr.pm>
 <957b01f742ed47d1ac9e0ea1277d155b@AcuMS.aculab.com>
 <e95eb45e-8bc6-ec81-fbd2-913f22c4224a@newmedia-net.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e95eb45e-8bc6-ec81-fbd2-913f22c4224a@newmedia-net.de>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 02:28:21PM +0200, Sebastian Gottschall wrote:
> so the question is if it isnt possible to create a EXPORT_SYMBOL variant
> which includes acceptable license models, but still restricts unacceptable
> licenses

It's not very difficult, "acceptable" license models are all described
in the kernel LICENSES/ directory, and must be GPLv2 compatible.

greg k-h
