Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513113CD534
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237103AbhGSMPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 08:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231282AbhGSMPO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 08:15:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3ABB6100C;
        Mon, 19 Jul 2021 12:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626699354;
        bh=cODhtD7HnTm8K6ftWjH22qa5zEBf3/9OCYf9kjDqako=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c1qgODvLdy2G46o/2XsUi5ieAidUvzmJ4j5IzD86oFP1ZuKUc9F4ZyrHmQXNDc3yt
         zcWjbXB1Fcot0CtKpFUfvyLU3ZzQL5pYoWvPLXvKDsorM0khtIX/UQKZCoKiDCatsd
         eNJ2T0yP2rOo5iuDvqAq0X9oTi9Pi7sqk8X8n6TY=
Date:   Mon, 19 Jul 2021 14:55:51 +0200
From:   gregkh <gregkh@linuxfoundation.org>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: [PATCH 0/2] drm/ingenic: backports for v5.10.x
Message-ID: <YPV2V/oyViM36voW@kroah.com>
References: <1626352148199179@kroah.com>
 <20210717174446.14455-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210717174446.14455-1-paul@crapouillou.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 17, 2021 at 06:44:44PM +0100, Paul Cercueil wrote:
> Hi Greg,
> 
> Here are two patches for the ingenic-drm driver that couldn't be applied
> to the stable v5.10.x automatically. I backported them manually so that
> they can be applied there.

All now queued up, thanks.

greg k-h
