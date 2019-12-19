Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD051270A3
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 23:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfLSW0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 17:26:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:48906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfLSW0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 17:26:40 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E7812465E;
        Thu, 19 Dec 2019 22:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576794399;
        bh=BdxQB7ZSwpAKwtK0q7O8WB6T9KEqcDWx9oV6YYKU1yE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xeKp3emR/vcXvAEBwMnM2kiL7cWKcDjM2mTeGnzAfzCB5mxZgB2q+exWBl6sLXkaV
         MmAtLNeK9ggqD5nzAPd8Fi14TMgOdo4JAov0ycKif6Ru46LbAGh/XlMAwP5kzk5bwj
         KnfhPJuEEXpk2S1I6Esw9VouM18G9PO9MZU1Un64=
Date:   Thu, 19 Dec 2019 17:26:38 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Guenter Roeck <groeck@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "# v4 . 10+" <stable@vger.kernel.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Andrey Pronin <apronin@chromium.org>,
        Duncan Laurie <dlaurie@chromium.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Alexander Steffen <Alexander.Steffen@infineon.com>,
        Heiko Stuebner <heiko@sntech.de>,
        linux-integrity@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 277/350] tpm: Add a flag to indicate TPM
 power is managed by firmware
Message-ID: <20191219222638.GS17708@sasha-vm>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-238-sashal@kernel.org>
 <CABXOdTdO16V4AtO1t=BwXW2=HAtT6CYoSddmrn5T2qZP9hs0eQ@mail.gmail.com>
 <20191211175651.GK4516@linux.intel.com>
 <CABXOdTcsnAVaPo-492tVPtjOYMbNtu2Zvz4GwSBGcDEHAMGw5Q@mail.gmail.com>
 <20191213001654.GD7854@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191213001654.GD7854@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 13, 2019 at 02:17:31AM +0200, Jarkko Sakkinen wrote:
>On Wed, Dec 11, 2019 at 10:05:52AM -0800, Guenter Roeck wrote:
>> On Wed, Dec 11, 2019 at 9:57 AM Jarkko Sakkinen
>> <jarkko.sakkinen@linux.intel.com> wrote:
>> >
>> > On Tue, Dec 10, 2019 at 01:32:15PM -0800, Guenter Roeck wrote:
>> > > On Tue, Dec 10, 2019 at 1:12 PM Sasha Levin <sashal@kernel.org> wrote:
>> > > >
>> > > > From: Stephen Boyd <swboyd@chromium.org>
>> > > >
>> > > > [ Upstream commit 2e2ee5a2db06c4b81315514b01d06fe5644342e9 ]
>> > > >
>> > > > On some platforms, the TPM power is managed by firmware and therefore we
>> > > > don't need to stop the TPM on suspend when going to a light version of
>> > > > suspend such as S0ix ("freeze" suspend state). Add a chip flag,
>> > > > TPM_CHIP_FLAG_FIRMWARE_POWER_MANAGED, to indicate this so that certain
>> > > > platforms can probe for the usage of this light suspend and avoid
>> > > > touching the TPM state across suspend/resume.
>> > > >
>> > >
>> > > Are the patches needed to support CR50 (which need this patch) going
>> > > to be applied to v5.4.y as well ? If not, what is the purpose of
>> > > applying this patch to v5.4.y ?
>> > >
>> > > Thanks,
>> > > Guenter
>> >
>> > Thanks Guenter. I think not.
>> >
>> Thought so. In that case this patch should be dropped.
>>
>> Guenter
>
>I fully agree with you.

I've dropped it, thanks!

-- 
Thanks,
Sasha
