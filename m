Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D80233A2A3
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 05:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhCNEbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 23:31:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhCNEam (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Mar 2021 23:30:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D1E164EC3;
        Sun, 14 Mar 2021 04:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615696241;
        bh=NxwIpWjfmSmkmEdEXYa3bsFEkhoHin65SJ//WUncEJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OmvjSS4B7zu+0g1O0QQsUYUDdWFoAFVMFt3SfcMzaQYmawCvgkYSCcznGjXbM9/L6
         Do+bD6pYdh+uIKgTmmEAYoNj06HzreBYsUXefYS8hMJttB7/0jNKElllJSyTCd+lGD
         cDTW33B789n5ngWDJ2wwN51r/yt5Z1ZoLi2yOWvJtS7IfqUECwdEkqj2KWpdfhgC89
         WJYn35nembI0r3HQebft/yqei7aw1gIyYvnF3mLKHtMk3iqNQ8tR1lA6xsQ7NdKozW
         wBGzK5/qXAohqs5fMhu267Ce4s1CxPYBvhw+IIx9mSnyGT0RuXNcoUaPBZ2Wcy0FMZ
         hYYJUjfGSuLHQ==
Date:   Sun, 14 Mar 2021 13:30:36 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Anton Eidelman <anton@lightbitslabs.com>
Cc:     stable@vger.kernel.org, sagi@grimberg.me, hch@lst.de
Subject: Re: nvme: ns_head vs namespace mismatch fixes
Message-ID: <20210314043036.GA10801@redsun51.ssa.fujisawa.hgst.com>
References: <20210314041320.1358030-1-anton@lightbitslabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210314041320.1358030-1-anton@lightbitslabs.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 13, 2021 at 08:13:18PM -0800, Anton Eidelman wrote:
> Please, apply the following two upstream commits (attached)
> (in this order):
>     d567572906d9 nvme: unlink head after removing last namespace
>     ac262508daa8 nvme: release namespace head reference on error
> 
> TO: v5.4, v5.5, v5.6, v5.7
> These commits are present in v5.8
> and apply cleanly to the above.

5.4 is probably okay, but the rest are EOL and no longer maintained.
Please visit kernel.org for the current stable kernel maintenance
status.
