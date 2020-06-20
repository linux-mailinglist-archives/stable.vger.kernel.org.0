Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022A720224F
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 09:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgFTHWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 03:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726517AbgFTHWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Jun 2020 03:22:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1534F2339E;
        Sat, 20 Jun 2020 07:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592637759;
        bh=4RuUfIULy+jMej/c/NGOZ0IlwWn9hbyY9ATVsw5sV0o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lr5xJjmkpj56iF7KOoyPPbIJ5OrtLgS42M0qQbH5y3X8AwtyMrWg5lhiNnsr5JBpz
         kdCfQ1UjgJLd+tJCOgI+k/Dqd1b1kGaImZKS9tBWoqYTTHQZQtV/4tKFpe8CNEAqps
         XNKI2cnBz2XrxW2Wn5u3ozPojGrKziQp0aiz7Ilc=
Date:   Sat, 20 Jun 2020 09:22:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/376] 5.7.5-rc1 review
Message-ID: <20200620072236.GB66401@kroah.com>
References: <20200619141710.350494719@linuxfoundation.org>
 <1b6c9c26-04af-eb91-ef06-23d09bd31d91@applied-asynchrony.com>
 <1797f3d4-d3b6-00ac-30fc-a10f584acae9@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1797f3d4-d3b6-00ac-30fc-a10f584acae9@applied-asynchrony.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 20, 2020 at 03:18:30AM +0200, Holger Hoffstätte wrote:
> On 2020-06-19 21:31, Holger Hoffstätte wrote:
> > On 2020-06-19 16:28, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.7.5 release.
> > > There are 376 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > Applied to 5.7.4 and running fine on two different systems (server, desktop)
> > without problems.
> 
> Uh-oh: I have to take the above back. This release no longer suspends to RAM;
> display and NIC shut down (box is no longer remotely accessible) but the power
> stays on and I have to power-cycle.
> Will try to revert a bunch of things tomorrow..

Is this a new problem?  Or is it a regression?

thanks,

greg k-h
