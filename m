Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE761B8310
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 03:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbgDYBoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 21:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbgDYBoQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 21:44:16 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4F2120857;
        Sat, 25 Apr 2020 01:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587779055;
        bh=dEsZkqvnMLvemwC5JZBMdhog0NUYTGfMOIaUvEcwpUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KwEwR6mKtBH2f4MCkuAkxeDIWSfFZXiDAo+b6YdZUF2oXjeaOWlmm72Unhp7sOLBy
         9uHgiJ42Ii6ligO1mgHmX8IKg+pnYY0WuIUvHOeoMg/RsjcKv7bd4BVo70Vdl/y4PQ
         e1G4JNeVtewZftE78NX9Psmp2gc1fAz0cUCZAwl4=
Date:   Fri, 24 Apr 2020 21:44:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     James Morse <james.morse@arm.com>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [stable:PATCH 0/4 v5.4] arm64: Workaround Neoverse-N1 #1542419
Message-ID: <20200425014414.GC13035@sasha-vm>
References: <20200424163805.4087-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200424163805.4087-1-james.morse@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 05:38:01PM +0100, James Morse wrote:
>This series backports the Neoverse-N1 #1542419 erratum workaround
>to v5.4.35. The series was originally merged in v5.5.
>
>These patches handle user-space. The kernel change was:
>commit dd8a1f134884 ("arm64: ftrace: Ensure synchronisation in PLT setup
>for Neoverse-N1 #1542419"), which was taken as a fix for v5.4.

I've queued this and the 4.19 backport, thank you!

-- 
Thanks,
Sasha
