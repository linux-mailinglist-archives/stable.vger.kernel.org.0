Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0537231B78
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 12:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfFAKuM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 1 Jun 2019 06:50:12 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:33266 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfFAKuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Jun 2019 06:50:12 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hX1aS-0001h9-Ma; Sat, 01 Jun 2019 12:50:08 +0200
Date:   Sat, 1 Jun 2019 12:50:08 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Soeren Moch <smoch@web.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "usb: core: remove local_irq_save() around
 ->complete() handler"
Message-ID: <20190601105008.zfqrtu6krw4mhisb@linutronix.de>
References: <20190531215340.24539-1-smoch@web.de>
 <20190531220535.GA16603@kroah.com>
 <6c03445c-3607-9f33-afee-94613f8d6978@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <6c03445c-3607-9f33-afee-94613f8d6978@web.de>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-06-01 01:02:37 [+0200], Soeren Moch wrote:
> > Why not just fix that driver?  Wouldn't that be easier?
> >
> I suspect there are more drivers to fix. I only tested WIFI sticks so
> far, RTL8188 drivers also seem to suffer from this. I'm not sure how to
> fix all this properly, maybe Sebastian as original patch author can help
> here.

Suspecting isn't helping here.

> This patch is mostly for -stable, to get an acceptable solution quickly.
> It was really annoying to get such unstable WIFI connection over the
> last three kernel releases to my development board.  Since my internet
> service provider forcefully updated my router box 3 weeks ago, I
> unfortunately see the same symptoms on my primary internet access.
> That's even worse, I need to reset this router box every few days. I'm
> not sure, however, that this is caused by the same problem, but it feels
> like this.
> So can we please fix this regression quickly and workout a proper fix
> later? In the original patch there is no reason given, why this patch is
> necessary. With this revert I at least see a stable connection.

I will look into this. This patch got in in v4.20-rc1 and the final
kernel was released by the end of 2018. This is the first report I am
aware of over half year later…

> Thanks,
> Soeren

Sebastian
