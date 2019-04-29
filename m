Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2393BE2EE
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 14:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbfD2MnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 08:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbfD2MnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 08:43:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B00D2075E;
        Mon, 29 Apr 2019 12:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556541792;
        bh=bIfBqkPDQ6e7Jh243IHJzgn2cqjGZuCjSwv8chcSMXQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rRsOcR8SM9orR5Rvp5Qc2/vbTK3Yexrp3bzYiB/hvZgpaQ8E6gg0QW640Jprhvexp
         b6oWsod4P/50gzWJ7mUveVaTK9i2uTnLSJq+cpSccUKD6ofm97Y8/J6i4C+qGOO5v1
         j3CkZutlLv2dqXyTpJzsV+cD/zd2GT1LJtLy2/CY=
Date:   Mon, 29 Apr 2019 14:43:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     David Miller <davem@davemloft.net>, stable@vger.kernel.org,
        cake@lists.bufferbloat.net
Subject: Re: [PATCH for-4.19 1/3] sch_cake: Simplify logic in
 cake_select_tin()
Message-ID: <20190429124310.GD31371@kroah.com>
References: <155446010188.1460.16734711102827171744.stgit@alrua-x1>
 <155446010198.1460.1169444436924215431.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <155446010198.1460.1169444436924215431.stgit@alrua-x1>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 05, 2019 at 12:28:22PM +0200, Toke Høiland-Jørgensen wrote:
> commit 4b454433221de445f6d3d73b0ac27b4f7da25b83 upstream.

I see no such commit in Linus's tree.  What am I supposed to do with
this?

thanks,

greg k-h
