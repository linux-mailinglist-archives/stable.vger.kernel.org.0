Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D3D491F39
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 07:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239955AbiARGB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 01:01:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50838 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiARGB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 01:01:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53EBDB811CE
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 06:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753F0C00446;
        Tue, 18 Jan 2022 06:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642485714;
        bh=n3R19W5jAixM3gm1/NBWT2klvDXcTnYxSi9WShr3GHY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XLDQs8Y6qT3DDkCMEzbGzeh8/zxstuOPxkHz4IT4pZ61SDJAOIBDdEfnQ91upjRbO
         qZvGPQbrrGq3oLbbXwAdzVI53UwlM8nCNijErR9qmkNVlcjpYYp47cBVOT8325C4PF
         4KMGrV5zt2382b9WWc16mKJQ2ZEkIn8A2HITqzoU=
Date:   Tue, 18 Jan 2022 07:01:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: Re: UBSAN error on is_dsc_supported
Message-ID: <YeZXz9mkZ0lBFhi3@kroah.com>
References: <BL1PR12MB515740E9B2213800E5C16958E2579@BL1PR12MB5157.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB515740E9B2213800E5C16958E2579@BL1PR12MB5157.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 17, 2022 at 10:43:34PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi stable,
> 
> Can you please pull in commit 63ad5371cd1e379519395c49a4b6a652c36c98e5 ("drm/amd/display: explicitly set is_dsc_supported to false before use") to 5.15.y?
> 
> This fixes address sanitizer errors on hotplug found by the Canonical team.

Also added to 5.16.y as you do not want someone upgrading and having a
regression.

thanks,

greg k-h
