Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58B33A66A3
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 14:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbhFNMeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 08:34:25 -0400
Received: from 2.mo3.mail-out.ovh.net ([46.105.75.36]:50636 "EHLO
        2.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbhFNMeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 08:34:25 -0400
X-Greylist: delayed 2673 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jun 2021 08:34:25 EDT
Received: from player738.ha.ovh.net (unknown [10.110.103.115])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id CF5B028D4B8
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 13:47:48 +0200 (CEST)
Received: from RCM-web3.webmail.mail.ovh.net (static-176-175-108-40.ftth.abo.bbox.fr [176.175.108.40])
        (Authenticated sender: adel.ks@zegrapher.com)
        by player738.ha.ovh.net (Postfix) with ESMTPSA id 93BA21F3CE657;
        Mon, 14 Jun 2021 11:47:46 +0000 (UTC)
MIME-Version: 1.0
Date:   Mon, 14 Jun 2021 13:47:46 +0200
From:   adel.ks@zegrapher.com
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Kernel 5.12.10 and 5.12.9 freezing after boot-up with while sound
 output is looping
In-Reply-To: <b56d3d96-70d6-4ad5-9b8f-9b6fea958ad7@zegrapher.com>
References: <d086de2a793eb2ea52acb11ed143675c@zegrapher.com>
 <YMbmeRH38Wp6BHPf@kroah.com>
 <b56d3d96-70d6-4ad5-9b8f-9b6fea958ad7@zegrapher.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <f454b38b7987773caa72b656c4d2e3fb@zegrapher.com>
X-Sender: adel.ks@zegrapher.com
X-Originating-IP: 176.175.108.40
X-Webmail-UserID: adel.ks@zegrapher.com
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 4747919909701261173
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrfedvhedggedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepggffhffvufgjfhgfkfigihgtgfesthekjhdttderjeenucfhrhhomheprgguvghlrdhkshesiigvghhrrghphhgvrhdrtghomhenucggtffrrghtthgvrhhnpeeuleegteeuueeuleevjeejvdfgjefggeefleffteehieefueekheduffevgeetieenucfkpheptddrtddrtddrtddpudejiedrudejhedruddtkedrgedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeefkedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegruggvlhdrkhhsseiivghgrhgrphhhvghrrdgtohhmpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I decided to test first the ALSA changes, which happen to be the commits 
right after v5.12.8, and the very first commit of the series, `73d862c55 
ALSA: hda/realtek: the bass speaker can't output sound on Yoga 9i` made 
the freeze happen (although it took some time when compared to f3c23683d 
and 59ef5291f).

I am ready and willing to help further on the matter.

Kind regards,

Adel K.S.

On 2021-06-14 11:03, Adel Kara Slimane wrote:
> Hello,
> 
> Yes I can, I will do then report back. It will take me some time as I
> only know how to do it manually.
> 
> Thank you for your help,
> 
> Adel
> 
> Jun 14, 2021 07:17:59 Greg KH <gregkh@linuxfoundation.org>:
> 
>> On Sun, Jun 13, 2021 at 08:19:37PM +0200, adel.ks@zegrapher.com wrote:
>>> Hello,
>>> 
>>> I am encountering an issue where my system freezes entirely after a 
>>> random
>>> but short time after boot-up: the computer does not react to any user 
>>> input,
>>> be it mouse, keyboard or plugging-unplugging peripherals.  The image 
>>> on
>>> screen remains still and does not go black. Any sound that was 
>>> playing at
>>> the moment of the freeze loops indefinitely with a period of around 
>>> 1s. I
>>> have the intuition that the issue is sound related because of that.
>>> 
>>> Some additional information with this issue
>>> - Only happens only with the latest stable releases of the kernel:  
>>> 5.12.9
>>> and 5.12.10 . 5.12.8  does not have this issue. I have not tested 
>>> other
>>> kernel version, e.g. LTS 5.10 , to see if it's a change that got
>>> back-ported.
>> 
>> Any chance you can run 'git bisect' to find the offending change?
>> That's the easiest way to fix this up.
>> 
>> thanks,
>> 
>> greg k-h
