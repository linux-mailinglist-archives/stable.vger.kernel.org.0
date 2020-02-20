Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87BD116569C
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 06:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgBTFNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 00:13:14 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45708 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725947AbgBTFNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 00:13:14 -0500
Received: from callcc.thunk.org (guestnat-104-133-8-109.corp.google.com [104.133.8.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 01K5D89J028725
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 00:13:09 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 22E2E4211EF; Thu, 20 Feb 2020 00:13:08 -0500 (EST)
Date:   Thu, 20 Feb 2020 00:13:08 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Suraj Jitindar Singh <surajjs@amazon.com>
Cc:     linux-ext4@vger.kernel.org, sblbir@amazon.com,
        sjitindarsingh@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] ext4: fix potential race between s_group_info online
 resizing and access
Message-ID: <20200220051308.GF476845@mit.edu>
References: <20200219030851.2678-1-surajjs@amazon.com>
 <20200219030851.2678-3-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219030851.2678-3-surajjs@amazon.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 07:08:50PM -0800, Suraj Jitindar Singh wrote:
> During an online resize an array of pointers to s_group_info gets replaced
> so it can get enlarged. If there is a concurrent access to the array in
> ext4_get_group_info() and this memory has been reused then this can lead to
> an invalid memory access.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206443
> Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
> Cc: stable@vger.kernel.org

Thanks, applied.

					- Ted
