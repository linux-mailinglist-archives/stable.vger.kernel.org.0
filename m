Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6446348C207
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 11:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352411AbiALKN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 05:13:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54214 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352380AbiALKN5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 05:13:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35671B81EA2;
        Wed, 12 Jan 2022 10:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA70C36AEA;
        Wed, 12 Jan 2022 10:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641982434;
        bh=l/MAPuhYehSWlPQXLxWyJUNQ64woevtj4J1Obqd0MXk=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=Xnxqlbzjk3oP0RWroREu3bGetH+k92YlBtOhyHD9hNjit5kAxDGu5omh4BrhRvK3X
         Tonc1UdtNmxfU0b+7s1f1hDaKfRZFcahPe9HOTiTBm0PF23aSc4L5OjQqhkzbuwgLm
         bqg3xMLQE2A5hPEO8tf7NXFtVnE7l8AtmWlCliyssi4vZy+fyxfwWrzbxNz8SX6v6x
         FpqdvEkY2Jqe5rWISOSngVvIuhUkx30a4YOiv3oPeKbpHC9Xc/bGbDEYPnZxl215ds
         mAec8OOF9/P2mNZSewEN33E2XgA3Q9CQSWUMtUn1ObHUweX6GqVI+hz9LM59zMPxME
         zalqR7py+UY6g==
Date:   Wed, 12 Jan 2022 11:13:51 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Karl Kurbjun <kkurbjun@gmail.com>
cc:     linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] HID: Ignore battery for Elan touchscreen on HP Envy X360
 15t-dr100
In-Reply-To: <20220110034935.15623-1-kkurbjun@gmail.com>
Message-ID: <nycvar.YFH.7.76.2201121113230.28059@cbobk.fhfr.pm>
References: <20220110034935.15623-1-kkurbjun@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 9 Jan 2022, Karl Kurbjun wrote:

> Battery status on Elan tablet driver is reported for the HP ENVY x360
> 15t-dr100. There is no separate battery for the Elan controller resulting
> in a battery level report of 0% or 1% depending on whether a stylus has
> interacted with the screen. These low battery level reports causes a
> variety of bad behavior in desktop environments. This patch adds the
> appropriate quirk to indicate that the batery status is unused for this
> target.
> 
> Signed-off-by: Karl Kurbjun <kkurbjun@gmail.com>

I've added Cc: stable and applied to hid.git#for-5.17/upstream-fixes

Thanks,

-- 
Jiri Kosina
SUSE Labs

