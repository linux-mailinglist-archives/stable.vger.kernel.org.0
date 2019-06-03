Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE2533023
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 14:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfFCMrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 08:47:25 -0400
Received: from mout.web.de ([212.227.17.12]:32831 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbfFCMrY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 08:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1559566036;
        bh=WueIryAtfWuxgQR2BNozZRjdt4M6NCo/HXvXvqK06XU=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=PogNKJDo6Sdjzc56uXnE77HUNVXXnfuhWfeqJnMR7wzuw0N4ZtPx9VW2XXvM+STFM
         w4hj6LIpmbkAl2UB/WtdlO39Zm0RiS+wFzD0QlWmqWWmCLbtuRGiYNBv4jKMljdIlZ
         zyGT7nxSeu6b/TeGyuqUNf12aPPKKiugo6eyTSyg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.58.28] ([80.130.118.25]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MHY5w-1hYspc2mYW-003Isp; Mon, 03
 Jun 2019 14:47:16 +0200
Subject: Re: [PATCH] Revert "usb: core: remove local_irq_save() around
 ->complete() handler"
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20190531215340.24539-1-smoch@web.de>
 <20190531220535.GA16603@kroah.com>
 <6c03445c-3607-9f33-afee-94613f8d6978@web.de>
 <20190601105008.zfqrtu6krw4mhisb@linutronix.de>
From:   =?UTF-8?Q?S=c3=b6ren_Moch?= <smoch@web.de>
Message-ID: <e4c057c4-218c-31aa-5aee-90dea3552282@web.de>
Date:   Mon, 3 Jun 2019 14:47:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190601105008.zfqrtu6krw4mhisb@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:gXOSPN+7vYzEmHNWhslARZjMKDQhZ6/0pvmDe55ECK7DDKBtLWK
 Ny6BHpKf5xEwlpdirjK+i4v6jNEjAs+WX5evt4ApT6JGFO+ftNcHTErL4g10tz2nmIcGhbN
 Zd0LLkl7arj7ZqPwnSSyaAQbsFrwa2PXCRW/f2EnAe3sEayACqeejWFrVGGyTCrDTOXGygU
 LLtuxpNUjlDJC8LM31zyw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:zl9WDbOTpIo=:1DVOP8oF2yEb6XjEB4chLv
 VtTXqjTyGsbh1NPSKnE/gEJ1LFLiSE2AKzCPJLKmppxqsgVU43LlYntyfipsRUFfOxpA9Xk6+
 d5rSRk3fZljnJxaodF3pebOV/psHPduI11rIxoAUg08N4ZgepFMsijq/aBpTBVe+wOVXW5wKY
 /cq62s1/gi1f8pCWqeuUxFhmmGJP0RY72seE+gCyLT/rJ3BzPkJTCamNBhXPxHlsQeNi5RJZ7
 059NPz1hfQUTIMkHiqJydBtX9/gzhB69aIJQTS5ykol4YG7puFZ1WpkWE1NoFusEWotZ3GQbt
 UWN4k+6Kn+n2LOBvfyJIJ/ovYbzlN0YdGy3lQ9mStXDUnKYyFyBBFLqWTUqp2khth4sRKCsYw
 w3OuckZ7Ex3wN50B8lEa7uxNRBwQUN2VoAoh1vezUMglfcY5B3gd4VXCaA2bHUs2BsXxXzUTY
 Znb4wsl+JWWJEM1SnU6zz5rmzxcgBhc0ixdgQ0FhgCJNipOFeJuIHQa+kq01bbCUu1NtNXbT8
 DY+nTOX4EKJgiRMHbkg3hZhGQiA8mHtJ4LsmmB9U1POo6lDCh6A3ts901dd1LpA9GlSPIFLpv
 WWcyhDcHzmdHL2zYFyv78OEeEv1uGmBhazrxraIG9AMv1YNPJHgUlK+3e3t27+p9XZLujaZkD
 nCqytJn+avoEirPkRhyRhxI6m/uDtb8tIFoliQEeZxjSJzxuy08jIjrYH5BrR9WBPXcc73DA4
 P0QtWb6EQIirARkwi0eWFF/HMCQ/tecZUwqEMtA7KT/VDW9wMYXikvohIQjZCHOg5fiFUp0Hg
 GkOoEeBdtFUIQuR8kevbRLBJdfcgfJJb2s+GL3wgZL4338EO42bY2fdigaxthJ1lmaiLb+lrw
 kCVXB+MJ3vOL/QqE07rUqZfqJ/cCUx+ASS7Zodc9r4JZBTyGPEo7mpKYQ3lWR54GkvfV28O3l
 gZcvoqBG3sKJJmjyzAuvoQL1KhgZeObM=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 01.06.19 12:50, Sebastian Andrzej Siewior wrote:
> On 2019-06-01 01:02:37 [+0200], Soeren Moch wrote:
>>> Why not just fix that driver?  Wouldn't that be easier?
>>>
>> I suspect there are more drivers to fix. I only tested WIFI sticks so
>> far, RTL8188 drivers also seem to suffer from this. I'm not sure how to
>> fix all this properly, maybe Sebastian as original patch author can hel=
p
>> here.
> Suspecting isn't helping here.
Yes, you are right.
When I encountered this problem half a year ago, I tried some other type
of wifi stick
and immediately ran into trouble with this, too.

Now I did a short test with a RTL8188CUS stick, I could not reproduce
this bug with
this stick so far.

>
>> This patch is mostly for -stable, to get an acceptable solution quickly=
.
>> It was really annoying to get such unstable WIFI connection over the
>> last three kernel releases to my development board.=C2=A0 Since my inte=
rnet
>> service provider forcefully updated my router box 3 weeks ago, I
>> unfortunately see the same symptoms on my primary internet access.
>> That's even worse, I need to reset this router box every few days. I'm
>> not sure, however, that this is caused by the same problem, but it feel=
s
>> like this.
>> So can we please fix this regression quickly and workout a proper fix
>> later? In the original patch there is no reason given, why this patch i=
s
>> necessary. With this revert I at least see a stable connection.
> I will look into this. This patch got in in v4.20-rc1 and the final
> kernel was released by the end of 2018. This is the first report I am
> aware of over half year later=E2=80=A6
It is not easy to reproduce this bug reliably within a reasonable period
of time. It
took days to bisect this. And usb core code was for sure not my first
candidate
to look at.

Reverting this patch solves the problem, but of course disabling interrupt=
s
also can hide a bug elsewhere.

Soeren
