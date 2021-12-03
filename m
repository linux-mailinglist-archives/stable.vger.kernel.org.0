Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D65C467F4F
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 22:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240593AbhLCVbd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 3 Dec 2021 16:31:33 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:59340 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233581AbhLCVbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 16:31:33 -0500
Received: from smtpclient.apple (p5b3d2e91.dip0.t-ipconnect.de [91.61.46.145])
        by mail.holtmann.org (Postfix) with ESMTPSA id 48360CED20;
        Fri,  3 Dec 2021 22:28:07 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH v10 2/2] btbcm: disable read tx power for some Macs with
 the T2 Security chip
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <51575680-E9C3-4962-A3C4-ADCBD6DBCA00@live.com>
Date:   Fri, 3 Dec 2021 22:28:06 +0100
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Daniel Winkler <danielwinkler@google.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sonnysasaka@chromium.org" <sonnysasaka@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <BF89065D-FE7B-4E57-BFEF-DEACC67C25AB@holtmann.org>
References: <3B8E16FA-97BF-40E5-9149-BBC3E2A245FE@live.com>
 <YZSuWHB6YCtGclLs@kroah.com> <52DEDC31-EEB2-4F39-905F-D5E3F2BBD6C0@live.com>
 <8919a36b-e485-500a-2722-529ffa0d2598@leemhuis.info>
 <20211117124717.12352-1-redecorating@protonmail.com>
 <F8D12EA8-4B37-4887-998E-DC0EBE60E730@holtmann.org>
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
To:     Aditya Garg <gargaditya08@live.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Aditya,

> Some Macs with the T2 security chip had Bluetooth not working.
> To fix it we add DMI based quirks to disable querying of LE Tx power.
> 
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
> Tested-by: Orlando Chamberlain <redecorating@protonmail.com>
> Link:
> https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmail.com
> Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")
> Cc: stable@vger.kernel.org
> ---
> v7 :- Removed unused variable and added Tested-by.
> v8 :- No change.
> v9 :- Add Cc: stable@vger.kernel.org
> v10 :- Fix gitlint
> drivers/bluetooth/btbcm.c | 39 +++++++++++++++++++++++++++++++++++++++
> 1 file changed, 39 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

