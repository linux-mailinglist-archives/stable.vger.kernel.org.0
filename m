Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60E310A356
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 18:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbfKZR2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 12:28:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:32880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbfKZR2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 12:28:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A5D22071E;
        Tue, 26 Nov 2019 17:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574789312;
        bh=PqcLATrffum4zuGpW5ZCLsjuEhchNhiH77cwjM4yx38=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fT/FHNZu14IDf/y8yx3tTQTVuRl5jDNIqqEWlWlZNPovVy1y5a8+bn0nzqRk2+2C1
         q2x2gesjyjuFe1oTsYWcd8uSI/3s0+Vh3dM6o6vMyhSY+8euqKNHoEwOYb2v3O4ACw
         FlyXaDRL5RH0JfYD7Vbt34r3WkB32q2hnZ7dv4A8=
Date:   Tue, 26 Nov 2019 18:28:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     vcaputo@pengaru.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Revert "dm crypt: use WQ_HIGHPRI for the
 IO and crypt" failed to apply to 4.19-stable tree
Message-ID: <20191126172828.GA1665391@kroah.com>
References: <157476486318662@kroah.com>
 <20191126170550.GA2718@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126170550.GA2718@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 26, 2019 at 12:05:50PM -0500, Mike Snitzer wrote:
> On Tue, Nov 26 2019 at  5:41am -0500,
> gregkh@linuxfoundation.org <gregkh@linuxfoundation.org> wrote:
> 
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> I assume you didn't first pull in the prereq commit detailed in the
> commit header with:
>  Requires: ed0302e83098d ("dm crypt: make workqueue names device-specific")
> 
> ?
> 
> Because this worked for me:
> git cherry-pick ed0302e83098d
> git cherry-pick f612b2132db529feac4f965f28a1b9258ea7c22b

Oops, missed that, will go try that now, sorry for the noise...

greg k-h
