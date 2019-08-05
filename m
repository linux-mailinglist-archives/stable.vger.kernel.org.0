Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF21817ED
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 13:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfHELMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 07:12:37 -0400
Received: from smtp.duncanthrax.net ([89.31.1.170]:56240 "EHLO
        smtp.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbfHELMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 07:12:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=duncanthrax.net; s=dkim; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date;
        bh=eGfmqwoNQse7TIzn8zKVAh9yCdBrHUHS48o8cQ5O26s=; b=VKIe46GTHRb85/XRKqr1NVST0y
        qg3bi/62b6qfFSYtYQyvOxWPD91NLIzfyojFfwFocWB/M0s0zUer8596M8zEmtfsTFEv3f4O2PwEJ
        GZAGNmnp3WxDUNoFgHx92+IVwPObnrDzJmb2gE4sN+98xveGMkAnUWvsX+h4tq/9B57s=;
Received: from frobwit.duncanthrax.net ([89.31.1.178] helo=t470p.stackframe.org)
        by smtp.eurescom.eu with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.86_2)
        (envelope-from <svens@stackframe.org>)
        id 1huaup-0004yg-3l; Mon, 05 Aug 2019 13:12:35 +0200
Date:   Mon, 5 Aug 2019 13:12:33 +0200
From:   Sven Schnelle <svens@stackframe.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     deller@gmx.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] parisc: fix race condition in patching
 code" failed to apply to 5.2-stable tree
Message-ID: <20190805111233.GB10502@t470p.stackframe.org>
References: <1564983055189121@kroah.com>
 <20190805074524.GA10502@t470p.stackframe.org>
 <20190805105701.GA1157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805105701.GA1157@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Aug 05, 2019 at 12:57:01PM +0200, Greg KH wrote:
> On Mon, Aug 05, 2019 at 09:45:24AM +0200, Sven Schnelle wrote:
> > On Mon, Aug 05, 2019 at 07:30:55AM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 5.2-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> >  
> > The reason is that 5.2 doesn't have DYNAMIC_FTRACE suport, so this can be
> > ignored.
> 
> Then why did the patch have:
> 	    Cc: <stable@vger.kernel.org> # 5.2+
> in it?

My Fault. Helge asked me whether this patch should be added to 5.2 stable,
and i said "yes", assuming that DYNAMIC_FTRACE for PA-RISC is already in
Linux-5.2, which isn't the case. It got merged in 5.3.

Regards
Sven
