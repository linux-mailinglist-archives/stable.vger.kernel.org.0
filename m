Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A203C18F8F1
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 16:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgCWPtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 11:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727223AbgCWPtg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Mar 2020 11:49:36 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BD9820714;
        Mon, 23 Mar 2020 15:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584978575;
        bh=BSeEjxzok+RV27JwppENBSQhAIYBxT3WUBrxnvbJRD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CWGgrjIy9X0EJy4np1ZxTs9JSkyV1nF/+PZL8/EyfzdLkN/PM7TWbLEX1YyWjHCT3
         pPK7LUebQS+zAOsaIaysuuJ3cMI73iXAFxkXS4+ljVbWBk5GnQm5eKBgtHBmnp/3b0
         MGVPjsWwVK1AFN8HCwCZPWFTUBozXSt+XSMfmuNo=
Date:   Mon, 23 Mar 2020 11:49:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     anthony.mallet@laas.fr, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] USB: cdc-acm: fix close_delay and
 closing_wait units in" failed to apply to 4.14-stable tree
Message-ID: <20200323154934.GT4189@sasha-vm>
References: <15849665753924@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15849665753924@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 23, 2020 at 01:29:35PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 633e2b2ded739a34bd0fb1d8b5b871f7e489ea29 Mon Sep 17 00:00:00 2001
>From: Anthony Mallet <anthony.mallet@laas.fr>
>Date: Thu, 12 Mar 2020 14:31:00 +0100
>Subject: [PATCH] USB: cdc-acm: fix close_delay and closing_wait units in
> TIOCSSERIAL
>
>close_delay and closing_wait are specified in hundredth of a second but stored
>internally in jiffies. Use the jiffies_to_msecs() and msecs_to_jiffies()
>functions to convert from each other.
>
>Signed-off-by: Anthony Mallet <anthony.mallet@laas.fr>
>Cc: stable <stable@vger.kernel.org>
>Link: https://lore.kernel.org/r/20200312133101.7096-1-anthony.mallet@laas.fr
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Both this and b401f8c4f492 ("USB: cdc-acm: fix rounding error in
TIOCSSERIAL") depended on b401f8c4f492 ("USB: cdc-acm: fix rounding
error in TIOCSSERIAL").

I've fixed it to remove the dependency and queued both patches to
4.19-4.4.

-- 
Thanks,
Sasha
