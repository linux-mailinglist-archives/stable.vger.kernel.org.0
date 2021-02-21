Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A195320A7E
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 14:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhBUNSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 08:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhBUNSZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Feb 2021 08:18:25 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64386C061574
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 05:17:44 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id m25so2459260wmi.3
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 05:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IMTgUdCDZrOAZx2RsikEH3uVgS+SSyiMRqGQynSPIw0=;
        b=sFTo+XWBJ641IeDDucEgJqZDLf5g3sxnRcNZjOrWQKCr4ohuc6eXRUjhDlS5cPQCGl
         9+59GXjvXHB3ke6VhYpP27JZswVV0PPgm49gNsida7YxV3dpKOvCstvZSxiI5IS8LIX9
         /82Yk63W7M5L/nIEbtwWFpMC0+tn9J9Tm91SeTda3LqCgCTvJ6aYzqyzS19PBxSOc/Lk
         1lRHdXq0zNu3/nOOBj8w6Dbim9hihK6qMB5Aia3sN8s+2sEGc1q2JOuTdnJipGTxPFEM
         TFTZIrAV1wfPuKYoD0Cmtk//JNKB5I5SZGdi3I3qoVwKKNoDGPBZ14P9f9vFGxjCqEDA
         gJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=IMTgUdCDZrOAZx2RsikEH3uVgS+SSyiMRqGQynSPIw0=;
        b=GXvAEpQw60Wrun1HjF8lXCQHMX7uEVJEK58UMkNwCL279olIYU4qoeaEr0/Al44pBY
         Dma0zg9RA7RJHYL/n5PGwz1m0GnDLoQV5tVHtdKWPLPdEN0caOzELzgtdreM3EGdFXYJ
         OV4KZJClOEZUt/GDV6cXJMqH4gSmzGiEhWNKg+hKnUJt6fXEqbsueHs48slj/8Ww3VyY
         G/a38MSoaPpfie1Jb3mMHmWuFIH4q4aUa404qufHalfiV80+ymk6/puSBKrso1rCL6Cq
         EchVeAg6wqsvcM6GFTWRWrU+CKiiM75ixx4wRGB7k1KIFRL0IwWgl7orzN9OwrM00/mz
         xitg==
X-Gm-Message-State: AOAM531G2wnDfthECFJra+GVsYor4aTDFAumdgzd2uyvg6DIFGAFrjH2
        JtHoL9NZSH1lNWWCVnhiq0s=
X-Google-Smtp-Source: ABdhPJwJE/9VkOPjVUeJJ1zKyMiZgTiWAIZBhdg2rzQJzIWnfYeukovkDZU46W8iE82Kdg/Q+LyHLA==
X-Received: by 2002:a7b:cc90:: with SMTP id p16mr5809493wma.45.1613913463236;
        Sun, 21 Feb 2021 05:17:43 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id o10sm18294754wrx.5.2021.02.21.05.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 05:17:42 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sun, 21 Feb 2021 14:17:41 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Trent Piepho <tpiepho@gmail.com>, stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Please apply commit 517b693351a2 ("Bluetooth: btusb: Always
 fallback to alt 1 for WBS") to back to v5.10.y
Message-ID: <YDJddZykdgO5kShh@eldamar.lan>
References: <YDJWEh5qNUQbXcv2@eldamar.lan>
 <YDJXvYLSUQ3P0iMz@kroah.com>
 <CA+7tXij-wK3-tswGx2sQMR60wbThZPg_C3yuVXFVfbgSSi7ecw@mail.gmail.com>
 <YDJcMQnGWTIFG7k5@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDJcMQnGWTIFG7k5@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Sun, Feb 21, 2021 at 02:12:17PM +0100, Greg Kroah-Hartman wrote:
> On Sun, Feb 21, 2021 at 05:03:34AM -0800, Trent Piepho wrote:
> > On Sun, Feb 21, 2021 at 4:53 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > On Sun, Feb 21, 2021 at 01:46:10PM +0100, Salvatore Bonaccorso wrote:
> > > > Hi
> > > >
> > > > 517b693351a2 ("Bluetooth: btusb: Always fallback to alt 1 for WBS")
> > > > was applied to mainline fixing (restoring) behaviour to pre 5.7. As
> > > > the commit message describes in effect, WBS was broken for all USB-BT
> > > > adapters that do not support alt 6.
> > > >
> > > > Can you consider it to apply it to back to 5.10.y?
> > >
> > > I do not see any such git commit id in Linus's tree, are you sure you
> > > picked the right one?
> > 
> > Full hash is 517b693351a2d04f3af1fc0e506ac7e1346094de.
> > 
> > Looks like it should work as I intended on current 5.10.y, but I
> > didn't test that kernel.
> 
> Ah, this thing isn't even in 5.11, it just now showed up in Linus's
> tree.
> 
> Give it time to hit at least a released version (i.e. 5.12-rc1) before
> we pull it into a stable release.  Unless the bluetooth maintainers say
> it is ok to do so earlier than that.

Sure. We got a request in Debian to include the commit for an upcoming
5.10.y based update and just want to make sure we do not diverge here
from upstream.  But it's obviously good to wait then unless bluetooth
maintainers give the ack earlier.

Thanks for the quick responses.

Regards,
Salvatore
