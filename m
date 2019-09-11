Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1BBAF9C3
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 12:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfIKKB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 06:01:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbfIKKB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 06:01:56 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 554072075C;
        Wed, 11 Sep 2019 10:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568196116;
        bh=4AC8fqWOxhpdaHQC9zy9mO1g7IsQxUCxKasNYiJ67Sk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mljHzRvNp+zT/odA0CD+eCB+uUCbE0BFQLzZoc91Xl+VMoPI4EuUKf4E79Bkjmqku
         fnLtAeItAmtQ5JD50e8+wBrMhXtiTYqB01dX0n7tUTCdu0upwf2qleunh/h1K2P2ki
         Tk8vGtrOa4kpN8av6hExdi9KLIuJklJjr04JmnBg=
Date:   Wed, 11 Sep 2019 06:01:53 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, stable@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com
Subject: Re: [PATCH 4.14] vhost/test: fix build for vhost test
Message-ID: <20190911100153.GM2012@sasha-vm>
References: <20190911025055.26774-1-tiwei.bie@intel.com>
 <20190911091631.GI2012@sasha-vm>
 <20190911093532.GA17308@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190911093532.GA17308@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 11, 2019 at 10:35:32AM +0100, Greg KH wrote:
>On Wed, Sep 11, 2019 at 05:16:31AM -0400, Sasha Levin wrote:
>> On Wed, Sep 11, 2019 at 10:50:55AM +0800, Tiwei Bie wrote:
>> > commit 264b563b8675771834419057cbe076c1a41fb666 upstream.
>> >
>> > Since vhost_exceeds_weight() was introduced, callers need to specify
>> > the packet weight and byte weight in vhost_dev_init(). Note that, the
>> > packet weight isn't counted in this patch to keep the original behavior
>> > unchanged.
>> >
>> > Fixes: e82b9b0727ff ("vhost: introduce vhost_exceeds_weight()")
>> > Cc: stable@vger.kernel.org
>> > Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
>> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> > Acked-by: Jason Wang <jasowang@redhat.com>
>>
>> I've queued it up for 4.14, 4.9, and 4.4. Thank you.
>
>So did I, I think you will get conflicts when you try to merge :)

I did. Good thing we live in different timezones :)

--
Thanks,
Sasha
