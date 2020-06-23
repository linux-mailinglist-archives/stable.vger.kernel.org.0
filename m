Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38460205C01
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 21:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733305AbgFWTly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 15:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733236AbgFWTly (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 15:41:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B89020C09;
        Tue, 23 Jun 2020 19:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592941313;
        bh=TJ903FSnLZ8Jzw8mefzwMWYnFi1IvgoR3T01OyaRGNk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QjB+LkLk6SDdD7AQZs3mpztGNkCYQ/iuolJsotycbmtdGmwaafoViDkx65aqq457o
         /xOmdQOmXc3Z50AIUXEMSttzTZolufyQUZF2Au21dTyui3TOLMY//WLyn8OqSq0nXX
         /7YEUGpDT8Y1YZWUzw78wdLDaxPrwHR+EdODcpzk=
Date:   Tue, 23 Jun 2020 21:41:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sushma Kalakota <sushmax.kalakota@intel.com>
Cc:     stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH] iommu/vt-d: Remove real DMA lookup in find_domain
Message-ID: <20200623194152.GA350873@kroah.com>
References: <20200623192733.2560-1-sushmax.kalakota@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623192733.2560-1-sushmax.kalakota@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 01:27:33PM -0600, Sushma Kalakota wrote:
> From: Jon Derrick <jonathan.derrick@intel.com>
> 
> commit 	bba9cc2cf82840bd3c9b3f4f7edac2dc8329ci241 upstream

That commit id is not in Linus's tree :(

