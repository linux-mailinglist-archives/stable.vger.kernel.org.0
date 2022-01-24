Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45599497C3E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 10:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiAXJnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 04:43:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56008 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiAXJnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 04:43:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2656D6124D
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 09:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA73C340E1;
        Mon, 24 Jan 2022 09:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643017397;
        bh=cn+bFyFvwvVh6gZJl1UIXC+jzoxGz+REbKVe1pPw8N8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pp3faTUza7m7xV9fP7T1a8JWcp70ebHbndGc8XkhJJLbne5vOyak5mawY5xs2PIc8
         t1QzfY4lL2WFrtIhDcZyb6nOBN5Diu4ZRfekLU1ieg1Je//CcQtb00EMcVNnP4YvBR
         wwDHfWoUHIvSv4W7L+ZxuDOvFz9uRu2trN6/UCr8=
Date:   Mon, 24 Jan 2022 10:43:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <mario.limonciello@amd.com>
Cc:     stable@vger.kernel.org
Subject: Re: Backport ath11k fix to 5.15
Message-ID: <Ye50ssgEZ0l6kPWy@kroah.com>
References: <148cc640-9cab-02cb-2390-7930d19c0024@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148cc640-9cab-02cb-2390-7930d19c0024@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 21, 2022 at 02:00:20PM -0600, Limonciello, Mario wrote:
> Hi,
> 
> I've been noticing this on a number of Ryzen machines that a traceback comes
> up when allocating memory for ath11k.  It's not a fatal failure, as it
> retries with smaller slices but makes a lot of spew in the logs.
> 
> commit b9b5948cdd7bc8d9fa31c78cbbb04382c815587f ("ath11k: qmi: avoid error
> messages when dma allocation fails") fixes it, can you please bring it to
> 5.15.y?

Now queued up, thanks.

greg k-h
