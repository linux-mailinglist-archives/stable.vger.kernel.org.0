Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C1B251EF1
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 20:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgHYSTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 14:19:34 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:38548 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYSTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 14:19:34 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3FB271C0BB9; Tue, 25 Aug 2020 20:19:31 +0200 (CEST)
Date:   Tue, 25 Aug 2020 20:19:30 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 4.19 09/71] btrfs: sysfs: use NOFS for device creation
Message-ID: <20200825181930.GA989@bug>
References: <20200824082355.848475917@linuxfoundation.org>
 <20200824082356.348762357@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824082356.348762357@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

> From: Josef Bacik <josef@toxicpanda.com>
> 
> Dave hit this splat during testing btrfs/078:

...

> CC: stable@vger.kernel.org # 4.14+

This commit is in mainline, as a47bd78d0c44621efb98b525d04d60dc4d1a79b0, but is not marked
as such.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
