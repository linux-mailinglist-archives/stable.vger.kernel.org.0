Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2C6115850
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 21:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfLFUvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 15:51:05 -0500
Received: from mail.kapsi.fi ([91.232.154.25]:48377 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfLFUvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 15:51:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=w+cVWrA45xf+tHdvZU6WM7nm43N7RXemwP51QMaBP9s=; b=P5J9s2XZ+YaS+14+tDKrallG72
        clC5Yh2OYVUXW/7y3DumIj5bKikaxlkTcNJwPnTPZph0gsUuiWnJCSYx/9cGJbJMhOlNfaQYNe0mV
        wBy/H9moMOa6FLiOkIFmnfUxyr/TnezSWH35eF4FRbKrSuwdDX9BEmWlLI0DfPSfwZKa8YCbggPzn
        IDLZuHSvm466fxoM/2zPC5xdPW/H546Lm2+g6rpWYzDorOZiDIX5fs4D4Ce1jQyHoqCA4rQOXTkwp
        Rxk1i+QDXv3ySKo80y2J4kTdQw/L8sdBQjeBZ4Jyd5VsY9UtehVvNWHZlu9fYfDVw/cDPH/w++mZS
        hsUBdk0w==;
Received: from 91-154-92-5.elisa-laajakaista.fi ([91.154.92.5] helo=localhost)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jarkko.sakkinen@linux.intel.com>)
        id 1idKZ5-0002a2-7A; Fri, 06 Dec 2019 22:51:03 +0200
Date:   Fri, 6 Dec 2019 22:51:03 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org, James Morris <jmorris@namei.org>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] tpmdd updates for Linux v5.4
Message-ID: <20191206205103.GC9971@linux.intel.com>
References: <20190902143121.pjnykevzlajlcrh6@linux.intel.com>
 <CAA9_cmeLnHK4y+usQaWo72nUG3RNsripuZnS-koY4XTRC+mwJA@mail.gmail.com>
 <20191122161836.ry3cbon2iy22ftoc@cantor>
 <20191129210400.GB12055@linux.intel.com>
 <20191129232249.bgj25rlwrcg3afj5@cantor>
 <20191129233247.oavwmrp65b5nc5hq@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191129233247.oavwmrp65b5nc5hq@cantor>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 91.154.92.5
X-SA-Exim-Mail-From: jarkko.sakkinen@linux.intel.com
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 29, 2019 at 04:32:47PM -0700, Jerry Snitselaar wrote:
> > I still don't have access to one of the laptops, but looking online
> > they should have one of the following: i5-8265U, i5-8365U, i7-8565U,
> > or i7-8665U. The tpm is discrete, so I don't know that the cpu will
> > matter. Looking at a log, in the t490s case it is an STMicroelectronics
> > chip. So both Infineon and STM so far.
> > 
> 
> In the case reported on Fedora the cpu is a i7-8665U.

I don't think CPU will matter that much if it is a dTPM.

/Jarkko
