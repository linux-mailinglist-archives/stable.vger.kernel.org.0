Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E33C60D620
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 23:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbiJYV26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 17:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbiJYV25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 17:28:57 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2EB9B879;
        Tue, 25 Oct 2022 14:28:56 -0700 (PDT)
Received: from pps.filterd (m0297266.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PJrHPb023654;
        Tue, 25 Oct 2022 14:28:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=tLwCLy0yhYKhAHrYLhuBXfumznu76C7ytudAe0JnBzA=;
 b=PmeSI/1TYV+xG7myXjUzyMezi7w/+Bmt6Ul3ku9LeSBI5F8Ly0yoK/ysWgoOm51GunTP
 ynYuAyrtqSzUMAlwQ9Oz2TQuLpoeAALs4DtWbd7yMGx2jDgd6PdeglNXOjPwgyocay3S
 w7WYaK7KZ1Ru9EggaLiJG5WLe8YHLXTHv/ewsTPpFMa+SpfNTJnya3Xz8LUKAFc7YS5H
 1Xgl915PKceDF4KySfqpRWl8Ut62ssiPIbknAN7QHxEcaR9VbcXBeRJ1bWhdapVsegHT
 QlPQIb+Esgce8JqBQh52xccuyGOaJ+UWbbPKx1am/zccL215btFTnOWaJq1UNZaSyqqy Wg== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3kcfs7hcs5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 14:28:45 -0700
Received: from mailhost.synopsys.com (us03-mailhost2.synopsys.com [10.4.17.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D41BE400CE;
        Tue, 25 Oct 2022 21:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666733325; bh=tLwCLy0yhYKhAHrYLhuBXfumznu76C7ytudAe0JnBzA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=d7yjRZivnUDsz1KhHThvjiMgpJKTsnfmQVxwt9gfYqNj2y0LRfoXFT0kxlbF1ARNn
         AXJiV2YPnIU/oelb/DNntVkcj2M12e7E3Or2dDiPNkTfAvDAS6tiLmhiCaoCTwxLbq
         M4kR8p/8WnOKaWz+GaOHwrY5Pbn84tASzCqQmPWFhEK8CpwhoyWJtfWqs87sG+Sd9P
         pX+PmK0iE21mJBiAz66NZWSIMmjNC7khqsWKtoFNW1cKMhEbQ0PouA7otS2cu2f6JD
         GjW+8D2re3oz8qHWzGoPGrFK1K1MiC2OKWtnjUaQUy5YcZkuNZq2SiWOmu/Mn3/I/X
         nGL2QGP60QO+w==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 1EE06A0098;
        Tue, 25 Oct 2022 21:28:44 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 08528800DD;
        Tue, 25 Oct 2022 21:28:43 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="RYhFjb/1";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FphSOHAWCPmU0ikag89TmlqVOSiYbAkD5OKQgvIJgtBh8xCsOqxAjfuOAGE2aGVGZK2SrruN144oWMpAtJIS43GPVLNs8hfTK/DnLeCHJTHgwJWyXS9laDGVyfn3QF4mgZyRlccbHwAdP2K8Qhw7axSyFSn66xThaRJEEQcGF3ZEoG+EEbslgfXqLF+IJxcvUqtcAk1tM/QvXe6vNCX9lQpokDdPlVOk5reZ/0yLMp1ujg2YoeUaxaaXWMAZ00rb2iQOiUwZ42ntPtmn3Tjb/ppPnO31Q5zhU/1bFqPDWzlET7xpYItofkh8isq8st51ycQHMcMEMBf3Vj1nQ/xzsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tLwCLy0yhYKhAHrYLhuBXfumznu76C7ytudAe0JnBzA=;
 b=bcX0pxlqlhkv2fHfN8P+bk+l9c/73f/qx6ZrzFR93vJ8ui5pFQygkH1JBX8T1uN3Y66QrpejHyEX+LpPjaT+9Srx5c5txtR2anhACGaDOekqed54P6Q2CA/ZO16Lxm0LSVSMe1K13YlkXauB1kJqLepNef6thDUaEfZS1ykrY05fwZBxIeg3GOQBVcociNL9bYCnpBKFQXh59Atd12lu+ijgIA+YHA+l3mksjCsqfqGCvJ3u3RgJhipinJ5ZCErsa/id+XMDZbMKsGUd8L8Xz7AZZtpe7VUDqQpFDusky2vjfkkQntwv6Ori5R+oKz7QMhnAmog5VL51fKsPYuMj3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tLwCLy0yhYKhAHrYLhuBXfumznu76C7ytudAe0JnBzA=;
 b=RYhFjb/14OVl9iWXoGCnyO867ixvGj5Y6av3fB1uz7QrYUHmKB0+BtX5C1QY/Zbb8oOqwetQZkl6yzt9/GByqUY6Z+Qwxymn1vj0X1McyPz08hm+DqaJNBaj3mRf5QVfrQoQnWb0Fs1/SIaClfNJOruoJIcLhb01Iy7IAOfXCXs=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by PH7PR12MB5594.namprd12.prod.outlook.com (2603:10b6:510:134::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 21:28:39 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.031; Tue, 25 Oct 2022
 21:28:39 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Jeff Vanhoof <jdv1029@gmail.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dan Vacura <w36195@motorola.com>
Subject: Re: [PATCH v2 2/2] usb: dwc3: gadget: Don't set IMI for no_interrupt
Thread-Topic: [PATCH v2 2/2] usb: dwc3: gadget: Don't set IMI for no_interrupt
Thread-Index: AQHY6BEJdYD5PgC+60eX9aTbiKyHo64eitoAgAD/RoCAAA1DgIAACe2A
Date:   Tue, 25 Oct 2022 21:28:39 +0000
Message-ID: <20221025212829.dxgo3sxyjpqchl77@synopsys.com>
References: <cover.1666661013.git.Thinh.Nguyen@synopsys.com>
 <453f4dc3189eb855e31768d5caa6bfc7f4bf5074.1666661013.git.Thinh.Nguyen@synopsys.com>
 <20221025045148.GA15715@qjv001-XeonWs> <20221025200527.GA11641@qjv001-XeonWs>
 <20221025205257.7vibcudn46szd4lr@synopsys.com>
In-Reply-To: <20221025205257.7vibcudn46szd4lr@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|PH7PR12MB5594:EE_
x-ms-office365-filtering-correlation-id: 1661f334-db24-4445-640a-08dab6cfe203
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gApELZ1847HG/HC2UGXQmOEO2xaMstNrs1dDvNmQs8UxD7J9QtOmKgcRDx7It/OAVnxWWkYvTDsrDvMluCqwY7CNKVypQFAQYLf4WS8EDKzGnm7dJPaJhSEm5zpwTR3Iy54yr1or6UYxd9wrC69lKwRa0kuBBanomB0F8NlnBI2lqFver5SNjGsj2ebVg5JboVMri3RZ1sxF85sDMKU0PWQwpKsDkix3f8t+YLKfP/RmI6XWCTmfSC2na00qdvXhgXmYkHfyjVIVO36O95E5za0cVCSzuqBEjdEhGo74NVNVGKWNVHtgqTc6BSmhHphHHSdUtbHGe2yONSFHjmnuJJ9PyHokoy1EHraZpo30pReMvTDOeSj+3IB+MWlh95tW+tzzKn3y7/xYxMH3uOnjswz/Ie8zE3XhoknWbpvX3gN0tmvIg57jESOEq+RFhi0qw4fes6B/SNwwB9wVvk3uFleIfpW3cPzsbQLzZ2tzSTCDOexaE4l1p56o70FKk17elVEhHH6Idsd/a9UBK3i2Hwr2tUr8R0n5YTUOZh/wLIWF4AFGgD1srbZCBf5v+p8G7I+50EXnp2X8bsUNlEGIaPnFd4tSBYGRiLKFd+ew2Q94v6pcp5EsY+FyNuzHsGiu9Jm7jQCDQhJUdhJ5+weG9N5EhMoFRc0RXuGtNbIAgl0h8O5zmipr0LpiN0iWwp0GlC0k6bKeu4hdjVaID4Lyor6d2iKAkfxAqGIGi/02tlWqGPMInla2KpJmph9ZwRazAcsOX1GA3nh0jNRPwI7LKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(346002)(396003)(451199015)(2616005)(1076003)(38070700005)(83380400001)(41300700001)(38100700002)(86362001)(122000001)(6512007)(2906002)(66446008)(8936002)(54906003)(5660300002)(478600001)(6486002)(26005)(66946007)(66556008)(76116006)(71200400001)(316002)(8676002)(4326008)(64756008)(66476007)(186003)(6916009)(6506007)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?endhd3o0Y0huR0hpVCtwbDJvam1Odklha1lJOHZpRUhuOUEycGlPR0NmdVRk?=
 =?utf-8?B?NjlJNno0ZmxJeFJ3b2VrdVg0S0lhOUF2OGF0M2ZocmNwTHoraHNVemRJdUJZ?=
 =?utf-8?B?WEdlSDRvbGFMa2ZoblN0b1Q3a3EwUlg4S0dlNDYvMmg3dDREYjk5NFBuenJC?=
 =?utf-8?B?azJRTGF4MXBMUkIyRWlLanc0Q0QwenNQT1o4amJTNktLVjJya3FUZGEzeEIr?=
 =?utf-8?B?YWs3eWhUUklGaXB5Q1Y1YXJ6TlkzcWdnemFoeEhBZmpWaHFQR2RhY29OMG1F?=
 =?utf-8?B?VnEzQWhxeXE0QVU0R2I2K2F4ajJGR21mUGdvRGMyQU9TTG5GV2c4eVhuSk9n?=
 =?utf-8?B?U0lwUGY2ZS9QMzFvbTJMU2ZVMmVGdnJ6RW5jbmsyNzRROUhlTDV2SEZuTkdm?=
 =?utf-8?B?VDN5Ukt6YjFCb01RWjF0ZzYyWUh6ZUc0V3lxd0pvZmFKYjM0VjJoT3k4TVhz?=
 =?utf-8?B?ZURPZ2pMWjVXbHMvTHpSRThQZ3FKYmphem14VzA3a3NQd2xRa3cwNm1sT0tQ?=
 =?utf-8?B?dzJaS2ZucUxlMi9UQkFJQlBYcmx6b3FSRlJwNjJ5a2MrclBISEFwaEV3cVZi?=
 =?utf-8?B?cnR6NVhCUlRaUm5TMFpTblFOTmcyTTFISTRBcU1lMFlhbmZhTU9BUG9VMjRQ?=
 =?utf-8?B?RlF4SFpsRnk1Smg2elFMcHFrNm9sT2hYd3poUUlqSnRjajFmNzlOKzZnR0FQ?=
 =?utf-8?B?RHpPeXpGbTluNUZSTnk3enFoNTRpU2RmMG9WSVlaS0FtandPVzhGcVg5NDY1?=
 =?utf-8?B?TnAwaENobjgzNEgzR0RMU0JTRHZLb3JSSDF0YVNDdytGYWludTdjdmg2VTE4?=
 =?utf-8?B?SEtFNGZNeWZ0UVQwMGxwS1hWY0IvNlJacmNMenBJaGtlVFJ4b1ZXakdUM2FH?=
 =?utf-8?B?N05oUWhIUFNDTDVHb1RoWUZqRjdLbkVTaEhUQm1ER25mSEdDUkR1NGdWNldC?=
 =?utf-8?B?eUI3c1FUMkp0WncxTkpSUTMzUXl2VlhacThGWGhMbS8yZDd1djdsSXdReDE4?=
 =?utf-8?B?Q0p2eEhKbzc4VzFiQVhsU0VTMk1yOVpDSnBMSWNWQndhMkdVUlovd21ITDND?=
 =?utf-8?B?K0d6NUxlTkNHQWhrUm9ZV1E0SmNhS29RbVA4RFNxYjlBNkZMaU1WeVNHeURa?=
 =?utf-8?B?c09kODFKd3krUHpZTzk3VE1pN2hJRFpyOVYvUWlOM3JybmRWeS9tZkwvcSt4?=
 =?utf-8?B?Z2I3ZlpJTENZUUpPY2JoU0F4RWJDOU9ocVp1a0htM2RVUEczREtpUWsrYjAw?=
 =?utf-8?B?UDdDTXJ4WDR4MXVQNzR6Z1dLNlp5L0IwN2pDbW5aZUNLVlpsV0h4cHdTZnlE?=
 =?utf-8?B?Ky9uMFRFdUlpR0Flcmk3Vkw2VkJ5QVB5L3VMV2ZsZTN5Y2phdkhua1hjbm5m?=
 =?utf-8?B?bkhkRU9LVk1pdU10YTJBclQ0TGo1cElzMDFBTzBQOWcwc3UxZWFPMW5RQ1pL?=
 =?utf-8?B?VVo4MFQvdzJGRjNDYnpzcUI2SzBqWDdkRDZzaEhCdWhnaDdUMEJoc3hpQWUz?=
 =?utf-8?B?VEpTTERxa3JxdVJidzNZS0RVT0Y5RVJwek4zY2VDSGticEYvZEx6VWFvbkh2?=
 =?utf-8?B?UTlaY1F6VVZLejJyd3ZEaTd6eXJnUUd5Y2Vjb05SUFIxM1hRckg5MUtKb0sr?=
 =?utf-8?B?UzNwYzFqSncvYVdCdS9uUmdoRVBwNk56ZmJxb2Nxb0lmNzlxUXMxc1hxeU41?=
 =?utf-8?B?MnhsSWxlU2gvN3FqK1hpOER4enBwK3diTC9yeWFjVW1DVkFETGZ0NDlDdWQ0?=
 =?utf-8?B?aHFVaDd3TVU2dFlmc3ppeGFqNytnZVlGSTJxSjJwdFhUdkhZZGpxc2NnWDlw?=
 =?utf-8?B?eWd3Vk5RMFpqNEYrZTFxRXVXYlNtUmg3bWwxYXZkOGtFK1lMbWVPcjh1RUdt?=
 =?utf-8?B?Y21OYnIvVFpuYVE2QWdFc1JMYm9wUWdNTzlWRVorNU1IUkY2aDRmU1o5OXRZ?=
 =?utf-8?B?VXRNcmE4QzhQSWpLS1VGdnFpdjJ4RzlRYmpDaGF3ZUdwb3FLdnZBY2p3NTV0?=
 =?utf-8?B?R3d4MDdJS3hDaGdyN2RwbSs5VE9kaEJsd2taNjhLMnllV3MwUWc2eVFWWmNN?=
 =?utf-8?B?b1RsK0lHL0hoaXd3NEJIQUZNT2l6OHFVTnk0aXlFckZYVlJ3NGVPRXJ4akJR?=
 =?utf-8?Q?lofz5NIqqHcq14MgMOizj46es?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7ABB398024483E4DAD782D4674E9907F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1661f334-db24-4445-640a-08dab6cfe203
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 21:28:39.2392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GnNfmkbnWHIl39UNFyMTMHzCitKdoQRdZxpDtz7Od5gGZUoAjK6ymXCsfVHXgOrzvzjaIcEOsboGAeG3wurnIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5594
X-Proofpoint-GUID: mxUfp0nbgRKtb5M4BuUT91MDb6kRMTVa
X-Proofpoint-ORIG-GUID: mxUfp0nbgRKtb5M4BuUT91MDb6kRMTVa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_13,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0
 adultscore=0 mlxlogscore=945 spamscore=0 clxscore=1015 suspectscore=0
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210250119
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCBPY3QgMjUsIDIwMjIsIFRoaW5oIE5ndXllbiB3cm90ZToNCj4gT24gVHVlLCBPY3Qg
MjUsIDIwMjIsIEplZmYgVmFuaG9vZiB3cm90ZToNCj4gPiBIaSBUaGluaCwNCj4gPiANCj4gPiBP
biBNb24sIE9jdCAyNCwgMjAyMiBhdCAxMTo1MTo1MFBNIC0wNTAwLCBKZWZmIFZhbmhvb2Ygd3Jv
dGU6DQo+ID4gPiBPbiBNb24sIE9jdCAyNCwgMjAyMiBhdCAwNjoyODowNFBNIC0wNzAwLCBUaGlu
aCBOZ3V5ZW4gd3JvdGU6DQo+ID4gPiA+IFRoZSBnYWRnZXQgZHJpdmVyIG1heSBoYXZlIGEgY2Vy
dGFpbiBleHBlY3RhdGlvbiBvZiBob3cgdGhlIHJlcXVlc3QNCj4gPiA+ID4gY29tcGxldGlvbiBm
bG93IHNob3VsZCBiZSBmcm9tIHRvIGl0cyBjb25maWd1cmF0aW9uLiBNYWtlIHN1cmUgdGhlDQo+
ID4gPiA+IGNvbnRyb2xsZXIgZHJpdmVyIHJlc3BlY3QgdGhhdC4gVGhhdCBpcywgZG9uJ3Qgc2V0
IElNSSAoSW50ZXJydXB0IG9uDQo+ID4gPiA+IE1pc3NlZCBJc29jKSB3aGVuIHVzYl9yZXF1ZXN0
LT5ub19pbnRlcnJ1cHQgaXMgc2V0Lg0KPiA+ID4gPiANCj4gPiA+ID4gRml4ZXM6IDcyMjQ2ZGE0
MGYzNyAoInVzYjogSW50cm9kdWNlIERlc2lnbldhcmUgVVNCMyBEUkQgRHJpdmVyIikNCj4gPiA+
ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogVGhp
bmggTmd1eWVuIDxUaGluaC5OZ3V5ZW5Ac3lub3BzeXMuY29tPg0KPiA+ID4gPiAtLS0NCj4gPiA+
ID4gIENoYW5nZXMgaW4gdjI6DQo+ID4gPiA+ICAtIE5vbmUNCj4gPiA+ID4gDQo+ID4gPiA+ICBk
cml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jIHwgNCArKy0tDQo+ID4gPiA+ICAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+ID4gPiANCj4gPiA+ID4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMgYi9kcml2ZXJzL3VzYi9kd2MzL2dh
ZGdldC5jDQo+ID4gPiA+IGluZGV4IDIzMGIzYzY2MDA1NC4uNzAyYmRmNDJhZDJmIDEwMDY0NA0K
PiA+ID4gPiAtLS0gYS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+ID4gPiA+ICsrKyBiL2Ry
aXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4gPiA+ID4gQEAgLTEyOTIsOCArMTI5Miw4IEBAIHN0
YXRpYyB2b2lkIGR3YzNfcHJlcGFyZV9vbmVfdHJiKHN0cnVjdCBkd2MzX2VwICpkZXAsDQo+ID4g
PiA+ICAJCQl0cmItPmN0cmwgPSBEV0MzX1RSQkNUTF9JU09DSFJPTk9VUzsNCj4gPiA+ID4gIAkJ
fQ0KPiA+ID4gPiAgDQo+ID4gPiA+IC0JCS8qIGFsd2F5cyBlbmFibGUgSW50ZXJydXB0IG9uIE1p
c3NlZCBJU09DICovDQo+ID4gPiA+IC0JCXRyYi0+Y3RybCB8PSBEV0MzX1RSQl9DVFJMX0lTUF9J
TUk7DQo+ID4gPiA+ICsJCWlmICghcmVxLT5yZXF1ZXN0Lm5vX2ludGVycnVwdCkNCj4gPiA+ID4g
KwkJCXRyYi0+Y3RybCB8PSBEV0MzX1RSQl9DVFJMX0lTUF9JTUk7DQo+ID4gPiA+ICAJCWJyZWFr
Ow0KPiA+ID4gPiAgDQo+ID4gPiA+ICAJY2FzZSBVU0JfRU5EUE9JTlRfWEZFUl9CVUxLOg0KPiA+
ID4gPiAtLSANCj4gPiA+ID4gMi4yOC4wDQo+ID4gPiA+DQo+ID4gPiANCj4gPiA8c25pcD4NCj4g
PiANCj4gPiBGb3Igc2NhdHRlciBnYXRoZXIsIHNob3VsZG4ndCB0aGUgSU1JIGJpdCBiZSBzZXQg
b25seSBmb3IgdGhlIFRSQiBhc3NvY2lhdGVkDQo+ID4gdG8gdGhlIGxhc3QgaXRlbSBpbiB0aGUg
c2cgbGlzdD8gIERvIHdlIG5lZWQgdG8gZG8gc29tZXRoaW5nIHNpbWlsYXIgdG8gd2hhdA0KPiA+
IHRoYXQgd2FzIGRvbmUgZm9yIElPQyBpbiB0aGlzIGFyZWE/DQo+ID4gDQo+ID4gRm9yIGV4LjoN
Cj4gPiArCWlmICgoIXJlcS0+cmVxdWVzdC5ub19pbnRlcnJ1cHQgJiYgIWNoYWluKSB8fCBtdXN0
X2ludGVycnVwdCkNCj4gPiArCQl0cmItPmN0cmwgfD0gRFdDM19UUkJfQ1RSTF9JU1BfSU1JOw0K
PiA+IA0KPiA+IEJUVywgRGFuIGluZGljYXRlZCB0aGF0IHRoaXMgc2VlbXMgdG8gaGVscCByZXNv
bHZlIHRoZSBjcmFzaCBtZW50aW9uZWQgaW4NCj4gPiBbUEFUQ0ggdjIgMS8yXSBvZiB0aGlzIGNo
YWluLg0KPiA+IA0KPiANCj4gQWN0dWFsbHksIHRoYXQncyBjb3JyZWN0LiBKdXN0IGlnbm9yZSB0
aGUgIm11c3RfaW50ZXJydXB0IiBzZXR0aW5nLiBUaGUNCj4gcHJvZ3JhbW1pbmcgZ3VpZGUgYWN0
dWFsbHkgbm90ZWQgdG8gc2V0IHRoZSBJTUkgZm9yIHRoZSBsYXN0IFRSQiBvZiB0aGUNCj4gY2hh
aW4gYWxzby4NCj4gDQo+IEknbGwgc2VuZCBhIGZpeCB0byB0aGlzLg0KPiANCg0KSG0uLi4gSSB3
b25kZXIgaWYgaXQncyBzdGlsbCBiZXR0ZXIgdG8gaWdub3JlIG5vX2ludGVycnVwdCBhbmQNCmlt
bWVkaWF0ZWx5IG5vdGlmeSB0aGUgZ2FkZ2V0IGRyaXZlciBvZiBtaXNzZWQgaXNvYy4gSXQncyBy
ZWR1bmRhbnQgdG8NCmhhdmUgYm90aCBJT0MgYW5kIElNSSBzZXQgdW5kZXIgdGhlIHNhbWUgY29u
ZGl0aW9uLCBidXQgSSBndWVzcyBpdA0KZG9lc24ndCBodXJ0IHRvIHNldCBpdCBmb3IgY2xhcml0
eS4NCg0KU28gaXQncyBlaXRoZXINCglpZiAoIW5vX2ludGVycnVwdCAmJiAhY2hhaW4pDQoJCXRy
Yi0+Y3RybCB8PSBEV0MzX1RSQl9DVFJMX0lTUF9JTUk7DQpvcg0KCWlmICghY2hhaW4pDQoJCXRy
Yi0+Y3RybCB8PSBEV0MzX1RSQl9DVFJMX0lTUF9JTUk7DQoNCkVpdGhlciB3YXksIHRoaXMgbmVl
ZHMgYSBmaXguDQoNClRoYW5rcywNClRoaW5o
