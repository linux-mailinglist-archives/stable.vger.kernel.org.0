Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24247231DAB
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 13:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgG2Lv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 07:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgG2Lv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jul 2020 07:51:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18A3A2076E;
        Wed, 29 Jul 2020 11:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596023487;
        bh=uiazbZon5DuuV7nkm5kCUJtsQgzorujkgMSDAtUtSqI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oge3bW96sp9UtoK92txsHC/RcHVb1cbyaf3d6/AcLcBBTikzDmqMcSpegqGJUvag0
         hTpJyxCrxfjh1h9V7SKBgYjG1DnpvQIJpLoi/+30IPEv7gk/y52Im8svZdtlztxh65
         mPKvyCCuQhDVq9l5E511+w8PWL4vfveWsdlY4k5U=
Date:   Wed, 29 Jul 2020 13:51:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     John Donnelly <John.P.donnelly@oracle.com>, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: (resend) [PATCH [linux-4.14.y]] dm cache: submit writethrough
 writes in parallel to origin and cache
Message-ID: <20200729115119.GB2674635@kroah.com>
References: <37c5a615-655d-c106-afd0-54e03f3c0eef@oracle.com>
 <20200727150014.GA27472@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727150014.GA27472@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 11:00:14AM -0400, Mike Snitzer wrote:
> This mail needs to be saent to stable@vger.kernel.org (now cc'd).
> 
> Greg et al: please backport 2df3bae9a6543e90042291707b8db0cbfbae9ee9

Now backported, thanks.

greg k-h
