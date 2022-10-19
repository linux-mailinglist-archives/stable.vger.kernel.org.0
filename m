Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4698B6053D1
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 01:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJSXRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 19:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiJSXRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 19:17:01 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF471A0C03;
        Wed, 19 Oct 2022 16:16:58 -0700 (PDT)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JKTu2i002061;
        Wed, 19 Oct 2022 16:16:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=CH8Su9EGry40V379cicqzqVSzZzzesFicqqgc2NPUpY=;
 b=t8oeBqRT53z3qePfJgnmEHYvas4kpXgY/ZpZHyufYIgn7cLNX0bdEYgA166vGMWlxkpK
 en8U3h1S/qMXeVafOW02TyUryhp+3NebNUjn/T4Hiw0kZA67wT+z2ibd1+spEKQInWRx
 c/NdSOzQcjY//LEJ0MYtCBFF5/7+jqhigWzlBqkF5SrRJ3VAGQk5B0EC/4/SBI/mW7CP
 x257s+lPdVCgKb4CHJV4P633GadMPbycat6Yv7gRETHatBlumqzSB2YhIGkGx0TnM8yg
 4RxlxYWMRy3SPmWCZj/xfA/XrlPbTRswuWR/coSIVShUwcB1H6793YrAUOTyN9uk+xn7 9Q== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3k7uvnkgmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 16:16:51 -0700
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2702040083;
        Wed, 19 Oct 2022 23:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666221411; bh=CH8Su9EGry40V379cicqzqVSzZzzesFicqqgc2NPUpY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=MCtxfr/c4ZhAal2ROxC5/Q1SWOjCQd5l5hz+5k334grQfW0OynAwHNGN3syd0Fht8
         tr27mSW3Q+T8pq8SoRO+uBLKC5tk9F6Pil9jW9Hz518qVGmZgFU9luLP2ExQrdSxo6
         JuXb6fJ9gacngPDrEICMbt8wTWZCA40ASpYsF3fIBpaaJnWXDzZ0d3m5NPxPbJmk7r
         h+JE7fMCMBUwyrSK5mO6IA+EgdQuNXi1vjjHG9bBY3zul+IILSdPbslIVVyzNngkwI
         DOULLPraaATH1X/M/e27w93wgATp+RfWAljqaLjxNQhPlQay+rHqecbX1IObxjLHlb
         dVughUpnZv72A==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 77642A0066;
        Wed, 19 Oct 2022 23:16:50 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id A3F55400CB;
        Wed, 19 Oct 2022 23:16:49 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="tyKZkZnU";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GY+cu+Fjh0ldrNYWTEl0cQZaYo1KONknDxzmr7jajSz7GdvKJNvg7iqhBFF53/wu0ljP8vURZn6kQWZkVelpI2lq7zMCy03Vy0uyZ5HvE+P1QATlH4fsLaZeBMGDJoJzhGusfrlU8+VpVM3ci7OmCko2pKjxQqdPhI+WNOPCwoGvnb7bGEQGmbzeUjnyj9PD7CwejNpW2m7sKa/iTvweX8T4JlbUoHTY4n28lkrzGWeHPvAZcJ00nPjLT8XlMOcB02XMDx42PvwkXtir2nt6eijahtB/DRmuRvnLnUJkqqQdWdTrg0EAysup2HHW2xnbrSTc0kU2Dqq+IToSxwp7Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CH8Su9EGry40V379cicqzqVSzZzzesFicqqgc2NPUpY=;
 b=N14fUHnAKwCzc8gd8g2xXVKDLQNmyB1zIL11X8F/XmgahAMfGkURi1rmIP/0Imq7kSrtN+hd2G7sJ8jxeDtJPzqaBmj/ju2zgakA6omI3T3WI/WRWa2AlWGNhHzCCxsg706L3Wk8Dqn/QK0kRaN9VwKOiafet/0IBHd5I/3tSENmclOypIFW3JXq88nnhnBeA2v91pXlzJWYCwyLYJT3CuhpZ4i6ksA3TsG8RCRjgwbBnr39rPI+L1TJgT72u6Lm3zBH8kpQlZlhxiN5EK8wcJmEUxQ1OfLJzS6kZY1yf1H07TGZB8AqI4eMIzi0N2QfmGvwnLngvojHr9GvSJKAMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CH8Su9EGry40V379cicqzqVSzZzzesFicqqgc2NPUpY=;
 b=tyKZkZnUktYPVkQsO2ucr8I4adeXb3cLlBpdZaXJSSukTvVL99pQ5ldAI8hFIXjpsFe58ocbBJG3vOOrKjPABjq1ktEn8BwF2IiqNtR7zm1MLKzZlaVMB23+D95c7+jW+Ckycxg280K29Ba+BFDFEt0phIhAicP1W3p56kFdQy4=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by PH8PR12MB6676.namprd12.prod.outlook.com (2603:10b6:510:1c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Wed, 19 Oct
 2022 23:16:47 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.031; Wed, 19 Oct 2022
 23:16:47 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Wesley Cheng <quic_wcheng@quicinc.com>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Youn <John.Youn@synopsys.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] usb: dwc3: gadget: Don't delay End Transfer on
 delayed_status
Thread-Topic: [PATCH v2] usb: dwc3: gadget: Don't delay End Transfer on
 delayed_status
Thread-Index: AQHY42P0QztXjCLwdUeZb+aKvBO8/64WUMgAgAAKGYA=
Date:   Wed, 19 Oct 2022 23:16:47 +0000
Message-ID: <20221019231635.gezbvucf6v6v3ltt@synopsys.com>
References: <3f9f59e5d74efcbaee444cf4b30ef639cc7b124e.1666146954.git.Thinh.Nguyen@synopsys.com>
 <c01ad237-4091-aabf-0878-0e72aeae5d3c@quicinc.com>
In-Reply-To: <c01ad237-4091-aabf-0878-0e72aeae5d3c@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|PH8PR12MB6676:EE_
x-ms-office365-filtering-correlation-id: 94ad0ce8-925d-43f9-8eea-08dab227fe90
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZyJL2cIWLrHWSmGZPyc0Z5luucw6tgQXlvXp70fuK6FxNLvV+2ZXuTUfP0PpSP5yEch7drdeHGGzOif9n1WQr9QfkjizuFnTxLEg0CaV2KvsRkYc6SyJz6m2vqLv9WcUb8n6GYztXBKcufgqRLGCGXMgGfcm/mtYY8rqCXv4HWbAxseO/tafX+fyry/0LRg+QyL4QGjBpw50sGDQv4uVLsCI5nqXTQOs/rn3KhqEk0hpWFD2zbzo9sgwqNL/IqiXsKVKRBMDf3CyrCmO2ZZjyK6uA2ZWY+VlclLcQ7GDi9PT05SqYs9Hu+PwExJKYZjgb/xlC12e4eDYxy+5GCvzJ2jM4VQnQdnHeUMY814VPf6BacSwyrNhA7O4bJsEGXKvN00NYZ3zEbRw0fgavQ3r7tF25hPuPFIONcX13dznan8970YBlXJzy5gE4MJEsrGK3I5ak6UcTRIqO+Mrle/khB7c4msj9W7ihvaIXo2XE4gPT0LLbESsKOyfDRKL0yuLBkPUxYoGg4DHCKv8DFz0TJ1kYEW9EWriAG0dQ0s8lHsUqWXUEjp0aNAamTmEiaSf5noWF7pnDbvPdYwLzkk2Qz09772D7tCl6HUF/+7HF1hP+kfTtzqhqt6xX6W2d5k5dK9Z5GQOpA6ZP2KF0ov5w71vUzHaXUoYWS5VWQ5+bOeVQ9NgwrbfyDkdyFYENv0g6T4p0pmvTyQS7w5YwJUb0MYxkxUFeSS7vQddga+OJtmB3gOVypdwbqSjhCcLXc/VrSOPKaQVMLWZlE5bYlkYZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199015)(26005)(53546011)(76116006)(64756008)(6512007)(8936002)(316002)(54906003)(66476007)(186003)(66946007)(66446008)(66556008)(6916009)(36756003)(6506007)(5660300002)(83380400001)(4326008)(86362001)(41300700001)(38070700005)(122000001)(1076003)(2906002)(8676002)(2616005)(6486002)(71200400001)(38100700002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aUROQ2kwOXd4dE1aN2Nkb0h4MWlMU3FjS3l6Nml0Q21nUkdIdDdMMkxnZDFx?=
 =?utf-8?B?TVNRNUN4U3kxc0tOUkZtODdvSTRXdDRsR3RYVno5Qk9UVHQxMnZxOWJIMWJI?=
 =?utf-8?B?alMxOHhNOUpiNSs3c2dMVkpabTNvZTNFN2lpeGZ2dEYxdHdIZmNtc24zajA4?=
 =?utf-8?B?VEpyU0RxNGh2d3FJQmlmYUtwTGp3dmxmSFNDNXFiMTFOMDhrbTBVUHhNY25H?=
 =?utf-8?B?VTVyYXdwSzhZekVweUQ0ZDlMdDVBTi9LWjh0Q3hMcXE0KzkvbTZWb00zM0xI?=
 =?utf-8?B?NDloakJWS01wZmNEbDU1VGJjNWFEbUEzZm95dlR2K3IxdGFVSnY5QWkzL1JL?=
 =?utf-8?B?bnV6dzh5SnRiY0hRdkducElkUjNPSCtFMDZRbU8vU1V1ck1maFRzQnBiMTZh?=
 =?utf-8?B?Y09nUGQ1aXdKZzhHWDFrRDAxU01sWGo4cURKNCtmZHNpb1VjbU1mTGlScmhX?=
 =?utf-8?B?ajZFTk9UZkdkNncvN1BET0tGYXVBOGNZVXhTUzhHbTMvbExqM1E1Z0d2VUE1?=
 =?utf-8?B?YzhoL3B0TEdBVXN4VlNTeVNVL1BTRFRCcjJGZ0ZLOERSMGZ2bFBKc2ZjU3VI?=
 =?utf-8?B?a1ZZQm81Y3VMbG9BaFQrbm5KWUp4dnpnS3YxYVM4REo1d0YyN1JaKzlabjZW?=
 =?utf-8?B?NGJnaWlMZWlRNjJ6WW05bVJ0T3ZkS0NJT0RTNGVwUzltblNRbmFnWWo4VmdW?=
 =?utf-8?B?ekdOeXp5SmRqWWhheE8rUXo3R0NWVXY3OVl3aURlM1lKazl5OHVRUjg4VG14?=
 =?utf-8?B?b3Q0L3JHWm9vVEFBRWw5QUVNVUV4d21sWm5DcDFTN0dXQk5Sek9qeGpRTzFW?=
 =?utf-8?B?RjZMMGJnUFdBT3R1bEpESUJGaWFhSVlDdGQ5NW5rOER4dEd1SzQ0clJpYU9n?=
 =?utf-8?B?bjFBaXlBcDEwNWx4dmZnMGxVQjRlQ1NMS2loVjFHV3VjOXJFdkliV0tLTjhl?=
 =?utf-8?B?L0tzVVZyemMxSUNtUUhFQit6Tm5McXgvZ2ErWCtKMS9jNHc5TUVRcUZNTlFJ?=
 =?utf-8?B?OGNPcEdQZTlSOUlpUXdMdXd2MnJGZkdVdTNndWlNUDBlRjdrUk81eTJCcUUv?=
 =?utf-8?B?cENodWVrakUzd05HU0lON1ROYVREUWFZSG9zRG9HRzIvYjl4T0FUUWNQS1Zx?=
 =?utf-8?B?ZXJPc2pNRFlwMmdZWUZGWVdnWHAxU3JFeVJtMEs5dWxQbUl0T2FJRmlmU21Q?=
 =?utf-8?B?QXFHRU5GcnloekFIQi9wSWd2eTVzMmRKS2NOR2pnbWo0UU9tWXJoZ3l5MmJo?=
 =?utf-8?B?T1VnWWVPdTVTT29rY0EyZERrM1BkRUlLSnYxazE4czJhczR4QXMyTkIxdG91?=
 =?utf-8?B?ZDlCZ1U0Q3NPL0ZDYWhWRitIbGlieGhGRTYvQk1aUXAzT2dlNXNNdjlVeUgr?=
 =?utf-8?B?S0hqVTNvZ1JIaHlEa1JSQ002WDJhbEk5bVlIVWJkM0VSOWRDZFAvR2VzQnJE?=
 =?utf-8?B?cTEyU2lmclM4MXozRnJ2UDFzWmdncjFuWVIrdWphcnZaYWU5MGFxRWxTcEk2?=
 =?utf-8?B?ajR3dE5SZDJxUDd1dmI2cmJFTWhyRTFHYTZybDNHUFZwdGNlWWxOeURQM3hq?=
 =?utf-8?B?Q3hZeEtDWFN6TzVkOWE4RDRkbWxBSVBYZk1WcnkyeVcvVUl0eUg1aHJ5TWth?=
 =?utf-8?B?dzdhRHoyQjRmTGhwQSsxVllWeWl5WmhHelVLWjhvUEJyZVFabkR4TndXQnY3?=
 =?utf-8?B?MVRJUE95ME9oL2l6aDNRQVNXUzdaVFFyTXhwQ2JyZTU0RWdyM2UvaXFiSXA3?=
 =?utf-8?B?Vm02WkFSc2RhYzQ4ZFoxaWJjc1ZOZ1d5SjZ0OWV3eHhvTnlWOEJVZ1dGTDdr?=
 =?utf-8?B?TTREUnA2MXlYbUhIUGZ0TGNybkkxVG43KzdMUG9QMkRlaHpuQ1BycjZkUjZr?=
 =?utf-8?B?L09WdkVhbndIOVJNdmZ4RDFrbjQ4RmtidkdGVEtMV3RkWkYyWktnZHhwdllK?=
 =?utf-8?B?N3lHenJFcW91ejArUHRvUTVnZ04xUzdvR0ZyRFlPM2xVeGVHZVRXTml6NHph?=
 =?utf-8?B?Z3JOQUZuM1ZSL240TjBJa1FWRHQ0TkY0c3BINTMwRXdBenV1K0I3WkQrM2NM?=
 =?utf-8?B?bDN6cEUzNDdCYldIaTQ0dUprN042RUV1c1RRWHlrZzlvNFpSOFpzY21IOG1w?=
 =?utf-8?Q?RC/upO16VftoC/4V1778pQPmG?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B458FF0817B8440ABF2F21C90067A47@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ad0ce8-925d-43f9-8eea-08dab227fe90
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2022 23:16:47.0545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g0AM5CIDlzQbTsmfF4pWaSHWmaZ1DGMXuGZAEa4UN6MuCNy4/BWYBo5MQDxMgUUsUjJCkDeuBacfhh81kjoUhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6676
X-Proofpoint-ORIG-GUID: KFA0BzF5KaLIryUnXEfQt8awa56qOtuW
X-Proofpoint-GUID: KFA0BzF5KaLIryUnXEfQt8awa56qOtuW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_12,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 adultscore=0 mlxscore=0 mlxlogscore=655 suspectscore=0 spamscore=0
 clxscore=1015 impostorscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210190130
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCBPY3QgMTksIDIwMjIsIFdlc2xleSBDaGVuZyB3cm90ZToNCj4gDQo+IA0KPiBPbiAx
MC8xOC8yMDIyIDc6MzkgUE0sIFRoaW5oIE5ndXllbiB3cm90ZToNCj4gPiBUaGUgZ2FkZ2V0IGRy
aXZlciBtYXkgd2FpdCBvbiB0aGUgcmVxdWVzdCBjb21wbGV0aW9uIHdoZW4gaXQgc2V0cyB0aGUN
Cj4gPiBVU0JfR0FER0VUX0RFTEFZRURfU1RBVFVTLiBNYWtlIHN1cmUgdGhhdCB0aGUgRW5kIFRy
YW5zZmVyIGNvbW1hbmQgY2FuDQo+ID4gZ28gdGhyb3VnaCBpZiB0aGUgZHdjLT5kZWxheWVkX3N0
YXR1cyBpcyBzZXQgc28gdGhhdCB0aGUgcmVxdWVzdCBjYW4NCj4gPiBjb21wbGV0ZS4gV2hlbiB0
aGUgZGVsYXllZF9zdGF0dXMgaXMgc2V0LCB0aGUgU2V0dXAgcGFja2V0IGlzIGFscmVhZHkNCj4g
PiBwcm9jZXNzZWQsIGFuZCB0aGUgbmV4dCBwaGFzZSBzaG91bGQgYmUgZWl0aGVyIERhdGEgb3Ig
U3RhdHVzLiBJdCdzDQo+ID4gdW5saWtlbHkgdGhhdCB0aGUgaG9zdCB3b3VsZCBjYW5jZWwgdGhl
IGNvbnRyb2wgdHJhbnNmZXIgYW5kIHNlbmQgYSBuZXcNCj4gPiBTZXR1cCBwYWNrZXQgZHVyaW5n
IEVuZCBUcmFuc2ZlciBjb21tYW5kLiBCdXQgaWYgdGhhdCdzIHRoZSBjYXNlLCB3ZSBjYW4NCj4g
PiB0cnkgYWdhaW4gd2hlbiBlcDBzdGF0ZSByZXR1cm5zIHRvIEVQMF9TRVRVUF9QSEFTRS4NCj4g
DQo+IEhpIFRoaW5oLA0KPiANCj4gSW4gdGhlIHNjZW5hcmlvIHlvdSBzYXcgeW91ciBpc3N1ZSBp
biwgd2FzIHRoZXJlIHNvbWV0aGluZyBlbHNlIHRoYXQNCj4gdHJpZ2dlcmVkIHRoZSBFUDAgc3Rh
bGwgYW5kIHJlc3RhcnQgdG8gYnJpbmcgYmFjayBFUDAgdG8gU0VUVVAgc3RhdGU/ICh3aGljaA0K
PiB3aWxsIGRvIHRoZSByZXRyeSkgIEp1c3Qgd2FudGVkIHRvIG1ha2Ugc3VyZSwgYmVjYXVzZSB0
aGVyZSB3ZXJlIHNpdHVhdGlvbnMNCj4gdGhhdCBJIGhhZCB0byBhZGQgdGhhdCBzZXF1ZW5jZSBm
b3IgdGhlIGVuZHhmZXIgcmV0cnkgdG8gaGFwcGVuLiAoaWUgaW4gdGhlDQo+IGRpc2Nvbm5lY3Qg
aW50ZXJydXB0KQ0KPiANCg0KTXkgc2NlbmFyaW8gaGFwcGVucyB3aGlsZSB0aGUgZGV2aWNlIGlz
IGNvbm5lY3RlZCBhbmQgbm90IHJlbGF0ZWQgdG8NCnNvZnQtZGlzY29ubmVjdC4gSXQgZG9lc24n
dCBpbnZvbHZlIGNhbmNlbGxhdGlvbiBvZiB0aGUgY29udHJvbA0KdHJhbnNmZXIuDQoNClRoZSBz
Y2VuYXJpbyB5b3UgbWVudGlvbmVkIGluIHlvdXIgY2hhbmdlIGlzIHJlbGF0ZWQgdG8gc29mdC1k
aXNjb25uZWN0DQpyaWdodD8NCg0KCSJPY2FzaW9uYWxseSwgYSBob3N0IG1heSBhYm9ydCB0aGUg
Y3VycmVudCBTRVRVUCB0cmFuc2FjdGlvbiwgYnkNCglpc3N1aW5nIGEgc3Vic2VxdWVudCBTRVRV
UCB0b2tlbi4gIEluIHRob3NlIHNpdHVhdGlvbnMsIGl0IHdvdWxkDQoJcmVzdWx0IGluIGFuIGVu
ZHhmZXIgdGltZW91dCBhcyB3ZWxsLiINCg0KSSBhZGRlZCBhIGNoZWNrIHRvIHJldHJ5IEVuZCBU
cmFuc2ZlciB0byBhY2NvdW50IGZvciB0aGUgc2NlbmFyaW8geW91DQpyZXBvcnRlZC4NCg0KVGhh
bmtzLA0KVGhpbmg=
