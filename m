Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B418E6032B0
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 20:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiJRSqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 14:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiJRSqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 14:46:18 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6C5696FA;
        Tue, 18 Oct 2022 11:46:16 -0700 (PDT)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IHtAtV002795;
        Tue, 18 Oct 2022 11:45:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=Jj75c3v3ovYytU5kqvpQCM7NsDFIkSqTeMrCkutgLj0=;
 b=aaOnf1KtQWTRp5eOoG7DiBRVeJX3n+xFC1SAAH1Xsq2zJ7D5oN9iBncXqcGxQuvlhdAh
 aNb2hA60tYjNf1WtRXPmLVcasbTYnzewIsRKCoeqcTo4701eUC0JMyn2KQZLey8Ujxj7
 NdXa2F5a5G7jnq6vYXz1RVyZXwC1GunRkaHivYa77IOaCKoSJ8WKqY/n18UZ9nF0L42C
 xn91xMuBl6OFoed4LmNU9JxNygw6vkn37tum5ZKb+JG0B5+j7ZMS5sujLutySHaGOYc3
 iVxNBJ8dNRuqE83jFbISrlhKz+dbf9CupqrcGoAAxacF9C8upQDduiWIzvXTjlJ9fwsA SQ== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3k7uvnamsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 11:45:50 -0700
Received: from mailhost.synopsys.com (badc-mailhost3.synopsys.com [10.192.0.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 48D18C00FA;
        Tue, 18 Oct 2022 18:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666118749; bh=Jj75c3v3ovYytU5kqvpQCM7NsDFIkSqTeMrCkutgLj0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DOYz3yc+PeD0Cx7el62e4Tzy/KJTXOv26lnDP+fdpPscf8f226m6o2XDEZBuDO9Pk
         vEnmKbL2Lk/DioH/adHa4R2+nkc+qubAyKZLDUKsCPTt3+cxngA9TmEfkqBg/Ys/+j
         QLKQFIQeKNm4FC1NnIeaRdz0EKjwXfLOlYIRk94oVt4XWXJdlMTEWmwaqsTt5iDf/K
         DdvHdFNBx7CLV0FZePVlE3jExZhH5fEBq8GC/nn886wGIen+veWmr9UeURUbiqkSsJ
         hK1nEdNKttJBbpBEi6tTB4hMY6bWU67RxbdjnTNeUaWEvLAtfjI0oyuAv11/J9f05+
         zPwSQAzUSRjJA==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 61B4BA0082;
        Tue, 18 Oct 2022 18:45:46 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 5E70740085;
        Tue, 18 Oct 2022 18:45:44 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="I33DquvP";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gn8fTtBadCIqdKJB+omVR6J13rRyNZj/c6LDGjGlltOHLlCrcdTW0Gftz1FE8ducw8ywnhlN+FULgsn9uOcrQlG2E1E8ACd5XqkGkYZFgPPOY0CWmSZYS2v/c2q28aqPDokZLpGGNu+cN6ghJtcnZo63S4O+vJJAvuEeqGR8dMtw8kJI3JvHqBWKcUqqj0gOOW+NNEhEd+Lq8BDAFBF6nJ4YitzCKF+1/CcFrm0rNgXayByxeJ6D4GHPtxBxNy5fZAr5Nlt48WiucrFQYCkhQlUV9NFuoml4Obg4hzCWPTL55DqkdTp8AMGcipuIARTZ7GKLUAregKSYPWfjoWzkhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jj75c3v3ovYytU5kqvpQCM7NsDFIkSqTeMrCkutgLj0=;
 b=NmP3nWh5ttwntSFdNsCV3BGDJtg4lu8xYqBkhkQTPsFdaYC+CXOC+jhfGpfFg39sZ8tnecfGZNcbhbfT8MPDuDhQsT66A64M/6NfWd6bPRpoTjVfP5czx9ZjoIWSkQT7ETs7qPLOwPg6Xrhe9Erq2whXvkGcUTI7Hc1UseqzhEWF8PYkfwrOUMjCG2w+YwHaPxW4BuAOS12Sa90sUFucSaQ+q1+FkyAMHRtMJT2vWOg9IUxT4xCTmz/2mHHuh305ITVcC6nHpaMd+rllJmOSc24VPifG0FvrRI8vuHvSLyu9oT/MBVtnYxE56fTQip6PKrP3rkKog8i6yeBGKTLHYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jj75c3v3ovYytU5kqvpQCM7NsDFIkSqTeMrCkutgLj0=;
 b=I33DquvPxcwhX+G63r5b5TC0m4Ha3bHzV7RoTEJYKkDuqFpBj2YQqtOE1ueXP6FGgk0k0Rry7OJ4uUy33Jh4OnD1kSZ3JI+TGC6RXZZK7HS38XAVnvw1FQHDCvsUCUNuI3yz6I8fsbxSgBbaZG4Nh84cZ619PC5jb5HKYDf0xHA=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by SN7PR12MB6931.namprd12.prod.outlook.com (2603:10b6:806:261::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 18:45:41 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.031; Tue, 18 Oct 2022
 18:45:41 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Dan Vacura <w36195@motorola.com>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Daniel Scally <dan.scally@ideasonboard.com>,
        Jeff Vanhoof <qjv001@motorola.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v3 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Thread-Topic: [PATCH v3 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Thread-Index: AQHY4mrMbMdbRPcOxEKXMohPF6Ycjq4TGoiAgABOUICAARXvgA==
Date:   Tue, 18 Oct 2022 18:45:40 +0000
Message-ID: <20221018184535.3g3sm35picdeuajs@synopsys.com>
References: <20221017205446.523796-1-w36195@motorola.com>
 <20221017205446.523796-3-w36195@motorola.com>
 <20221017213031.tqb575hdzli7jlbh@synopsys.com> <Y04K/HoUigF5FYBA@p1g3>
In-Reply-To: <Y04K/HoUigF5FYBA@p1g3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|SN7PR12MB6931:EE_
x-ms-office365-filtering-correlation-id: 5e7bdd10-ebdb-4285-25a5-08dab138f4b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8RlowCjmlot+RVBM4xcn6r93wxyc7dyV4MXFiUfpAuhZUtWfmkvAbpDO8vwEzPstRq5rMxRzGl5hxG477TXrMdU72pntQ5iL6NsxRlctE/AQ7VqKnmN7MN6DH3Slw1dPsBcmRMdci1fIbpkDEOGTaOuEjud965ZdVoyqzvY0xi45yyKu6LePQ/wzHSwMZFdeQtwC0/Bk2wfXIiLIpaqv+iclS3TdKljun7u+rPxmo2VUdgXEy1LGcSjZidYoFTJNRoXoLKBs8hwV1V+IrTs76l4nnjfjfHzFD3D6cdpl4RygF5Re5bzBMn+w+qI+/8NEF7Gs/PI0wvDAHtmQa+YnGcReiZCcwPZT+JN2GMBkahVmvoSV2NlK5DovbLqXbXFy2NIOsB2eU2xM9jy2pQZbbLtWL5aHatq5pjchq8p06654/37WTn4LWqUEoxngy5mP9bHtZeYODtUXUSFuJpGQ6g4jNfCW+Qwsd2wBLjbep32oYarppKD/l28FHL0rMzCWCuDai6bvXkobgfuS2zrkog5y2wkk9NdGYhZS4vJbFpfOtHjr4XoqYe7+AGgjY9wKNg9NgoWwVd2Mqqhg2+IBiTJIA2ramUre2vLNg0FVdG19KrB18hZ97pNZ3h7KBfcVyRIRP7uYlSG5Cs8nzFm76TdJjThTi1kbuItGluFB3cFUjFgt4PyWNibWQ4tcVQOp8Ra4sHZjYa7FMLVjW98cnNhjcZiVx/ydxT+2SU4aO1LRdOIzoQsLhvII7Jj2/WPsZUFsUmhxdFwiZaaNd8tXj0yu9DCvaiIsdZquo6PL6TU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(376002)(136003)(346002)(84040400005)(451199015)(83380400001)(38070700005)(36756003)(86362001)(122000001)(38100700002)(76116006)(66556008)(316002)(6916009)(54906003)(7416002)(5660300002)(71200400001)(8936002)(186003)(66476007)(1076003)(966005)(6486002)(2906002)(2616005)(6506007)(66946007)(478600001)(64756008)(6512007)(26005)(66446008)(41300700001)(8676002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cnJJWUVHZllQZ0pUQnE3akNVSFI3UVB4Zzl2bmxWMU5NekJ4OXlyWXRNaVdG?=
 =?utf-8?B?T0laSVNJSlZObHVUeUNIWmNxdXc4bmdLbUtLM0Ztdzh5d1dXeTZsTUJpNVAr?=
 =?utf-8?B?WU85SmZHMnFWOWNNdVRtVDZVdXhVVGFDemlYSng5T2dLaC9oaDNhNUw0cGFC?=
 =?utf-8?B?Q1ZjamcvOUlWSUY0aVhKelhldXg3eHNlUm9UK29ISzVxVVRKMTdXdEgrRTFE?=
 =?utf-8?B?eE5tQ2JBaDN2a3lYR2t1cnlJbUNyMDEvc2JmTXdhdHd3b2lZN0RiTVlWQTFO?=
 =?utf-8?B?WTduRVpkRVB3MlJ5bTczL203R200UVgyRmRaenpBZEZ2VDRFVzJoYUZ4ZjRH?=
 =?utf-8?B?R3duOWVKaGwvT21Gb0gwN3ZnN2E3OENJbVVqbndUNWdrcDhIOWwzTGhHYU1o?=
 =?utf-8?B?OFZSMjRsZkpGM08vQnIraDl4c2ZETVlrNzVPU21vN1E1NVc0OUhHd3JmRldu?=
 =?utf-8?B?RVE0VGRXcnVtS3hCRlZWaE5iM0luTWVJZkp3cjdXZnJJME1TOGtadDYvSlJV?=
 =?utf-8?B?OEF4cDF5Q2VCTXYzWHU1QnJXbEtqb1UyeGZUMjQwRUdldUdMM1N5WmZHUHBR?=
 =?utf-8?B?MzYxbXFWeENqSnUrMjZPRlJzU2ZKMmNjc2VnUzFTd2RDRWRwTit6NU9EcGJs?=
 =?utf-8?B?bUl2NkZCTk5aYkt0bEp4bzJxZnBBeElLdmk0RjdndXZBTllsWURXY1V2ZmFG?=
 =?utf-8?B?TnJyTDd3dS9wQUIzck1NTjVBK25hQXc3ZHR3Sm44ZVR0dVorUm1JeXBkRGt4?=
 =?utf-8?B?eVVmZUFTanoyTGF0cjNOdjVkOXFrZDJtak1xQVpvUFNJWm9oU1dWbkNkTnBv?=
 =?utf-8?B?Yy9XY3BQQWYrVCtJcExZS25hM3JxMFgvLytjTVV6bkFRZ1hhMFRzSVZjRUdX?=
 =?utf-8?B?dlVuQ1FBRlNnemVXdHpQSGdQMHU4QjlnMU9EZnJjZ052cTd1MCtZTTRsVCtx?=
 =?utf-8?B?bHp6SDlxQXZoaVExdDU5YnQvUFhra2V5T1l3TmVhdjB4OHFGamo1QkhCWXBY?=
 =?utf-8?B?bHgwZ1F4aXE0cTVtWUcvY1BKSWlyK0lqZ1lCRDNGcTBINEFaUlhRVnBQa2tr?=
 =?utf-8?B?eTJPaWF4UHB1WnpXNzlUOUZobFNIci95U0RLTGFkSk1USStyNjdLdjVtYXdq?=
 =?utf-8?B?Vm9hOGlQTVJrUGFFa1pJd3RheTFZdDczVTQ2OFNTZlJOVUNQTlFKUGtvR282?=
 =?utf-8?B?eTM2UzhhZzlvd3VXaDZpTlVVMGJnMVk1aHRmZmVuUm5kMExkclMwdDRLY09k?=
 =?utf-8?B?Mkl1M2NlOWx4RmpwSmU2VElUYWx5eFc5RFo4S0RDd2E1aVA0a25OWTJRcXFF?=
 =?utf-8?B?N0xDTE1SdkNVdFVranJKLy81S3BlLzZqSndMQVhOWDFmdjNNV1hBTkx1Q0VP?=
 =?utf-8?B?ZWpkMmRNaE9ubVF2Z1VPVXZKT3hDOHZDVkQwRFVzaUlqOWtNSEVLV0hzV3Ay?=
 =?utf-8?B?ZmV3U3ErTVZJQmVCaTJhZ3VOVmNSeUtlV2Q4bURORGZ4SGtTUmtZZ0xQQk9Q?=
 =?utf-8?B?aG8xVXNQMXI3NG4wUlFSWTdWdFBFbmdONzMrSFRHZks3dTFDSUpnUmZpazNu?=
 =?utf-8?B?WkozUTJKRnBQeTc4cGU4VFlLZDlMMjhqUmZ5NXFsZGtxOTN3akZ5cnBOTmtt?=
 =?utf-8?B?dmx0MnYzdzc5UkRGT1hzOTdqMzdOVDZIK3VEcUVUWldISThTRU5VUGZSQ2VN?=
 =?utf-8?B?YjU3MDFIZ3NUaVVFZFlvZlZteDVhN0lmOGI4cG9CT0RvY0xObmtZWGNyazBj?=
 =?utf-8?B?ZGJrNGtaYm5ROVJ6dkF1bHBLK2VCNmkycDFqVEhETnlqQjVQYlMvaWZNQXVv?=
 =?utf-8?B?elZzbGlQcWRUeWNnNW1aNjc1aytaOXErOXdWSjBxc2RhTDI3MGorWGJENEFt?=
 =?utf-8?B?c1Ruekd0bFBWd1ZzQWNISkFyNm9LanBkbUpKb2haWUpTaWswYTlHTHRHVnp0?=
 =?utf-8?B?UzVyTUdQYVdqYmt4cVNaU0ZOM2hUSk50YUZ3YW1sSEloTjZFczVodXg0K0w2?=
 =?utf-8?B?NDk1Tm5sSHhBRk9Ud1U5L1VOUHBwUDkrWTN1TlEyeGl3VHFDVEJ3OFJQNHRU?=
 =?utf-8?B?dkRHWTBYTjRJVWhTOERHaWwrYjlydEdJbFU0UTdMU25oQmZQam9ZdFEwb0xT?=
 =?utf-8?Q?eGIaelx0dCABAEVHV5Woguq7h?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4995321ADE8F2046992C7F058438944E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e7bdd10-ebdb-4285-25a5-08dab138f4b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 18:45:40.7765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kL8WY5aW1dUvcZJvCdEeV4ChwjX+T+lUhrmR+K4K5cfP0drtOzsGsPjSpoiydt5E1kKAJVyKWPiB3cZdeQl7TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6931
X-Proofpoint-ORIG-GUID: jl2evOmshlku-t2m_ABTEF2m6LoczMmU
X-Proofpoint-GUID: jl2evOmshlku-t2m_ABTEF2m6LoczMmU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_07,2022-10-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 clxscore=1015 impostorscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210180106
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgRGFuLA0KDQpPbiBNb24sIE9jdCAxNywgMjAyMiwgRGFuIFZhY3VyYSB3cm90ZToNCj4gSGkg
VGhpbmgsDQo+IA0KPiBPbiBNb24sIE9jdCAxNywgMjAyMiBhdCAwOTozMDozOFBNICswMDAwLCBU
aGluaCBOZ3V5ZW4gd3JvdGU6DQo+ID4gT24gTW9uLCBPY3QgMTcsIDIwMjIsIERhbiBWYWN1cmEg
d3JvdGU6DQo+ID4gPiBGcm9tOiBKZWZmIFZhbmhvb2YgPHFqdjAwMUBtb3Rvcm9sYS5jb20+DQo+
ID4gPiANCj4gPiA+IGFybS1zbW11IHJlbGF0ZWQgY3Jhc2hlcyBzZWVuIGFmdGVyIGEgTWlzc2Vk
IElTT0MgaW50ZXJydXB0IHdoZW4NCj4gPiA+IG5vX2ludGVycnVwdD0xIGlzIHVzZWQuIFRoaXMg
Y2FuIGhhcHBlbiBpZiB0aGUgaGFyZHdhcmUgaXMgc3RpbGwgdXNpbmcNCj4gPiA+IHRoZSBkYXRh
IGFzc29jaWF0ZWQgd2l0aCBhIFRSQiBhZnRlciB0aGUgdXNiX3JlcXVlc3QncyAtPmNvbXBsZXRl
IGNhbGwNCj4gPiA+IGhhcyBiZWVuIG1hZGUuICBJbnN0ZWFkIG9mIGltbWVkaWF0ZWx5IHJlbGVh
c2luZyBhIHJlcXVlc3Qgd2hlbiBhIE1pc3NlZA0KPiA+ID4gSVNPQyBpbnRlcnJ1cHQgaGFzIG9j
Y3VycmVkLCB0aGlzIGNoYW5nZSB3aWxsIGFkZCBsb2dpYyB0byBjYW5jZWwgdGhlDQo+ID4gPiBy
ZXF1ZXN0IGluc3RlYWQgd2hlcmUgaXQgd2lsbCBldmVudHVhbGx5IGJlIHJlbGVhc2VkIHdoZW4g
dGhlDQo+ID4gPiBFTkRfVFJBTlNGRVIgY29tbWFuZCBoYXMgY29tcGxldGVkLiBUaGlzIGxvZ2lj
IGlzIHNpbWlsYXIgdG8gc29tZSBvZiB0aGUNCj4gPiA+IGNsZWFudXAgZG9uZSBpbiBkd2MzX2dh
ZGdldF9lcF9kZXF1ZXVlLg0KPiA+IA0KPiA+IFRoaXMgZG9lc24ndCBzb3VuZCByaWdodC4gSG93
IGRpZCB5b3UgZGV0ZXJtaW5lIHRoYXQgdGhlIGhhcmR3YXJlIGlzDQo+ID4gc3RpbGwgdXNpbmcg
dGhlIGRhdGEgYXNzb2NpYXRlZCB3aXRoIHRoZSBUUkI/IERpZCB5b3UgY2hlY2sgdGhlIFRSQidz
DQo+ID4gSFdPIGJpdD8NCj4gDQo+IFRoZSBwcm9ibGVtIHdlJ3JlIHNlZWluZyB3YXMgbWVudGlv
bmVkIGluIHRoZSBzdW1tYXJ5IG9mIHRoaXMgcGF0Y2gNCj4gc2VyaWVzLCBpc3N1ZSAjMS4gQmFz
aWNhbGx5LCB3aXRoIHRoZSBmb2xsb3dpbmcgcGF0Y2gNCj4gaHR0cHM6Ly91cmxkZWZlbnNlLmNv
bS92My9fX2h0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9saW51eC11c2IvcGF0
Y2gvMjAyMTA2MjgxNTUzMTEuMTY3NjItNi1tLmdyemVzY2hpa0BwZW5ndXRyb25peC5kZS9fXzsh
IUE0RjJSOUdfcGchYVNOWi1Jak1jUGdMNDdBNE5SNXFwOXFoVmxQOTFVR1R1Q3hlajVOUlR2OC1G
bVRyTWtLSzdDak5Ub1FRVkVndHBxYkt6TFUySFhFVDlPMjI2QUVOJCAgDQo+IGludGVncmF0ZWQg
YSBzbW11IHBhbmljIGlzIG9jY3VycmluZyBvbiBvdXIgQW5kcm9pZCBkZXZpY2Ugd2l0aCB0aGUg
NS4xNQ0KPiBrZXJuZWwgd2hpY2ggaXM6DQo+IA0KPiAgICAgPDM+WyAgNzE4LjMxNDkwMF1bICBU
ODAzXSBhcm0tc21tdSAxNTAwMDAwMC5hcHBzLXNtbXU6IFVuaGFuZGxlZCBhcm0tc21tdSBjb250
ZXh0IGZhdWx0IGZyb20gYTYwMDAwMC5kd2MzIQ0KPiANCj4gVGhlIHV2YyBnYWRnZXQgZHJpdmVy
IGFwcGVhcnMgdG8gYmUgdGhlIGZpcnN0IChhbmQgb25seSkgZ2FkZ2V0IHRoYXQNCj4gdXNlcyB0
aGUgbm9faW50ZXJydXB0PTEgbG9naWMsIHNvIHRoaXMgc2VlbXMgdG8gYmUgYSBuZXcgY29uZGl0
aW9uIGZvcg0KPiB0aGUgZHdjMyBkcml2ZXIuIEluIG91ciBjb25maWd1cmF0aW9uLCB3ZSBoYXZl
IHVwIHRvIDY0IHJlcXVlc3RzIGFuZCB0aGUNCj4gbm9faW50ZXJydXB0PTEgZm9yIHVwIHRvIDE1
IHJlcXVlc3RzLiBUaGUgbGlzdCBzaXplIG9mIGRlcC0+c3RhcnRlZF9saXN0DQo+IHdvdWxkIGdl
dCB1cCB0byB0aGF0IGFtb3VudCB3aGVuIGxvb3BpbmcgdGhyb3VnaCB0byBjbGVhbnVwIHRoZQ0K
PiBjb21wbGV0ZWQgcmVxdWVzdHMuIEZyb20gdGVzdGluZyBhbmQgZGVidWdnaW5nIHRoZSBzbW11
IHBhbmljIG9jY3Vycw0KPiB3aGVuIGEgLUVYREVWIHN0YXR1cyBzaG93cyB1cCBhbmQgcmlnaHQg
YWZ0ZXINCj4gZHdjM19nYWRnZXRfZXBfY2xlYW51cF9jb21wbGV0ZWRfcmVxdWVzdCgpIHdhcyB2
aXNpdGVkLiBUaGUgY29uY2x1c2lvbg0KPiB3ZSBoYWQgd2FzIHRoZSByZXF1ZXN0cyB3ZXJlIGdl
dHRpbmcgcmV0dXJuZWQgdG8gdGhlIGdhZGdldCB0b28gZWFybHkuDQoNCkFzIEkgbWVudGlvbmVk
LCBpZiB0aGUgc3RhdHVzIGlzIHVwZGF0ZWQgdG8gbWlzc2VkIGlzb2MsIHRoYXQgbWVhbnMgdGhh
dA0KdGhlIGNvbnRyb2xsZXIgcmV0dXJuZWQgb3duZXJzaGlwIG9mIHRoZSBUUkIgdG8gdGhlIGRy
aXZlci4gQXQgbGVhc3QgZm9yDQp0aGUgcGFydGljdWxhciByZXF1ZXN0IHdpdGggLUVYREVWLCBp
dHMgVFJCcyBhcmUgY29tcGxldGVkLiBJJ20gbm90DQpjbGVhciBvbiB5b3VyIGNvbmNsdXNpb24u
DQoNCkRvIHdlIGtub3cgd2hlcmUgZGlkIHRoZSBjcmFzaCBvY2N1cj8gSXMgaXQgZnJvbSBkd2Mz
IGRyaXZlciBvciBmcm9tIHV2Yw0KZHJpdmVyLCBhbmQgYXQgd2hhdCBsaW5lPyBJdCdkIGdyZWF0
IGlmIHdlIGNhbiBzZWUgdGhlIGRyaXZlciBsb2cuDQoNCj4gDQo+ID4gDQo+ID4gVGhlIGR3YzMg
ZHJpdmVyIHdvdWxkIG9ubHkgZ2l2ZSBiYWNrIHRoZSByZXF1ZXN0cyBpZiB0aGUgVFJCcyBvZiB0
aGUNCj4gPiBhc3NvY2lhdGVkIHJlcXVlc3RzIGFyZSBjb21wbGV0ZWQgb3Igd2hlbiB0aGUgZGV2
aWNlIGlzIGRpc2Nvbm5lY3RlZC4NCj4gPiBJZiB0aGUgVFJCIGluZGljYXRlZCBtaXNzZWQgaXNv
YywgdGhhdCBtZWFucyB0aGF0IHRoZSBUUkIgaXMgY29tcGxldGVkDQo+ID4gYW5kIGl0cyBzdGF0
dXMgd2FzIHVwZGF0ZWQuDQo+IA0KPiBJbnRlcmVzdGluZywgdGhlIGRldmljZSBpcyBub3QgZGlz
Y29ubmVjdGVkIGFzIHdlIGRvbid0IGdldCB0aGUNCj4gLUVTSFVURE9XTiBzdGF0dXMgYmFjayBh
bmQgd2l0aCB0aGlzIHBhdGNoIGluIHBsYWNlIHRoaW5ncyBjb250aW51ZQ0KPiBhZnRlciBhIC1F
WERFViBzdGF0dXMgaXMgcmVjZWl2ZWQuDQo+IA0KDQpBY3R1YWxseSwgbWlub3IgY29ycmVjdGlv
biBoZXJlOiBhIHJlY2VudCBjaGFuZ2UNCmI0NGMwZTdmZWY1MSAoInVzYjogZHdjMzogZ2FkZ2V0
OiBjb25kaXRpb25hbGx5IHJlbW92ZSByZXF1ZXN0cyIpDQpjaGFuZ2VkIC1FU0hVVERPV04gcmVx
dWVzdCBzdGF0dXMgdG8gLUVDT05OUkVTRVQgd2hlbiBkaXNhYmxlIGVuZHBvaW50Lg0KVGhpcyBk
b2Vzbid0IGxvb2sgcmlnaHQuDQoNCldoaWxlIGRpc2FibGluZyBlbmRwb2ludCBtYXkgYWxzbyBh
cHBseSBmb3Igb3RoZXIgY2FzZXMgc3VjaCBhcw0Kc3dpdGNoaW5nIGFsdGVybmF0ZSBpbnRlcmZh
Y2UgaW4gYWRkaXRpb24gdG8gZGlzY29ubmVjdCwgLUVTSFVURE9XTg0Kc2VlbXMgbW9yZSBmaXR0
aW5nIHRoZXJlLg0KDQpIaSBNaWNoYWVsLA0KDQpDYW4geW91IGhlbHAgY2xhcmlmeSBmb3IgdGhl
IGNoYW5nZSBhYm92ZT8gVGhpcyBjaGFuZ2VkIHRoZSB1c2FnZSBvZg0KcmVxdWVzdHMuIE5vdyBy
ZXF1ZXN0cyByZXR1cm5lZCBieSBkaXNjb25uZWN0aW9uIHdvbid0IGJlIHJldHVybmVkIGFzDQot
RVNIVVRET1dOLg0KDQo+ID4gDQo+ID4gVGhlcmUncyBhIHNwZWNpYWwgY2FzZSB3aGljaCBkd2Mz
IG1heSBnaXZlIGJhY2sgcmVxdWVzdHMgZWFybHkgaXMgdGhlDQo+ID4gY2FzZSBvZiB0aGUgZGV2
aWNlIGRpc2Nvbm5lY3RpbmcuIFRoZSByZXF1ZXN0cyBzaG91bGQgYmUgcmV0dXJuZWQgd2l0aA0K
PiA+IC1FU0hVVERPV04sIGFuZCB0aGUgZ2FkZ2V0IGRyaXZlciBzaG91bGRuJ3QgYmUgcmUtdXNp
bmcgdGhlIHJlcXVlc3RzIG9uDQo+ID4gZGUtaW5pdGlhbGl6YXRpb24gYW55d2F5Lg0KPiA+IA0K
PiA+IFdlIHNob3VsZCBub3QgaXNzdWUgRW5kIFRyYW5zZmVyIGNvbW1hbmQganVzdCBiZWNhdXNl
IG9mIG1pc3NlZCBpc29jLiBXZQ0KPiA+IG1heSB3YW50IGlzc3VlIEVuZCBUcmFuc2ZlciBpZiB0
aGUgZ2FkZ2V0IGRyaXZlciBpcyB0b28gc2xvdyBhbmQgdW5hYmxlDQo+ID4gdG8gZmVlZCByZXF1
ZXN0cyBpbiB0aW1lIChjYXVzaW5nIHVuZGVycnVuIGFuZCBtaXNzZWQgaXNvYykgdG8gcmVzeW5j
DQo+ID4gd2l0aCB0aGUgaG9zdCwgYnV0IHdlIGFscmVhZHkgaGFuZGxlIHRoYXQuDQo+IA0KPiBI
bW0sIGlzbid0IHRoYXQgd2hhdCBoYXBwZW5zIHdoZW4gd2UgZ2V0IGludG8gdGhpcw0KPiBjb25k
aXRpb24gaW4gZHdjM19nYWRnZXRfZW5kcG9pbnRfdHJic19jb21wbGV0ZSgpOg0KPiANCj4gCWlm
ICh1c2JfZW5kcG9pbnRfeGZlcl9pc29jKGRlcC0+ZW5kcG9pbnQuZGVzYykgJiYNCj4gCQlsaXN0
X2VtcHR5KCZkZXAtPnN0YXJ0ZWRfbGlzdCkgJiYNCj4gCQkobGlzdF9lbXB0eSgmZGVwLT5wZW5k
aW5nX2xpc3QpIHx8IHN0YXR1cyA9PSAtRVhERVYpKQ0KPiAJCWR3YzNfc3RvcF9hY3RpdmVfdHJh
bnNmZXIoZGVwLCB0cnVlLCB0cnVlKTsNCj4gDQoNClllcywgaXQncyBiZWluZyBoYW5kbGVkIHRo
ZXJlLg0KDQo+ID4gDQo+ID4gSSdtIHN0aWxsIG5vdCBjbGVhciB3aGF0J3MgdGhlIHByb2JsZW0g
eW91J3JlIHNlZWluZy4gRG8geW91IGhhdmUgdGhlDQo+ID4gY3Jhc2ggbG9nPyBUcmFjZXBvaW50
cz8NCj4gPiANCj4gDQo+IEFwcHJlY2lhdGUgdGhlIHN1cHBvcnQhDQo+IA0KDQpUaGFua3MsDQpU
aGluaA==
