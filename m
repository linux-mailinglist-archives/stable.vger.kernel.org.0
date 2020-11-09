Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3202AC278
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 18:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732006AbgKIRgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 12:36:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:39588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732084AbgKIRgJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 12:36:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4E1E21D46;
        Mon,  9 Nov 2020 17:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604943369;
        bh=yh4PScNQuUl7xFxFinV4fz2Gyo7R1SZzA2V6WulMcZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RqL0L1rBwlujgxk26Rnrqmyh84uB2TbB/KkW1FIum4+KzSExmO7FMGgSyvoOq+Lkp
         LlGDh0aDo56XwBkNrr8K1IUn1TxE38lS191Y17POX4cgw1raaqCLTFV9Jv8fi6yNyC
         R/8obUM15r+BRH6pW/04dBuOYHFyXRqYhIY/zy5E=
Date:   Mon, 9 Nov 2020 18:37:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     mpe@ellerman.id.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc/603: Always fault when
 _PAGE_ACCESSED is not set" failed to apply to 5.9-stable tree
Message-ID: <20201109173707.GA2381714@kroah.com>
References: <1604916596142143@kroah.com>
 <e53550ea-761f-14b1-f74f-627b77f7caf9@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e53550ea-761f-14b1-f74f-627b77f7caf9@csgroup.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 06:23:42PM +0100, Christophe Leroy wrote:
> Hi,
> 
> It does apply, but you have to increase your merge.renamelimit, that's
> because the file name changed recently.

I do not use git to apply patches this way, I use quilt, which does not
handle renames :)

Can you send a backported patch with the correct file rename?

thanks,

greg k-h
