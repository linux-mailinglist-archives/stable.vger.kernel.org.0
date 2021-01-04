Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092AD2E933C
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 11:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbhADKYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 05:24:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbhADKYS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 05:24:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE30F207B3;
        Mon,  4 Jan 2021 10:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609755818;
        bh=UeKFz1Yw+xdc6YczXAcXXU4WEPgybdfnUa/qXuWDLeo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y3+bPWqvfMmzyZgqB9/JB96rgNk4MATWtFJZF9Dt8T4R+up/JyQKYDkLw+blz+SBg
         miYYTIMs7xJwdgGahR5t4tsT+ztesXOZh9jSjllxi/+6QW2L3EKFORYf284GdT8vEE
         1Gi3UqYmthmhiwKKzGrt0IEQBKnuNmQS89LjyhlM=
Date:   Mon, 4 Jan 2021 11:25:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jinoh Kang <jinoh.kang.kr@gmail.com>
Cc:     Souptick Joarder <jrdr.linux@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        John Hubbard <jhubbard@nvidia.com>, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 bp] xen/gntdev.c: Mark pages as dirty
Message-ID: <X/LtAFKYjkxLFijk@kroah.com>
References: <160413862539217@kroah.com>
 <d4310d1f-8add-4074-ea4c-1c6b8276e79f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4310d1f-8add-4074-ea4c-1c6b8276e79f@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 01, 2021 at 05:25:50PM +0000, Jinoh Kang wrote:
> From: Souptick Joarder <jrdr.linux@gmail.com>
> 
> commit 779055842da5b2e508f3ccf9a8153cb1f704f566 upstream.

Thanks for the backport, now queued up.

greg k-h
