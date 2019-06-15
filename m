Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF35D4726B
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 00:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfFOWiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 18:38:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbfFOWiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Jun 2019 18:38:12 -0400
Received: from localhost (unknown [107.242.116.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28A6C2073F;
        Sat, 15 Jun 2019 22:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560638291;
        bh=+PcXKoEYSFcpmWR4eCRY2o0tn67VO6ioCzBdZ1aNSsY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZHCtFO/fIn9Is9ew0H5lSCF9lAhXTGJcnVHpus6ZQUwe5sJ/VYyXPzBDkAPSOTFcL
         4vKJ6bLsi8qCzLwwqN2iO/4PPzZhSq5aPNIygK+e/qS/DVLTW9lGBnb1RCTEcKB8Ao
         Q3ACp0LxVbxsIgHSMtCEtEEApt+8gQ95yhTbqpII=
Date:   Sat, 15 Jun 2019 18:38:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Lyude Paul <lyude@redhat.com>
Cc:     Juston Li <juston.li@intel.com>, Lyude <cpaul@redhat.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        clinton.a.taylor@intel.com, stable@vger.kernel.org
Subject: Re: [RESEND PATCH v2 1/2] drm/dp/mst: Reprobe EDID for MST ports on
 resume
Message-ID: <20190615223809.GS1513@sasha-vm>
References: <20181024021925.27026-2-juston.li@intel.com>
 <20190614215644.8F9D821874@mail.kernel.org>
 <90274aca8c1b785caf9e3732e8b56e501e573a1f.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <90274aca8c1b785caf9e3732e8b56e501e573a1f.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 14, 2019 at 06:10:20PM -0400, Lyude Paul wrote:
>uh, Sasha not sure if you're a bot or not but this patch isn't even upstream

This is indeed a bot, and that's indeed it's purpose :)

We tend to get less responses if we wait for weeks for a patch to get
upstream and queued for -stable because most often folks have moved on
and forgotten all about it.

This bot looks for commits tagged for stable, and runs basic sanity
checks on them while they're still being discussed on the mailing list.
This way we get more responses with instructions on how to deal with the
patch.

Either way, it won't be actually queued for stable before it's upstream.

--
Thanks,
Sasha
