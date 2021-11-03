Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87D844409B
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 12:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhKCLbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 07:31:34 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:52217 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbhKCLbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 07:31:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635938938; x=1667474938;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GyiXn22ClWqYGcTiQqK7MIGRKj1xY2+QRQB07tsDrCU=;
  b=NpMqGjrcp6fK2VTV2Z9z+ZBKGH2cTGjDbir6kpiEyXXVafHcSBsgL73V
   59fBuq/rcVW671u5nTM6K20ouNOl5t46tcL2cvNPE6HsO3hoHjZd8VFvM
   ldDl1j109Te0BmKLMlVBOJniRfCaeYD0YDAlyKSpyBTw2FWuJvlcARz07
   Qa4G4itoWLhokS0aFbQvUNLujxPZceGYE+oafLsftlpyNk6MjH3R97hRW
   YnDZHV+gX8+MJfiJ8DMvzzAa0DGYDG7dlwmLmUZAJ0FsjfttAOPgaQ9xS
   QSX0DvrqVppCPcHErX1tHnXpsKowqpu5Lavpkd+qLZrvuJbxua1KXE6Ww
   Q==;
IronPort-SDR: 14gPDW1i0qIuUoAAWUC5U0OpzGEB+xoYaBeQZ3OWiTgtXFrDyBkAFdcGhvqNQoTC/b38T5NHCD
 YHSR6br4NPg37kncpDEw0HQTZF/nXplVUyEYFZdLHW3xeuLWeqAYEbJTyS92xzvDAezgqtRDUk
 W2D+rtHEA0RLz+bS2UByX5c5dTH3Yp33IIo8upk+xtHHC8ueJ19SRYhdxYRz+GRbmCFv2g1t3h
 JXHhwaUbTvuLcm4P0LfS2/nM7RpfM3OOw/Njvc3tVXcDLP+1Rnm205S6X6KnXxIqBFOT027RFF
 ynzfpFmvgFWlxlXDSbXq/Mia
X-IronPort-AV: E=Sophos;i="5.87,205,1631602800"; 
   d="scan'208";a="142058257"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Nov 2021 04:28:57 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 3 Nov 2021 04:28:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14 via Frontend Transport; Wed, 3 Nov 2021 04:28:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TMz4YEi0CyJV8lY8cNb2QmSVULjA5tEEZYeZ5UtnMwsmV/8eAAcwc/z+UL8CuLE7hmSVoVVmybvKsx7rj1M+QkyWVSP8U1WdtPzUh3pqhpHTgIjCZCsuv2IrjrqskEOyz63TRW9W1C73XL1i8ssBsSqI26UkWXrqI2Jzw5EkCsyA4YDi5rXarapsuoiovEpzouSSY5GYDIYhQ9uGc7XU6//MPu+ToGJsk2IaLzpQwaJx9+mHbxsufGJPCCF5THbD83N91uHw+3JkdWzNz9DxE4dq0ObJEhMAB6pKZM9hDM5wLbg57Opg6QsqqOnET2l4pwdykYkLqYGuhNxKUIEgQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GyiXn22ClWqYGcTiQqK7MIGRKj1xY2+QRQB07tsDrCU=;
 b=bEXrgPeMju+1pAM1M4fzUnpcWYpl/sjFUmtcOwTAQq0Jr9MfV/Acu8Of9IpDxbwl/hEUOceZLxiCNzPs6dmknv1Qi2ZzfaTNzmJ1ZrTehbutpLArC55oLusuoYCwscQQLqwqF90ke/RaurYOudGHLS59bkvFqRQ92Vc02osS/q+vOiQdOr1BPUMYt0dKbcrSeuCqyadET5JAW4tpHVQyScch86WdUC4s6CKYaYaNjRLebAmuBfiv/sxT5soRHXt9MAS+Ke3WUHp7uOV5pSZwhW8gYWjsHdKwRIimL1PvmJjIKhGy9NpWSV+MQhhslBG5riI1j2iy06SxOnXmky7dpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GyiXn22ClWqYGcTiQqK7MIGRKj1xY2+QRQB07tsDrCU=;
 b=r7uW4QKZP/XPEPLckg3d3DI1nebrV+2x2Bju0Emcc6PCra6Yf2AGKUwxhB8DPQkmzni0SG72XPShqIB9Mv+fs199aa+XbNlsIXyM3PGXOV6hGUw/UE5Ke7+BMVNa021IZiavYDws23FGslM9EcEGJnB3wowywruArlIk5PggI5M=
Received: from CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8)
 by CH0PR11MB5563.namprd11.prod.outlook.com (2603:10b6:610:d6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Wed, 3 Nov
 2021 11:28:55 +0000
Received: from CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::c096:557e:a1b5:bc5c]) by CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::c096:557e:a1b5:bc5c%7]) with mapi id 15.20.4649.019; Wed, 3 Nov 2021
 11:28:55 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <greg@kroah.com>
CC:     <stable@vger.kernel.org>
Subject: RE: [PATCH net] net: ethernet: microchip: lan743x: Fix skb allocation
 failure
Thread-Topic: [PATCH net] net: ethernet: microchip: lan743x: Fix skb
 allocation failure
Thread-Index: AQHXz/PcQ4gfj71hFEaOTCQj3NoXfKvxjqeAgAAdOyA=
Date:   Wed, 3 Nov 2021 11:28:54 +0000
Message-ID: <CH0PR11MB556176100C396C0A6CCEA3368E8C9@CH0PR11MB5561.namprd11.prod.outlook.com>
References: <20211102141427.11272-1-yuiko.oshino@microchip.com>
 <YYJZy7wo0f1ePNSp@kroah.com>
In-Reply-To: <YYJZy7wo0f1ePNSp@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kroah.com; dkim=none (message not signed)
 header.d=none;kroah.com; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bad3e998-440e-40dd-5d9f-08d99ebd1eb4
x-ms-traffictypediagnostic: CH0PR11MB5563:
x-microsoft-antispam-prvs: <CH0PR11MB556362431EDB93503B6227C98E8C9@CH0PR11MB5563.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:243;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nCoaCBzpG8Hol/wO1F8tUu61IjPGmodKP5w1h7j08vboXpsR9peqfRK3R+R/RrNrvItmy2MeUtVVNSgbG8Ob8SaIR9IoBPyyAZEeUiOVBZRmJx3U4nU4ToAd3oekexcAq3MVM2iWRuagt09yWyzDvmwMFTnTL/BiVbfLq+N4xdd5a7ZwwZoo163cu9OppxAmv9hPg04nFrJl0Wbpu6NgQp3kE/2H1667+3z606IO1gPEW55G3XBEwlQN5EJ7OUvIAYPhj0ZHS4+7/nks+TkrfwpOwr8E2n7pV7u+gv4Su94fpdddnHaNUT7uXo5QMm7i7ShcW1J2AjlMjWtuNxQ33CPQaJaKHQowcnIUBV1AEwxoUtb3J4bLmEr361GsP6v+CK2XS/hTNxaeLC6dWANfz+LB3f7Y1zZAeCQ7oidzkIbi8wCGVzU3VHBfk0ft3HZmn0kIzb4EMoxiwZgpTqMSrM9JCs6vLEvXNnFqs5RD5SK//oS3M8x1xbCmAON6TYKi8GYOmh6nUrWa6fyCCqPb+OEIIj+y25xolL2EBU5p+BJgQI+85rhejT6ieIv0UHAMFNzDOtb98vSvsvtPfoY6Tct9SQzSz9ut6DuqXkPOs1EleZJiJgdCUG6ptg/L2xgU6PQndtrq6dbWkHjmo+xDe6ev1V9J2Wf54eSSrTQ6PEmurEFBC2n06gaVzQ2+JeFJpbD7TSpgJQW36mxgYKekh3D+3NNJG+H/Owg6Dr7ch2JwLdyVB6zWkeZyvKGtuikI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5561.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(71200400001)(26005)(9686003)(6916009)(8676002)(55016002)(86362001)(5660300002)(66946007)(4744005)(76116006)(66446008)(66476007)(66556008)(186003)(122000001)(38100700002)(83380400001)(52536014)(64756008)(2906002)(7696005)(4326008)(33656002)(508600001)(38070700005)(6506007)(316002)(10090945008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gLfZX9DTGDqXVCIw/gYP7crATVWQ5GoVFb7ozF2bNZFfIR5EPVZ36/HER9Cd?=
 =?us-ascii?Q?/diP9oUsJpA6+tP/0DRgTEaGAwfGPyXRpP9tA6S1QvXPP8WL6QFFUGjIv8Ty?=
 =?us-ascii?Q?OfMYIFGdwJX6u0K7WGZmtp3qHrM14EksTnlbIuQqH0rVrXjooW+cC+zq94ba?=
 =?us-ascii?Q?oEUzqcVx7brGQCdi0ybepwoGvHP1xkKCS3zS8/+DVFvVsHt1RIqU/o85qTUv?=
 =?us-ascii?Q?gkHQM6t5x20WKQ/X1tRh8hUxiPQ6kIuvwnr6FIKOqPdBmbiqFt52J4b3b28/?=
 =?us-ascii?Q?WVJNEtCQ4gH6FajAKIOKB6ZBvxw4I8jqefnJVz8PmCNQGeSDj+ksOsMHfFw2?=
 =?us-ascii?Q?d9LJfhqM8VNNg0Ost5HIUv6sJMSylDW+X+ZJ7uHYODhK/bs1Osy8FhwP6VyU?=
 =?us-ascii?Q?5MF10jWbbMl+dMhBVUeAx/0/Zc/48XGbDE3rJ8ZvHcGVNaWXZw4HJpKBLP6o?=
 =?us-ascii?Q?v+qB7Mp4wDSm6UwtA43NJDAXrsWuUf9myUn6sl62xczXUFs4DlBW4rdRlu0X?=
 =?us-ascii?Q?dpoS7iY0YlXM6E1b2xqEbCN2c+MkMze7vxTyFPypNQ18skRWn0yQQEp+bV4+?=
 =?us-ascii?Q?soLpEeshni767XRxTMep/b0IxMROlnO2oXp26TBw98vJela4v+0TQ1X6wMIw?=
 =?us-ascii?Q?shUHXaEJ9cgTYTk7H7YQHekYSiNB0N9GUslVZ0bk9zP4NCZJ7a9/vMxdj5LS?=
 =?us-ascii?Q?dKUgRm65sUdIgZTthqtoAPTXBVSjpihuWGOvqeXboQ5qBgHCNlo2PUJXkmxn?=
 =?us-ascii?Q?EuzwFTODO4OX14qdbMcjP3X5j1yGZ9xUxxsVlfdU7fAokZlMRzWZZp0JUgg/?=
 =?us-ascii?Q?EG4/vfPyeEv0VQuRWgiZF9OwcEYZU5NYvnBvgqkW3z1DKB0FuTFrLEF2s1E8?=
 =?us-ascii?Q?wSAV4LaOdjJ8G2dzHNs7767tgP1KLmkYh+Px3ZoeD0STj4mg8U4dePn0C2vO?=
 =?us-ascii?Q?nVgpVF09GtgL/SNiy9W/jAd06WUfx4j8vhYc3I9emKZHfPZ1VhhOP8zEEpsZ?=
 =?us-ascii?Q?P18IKsTkljaoZAZAcoxNYzUXUixWU9e/1vf2s/DXReY5WkL4iuSdFFgzAgQl?=
 =?us-ascii?Q?VY0lqty6eKI+NwBXV1O6DEMkQz8zQRXvw1RVZc36jhI/Yanb8lQtppt5HS8e?=
 =?us-ascii?Q?+EhU+Ko878HW62sN837axgONFV58u+JCih+6yGy5m61E39TVAFWog6mVk2CQ?=
 =?us-ascii?Q?dZCjhGfk9AUck+qTESSjAicqnqlY+rojFplYoOQ71LFo8v3iIUS49dUX0IoL?=
 =?us-ascii?Q?7POmaJ2sw0/8BmIDDry3SGufjPpyLLzJNJ0J6u5nbJjgelHQIwCPiw4MWOsJ?=
 =?us-ascii?Q?1inAV+iPAhSs4OFJrUeYRflyz2YvzQZCrZzSEipNnojNz91RrqQyQw2wOuXx?=
 =?us-ascii?Q?6otgiWkjKBM4W8EpwjDfo5FEUO3G+yNYvQID/jq/HoPMcWwAz4uz9f19KEz+?=
 =?us-ascii?Q?8KTaJ0RuKIXEfHmLt9mW4SprQvj9a1gXXWV5wknljiorrPX1GZu6jQJAx2jh?=
 =?us-ascii?Q?xkyz9OCCcqhkxCLq2Y/KKdI2aw/ymmublugXrKYl5EzHIS5wCvoeS6m5O6ki?=
 =?us-ascii?Q?lF/r99nS4aU8mtD/3tYy/t908urqWPX+wG5KgysHgf8RZKcx//cTx9pGnhko?=
 =?us-ascii?Q?YUgjduRtBVYElcRK7VQn2xGtnCObfyDOWc1X+WSs3Ws5O4dsEPgWXEFnzSKi?=
 =?us-ascii?Q?uOeheA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5561.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bad3e998-440e-40dd-5d9f-08d99ebd1eb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 11:28:54.9306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tv/F6oME/mw4lM+CyZ//zMzUEa4lctnt5eVG38RtHht2BsPJI0/0+IKaAnuipeV8aPb8hm+NKSBLDneAcgUQnP/A4tkWyP6Ak7OPeI+/s+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5563
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>-----Original Message-----
>From: Greg KH <greg@kroah.com>
>Sent: Wednesday, November 3, 2021 5:44 AM
>To: Yuiko Oshino - C18177 <Yuiko.Oshino@microchip.com>
>Cc: stable@vger.kernel.org
>Subject: Re: [PATCH net] net: ethernet: microchip: lan743x: Fix skb alloca=
tion
>failure
>
>[You don't often get email from greg@kroah.com. Learn why this is importan=
t at
>http://aka.ms/LearnAboutSenderIdentification.]
>
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>content is safe
>
>On Tue, Nov 02, 2021 at 10:14:27AM -0400, Yuiko Oshino wrote:
>> commit e8684db191e4164f3f5f3ad7dec04a6734c25f1c upstream.
>>
>> The driver allocates skb during ndo_open with GFP_ATOMIC which has high
>chance of failure when there are multiple instances.
>> GFP_KERNEL is enough while open and use GFP_ATOMIC only from interrupt
>context.
>>
>> Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x dri=
ver")
>> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
>> cc: <stable@vger.kernel.org> # 5.4.x
>
>Now queued up, thanks.
>
>greg k-h

Thank you, Greg!

Yuiko
