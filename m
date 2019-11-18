Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4145100E31
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 22:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfKRVrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 16:47:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:48946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbfKRVrP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 16:47:15 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66529206DA;
        Mon, 18 Nov 2019 21:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574113634;
        bh=NhKtL9xvqSHWdCkQ01G1URk3w/1kZ+jC7w48JUyR0zk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=epYIwk9YD1G2NenrvnMte/haakXLUAlEv3cRAWfQ+21OUx7R6GJ+S4MxZiw+Kp+BL
         drEdFAjG9Xo+v8VcXjKQb5jsgKbz6imCetIzurRqr4iSu53KK7UnWPZ4lp50H2xRea
         CkF1r3Nhc46SGAKndBlFbjQpykIseCiMm4P8SwHE=
Date:   Mon, 18 Nov 2019 16:47:13 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stable <stable@vger.kernel.org>,
        =?iso-8859-1?Q?Fran=E7ois?= Valenduc <francoisvalenduc@gmail.com>
Subject: Re: Size of the stable-queue git tree
Message-ID: <20191118214713.GB16867@sasha-vm>
References: <95023b9f-1281-b74b-cae0-0516ee4ceb90@gmail.com>
 <CADVatmObLQ9-aPN1s9qLNh0JVO08fxJ_r_YGvuGqyF4Lsf9KeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADVatmObLQ9-aPN1s9qLNh0JVO08fxJ_r_YGvuGqyF4Lsf9KeQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 08:22:34PM +0000, Sudip Mukherjee wrote:
>On Mon, Nov 18, 2019 at 6:55 PM François Valenduc
><francoisvalenduc@gmail.com> wrote:
>>
>> Hello everybody,
>>
>> I pulled the stable-queue tree just now. This was not an inital clone,
>> but only an update. My previous update was end of last week I was
>> surprised I had to download 1,19 Gb to download.
>
>same for me too. 1.2GiB.

Yes, it has gotten bigger :)

There was feedback from the testing & fuzzing MC in plumbers that the
quilt queue is difficult to work with, and is quite "unique" in the
landscape of kernel development, so I've added queue/* branches to
stable-queue which are basically regular git branches that represent
different queues.

I'll send a longer mail once few more folks finish some testing with it.

-- 
Thanks,
Sasha
