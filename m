Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 653BA100392
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 12:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfKRLLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 06:11:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:34842 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726460AbfKRLLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 06:11:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 388F9B2DF;
        Mon, 18 Nov 2019 11:11:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F1412DA823; Mon, 18 Nov 2019 12:11:43 +0100 (CET)
Date:   Mon, 18 Nov 2019 12:11:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Liu Bo <bo.liu@linux.alibaba.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 028/237] Btrfs: fix alignment in declaration
 and prototype of btrfs_get_extent
Message-ID: <20191118111143.GE3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Liu Bo <bo.liu@linux.alibaba.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20191116154113.7417-1-sashal@kernel.org>
 <20191116154113.7417-28-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116154113.7417-28-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 16, 2019 at 10:37:43AM -0500, Sasha Levin wrote:
> From: Liu Bo <bo.liu@linux.alibaba.com>
> 
> [ Upstream commit de2c6615dcddf2af868c5cbd1db2e9e73b4beb58 ]
> 
> This fixes btrfs_get_extent to be consistent with our existing
> declaration style.

The patch is pure white space fix with no effects. I don't see that it
would be needed for a followup patch. What was the reason to add it to
autosel/stable ?
