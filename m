Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26FF468AB3
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 13:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbhLEMN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 07:13:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56852 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbhLEMN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 07:13:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97CC7B80E1B
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 12:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE5FC341C1;
        Sun,  5 Dec 2021 12:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638706197;
        bh=er9CG0dl6kI/OQu0NRc07mM8HklpBzR67WCeLHEbLOY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qmX6K7hcw48wDfzmsVu421SA4/SKB+kgCezeR04dxKLPFVu9e6h46p4FQaKZd4YHx
         erEfaFPqO2ntHLN+HGx3okaKq3ELt5Us4HZvOVt/xOGaTrOwwp9NaAlhxlPOMOdTcS
         E7BiEcL8E9xoPsvZFrbYKpLi8cloP/D1P1fDT7E8=
Date:   Sun, 5 Dec 2021 13:09:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     stable@vger.kernel.org, linux-amlogic@lists.infradead.org,
        Artem Lapkin <art@khadas.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: [PATCH 5.10] Revert "drm: meson_drv add shutdown function"
Message-ID: <YaysEhJFqkQWa50W@kroah.com>
References: <20210315135545.132503808@linuxfoundation.org>
 <20211204213157.27551-1-jbrunet@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211204213157.27551-1-jbrunet@baylibre.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 04, 2021 at 10:31:57PM +0100, Jerome Brunet wrote:
> This reverts commit d66083c0d6f5125a4d982aa177dd71ab4cd3d212
> and commit d4ec1ffbdaa8939a208656e9c1440742c457ef16.

No, please, at most let us revert the commits individually.

> On v5.10 stable, reboot gets stuck on gxl and g12a chip family (at least).
> This was tested on the aml-s905x-cc from libretch and the u200 reference
> design.
> 
> Bisecting on the v5.10 stable branch lead to
> commit d4ec1ffbdaa8 ("drm: meson_drv add shutdown function").
> 
> Reverting it (and a fixes on the it) sloves the problem.
> 
> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
> ---
> 
> Hi Greg,
> 
> Things are fine on master but it breaks on v5.10-y.
> I did not check v5.14-y yet. I'll try next week.

Please check 5.15.y (5.14 is long end-of-life).

thanks,

greg k-h
