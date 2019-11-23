Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A254D10801D
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 20:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfKWTWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Nov 2019 14:22:51 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:24638 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfKWTWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Nov 2019 14:22:51 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id xANJMiKm016414;
        Sat, 23 Nov 2019 20:22:44 +0100
Date:   Sat, 23 Nov 2019 20:22:44 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Bob Funk <bobfunk11@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, sashal@kernel.org,
        stable@vger.kernel.org
Subject: Re: Bug Report - Kernel Branch 4.4.y - asus-wmi.c
Message-ID: <20191123192244.GA16156@1wt.eu>
References: <33bfa93a-3853-85f5-47f9-8a69ed9c656e@gmail.com>
 <20191123092701.GA2129125@kroah.com>
 <e452278c-4b5c-59fc-441c-94b41d817503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e452278c-4b5c-59fc-441c-94b41d817503@gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 23, 2019 at 01:08:03PM -0600, Bob Funk wrote:
> For the record, the patch that Willy offered does fix the issue on my
> affected
> system. That might be a better choice than my request to revert as per the
> original email.

Greg, FWIW I did nothing more than a regular backport so that you can take
it as-is. I think you dropped it from 4.4 because it did not apply well
and was not worth the hassle, but given that it fixes a regression caused
by another backport I think it makes sense to take it, at least so that
some users do not stop updating. The fix was only merged into 4.19, not
4.4/4.9/4.14.

The backports for 4.9 and 4.14 are easy to do, if you're willing to take
the patches I can do them as well, just let me know.

Cheers,
Willy
