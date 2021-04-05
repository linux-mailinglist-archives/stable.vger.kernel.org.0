Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751B63544E5
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbhDEQLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229832AbhDEQLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:11:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F61C613A0;
        Mon,  5 Apr 2021 16:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617639068;
        bh=0nxhWE6IAzpMJqaGVDCss/SA+OOiQa0lCJ58aPZldA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K+bqum1sUfOUSlwEk+awVoaZGLXUj7pX3/i/MItYtAHRVbItgqWTLbrQeCePmscYH
         YerfMBg483DSYAI9YPF6zRViWBagZuckRzZ64J6OLYEl+VZqxtKz4QYcm87RLEcoS8
         i64zVLz1wXdJlLJ76atDuKeGqm5aWYZmDxbsn/mI=
Date:   Mon, 5 Apr 2021 18:11:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 039/126] can: dev: move driver related
 infrastructure into separate subdir
Message-ID: <YGs2mTDl7n0j70Zx@kroah.com>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085032.339701089@linuxfoundation.org>
 <20210405153029.GB32232@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405153029.GB32232@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 05:30:29PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Marc Kleine-Budde <mkl@pengutronix.de>
> > 
> > [ Upstream commit 3e77f70e734584e0ad1038e459ed3fd2400f873a ]
> > 
> > This patch moves the CAN driver related infrastructure into a separate subdir.
> > It will be split into more files in the coming patches.
> 
> I don't think this is suitable for stable. I don't think any of the
> follow up patches depend on it...?

Yes it does.
