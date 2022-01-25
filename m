Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6336749B00C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 10:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455884AbiAYJZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 04:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455891AbiAYJHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 04:07:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D78C0604F6;
        Tue, 25 Jan 2022 00:54:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18E716136E;
        Tue, 25 Jan 2022 08:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9178C340E0;
        Tue, 25 Jan 2022 08:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643100892;
        bh=P97CRUhpybAcbw4VlTgBCB5Io1wPlnUg/aDb9rr9v9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YbC+1f32bpxVe4yG7HdH9iXYNcGx42MN1hb4nOWCl+PIZT/P5GwVmjKqW/4swUR1d
         6KqiEL+h2UuTktfu3dQllgKGMsIw7Dj1OEsMWjPkHqZb72qOKDyN7tbOMGjrg9N8oi
         3ktiJZ24fJMYT/TJ9k+CJpwJI57tglkzNb5mmHFY=
Date:   Tue, 25 Jan 2022 09:54:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Akira Yokosawa <akiyks@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.16 0728/1039] scripts: sphinx-pre-install: Fix ctex
 support on Debian
Message-ID: <Ye+61LN8AYJ43tIG@kroah.com>
References: <20220124184125.121143506@linuxfoundation.org>
 <20220124184149.801920838@linuxfoundation.org>
 <ba541d48-826c-3d39-b3e1-05642fa6edd6@gmail.com>
 <20220125091551.6a6faaf6@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125091551.6a6faaf6@coco.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 09:15:51AM +0100, Mauro Carvalho Chehab wrote:
> Em Tue, 25 Jan 2022 07:48:39 +0900
> Akira Yokosawa <akiyks@gmail.com> escreveu:
> 
> > Hi Greg,
> > 
> > On Mon, 24 Jan 2022 19:41:57 +0100,
> > Greg Kroah-Hartman wrote:
> > > From: Mauro Carvalho Chehab <mchehab@kernel.org>
> > > 
> > > [ Upstream commit 87d6576ddf8ac25f36597bc93ca17f6628289c16 ]
> > > 
> > > The name of the package with ctexhook.sty is different on
> > > Debian/Ubuntu.
> > > 
> > > Reported-by: Akira Yokosawa <akiyks@gmail.com>
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> > > Tested-by: Akira Yokosawa <akiyks@gmail.com>
> > > Link: https://lore.kernel.org/r/63882425609a2820fac78f5e94620abeb7ed5f6f.1641429634.git.mchehab@kernel.org
> > > Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>  
> > 
> > This "Fix" is against upstream commit 7baab965896e ("scripts:
> > sphinx-pre-install: add required ctex dependency") which is
> > also new to v5.17-rc1.
> > 
> > So I don't think this is worth backporting to stable branches.
> 
> Well, either both patches should be backported or none, IMHO.
> I guess I would just backport also commit 7baab965896e.

Ok, in looking at that report, it makes sense, I'll add both of these
now.

thanks,

greg k-h
