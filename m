Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 551DDAC639
	for <lists+stable@lfdr.de>; Sat,  7 Sep 2019 13:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388960AbfIGLJu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 7 Sep 2019 07:09:50 -0400
Received: from saturn.retrosnub.co.uk ([46.235.226.198]:44310 "EHLO
        saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfIGLJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Sep 2019 07:09:49 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        by saturn.retrosnub.co.uk (Postfix; Retrosnub mail submission) with ESMTPSA id BBC109E6A6F;
        Sat,  7 Sep 2019 12:09:47 +0100 (BST)
Date:   Sat, 7 Sep 2019 12:09:46 +0100
From:   Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Bakker <xc-racer2@live.ca>,
        =?UTF-8?B?UGF3ZcWC?= Chmiel <pawel.mikolaj.chmiel@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 066/167] iio: adc: exynos-adc: Add S5PV210
 variant
Message-ID: <20190907120946.34c03331@archlinux>
In-Reply-To: <20190903194654.GI5281@sasha-vm>
References: <20190903162519.7136-1-sashal@kernel.org>
        <20190903162519.7136-66-sashal@kernel.org>
        <20190903185328.74299c4d@archlinux>
        <20190903194654.GI5281@sasha-vm>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 3 Sep 2019 15:46:54 -0400
Sasha Levin <sashal@kernel.org> wrote:

> On Tue, Sep 03, 2019 at 06:53:28PM +0100, Jonathan Cameron wrote:
> >On Tue,  3 Sep 2019 12:23:38 -0400
> >Sasha Levin <sashal@kernel.org> wrote:
> >  
> >> From: Jonathan Bakker <xc-racer2@live.ca>
> >>
> >> [ Upstream commit 882bf52fdeab47dbe991cc0e564b0b51c571d0a3 ]
> >>
> >> S5PV210's ADC variant is almost the same as v1 except that it has 10
> >> channels and doesn't require the pmu register
> >>
> >> Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
> >> Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
> >> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> >> Signed-off-by: Sasha Levin <sashal@kernel.org>  
> >
> >I have no particular objection to adding new IDs (which is more
> >or less what this patch is), but I didn't know autosel was
> >picking them up.  So a bit of surprise... If intentional
> >then fine to apply to stable.  
> 
> I dragged it in because 103cda6a3b8d2 ("iio: adc: exynos-adc: Use proper
> number of channels for Exynos4x12") which is tagged for stable depended
> on this patch, and given it just adds new IDs which is part of what we
> take for stable I just took it in as is.
Ah fair enough!  Thanks for the explanation.

Jonathan

> 
> --
> Thanks,
> Sasha

