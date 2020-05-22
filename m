Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405331DE63A
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 14:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgEVMHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 08:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729850AbgEVMHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 08:07:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1EAC2072C;
        Fri, 22 May 2020 12:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590149271;
        bh=vHSgjKvbc5R4F0jsQCkcjIrdu+UdsNtu0U/jwyEL4ZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rm6PFaJ5Df1MOII0mNbl59jDH2idX4qKC9sttvY2mJDJfxk5cCMzBRMNY2xq0/Qun
         zz7P2DauJ1JrLcyi1ioI0L/L1z3LJr6kiQBYbzmYMLBKRJ3/lyFojwxbwyCkIXURRx
         S1e9pkYTO3R9gBWrh7cdsOHGZYwV6z7/ER8k/HVk=
Date:   Fri, 22 May 2020 14:07:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Giuliano Procida <gprocida@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 0/4] [backports] fix l2tp use-after-free in
 pppol2tp_sendmsg
Message-ID: <20200522120748.GB1457873@kroah.com>
References: <20200521135704.109812-1-gprocida@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521135704.109812-1-gprocida@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 21, 2020 at 02:57:00PM +0100, Giuliano Procida wrote:
> Hi Greg.
> 
> This is for 4.14.
> 
> We received a PoC (code to run as root with a KASAN kernel)
> demonstrating the existence of a use-after-free in pppol2tp_sendmsg.
> This was accompanied by a patch to resolve it, consisting mostly of
> parts of patch 3 plus a little of 4.
> 
> The following patches all apply cleanly and compile with allmodconfig.
> However, I lack the hardware to test them.

All now queued up, thanks.

greg k-h
