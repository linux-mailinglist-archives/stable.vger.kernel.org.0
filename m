Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0FEFF142F
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 11:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbfKFKoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 05:44:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfKFKoQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 05:44:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23D3920869;
        Wed,  6 Nov 2019 10:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573037054;
        bh=jG0JttOgmzlQCSx7+bOGT0umZwwN41UEPKfYQFE7IDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qs1lyDlxFOVZXq+UkW903qovOG/laBOg+I0zSVnMMqP9jfNZFbFedbrP8vWQXel4M
         JamqDdZYwDGZwdnNsAYVMMNiJFKR/2FFeBZiFSTd7Y0R04GaiBquD9O3hTEZ1JKCGg
         bGN6OsQ2c1OqL1yeUpTgO4CgAeAn8IWETcbLf+oU=
Date:   Wed, 6 Nov 2019 11:44:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pascal Bouwmann <bouwmann@tau-tec.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 059/149] iio: fix center temperature of
 bmc150-accel-core
Message-ID: <20191106104412.GA2982490@kroah.com>
References: <20191104212126.090054740@linuxfoundation.org>
 <20191104212140.681522108@linuxfoundation.org>
 <20191106094138.62qkvhfpyf5brits@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106094138.62qkvhfpyf5brits@ucw.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 06, 2019 at 10:41:38AM +0100, Pavel Machek wrote:
> > From: Pascal Bouwmann <bouwmann@tau-tec.de>
> > 
> > [ Upstream commit 6c59a962e081df6d8fe43325bbfabec57e0d4751 ]
> > 
> > The center temperature of the supported devices stored in the constant
> > BMC150_ACCEL_TEMP_CENTER_VAL is not 24 degrees but 23 degrees.
> > 
> > It seems that some datasheets were inconsistent on this value leading
> > to the error.  For most usecases will only make minor difference so
> > not queued for stable.
> > 
> > Signed-off-by: Pascal Bouwmann <bouwmann@tau-tec.de>
> > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Minor miscalibration, and author specifically states it should not be
> queued for stable. Yet, Sasha goes and queues it for stable. Why?

Because it really does fix an issue.

thanks,

greg k-h
