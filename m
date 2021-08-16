Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6C93ED355
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 13:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbhHPLsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 07:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236527AbhHPLsf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 07:48:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B6D26323B;
        Mon, 16 Aug 2021 11:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629114483;
        bh=BFuXUwi4bufxe+dI9nTVuNvI+ZBzPwerblvIBFHJWAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LxUnNMoYNIzvEApQZ9EmKxL23THOKJk/AHqh06ddvvW5EublGNT41g34G/dNrTkEe
         7B+aAMywnpD34wMdupE3TnbZ51RnnRfWYperjHGzkClLC1EFZuzcjB1pGO2CmovZ6Z
         DEbliOruyLP17TG0cpTkvBHFzggwjArlUNd/SSTQ=
Date:   Mon, 16 Aug 2021 13:48:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Camille Lu <camille.lu@hpe.com>
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix agaw for a supported 48 bit guest
 address width
Message-ID: <YRpQcOQzOVnGn0Lg@kroah.com>
References: <20210816113932.1210581-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816113932.1210581-1-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 07:39:32PM +0800, Lu Baolu wrote:
> From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> 
> [ Upstream commit 327d5b2fee91c404a3956c324193892cf2cc9528 ]

Also, this really does not look like this commit at all :(
