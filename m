Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFD715CCD9
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 22:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgBMVCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 16:02:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:43088 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727761AbgBMVCc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 16:02:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 52140AD94;
        Thu, 13 Feb 2020 21:02:30 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 279D7DA703; Thu, 13 Feb 2020 22:02:16 +0100 (CET)
Date:   Thu, 13 Feb 2020 22:02:16 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 129/173] btrfs: flush write bio if we loop in
 extent_write_cache_pages
Message-ID: <20200213210216.GT2902@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
References: <20200213151931.677980430@linuxfoundation.org>
 <20200213152004.740147248@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213152004.740147248@linuxfoundation.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 07:20:32AM -0800, Greg Kroah-Hartman wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> [ Upstream commit 96bf313ecb33567af4cb53928b0c951254a02759 ]

Same comment as for the 4.9 backport, correct commit id is
42ffb0bf584ae5b6b38f7.
