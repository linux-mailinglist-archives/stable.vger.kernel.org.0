Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9943AE752
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhFUKm3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 21 Jun 2021 06:42:29 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:40791 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhFUKm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:42:28 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 15LAe2mE5007015, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 15LAe2mE5007015
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 21 Jun 2021 18:40:02 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 21 Jun 2021 18:40:01 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 21 Jun 2021 18:40:01 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::a0a3:e64a:34ad:fe28]) by
 RTEXMBS04.realtek.com.tw ([fe80::a0a3:e64a:34ad:fe28%5]) with mapi id
 15.01.2106.013; Mon, 21 Jun 2021 18:40:01 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Subject: RE: [PATCH v2] rtw88: Fix some memory leaks
Thread-Topic: [PATCH v2] rtw88: Fix some memory leaks
Thread-Index: AQHXZgxATtcHECM3iE6itZ90Mb4OaaseRfiQ
Date:   Mon, 21 Jun 2021 10:40:01 +0000
Message-ID: <19c86cb8dbe04b56b76a386b5faeaa89@realtek.com>
References: <20210620194110.7520-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20210620194110.7520-1-Larry.Finger@lwfinger.net>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/6/21_=3F=3F_08:47:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/21/2021 10:15:36
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164498 [Jun 21 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;lore.kernel.org:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/21/2021 10:18:00
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Larry Finger [mailto:larry.finger@gmail.com] On Behalf Of Larry Finger
> Sent: Monday, June 21, 2021 3:41 AM
> To: kvalo@codeaurora.org
> Cc: linux-wireless@vger.kernel.org; Larry Finger; Stable
> Subject: [PATCH v2] rtw88: Fix some memory leaks
> 
> There are memory leaks of skb's from routines rtw_fw_c2h_cmd_rx_irqsafe()
> and rtw_coex_info_response(), both arising from C2H operations. There are
> no leaks from the buffers sent to mac80211.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>
> ---
> v2 - add the missinf changelog.
> 
> ---
>  drivers/net/wireless/realtek/rtw88/coex.c | 4 +++-
>  drivers/net/wireless/realtek/rtw88/fw.c   | 2 ++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
> index cedbf3825848..e81bf5070183 100644
> --- a/drivers/net/wireless/realtek/rtw88/coex.c
> +++ b/drivers/net/wireless/realtek/rtw88/coex.c
> @@ -591,8 +591,10 @@ void rtw_coex_info_response(struct rtw_dev *rtwdev, struct sk_buff *skb)
>  	struct rtw_coex *coex = &rtwdev->coex;
>  	u8 *payload = get_payload_from_coex_resp(skb);
> 
> -	if (payload[0] != COEX_RESP_ACK_BY_WL_FW)
> +	if (payload[0] != COEX_RESP_ACK_BY_WL_FW) {
> +		dev_kfree_skb_any(skb);
>  		return;
> +	}
> 
>  	skb_queue_tail(&coex->queue, skb);
>  	wake_up(&coex->wait);
> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
> index 797b08b2a494..43525ad8543f 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.c
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> @@ -231,9 +231,11 @@ void rtw_fw_c2h_cmd_rx_irqsafe(struct rtw_dev *rtwdev, u32 pkt_offset,
>  	switch (c2h->id) {
>  	case C2H_BT_MP_INFO:
>  		rtw_coex_info_response(rtwdev, skb);
> +		dev_kfree_skb_any(skb);

The rtw_coex_info_response() puts skb into a skb_queue, so we can't free it here.
Instead, we should free it after we dequeue and do thing. 
So, we send another patch: 
https://lore.kernel.org/linux-wireless/20210621103023.41928-1-pkshih@realtek.com/T/#u

I hope this isn't confusing you.


>  		break;
>  	case C2H_WLAN_RFON:
>  		complete(&rtwdev->lps_leave_check);
> +		dev_kfree_skb_any(skb);
>  		break;
>  	default:
>  		/* pass offset for further operation */
> --
> 2.32.0

--
Ping-Ke

