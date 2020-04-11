Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBE71A4F94
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 13:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgDKLoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 07:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgDKLoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 07:44:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F26920732;
        Sat, 11 Apr 2020 11:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586605493;
        bh=Nldghb/aK0fjrOzUX5o025qoOuAeW/U0gYA/4XKlAJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JaQggXQps/nAbeeKsfwRBro5La9x5CxklSFCV2cnLxk7E+uvxXjXk7S9Y8uAIa/MO
         Etjl8mAqHKaEFvSn5e90UJN874aCY1OUAS+RIEsCnjuQ01s7TEJQKtm6fnOtSodzYk
         dYcDXi1B9TrLdUOEKYwMhFZdKlpZKMdqFVn1SCh0=
Date:   Sat, 11 Apr 2020 13:44:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Patchset for CVE-2020-1749 Kernel 4.19
Message-ID: <20200411114450.GE2606747@kroah.com>
References: <1586262823357.14177@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586262823357.14177@mentor.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 12:33:43PM +0000, Schmid, Carsten wrote:
> Hi Greg,
> 
> as announced i have backported the identified patches for CVE-2020-1749 from kernel 5.x into v4.19.
> Applies to stable linux-v4.19.y (with y=114).

Have you been able to test these patches so that you know they work?

And can you please send them as a patch series, not as attachments, and
 cc: all the original authors so that everyone can know what is going on
and weigh in if they see any issues?

And finally, do not change the changelog text from the original commits,
that's not ok.  If you need to put any notes in there as to what you
did, follow the format we have been using for years, and put it in the
s-o-b: area in a small [ box ]

Same for the 4.14 patches.

thanks,

greg k-h
