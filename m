Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D373C90D
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 12:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387481AbfFKKeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 06:34:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387423AbfFKKeK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 06:34:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C48820820;
        Tue, 11 Jun 2019 10:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560249249;
        bh=AGDPT1AoOw9nmWJIzOMKADUrwszJF2rRpQsLSuMVAuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y74gmZ6m8Gsmmx58Wz7XQPH4kw9huB5GV3DDjvVWtWhjxEOgx8FwqKaqlhxYS4W1Y
         7qrlixGDyfIKrt2VT4kuqnIrB6OXA6rbXgqh5V3ONoNhsNPV7sSUHedEePzR0DkK6l
         rrDbBJP0oQogWtnziGHTVp8bTZlupIRw8Px8MRL4=
Date:   Tue, 11 Jun 2019 12:34:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Miles Chen <miles.chen@mediatek.com>
Cc:     stable@vger.kernel.org
Subject: Re: backport commit ("739f79fc9db1 mm: memcontrol: fix NULL pointer
 crash in test_clear_page_writeback()") to linux-4.9-stable
Message-ID: <20190611103407.GA3486@kroah.com>
References: <1560243467.26425.8.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560243467.26425.8.camel@mtkswgap22>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 11, 2019 at 04:57:47PM +0800, Miles Chen wrote:
> Hi reviewers,
> 
> I suggest to backport commit "739f79fc9db1 mm: memcontrol: fix NULL
> pointer crash in test_clear_page_writeback()" to linux-4.9 stable tree.
> 
> This email reports a NULL pointer crash in test_clear_page_writeback()
> in android common kernel-4.9. There is a fix ("739f79fc9db1 mm:
> memcontrol: fix NULL pointer crash in test_clear_page_writeback()") in
> kernel-4.13.
> 
> 
> commit: 739f79fc9db1b38f96b5a5109b247a650fbebf6d
> subject: mm: memcontrol: fix NULL pointer crash in
> test_clear_page_writeback()
> kernel version to apply to: Linux-4.9

It does not apply cleanly to the 4.9.y tree, can you provide a working
backport of it that I can apply?

thanks,

greg k-h
