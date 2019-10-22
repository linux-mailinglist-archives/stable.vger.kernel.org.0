Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D38E3E0345
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 13:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388743AbfJVLov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 07:44:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388689AbfJVLov (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Oct 2019 07:44:51 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 959C2207FC;
        Tue, 22 Oct 2019 11:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571744690;
        bh=Ocg4gJYWLSPlASVvZP7w0Vv9HGn/kHUlwwAOpQ+M/f8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gldl0GnsRIXEOXTVg+jzHW4p18xos0sPbFW+BB6V0+InEsyR3taFRAWSfaK5RbAFn
         t36QzeLk2slsDrKYrEH39DQ21zRB4ywbSHsws0EyBbY0yC+UCL8ps8BPbuGC6tDhnO
         dlQ3c99cEl2xxhdwMPm+G2dw9y0d0/kbUJIF5aEQ=
Date:   Tue, 22 Oct 2019 12:44:46 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Jean-Baptiste Maneyrol <JManeyrol@invensense.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] iio: imu: inv_mpu6050: fix no data on MPU6050
Message-ID: <20191022124446.217b1697@archlinux>
In-Reply-To: <20191017181128.GX31224@sasha-vm>
References: <20191016144253.24554-1-jmaneyrol@invensense.com>
        <20191017143142.489CF21848@mail.kernel.org>
        <MN2PR12MB3373BC1DE5152A4546940EB3C46D0@MN2PR12MB3373.namprd12.prod.outlook.com>
        <20191017181128.GX31224@sasha-vm>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Oct 2019 14:11:28 -0400
Sasha Levin <sashal@kernel.org> wrote:

> On Thu, Oct 17, 2019 at 02:43:55PM +0000, Jean-Baptiste Maneyrol wrote:
> >Hello Sacha,
> >
> >I can do a specific patch for backporting to kernel 4.19 and older ones if needed.
> >This is really simple.
> >
> >Tell me if this is OK for you and how to proceed.  
> 
> If you do end up doing a backport, just send it either as a reply to
> this mail, or add a "4.19" tag and send it over to
> stable@vger.kernel.org.
> 

I've applied this to the fixes-togreg branch of iio.git.  Hopefully
will a pull request out to Greg sometime in the next few days and
from him it'll work it's way into Linus' tree.

Thanks,

Jonathan
