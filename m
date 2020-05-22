Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5761DE575
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 13:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgEVLeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 07:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728871AbgEVLeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 07:34:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55E50206F6;
        Fri, 22 May 2020 11:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590147245;
        bh=+zFfJ51+67yTEbzNzUzHl+j9Z/wx3mQVNM6YmEbVlzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0tIPSx+0XmzxfG4JbzCmWJcMorteu3lYMbvRnzqVYwvkFJb36I0J49M8zdTEme2e+
         ZE/O6q8G/n/NkJ93VUr7gRT/ystIWeqGI4sxgiWu0myqUNM2RXlLFBgXRfxoTCd7rA
         KcqcqNWT0N6rSJfMsDzV/6Q/k8vzQvbaA2uOVRrM=
Date:   Fri, 22 May 2020 13:34:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable] i2c: dev: Fix the race between the release of i2c_dev
 and cdev
Message-ID: <20200522113403.GA1397522@kroah.com>
References: <0fa517f4672e45bbb11aeb57cfb2740b60f1f998.camel@codethink.co.uk>
 <20200521055011.GA2330588@kroah.com>
 <1d4004d71924fa2e4c422ae086166c280e5b43be.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d4004d71924fa2e4c422ae086166c280e5b43be.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 21, 2020 at 09:58:57PM +0100, Ben Hutchings wrote:
> On Thu, 2020-05-21 at 07:50 +0200, Greg Kroah-Hartman wrote:
> > On Wed, May 20, 2020 at 08:45:15PM +0100, Ben Hutchings wrote:
> > > Please pick this fix for all stable branches:
> > > 
> > > commit 1413ef638abae4ab5621901cf4d8ef08a4a48ba6
> > > Author: Kevin Hao <haokexin@gmail.com>
> > > Date:   Fri Oct 11 23:00:14 2019 +0800
> > > 
> > >     i2c: dev: Fix the race between the release of i2c_dev and cdev
> > > 
> > > I don't know whether it will apply cleanly to all of them; I can deal
> > > with those where it doesn't.
> > 
> > I applied it to 4.14, 4.19, 5.4, and 5.6.  It does apply to 4.9 but as
> > the patch it depends on is not there, I don't think it will help.
> 
> It was included in 4.9.224, so both this and the similar watchdog fix
> should be applicable for 4.9.

My fault, I hadn't updated my scripts, all is good here, sorry for the
noise.

greg k-h
