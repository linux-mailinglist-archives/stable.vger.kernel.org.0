Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37DA1DC6B3
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 07:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgEUFuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 01:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbgEUFuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 01:50:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F138E2070A;
        Thu, 21 May 2020 05:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590040213;
        bh=ypc2u5gf6zwFtUf9eyihsWkph9t3l4yCmCnoIeDHiAM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qTPKJh6PV/6wBlDcv1K7vXY/ZYrKFrU7MS6Gdw+fZcy6sYGScFcR6pHJ9QqKT9fwq
         /e+X1D+wjhwJUdQvtowa6i4nS3tmDK98be8VEU4CwVzvN79pfIO4rlPYgcaq74cK8/
         arIrxeQPbycHBYxI5k/ix1CXAw368bxZcSJPc6T8=
Date:   Thu, 21 May 2020 07:50:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable] i2c: dev: Fix the race between the release of i2c_dev
 and cdev
Message-ID: <20200521055011.GA2330588@kroah.com>
References: <0fa517f4672e45bbb11aeb57cfb2740b60f1f998.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fa517f4672e45bbb11aeb57cfb2740b60f1f998.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 20, 2020 at 08:45:15PM +0100, Ben Hutchings wrote:
> Please pick this fix for all stable branches:
> 
> commit 1413ef638abae4ab5621901cf4d8ef08a4a48ba6
> Author: Kevin Hao <haokexin@gmail.com>
> Date:   Fri Oct 11 23:00:14 2019 +0800
> 
>     i2c: dev: Fix the race between the release of i2c_dev and cdev
> 
> I don't know whether it will apply cleanly to all of them; I can deal
> with those where it doesn't.

I applied it to 4.14, 4.19, 5.4, and 5.6.  It does apply to 4.9 but as
the patch it depends on is not there, I don't think it will help.

thanks,

greg k-h
