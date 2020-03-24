Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4237191373
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 15:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbgCXOnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 10:43:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727464AbgCXOnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 10:43:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0F0C2074D;
        Tue, 24 Mar 2020 14:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585061021;
        bh=YGLNP/IXNHSdlNivc3mGScmLK2wHsHCBGrFUSV8D1/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gc+D7SdE/ud/v+FUvrfzIHLDg8P0l+lMONFjhoG9pzIjxogZ/4nwiVstBhi4nzXAs
         dSgVLcFjPgl9j44S0ghS907EjBOcbbsTltVjKaUpphLgAXbbqQZThMelpSga4K7hTN
         2OcoTeOA2GPzhoWR20lv8p26kC1o/3cXn24UyYRY=
Date:   Tue, 24 Mar 2020 15:43:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark Salyzyn <salyzyn@android.com>
Cc:     stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: locks use-after-free stable request
Message-ID: <20200324144338.GA2507446@kroah.com>
References: <52be02d3-3a6a-c8b8-4177-5cc1d67aedd4@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52be02d3-3a6a-c8b8-4177-5cc1d67aedd4@android.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 24, 2020 at 07:24:49AM -0700, Mark Salyzyn wrote:
> Referencing upstream fixes commit dcf23ac3e846ca0cf626c155a0e3fcbbcf4fae8a
> ("locks: reinstate locks_delete_block optimization") and commit
> 6d390e4b5d48ec03bb87e63cf0a2bff5f4e116da ("locks: fix a potential
> use-after-free problem when wakeup a waiter") and possibly address
> CVE-2019-19769.
> 
> Please apply to all relevant stable trees including 5.4, 4.19 and below.
> Confirmed they apply cleanly to 5.4 and 4.19.
> 
> 
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> 
> Cc: stable@vger.kernel.org
> 
> Cc: linux-kernel@vger.kernel.org
> 
> Cc: kernel-team@android.com
> 

These are all queued up for the next round of 5.4 and 5.5 stable
releases,but they do not seem to apply to 4.19.

And why do you think they apply to 4.19, that's not what 6d390e4b5d48
("locks: fix a potential use-after-free problem when wakeup a waiter")
says.

confused,

greg k-h
