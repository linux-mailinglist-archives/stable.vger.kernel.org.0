Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B880162B90
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 18:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgBRRIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 12:08:13 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:32970 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726411AbgBRRIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 12:08:12 -0500
Received: from callcc.thunk.org (guestnat-104-133-8-109.corp.google.com [104.133.8.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 01IH82f3018375
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Feb 2020 12:08:03 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id A4ACC4211EF; Tue, 18 Feb 2020 12:08:01 -0500 (EST)
Date:   Tue, 18 Feb 2020 12:08:01 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, jack@suse.cz, scan-admin@coverity.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ext4: simplify checking quota limits in
 ext4_statfs()" failed to apply to 5.5-stable tree
Message-ID: <20200218170801.GD147128@mit.edu>
References: <1581966460247127@kroah.com>
 <20200218163434.GO1734@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218163434.GO1734@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> I'm not quite sure that this patch is stable material.

Yeah, that was a misfire on my part.  I think I had somehow convinced
myself that it was a prereq for another patch that was stable
material, but looking at it again, that's not the case.

	      	      	    	   	  - Ted
