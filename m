Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C64A483B10
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfHFV3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:29:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbfHFV3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:29:06 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E2F42086D;
        Tue,  6 Aug 2019 21:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565126945;
        bh=dDrEUU+uQfRilyP9Hq/+SAecmx3PUDljtMzvZnA3tbc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L8myfAyO4JD+iUPiWvm1AMuFJjtAQkOKJSjNh6u7MPjlpQZht52dP9SVBqn5TmGXF
         ZBGp1ncfNEVfU9Sc+5To6X6meBOW17Xu0MBSBzhYub7P6Gm/GXDQqB9pSDzl99Z5N+
         Ro9nRfD+n2245gbup9SP/eQTdhk/HDjwBPibHRdQ=
Date:   Tue, 6 Aug 2019 17:29:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] [Backport for 4.4.y stable] arm64 CTR_EL0 cpufeature
 fixes
Message-ID: <20190806212904.GL17747@sasha-vm>
References: <20190805171308.19249-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190805171308.19249-1-will@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 06:13:06PM +0100, Will Deacon wrote:
>Hi,
>
>These two patches are backports for 4.4.y stable kernels after one of
>them failed to apply:
>
>  https://lkml.kernel.org/r/156498316752100@kroah.com

I took these 2, but note that they have two fixes that are not in 4.4:

314d53d297980 arm64: Handle mismatched cache type
4c4a39dd5fe2d arm64: Fix mismatched cache line size detection

Will you send a backport for them?

--
Thanks,
Sasha
