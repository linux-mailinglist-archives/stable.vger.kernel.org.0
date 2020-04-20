Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CA41B13F3
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 20:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgDTSH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 14:07:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39342 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgDTSH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 14:07:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4FBDB127D38C5;
        Mon, 20 Apr 2020 11:07:26 -0700 (PDT)
Date:   Mon, 20 Apr 2020 11:07:25 -0700 (PDT)
Message-Id: <20200420.110725.484589741956408175.davem@davemloft.net>
To:     john.haxby@oracle.com
Cc:     edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] ipv6: fix restrict IPV6_ADDRFORM operation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2728d063cd3c34c25eec068e06a0676199a84f62.1587221721.git.john.haxby@oracle.com>
References: <cover.1587221721.git.john.haxby@oracle.com>
        <2728d063cd3c34c25eec068e06a0676199a84f62.1587221721.git.john.haxby@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 11:07:26 -0700 (PDT)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Haxby <john.haxby@oracle.com>
Date: Sat, 18 Apr 2020 16:30:49 +0100

> Commit b6f6118901d1 ("ipv6: restrict IPV6_ADDRFORM operation") fixed a
> problem found by syzbot an unfortunate logic error meant that it
> also broke IPV6_ADDRFORM.
> 
> Rearrange the checks so that the earlier test is just one of the series
> of checks made before moving the socket from IPv6 to IPv4.
> 
> Fixes: b6f6118901d1 ("ipv6: restrict IPV6_ADDRFORM operation")
> Signed-off-by: John Haxby <john.haxby@oracle.com>

Applied, thanks.
