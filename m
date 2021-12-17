Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7BF479596
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 21:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240539AbhLQUmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 15:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhLQUmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 15:42:24 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C16C061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 12:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=T2EucjKALtwn3jqiQSniu+GFTgjCNI6/fhfCSUcRWNE=;
        t=1639773744; x=1640983344; b=cLl5nFl02v/I9JpOF3sZQhGRYEuSHZrvvUwiFvzuhkCROjj
        lHx6eDnvu2mNEZadp2V+iDhQfcmQh3VPUsv5WhwetVB+A9sha6DOyjwnAS9E6ke+ICeeIxjxvFzqM
        9Hxox31SvW5Mws+YCd/uORHWauontxfzJ+Vu3WnB2nGRns3U5i9wlAURlMaFNVJLBFuvV+K6HyYNm
        zsKBdB5xThj5BIAHGv8jZazH5LUdrbPVSQyHIRG/hPfz3xDywDwj26n+TQhvPgZarIE91zQ0rhmgW
        zt81WjH8jp60HVrcKFqM3GEHs9KhcrNL6u9uFDGbKxDjKN6DzfhJvwI/PFH8gtcw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1myK3a-00CuUG-Kh
        for stable@vger.kernel.org;
        Fri, 17 Dec 2021 21:42:22 +0100
Message-ID: <3ce00af3568e08d25b88ba9c7d27638d95c95536.camel@sipsolutions.net>
Subject: Re: [PATCH v4.19 1/2] mac80211: mark TX-during-stop for TX in
 in_reconfig
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Fri, 17 Dec 2021 21:42:21 +0100
In-Reply-To: <20211217203550.54684-1-johannes@sipsolutions.net>
References: <20211217203550.54684-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-12-17 at 20:35 +0000, Johannes Berg wrote:
> 
> I'm not sure why you say it doesn't apply - it did for me?
> 

Oh, I'm an idiot, it doesn't *compile* afterwards since
IEEE80211_TXQ_STOP_NETIF_TX doesn't exist yet.

Let's ignore this patch for now, but please take 2/2.

I'll have to think if we even want to introduce this on the old kernels,
the bug that was reported required a firmware crash in the first place,
and it was reported on iwlwifi which doesn't even use TXQs on 4.19 yet.

johannes
