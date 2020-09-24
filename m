Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73FD277C44
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 01:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIXXQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 19:16:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgIXXQE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 19:16:04 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53AAF2371F;
        Thu, 24 Sep 2020 23:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600989364;
        bh=4I8hRldPPH+j33yA2+zofOz9yfdtyJFUG/fwFdxhr/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h2W4RRinKheuwe3RsAEfR0AKpxkUL6XfhXZIxf13DpYxX7+HsRgHor/jtl5dQclsw
         u2YnupX5kYRqFEqblKL4aWRoP1Ts76YW57HJ817E5mZnUUXZ8+GPB2Va7Qkf4E9GNH
         LnYczC6NIgI0YAA6/bUUs5f5J+1eVbLn55G0M2h8=
Date:   Thu, 24 Sep 2020 19:16:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     gregkh@linuxfoundation.org, zhouchengming@bytedance.com,
        songmuchun@bytedance.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ftrace: Setup correct FTRACE_FL_REGS
 flags for module" failed to apply to 4.4-stable tree
Message-ID: <20200924231603.GT2431@sasha-vm>
References: <159784015193138@kroah.com>
 <20200923185613.6901e246@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200923185613.6901e246@oasis.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 23, 2020 at 06:56:13PM -0400, Steven Rostedt wrote:
>On Wed, 19 Aug 2020 14:29:11 +0200
><gregkh@linuxfoundation.org> wrote:
>
>> The patch below does not apply to the 4.4-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>
>
>This should be the fix for 4.4.

Queued up, thanks!

-- 
Thanks,
Sasha
