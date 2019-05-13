Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D19F81B723
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 15:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbfEMNhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 09:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730234AbfEMNhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 09:37:38 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75A0321019;
        Mon, 13 May 2019 13:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557754657;
        bh=d9zV5NxRO983geJRFbQCgZJPUiqH8fIlmgOX6IEtKC0=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=aijBOMDb7JZM0E98uhcqkFlvetuou4pSY2/WVrWlKyh9Nc1z8C+0xkBzksEUJbbr3
         omZUaLiNRbOAh7xIx5dY6UPD1Kxhlq8morYgLA0U1CGzQl2Sd2yHQDE07Iwm3/C2s3
         nurBc0LKZ3RmLMWZuxNZed45/CG3N9EgkemTn7HE=
Date:   Mon, 13 May 2019 09:37:36 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     dsterba@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.0 92/99] btrfs: Switch memory allocations in
 async csum calculation path to kvmalloc
Message-ID: <20190513133736.GC11972@sasha-vm>
References: <20190507053235.29900-1-sashal@kernel.org>
 <20190507053235.29900-92-sashal@kernel.org>
 <20190507074919.GM20156@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190507074919.GM20156@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 09:49:19AM +0200, David Sterba wrote:
>On Tue, May 07, 2019 at 01:32:26AM -0400, Sasha Levin wrote:
>> From: Nikolay Borisov <nborisov@suse.com>
>>
>> [ Upstream commit a3d46aea46f99d134b4e0726e4826b824c3e5980 ]
>>
>> Recent multi-page biovec rework allowed creation of bios that can span
>> large regions - up to 128 megabytes in the case of btrfs.
>
>Not necessary for 5.0/4.x as it depends on 5.1 changes.

Dropped it, thank you!

--
Thanks,
Sasha
