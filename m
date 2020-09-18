Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2621A26F74E
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 09:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgIRHrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 03:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbgIRHrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 03:47:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CEF5208DB;
        Fri, 18 Sep 2020 07:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600415264;
        bh=EnUmhxP0aZvFk+6R7U9X2ixh8KrkrgjAZ8NQYuY+aQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aOgx0efzJnHi23PvEiRhJWCeN9T8qCizfaGoA2GM79Z8wefFiSTLJA0sTEzJ9+TM1
         wNnGVT9Ehq7hqtxt0leqf0t4EduvJnWYM1A8aQQXNWIWUGiSaqJ+ilneTdbfJwbPt4
         ZNc0VxmMQL6WWBIgR/u/e8s6c+toIVt/m4H5p2iA=
Date:   Fri, 18 Sep 2020 09:48:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Quan, Evan" <Evan.Quan@amd.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH AUTOSEL 5.4 265/330] drm/amd/powerplay: try to do a
 graceful shutdown on SW CTF
Message-ID: <20200918074815.GB979569@kroah.com>
References: <20200918020110.2063155-1-sashal@kernel.org>
 <20200918020110.2063155-265-sashal@kernel.org>
 <DM6PR12MB26190E9DD4C2DF9CEEFAD8EFE43F0@DM6PR12MB2619.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB26190E9DD4C2DF9CEEFAD8EFE43F0@DM6PR12MB2619.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 18, 2020 at 07:17:10AM +0000, Quan, Evan wrote:
> [AMD Official Use Only - Internal Distribution Only]

That didn't work :)
