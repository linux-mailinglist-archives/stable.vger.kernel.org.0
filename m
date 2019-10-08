Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 651C4CFD6C
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbfJHPSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfJHPSB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 11:18:01 -0400
Received: from localhost (unknown [89.205.136.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A90B206C0;
        Tue,  8 Oct 2019 15:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570547881;
        bh=pu15L9RwUEae6WQjWmvYaOl1fDYuNLf8hrqu5nJEfk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nbDY0sw3u8LA9uVR+RmMolTPUQLU5DB8aI9i9TF3dGYpFQhqnUeT/54uJWyK/mNqO
         kz0nOuGyL9sDpstiPmnATSUxHBffFQVE5OjbVpMSBT2TJ04F1YSwPhkJ/cmwU9DkgB
         tW+/Za3J9e5uxhxKvWPyqfl23hR+7nPyjbnBzU0Q=
Date:   Tue, 8 Oct 2019 17:17:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Charlene Liu <charlene.liu@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 033/106] drm/amd/display: support spdif
Message-ID: <20191008151757.GB2872679@kroah.com>
References: <20191006171124.641144086@linuxfoundation.org>
 <20191006171140.114447492@linuxfoundation.org>
 <20191008133741.GG608@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008133741.GG608@amd>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 03:37:41PM +0200, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit b5a41620bb88efb9fb31a4fa5e652e3d5bead7d4 ]
> > 
> > [Description]
> > port spdif fix to staging:
> >  spdif hardwired to afmt inst 1.
> >  spdif func pointer
> >  spdif resource allocation (reserve last audio endpoint for spdif only)
> 
> I'm sorry, but I don't understand this changelog. Code below modifies
> whitespace, adds a debug output, and uses local variable for
> pool->audio_count.
> 
> Does not seem to be a bugfix, and does not seem to do anything with
> staging.

That's what the original changelog had in it, so I kept it.

thanks,

greg k-h
