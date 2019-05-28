Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7858E2CB2A
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 18:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfE1QJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 12:09:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:56814 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726492AbfE1QJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 12:09:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 49304AF3B;
        Tue, 28 May 2019 16:09:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 34687DA85E; Tue, 28 May 2019 18:10:40 +0200 (CEST)
Date:   Tue, 28 May 2019 18:10:40 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs: honor path->skip_locking in backref code
Message-ID: <20190528161040.GS15290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>
References: <20190528101835.20377-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528101835.20377-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 28, 2019 at 06:18:35PM +0800, Qu Wenruo wrote:
> CC: stable@vger.kernel.org # 4.19

This is for 4.19 stable tree.
