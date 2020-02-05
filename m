Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE454153976
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 21:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgBEUS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 15:18:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgBEUS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 15:18:58 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 293BB20720;
        Wed,  5 Feb 2020 20:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580933937;
        bh=1U2JNySow9ywV+0MoIP2f05Iqj1pjEt3CoLVZfd9sIs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AtfVJGGE53V8jsRx4jZS4KtqAT6NoNv+ezxGCKvxqdo9kMyIQs3JAnkNhg7g8io+a
         FEvppDkZoFTQllOk2fRgVfUtfkZLq7+xx9UZO8+UxeUrtDadP46ROtLEtqvSewGyKg
         WjBroJhKWkH6fKrAyDNTwtsmd8AOQ2ONRb8cIKPI=
Date:   Wed, 5 Feb 2020 15:18:56 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Evan Green <evgreen@chromium.org>, Rajat Jain <rajatja@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, Marc Zyngier <maz@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/apic/msi: Plug non-maskable MSI affinity race
Message-ID: <20200205201856.GF31482@sasha-vm>
References: <87lfpn50id.fsf@nanos.tec.linutronix.de>
 <20200205144509.7004C21D7D@mail.kernel.org>
 <87wo91rsgg.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87wo91rsgg.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 05, 2020 at 02:58:55PM +0000, Thomas Gleixner wrote:
>Sasha Levin <sashal@kernel.org> writes:
>
>> Hi,
>>
>> [This is an automated email]
>>
>>
>> NOTE: The patch will not be queued to stable trees until it is upstream.
>>
>> How should we proceed with this patch?
>
>Use V2 :)

My little bot can't keep up :)

-- 
Thanks,
Sasha
