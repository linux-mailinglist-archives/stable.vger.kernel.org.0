Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7D3721EC
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 00:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392262AbfGWWCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 18:02:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731354AbfGWWCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jul 2019 18:02:54 -0400
Received: from localhost (unknown [131.107.174.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40472218F0;
        Tue, 23 Jul 2019 22:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563919373;
        bh=aSgrCrjwzNnT0DbMSQRs16oON8qpLxN6kkiR0/9LU2Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1iQS/6FCyEigVK9Ixjd+4mlMlUJUyQpKzEtcskQds7qcPrlU7JUEwkzOE61LueF/m
         RzDnV7AW2Hq1QB//l+vx6LdaKS/8mg9AXb8jtPllK55JQKa2oZOTnIQWCKMClwCpax
         OHdFwpkzv62msVpyJNHGr6IVw0ktMTCPIqkJ/WO4=
Date:   Tue, 23 Jul 2019 18:02:52 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com, stable@vger.kernel.org,
        amir73il@gmail.com, hch@infradead.org, zlang@redhat.com
Subject: Re: [PATCH 0/9] xfs: stable fixes for v4.19.y - circa ~ v4.19.58
Message-ID: <20190723220252.GI1607@sasha-vm>
References: <20190718230617.7439-1-mcgrof@kernel.org>
 <20190719192311.GP30113@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190719192311.GP30113@42.do-not-panic.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 19, 2019 at 07:23:11PM +0000, Luis Chamberlain wrote:
>On Thu, Jul 18, 2019 at 11:06:08PM +0000, Luis Chamberlain wrote:
>> There is a stable bug tracking this, kz#204223 [1], and a respective bug
>> also present on upstream via kz#204049 [2] which Zorro reported. But,
>> again, nothing changes from the baseline.
>
>The crash is fixed by Brian's commit 6958d11f77d ("xfs: don't trip over
>uninitialized buffer on extent read of corrupted inode") merged on v5.1.
>
>As such I'll extend this series to include one more patch.

I've queued this series up, thanks!

--
Thanks,
Sasha
