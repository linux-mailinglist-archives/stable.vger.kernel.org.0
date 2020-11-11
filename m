Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DC42AF47B
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 16:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgKKPNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 10:13:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:35334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbgKKPNA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Nov 2020 10:13:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FF622053B;
        Wed, 11 Nov 2020 15:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605107580;
        bh=32P7q1J/tsIbN+ljcBb6Envu059AGiIIb39ZRQjwdgc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qkGiTpVp1Ruh1iAOGEwV0u2nwYjmVUHXYFVprj3TzE50Dd8C4ihqiQRIRqQo70FvA
         WQL60k+l+UbtPyKBzV6Y6+2ao242gRcwlKDSPfZGPUaADZU+a2+23OZKQl3DVvKSqz
         6frhOOQZKrrXIgj95o80j1mRLutuh0aQRDD+FUYg=
Date:   Wed, 11 Nov 2020 16:14:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Hesse <list@eworm.de>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: Linux 5.9.8
Message-ID: <X6v/uMppWit4j+2Z@kroah.com>
References: <1605041246232108@kroah.com>
 <20201111153604.6a4fb08c@leda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111153604.6a4fb08c@leda>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 11, 2020 at 03:36:04PM +0100, Christian Hesse wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> on Tue, 2020/11/10 21:56:
> > I'm announcing the release of the 5.9.8 kernel.
> 
> This is not yet linked on kernel.org - same goes for lts version 5.4.77.
> I guess this is not by intention, no?

kernel.org is "stuck" on some syncing tasks right now, it should be
"unstuck" "soon".  Hopefully.  The admins know about it.

thanks,

greg k-h
