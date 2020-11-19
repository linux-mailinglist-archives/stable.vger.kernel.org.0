Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F252B9B03
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 19:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgKSS5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 13:57:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727025AbgKSS5L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Nov 2020 13:57:11 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EB1D2151B;
        Thu, 19 Nov 2020 18:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605812230;
        bh=i4mQIFLjwvFqbd0N4OxgUfvufwBI3b6pbjHDzOyryVo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XpqWvjRCeYcJVg4l5yOHeLEQODM2X3jYkrZMzutu3+AhuFIX3tzJP24RMCc4jvQEf
         giOaQkpXj7thJLV0V8lby/J5UDBBPK6f1VGzWOasX81rVGMuFESJH12GtwyYTx9pqn
         okQ7rKllgpYIbZKa+PzM5ou/I2eJwV/tsHXEiwoY=
Date:   Thu, 19 Nov 2020 13:57:09 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     peterz@infradead.org, Vincent Guittot <vincent.guittot@linaro.org>,
        bsegall@google.com, gregkh@linuxfoundation.org, pauld@redhat.com,
        zohooouoto@zoho.com.cn, stable@vger.kernel.org,
        Gavin Guo <gavin.guo@canonical.com>,
        nivedita.singhvi@canonical.com, halves@canonical.com
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
Message-ID: <20201119185709.GD643756@sasha-vm>
References: <d3188913-ddb8-7198-8483-47d3031b01fe@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d3188913-ddb8-7198-8483-47d3031b01fe@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 19, 2020 at 11:56:01AM -0300, Guilherme G. Piccoli wrote:
>Hi Sasha / Peter, is there anything blocking this backport from Vincent
>to get merged in 5.4.y?

An ack from Peter...

-- 
Thanks,
Sasha
