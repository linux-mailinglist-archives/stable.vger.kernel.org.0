Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0FB47E0EB
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 19:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732689AbfHARQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 13:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730102AbfHARQl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Aug 2019 13:16:41 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B0AF2064A;
        Thu,  1 Aug 2019 17:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564679800;
        bh=hugktKepZTaSJZmk5APIsma6IAUz8PHugOUthpU6u7E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ul81fXoq2+6K9dejlvslqd6qtXd1pW3517qC4jMHJf6YdXNisnZ36FSu7x7Xr9CDn
         ayMZXoOC6vhL81Z3iRfW4HUWTPy+akkWQmTDfHBqw48R+lx6XaiSOROqaSxj1oNWrr
         QtfvbX+OoljXiBMMHejW6a8L8uC2Y/JKMkep2ct8=
Date:   Thu, 1 Aug 2019 13:16:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Vladis Dronov <vdronov@redhat.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v5.3-rc2] Bluetooth: hci_uart: check for missing tty
 operations
Message-ID: <20190801171639.GC17697@sasha-vm>
References: <20190730093345.25573-1-marcel@holtmann.org>
 <20190801133132.6BF30206A3@mail.kernel.org>
 <20190801135044.GB24791@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190801135044.GB24791@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 01, 2019 at 03:50:44PM +0200, Greg KH wrote:
>On Thu, Aug 01, 2019 at 01:31:31PM +0000, Sasha Levin wrote:
>> Hi,
>>
>> [This is an automated email]
>>
>> This commit has been processed because it contains a "Fixes:" tag,
>> fixing commit: .
>>
>> The bot has tested the following trees: v5.2.4, v5.1.21, v4.19.62, v4.14.134, v4.9.186, v4.4.186.
>>
>> v5.2.4: Build OK!
>> v5.1.21: Build OK!
>> v4.19.62: Build OK!
>> v4.14.134: Failed to apply! Possible dependencies:
>>     25a13e382de2 ("bluetooth: hci_qca: Replace GFP_ATOMIC with GFP_KERNEL")
>>
>> v4.9.186: Failed to apply! Possible dependencies:
>>     25a13e382de2 ("bluetooth: hci_qca: Replace GFP_ATOMIC with GFP_KERNEL")
>>
>> v4.4.186: Failed to apply! Possible dependencies:
>>     162f812f23ba ("Bluetooth: hci_uart: Add Marvell support")
>>     25a13e382de2 ("bluetooth: hci_qca: Replace GFP_ATOMIC with GFP_KERNEL")
>>     395174bb07c1 ("Bluetooth: hci_uart: Add Intel/AG6xx support")
>>     9e69130c4efc ("Bluetooth: hci_uart: Add Nokia Protocol identifier")
>>
>>
>> NOTE: The patch will not be queued to stable trees until it is upstream.
>>
>> How should we proceed with this patch?
>
>Already fixed up by hand and queued up, your automated email is a bit
>slow :)

/me scratches head

The patch went out two days ago:
https://lore.kernel.org/lkml/20190730093345.25573-1-marcel@holtmann.org/

How did it make it upstream already?
