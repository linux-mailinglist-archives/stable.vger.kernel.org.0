Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FE32EC178
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 17:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbhAFQvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 11:51:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:55282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727531AbhAFQvZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 11:51:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33EE12312F;
        Wed,  6 Jan 2021 16:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609951844;
        bh=Ms+9owRVzyKNnDg6RlMycvQP5wwQcnf3LmQxmWgIffU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j0XH5W+B82v3QcNXCkWcrkQ4GPCuslvK2NYoAZYkbF0ZUb0LW/6RQ/Phtf9OC6n7C
         9RmdgncSLWVw+rq/H45vQEg+N0j/tUgwwdDqfONW/DDgYXPl5xmdEspGrcuvQmq5DF
         /JosNuBWAHKMm1hn6Hjg6OeaIPWFLJjAiR/7q+eI=
Date:   Wed, 6 Jan 2021 17:52:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: RTC pcf2127 fix for 5.10-stable
Message-ID: <X/XqttuxoWnetEu0@kroah.com>
References: <92f8f995-cd97-e978-c8d5-2093cd1fe16a@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <92f8f995-cd97-e978-c8d5-2093cd1fe16a@prevas.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 12:00:15PM +0100, Rasmus Villemoes wrote:
> Hi Greg
> 
> Please consider adding
> 
> commit 71ac13457d9d1007effde65b54818106b2c2b525
> Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Date:   Fri Dec 18 11:10:54 2020 +0100
> 
>     rtc: pcf2127: only use watchdog when explicitly available
> 
> to the 5.10 stable queue. You will need the preparatory refactoring patch
> 
> commit 5d78533a0c53af9659227c803df944ba27cd56e0
> Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Date:   Thu Sep 24 12:52:55 2020 +0200
> 
>     rtc: pcf2127: move watchdog initialisation to a separate function
> 
> And if documentation is supposed to be kept up-to-date in the -stable
> trees, you can pick
> 
> commit 320d159e2d63a97a40f24cd6dfda5a57eec65b91
> Author: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> Date:   Fri Dec 18 11:10:53 2020 +0100
> 
>     dt-bindings: rtc: add reset-source property

Looks good, will go apply these, thanks.

greg k-h
