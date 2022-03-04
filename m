Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF934CD3AB
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 12:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiCDLlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 06:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbiCDLlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 06:41:50 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11hn2233.outbound.protection.outlook.com [52.100.173.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056E4162013;
        Fri,  4 Mar 2022 03:41:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVe5fMAbegGFqBxjb7/LQ+HpO8bdlR2iTntCjb1CbW+U9eaYoVIbNITVMzqUfgud/zMg2AmX3XIXG8ZvP2Ql4PyKgdLAyxE2ECZS4d26FMjEkngVEzimvwgJDBWjT0KP5fNJT6HzLgQtFQrz1QfNKiNc4SyZierQCFKkqhYv/6r9+cGpVbTj0e0fB1Tbvr+oUgSMGF0d7uQzdkdsb3VdfCdGKY4QYrgW5VxD3K+6QcRb9sy++pdZjlvRh3mQ1AGbp9muIlgK1ppIFXXRX4iitZoCAIDFHwN6VjjsFFNQFheNpaNsYXEQ/2dHaRB0eVHziUOLIths84WNoR5tib48cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2wCbdxvHv2WaPeDBrVxiaqkZpJlXrAvHilU0Alu3te8=;
 b=MhxrDWiteKa3IJnaurWyMD8lEV15NvJFRebJRZeVUZNxdl2Qy3qA4PtcF36ead+5Ymq88r0FyJcmAabQIpuHTvte+1utSFOpuDSY5V4BZazQu3cpPoiOBRrLGA7Pv/Z3IOVpONrqDau786diRjgeQZW+F/TkSbVb5FLJtGCiEOsco4wa3s++qxw9FJB9+i2Lryj1HXWiqEwty6kBe//ga+GrcsdGg8Jn5O8MYrXsXKCTKx7vvOzhBx8gM0fqBPVULxp/46zKMTexX3mtyf0luu+VaZMRVAVb+20fYOjuDyDtB9FCIbQFZZq9P6M/wkcgFNqK5B+muMXvfBZ2PyeQuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uniminuto.edu.co; dmarc=pass action=none
 header.from=uniminuto.edu.co; dkim=pass header.d=uniminuto.edu.co; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=uniminuto0.onmicrosoft.com; s=selector2-uniminuto0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2wCbdxvHv2WaPeDBrVxiaqkZpJlXrAvHilU0Alu3te8=;
 b=k5umrPPT1B0+avxzT5uL7eJUel18i1iTO3jt4WYDbYNtNGSBAh6PfeYSQ6VcYhhOENjmAn+vouXeid0MkeeWDYKiLV6F86qSQRAELgHIWD1JUEdP1hM8pkZ2Fobe800qoPgkilSPswujhROfYE52O9aPuYekfGJ7/zMEUqwtK8g=
Received: from SN6PR10MB2958.namprd10.prod.outlook.com (2603:10b6:805:db::31)
 by BN6PR1001MB2275.namprd10.prod.outlook.com (2603:10b6:405:2f::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 11:40:58 +0000
Received: from SN6PR10MB2958.namprd10.prod.outlook.com
 ([fe80::e4c0:28a7:803c:78ed]) by SN6PR10MB2958.namprd10.prod.outlook.com
 ([fe80::e4c0:28a7:803c:78ed%5]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 11:40:58 +0000
From:   Maryoris Luz Mendoza Ruiz <mmendozarui@uniminuto.edu.co>
To:     "insjhu@mail.com" <insjhu@mail.com>
Subject: Re: Hola ***^
Thread-Topic: Hola ***^
Thread-Index: AQHYL7t1Vdl1Qj4i40yL6MItXFG/cayvKreA
Date:   Fri, 4 Mar 2022 11:40:58 +0000
Message-ID: <9CD2E140-8E67-45A2-875B-0189DF1D4ECA@uniminuto.edu.co>
References: <D3B8F760-1259-4538-A87D-D6CB28BCE719@uniminuto.edu.co>
In-Reply-To: <D3B8F760-1259-4538-A87D-D6CB28BCE719@uniminuto.edu.co>
Accept-Language: es-ES, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uniminuto.edu.co;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d07d86cb-463f-43f1-8e9c-08d9fdd3d9e8
x-ms-traffictypediagnostic: BN6PR1001MB2275:EE_
x-microsoft-antispam-prvs: <BN6PR1001MB22756BFEC3C49E4C3AA541ED81059@BN6PR1001MB2275.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DCQCyedTyL4jCLR4K86aw4+0TS6bliKJg+zXHKhfhJ/f2C0APYHxGUiFKCw5byn/Dtrm8g4TKopyJZQJYNjbfWewLFFeJc3LruAXitnYFQ359FidiM6ba5LDv70V56UPS129N4+2TKrE++CNphPjQ20zIz4N4kjzS1+LTUJOczCsLKklY5qFWvyK2uqyxIBCH0agduoPYjprCd3MZa76YktpiWvS1V93y9MJzP9VqqFDGexBvvEsgbj1tgunLqJ2A5VU+f4d+Qds5rpTAp73zI6Tpu+RKU/S9SJOx+Rz+wD5JDaVkxm7wE1iZAOA5TcJgUtb7B1UsH6JHFB6EbDqqjvSbQaA5Q5UmadnP+r1H/+8zOkVBj4Nr6SE+c7Tu9RuQU3sfsoPAvmRJ1+GR9r6ONKH1UFY4pMTsOq6NPOL3QFFIihK8BclZo5WWbsgdqVlGWwnZ8t4PELKSY/g286rVdQhCXVMNau4icIOg+Bhzqc1Lxx9r0j1TBUiIo5amzNDg1BaieipvOtJglzW0vvnUktqE5gJnePQq9o7hFeXWRijb1mu1mlLiwZRZV6uFkPBrJnitRRmy7CE994ZzSoIpZfeeelDq+W3KVVvFQdN3ucd+FVJubJ1FqC9fkxkeBnU2uN20G1q4elNZha/Z7aaWTCj1cbCg0p4IKmlbZ16quHkdd6S1cmG3+LzkWc9je7yrn2BGq5HgJKI30754j8XgSUl57CXZf92+bqy8xQbQ6EMGlPSLStzNdYsoBy//KkQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:es;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2958.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(7366002)(7336002)(6506007)(33656002)(38100700002)(7276002)(6916009)(7416002)(7406005)(186003)(5660300002)(2906002)(6512007)(26005)(8936002)(2616005)(16799955002)(38070700005)(15188155005)(786003)(316002)(508600001)(6486002)(966005)(76576003)(7116003)(86362001)(8676002)(71200400001)(76116006)(66446008)(66946007)(66476007)(122000001)(66556008)(64756008)(91956017)(3480700007)(17680700008)(48574002)(45980500001);DIR:OUT;SFP:1501;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OThHOVB6b0t0MEM1NFkzWEh0TG5nR1gvendSQ1FtOUVPdEh1Vk5NRzExeDVp?=
 =?utf-8?B?SGlHUjRyT2FYSzVLQlJEK3ViN2VGNzRKbUxrNFdTMGV5QzIwUTFMSytHc2ZW?=
 =?utf-8?B?VVk2MXplcXZUUUVqSUFxY0pjaDdROHhjays0UEsyYTlFQWp0dEg1WHJ1OG5G?=
 =?utf-8?B?Vll1MWV0TFJSYWJTY05TTFNtZFd2MGlOWHdkVXc5MXdvU2hpZXRXV3NNeWIr?=
 =?utf-8?B?UnVyLzVRVTlEN3VRaDl3bUpjUHBTdXNzajVJSDBjcWcrZ1g4WHZDa0tNcis1?=
 =?utf-8?B?cFh3SXI0SGw1NS9vRkVvUVBvR05SVGFuMmhsejBWQlpUcklIZnZ4SEx5dEJy?=
 =?utf-8?B?eGdaY3o2NEJCTEk1REMzekhqRWZWSVA4MS9iMDdzeUJxSmRyV2dwT0tiNm1p?=
 =?utf-8?B?aTJBM2dZTWtUVThiQU85a2JEaWszRU5oRlc1NDNQeWZ1OHAvVFNlRjh6Uk9R?=
 =?utf-8?B?MXpDSkh4eXU5TmkyL2c1M0U2aEFQTzZlVVVSSm5DemFDNDhFTDBtRUJWOS94?=
 =?utf-8?B?RHJ3MUwxOHVDN0VrZmwydkNvTnZYakcyRDd1OXB5L2RPUjZuMEhxd1dOTTRa?=
 =?utf-8?B?Z3poODBuVEN1ZFBIZWtzR0F6aEZOaTVDVFUwenErVmpramZ0REVSNjcydnY2?=
 =?utf-8?B?WEtDSEpQT0ZOb0dINFFpS2YrYlFMdE5CenY1bVNtSko0Si92Rzd4UWFVZThq?=
 =?utf-8?B?RDFpZVlxbFF0Ulg4VjFMM254dW12OG1NYnlhaW4wTzNXR0YrSm05K3R0MzdU?=
 =?utf-8?B?c284dlFnbHBHYzdMSEptWmFnajhNWWpteFFMKzJwWVRvZWFtYWdzVFpjRVIv?=
 =?utf-8?B?Mitkbmd0VmtrYlRNQ2l2dUhoL1p1NmtLT0RxMkR0OG8vdWRTTXdycUsxRUph?=
 =?utf-8?B?ZnFxUWxwWVFobXdSTE5GbmdtejFZRjFhSGd6ZEcxYlVJVFQwajhYQiswK0Fq?=
 =?utf-8?B?UHdSYWowR2xvTTBzNjhLSXBENEVXTFVJS3o0bkl1aXNyREc3N2VZTWRQOURh?=
 =?utf-8?B?bFVKZWNHQnhkU01Td2lKM2plbjVhS29FdHN5MjhWS05kWFZiY2p3SGExTGc3?=
 =?utf-8?B?dVJGZEtRUDZiME53YmE4QUY3aHV3bWpXeTNuNmhLY2RSWTkyMVdoREM5NXZO?=
 =?utf-8?B?YzdOUXc5Z2JkYzFjcVNFQ3pRcnRwMVpWUVcwZFROL3RobXZ2NVhnSzFjaEV4?=
 =?utf-8?B?Tnk1SDRzRkE2dnRzSVRhQkRib01rVVBocXhjT2tabzBBTlU4R2JJc01GbzY4?=
 =?utf-8?B?YVIxbUNHblpVbHZNeUpIQzF0NGI4eXVJS2YrYjg2Tkd0bHRpZzM0MjFySmZG?=
 =?utf-8?B?NStIeVR2WElMaFlvbXpwMTlLdGhmY2VaZzdiaDNWR05ZMnF3R1drT2ppNjU2?=
 =?utf-8?B?V05VZXhUV25Cb2ZFTjZKVzdBUnpqNm0zeGR5MTZNcDFlMEZkYTJoQWxrekVB?=
 =?utf-8?B?T3BTcWZFME5JQVBpZEFmcExtSDNzYzFjMjA4UUhDZnluVjVxUDlyYmQreUdT?=
 =?utf-8?B?aWxNZ1FTQzk3NllINktmdjl2UTNEVkJ4Q1FnUXpmZENEcncybWZiams1VWdo?=
 =?utf-8?B?NUNmV0Qwb25xVWI5Qmc0TEFXTVFCUVZhMjMvR2hQWGhqYU9POWhhT0p2U1kv?=
 =?utf-8?B?R09WMEd5YUNFclhPb2puNlkwRWdOUThaUVN1bno1bzlNdUZEb1l2K1BnbnFI?=
 =?utf-8?B?WndrTGJadVo1cFRwdzBsUGdFdjg4dkdoOVQvc2J1akJnTWtCdU1LWnVoTTlG?=
 =?utf-8?B?UmEyQUdpT2sxN2o3VVptM25URnRRdkQ4TFlDd1lnU3JqcklsTlQweWpUR3px?=
 =?utf-8?B?dktWRFM3SUIydWNnQUpRWC8yS3BtZ2k3Z25sWWRNSzd5SE9LRzBwaVZXRDZ4?=
 =?utf-8?B?N28wSWc4dFFxVDZPM1d2QUhwajZYMHFHVDFkM3VZeVl1QUxEN2JzYi8wVHBm?=
 =?utf-8?B?dld6bVZFTkp5UDE4NFQwUWZma1NHK3ZhYlZxQ29FV0kwLzhZdmhnZysxOUJz?=
 =?utf-8?B?TEhVSHAxV016OW16U3plSjcwVkhUVnUxcDVYZE5BeEFVNkJZUTU3Tjg5cEN6?=
 =?utf-8?B?T2xQZXNPVWs0dDdPL2xTeHMxL2pQaXgxY3oxQWFHUGk5VUI1bFZGM1VGaGR6?=
 =?utf-8?B?anh1Vk1zRGdUUSswbksxZElFWUlJNFpRS0w2ZGhDUXJ0U21EMlRFREhtblBu?=
 =?utf-8?B?UzN2dnptaXNSbDQzc2tmSDJ0MzE3bHBoVVVoOHdmVk1UWTU0OTBGZlhnRXdq?=
 =?utf-8?Q?clhX0Pr+VcGhiRFeqaAwkFWydBs/wlAv9nNkNWRNcU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <390CC4324FE80D4EA5F2D9CF5A61E0E4@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: uniminuto.edu.co
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2958.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d07d86cb-463f-43f1-8e9c-08d9fdd3d9e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2022 11:40:58.0615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b1ba85eb-a253-4467-9ee8-d4f8ed4df300
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yWQV7xHg9zVIDOgq9nxtGm2B3BOxxfHinHrWko/Pdt9t03+MzJaiQesq6YQQyVljFgptaLLrR/57u391WD6uAdNOre9tgpQLGkfUnGOxxyQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2275
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCu+7v09uIDMvNC8yMiwgMTI6MzEgUE0sICJNYXJ5b3JpcyBMdXogTWVuZG96YSBSdWl6IiA8
bW1lbmRvemFydWlAdW5pbWludXRvLmVkdS5jbz4gd3JvdGU6DQoNCiAgICBVbiBwcmVtaW8gZW4g
ZWZlY3Rpdm8gZGUgODIwLDAwMC4wMCBkb25hZG8gYSB1c3RlZCwgZW52w61lbm9zIHN1IG5vbWJy
ZSAgICAgY29ycmVvOiBkZW5pc2JlYXU1MDFAZ21haWwuY29tDQoNCg0KDQoNCkVuIGN1bXBsaW1p
ZW50byBkZSBsYSBsZXkgMTU4MSBkZSAyMDEyLCBVTklNSU5VVE8gZXN0w6EgY29tcHJvbWV0aWRh
IGNvbiBlbCB0cmF0YW1pZW50byBsw61jaXRvIHkgc2VndXJvIGRlIGxvcyBkYXRvcyBwZXJzb25h
bGVzIGRlIHN1cyBjb2xhYm9yYWRvcmVzIHkgdGVyY2Vyb3MsIGdhcmFudGl6YW5kbyBzdSBjb25m
aWRlbmNpYWxpZGFkLiBDb25zdWx0ZSBudWVzdHJhIFBvbMOtdGljYSBkZSBUcmF0YW1pZW50byBk
ZSBJbmZvcm1hY2nDs24gZW46IGh0dHA6Ly93d3cudW5pbWludXRvLmVkdS9kb2N1bWVudG9zLWlu
c3RpdHVjaW9uYWxlcy4gTG9zIHRpdHVsYXJlcyBlbiBjdWFscXVpZXIgbW9tZW50byBwdWVkZW4g
ZWplcmNlciBzdXMgZGVyZWNob3MgbGVnYWxtZW50ZSBjb25zYWdyYWRvcyBkZSBjb25vY2ltaWVu
dG8sIGFjdHVhbGl6YWNpw7NuLCByZWN0aWZpY2FjacOzbiB5IHN1cHJlc2nDs24gZGUgc3VzIGRh
dG9zIHBlcnNvbmFsZXMgYSB0cmF2w6lzIGRlbCBwb3J0YWwgd2ViIGh0dHA6Ly93d3cudW5pbWlu
dXRvLmVkdS9jb250YWN0byBvIGEgbGEgc2lndWllbnRlIGRpcmVjY2nDs246IENhbGxlIDgxQiBO
by43MkItNzAgZW4gbGEgY2l1ZGFkIGRlIEJvZ290w6EsIHkgZWwgdGVsw6lmb25vIDU5MzMwMDQg
ZW4gbGEgY2l1ZGFkIGRlIEJvZ290w6EsIG8gYSBuaXZlbCBuYWNpb25hbCAwMTgwMCAwOTM2Njcw
Lg0KDQpTaSBzdSBjb3JyZW8gbm8gZXMgaW5zdGl0dWNpb25hbCB5IGRlc2VhIHNlciBib3JyYWRv
IGRlIGxhIGxpc3RhIGRlIGVudsOtb3MgVU5JTUlOVVRPLCBoYWdhIGNsaWMgZW4gZWwgc2lndWll
bnRlIGVubGFjZSBodHRwOi8vc29wb3J0ZS51bmltaW51dG8uZWR1L2dscGkvcGx1Z2lucy9mb3Jt
Y3JlYXRvci9mcm9udC9mb3JtZGlzcGxheS5waHA/aWQ9NTAgcG9ycXVlIGVzdGUgbWVuc2FqZSBm
dWUgaGVjaG8gZXNwZWPDrWZpY2FtZW50ZSBwYXJhIHVzdGVkLiBFbiBzdSBsdWdhciwgdXNlIGxh
IHDDoWdpbmEgZGUgcmVlbnbDrW8gZW4gbnVlc3RybyBzaXN0ZW1hIGRlIGJvbGV0w61uIGRlIG5v
dGljaWFzLiBQYXJhIGNhbWJpYXIgc3VzIGRldGFsbGVzIHkgZWxlZ2lyIGEgcXXDqSBsaXN0YXMg
ZGVzZWEgc3VzY3JpYmlyc2UsIHZpc2l0ZSBzdSBww6FnaW5hIGRlIHByZWZlcmVuY2lhcyBwZXJz
b25hbDsgbyBwdWVkZXMgY2FuY2VsYXIgc3Ugc3VzY3JpcGNpw7NuIHBvciBjb21wbGV0byBkZSB0
b2RvcyBsb3MgZW52w61vcyBmdXR1cm9zLg0K
