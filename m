Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273252022A4
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 10:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgFTIir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 04:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:32886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbgFTIiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Jun 2020 04:38:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C523C23A40;
        Sat, 20 Jun 2020 08:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592642326;
        bh=uAL3Li0aoX8mopwU1KNm2yhtKEEfjY3M64OrTH/ZUdc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WwRS0cbJ2jtu2cr/BvK3uOjMSSYu0yEaDN9fjKzW5CEXaGWkRouIAHVXEqjoudrBM
         3LTjuWQa9lfjsZIL100ZhkL7PcjfYkpQewaWfi0yX0GwdUkfhjnj221o2imRdscAHM
         jq5sSWGS9q1OPN1hQQUqiWSdArZBPiTY5sf6qSyg=
Date:   Sat, 20 Jun 2020 10:38:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/376] 5.7.5-rc1 review
Message-ID: <20200620083842.GA2509562@kroah.com>
References: <20200619141710.350494719@linuxfoundation.org>
 <1b6c9c26-04af-eb91-ef06-23d09bd31d91@applied-asynchrony.com>
 <1797f3d4-d3b6-00ac-30fc-a10f584acae9@applied-asynchrony.com>
 <20200620072236.GB66401@kroah.com>
 <44a85676-c69d-3dd1-80c6-82cc7b0a6c60@applied-asynchrony.com>
 <c54fe354-4059-071c-7660-8975542f2a52@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c54fe354-4059-071c-7660-8975542f2a52@applied-asynchrony.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 20, 2020 at 10:29:48AM +0200, Holger Hoffstätte wrote:
> On 2020-06-20 09:43, Holger Hoffstätte wrote:
> > On 2020-06-20 09:22, Greg Kroah-Hartman wrote:
> > > On Sat, Jun 20, 2020 at 03:18:30AM +0200, Holger Hoffstätte wrote:
> > > > On 2020-06-19 21:31, Holger Hoffstätte wrote:
> > > > > On 2020-06-19 16:28, Greg Kroah-Hartman wrote:
> > > > > > This is the start of the stable review cycle for the 5.7.5 release.
> > > > > > There are 376 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > 
> > > > > Applied to 5.7.4 and running fine on two different systems (server, desktop)
> > > > > without problems.
> > > > 
> > > > Uh-oh: I have to take the above back. This release no longer suspends to RAM;
> > > > display and NIC shut down (box is no longer remotely accessible) but the power
> > > > stays on and I have to power-cycle.
> > > > Will try to revert a bunch of things tomorrow..
> > > 
> > > Is this a new problem?  Or is it a regression?
> > 
> > 5.7.(0,1,2,3,4) all suspended & woke up without problem, every night.
> > Just a moment ago I also got a GPU lockup out of the blue, probably caused by
> > something else (looks like mm/THP/memory mapping/userfault related)
> 
> OK, nevermind - my bad, just noticed that I had a bunch of custom patches in
> that tree that should not have been in there for testing (yet).
> Extra-virgin 5.7.4 + 5.7.5-rc1 on top works & suspends/resumes fine, and so far
> no new GPU lockups either.

Wonderful, thanks for testing and letting me know it is good :)

greg k-h
