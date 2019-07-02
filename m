Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D115DAEA
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 03:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfGCBdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 21:33:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbfGCBdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 21:33:04 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D76B21994;
        Tue,  2 Jul 2019 23:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562108624;
        bh=IVh8jOUJJEA+ALuVr4qfD7XPSVuluLL2j2wLnTQfx/8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LR3HsGY+0K7CirHAyxmpdqdnERY7xoIsiQqICrYKbQ9iazucnARZupuPMSUAF+Ijk
         5kgDTu/VKmblxBaUsVZmnzL6PCtHypxRpA8WkODcsNq09cZpDwIt5G6HOl+s2JBCjG
         hfTv1qBFQpw7Ny3+U9IDSJ5ba3T/9DJ8gkvyTUdw=
Date:   Tue, 2 Jul 2019 16:03:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     stable@vger.kernel.org, hirofumi@mail.parknet.co.jp
Subject: Re: +
 fat-add-nobarrier-to-workaround-the-strange-behavior-of-device.patch added
 to -mm tree
Message-Id: <20190702160343.0b1fd99491f7b257f68ad82c@linux-foundation.org>
In-Reply-To: <20190702225053.GA24248@lst.de>
References: <20190702224959.sBsBg%akpm@linux-foundation.org>
        <20190702225053.GA24248@lst.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 3 Jul 2019 00:50:53 +0200 Christoph Hellwig <hch@lst.de> wrote:

> I still very fundamentally disagree with this patch.  We did a concerted
> effort around the other file systems to move to the device level tweak
> and remove the badly misnamed option, so we should not add it now for
> fat.

OK, thanks, I'll leave it on hold for now.
