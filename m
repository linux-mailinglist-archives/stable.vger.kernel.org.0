Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D06115AC4
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 03:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfLGCiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 21:38:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbfLGCiD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 21:38:03 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 087612464E;
        Sat,  7 Dec 2019 02:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575686283;
        bh=czrIXGnZRCY/zaLosLV5Cn9xelOfR4LVwpir/P5oTQk=;
        h=Date:From:To:Subject:From;
        b=AYs/Z7quqAhAsq7kaX1JC0mmCDKdR3aFl/W1IfDXP/lfFJgkl2V93hEJZcYt9j7u4
         KyPDM4BX6u8EfIx/utoqNMTUwWG04jgtX2QrJkhgdM1fgxCxu0j/Sh85yVnsqH8bPo
         HD6RAse6YFC8SN59SFpOqPuFnywlzqd60Z/jJss4=
Date:   Fri, 6 Dec 2019 21:38:02 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: MAINTAINERS updates in stable trees
Message-ID: <20191207023802.GY5861@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I just saw an update to the MAINTAINERS file fly by on stable@ and
figured we might want to be grabbing all of those into our stable trees?

Unlike documentation, it's not something the case that it can diverge
from the code, and it's also very unlikely that someone wants to keep
recieving mails as a result of someone who runs get_maintainers.pl on
older kernels after he has removed his name upstream.

Any objections to taking these updates? It'll grow our patch count, but
that's one of the rare cases where I don't see a way for it to cause
regressions...

-- 
Thanks,
Sasha
