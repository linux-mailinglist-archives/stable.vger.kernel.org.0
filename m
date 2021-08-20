Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5983F376D
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 01:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhHTXty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 19:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhHTXty (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 19:49:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DD366101C;
        Fri, 20 Aug 2021 23:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629503355;
        bh=JXwU5WV9T1UNozXqtaSTz69izClPxoPdqjQ204PcehA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F8HoREA4IKijQEf5GT+O6JfOZKTymP5vm27A0xAx2RIYINuMCTa/+t1bZxZd9sepo
         31C2bfPCc7NHe96EpVrd0CdzIHMKP0/uwIhNGZlcczbebJD5OcR3gQDIqoOYThKUbx
         1HHqQxFPqbN0HzKAQ/Jkhy3U5eceukxQK5DVg24wPp70c0fpfa1TOQA98SQ2dBySDb
         mHrjixdNL5ORYDngeGJIPpYtxByaLJzHbk/LWPSQAwJo75zT2Jcc7SjXaoYG22LbEs
         Mkc1VLwIVzfNDXUK+U8CWI78H1rrhUIV8Je4gR+gTIbzPPDYnFnRhix3HNsAYHSA00
         Sl1HQu1aPp/Qg==
Date:   Fri, 20 Aug 2021 19:49:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Backporting CVE-2020-3702 ath9k patches to stable
Message-ID: <YSA/euLpnAqmoq5b@sashalap>
References: <20210818084859.vcs4vs3yd6zetmyt@pali>
 <YRzMt53Ca/5irXc0@kroah.com>
 <20210818091027.2mhqrhg5pcq2bagt@pali>
 <YRzQZZIp/LfMy/xG@kroah.com>
 <20210820113505.dgcsurognowp6xqp@pali>
 <YSAdPJFhmTztd+0Z@sashalap>
 <87y28vycox.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87y28vycox.fsf@toke.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 21, 2021 at 12:27:10AM +0200, Toke Høiland-Jørgensen wrote:
>Sasha Levin <sashal@kernel.org> writes:
>> On Fri, Aug 20, 2021 at 01:35:05PM +0200, Pali Rohár wrote:
>>>It is sad, but Qualcomm support said that they have fixed it in their
>>>proprietary driver in July 2020 (so more than year ago) and that open
>>>source drivers like ath9k are unsupported and customers should not use
>>>them :( And similar answer is from vendors who put these chips into
>>>their cards / products.
>>
>> Is there a public statement that says that? Right now the MAINTAINERS
>> file says it's "supported" and if it's not the case we should at least
>> fix that and consider deprecating it if it's really orphaned.
>
>FWIW there's still quite a few OpenWrt devices that are using ath9k and
>ticking away happily. And we are some that do still care about ath9k,
>even if QCA doesn't... As the email that started this thread also shows,
>I suppose?

Thats obviously true, and if there are people who care about this then
they should both get the tools needed from the community to do their
work as well as the credit for getting the work done.

-- 
Thanks,
Sasha
