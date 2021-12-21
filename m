Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939E447C0F6
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 14:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235515AbhLUNox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 08:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234681AbhLUNow (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 08:44:52 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E5CC06173F;
        Tue, 21 Dec 2021 05:44:52 -0800 (PST)
Received: from ip4d173d4a.dynamic.kabel-deutschland.de ([77.23.61.74] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1mzfRe-0000yG-Re; Tue, 21 Dec 2021 14:44:46 +0100
Message-ID: <57cd1e60-f412-8439-2c5f-3f38824d9c74@leemhuis.info>
Date:   Tue, 21 Dec 2021 14:44:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v10 2/2] btbcm: disable read tx power for some Macs with
 the T2 Security chip
Content-Language: en-BS
To:     Marcel Holtmann <marcel@holtmann.org>,
        Aditya Garg <gargaditya08@live.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Daniel Winkler <danielwinkler@google.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sonnysasaka@chromium.org" <sonnysasaka@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <3B8E16FA-97BF-40E5-9149-BBC3E2A245FE@live.com>
 <40550C00-4EE5-480F-AFD4-A2ACA01F9DBB@live.com>
 <332a19f1-30f0-7058-ac18-c21cf78759bb@leemhuis.info>
 <D9375D91-1062-4265-9DE9-C7CF2B705F3F@live.com>
 <BC534C52-7FCF-4238-8933-C5706F494A11@live.com> <YaSCJg+Xkyx8w2M1@kroah.com>
 <287DE71A-2BF2-402D-98C8-24A9AEEE55CB@live.com>
 <42E2EC08-1D09-4DDE-B8B8-7855379C23C5@holtmann.org>
 <6ABF3770-A9E8-4DAF-A22D-DA7113F444F3@live.com>
 <92FBACD6-F4F2-4DE8-9000-2D30852770FC@live.com>
 <3716D644-CD1B-4A5C-BC96-A51FF360E31D@live.com>
 <9E6473A2-2ABE-4692-8DCF-D8F06BDEAE29@live.com>
 <64E15BD0-665E-471F-94D9-991DFB87DEA0@live.com>
 <A6DD9616-E669-4382-95A0-B9DBAF46712D@live.com>
 <312202C7-C7BE-497D-8093-218C68176658@live.com>
 <CDAA8BE2-F2B0-4020-AEB3-5C9DD4A6E08C@live.com>
 <3F7CFEF0-10D6-4046-A3AE-33ECF81A2EB3@live.com>
 <DCEC0C45-D974-4DC7-9E86-8F2D3D8F7E1D@live.com>
 <51575680-E9C3-4962-A3C4-ADCBD6DBCA00@live.com>
 <BF89065D-FE7B-4E57-BFEF-DEACC67C25AB@holtmann.org>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <BF89065D-FE7B-4E57-BFEF-DEACC67C25AB@holtmann.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1640094292;e3ceae96;
X-HE-SMSGID: 1mzfRe-0000yG-Re
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this once again is your Linux kernel regression tracker speaking.

On 03.12.21 22:28, Marcel Holtmann wrote:

>> Some Macs with the T2 security chip had Bluetooth not working.
>> To fix it we add DMI based quirks to disable querying of LE Tx power.
>>
>> Signed-off-by: Aditya Garg <gargaditya08@live.com>
>> Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
>> Tested-by: Orlando Chamberlain <redecorating@protonmail.com>
>> Link:
>> https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmail.com
>> Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")

If anyone wonders: this was for v5.11-rc1.

>> Cc: stable@vger.kernel.org
>> ---
>> v7 :- Removed unused variable and added Tested-by.
>> v8 :- No change.
>> v9 :- Add Cc: stable@vger.kernel.org
>> v10 :- Fix gitlint
>> drivers/bluetooth/btbcm.c | 39 +++++++++++++++++++++++++++++++++++++++
>> 1 file changed, 39 insertions(+)
> 
> patch has been applied to bluetooth-next tree.
And there are these two pages now for 19 days. What's the hold-up? Or do
you consider the changes to dangerous to merge now?

Sure, it's not a recent regression, so it might not look that urgent.
But it OTOH affects everyone that can't go back to v5.10 (the newest
Longterm kernel without the regression) -- for example if a user needs a
post-v5.10 feature or upgrades to a distro with a newer kernel.

That's why this fix (unless you considerer it to dangerous) IMHO should
be merged rather sooner than later and and not wait for the merge window
of v5.17. Another aspect against waiting for the next merge window: it
contributes to piling up a large number of changes that need to be
backported to stable and longterm kernels once v5.17-rc1 is out,
resulting in stable and longterm releases with a huge pile of changes:
https://lwn.net/Articles/863505/

Ciao, Thorsten

#regzbot poke
