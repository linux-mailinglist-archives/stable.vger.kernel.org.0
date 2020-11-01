Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B762A1B57
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 01:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgKAAOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 20:14:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgKAAOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 20:14:15 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39A3920791;
        Sun,  1 Nov 2020 00:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604189655;
        bh=fLxZMQnVK0Gt5mTwNVWTfb+qOBMHXYqwEmR4V1UfGD4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y9vK2zxSYhwLxzt/k4lDU3JUd7pn8WDUUDTe3vjU9yWOKcLdf+999ghfSeBOH7yP4
         QuxWpF74k87CkGf3C9dmD/1SQq5jkcGF3/3yT7m8fn0ny8wUL8vJHKsx8oivHWC+vd
         /m4DmqTdp1sovSQftEW2camsDHpf9HBbO+sttAqg=
Date:   Sat, 31 Oct 2020 20:14:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: v4.9.241 build failures
Message-ID: <20201101001414.GA2092@sasha-vm>
References: <d7a693e2-9f4d-afc4-c1e1-a1c04122f472@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d7a693e2-9f4d-afc4-c1e1-a1c04122f472@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 31, 2020 at 07:35:58AM -0700, Guenter Roeck wrote:
>Building powerpc:defconfig ... failed
>Building powerpc:allmodconfig ... failed
>--------------
>Error log:
>arch/powerpc/platforms/powernv/opal-dump.c: In function ‘process_dump’:
>arch/powerpc/platforms/powernv/opal-dump.c:409:7: error: void value not ignored as it ought to be
>  dump = create_dump_obj(dump_id, dump_size, dump_type);
>

I see that Greg already took b29336c0e178 ("powerpc/powernv/opal-dump :
Use IRQ_HANDLED instead of numbers in interrupt handler") for 4.9 and
4.4, which should fix this issue.

-- 
Thanks,
Sasha
