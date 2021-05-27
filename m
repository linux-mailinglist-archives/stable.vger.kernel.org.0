Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20008392A78
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 11:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbhE0JSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 05:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235775AbhE0JS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 05:18:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CDC7610CB;
        Thu, 27 May 2021 09:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622107016;
        bh=kUCEtACwTfV2pAhZPvQKeU1Y2obfxXmiwctwVq2Glpk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R1SQK0GVkmRWy7F2TzWqdPON6RUAmEGoPsEA2w56kcJFb2w0LBlQBfrRN+3fEp82D
         J0tDl/mTxoZztFlNhCfmg4d7HYUahWIv/THcV/7Cl/MJEd2kxZsHadpWVYf285teO4
         kBwxA4HnEt2AdU8m1NnmlQcH4hhVToHXbkdAuV/0=
Date:   Thu, 27 May 2021 11:16:54 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jan.kratochvil@redhat.com" <jan.kratochvil@redhat.com>
Subject: Re: LTS perf unwind fix
Message-ID: <YK9jhtj/hwTKU5+N@kroah.com>
References: <682895f7a145df0a20814001c508688113322854.camel@nokia.com>
 <YKz2RIcTyD/FCF+a@kroah.com>
 <45b140543ccb85ab184ed17befca4a9e64661051.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45b140543ccb85ab184ed17befca4a9e64661051.camel@nokia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 26, 2021 at 07:21:15AM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> 2021-05-25 15:06 +0200, gregkh@linuxfoundation.org:
> > On Tue, May 25, 2021 at 12:41:15PM +0000, Rantala, Tommi T. (Nokia -
> > FI/Espoo) wrote:
> > > Can you please cherry-pick this to LTS:
> > > 
> > > commit bf53fc6b5f415cddc7118091cb8fd6a211b2320d
> > > Author: Jan Kratochvil <jan.kratochvil@redhat.com>
> > > Date:   Fri Dec 4 09:17:02 2020 -0300
> > > 
> > >     perf unwind: Fix separate debug info files when using elfutils'
> > > libdw's unwinder
> > 
> > What exact kernel(s) do you want it backported to?
> 
> 5.4.y please, tested Jan's and Dave's patches with it, and they cure
> some broken backtraces.
> 
> 
>   commit 4e1481445407b86a483616c4542ffdc810efb680
>   Author: Dave Rigby <d.rigby@me.com>
>   Date:   Thu Feb 18 16:56:54 2021 +0000
> 
>     perf unwind: Set userdata for all __report_module() paths
> 
> 

What does this commit here have to do with the above?

confused as to what exactly you are asking for here, sorry, can you be
more specific?  Like "please apply commits X, Y, and Z, in that order,
to the X.y kernel?"

thanks,

greg k-h
