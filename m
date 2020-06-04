Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9A11EE13C
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 11:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgFDJ0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 05:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbgFDJ0q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jun 2020 05:26:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6838020738;
        Thu,  4 Jun 2020 09:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591262805;
        bh=Mhvx/pNWkQhcHDjB3kNOYdY60ICJ5NtFHjVSD4GR/J4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sc6jaWo2VC544JaNq3BckUeCcPfTDQYupiH3Wd4RUzgs0EAKDJV6XB5jHZIJI1sf2
         R4Vv4TAPGpGG2tuDAPt2k9lVE2OMsmgTjVdxriEKdDpYbf/9VAfEiLpxl+xKVpQSwg
         4ekFJHQ/h7blOymopi5NOocsezJa0xUnURC4S/Ho=
Date:   Thu, 4 Jun 2020 11:26:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sean Young <sean@mess.org>
Cc:     stable@vger.kernel.org, Brad Love <brad@nextdimension.cc>,
        linux-media@vger.kernel.org, hverkuil-cisco@xs4all.nl,
        mchehab@kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/1] dvbdev: Fix tuner->demod media controller link
Message-ID: <20200604092642.GA365392@kroah.com>
References: <20200514164043.8756-1-3126054018@nextdimension.cc>
 <20200514164043.8756-2-3126054018@nextdimension.cc>
 <20200604090016.GA20902@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604090016.GA20902@gofer.mess.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 04, 2020 at 10:00:16AM +0100, Sean Young wrote:
> On Thu, May 14, 2020 at 11:40:43AM -0500, Brad Love wrote:
> > Fixes bug exposed by:
> > 
> > [a3fbc2e6bb0: media: mc-entity.c: use WARN_ON, validate link pads]
> 
> This patch was merged for v5.8, but should have been merged for v5.7
> as well. Please can it be merged into v5.7 stable. The upstream
> commit is 9f984cacf4f4d53fd8a3f44d7f13528b81c1f6a8.

Now queued up, thanks.

greg k-h
