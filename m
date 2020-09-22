Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DD8274656
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 18:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgIVQQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 12:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgIVQQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 12:16:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CF812086A;
        Tue, 22 Sep 2020 16:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600791384;
        bh=kUiP+Te7+8GbRT4VNadGzvGtpaieV11wYO/BLoN8hU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xj4RoAAuZJv0dn0Lp4/982lv9vKRkkjZb7TB7YMy9tSxQN2BcHSvW83jpTIPHzBOT
         cIi3uXQBvXhg0cs7ZsIxhKzzRIWeyueRhOk4rMTfSdvOr8ZOl8FgGwS8lHTDn1+1pJ
         ZgdpLt0C/BgMcIxmyV8fiQfs4g6eJVf4fnzEcoH4=
Date:   Tue, 22 Sep 2020 18:16:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 4.19 43/49] Input: trackpoint - add new trackpoint
 variant IDs
Message-ID: <20200922161642.GA2283857@kroah.com>
References: <20200921162034.660953761@linuxfoundation.org>
 <20200921162036.567357303@linuxfoundation.org>
 <20200922153957.GB18907@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922153957.GB18907@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 05:39:57PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Vincent Huang <vincent.huang@tw.synaptics.com>
> > 
> > commit 6c77545af100a72bf5e28142b510ba042a17648d upstream.
> > 
> > Add trackpoint variant IDs to allow supported control on Synaptics
> > trackpoints.
> 
> This just adds unused definitions. I don't think it is needed in
> stable.

It add support for a new device.
