Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E82562C8
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 08:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfFZG4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 02:56:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:37992 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726006AbfFZG4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 02:56:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E0330AC83;
        Wed, 26 Jun 2019 06:56:08 +0000 (UTC)
Date:   Wed, 26 Jun 2019 08:56:06 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH AUTOSEL 5.1 09/51] iommu/vt-d: Fix lock inversion between
 iommu->lock and device_domain_lock
Message-ID: <20190626065606.GT8151@suse.de>
References: <20190626034117.23247-1-sashal@kernel.org>
 <20190626034117.23247-9-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626034117.23247-9-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Tue, Jun 25, 2019 at 11:40:25PM -0400, Sasha Levin wrote:
> From: Dave Jiang <dave.jiang@intel.com>
> 
> [ Upstream commit 7560cc3ca7d9d11555f80c830544e463fcdb28b8 ]

This commit was reverted upstream, please drop it from your stable
queue. It caused new lockdep issues.

Regards,

	Joerg
