Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D172CB27
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 18:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfE1QJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 12:09:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:56756 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726492AbfE1QJa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 12:09:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2F7E5AF7C;
        Tue, 28 May 2019 16:09:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 00278DA85E; Tue, 28 May 2019 18:10:23 +0200 (CEST)
Date:   Tue, 28 May 2019 18:10:23 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs: honor path->skip_locking in backref code
Message-ID: <20190528161023.GR15290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>
References: <20190528101552.14798-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528101552.14798-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 28, 2019 at 06:15:52PM +0800, Qu Wenruo wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> CC: stable@vger.kernel.org # 4.14

This applies to 4.14 stable tree.
