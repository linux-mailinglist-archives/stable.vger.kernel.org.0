Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8517039264D
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 06:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhE0E1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 00:27:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229844AbhE0E1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 00:27:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5DD2613E3;
        Thu, 27 May 2021 04:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622089530;
        bh=v8ZYgGZ08/ZapsFQPeNpDi1vKu6GpRXVw/25VMbmXco=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xo4sLiq5D50+LrjTdap5Y2GQ/nV+KPfm3xnwpxd6SexIBt229MXxDMR6NrKjP3BKU
         oYbA7tN1ykBFWokX9KpnufhmM+cruDLuOSwYDz1lpX+y6xw1B/UTXp0SX/e+DvE5+Z
         sp8NA0n9WdF/zeHTX1WikSdFo+UzVi0d8v4NwnEQ=
Date:   Thu, 27 May 2021 06:25:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wolfgang =?iso-8859-1?Q?M=FCller?= <wolf@oriole.systems>,
        Ashok Raj <ashok.raj@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 261/289] Revert "iommu/vt-d: Remove WO permissions
 on second-level paging entries"
Message-ID: <YK8fOJik3rGJwQ2f@kroah.com>
References: <20210517140305.140529752@linuxfoundation.org>
 <20210517140313.931565813@linuxfoundation.org>
 <20210526212247.GA4463@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526212247.GA4463@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 26, 2021 at 11:22:47PM +0200, Pavel Machek wrote:
> On Mon 2021-05-17 16:03:06, Greg Kroah-Hartman wrote:
> > This reverts commit c848416cc05afc1589edba04fe00b85c2f797ee3 which is
> > eea53c5816889ee8b64544fa2e9311a81184ff9c upstream.
> 
> Please don't do this.

I've always done it this way, this is not new for reverts in the stable
trees.

thanks,

greg k-h
