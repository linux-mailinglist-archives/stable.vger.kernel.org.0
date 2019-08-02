Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA4727ED3F
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 09:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389405AbfHBHQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 03:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387657AbfHBHQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 03:16:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10F5220449;
        Fri,  2 Aug 2019 07:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564730166;
        bh=GzrJYKdaGAB/vRQG58DPN7pMYwycEY4dw++v+VVci90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YmkJOrqA2O559LQq/pmV25PARoDR1DvQhFsH1smtAtIYTvKkFh9QnM28V1Xwp1jy3
         GQFe4jKp3mMCVpkR8g2XmPgn6evcOKygZ9Z7ynCy1L7j750Wf3geJFfabH4jXhuMZ+
         p4OlETfe8S7dFE9Um4T7mFIZOmSzfsyF6yUUsblc=
Date:   Fri, 2 Aug 2019 09:16:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc:     Jinpu Wang <jinpuwang@gmail.com>, Sasha Levin <sashal@kernel.org>,
        "v3.14+, only the raid10 part" <stable@vger.kernel.org>
Subject: Re: [stable-4.19 0/4] CVE-2019-3900 fixes
Message-ID: <20190802071604.GA26174@kroah.com>
References: <20190722130313.18562-1-jinpuwang@gmail.com>
 <20190722154239.GH1607@sasha-vm>
 <CAD9gYJ+xhujXEHVNAEB5EUO7vwkXuZeU-xf0+g049uk8ucP_tA@mail.gmail.com>
 <20190802070201.GA18798@pcnci.linuxbox.cz>
 <20190802071342.GA25871@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802071342.GA25871@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 09:13:42AM +0200, Greg Kroah-Hartman wrote:
> 
> A: No.
> Q: Should I include quotations after my reply?
> 
> http://daringfireball.net/2007/07/on_top
> 
> On Fri, Aug 02, 2019 at 09:02:01AM +0200, Nikola Ciprich wrote:
> > Hi,
> > 
> > just wanted to ask about the status of those? I'm testing patches on top
> > of 4.19.60, not sure about how can I test if the problem is fixed, but at
> > least nothing seems to be broken so far..
> 
> We wanted to get some verification that the issues were really fixed by
> these patches.  If no one knows how to test them, then odds are they are
> not vulnerable, right?  :)

Ok, snarkyness aside, let me look at these today and queue them up.
They have been sitting here for a while and they would be good to get
merged...

thanks,

greg k-h
