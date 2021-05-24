Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCE938E0BD
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 07:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhEXF6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 01:58:09 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:34212 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232274AbhEXF6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 01:58:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621835801; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=be4eKo2P5DdMYwKNrNDybOr8ySR6R9EZI7Dx3bWOIS4=; b=GS3ynVs5Ejy/S4lMb4Hgl5VxcfS+FwSPABbNeniZvEF8g1aReI6sMKIPPkWy6Ea7Ujo4kP5n
 m7ro+g7wukBIrabBtK1bFPgKoXl1mhkEe1ON1+O5PSRW8kxkOZyZRV3uPQH4kqBUEaWIXUL+
 nBuBmXvE1af4Bvta2+eOItH63Ec=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60ab4004c229adfeff1085d7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 24 May 2021 05:56:20
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DE001C4360C; Mon, 24 May 2021 05:56:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 887CBC433D3;
        Mon, 24 May 2021 05:56:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 887CBC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        regressions@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [regressions] ath11k: v5.12.3 mhi regression
References: <87v97dhh2u.fsf@codeaurora.org> <YKYzwBJNTy4Czd1A@kroah.com>
        <20210520104313.GA128703@thinkpad> <87r1i1h9an.fsf@codeaurora.org>
        <3e8bac3b02e3549a55b7c9b78b699965@codeaurora.org>
        <YKajWVPUSTzNVVm8@kroah.com>
        <608474b9b9feae5bd0616ad16d6d6bbd@codeaurora.org>
        <YKanuzzvDhztYxm/@kroah.com>
Date:   Mon, 24 May 2021 08:56:14 +0300
In-Reply-To: <YKanuzzvDhztYxm/@kroah.com> (Greg KH's message of "Thu, 20 May
        2021 20:17:31 +0200")
Message-ID: <87eedwhdz5.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Thu, May 20, 2021 at 11:04:05AM -0700, Bhaumik Bhatt wrote:
>> On 2021-05-20 10:58 AM, Greg KH wrote:
>> > On Thu, May 20, 2021 at 10:38:12AM -0700, Bhaumik Bhatt wrote:
>> > > On 2021-05-20 05:36 AM, Kalle Valo wrote:
>> > > > Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:
>> > > >
>> > > > > On Thu, May 20, 2021 at 12:02:40PM +0200, Greg KH wrote:
>> > > > > > On Thu, May 20, 2021 at 12:47:53PM +0300, Kalle Valo wrote:
>> > > > > > > Hi,
>> > > > > > >
>> > > > > > > I got several reports that this mhi commit broke ath11k in v5.12.3:
>> > > > > > >
>> > > > > > > commit 29b9829718c5e9bd68fc1c652f5e0ba9b9a64fed
>> > > > > > > Author: Bhaumik Bhatt <bbhatt@codeaurora.org>
>> > > > > > > Date:   Wed Feb 24 15:23:04 2021 -0800
>> > > > > > >
>> > > > > > >     bus: mhi: core: Process execution environment changes serially
>> > > > > > >
>> > > > > > >     [ Upstream commit ef2126c4e2ea2b92f543fae00a2a0332e4573c48 ]
>> > > > > > >
>> > > > > > > Here are the reports:
>> > > > > > >
>> > > > > > > https://bugzilla.kernel.org/show_bug.cgi?id=213055
>> > > > > > >
>> > > > > > > https://bugzilla.kernel.org/show_bug.cgi?id=212187
>> > > > > > >
>> > > > > > > https://bugs.archlinux.org/task/70849?project=1&string=linux
>> > > > > > >
>> > > > > > > Interestingly v5.13-rc1 seems to work fine, at least for me, though I
>> > > > > > > have not tested v5.12.3 myself. Can someone revert this commit in the
>> > > > > > > stable release so that people get their wifi working again, please?
>> > > > > >
>> > > > > > How does the mhi bus code relate to a ath11k driver?  What bus
>> > > > > > is that
>> > > > > > on?
>> > > > > >
>> > > > >
>> > > > > MHI is the transport used by the ath11k driver to work with the WLAN
>> > > > > devices
>> > > > > over PCIe.
>> > > > >
>> > > > > Regarding the bug, I'd suggest to wait for Bhaumik (the author of
>> > > > > 29b9829718c5)
>> > > > > to comment on the possible commit which needs backporting from
>> > > > > mainline.
>> > > >
>> > > > Ok, but if a quick fix is not available I think we should just revert
>> > > > this in the stable releases. I also got a report that v5.11.21 is
>> > > > broken:
>> > > >
>> > > > https://bugzilla.kernel.org/show_bug.cgi?id=213055#c11
>> > > 
>> > > Please pick [1] as the dependency to [ Upstream commit
>> > > ef2126c4e2ea2b92f543fae00a2a0332e4573c48 ].
>> > 
>> > what is [1]???
>> > 
>> > What commit do I need to backport, a commit id would be nice...
>> > 
>> > thanks,
>> > 
>> > greg k-h
>> Sure Greg. Commit id is: 4884362f6977fc05cbec736625665241c0e0732f
>> 
>> Title of patch:
>> bus: mhi: core: Download AMSS image from appropriate function
>> 
>> It was supposed to be a link but not sure why it's not seen.
>
> Text email doesn't have links :)
>
> Anyway, thanks, now queued up.

I'm now getting confirmations that this issue is fixed in v5.12.6.
Thanks for the quick fix and the quick new release!

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
