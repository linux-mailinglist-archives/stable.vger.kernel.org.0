Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E514201E0
	for <lists+stable@lfdr.de>; Sun,  3 Oct 2021 16:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhJCOIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 10:08:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230207AbhJCOIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Oct 2021 10:08:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DF2561A0C;
        Sun,  3 Oct 2021 14:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633269991;
        bh=l+6HkwsA4CjIN5ttkX0yJhEhzZKmS5Wdw2ODYs1rE2g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eRfRko93/07q/mytTHt/GOfe/3XOmT1qDoTBBiZkQuJ/HDjzaivLSFOkGlJJCPrBC
         eD0YXCawEfAKApyO3nrr6OExBqGsNfLQdOhNxu8P9vmWX+qtfnzyqkYznQTmYwzr2N
         c8by20CuTYaW5BKYHNqbEgslZhkGElqfm6w5L1zQ=
Date:   Sun, 3 Oct 2021 16:06:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     stable@vger.kernel.org,
        =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>,
        Tobias Gurtzick <magic@wizardtales.com>
Subject: Re: [PATCH] platform/x86/intel: hid: Add DMI switches allow list
Message-ID: <YVm45IRcJ3eM387f@kroah.com>
References: <20211001100932.7907-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211001100932.7907-1-hdegoede@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 01, 2021 at 12:09:32PM +0200, Hans de Goede wrote:
> From: José Expósito <jose.exposito89@gmail.com>
> 
> commit b201cb0ebe87b209e252d85668e517ac1929e250 upstream.
> 
> Some devices, even non convertible ones, can send incorrect
> SW_TABLET_MODE reports.
> 
> Add an allow list and accept such reports only from devices in it.
> 
> Bug reported for Dell XPS 17 9710 on:
> https://gitlab.freedesktop.org/libinput/libinput/-/issues/662
> 
> Fixes: ac32bae00083 ("platform/x86: intel-hid: Add alternative method to enable switches")
> Depends-on: 153cca9caa81 ("platform/x86: Add and use a dual_accel_detect() helper")
> Reported-by: Tobias Gurtzick <magic@wizardtales.com>
> Suggested-by: Hans de Goede <hdegoede@redhat.com>
> Tested-by: Tobias Gurtzick <magic@wizardtales.com>
> Signed-off-by: José Expósito <jose.exposito89@gmail.com>
> Link: https://lore.kernel.org/r/20210920160312.9787-1-jose.exposito89@gmail.com
> [hdegoede@redhat.com: Check dmi_switches_auto_add_allow_list only once]
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/platform/x86/intel-hid.c | 27 ++++++++++++++++++++++-----
>  1 file changed, 22 insertions(+), 5 deletions(-)

Now queued up, thanks.

greg k-h
