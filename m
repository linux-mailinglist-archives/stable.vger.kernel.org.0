Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741C6233F28
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 08:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731297AbgGaGgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 02:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731269AbgGaGgO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jul 2020 02:36:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCC91207F5;
        Fri, 31 Jul 2020 06:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596177373;
        bh=Hl9TuKXwfbVAEdY+CGf5cvl10B1o3+uduhGiL2IKBi8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YrmbtjF59Gr3fFwebbxRUcwsALQjr9GXFpSz84UtSNRnKhI1BRy253CXBD6TbElr+
         YVGbU9pN9Zu8uykydceKdrO4/R0Kvt1pzFaZQFFxORqHCNOTcbBH2lzNgiggR2dDus
         ziozel1TJezLdGHeEAdL+zE37iWz4SI+lQ4K/tI4=
Date:   Fri, 31 Jul 2020 08:36:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Donnelly <john.p.donnelly@oracle.com>
Cc:     Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: (resend) [PATCH [linux-4.14.y]] dm cache: submit writethrough
 writes in parallel to origin and cache
Message-ID: <20200731063600.GE1508201@kroah.com>
References: <37c5a615-655d-c106-afd0-54e03f3c0eef@oracle.com>
 <20200727150014.GA27472@redhat.com>
 <20200729115119.GB2674635@kroah.com>
 <20200729115557.GA2799681@kroah.com>
 <20200729141607.GA7215@redhat.com>
 <851f749a-5c92-dcb1-f8e4-95b4434a1ec4@oracle.com>
 <20200730052127.GA3860556@kroah.com>
 <8481B1B9-C9CF-442A-87BE-4A01499CF26D@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8481B1B9-C9CF-442A-87BE-4A01499CF26D@oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 09:40:32AM -0500, John Donnelly wrote:
> 
> 
> > On Jul 30, 2020, at 12:21 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > On Wed, Jul 29, 2020 at 06:45:46PM -0500, John Donnelly wrote:
> >> 
> >> 
> >> On 7/29/20 9:16 AM, Mike Snitzer wrote:
> >>> On Wed, Jul 29 2020 at  7:55am -0400,
> >>> Greg KH <gregkh@linuxfoundation.org> wrote:
> >>> 
> >>>> On Wed, Jul 29, 2020 at 01:51:19PM +0200, Greg KH wrote:
> >>>>> On Mon, Jul 27, 2020 at 11:00:14AM -0400, Mike Snitzer wrote:
> >>>>>> This mail needs to be saent to stable@vger.kernel.org (now cc'd).
> >>>>>> 
> >>>>>> Greg et al: please backport 2df3bae9a6543e90042291707b8db0cbfbae9ee9
> >>>>> 
> >>>>> Now backported, thanks.
> >>>> 
> >>>> Nope, it broke the build, I need something that actually works :)
> >>>> 
> >>> 
> >>> OK, I'll defer to John Donnelly to get back with you (and rest of
> >>> stable@).  He is more invested due to SUSE also having this issue.  I
> >>> can put focus to it if John cannot sort this out.
> >>> 
> >>> Mike
> >>> 
> >> 
> >> 
> >> Hi.
> >> 
> >> 
> >> Thank you for reaching out.
> >> 
> >> What specifically is broken? . If it that applying
> >> 2df3bae9a6543e90042291707b8db0cbfbae9ee9 to 4.14.y is failing?
> > 
> > yes, try it yourself and see!
> 
>  Hi . 
> 
>  Yes .  
> 
>   2df3bae9a6543e90042291707b8db0cbfbae9ee9
> 
>  Needs refactored to work in 4.14.y (now .190) as there is a conflict in arguments as noted in my original submittal ;-) . 
>  I also noticed there are warning to functions " defined but not used [-Wunused-function] “  too.
> 
>  Do you want another PATCH v2 message  in a new email thread,  or can I  append it to this this thread ?

I do not care, either should be fine.
