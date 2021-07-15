Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13ECF3CA458
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 19:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhGORao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 13:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhGORao (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 13:30:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FC83613D8;
        Thu, 15 Jul 2021 17:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626370071;
        bh=R/wbqKDj6dP85+o15sGDZqVlYXdKpyzGlSiQj2Yp3qQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o00kPKLs682vazYEW+edBKRrHZoS6KUbJFL6EBAqtYFo6EOhpN4SbkoPvswie/Xer
         ylFqr1yLX8mSZ0xh+jizO7d+w9LFU8PFsZ1DWAh1dppLrt5EAxoI782ki5XDpu5VkT
         aqc5xRrP92EpOEhNj6QyJSdoBhscqFZWGf393scQ=
Date:   Thu, 15 Jul 2021 19:27:48 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Lin, Wayne" <Wayne.Lin@amd.com>
Cc:     "lyude@redhat.com" <lyude@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] drm/dp_mst: Avoid to mess up payload
 table by ports in stale" failed to apply to 5.13-stable tree
Message-ID: <YPBwFGmNN2zLb3cf@kroah.com>
References: <1626351420140215@kroah.com>
 <CO6PR12MB548978A31FF543E2333447FFFC129@CO6PR12MB5489.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR12MB548978A31FF543E2333447FFFC129@CO6PR12MB5489.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 03:07:19PM +0000, Lin, Wayne wrote:
> [AMD Official Use Only]
> 
> Hi Greg,
> 
> Really thanks for your time. About failing to apply below patches to stable tree:
> 3769e4c0af5b82c8ea21d037013cb9564dfaa51f
> [PATCH] drm/dp_mst: Avoid to mess up payload table by ports in stale topology
> 
> 35d3e8cb35e75450f87f87e3d314e2d418b6954b
>  [PATCH] drm/dp_mst: Do not set proposed vcpi directly
> 
> There was an immediate following patch to correct the issue caused by above patches:
> 24ff3dc18b99c4b912ab1746e803ddb3be5ced4c
> [PATCH] drm/dp_mst: Add missing drm parameters to recently added call to drm_dbg_kms()
> 
> In other words, these three patches should be committed at the same time. Sorry for any inconvenience it brought.
> Please advise me if there is anything else to do for having these patches applied to stable tree.
> Really thanks for your help.

These commits do not apply to the current stable trees, so please submit
backports of them for how ever far back you wish to see them, so that we
can apply them.

thanks,

greg k-h
