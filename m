Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E812E469611
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 13:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243318AbhLFNAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 08:00:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33150 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243274AbhLFNAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 08:00:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6644261268
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 12:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453FCC341C2;
        Mon,  6 Dec 2021 12:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638795407;
        bh=L/GeO4tUTunT/zC1292S0Y0Kioi/UUZfO3cZ7czRS2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bERk7AioDaZZST+4CuXHkxUxfRPQgo129/UJdUzIi/sFw7uQQCOLpHAFjH6EXsaNv
         4T9XZ2tBbOjsEgVCmPT0Re3b1iRoqEb7IXFRdCV3A5lN3VFh9JdAbFPYiEOQ/PCY4y
         YyOLGkGSSB0qgShNaNCaekd6DqJd10ZrNmJHP1iM=
Date:   Mon, 6 Dec 2021 13:56:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Helge Deller <deller@gmx.de>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] parisc stable patch: parisc: Mark cr16 CPU clocksource
 unstable on all SMP machines
Message-ID: <Ya4IjKQAOiiRMlOf@kroah.com>
References: <Ya36JqHtMQv/H2Z4@ls3530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya36JqHtMQv/H2Z4@ls3530>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 12:55:18PM +0100, Helge Deller wrote:
> Hello stable team,
> 
> can you please apply this patch to stable kernels from v4.14 up to v5.14 (both including).
> 
> It's a backport of upstream commit:
>   commit afdb4a5b1d340e4afffc65daa21cc71890d7d589
>   parisc: Mark cr16 CPU clocksource unstable on all SMP machines
> 
> The upstream commit doesn't apply cleanly to those kernels, so this
> patch has been adjusted so that it now applies.

Now queued up, thanks.

greg k-h
