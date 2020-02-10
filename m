Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20BF0156DE1
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 04:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgBJD02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 22:26:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:58316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbgBJD02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 22:26:28 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 347D32082E;
        Mon, 10 Feb 2020 03:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581305187;
        bh=gcEKGVako4A3c54+3OPsLz8VmNdLTDAR0h+U7BzlV0I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YREBgfWQaSbymJb2ppaxiJuKnTX4woSzmuRHRqpcFAcXYbEu9woCjUyjxJFH9bog2
         lGB5yguzZXVMj/CwgN1kx5DIbJC4sl/9eJeUN3rP3RiBj7pX9mcV6zsn6zCrQxN2En
         wSUisHrw9ByTGcVHDY62RlhQ3sQbYQGAH5ktSeLs=
Date:   Sun, 9 Feb 2020 22:26:26 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.4.19-rc1-db47074.cki (stable)
Message-ID: <20200210032626.GA13097@sasha-vm>
References: <cki.8EB2969432.TNQD7SAORH@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cki.8EB2969432.TNQD7SAORH@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 12:24:46AM -0000, CKI Project wrote:
>
>Hello,
>
>We ran automated tests on a recent commit from this kernel tree:
>
>       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>            Commit: db4707481a60 - Linux 5.4.19-rc1
>
>The results of these automated tests are provided below.
>
>    Overall result: FAILED (see details below)
>             Merge: OK
>           Compile: FAILED

I've fixed this one up, thanks!

-- 
Thanks,
Sasha
