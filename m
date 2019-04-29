Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F37DE2E9
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 14:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfD2MmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 08:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728006AbfD2MmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 08:42:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E7B020675;
        Mon, 29 Apr 2019 12:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556541728;
        bh=jKR/Iq4h9VBT62enEBoc9eabAaRsmbUlR4We681bp4Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=prNpFhdQwJ3dj2nUya4VKJoW9IncoKtmzcIn+UqJVTzxI7jVjt6W0oGlC3FMFaanH
         OziKzF8a9Cnqt35KCVGHkzsh2wXVAT4WsiFnMn4W4fAsTN2nT4KJXvCx5Zz0a0AnKf
         QkPQHlT1Oi9MyN7u1wR4nDkY3NIt71+sLcbYW38A=
Date:   Mon, 29 Apr 2019 14:42:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH] dm integrity: change memcmp to strncmp in
 dm_integrity_ctr
Message-ID: <20190429124205.GC31371@kroah.com>
References: <155534623619152@kroah.com>
 <alpine.LRH.2.02.1904160442450.18585@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1904160442450.18585@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 16, 2019 at 04:44:23AM -0400, Mikulas Patocka wrote:
> Hi.
> 
> Here I'm sending the patch backported for the kernel 4.14.

Thanks, now queued up.

greg k-h
