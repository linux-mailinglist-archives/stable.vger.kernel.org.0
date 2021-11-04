Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEC644500C
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 09:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhKDIUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 04:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhKDIUx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 04:20:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E22A66109F;
        Thu,  4 Nov 2021 08:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636013895;
        bh=q2Veb9ZVM14tFWBhPqPjxLrp2e+zN3NVuqdIFRPv+r4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZGwlZaHqv1si/4qMJXTDa5Z63/NffZQXKc19atydSujv26pgBUqumQQq83EaZwn2A
         HB6/P34vCsVeugWzbzG+EVjaDMnNqMfo4LwzcXPRmhRtXesx6fLkrk54PPeRRbCcru
         T3btLdsTqY4vYnf1M8R26CitTXpXz8A0TKiXAksk=
Date:   Thu, 4 Nov 2021 09:18:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Erik Ekman <erik@kryo.se>
Cc:     stable@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] sfc: Fix reading non-legacy supported link modes
Message-ID: <YYOXRYUdTILeV09K@kroah.com>
References: <20211103111522.111148-1-erik@kryo.se>
 <20211103111522.111148-2-erik@kryo.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103111522.111148-2-erik@kryo.se>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 03, 2021 at 12:15:22PM +0100, Erik Ekman wrote:
> commit 041c61488236a5a84789083e3d9f0a51139b6edf upstream,
> with filename updated in backport to v5.4 and older.

Thank you, now queued up.

greg k-h
