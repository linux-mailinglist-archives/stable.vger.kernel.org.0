Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A68624EB08
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 05:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgHWDOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 23:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgHWDOD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Aug 2020 23:14:03 -0400
Received: from dragon (unknown [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C6692078A;
        Sun, 23 Aug 2020 03:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598152443;
        bh=khio95mCvaUHCF64s/7SvoTet5/u/I4ESYa2ByHtat0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oGkj7e1MMqPAdXSET9xrkQbxU9fkV+pxcMBsbOf7IMUkZyKMp4HJHyrHgRhoLnbaI
         7khka4yJeEd7wkOZliHFnzmKxG5VPrfklclNDcRh/nURatqF4qv9t4o3VkDg17+LvF
         INt7CvjtjMFJ5K5Y3zDpn5rkcO5OuKXLj6QP099s=
Date:   Sun, 23 Aug 2020 11:13:50 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Chris Healy <cphealy@gmail.com>
Cc:     srinivas.kandagatla@linaro.org, robh+dt@kernel.org,
        andrew.smirnov@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, s.hauer@pengutronix.de,
        kernel@pengutronix.de, stefan@agner.ch,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        festevam@gmail.com
Subject: Re: [PATCH v3 2/2] ARM: dts: vfxxx: Add syscon compatible with OCOTP
Message-ID: <20200823031341.GU30094@dragon>
References: <20200821212102.137991-1-cphealy@gmail.com>
 <20200821212102.137991-2-cphealy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821212102.137991-2-cphealy@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 02:21:02PM -0700, Chris Healy wrote:
> From: Chris Healy <cphealy@gmail.com>
> 
> Add syscon compatibility with Vybrid OCOTP node. This is required to
> access the UID.
> 
> Fixes: fa8d20c8dbb77 ("ARM: dts: vfxxx: Add node corresponding to OCOTP")
> Cc: stable@vger.kernel.org
> Reviewed-by: Fabio Estevam <festevam@gmail.com>
> Reviewed-by: Stefan Agner <stefan@agner.ch>
> Signed-off-by: Chris Healy <cphealy@gmail.com>

Applied, thanks.
