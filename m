Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AC0262DED
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 13:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbgIILfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 07:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729622AbgIILfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 07:35:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4F7C21D7B;
        Wed,  9 Sep 2020 11:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599650682;
        bh=LsZZCgcD9CKkSW0yTqr5sXk2HVFb9a1pnywslo7fZww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vIur60NMEckDbV+dW9IzqmRMhQRqdG47fgB2CmYQCO4frCQmILdcuxdpwkGsZk3Ut
         MS6De6rBF8MOvEMUxl1qnrdy7RKi7swqmuyJ5RTtCLEHXtSahUJ0SgRlkwtzGg3CC3
         aA8hRwkCVNcsZHlg/uAXJpPt5P+opjQ5xPXgy5RI=
Date:   Wed, 9 Sep 2020 13:24:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.8 101/186] drm/radeon: Prefer lower feedback dividers
Message-ID: <20200909112452.GA621541@kroah.com>
References: <20200908152241.646390211@linuxfoundation.org>
 <20200908152246.531365310@linuxfoundation.org>
 <77ec0338-32a1-6379-858c-359f636a0e58@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <77ec0338-32a1-6379-858c-359f636a0e58@amd.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 09, 2020 at 01:15:13PM +0200, Christian König wrote:
> Hi Greg,
> 
> please drop that patch. It turned out to break a lot of different setups and
> we are going to revert it now.

Ok, now dropped from all trees, thanks.

greg k-h
