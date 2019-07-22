Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D67BD6F6BE
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 02:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfGVAib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 20:38:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbfGVAib (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jul 2019 20:38:31 -0400
Received: from localhost (unknown [216.243.17.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61970206BF;
        Mon, 22 Jul 2019 00:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563755910;
        bh=GpZBe/mU9F6rGW/Fli0H0zLhqDf/3yS0fGD8fy4RP4k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v5ABB0JnKaTX4+K9ZkC9f1xuPEc/MArnu+5GmX9I8bR0+YFLIU1SMIFkDFar50H/5
         oLb703VMlHvdMhKhKj4fRYWUMeCeMD+YEb/vEc/qOEwd34IbNweQ9iv1158CICdv9A
         koMtFO3hfEbObUZdgI36pQClZmou1ye6qlqA1it8=
Date:   Sun, 21 Jul 2019 20:38:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: Floppy ioctl range clamping fixes
Message-ID: <20190722003830.GA1607@sasha-vm>
References: <CAHk-=wg+aNdzECivhrKrBr8CzEuMuhPg40DcH=jgmNSD+Ns_Fw@mail.gmail.com>
 <20190719170718.GA32664@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190719170718.GA32664@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 19, 2019 at 07:07:18PM +0200, Greg KH wrote:
>On Thu, Jul 18, 2019 at 09:29:06PM -0700, Linus Torvalds wrote:
>> Hmm. I just realized when I saw Sasha's autoselect patches flying by
>> that the floppy ioctl fixes didn't get marked for stable, but they
>> probably should be.
>>
>> There's four commits:
>>
>>   da99466ac243 floppy: fix out-of-bounds read in copy_buffer
>>   9b04609b7840 floppy: fix invalid pointer dereference in drive_name
>>   5635f897ed83 floppy: fix out-of-bounds read in next_valid_format
>>   f3554aeb9912 floppy: fix div-by-zero in setup_format_params
>>
>> that look like stable material - even if I sincerely hope that the
>> floppy driver isn't critical for anybody.
>>
>> I leave it to the stable people to decide if they care. I don't think
>> the hardware matters any more, but I could imagine that people still
>> use it for some virtual images and have a floppy device inside a VM
>> for that reason.
>
>Thanks for the reminder, I'll queue these up for the next round of
>stable releases after the next ones go out in a day or so.

I've queued them up, thanks!

--
Thanks,
Sasha
