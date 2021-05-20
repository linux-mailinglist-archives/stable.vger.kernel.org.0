Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2224238A041
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 10:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhETIyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 04:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbhETIyS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 04:54:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EAD961244;
        Thu, 20 May 2021 08:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621500776;
        bh=iF2TvhOWD2CxEh8NgpwDPS5sMxjEUuEEaOSyHWKvEsU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QClYvQKspkKqfEuU1GyUk95T3Ar612LWkZsXb/9C9IftV9L+3uaXklvxT9HkSY/0F
         htpsvIERmc4sPT7qbHAUN9nX98L/vsnPA7zHzMoHjdREPt2tmyesuA2VQlUv6Iiu+1
         TAsCX799A2PzKWEshgvKjLrG+LI3PIrtCHdDQVtg=
Date:   Thu, 20 May 2021 10:52:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Joerg M. Sigle" <joerg.sigle@jsigle.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] iommu/vt-d: Fix kernel panic caused by 416fa531c816:
 Preset Access/Dirty bits for IOVA over FL
Message-ID: <YKYjZivpfGivHqps@kroah.com>
References: <095f9639-2708-48bf-bf56-57ab0866dcee@jsigle.com>
 <7827b043-7abe-de56-2a46-19d689f34120@jsigle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7827b043-7abe-de56-2a46-19d689f34120@jsigle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 09:47:40AM +0200, Joerg M. Sigle wrote:
> Dear colleaguse
> 
> I've submitted a patch for 5.10.37 that wasn't included in 5.10.38,
> which would have corrected a patch that has been reverted instead.
> 
> More info:
> https://bugzilla.kernel.org/show_bug.cgi?id=213077
> 
> Now sending to the other kernel list, according to autoresponse
> from Greg Kroah-Hartman.
> 
> Thanks for any feedback & Kind regards, Joerg Sigle

Are you sure that 5.10.38 doesn't already fix this issue?  We resolved
an issue in this area.

And where is the patch, I can't find it in this email, can you submit it
"properly" so that it can be reviewed?

thanks,

greg k-h
