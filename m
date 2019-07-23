Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B428E71842
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 14:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfGWMaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 08:30:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:45824 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726438AbfGWMaY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jul 2019 08:30:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F362EAD7B;
        Tue, 23 Jul 2019 12:30:22 +0000 (UTC)
Date:   Tue, 23 Jul 2019 14:30:22 +0200
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     dsterba@suse.com, nborisov@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: correctly validate compression
 type" failed to apply to 5.1-stable tree
Message-ID: <20190723123018.GF3997@x250.microfocus.com>
References: <156388330112473@kroah.com>
 <20190723121955.GE3997@x250.microfocus.com>
 <20190723122817.GB11835@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190723122817.GB11835@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 23, 2019 at 02:28:17PM +0200, Greg KH wrote:
> On Tue, Jul 23, 2019 at 02:19:55PM +0200, Johannes Thumshirn wrote:
> > Hi Greg,
> > 
> > please try the following:
> > 
> > >From 9afa2d46ecb511259130eb51b4ab1feb1055d961 Mon Sep 17 00:00:00 2001
> > From: Johannes Thumshirn <jthumshirn@suse.de>
> > Date: Thu, 6 Jun 2019 12:07:15 +0200
> > Subject: [PATCH] btrfs: correctly validate compression type
> > 
> > (commit aa53e3bfac7205fb3a8815ac1c937fd6ed01b41e upstream)
> 
> Worked for 5.1.y and 4.19.y, but not for the older ones.

But 4.19 lacks the buggy commit, doesn't it?

-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
