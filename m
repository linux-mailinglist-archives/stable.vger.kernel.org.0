Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBBF9153DF5
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 05:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgBFEy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 23:54:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727698AbgBFEy1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 23:54:27 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F313720838;
        Thu,  6 Feb 2020 04:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580964867;
        bh=5m/AIOSzYuJGJ+qUx4tL/v18AxlKm3Q8CJnZxiGyTgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bN6ZaNHGj9UCJERzgL7b6qj+UPPvP2Tri3mGxchPgyvwlgEpIepGlWg3ZY84TR5K4
         pijPTiWvLLbTcDGLI+8oN39p1FgTR+ShkNIa4ir4AjPtd8BYDszmjyWupnldiVjSgR
         1DBfHxlAh+0M81OTObzBGokbq/FDq2vPvda3Oybs=
Date:   Wed, 5 Feb 2020 23:54:26 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] Sparc
Message-ID: <20200206045426.GM31482@sasha-vm>
References: <20200205.151110.999222765422116817.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200205.151110.999222765422116817.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 05, 2020 at 03:11:10PM +0100, David Miller wrote:
>
>Please queue up the attached sparc bug fix for -stable, thanks!

I've queued it up for all branches, thanks!

-- 
Thanks,
Sasha
