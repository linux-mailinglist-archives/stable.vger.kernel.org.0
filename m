Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F7B588043
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 18:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiHBQ3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 12:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiHBQ3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 12:29:48 -0400
X-Greylist: delayed 601 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 02 Aug 2022 09:29:46 PDT
Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.61.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BCF3A480;
        Tue,  2 Aug 2022 09:29:46 -0700 (PDT)
Received: from mors-relay-8403.netcup.net (localhost [127.0.0.1])
        by mors-relay-8403.netcup.net (Postfix) with ESMTPS id 4Ly0Qf2HnFz7vmT;
        Tue,  2 Aug 2022 18:13:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jonathanweth.de;
        s=key2; t=1659456794;
        bh=g+aUoZtn9lkTEhcQ9iJURvNaO6BxMn2nDpOE4kZeFMo=;
        h=Date:To:Cc:References:Subject:From:In-Reply-To:From;
        b=EnVTvE6E0PMaoeUNFZZxX+gqj1gabeWI23TA1v96p8fdFZlQOgxA1vdevdDdtryrz
         G5pNif1ZFCGLK7ebLV6OtugrRDR1u99tRD3HRWA4bUyWs9Wy3RXILudm3QMzCM1tqF
         RHNH7GEHFLC0p6nTJT2I1KhVsev8VqhPDM/wHb5RwozLvjeP8oPRWbyCaFaUUvJecf
         EXILQmN+UlosRoGKoFaI0Ow1P++LAOPLLheJ7fNObmxT2Iev3uCEP2LLJrALyjh1rB
         Efzg7aSWAk87+K0uLJfKERQgDMuBbAHO5N1gOmoRgRpWF5ydELnWZDy0aGEdqlLDyc
         6G1crlFcqv2gQ==
Received: from policy02-mors.netcup.net (unknown [46.38.225.53])
        by mors-relay-8403.netcup.net (Postfix) with ESMTPS id 4Ly0Qf1vLbz7vmR;
        Tue,  2 Aug 2022 18:13:14 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at policy02-mors.netcup.net
X-Spam-Score: -2.9
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
Received: from mx2f71.netcup.net (unknown [10.243.12.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by policy02-mors.netcup.net (Postfix) with ESMTPS id 4Ly0Qd18m7z8sZR;
        Tue,  2 Aug 2022 18:13:13 +0200 (CEST)
Received: from [192.168.1.195] (unknown [83.139.202.244])
        by mx2f71.netcup.net (Postfix) with ESMTPSA id 5687C62372;
        Tue,  2 Aug 2022 18:13:11 +0200 (CEST)
Authentication-Results: mx2f71;
        spf=pass (sender IP is 83.139.202.244) smtp.mailfrom=dev@jonathanweth.de smtp.helo=[192.168.1.195]
Received-SPF: pass (mx2f71: connection is authenticated)
Message-ID: <b30e2fd3-55a4-b4fa-e72d-54dc6b22af82@jonathanweth.de>
Date:   Tue, 2 Aug 2022 18:13:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To:     larry.finger@lwfinger.net
Cc:     gustavo@padovan.org, hildawu@realtek.com, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        stable@vger.kernel.org
References: <20210927204302.10871-1-Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bluetooth: Add another Bluetooth part for Realtek 8852AE
Content-Language: de-DE
From:   Jonathan Weth <dev@jonathanweth.de>
In-Reply-To: <20210927204302.10871-1-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <165945679271.30739.4803581689034896251@mx2f71.netcup.net>
X-PPP-Vhost: jonathanweth.de
X-NC-CID: RkBhufbiRBTzb1jrhoWfaRfcT037wlDn3Hp8M//0N5TJJi+7
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi everyone,

>> This Realtek device has both wifi and BT components. The latter reports
>> a USB ID of 0bda:4852, which is not in the table.
>> 
>> The portion of /sys/kernel/debug/usb/devices pertaining to this device is
>> 
>> T:  Bus=06 Lev=01 Prnt=01 Port=03 Cnt=02 Dev#=  3 Spd=12   MxCh= 0
>> D:  Ver= 1.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
>> P:  Vendor=0bda ProdID=4852 Rev= 0.00
>> S:  Manufacturer=Realtek
>> S:  Product=Bluetooth Radio
>> S:  SerialNumber=00e04c000001
>> C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
>> I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
>> E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
>> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
>> I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
>> I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
>> I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
>> I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
>> I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
>> I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
>> 
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Stable <stable@vger.kernel.org>
>> ---
>> drivers/bluetooth/btusb.c | 2 ++
>> 1 file changed, 2 insertions(+)
> 
> patch does not apply cleanly to bluetooth-next tree.

Is there any progress according to this fix? I would like to help as 
this prevents my bluetooth interface from working but I actually don't 
know how.

Regards

Jonathan

-- 
Jonathan Weth
mail@jonathanweth.de
