Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4455277C43
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 01:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgIXXPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 19:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgIXXPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 19:15:49 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AE75206FB;
        Thu, 24 Sep 2020 23:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600989348;
        bh=JmCbhukdU02G7qBj6VXLCDophzwUUFtHYpSQlEKA840=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OqNiYhOSBdsGhGhBFnkFL5QWBoniRRRKuhd9tdz7mYNppbkBWmEvbUjSErLED80U8
         ah9Qs5thaoK4qp/oklh7guY2EDYZmaYbUUz1vrGL1FwAYPQ5SM/SGJKxrqisdiCpMU
         nRHcDJ/pDcpOpmYxpL7JLggrGMli33gH+BqyRVS4=
Date:   Thu, 24 Sep 2020 19:15:47 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Nobuhiro Iwamatsu <noburhio1.nobuhiro@toshiba.co.jp>
Subject: Re: [PATCH for 4.4 and 4.9] mtd: Fix comparison in
 map_word_andequal()
Message-ID: <20200924231547.GS2431@sasha-vm>
References: <20200924100054.367518-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200924100054.367518-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 24, 2020 at 07:00:54PM +0900, Nobuhiro Iwamatsu wrote:
>From: Ben Hutchings <ben@decadent.org.uk>
>
>commit ea739a287f4f16d6250bea779a1026ead79695f2 upstream.
>
>Commit 9e343e87d2c4 ("mtd: cfi: convert inline functions to macros")
>changed map_word_andequal() into a macro, but also changed the right
>hand side of the comparison from val3 to val2.  Change it back to use
>val3 on the right hand side.
>
>Thankfully this did not cause a regression because all callers
>currently pass the same argument for val2 and val3.
>
>Fixes: 9e343e87d2c4 ("mtd: cfi: convert inline functions to macros")
>Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
>Signed-off-by: Nobuhiro Iwamatsu (CIP) <noburhio1.nobuhiro@toshiba.co.jp>

Queued up, thanks!

-- 
Thanks,
Sasha
