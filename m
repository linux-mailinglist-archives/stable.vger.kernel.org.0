Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239981B33F4
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 02:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgDVAZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 20:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgDVAZV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 20:25:21 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4216C206B9;
        Wed, 22 Apr 2020 00:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587515121;
        bh=zrU2hEmmyR/ZEGItBxmDCFcYN7opp3qoeiKxkvMgU4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DGktUyYTipN2pBSDWzOmNkZMSRspIfWVJVvFtI/EujHBtpwwlcmJ+QkAkzwUOLXT2
         9EdH5reI1Z6iP9Me6x+yifOLQfl1mUCeV/Nuo+kczt9+u26ZHXwp/8J82yxThRLtiZ
         3qIDJUUTKk95IL9rQcWdAt9oudkc2iFliFecSDYI=
Date:   Tue, 21 Apr 2020 20:25:20 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     frank.rowand@sony.com, erhard_f@mailbox.org, robh@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] of: unittest: kmemleak in
 of_unittest_platform_populate()" failed to apply to 4.14-stable tree
Message-ID: <20200422002520.GP1809@sasha-vm>
References: <1587488977126108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1587488977126108@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 07:09:37PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 216830d2413cc61be3f76bc02ffd905e47d2439e Mon Sep 17 00:00:00 2001
>From: Frank Rowand <frank.rowand@sony.com>
>Date: Thu, 16 Apr 2020 16:42:47 -0500
>Subject: [PATCH] of: unittest: kmemleak in of_unittest_platform_populate()
>
>kmemleak reports several memory leaks from devicetree unittest.
>This is the fix for problem 2 of 5.
>
>of_unittest_platform_populate() left an elevated reference count for
>grandchild nodes (which are platform devices).  Fix the platform
>device reference counts so that the memory will be freed.
>
>Fixes: fb2caa50fbac ("of/selftest: add testcase for nodes with same name and address")
>Reported-by: Erhard F. <erhard_f@mailbox.org>
>Signed-off-by: Frank Rowand <frank.rowand@sony.com>
>Signed-off-by: Rob Herring <robh@kernel.org>

Conflict with a613b26a5013 ("of: Convert to using %pOFn instead of
device_node.name"). Fixed and queued for 4.14-4.4.

-- 
Thanks,
Sasha
