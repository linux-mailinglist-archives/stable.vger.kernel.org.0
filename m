Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1244F1B534
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 13:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfEMLqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 07:46:09 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34324 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfEMLqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 07:46:09 -0400
Received: by mail-lj1-f196.google.com with SMTP id j24so9832931ljg.1;
        Mon, 13 May 2019 04:46:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SJ5l1IpLJC7+dtI8NGV8YOL2GMYogaRYg2y2HKC56RY=;
        b=d2mLN4Gyly0EQh0bZU0nlKxjB/VAqX7fAYjqScnhheGDz1/RElea16mSKhjn6sMVId
         XVfPcG9KWovZPLnv38GziZv9GL5kCngUxazpBXv6dwQ/knf0KdVrGc/p6xm2xtgUKScr
         ItWhMRR0UIVh3aptheEj80HgpaH1ELQJAevf8teR5Co+W2sj/Zc17i6jUW058ydY9PAX
         IFh0dEZFOFNAID4/Q5ZH2ImEuR0O84+xLCPovsHYW9SJKu34DJhnWAin1+c3H557eeCz
         SL7ToTknMKu32yM4e077gTDoh1l/fpXutKRssEqrTwuVLi3BdxDAeUya/jrVEWRn9A6S
         0NcA==
X-Gm-Message-State: APjAAAUKl+/9i++K3NUwAgiua04y4PzyGxeedKJJCmEzJffc8CkN5iN+
        7EP/bbhoJ0jLguB3kwONIGRDFRLr
X-Google-Smtp-Source: APXvYqzr5W7H5LcHa+mQgi60MiBHA2s64Bl73hcokznd9DXietx/FDXkiHd4fGSYUmXarczK+muA9Q==
X-Received: by 2002:a2e:844a:: with SMTP id u10mr13469505ljh.41.1557747966791;
        Mon, 13 May 2019 04:46:06 -0700 (PDT)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id k26sm3603280lfb.63.2019.05.13.04.46.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 04:46:05 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1hQ9P7-0007h8-EU; Mon, 13 May 2019 13:46:02 +0200
Date:   Mon, 13 May 2019 13:46:01 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] USB: serial: fix unthrottle races
Message-ID: <20190513114601.GB9651@localhost>
References: <20190425160540.10036-1-johan@kernel.org>
 <20190425160540.10036-2-johan@kernel.org>
 <20190513104339.GA9651@localhost>
 <20190513105606.GA21346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513105606.GA21346@kroah.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 12:56:06PM +0200, Greg Kroah-Hartman wrote:
> On Mon, May 13, 2019 at 12:43:39PM +0200, Johan Hovold wrote:
> > On Thu, Apr 25, 2019 at 06:05:36PM +0200, Johan Hovold wrote:
> > > Fix two long-standing bugs which could potentially lead to memory
> > > corruption or leave the port throttled until it is reopened (on weakly
> > > ordered systems), respectively, when read-URB completion races with
> > > unthrottle().

> > > Fixes: d83b405383c9 ("USB: serial: add support for multiple read urbs")
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > 
> > Greg, I noticed you added a stable tag to the corresponding cdc-acm fix
> > and think I should have added on one from the start to this one as well.
> > 
> > Would you mind queuing this one up for stable?
> > 
> > Upstream commit 3f5edd58d040bfa4b74fb89bc02f0bc6b9cd06ab.
> 
> Sure, now queued up for 4.9+

Thanks. The issue has been there since v3.3 so I guess you could queue
it for all stable trees.

Johan
