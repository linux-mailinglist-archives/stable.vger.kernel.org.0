Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB2E19F361
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 12:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgDFKRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 06:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726675AbgDFKRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Apr 2020 06:17:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C6742054F;
        Mon,  6 Apr 2020 10:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586168228;
        bh=ds1MlHuAAnJu9UOEPHBIrpL4Q3PVENppdThGQdxIwfk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TN5qXqqpQh9MR4BCb5crNVwWGvweZM8yzilJu+R/qaeHYukfQk1loDjKumQD1xoNI
         nK+cyG8r3nwGen6gMvJBVruFahFZdlbyI4Rp4ZMpER4Fr/0EAi5M7gtkHWmQJu86Qm
         tMH9K2KD7mkKIwvetXxcYB2wTNJoYpSFfiLkFIjQ=
Date:   Mon, 6 Apr 2020 12:17:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sean Young <sean@mess.org>
Cc:     stable@vger.kernel.org, linux-media@vger.kernel.org,
        Takashi Kanamaru <neuralassembly@gmail.com>
Subject: Re: [PATCH] media: rc: IR signal for Panasonic air conditioner too
 long sequences is too small
Message-ID: <20200406101704.GA1743709@kroah.com>
References: <CAKL8oB_qPGVXd3MCj=f1Lzh02ifGzYTS2YAD77s2MY2LAnc+1A@mail.gmail.com>
 <20190612150132.iemhbronjjaonpt2@gofer.mess.org>
 <CAKL8oB-KxsGxHAUac7sYBf-Gs4UkAPVkXg75LwwVbut9GkQ-sQ@mail.gmail.com>
 <20190613084926.bjxv2vdkp3qqpkuu@gofer.mess.org>
 <CAKL8oB-_=07iOBUfiuD4sj_nuL2HURt_Ej4m9EFCL7yNzLYXjg@mail.gmail.com>
 <20200406095154.GA19905@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406095154.GA19905@gofer.mess.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 06, 2020 at 10:51:55AM +0100, Sean Young wrote:
> Hello stable team, Greg,
> 
> On Mon, Apr 06, 2020 at 06:06:29PM +0900, Takashi Kanamaru wrote:
> > Dear Sean Young and all,
> > 
> > In the last year, a change of the value of LIRCBUF_SIZE
> > from 256 to 1024 was committed to the master branch at the time,
> > and the new value can be used in the kernel 5.3 or later.
> > 
> > https://github.com/torvalds/linux/commit/5c4c8b4a999019f19e770cb55cbacb89c95897bd#diff-3b71f634ae88214ee31a1b6c90f7df5c
> > 
> > This change of LIRCBUF_SIZE was proposed
> > in order to treat long IR sequences of remote controllers
> > on Raspberry Pi.
> > 
> > However, Raspberry Pi now uses kernel 4.19,
> > so the new value cannot be used.
> > 
> > Can you backport the above commit
> > to the older kernels, i.e.,
> > 4.19, 4.20, 5.0, 5.1, and 5.2?
> 
> I'd like to propose this commit for the stable tree, from kernel 4.16 to
> 5.2. It has been in the tree from v5.3 onwards and no regressions have
> been found.

The only kernel being supported in that range is 4.19 at the moment, so
I'll queue it up now, thanks.  All other kernel trees are long
end-of-life and no one should be using them anymore.

thanks,

greg k-h
