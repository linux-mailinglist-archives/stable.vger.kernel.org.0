Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEEDED059
	for <lists+stable@lfdr.de>; Sat,  2 Nov 2019 20:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfKBTU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Nov 2019 15:20:28 -0400
Received: from mx2.yrkesakademin.fi ([85.134.45.195]:45908 "EHLO
        mx2.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbfKBTU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Nov 2019 15:20:28 -0400
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Nov 2019 15:20:27 EDT
Subject: Re: Please backport 12e36d98d3e for 5.1+: iwlwifi: exclude GEO SAR
 support for 3168
To:     Luciano Coelho <luciano.coelho@intel.com>,
        Thomas Deutschmann <whissi@gentoo.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <7a5f833a-3183-6a64-cd35-80d131343089@gentoo.org>
 <c93083f278d810e1bebab40dcb1990e9285ee1f4.camel@intel.com>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <dce53d5b-eb19-cee0-5f0f-936c2199e929@mageia.org>
Date:   Sat, 2 Nov 2019 21:05:18 +0200
MIME-Version: 1.0
In-Reply-To: <c93083f278d810e1bebab40dcb1990e9285ee1f4.camel@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-WatchGuard-Spam-ID: str=0001.0A0C020A.5DBDD6FB.007A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WatchGuard-Spam-Score: 0, clean; 0, virus threat unknown
X-WatchGuard-Mail-Client-IP: 85.134.45.195
X-WatchGuard-Mail-From: tmb@mageia.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 02-11-2019 kl. 19:52, skrev Luciano Coelho:
> Hi Thomas,
> 
> On Sat, 2019-11-02 at 15:36 +0100, Thomas Deutschmann wrote:
>> Hi,
>>
>> please backport
>>
>> <<<<snip
>>  From 12e36d98d3e5acf5fc57774e0a15906d55f30cb9 Mon Sep 17 00:00:00 2001
>> From: Luca Coelho <luciano.coelho@intel.com>
>> Date: Tue, 8 Oct 2019 13:10:53 +0300
>> Subject: iwlwifi: exclude GEO SAR support for 3168
>>
>> We currently support two NICs in FW version 29, namely 7265D and 3168.
>> Out of these, only 7265D supports GEO SAR, so adjust the function that
>> checks for it accordingly.
>>
>> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>> Fixes: f5a47fae6aa3 ("iwlwifi: mvm: fix version check for
>> GEO_TX_POWER_LIMIT support")
>> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>> snap>>>
>>
>> This was the first patch of a 2 patch patch series. The second patch,
>> aa0cc7dde17 ("iwlwifi: pcie: change qu with jf devices to use qu
>> configuration") had "Cc: stable@vger.kernel.org # 5.1+" and was added.
>> The first one was missed.
> 
> I sent this earlier for stable v5.1, but it's EOL already, so it won't
> be merged there anymore.
> 


But it's still needed in the active 5.3 tree, and is already queued for 
4.19, and since 4.14 also loads api 29, it also needs it...

--
Thomas
