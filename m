Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9E3351C6F
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 20:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbhDASRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 14:17:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237302AbhDASIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Apr 2021 14:08:00 -0400
Received: from jic23-huawei (cpc108967-cmbg20-2-0-cust86.5-4.cable.virginm.net [81.101.6.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6078A61210;
        Thu,  1 Apr 2021 13:21:36 +0000 (UTC)
Date:   Thu, 1 Apr 2021 14:21:45 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     Gwendal Grignou <gwendal@chromium.org>, andy.shevchenko@gmail.com,
        campello@chromium.org, lars@metafoo.de, linux-iio@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] iio: sx9310: Fix write_.._debounce()
Message-ID: <20210401142145.5f92fac6@jic23-huawei>
In-Reply-To: <161722015839.2260335.4267819779077188735@swboyd.mtv.corp.google.com>
References: <20210331182222.219533-1-gwendal@chromium.org>
        <161722015839.2260335.4267819779077188735@swboyd.mtv.corp.google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 31 Mar 2021 12:49:18 -0700
Stephen Boyd <swboyd@chromium.org> wrote:

> Quoting Gwendal Grignou (2021-03-31 11:22:22)
> > Check input to be sure it matches Semtech sx9310 specification and
> > can fit into debounce register.
> > Compare argument writen to thresh_.._period with read from same
> > sysfs attribute:
> > 
> > Before:                   Afer:
> > write   |  read           write   |  read
> > -1      |     8           -1 fails: -EINVAL
> > 0       |     8           0       |     0
> > 1       |     0           1       |     0
> > 2..15   |  2^log2(N)      2..15   |  2^log2(N)
> > 16      |     0           >= 16 fails: -EINVAL
> > 
> > Fixes: 1b6872015f0b ("iio: sx9310: Support setting debounce values")
> > Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> > Cc: stable@vger.kernel.org
> > ---  
> 
> Reviewed-by: Stephen Boyd <swboyd@chromium.org>

Applied to the fixes-togreg branch of iio.git.

Thanks,

Jonathan


