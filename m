Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379E0447AC4
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 08:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbhKHH0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 02:26:04 -0500
Received: from mail.ispras.ru ([83.149.199.84]:49868 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234543AbhKHH0A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 02:26:00 -0500
Received: from [10.10.2.219] (unknown [10.10.2.219])
        by mail.ispras.ru (Postfix) with ESMTPSA id 2D2C140D4004;
        Mon,  8 Nov 2021 07:23:13 +0000 (UTC)
Subject: Re: [PATCH 5.10 68/77] sctp: add vtag check in sctp_sf_violation
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ldv-project@linuxtesting.org
References: <20211101082511.254155853@linuxfoundation.org>
 <20211101082525.833757923@linuxfoundation.org>
 <a3059f52-54c6-6ab3-0f1d-a9b1566ff118@ispras.ru> <YYFevClqyJbASQXH@kroah.com>
 <YYjKd/UwdwrbnrNd@kroah.com>
From:   Alexey Khoroshilov <khoroshilov@ispras.ru>
Autocrypt: addr=khoroshilov@ispras.ru; prefer-encrypt=mutual; keydata=
 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
 kK2E04Fb+Zk1eJvHYRc=
Message-ID: <06ea9fcf-12ab-29af-1621-6b1bb38a2265@ispras.ru>
Date:   Mon, 8 Nov 2021 10:23:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YYjKd/UwdwrbnrNd@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: ru-RU
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.11.2021 09:57, Greg Kroah-Hartman wrote:
> On Tue, Nov 02, 2021 at 04:52:28PM +0100, Greg Kroah-Hartman wrote:
>> On Tue, Nov 02, 2021 at 05:12:16PM +0300, Alexey Khoroshilov wrote:
>>> Hello!
>>>
>>> It seems the patch may lead to NULL pointer dereference.
>>>
>>>
>>> 1. sctp_sf_violation_chunk() calls sctp_sf_violation() with asoc arg
>>> equal to NULL.
>>>
>>> static enum sctp_disposition sctp_sf_violation_chunk(
>>> ...
>>> {
>>> ...
>>>     if (!asoc)
>>>         return sctp_sf_violation(net, ep, asoc, type, arg, commands);
>>> ...
>>>
>>> 2. Newly added code of sctp_sf_violation() calls to sctp_vtag_verify()
>>> with asoc arg equal to NULL.
>>>
>>> enum sctp_disposition sctp_sf_violation(struct net *net,
>>> ...
>>> {
>>>     struct sctp_chunk *chunk = arg;
>>>
>>>     if (!sctp_vtag_verify(chunk, asoc))
>>>         return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
>>> ...
>>>
>>> 3. sctp_vtag_verify() dereferences asoc without any check.
>>>
>>> /* Check VTAG of the packet matches the sender's own tag. */
>>> static inline int
>>> sctp_vtag_verify(const struct sctp_chunk *chunk,
>>> 		 const struct sctp_association *asoc)
>>> {
>>> 	/* RFC 2960 Sec 8.5 When receiving an SCTP packet, the endpoint
>>> 	 * MUST ensure that the value in the Verification Tag field of
>>> 	 * the received SCTP packet matches its own Tag. If the received
>>> 	 * Verification Tag value does not match the receiver's own
>>> 	 * tag value, the receiver shall silently discard the packet...
>>> 	 */
>>> 	if (ntohl(chunk->sctp_hdr->vtag) != asoc->c.my_vtag)
>>> 		return 0;
>>>
>>>
>>> Found by Linux Verification Center (linuxtesting.org) with SVACE tool.
>>
>> These issues should all be the same with Linus's tree, so can you please
>> submit patches to the normal netdev developers and mailing list to
>> resolve the above issues?
> 
> Given a lack of response, I am going to assume that these are not real
> issues.  If you think they are, please submit patches to the network
> developers to resolve them.
> 
> thanks,
> 
> greg k-h

Hi Greg,

During discussion with the network developers it was defined that the
code is unreachable and should be removed. The corresponding patch is
already in network tree:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=e7ea51cd879c

Thank you,
Alexey


