Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DB160D5E2
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 22:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiJYUxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 16:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiJYUxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 16:53:23 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61357B1B97;
        Tue, 25 Oct 2022 13:53:22 -0700 (PDT)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PJrULr030254;
        Tue, 25 Oct 2022 13:53:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=4RfKAx7+f3NASlC/xfYHEwpdOURmHEKh5PlXe45rzaM=;
 b=lK4zdEETzxTaH4SgiGAD+AsbJJyUgCu5Lgk4DAkzSRkDprnFlTCgKhYuDZ7FYNnTWffU
 u4j3uBHPxHFCkLFqPqirVXPAHzj14Q9li8/4/OBhiJ44eLZw1P09dETslN7jbMAhvDwH
 VhnDH/Oe+nExAxrsr4sRtL4jxOA3qv7COVv2G4+bTd6hp/QGkseynzxpi+wL/nq3nurW
 qdofgLtE1b6hFZsqZXVvdGTXrCMjBY6qexreXvLWtAqYMWSTegUPkiX9Vxor6AyfsrYJ
 NkISqhxwcD9ryn9XDiEZSi+Hoq+sTEUXTObZH/5wnEjTdrfatFJpnulSYZY8AAstpSz8 Mg== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3kcfhp967g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 13:53:12 -0700
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2AB49C00F4;
        Tue, 25 Oct 2022 20:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666731191; bh=4RfKAx7+f3NASlC/xfYHEwpdOURmHEKh5PlXe45rzaM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=IVIQQbciDkCHkaDC0OS2KoL/vhWySteW2OatyXEt9dfJ8oZZVCXJxLieaR2/c44uK
         I9GabonCt19gZctQ89rptBwYdop91SZP71DKkSmYHdN2cPn+D6H6x6PCyPpV0hAN9V
         EJEa59d7tY4hmQiJYIpre85uSWzpeYe4V3wA2gjcwpzIZdbCvK5YLYjV+suenvZ1cK
         YVBYqMspZUtTSPa0I9Z0fU+vow/Bp/ldcuWhsdhbBzh0E02+Hudp57P+3UxbIpoR6Q
         6fAIHl03jwbrpMoeZqTD8cM7h/Z0ha42muwXNYUtO7XjYuwtEgo5eZAGSdre2KuWI+
         M4Uy18Tt76WfQ==
Received: from o365relay-in.synopsys.com (sv2-o365relay5.synopsys.com [10.202.1.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 804EBA0079;
        Tue, 25 Oct 2022 20:53:10 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id B289DA00A6;
        Tue, 25 Oct 2022 20:53:09 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="axHgKWvb";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcGPj2U167QaBBv4ZcUkL9ZFRmNZUM0ymVsBFhDNtTCrhsazK8N/6LnFw7sBH15f7LLCGW2otGIeVgAR9bZKhuBJnKyumCX1wDPwYXELaqdAi+rm0WwiPotZNPDFJf4yfTLzEA8Q/FzMoAppSxwyxWX//sbVX18m8H3GfWJ/+F1Jc46pIad6rrGd1l66FNOzMWpvfz60aTm/BHbbUkI962ailou3CAGv8zQyZb7BUinBNQMWDxtaZ+jHVMg5cl8QJpvg9+KfbBYfN/cBiFrkZIEtfqt0nvstvPG9wnHpSxElyUw2fVeKIUlMQBezSTIGFZCoxpBSXZ/ELYW0xlfQAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4RfKAx7+f3NASlC/xfYHEwpdOURmHEKh5PlXe45rzaM=;
 b=mAqlr99v2HbnmOmEnPrhbFEPveyJ+ex0JOuVxfBaQFJaeAuY+QvJLvm6W3UBlwdYFtcpbLX1n9Ls1R+AxbVOKfYH3rU4g7D7TTWcXr3qHmsolTjb4uv9lD5mmD6VZBbYDT7rae6psXxxvJDi0zaV2QDqn6NzCVY9DNURM2I60zhQvGAyMxR2590DDx1RCN6hnc/ik5SNN+j0tGSyJWArSKe7qt2vzIeZSYKcJkOUIbASDK/y9/iWJVrZpUyqpnj0bFoCQg2+GF78n2g96zBF/ny64ZmEFAb0HMco8+5z5swWyk6KtS3wpHdM/tQ0oA1Jtfs79Yg8z347XkdjhYCqLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4RfKAx7+f3NASlC/xfYHEwpdOURmHEKh5PlXe45rzaM=;
 b=axHgKWvbR8Wp0WVjC5dh62jWlCERU9/ytLmeFiHe7itgJRdL4awgstoDr9v2Y0HyD1LGJ/YD8tWrqqD4TjkA1C7CjJ39dMvX7zt7pt8Bvrqcnr8driR2R6kEdaaxhsdCU+s4fLJyaF3C6pu2LBka0fI25aA3s2+prm5Fb+vYd78=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by SA1PR12MB5669.namprd12.prod.outlook.com (2603:10b6:806:237::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Tue, 25 Oct
 2022 20:53:06 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.031; Tue, 25 Oct 2022
 20:53:05 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Jeff Vanhoof <jdv1029@gmail.com>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dan Vacura <w36195@motorola.com>
Subject: Re: [PATCH v2 2/2] usb: dwc3: gadget: Don't set IMI for no_interrupt
Thread-Topic: [PATCH v2 2/2] usb: dwc3: gadget: Don't set IMI for no_interrupt
Thread-Index: AQHY6BEJdYD5PgC+60eX9aTbiKyHo64eitoAgAD/RoCAAA1DgA==
Date:   Tue, 25 Oct 2022 20:53:05 +0000
Message-ID: <20221025205257.7vibcudn46szd4lr@synopsys.com>
References: <cover.1666661013.git.Thinh.Nguyen@synopsys.com>
 <453f4dc3189eb855e31768d5caa6bfc7f4bf5074.1666661013.git.Thinh.Nguyen@synopsys.com>
 <20221025045148.GA15715@qjv001-XeonWs> <20221025200527.GA11641@qjv001-XeonWs>
In-Reply-To: <20221025200527.GA11641@qjv001-XeonWs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|SA1PR12MB5669:EE_
x-ms-office365-filtering-correlation-id: 21504c7e-2348-413c-597e-08dab6caea41
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I+jyypDeLQTJ7xU1Xn+8SS39AN3pCz/MHNr11R+JvuK6E+zJYSJDEltfVUNgZ6VeoN0y2lonSB87RZWmb1PgCNd+R/jbzjcFjFWjPw8EP6z+PuVxqhz9Rroi+HuCfPxa6wF3WHHS9REwYnKF9gA9ILzGPWmWhdmqG9kONSPhbtgHmweOhf7QxwSC0AVQxkNFDxlb4irBT/rwwXblcrdaG8dxztOwftVkdBe5bZpq/hy1xtamnmrM6Upl51aQJsh8bQZYRwc7v5FIAyPvilWixbsivUV5Md+iBefyvIvrkn6TZfPsPrSqEnEjUqpKg+ex85DcL4QgJLxugBY8mrxXe+YASlvGqcFwSBdeYbKrz+bDfH4tTkLUCzRxzAWqJNYRNSAXw5pBwFOwcqPYVx0e1lLqukChjzSDQqoeD51nVed7AKqqr1Kf5jVTg3pRpDkOqfPL9ORn2YEZo9T7gWgNAZ3DFwu72vgF1VkRxw3jfd2c4VQeOQHnD5ylbqiaVeu2BEPaSkCcnIM0ZSxy92EqfvAmIUcvxnvwt+pLxMjerz6jpLcg0j5YD1mPksx44orC/UMmO/rITJ/0QSWU20yqv04sSlAgNAaqGhgv1r6bCTtddDUq5sIuGOrsPTa/MoDbzIfgZ8+9SJWSG0UFRhbRdKHNYT9wsNWP2o53kE5EgJ3CjWF6BNSFthuky65/+N/pMXzIA6oxZzWlIRwm4aMvmlgBslpXGmAmTBcccdF0luXV0Id3XM/Al0Mi9xSu6AWxozawzqw2Kd+RVTtOS5PTMA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(66946007)(66556008)(66446008)(64756008)(4326008)(76116006)(8676002)(6506007)(186003)(66476007)(83380400001)(1076003)(2616005)(36756003)(26005)(41300700001)(6512007)(5660300002)(478600001)(2906002)(8936002)(122000001)(38070700005)(86362001)(71200400001)(38100700002)(6486002)(316002)(6916009)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WE5neWY1UUNURVNJSnUwZmZKSzN3YWtFUVIxVnp0VmwxRnQ1UjNTbHpXRys3?=
 =?utf-8?B?L0t3T1JJQ05aZFZaUnhnYkJNR3VoMjQ2aFh5NkJUNnNib1ZKdGs0WGhMMzZJ?=
 =?utf-8?B?cytCWFpQTCs1Um9qcld0VDRLaS9vNmNrc0lvRUVDcnBCenUzcWlSZVBQcXRV?=
 =?utf-8?B?ck9WT2E5TE9YQ2NVVDNoMWxaYnVhUHNrQ0E3dlBDQlNjZTNUQVpxcms3M1JO?=
 =?utf-8?B?M3ZoVW5yTHQ4cG5MUkp3cmwydzFpS3ZNY2JBWk5taDkzU0FqOTViaXNHNGtY?=
 =?utf-8?B?Y1E2VWlBdy9IOEM3M3dUbUdEdTJEaDBrckJqZlBMa0FlOTYxYWpnTUpBUnkx?=
 =?utf-8?B?QTRMZjNPS0NyL1NlcmlCdkVXOCtSZ255SGQwQUx0QVNvRXBGRGpKQ1NJSnly?=
 =?utf-8?B?QUE5Wmtha3JkWStlMENZV2xPTzlYSWFsc2o2UUZmZ2JYVkdiTEpkc0J0QlMv?=
 =?utf-8?B?RVlrczBWbzI3Q3R2aHRnSlJwYXBUUXZoVXl4WWt5OW1QazlMUjlDSVhqTlli?=
 =?utf-8?B?WTdHQ0xBbDd2NXNkRWttMzcvR0g3WW80bVdvdGdXVnhYTTQ5TkpIeGx4Vmdw?=
 =?utf-8?B?S3ZyTFlwRFE4dEk1Z2FqOXBpcE9VL0kreTViajFyYk5wT1FYQzMrS3cray9x?=
 =?utf-8?B?aFdveTJWN2t3SnFrZUpUcUhDOGZKSHVjVnNRek9Hci93c1JXSjZxdEhrTmpK?=
 =?utf-8?B?SXhzTHFEZytUZWRWOHZta2F4dmtrSGRDeEFrd2V6YkNlRHh6bDdDSUdRNHRG?=
 =?utf-8?B?WmlkMytIOGNFd3h0cDRBQ2RTK2ZjbFRyU2N1MDdteitvTytxKzkrK1VaNGRp?=
 =?utf-8?B?dC9LNlBPZ0J3anExZ2dDWm9yMExoaElZSFl4QlZKT050VHJNWTJPbUN1cHpQ?=
 =?utf-8?B?bU10UHFpRG4xNTJZemxJUDBNNWYxTzdZY0hBM081WkpIUmNYUjdscjVzUTJZ?=
 =?utf-8?B?Wmkrcnc0dFZMYm1aWWpPcE5XZHg1Q29YMWZlQ3hibE9jaWpqUlVRVy9qdkQ3?=
 =?utf-8?B?bFhqQjJEdGZkZGhuMlQ3VS9sY3VjWTBpOFo2UHdPZlVoVGtnMTVaTmdGM2Fq?=
 =?utf-8?B?TVdNNlN2ZWlEL2tDMmV3M2J6VEtoSGVGbjZoTjZSZ2hOaWhBQzB4UWlhdmdP?=
 =?utf-8?B?bTJWY1VybHdEcWU2a2ZuWG9OeWVqYjBaKzVXWlpLVWNEMG5ZeDRyV3lmWHFU?=
 =?utf-8?B?TitYT2tEYURqVHpLNzdadlpIVEJoYnVCS0x4ODBTS0Q4a1NrOEszcmRRamIz?=
 =?utf-8?B?Und6TVRmdkxYMXJVRlF5VlI3S1g1YTZlV05SYUp1WTRsbGhjUHRhTzJ0MjBZ?=
 =?utf-8?B?U1pLczUrakdEQWVCeWxER1FtcitQREpha2J5Njc1L2xKNisyYUpZSE12KzNJ?=
 =?utf-8?B?S0ErUEtNU1Q4OWp4NlZvQ0hkWmQzWWhrUHYrakdYOTlHN2tHTlJqakd0VU9Y?=
 =?utf-8?B?V3RYS2cwMGtNWWxHaTlrVEVDQWxqQ3VUbWFvd09McjJWTUVqQlU0bEI0TUVu?=
 =?utf-8?B?YXFPbVZ0UUhNL3BmZkxSUndLRVh6dEJHcHdGTFNCNmp1eG1RV2FycG96LzZB?=
 =?utf-8?B?S21aVGltNThpd1E4YTltZysxZGRiNzQyUTNaZ05YTmFLRURLeDQrSHY1Y2tT?=
 =?utf-8?B?eXZSSmYxUGFhY0ZHK1FHbVZwbWR1S2VJMFRSRE5GTHJHYTE3Z1J6TDJGUEtL?=
 =?utf-8?B?NWN1S2lmbHVNay9iM2M4azJsTUIrdVB5NWhjOU5McWdmS2pJZDcwbUtuL2Nw?=
 =?utf-8?B?M2ZyVDV2VERJUERHZTEwWDV0bW1QVmRxa3dHa0pDcEtkUGNoeEFhTFBqYmpi?=
 =?utf-8?B?SkpTYlBRWUw3MDNveDVYL3dySmhoeGVnVU5RMHRSQ3RsQWxDcWFydUdlT0tz?=
 =?utf-8?B?UVlya29iU2piYzJNZmxyNC9XcnlqUU9oNE1wSDRJeGhRaWxBS3kyblV4YVB5?=
 =?utf-8?B?VU5WS0tmSFdwNms0QWJtTmdSaVZMbEIvRnlxQkRGOHVudDc5NFlKZmZLbXE4?=
 =?utf-8?B?YkVFR3BuTGdmb2FGSzBReU9UWjBwVnU1d29BdEhNU29YVGdqM29hYkVmcTBa?=
 =?utf-8?B?c3NKbDJHUXAvaTlwcVc3elRzaVlhRjM4ZGRCRmhEbENLS21DNU91d25HcHd5?=
 =?utf-8?Q?YTCaH/i7VtZ222r4g8/I7qF2P?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E144F80103065F4F989012C4427C3690@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21504c7e-2348-413c-597e-08dab6caea41
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 20:53:05.5990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z7rwW1bBAghrT/VBufqvUamtyPuyrKUjut6qgfQC/GetdVzea9KlU3/z6OYEGu/LMIR7F6y0L3QfZxEEH0z25w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5669
X-Proofpoint-GUID: C7errRbG96rbdnBbYG1tM32YwqCPIjZt
X-Proofpoint-ORIG-GUID: C7errRbG96rbdnBbYG1tM32YwqCPIjZt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_13,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 mlxlogscore=848 malwarescore=0 clxscore=1015 impostorscore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210250117
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCBPY3QgMjUsIDIwMjIsIEplZmYgVmFuaG9vZiB3cm90ZToNCj4gSGkgVGhpbmgsDQo+
IA0KPiBPbiBNb24sIE9jdCAyNCwgMjAyMiBhdCAxMTo1MTo1MFBNIC0wNTAwLCBKZWZmIFZhbmhv
b2Ygd3JvdGU6DQo+ID4gT24gTW9uLCBPY3QgMjQsIDIwMjIgYXQgMDY6Mjg6MDRQTSAtMDcwMCwg
VGhpbmggTmd1eWVuIHdyb3RlOg0KPiA+ID4gVGhlIGdhZGdldCBkcml2ZXIgbWF5IGhhdmUgYSBj
ZXJ0YWluIGV4cGVjdGF0aW9uIG9mIGhvdyB0aGUgcmVxdWVzdA0KPiA+ID4gY29tcGxldGlvbiBm
bG93IHNob3VsZCBiZSBmcm9tIHRvIGl0cyBjb25maWd1cmF0aW9uLiBNYWtlIHN1cmUgdGhlDQo+
ID4gPiBjb250cm9sbGVyIGRyaXZlciByZXNwZWN0IHRoYXQuIFRoYXQgaXMsIGRvbid0IHNldCBJ
TUkgKEludGVycnVwdCBvbg0KPiA+ID4gTWlzc2VkIElzb2MpIHdoZW4gdXNiX3JlcXVlc3QtPm5v
X2ludGVycnVwdCBpcyBzZXQuDQo+ID4gPiANCj4gPiA+IEZpeGVzOiA3MjI0NmRhNDBmMzcgKCJ1
c2I6IEludHJvZHVjZSBEZXNpZ25XYXJlIFVTQjMgRFJEIERyaXZlciIpDQo+ID4gPiBDYzogc3Rh
YmxlQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gU2lnbmVkLW9mZi1ieTogVGhpbmggTmd1eWVuIDxU
aGluaC5OZ3V5ZW5Ac3lub3BzeXMuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgQ2hhbmdlcyBpbiB2
MjoNCj4gPiA+ICAtIE5vbmUNCj4gPiA+IA0KPiA+ID4gIGRyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0
LmMgfCA0ICsrLS0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvZHdjMy9n
YWRnZXQuYyBiL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4gPiA+IGluZGV4IDIzMGIzYzY2
MDA1NC4uNzAyYmRmNDJhZDJmIDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy91c2IvZHdjMy9n
YWRnZXQuYw0KPiA+ID4gKysrIGIvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0KPiA+ID4gQEAg
LTEyOTIsOCArMTI5Miw4IEBAIHN0YXRpYyB2b2lkIGR3YzNfcHJlcGFyZV9vbmVfdHJiKHN0cnVj
dCBkd2MzX2VwICpkZXAsDQo+ID4gPiAgCQkJdHJiLT5jdHJsID0gRFdDM19UUkJDVExfSVNPQ0hS
T05PVVM7DQo+ID4gPiAgCQl9DQo+ID4gPiAgDQo+ID4gPiAtCQkvKiBhbHdheXMgZW5hYmxlIElu
dGVycnVwdCBvbiBNaXNzZWQgSVNPQyAqLw0KPiA+ID4gLQkJdHJiLT5jdHJsIHw9IERXQzNfVFJC
X0NUUkxfSVNQX0lNSTsNCj4gPiA+ICsJCWlmICghcmVxLT5yZXF1ZXN0Lm5vX2ludGVycnVwdCkN
Cj4gPiA+ICsJCQl0cmItPmN0cmwgfD0gRFdDM19UUkJfQ1RSTF9JU1BfSU1JOw0KPiA+ID4gIAkJ
YnJlYWs7DQo+ID4gPiAgDQo+ID4gPiAgCWNhc2UgVVNCX0VORFBPSU5UX1hGRVJfQlVMSzoNCj4g
PiA+IC0tIA0KPiA+ID4gMi4yOC4wDQo+ID4gPg0KPiA+IA0KPiA8c25pcD4NCj4gDQo+IEZvciBz
Y2F0dGVyIGdhdGhlciwgc2hvdWxkbid0IHRoZSBJTUkgYml0IGJlIHNldCBvbmx5IGZvciB0aGUg
VFJCIGFzc29jaWF0ZWQNCj4gdG8gdGhlIGxhc3QgaXRlbSBpbiB0aGUgc2cgbGlzdD8gIERvIHdl
IG5lZWQgdG8gZG8gc29tZXRoaW5nIHNpbWlsYXIgdG8gd2hhdA0KPiB0aGF0IHdhcyBkb25lIGZv
ciBJT0MgaW4gdGhpcyBhcmVhPw0KPiANCj4gRm9yIGV4LjoNCj4gKwlpZiAoKCFyZXEtPnJlcXVl
c3Qubm9faW50ZXJydXB0ICYmICFjaGFpbikgfHwgbXVzdF9pbnRlcnJ1cHQpDQo+ICsJCXRyYi0+
Y3RybCB8PSBEV0MzX1RSQl9DVFJMX0lTUF9JTUk7DQo+IA0KPiBCVFcsIERhbiBpbmRpY2F0ZWQg
dGhhdCB0aGlzIHNlZW1zIHRvIGhlbHAgcmVzb2x2ZSB0aGUgY3Jhc2ggbWVudGlvbmVkIGluDQo+
IFtQQVRDSCB2MiAxLzJdIG9mIHRoaXMgY2hhaW4uDQo+IA0KDQpBY3R1YWxseSwgdGhhdCdzIGNv
cnJlY3QuIEp1c3QgaWdub3JlIHRoZSAibXVzdF9pbnRlcnJ1cHQiIHNldHRpbmcuIFRoZQ0KcHJv
Z3JhbW1pbmcgZ3VpZGUgYWN0dWFsbHkgbm90ZWQgdG8gc2V0IHRoZSBJTUkgZm9yIHRoZSBsYXN0
IFRSQiBvZiB0aGUNCmNoYWluIGFsc28uDQoNCkknbGwgc2VuZCBhIGZpeCB0byB0aGlzLg0KDQpU
aGFua3MsDQpUaGluaA==
