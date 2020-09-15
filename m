Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3647726B08E
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 00:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgIOWNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 18:13:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727747AbgIOQi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 12:38:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98656206B6;
        Tue, 15 Sep 2020 16:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600187911;
        bh=lhrLVWfuKn2BXppu3oqyjQrDnTIcYKHbBOmuXDEUnZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MucNqneYIEnWPDKekHUhJ6utUM5R+mdliD7hXYbBOVmOenDgxPGzAcJHK4C8yXzlU
         RWPutBTl1B/TNQkqD1mxqE8/Sm82pfdPZI2f1GQtqVMylBHl7cUqJovA6QHlgvCq6m
         N8GSY6QVGj0pYB+S2bWyo1TMh5PnQTAbjDMH3HQo=
Date:   Tue, 15 Sep 2020 18:39:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jordan Crouse <jcrouse@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rob Clark <robdclark@chromium.org>
Subject: Re: [PATCH 5.4 105/132] drm/msm: Split the a5xx preemption record
Message-ID: <20200915163907.GA35563@kroah.com>
References: <20200915140644.037604909@linuxfoundation.org>
 <20200915140649.400517956@linuxfoundation.org>
 <20200915155439.GA22371@jcrouse1-lnx.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915155439.GA22371@jcrouse1-lnx.qualcomm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 09:54:39AM -0600, Jordan Crouse wrote:
> On Tue, Sep 15, 2020 at 04:13:27PM +0200, Greg Kroah-Hartman wrote:
> > From: Jordan Crouse <jcrouse@codeaurora.org>
> > 
> > commit 34221545d2069dc947131f42392fd4cebabe1b39 upstream.
> > 
> > The main a5xx preemption record can be marked as privileged to
> > protect it from user access but the counters storage needs to be
> > remain unprivileged. Split the buffers and mark the critical memory
> > as privileged.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
> > Signed-off-by: Rob Clark <robdclark@chromium.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Hi. The MSM_BO_MAP_PRIV feature was added after 5.4. 
> 
> Since we are pulling in 7b3f3948c8b7 ("drm/msm: Disable preemption on all
> 5xx targets)" preemption will be disabled in the 5.4 stable tree which is enough
> to cover the security concern that this patch helped address.
> 
> This patch can be dropped.

Now dropped,t hanks!

greg k-h
