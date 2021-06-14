Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD443A652F
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbhFNLfF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 14 Jun 2021 07:35:05 -0400
Received: from 7.mo2.mail-out.ovh.net ([188.165.48.182]:35897 "EHLO
        7.mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhFNLcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 07:32:33 -0400
X-Greylist: delayed 8802 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jun 2021 07:32:32 EDT
Received: from player778.ha.ovh.net (unknown [10.110.171.96])
        by mo2.mail-out.ovh.net (Postfix) with ESMTP id D31CD20D783
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 11:03:46 +0200 (CEST)
Received: from zegrapher.com (static-176-175-108-40.ftth.abo.bbox.fr [176.175.108.40])
        (Authenticated sender: adel.ks@zegrapher.com)
        by player778.ha.ovh.net (Postfix) with ESMTPSA id 3CB821F24F971;
        Mon, 14 Jun 2021 09:03:44 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-102R004c63f1684-746c-421c-9661-91e17fa95fc5,
                    946D958682469A78D70B9269846191D1BA8514F5) smtp.auth=adel.ks@zegrapher.com
X-OVh-ClientIp: 176.175.108.40
Date:   Mon, 14 Jun 2021 09:03:41 +0000 (UTC)
From:   Adel Kara Slimane <adel.ks@zegrapher.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Message-ID: <b56d3d96-70d6-4ad5-9b8f-9b6fea958ad7@zegrapher.com>
In-Reply-To: <YMbmeRH38Wp6BHPf@kroah.com>
References: <d086de2a793eb2ea52acb11ed143675c@zegrapher.com> <YMbmeRH38Wp6BHPf@kroah.com>
Subject: Re: Kernel 5.12.10 and 5.12.9 freezing after boot-up with while
 sound output is looping
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Correlation-ID: <b56d3d96-70d6-4ad5-9b8f-9b6fea958ad7@zegrapher.com>
X-Ovh-Tracer-Id: 1977643188722636661
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrfedvhedgtdejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffkjghfufggtgfgsehtqhertddttdejnecuhfhrohhmpeetuggvlhcumfgrrhgrucfulhhimhgrnhgvuceorgguvghlrdhkshesiigvghhrrghphhgvrhdrtghomheqnecuggftrfgrthhtvghrnhepuddvgfevudelveeguedtkedvjedvgeevgeeigeeihfeglefhvddtgeffffegtdeinecukfhppedtrddtrddtrddtpddujeeirddujeehrddutdekrdegtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejjeekrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheprgguvghlrdhkshesiigvghhrrghphhgvrhdrtghomhdprhgtphhtthhopehsthgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Yes I can, I will do then report back. It will take me some time as I only know how to do it manually.

Thank you for your help,

Adel

Jun 14, 2021 07:17:59 Greg KH <gregkh@linuxfoundation.org>:

> On Sun, Jun 13, 2021 at 08:19:37PM +0200, adel.ks@zegrapher.com wrote:
>> Hello,
>> 
>> I am encountering an issue where my system freezes entirely after a random
>> but short time after boot-up: the computer does not react to any user input,
>> be it mouse, keyboard or plugging-unplugging peripherals.  The image on
>> screen remains still and does not go black. Any sound that was playing at
>> the moment of the freeze loops indefinitely with a period of around 1s. I
>> have the intuition that the issue is sound related because of that.
>> 
>> Some additional information with this issue
>> - Only happens only with the latest stable releases of the kernel:  5.12.9
>> and 5.12.10 . 5.12.8  does not have this issue. I have not tested other
>> kernel version, e.g. LTS 5.10 , to see if it's a change that got
>> back-ported.
> 
> Any chance you can run 'git bisect' to find the offending change?
> That's the easiest way to fix this up.
> 
> thanks,
> 
> greg k-h
