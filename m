Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3160048D3BA
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 09:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbiAMIiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 03:38:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43946 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiAMIiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 03:38:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 740B4B82139
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 08:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7855CC36AE3;
        Thu, 13 Jan 2022 08:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642063080;
        bh=sVKWCMTB1Ghis6N+ire88o0C9qkC0+2kaQRY/gYl1JY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KI+aS55YTpgNqZpfGiJNkerNkussC7yQw36+OW54GOAuCVugPvHO8GQvRhQ2sX2Ef
         7a532ds6e0uPjisUirP8f8G9hD2bEGfoNlbhAznbRIPBN/hIP3JOtf/U+LXAwRsOCN
         AO2bxeSpdLok13maPB151kaecxqn6SWhqU+DKqvk=
Date:   Thu, 13 Jan 2022 09:37:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tejun Heo <tj@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: Workqueue -stable request
Message-ID: <Yd/k5TRniwRrynvM@kroah.com>
References: <Yd9Dt6DndAeodDUk@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd9Dt6DndAeodDUk@slm.duckdns.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022 at 11:10:15AM -1000, Tejun Heo wrote:
> Hello, Greg.
> 
> The following two patches that just pulled by Linus need to be backported to
> -stable but don't have stable tagged on them.
> 
>  v5.2+ : 07edfece8bcb ("workqueue: Fix unbind_workers() VS wq_worker_running() race")
>  v5.16+: 45c753f5f24d ("workqueue: Fix unbind_workers() VS wq_worker_sleeping() race")
> 
> Can you please include them in -stable backports?

Both now queued up, thanks!

greg k-h
