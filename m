Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1002162C73
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 18:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgBRRRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 12:17:50 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:36014 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726411AbgBRRRu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 12:17:50 -0500
Received: from callcc.thunk.org (guestnat-104-133-8-109.corp.google.com [104.133.8.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 01IHHRxW022115
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Feb 2020 12:17:28 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id B38B14211EF; Tue, 18 Feb 2020 12:17:26 -0500 (EST)
Date:   Tue, 18 Feb 2020 12:17:26 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Sasha Levin <sashal@kernel.org>
Cc:     "zhangyi (F)" <yi.zhang@huawei.com>, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, jack@suse.cz
Subject: Re: [PATCH 5.4 1/2] jbd2: move the clearing of b_modified flag to
 the journal_unmap_buffer()
Message-ID: <20200218171726.GA152025@mit.edu>
References: <20200218105953.10684-1-yi.zhang@huawei.com>
 <20200218162752.GN1734@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218162752.GN1734@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 11:27:52AM -0500, Sasha Levin wrote:
> On Tue, Feb 18, 2020 at 06:59:52PM +0800, zhangyi (F) wrote:
> > [ Upstream commit 6a66a7ded12baa6ebbb2e3e82f8cb91382814839 ]
> > 
> > There is no need to delay the clearing of b_modified flag to the
> > transaction committing time when unmapping the journalled buffer, so
> > just move it to the journal_unmap_buffer().
> > 
> > Link: https://lore.kernel.org/r/20200213063821.30455-2-yi.zhang@huawei.com
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Cc: stable@kernel.org
> 
> I've queued all backports to their respective branches, thank you!

Many thanks to Yi Zhang for providing the backports!!

     	       	  	    	      - Ted
