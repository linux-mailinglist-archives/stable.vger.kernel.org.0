Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5039F3B6A12
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237775AbhF1VUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236035AbhF1VUJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 17:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDCFB61CB4;
        Mon, 28 Jun 2021 21:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915063;
        bh=9NDGyOwI1yazPLZWtPlWbzTdqeaOpj4lspR/RC2jvXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ARbiSMhsHD6cwcpISvBx6zf0aKibeFL15qgHePaCpsuFdhM01uv9/OTXnnh0k05gs
         FxLJyj88UMK8jSzZ9ZdEmkEnr0TAXLpoFY7MQoT67M2NYf7f25sfK0/3Kes17TVxAa
         m3r6CqCXON8fcdMfRLYHWFujPU1myid2PK8XXW+6EDM2Gy6gzsONalE/OPrIS8whdl
         AdSvf8laYSj4AIOUi18xhUM1yQHRlWBtYLl2tNOLxLe3zGCPvX2Cv1osh1wyBcnlQ5
         Z58jhDeJo4z0xxYvtevFUy4teteyV2Go6y4Q182Nv0HoGs0n01+HMD84oeSP9YkR66
         VD9veY2Woznzg==
Date:   Mon, 28 Jun 2021 17:17:42 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Chrisanthus, Anitha" <anitha.chrisanthus@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH 5.12 019/110] drm/kmb: Fix error return code in
 kmb_hw_init()
Message-ID: <YNo8dsX+st3fH/9E@sashalap>
References: <20210628141828.31757-1-sashal@kernel.org>
 <20210628141828.31757-20-sashal@kernel.org>
 <BY5PR11MB418269C8584FC8AAD088CA9C8C039@BY5PR11MB4182.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <BY5PR11MB418269C8584FC8AAD088CA9C8C039@BY5PR11MB4182.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 04:29:37PM +0000, Chrisanthus, Anitha wrote:
>This patch is already pushed to drm-misc-fixes. Please check for existing patches in the dri-devel mail list before sending patches.

Indeed, it's even upstream at this point.

This mail is a review for the stable trees rather than Linus's tree.

-- 
Thanks,
Sasha
