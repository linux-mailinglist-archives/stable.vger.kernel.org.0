Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D858A761B
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 23:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfICVWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 17:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbfICVWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 17:22:12 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E61D204EC;
        Tue,  3 Sep 2019 21:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567545731;
        bh=sPHmSwn/7iVG/HEKLHnBaYi7/WKQFU26yNb53p2Ne4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hEAJKG9rHHUs6RnP6Q11m6tR81aUruARXUeyr9HfvD2t4uKLAB09eqk2sgZQnXYGQ
         sEGGbUxHhIRYRW0tx/m0N9O53UwpMTwuLuC1GXCti5Wa/whpR/noDEE37oVj/u6atQ
         QqGaRWaeGSrMxvOO1lrEAMuIjI5CsQeAAUbnksII=
Date:   Tue, 3 Sep 2019 17:22:10 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     trond.myklebust@hammerspace.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] NFS: Ensure O_DIRECT reports an error if
 the bytes" failed to apply to 4.19-stable tree
Message-ID: <20190903212210.GR5281@sasha-vm>
References: <156753715823987@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <156753715823987@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 08:59:18PM +0200, gregkh@linuxfoundation.org wrote:
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

I've fixed it up and queued it for 4.19, 4.14, 4.9, and 4.4. I took
df3accb849607 ("NFS: Pass error information to the pgio error cleanup
routine") to make the backport cleaner.

--
Thanks,
Sasha
