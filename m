Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4880A94D72
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 21:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfHSTDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 15:03:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbfHSTDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 15:03:50 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5B32214DA;
        Mon, 19 Aug 2019 19:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566241429;
        bh=jSr9TTwNt7h927ghAvkmu9t9Gk5BAIbgJN+uo5miIQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZS13jkzwjmuASZFE38Zk5gFS5nQLRWFhqFad4UH1FUf27QeAiZ9qxDMtcJtymJa2U
         EYHx4MySb3Mg0dh9nUvw2pcnC8BgFAvmfFIPUNIM/lhUn8kwrQYu11NsgPXHZJ1vEq
         ga95TRTNAPBAr3vDajZWRoYxJVS3AaIhN6OhLza4=
Date:   Mon, 19 Aug 2019 15:03:49 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Aaron Armstrong Skomra <skomra@gmail.com>
Cc:     "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>, benjamin.tissoires@redhat.com,
        "Cheng, Ping" <ping.cheng@wacom.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        "# v4 . 3+" <stable@vger.kernel.org>
Subject: Re: [PATCH] HID: wacom: correct misreported EKR ring values
Message-ID: <20190819190349.GE30205@sasha-vm>
References: <1566232914-9919-1-git-send-email-aaron.skomra@wacom.com>
 <20190819170246.GA30205@sasha-vm>
 <CAEoswT3mvABD7T_0WkwrAOe1PHO62jZ63tUb2UBQLm_Tqu-guw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAEoswT3mvABD7T_0WkwrAOe1PHO62jZ63tUb2UBQLm_Tqu-guw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 19, 2019 at 10:13:31AM -0700, Aaron Armstrong Skomra wrote:
>On Mon, Aug 19, 2019 at 10:02 AM Sasha Levin <sashal@kernel.org> wrote:
>
>> On Mon, Aug 19, 2019 at 09:41:54AM -0700, Aaron Armstrong Skomra wrote:
>> >The EKR ring claims a range of 0 to 71 but actually reports
>> >values 1 to 72. The ring is used in relative mode so this
>> >change should not affect users.
>> >
>> >Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
>> >Fixes: 72b236d60218f ("HID: wacom: Add support for Express Key Remote.")
>> >Cc: <stable@vger.kernel.org> # v4.3+
>> >Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
>> >Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
>> >---
>> >Patch specifically targeted to v4.9.189
>>
>> Is this not a problem upstream as well? Why not?
>>
>> If it is, this patch will need to go upstream first, and then it'll get
>> to stable branches from there.
>>
>> Hi Sasha,
>I neglected my "--in-reply-to" in git send-email, I will resend. My
>apologies.

Ah, I see what happened. Looks good now, thanks!

--
Thanks,
Sasha
