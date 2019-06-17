Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D761747F59
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 12:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfFQKMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 06:12:50 -0400
Received: from mout.web.de ([212.227.15.3]:41211 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbfFQKMu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 06:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1560766362;
        bh=q+h39yDvvSNL+SgiMUGG7w9Yz/Of7I+1llmhplJontA=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=JNOf3RhidKxrPouxBQ3BTTJlOb/ZGm4K+1RdBMoY4Xfq452zwJJ6Mn/GctLYh6mnh
         0wqHgTxDghZhXDCVwKg7U1DVse3IXRAXYzCjBYk3lwZSmP5jCl8VIKzzlxDew0zcUs
         D4TTxxXYK8RmvLU+2tnZ2k59t1sCnwnWzk6vOAmI=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.43.108] ([89.15.236.75]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MVLY6-1i851r34hS-00YenX; Mon, 17
 Jun 2019 12:12:41 +0200
Subject: Re: [PATCH] Revert "usb: core: remove local_irq_save() around
 ->complete() handler"
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Stern <stern@rowland.harvard.edu>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, tglx@linutronix.de
References: <fb64b378-57a1-19f4-0fd2-1689fc3d8540@web.de>
 <Pine.LNX.4.44L0.1906121033550.1557-100000@iolanthe.rowland.org>
 <20190612144747.mf7hwunsl2zi3uxo@linutronix.de>
From:   Soeren Moch <smoch@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=smoch@web.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <23aebb29-db6f-95fb-5cad-10d9b45fcd57@web.de>
Date:   Mon, 17 Jun 2019 12:12:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190612144747.mf7hwunsl2zi3uxo@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:PGp1o0jtTntZX7rwyZPvnLipaN+uj3WeDVUw+W1cjw9qqbjHsBr
 L8g5vl7O2h/MI3kawIXFmO2e84NKM0Evx80wGXOBky3aHAYy1YyiU5mg/NSP7eWs1Z9LPd8
 /rrlBA/EP+uj3JIzXQg4L/y/PYDB3bfiPaGoTtDX1nKHC42nHNmjVF56i+B6VUmBhUIxVW6
 ApGyfsi9MDZisP1HcnL8g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0+HlxvSAQXc=:+6pGruXVO9GFALCdjc9CTa
 7gPuC8N48/gyazW4sBaJAWvQ1MP+n9J6PRdmcdzd7MbSxl7Q5Pw5VJxUhs8SjzIFnfc7ubNmt
 ZMMl/4Wm+McbnZEv/7mGIlc22XH7TshU63cYNBCjK4RawSF05YrvH4MScV04kBOYyV/zsCf/+
 6lVdTQwexgCX2RVCPMbKWQ36nt03hJhTplGkIXhp2YVnWjfu0qeihcWybLWxauXyJQ5kIdJav
 14se91fsDbqy0t2HYq1RqT7VNW+4QhfyxBSKE/uz1wGMu6nh9KwtL/9Qx4MEAkX8HCviIqe7+
 9CXeMV5SrxVogAoQBcxXBVridDQ3w//PSU82eVzzBuDONibN4UDlUsRL9cLtJtYcj54jnJsba
 3279+uRZQNgL0yqhb1CuXiQEY794j7lFJCYMQ8VLAvMs4+kkd4OeE/iVl+OcU1FYuue4jBEFQ
 /Gn7s4xqcGPh8mIb2pCPoufgw+aAvhx8oiF4KyjkgmD+zmM5HBoU6pfDZg0Mit6nWzStE+rih
 JeV43uh5FiDnv4QMC1oHEA5Ukb5t4e699mi9IdHEwGuJzIqj9W2pAQzR+pRh20WqQ9UA2B5Oo
 l5p4JrnJto0fjyfuecnsxZxAGMcdkgrhvpKs8vWuWX1SCiSD0EOIfqCHiPW6DFoL+ML/fuJS5
 defI23sqxqdZahYq9/wwRAUJoP6+2w1dueuHGALNZXux/wJ/jZUVGgUQ9kUJwyyW66w/pyDqF
 VoS0gIogjtrsc2uvJf58ZODngODCIxmB141syBuUzI2PH8JMLllEWx3npZoT+Vbe5F8CiI3eM
 mDLsJzrHjsF/92/4aBrZhr01784+dfsZ/7AJBxNYUyIWzkrgt1NJw91qpVhh0+cooEiF7Yycq
 jZXctxdXOxoS/9WmxdsCO/KTEnBV+3v6lk+1lSMhvEvvnGGvea13c4MlA0At5RsAAVlwiarkF
 TRsi+0FpX332Bg5hSs9KDxtaFuqdjPGU=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12.06.19 16:47, Sebastian Andrzej Siewior wrote:
> On 2019-06-12 10:38:11 [-0400], Alan Stern wrote:
>>> When stopping hostapd after it hangs:
>>> [  903.504475] ieee80211 phy0: rt2x00queue_flush_queue: Warning - Que=
ue
>>> 14 failed to flush
>> Instead of reverting the original commit, can you prevent the problem =

>> by adding local_irq_save() and local_irq_restore() to the URB=20
>> completion routines in that wireless driver?
>>
>> Probably people who aren't already pretty familiar with the driver cod=
e
>> won't easily be able to locate the race.  Still, a little overkill may=

>> be an acceptable solution.
> Not from RT point of view because you do
> 	local_irq_save() -> spin_lock()
>
> but it might be worth checking if the local_irq_save() within that
> wireless driver avoids the race or not.
I just sent a patch for the underlying problem in the rt2x00 driver, see
[1].
So we can drop this patch here and keep RT folks happy.
I really hope that no other usb drivers are affected by similar problems.=


Zyxel support just sent me (some?) source code for the firmware of my
internet router (my real problem I mentioned before). Need to look into
this...

Thanks for your help,
Soeren


[1] https://lkml.org/lkml/2019/6/17/238
>> Alan Stern
> Sebastian


