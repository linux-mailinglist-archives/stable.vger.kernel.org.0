Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680862E7761
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 10:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgL3JYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 04:24:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgL3JYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 04:24:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1779420791;
        Wed, 30 Dec 2020 09:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609320202;
        bh=0Lpz6nZMQosCawNiSPbGgwcmMbHnRImfGs6H04zLW/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C34NWMBFH5WcJtyymmCQBq1Q2DGC/MApfxlZpKwM28aPwvvu3usHJocqUzyU5gBok
         npIC0En2SJOLklk2XX5WHhKp90YxDjjWVrZr/8EnA1utsXvVu+s3EbgC8ae8l5GQjn
         T7iAJC06+OwacV75IMHE2UOP5ye9VmaxcEnhvx/c=
Date:   Wed, 30 Dec 2020 10:24:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Subject: Re: [PATCH 5.10 635/717] drm/amd/display: Honor the offset for plane
 0.
Message-ID: <X+xHWBzD/L9Z7w97@kroah.com>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125051.345050198@linuxfoundation.org>
 <CAP+8YyF+SeTpMDc_c4tFpBmmabwFJLymW7CByZwoYZD8UXGVVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP+8YyF+SeTpMDc_c4tFpBmmabwFJLymW7CByZwoYZD8UXGVVQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 29, 2020 at 08:42:50PM +0100, Bas Nieuwenhuizen wrote:
> Hi Greg,
> 
> Someone bisected a non-booting computer with 5.10.4-rc1 to this
> commit. Would it be possible to back out of backporting this commit
> (was backported to 5.4 and 5.10)? I suspect we may need
> 53f4cb8b5580a20d01449a7d8e1cbfdaed9ff6b6 to be picked too to avoid
> regressing, but I'm not sure about process (e.g. timeline to confirm
> things) here and a not booting computer is really bad.

Thanks for the report, now dropped from both queues.  If this needs to
be added, after testing, please let stable@vger.kernel.org know and we
will be glad to add it back.

thanks,

greg k-h
