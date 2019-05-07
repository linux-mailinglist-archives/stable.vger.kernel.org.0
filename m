Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8849E15E8A
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 09:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfEGHsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 03:48:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:59188 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726563AbfEGHsV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 03:48:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 22A59AEA9;
        Tue,  7 May 2019 07:48:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9BBD8DB17A; Tue,  7 May 2019 09:49:19 +0200 (CEST)
Date:   Tue, 7 May 2019 09:49:19 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.0 92/99] btrfs: Switch memory allocations in
 async csum calculation path to kvmalloc
Message-ID: <20190507074919.GM20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20190507053235.29900-1-sashal@kernel.org>
 <20190507053235.29900-92-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507053235.29900-92-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 01:32:26AM -0400, Sasha Levin wrote:
> From: Nikolay Borisov <nborisov@suse.com>
> 
> [ Upstream commit a3d46aea46f99d134b4e0726e4826b824c3e5980 ]
> 
> Recent multi-page biovec rework allowed creation of bios that can span
> large regions - up to 128 megabytes in the case of btrfs.

Not necessary for 5.0/4.x as it depends on 5.1 changes.
