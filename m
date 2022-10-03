Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC43B5F382B
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 23:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiJCV54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 17:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJCV5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 17:57:55 -0400
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6B22F657;
        Mon,  3 Oct 2022 14:57:54 -0700 (PDT)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293LgWLF025717;
        Mon, 3 Oct 2022 14:57:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=kr6zPlM7HkIDA69HKUgLia+BqyDy27/LezYLnyqusLo=;
 b=tMet6uWTS+vaABNPDJrP0S/D2cL/6deUUdS0UK2vtyaJb7pgjBI/0X0uHEXgCmQexThP
 lXeGseEFwppe0MLbrkSF462BARJ5ymP1Wvz1P3q9dbTsIBTrMGrhE4/ayGxBS9llCh5a
 0nBRJ6DG6cHd3hWjcFadQrbPQlTIkKbd+PZBdk1i/33XiPnm/UHZFlbNPM8BuLn7fstw
 PIjX7CexO7FdxRjyGhV6xWhgr1bGgXvnvE5Wztiw4Hgc2IC+QMdFGhcX3l1IwpI7WhFx
 bH6NN845VlvnNYLx9ita+EAcAZI1WzB8oKJrFQTxZmCJ2vARq1P9Lr1lSROvMaJBuA4s rg== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3jxmfv9br8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Oct 2022 14:57:41 -0700
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2E2AC400B4;
        Mon,  3 Oct 2022 21:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1664834260; bh=kr6zPlM7HkIDA69HKUgLia+BqyDy27/LezYLnyqusLo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=NeUliVUog060mhEAQVzNotOD2mdQbos18JoGjag3MZytDV/uzyLyRPcVW+q7jitQn
         JWkYEWUUf+tXdgT6stCKSbYFpEwwCcQQbiPagbn/l/zg6qgGOfcT4zCN/bWy+Q6o6Z
         AD/Cv4pkfiwvmTQxhMzQr5WBRO8OG2kExlrrlWf8rySrna7rGQKmLAfuBdxPt3qYB4
         1Yl68DUw3fW+qpNnZdGnIutprrWZqFj64Zs1eEJYKOwdPcLor4ui43icTOFsutv5y5
         NIJOb380e9GmiXWOCtMu/j3p0R0qNofNItByi8ULCJmPmkGf3xz6+7DLY2IgyneqzC
         wmKdOCca3TytA==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 69E5CA00C4;
        Mon,  3 Oct 2022 21:57:39 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 95C4C8007A;
        Mon,  3 Oct 2022 21:57:38 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="LXDJObia";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anNhC3meJkGdm5sM6/15OoRghqJQqx4uMA+O5Y3idKLYrvktOFaMZinaBFD55J/2zpX+6vcyJboZT0z3Rrs/ndd37q+G2ZPaG3To1ejUgK7AbmaRk9Kc8oYPFUZ5U4H4TtV2f27y8tw6bM/3kc7N+SsdQo97RwbSgyxEWTczyGPU1+bfKs/tQu4IldMcVNCXuUlowPapQ9OiNhSJgXOnvVj4uHd36/i8XlTGkiLl2c2ZZkRoZ/om4HJzDOoaT2JmH85K9KySRQHwNeJ4ODtBh5vzEeEhFKuyZCy8eYu78I7nwI3Kt7ULefKXKsgETfg8+ho28pWygcuUDC8PrHxDtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kr6zPlM7HkIDA69HKUgLia+BqyDy27/LezYLnyqusLo=;
 b=GPi0xYKHZpLj2tNziR2IE5fOMcbjcLLWSvDu7bdoF92+CLLIiasbBPx71G8KSv+q4NXo8k+h3fJMdVGS4K4qIz4AVF8LR1w5OkaCItjh9QUtr2XlXNtQIwmNDBEDZxSFR6y2LwcOITGLRtJtHiwnC17PmBCSOnYesh/1fYxU9IKuc6kr6sylsNMfWXBfisTrsUldrlKBrXRZ8cae7WQ81eYb7gbpsgwIwQhqV7ny9bRZbWsHRdPJvrrYy9+jknED8Nj+3Xm4S5f1lQENZoa8LDn1C735DsVoQ3l5Hl8VhJtaW4t1n0QC4myS52So4QOZRnEHjhNWZAGglwU83HcRjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kr6zPlM7HkIDA69HKUgLia+BqyDy27/LezYLnyqusLo=;
 b=LXDJObias+DY+NeLb9FDN/JC1g19ebywEUihm46aqcKT9XHHYMxbkkLD3UDoCmfQoRNOOLKGyES/ZOSzlkCLkAqRJ1cQZRjOPDmOaUtNHZNX1tF6OpGIVwHHGaFZR5fikczx9VT2f68/qZuW4632VNsSO52zTkSUBuGJfV/tusw=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by PH7PR12MB5829.namprd12.prod.outlook.com (2603:10b6:510:1d4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.30; Mon, 3 Oct
 2022 21:57:35 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.028; Mon, 3 Oct 2022
 21:57:35 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>, Ferry Toth <fntoth@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Thread-Topic: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Thread-Index: AQHY0omsjm4tTlL0CEmkY916+rpAAK39QTUA
Date:   Mon, 3 Oct 2022 21:57:35 +0000
Message-ID: <20221003215734.7l3cnb2zy57nrxkk@synopsys.com>
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
 <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|PH7PR12MB5829:EE_
x-ms-office365-filtering-correlation-id: ba1c2196-a93c-4b37-a022-08daa58a47e7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i1LVdH1WbeGdc4ID+AKHQAyr0BYAV1tIjCYV9OJXKvQQjHY3I78HFD5B/Op3WSjelKsbUcCw/lqjrWkun9INxyXx6Yt0u9N5lZCQSP8wjath0/Yv3ZSxTu+itsGyJsv3bJtz0h7XYbmmpIvWWEcFshttaIi/22tKBbC8S9vnbjar5xsWZhgRHNvUqEdUkoPSLZRRF91EhAkuoCHsE+vRzp12y2RZPIU/bTSclyCdFmRKg22rRcY0iEBlEaaMP2o6YZK8fDpBAuP1u5ugZ+cybmPHfkzc44NA5/Aslo605W/+ADDOlpN+3erwC1z7qMugNWk2Lc4LMi66XPTuACwv6rKYDQ5MeIXhkOhW7SySeHiiEEqoTIK0FZJsqCDsTgjfpawTly7CBoeoxMt9ei2AqgOqyIfXwuwa2jIDGBIMc/6eGLwm9owaPYb9p18DX8SEJnJ4dY1lznsBqAHABDGCIK2FHUXXJLRh3//OgEvi9wyVdFkS44Zo8ezihduSZhpqXgMp+G3bExJuertgw7cO8pJWD0yPMauzD+v02hXSYZlsvk2fCN1xc5Tz8RHpJUa7bJW4yHuke8NBWSMZzZLDMN34ZWK4ws1hRTo/RSEUYmjbGEVsDELDRMINL1svWyFUNutBE/IXqSeJ88nTjEC+Q3JFEvunpJuvRirJaAGW2u/0NMwV63XiMZ1s3oYwtcy0WhrWuvwfq9nk/+RKcg9SfQ5AMKOcu68v3qWopSrm2fQ/8dNPDJdYU2bl65N0O5S/DwpuEfQugzdZjjcus1c7EQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199015)(64756008)(66556008)(66946007)(76116006)(66446008)(8676002)(66476007)(316002)(6916009)(54906003)(38070700005)(36756003)(6486002)(83380400001)(5660300002)(2906002)(8936002)(478600001)(41300700001)(4744005)(71200400001)(6506007)(1076003)(2616005)(6512007)(26005)(186003)(38100700002)(4326008)(122000001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UEUvOFBOUWdUejFOUXMzL1dmc3d3YnpKMjEwcVFNYjhvd2ZlRmQwNi9vMkJq?=
 =?utf-8?B?UllCbU43NzNhcXJQMGxycHJlYVlYQS8xN3AwNW5lNmpyUFYzS1JlMDlKQ2Zv?=
 =?utf-8?B?RkUvOUlCZ3hacHNqYlRmUWU3aWVaeVpTZHdkV3ZqNmMzcmlwUHR3ZnhRMHhM?=
 =?utf-8?B?VTNMWWhUakdSYldqeTd2VWRub3E2T0JsWFIyRkd4T2IrRjgwMG1MeTY3R0NG?=
 =?utf-8?B?UDNvU2Z3L1JlbWtFN1RndG1DOHN3bERwZGFQZ0x0U1J2QjBKUG9tSFVEdDZi?=
 =?utf-8?B?TVB1WmIzZk8zMHVxZkFGSDlIMzR3MVNYc1dieTN1b0hTY0g0aU45V3hVdHds?=
 =?utf-8?B?SFptZTBnVGRrejNrNFBkUXlVT3cxeWNSMTMzZytzVU94YW95bm42R0dBZ0ds?=
 =?utf-8?B?MlI2c3lwRFM0SkNEZVJKMTFvRkhkWGliNDlFSUxJbVhRYjM0QUFaTzlMS2ZJ?=
 =?utf-8?B?amlqUDhON2xJWWZFRTdTNzg0dW80SFlmblZHaGxETWxwTm16OStBV3VySXZ0?=
 =?utf-8?B?eHlGQWsxUHdqQ0drQU45TXIrSHZYYXF1Tk1QYVJMbHJ3L3RZZTdVOUlPbWRi?=
 =?utf-8?B?T2dNMElHMnVMVzA0MHVFS2c4eHYzYlIwaTFQRWtTcythZDAwSzlXc2pkV2Y4?=
 =?utf-8?B?TjRtQVdrL09CMmlyaDE1VnpPZXN3UTk0Smp5TDBhODkxY2lGUExSNGRnR2FB?=
 =?utf-8?B?djRYS1l3cS9iZ1VSYUZPUzZhb2xGZUJ1a20rVVlLb1VJOUFWcDF3Yzl4SUJN?=
 =?utf-8?B?NFlaYUhFNWx0OUtHbkdBU05IUlZhMGVuK2F4YUtKOEJVR3l0dERBaW1KRUdB?=
 =?utf-8?B?OEJidWxjbGFIOExpR3BJT1BQVUxNQ1dEbTBlbHgyaExKN1VSemRFUkJyODE0?=
 =?utf-8?B?V09TV1BCaFk5bThkdTNBbmdWS1IzeG5rYllBZmU5ZXVTQlg1dTVjQUR1WHYx?=
 =?utf-8?B?V0NyYk85b2dkOGlydFovQlhhTkpSQTFKZCtZT1lRK2l0VktOV2wzZ3hoWHFj?=
 =?utf-8?B?bnYyOGY1SVBQTVNEVXppNGhHRlQ1ajdIeUFIY2UvWDhPczROWGl0RmRHZVUv?=
 =?utf-8?B?SVJSdnYrYnlOKzlFTnJjdUFRWjJyVzVFc2Fia1pnMklDaUNFd0o0eXZjWDU2?=
 =?utf-8?B?bllNLzFsUXRLWm84VXd6WTlsaEZDV21RUUlhSjh4SHBiSXg2QmRWb2tRN3VI?=
 =?utf-8?B?aVJjM0U3aHhmZHNuVzFIWldUV0RpazdpKzQyNnhHdlFaL3VNMkhxaDE3dnlw?=
 =?utf-8?B?Q2k4Zkt0S2JnamtUTWE3T3AxNnRMbGt5ZWVOQlBDd1dxdHJsejAxZmJBTmZW?=
 =?utf-8?B?S0FNczdldVpvR3dnRXM1WTAzc0t4WjVhMlZIMjBlTzFwWjc3MlplVFJ2b1Az?=
 =?utf-8?B?Y29hUWtHYllENnVYeHVDYVJYTy9wdFNlMzBvcmsvdEttdXMvZExaYjl4N3Nq?=
 =?utf-8?B?S3RFL3l0cTk4dlRRdGFYRHdpVWx3VnVxVEpQNVNKSmF5N3hveFcxZ0dvMG1x?=
 =?utf-8?B?bkpsakJDZU1OUnNTd0ZORm52eXRxeGdueW5SR25LVm5vcldSTk9jbHE3MGha?=
 =?utf-8?B?RjhmMGVmVkcvWFB6KzAydnNMd05hdDhYWEJuaGpIQXBiWWFvL2s3RzJibXhL?=
 =?utf-8?B?QTB4bVFHT1hzbWg4ZHAzTkJnNFlFMVhtT3M5YXk3UXU5RzVXY1lZUmxGekVy?=
 =?utf-8?B?djloV2tHRHNraXN5Sm1jc3RNRHJqVHBNa05wV01YWE1JZjJmWnNEcldmaXpI?=
 =?utf-8?B?K1RTMmtrTnhsZ1orUDc0YndTZ0ZlTmg4aTlOUWwyR1FpSjJhUVhFY2JXUGFw?=
 =?utf-8?B?N3Y4a2V0d1RaaDViUjc5RUNIMTEwbkZSMWprNGdKNlNvblF4TVB2NkwyMGhC?=
 =?utf-8?B?ODJTUHR0SGY1bVd5M0czT3cvQVl2VTgyZXVhYXMwSHQzVUx6QlJaSFNWTy92?=
 =?utf-8?B?WmpwbGV6K1RxTThRK2NhelFPYTFvSVJPV1VkaGZHQVJsTzhSOW4yQi9keisv?=
 =?utf-8?B?R0RnS3hsaUxTS0p0S2FNeHA4d082RDFTaG1wV2w3ZTl0VWFhR2Z5NVZMYWha?=
 =?utf-8?B?ZEh4NEgwUktZTXJzTmVyaUlzT3pqTU0za3dENENYeXIyeW5BZlJoSmZ6ZUV5?=
 =?utf-8?Q?mg9+ItW6uXqWWqHU2Voau1LnO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <442E6225539FA34E935D60E7C9D23C02@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba1c2196-a93c-4b37-a022-08daa58a47e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 21:57:35.5997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fnf6pTjEe5L5IZpoEDGJZkJJSOu2maLCAaYdUPaRh3K8mhKZxInpQ1TfU/FEcT9QkLB9SvY/8cNya6BevZk8EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5829
X-Proofpoint-GUID: j5Hkatm4GnjFz5sO3JGoSxDvzymaHZco
X-Proofpoint-ORIG-GUID: j5Hkatm4GnjFz5sO3JGoSxDvzymaHZco
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 impostorscore=0 bulkscore=0 clxscore=1011 mlxscore=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=474 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210030130
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgQW5keSwNCg0KT24gVHVlLCBTZXAgMjcsIDIwMjIsIEFuZHkgU2hldmNoZW5rbyB3cm90ZToN
Cj4gVGhpcyByZXZlcnRzIGNvbW1pdCAwZjAxMDE3MTkxMzg0ZTM5NjJmYTMxNTIwYTlmZDk4NDZj
M2QzNTJmLg0KPiANCj4gQXMgcG9pbnRlZCBvdXQgYnkgRmVycnkgdGhpcyBicmVha3MgRHVhbCBS
b2xlIHN1cHBvcnQgb24NCj4gSW50ZWwgTWVycmlmaWVsZCBwbGF0Zm9ybXMuDQoNCkNhbiB5b3Ug
cHJvdmlkZSBtb3JlIGluZm8gdGhhbiB0aGlzIChhbnkgZGVidWcgaW5mby9kZXNjcmlwdGlvbik/
IEl0DQp3aWxsIGJlIGRpZmZpY3VsdCB0byBjb21lIGJhY2sgdG8gZml4IHdpdGgganVzdCB0aGlz
IHRvIGdvIG9uLiBUaGUNCnJldmVydGVkIHBhdGNoIHdhcyBuZWVkZWQgdG8gZml4IGEgZGlmZmVy
ZW50IGlzc3VlLg0KDQpUaGFua3MsDQpUaGluaA0KDQo+IA0KPiBGaXhlczogMGYwMTAxNzE5MTM4
ICgidXNiOiBkd2MzOiBEb24ndCBzd2l0Y2ggT1RHIC0+IHBlcmlwaGVyYWwgaWYgZXh0Y29uIGlz
IHByZXNlbnQiKQ0KPiBSZXBvcnRlZC1ieTogRmVycnkgVG90aCA8Zm50b3RoQGdtYWlsLmNvbT4N
Cj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU2lnbmVkLW9mZi1ieTogQW5keSBTaGV2
Y2hlbmtvIDxhbmRyaXkuc2hldmNoZW5rb0BsaW51eC5pbnRlbC5jb20+DQo+IFRlc3RlZC1ieTog
RmVycnkgVG90aCA8Zm50b3RoQGdtYWlsLmNvbT4gIyBmb3IgTWVycmlmaWVsZA0KPiAtLS0NCj4g
IGRyaXZlcnMvdXNiL2R3YzMvY29yZS5jIHwgNTUgKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0NCj4gIGRyaXZlcnMvdXNiL2R3YzMvZHJkLmMgIHwgNTAgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA1MSBpbnNl
cnRpb25zKCspLCA1NCBkZWxldGlvbnMoLSkNCg==
