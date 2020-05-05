Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19161C618C
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 22:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgEEUD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 16:03:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbgEEUD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 16:03:58 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8C4320721;
        Tue,  5 May 2020 20:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588709038;
        bh=pipuDpvfZfNEKvyznB3sFn0XZCEjfP3aGCbir969T00=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WwvCor+TCXaNSHxEPhW+wZHOhGU+Y7VyxOCqaP0HoQ9AXGK9gf7EYBTVp1Gl5vtMQ
         x7VV35YV/frw6TCrsjt61fsKtY6z2VpbO1pB5ElqAzjpZ+LanP65zXKuuqZD6BHnZv
         uHTI3xf5cyzxpht7jsg74g2DGZ3VFLqSGeSUBCis=
Date:   Tue, 5 May 2020 13:03:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Roman Penyaev <rpenyaev@suse.de>
Cc:     Jason Baron <jbaron@akamai.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] epoll: call final ep_events_available() check under
 the lock
Message-Id: <20200505130357.04566dee5501c3787105376f@linux-foundation.org>
In-Reply-To: <a9898eaefa85fa9c85e179ff162d5e8d@suse.de>
References: <20200505084049.1779243-1-rpenyaev@suse.de>
        <a9898eaefa85fa9c85e179ff162d5e8d@suse.de>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 May 2020 10:42:05 +0200 Roman Penyaev <rpenyaev@suse.de> wrote:

> May I ask you to remove "epoll: ensure ep_poll() doesn't miss wakeup
> events" from your -mm queue? Jason lately found out that the patch
> does not fully solve the problem and this one patch is a second
> attempt to do things correctly in a different way (namely to do
> the final check under the lock). Previous changes are not needed.

Where do we stand with Khazhismel's "eventpoll: fix missing wakeup for
ovflist in ep_poll_callback"?

http://lkml.kernel.org/r/20200424190039.192373-1-khazhy@google.com


