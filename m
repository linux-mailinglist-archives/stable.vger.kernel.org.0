Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9324F217508
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 19:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgGGRUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 13:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727777AbgGGRUx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 13:20:53 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE29D20708;
        Tue,  7 Jul 2020 17:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594142453;
        bh=fWfzI/E8aZYdoiDIRVzG3U75i8mWZ55mV1BZcXWWxko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IR0mqr7f4DCEuZwCgxVGESyC4gkIJNOJrmE6iYNqQGmuYAr7hzBq1VrCcjUW0LqVL
         adSen5yqHOcO3GHOV2UmEirobhHqLxCWI30RPIqF2HCUGQitdIp6+g3yEpsrNg8PkB
         UyReP05y4HHhG5nVMJfqHICxEU4HR2yXnDk6UgvA=
Date:   Tue, 7 Jul 2020 13:20:51 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "J. Bruce Fields" <bfields@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 35/65] nfsd: clients dont need to break their own
 delegations
Message-ID: <20200707172051.GT2722994@sasha-vm>
References: <20200707145752.417212219@linuxfoundation.org>
 <20200707145754.171869800@linuxfoundation.org>
 <20200707153122.GA171624@pick.fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200707153122.GA171624@pick.fieldses.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 07, 2020 at 11:31:22AM -0400, J. Bruce Fields wrote:
>NACK.
>
>(How did this one even end up headed for stable?  It wasn't cc'd to

It came in when I was looking at the later nfs patches in this series
and figured it is a fix on its own.

>stable, it's not a bugfix, and it's not a small patch.)

If its not a bugfix, why did it go in -rc4 rather than waiting for the
merge window?

-- 
Thanks,
Sasha
