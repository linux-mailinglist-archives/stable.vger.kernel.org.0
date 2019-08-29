Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 543F3A262D
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfH2SiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727726AbfH2SiU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:38:20 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24F5821726;
        Thu, 29 Aug 2019 18:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567103899;
        bh=eYYpkZ7hrQWpMnK2X6rbOJKGLrjisQyhv3JDCs6tDh8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JuQ7xHQCDuND8d6Q5MASFu10EWXvIlHLIs1zG2F/EYPX5sm83pg7Fg12W4BDRlF7U
         iVUb0HhensGB+Wv7XAK2ysml+fLD2F4P/L23lUds7zXJsh5ZPkyY8IP8sQ0Tv1M8Fy
         RY1R5ridHjnJm7uZpHJjdl6q5ij8stsb5rlGSvNc=
Date:   Thu, 29 Aug 2019 14:38:18 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jan Stancek <jstancek@redhat.com>
Cc:     peterz@infradead.org, will@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Waiman Long <longman@redhat.com>,
        dbueso@suse.de, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v5.2 1/2] locking/rwsem: Add missing ACQUIRE to
 read_slowpath exit when queue is empty
Message-ID: <20190829183818.GK5281@sasha-vm>
References: <20190826143114.23471-1-sashal@kernel.org>
 <396661303.8419298.1566915099958.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <396661303.8419298.1566915099958.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 10:11:39AM -0400, Jan Stancek wrote:
>ACK, both look good to me.
>I also re-ran reproducer with this series applied on top of 5.2.10, it PASS-ed.

I've queued both for 5.2, thanks Jan.

--
Thanks,
Sasha
