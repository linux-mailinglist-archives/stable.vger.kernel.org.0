Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACFFBDB329
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 19:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440643AbfJQRTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 13:19:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728639AbfJQRTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 13:19:55 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2069B20872;
        Thu, 17 Oct 2019 17:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571332794;
        bh=fkXKLDfWaA7lFTgqJsrX3X37be5F5YLryM7NAGSqj1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Py7+YBWrBJXnll38jre94lW2Q7oCwuyUtBbvKH7kR/FpgwQE4QFlF7Vu4zgTDYx7E
         CuAUcv68/FcvRvELbZA5jllBFZNOGfFk84D6bPt0XlWXmcl8fLNZsQoKcN52szir8a
         9im9bonHnRDq+CdycxZBo62X8+oJ0iEshqG+6iFo=
Date:   Thu, 17 Oct 2019 13:19:53 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Dave Wysochanski <dwysocha@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 4.19 62/81] cifs: use cifsInodeInfo->open_file_lock while
 iterating to avoid a panic
Message-ID: <20191017171953.GV31224@sasha-vm>
References: <20191016214805.727399379@linuxfoundation.org>
 <20191016214843.979454273@linuxfoundation.org>
 <20191017085538.GA5847@amd>
 <20191017160117.GA1083277@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191017160117.GA1083277@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 17, 2019 at 09:01:17AM -0700, Greg Kroah-Hartman wrote:
>On Thu, Oct 17, 2019 at 10:55:39AM +0200, Pavel Machek wrote:
>> Hi!
>>
>> > From: Dave Wysochanski <dwysocha@redhat.com>
>> >
>> > Commit 487317c99477 ("cifs: add spinlock for the openFileList to
>> > cifsInodeInfo") added cifsInodeInfo->open_file_lock spin_lock to protect
>>
>> > Fixes: 487317c99477 ("cifs: add spinlock for the openFileList to cifsInodeInfo")
>> >
>> > CC: Stable <stable@vger.kernel.org>
>> > Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
>> > Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
>> > Signed-off-by: Steve French <stfrench@microsoft.com>
>>
>> This is missing upstream commit ID and a signoff.
>
>Good catch, Sasha forgot to do that :(

I was actually thinking I'll need to replace it with David's patch. Let
me look into it.

-- 
Thanks,
Sasha
