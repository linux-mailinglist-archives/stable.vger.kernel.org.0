Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A1625713A
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 02:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgHaAkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Aug 2020 20:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgHaAka (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 Aug 2020 20:40:30 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8719B2076D;
        Mon, 31 Aug 2020 00:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598834429;
        bh=bxcnnFTPGBQCAxQaHfAYMI/1h0euRCIeuvwm4n6QH7c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xs/LWox4XCB+XNJLgKQRtpDspfswSAI/ma/RYg1jh0olRAz8BIAk5Sp27wi2+FuPG
         KMBHwoAOugNqYi4XFY+iC79FqybUxYqrtjg3/WF22Nh4sghiEdUYFoQI4PbSzslxXh
         Z4Y7vpNtx52bsiaQ97emIAAx7IMymJbPN5piuSRo=
Date:   Sun, 30 Aug 2020 20:40:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Sean Young <sean@mess.org>
Cc:     stable@vger.kernel.org, grumpy@mailfence.com
Subject: Re: Please merge ea8912b788f8 to v5.7 and earlier
Message-ID: <20200831004028.GC8670@sasha-vm>
References: <20200830192752.GA30468@gofer.mess.org>
 <20200830211526.GA666@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200830211526.GA666@gofer.mess.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 30, 2020 at 10:15:26PM +0100, Sean Young wrote:
>On Sun, Aug 30, 2020 at 08:27:52PM +0100, Sean Young wrote:
>> Hello,
>>
>> This commit is in v5.8 but it is affecting users in earlier kernels. I'd
>> like to propose this commit for merging to all earlier stable kernels.
>
>See:
>
>https://sourceforge.net/p/lirc/mailman/lirc-list/thread/nycvar.QRO.7.76.2008301313570.2090%40tehzcl5.tehzcl-arg/#msg37097213

I'll queue it up, thanks!

-- 
Thanks,
Sasha
