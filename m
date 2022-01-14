Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3431048E6B7
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiANIkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:40:35 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:19418 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiANIke (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:40:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1642149633; x=1673685633;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gE8w0KJvgENVrosTeWOv0hZmcigSEYLvqTl9AWqwEUo=;
  b=UGESzZLvNO5obim2W490lPZo3tfb2xCi95FrWAzG8d7gE/Aaw8gfpnLg
   vTXoiNaz8CgSlveKxq2vdmwQF0wXko6OXslyta/kTJ2jsawehGrninNS3
   2bij7K44pS4LEyMvW4AA193c48nfr8wz2xGWrHI54m9zHUvhHTTzDYVmR
   ukoEP+Dy51iMUtIOIGzLzuSG9+bM8gALPXwWH/Jvo7Vt9X2e0TUAZt+Hk
   VBjKoMwduk9VyBIgg/vE1X8FK276+pKDcUYJmvAhxQWcL9blS6BinwoWZ
   Ui7FZi1h6oYdC+8acBNbO8aVpTWm79Uh1Ngpjk2AX0DxnIc2LIB4GFnPK
   A==;
IronPort-SDR: VajrTD0xpRRBLY8VQpvhY/oQ9SG1rfqtj+UeUIglLaAVCJQXDHU9mz5e2jCk03YXBa6Jto70Ka
 ZQKjSRUrBgHwjBlNKE2d+lSda5WJdn0sCp994oPUdz9bWxuugjuiHqkG4Ds1yHVPYt186W0KO2
 id25hIMEwkFOeAspitU3tFCE1DASLFdd3brhijHhpuOPogDk1USBdUWC1nMIzcy5CiyeU20syT
 WqiXggQN+GhhjkquN3zCfQm+2CAS/FzXbEGW461NzatvpVJ1MrEDEE6bocmVY2md+h+MZGfv2H
 5HM5Kdy072bcj4heGt9OJUvZ
X-IronPort-AV: E=Sophos;i="5.88,288,1635231600"; 
   d="scan'208";a="82492815"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jan 2022 01:40:31 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 14 Jan 2022 01:40:30 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 14 Jan 2022 01:40:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fz2MJnmk74BC124t1CtZnwGqFxNsEcke4qgteL12l88WipvqjK82F8N9G3H6fB1guXe25v7d12+v37gxVgoI1e70UcYy+iX8h7ns//1yDtjbF+MyD5QJkWcJEa+3iI2Ke5sdjUR8gHdpxK0nXhR17gwGjHVafMux+oL1WucZyIWRd9Mm5HAaQOYO5rgxKJlZNBOQ427Mqe4xcsMfmXpBuZfzmAJlcWdjIKHGWlYjVheD2r+2qrJu7+uD+nJg7/i345kP/wC3NKR6dQ37TeBo6HszKI09tI8BGWzpc1yBAgxtMeIAZim1AyjubmB3bQuB7z6P1418JKWL54U2OX8lSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gE8w0KJvgENVrosTeWOv0hZmcigSEYLvqTl9AWqwEUo=;
 b=Rs4RZkLXOOXH5OpzfykSkqSZZdZS3gYUW6aY7lwqJCVvOD1iL+27mO2JGp4M6luDlHmYh/iWvamQJ3EG/FDv/8ygsATc34fCr3XIEWfv/crcqEgNoTdOfR7cemXbXvugPZ8cet/GRrJJaGCsJremQjHHIY4nprGQaBp5WgZoDTGiayT+ydquYk2U8KGZkDqZOW4RqZMLaBK8naQ8wwrkFdUXPkNTNx+yggG5tJ8kK1GHL95weoParAmCEy96NWzKhVfZfJPH5nVcLRzo2q5jjrkrbB50kggv+0tluGKjVtlvAEEhy+czo2wZ1S11WQ/gzZOhAn2Vb+m/6Sn/h7MsSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gE8w0KJvgENVrosTeWOv0hZmcigSEYLvqTl9AWqwEUo=;
 b=IWFOZrHrkmFSa6KXNKfybuCz9zPF/IkJE4MwWx5Ziftka54HhEyV8/vsBhjMCAAg0RrZp9X4igBQpwt6ehad58kkLDlJXBJknsAt2ZcPUBse5G0ib+Ndhr9Pwd66aBwq5NNp7Q+q7G3I0o+aO/iXmfSnnt7GxwEBP9QzzHQl5ec=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:95::7)
 by SJ0PR11MB4942.namprd11.prod.outlook.com (2603:10b6:a03:2ac::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Fri, 14 Jan
 2022 08:40:25 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::6032:bbb2:b522:2ac3]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::6032:bbb2:b522:2ac3%9]) with mapi id 15.20.4888.012; Fri, 14 Jan 2022
 08:40:25 +0000
From:   <Conor.Dooley@microchip.com>
To:     <geert@linux-m68k.org>, <palmer@rivosinc.com>
CC:     <linux-riscv@lists.infradead.org>, <paul.walmsley@sifive.com>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>,
        <anup.patel@wdc.com>, <heinrich.schuchardt@canonical.com>,
        <atish.patra@wdc.com>, <bin.meng@windriver.com>,
        <sagar.kadam@sifive.com>, <damien.lemoal@wdc.com>,
        <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 02/12] RISC-V: MAXPHYSMEM_2GB doesn't depend on
 CMODEL_MEDLOW
Thread-Topic: [PATCH 02/12] RISC-V: MAXPHYSMEM_2GB doesn't depend on
 CMODEL_MEDLOW
Thread-Index: AQHX3WTUaxIDE/O6EkiX+niT9lHT9KxeTu2AgAQ7wIA=
Date:   Fri, 14 Jan 2022 08:40:25 +0000
Message-ID: <232b8a0d-b25d-b942-eeec-9a67b66b81ce@microchip.com>
References: <20211119164413.29052-1-palmer@rivosinc.com>
 <20211119164413.29052-3-palmer@rivosinc.com>
 <CAMuHMdXQg942-DwDBJANsFiOCqyAwCt_GwW4HuC1nh0_DNmyEQ@mail.gmail.com>
In-Reply-To: <CAMuHMdXQg942-DwDBJANsFiOCqyAwCt_GwW4HuC1nh0_DNmyEQ@mail.gmail.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe658835-8d22-4f5b-59ae-08d9d7398276
x-ms-traffictypediagnostic: SJ0PR11MB4942:EE_
x-microsoft-antispam-prvs: <SJ0PR11MB494259B68F37E799CEF04BE698549@SJ0PR11MB4942.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f+H6beeGlJzI7WmLg0sL8PRU0NFOOjYsRWSdhOgT+R+GhfQ/2u9SfNWShYWnfS2VOxFoy9IET7Y5TzFUko/BJQX2YC68y+TILtOpnMljOOuqaCkLrSUSAez9zDn2wd2n3xd1SQX0/gFzx7jKdBSluVbsgvXnO2vcr8pkkLD2fPumGGi3PDqbxSlFN7h+EtK30pfckCrEfW7cCaA0cbxceY0VTyc2SMIdnMQcC3dKn9KUMj/YYvUsw5K+HGzSrzV1j3wpq426R97ELjv37krhzrTEeHwE0O+okVzqf7y0g0pjtTrwnmJ54FF/+ZV1FfS9nqFNhrKOBCuLNJ1nIPcvDlQk+m+44sUqJH51dJ0Jsm67MLlzvZrHkcFMRhXH9k7hpbZFOXnTVn5I4LnThFUj4ab5qQYtl2h2IvJXb4An32Bm/tRB17dRVALQ0JkaxDLxipTCW34/k1FFTDflDWMRQp4kp70Ej1ZVNbs9LtcEFDvuFVkHmpDT/sY3fRZD9GX4kBRXcL/4qv3v6FmX0z7vi9r0RUCyLd+8NhJ5bMCuxDnewfBt0VAdWbPfCHJBTKhMOiupNKNUdIM7lNNr5w49jcmOm3lP2rg5EvkZrrMqoT2OfqxLSzkA2txkOydkKMlAfpjyl34tbfac24jmvgWkseTBbqh0CqSggNdWKpbYe+qrcLHjGRrnqwXP53NlfJiHnsCWVoSCSvDVuKZKI0OeLEJAJBkQMG/0x50Mjudbl+97YLxijusfPFjybEqumqyP6jUuTHT20heLJVLow4BK9dwmX+CN+dDJLLXWKPkWNZuPa4gFoB3/RKsRCC6/sF6lQbAlBbaE8hCuDhIc22cJMXLmbOFf0tftQJdaNRI0jVc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(186003)(26005)(45080400002)(91956017)(2906002)(7416002)(966005)(38100700002)(5660300002)(508600001)(8936002)(54906003)(110136005)(316002)(8676002)(71200400001)(66476007)(4326008)(53546011)(83380400001)(6506007)(122000001)(6486002)(2616005)(86362001)(36756003)(31686004)(6512007)(66556008)(66446008)(66946007)(76116006)(64756008)(38070700005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REF3eEQxRHJKb3FhUWloWXFCUWNNaEtWY29JaDRiR0VNZzFoSkhaVC9UQ203?=
 =?utf-8?B?RlllUHFKYTJyaCtvNWhqSUl2UmphQmV2SjlRK0NtYVdlNk5IVWI1alVSZWJW?=
 =?utf-8?B?RVJzcUhpbXBJdUFOZEk2Rk9tWHJhQjFPL2RpV21reXJRdDJhYXFDYnM0Lyta?=
 =?utf-8?B?RXcrOXF4ZWtCWEFZOWxxdWg5UEI3MWQwNzZDcmhZaFN0MzhtdzRlbHNmbGFk?=
 =?utf-8?B?VzdJMUZmVjZDWFhKazd5cHdkQU8vNlV1dWZWNU5ocDFzbVpBZmgwNnBaOXRo?=
 =?utf-8?B?TkYxbFc4ZDRuTkZjN29iby92bmpZY3NPOU02VEFRQ1d3SFdWQnhQZ21SQlRl?=
 =?utf-8?B?cXh2dnY1bGxxK2dma2VTYWVEQmZ6eEVPSUxXemYzVHBaQWdqcURRcE5ONG9V?=
 =?utf-8?B?dTlqMnV6eGorbVcvY0I1QmoyQngvcEU4VlhGai81SGh6SlAvQUc2RTNLMGh1?=
 =?utf-8?B?aHduazFxVCtVMXBZSHNpVTUrc0NZbUJYM1NEK2FpUnhtS2d2c2IwUkpzV1c2?=
 =?utf-8?B?M0dBcGRzOHlKaDB2NStPTGNIdEpKcUNxZWJLRk5XTHhyZHhSMDJmQlV1TlZn?=
 =?utf-8?B?V3ZWQ3kwejJCU0lPZDM0L1VRVkVSd1U0N29kdG95NWVoWi81Rkd2Z3BPZlRi?=
 =?utf-8?B?K1Z5T01sd1dPaDRVUG12WVFiVC92eDUrMGVNeGZXOHI0V1JxTXg2YkJHelVv?=
 =?utf-8?B?Qlk3SkJYNjRVWlZINlRMZ25kRi9JL1R1MnorT2djUkd1NWJpSEtwdzY0TjB2?=
 =?utf-8?B?V3BxT05kdEp5dSs0NFFtVEEvU3NuUEd4ak0wTUdZandGVHNRWDgxdFRDeG5E?=
 =?utf-8?B?MHB0T05rYldIcFE3bjltazJsMjk3Ym1jQTc3YkRhdVRoa0o0UEdLU3VtMjJz?=
 =?utf-8?B?aTBDMWlabWRyWnA3UzFlNG1LYmI2Ti9ERXV6cy85dk9XZWhsbXJwVVM0MEQz?=
 =?utf-8?B?OFd6Q281ay8wT2lNd2tNeUs3b1k0WmcreGZIMmNlL3hHa29hWUl2bGUyTHZo?=
 =?utf-8?B?VjVEdHB6aHJkb0ROTkRabEdsb1pZSVFJb3hCUmRkQklORjA1L3RuK1hVQnlh?=
 =?utf-8?B?QkQ2azdCUExuSnNCWWtCVWpwZFlMVGMzUDhpWDE5M2NaUHlzRVY5ZzF0WS9q?=
 =?utf-8?B?UlQzMUFnMGpZMFh5ZXg5cTZmVkllZFRHc3J0aXJPR3JnNE1DbXQwOFlDcHc4?=
 =?utf-8?B?V3ZhbWw5ckN2MUJUZlk4dlBVeXQ5UHM2UXIxaSttM0s3OXE5OXdRcUFZNVRq?=
 =?utf-8?B?eE1CRnF2SUp3aEJHQUFkVFJYajY0czZueHdROE5Gbmd4Y0VtT3lGOUdBRUl2?=
 =?utf-8?B?Vlo1bG9adTlIeUs1b2VwZnM4bi82M2MzNzg1cnAvY3VScFZEWHJsbVV5K3Vo?=
 =?utf-8?B?Q0ZLWHg2bHU5VU1tTkkzNjdZdTZtUzhtNDZoWTJ5Q3M4cndDdGQxcytiRHBy?=
 =?utf-8?B?dW8weEowMk5tRTJRUldQVWtzTnNDajYzeU1kRHpycjZMclVqOTdyVmJGQ0ND?=
 =?utf-8?B?Z0wyU3hWbmdtWTdpd1c0Q1ZUOVM5MUYwa3JSUmVaTTQyV2lHeFo1SDZnWXlS?=
 =?utf-8?B?UkxnWjFUM2gwNnV0MXhMM3pZZ0xIZWxaWVNmU2Ntb0QvSXdHbHp4RkRkc0cz?=
 =?utf-8?B?MWlSRnVrZkVXWDdNZVlWZ3JzM0ZUV0FVU01kZGhRUG96d2FSbGNxSjVsSy9R?=
 =?utf-8?B?Z3dIL2pvR1dudEdibHJ4bzhNSWxIME5sa3pzKzNxV3p4WTZZamJkd2xNWExV?=
 =?utf-8?B?b1B0V1NHcXJpWkh6ZElsN3J2OU0vb1N1QTdWc0dWU1NMWFEvVkVDYlVpS041?=
 =?utf-8?B?REpvcG5lbW1FK0dOQjRDd1ZIK1U0WlJEajY3MXhRMjNhRDBjcGNMS0tTMzI5?=
 =?utf-8?B?VWI0VFlWUGN5TVB6S3lRemEzektqcUpxeTJDT2NZaGsxWnQxTHlMRFBZU3Yr?=
 =?utf-8?B?RzJ1eVFTaHdFc284QzFlVzFwRjRxaklYb0M4aE5CMzVOREVoRHF5QU83VS95?=
 =?utf-8?B?MFRJOEZGSUtEQ0VneVlQWGkzRWo3Q1Zjc2lvRTU4bHdNZ2t1YyszOEFXaFlx?=
 =?utf-8?B?dWxaemU2RitqWkY2MDZEWjA3RkhsRzMxL1lwN1VNQVJxUHdDaXdOb0QwWGNY?=
 =?utf-8?B?d0hxVGNOdXdoWUNPSDFqSFlsbkk3Z1FmVWtaMHZiN1FVRk1wRnZZLytGRUZh?=
 =?utf-8?B?a1BrVmswZlFRbGV3alcxaGtocnJzMlI5cW9UUXU4OGlocVRnWkRmS2Njc3NG?=
 =?utf-8?B?T3NQNEpzMHd5K3VzVTcyWTY5NVdBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C52D52C7B18B41429098E5D9EECF0A65@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe658835-8d22-4f5b-59ae-08d9d7398276
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2022 08:40:25.0443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xNH8+fgwviGS7JBNnNhUj+4vAYRo8TDygEZhKt7i7dDFUNo97XaoU/jBHdCL1JTTp8SDmGvE8UFYEAanq4eoDy5v3FWoQXyvGkapGN9VOkc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4942
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTEvMDEvMjAyMiAxNjowNCwgR2VlcnQgVXl0dGVyaG9ldmVuIHdyb3RlOg0KPiBFWFRFUk5B
TCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IEhpIFBhbG1lciwNCj4gDQo+IE9uIEZy
aSwgTm92IDE5LCAyMDIxIGF0IDU6NDcgUE0gUGFsbWVyIERhYmJlbHQgPHBhbG1lckByaXZvc2lu
Yy5jb20+IHdyb3RlOg0KPj4gRnJvbTogUGFsbWVyIERhYmJlbHQgPHBhbG1lckByaXZvc2luYy5j
b20+DQo+Pg0KPj4gRm9yIG5vbi1yZWxvY2F0YWJsZSBrZXJuZWxzIHdlIG5lZWQgdG8gYmUgYWJs
ZSB0byBsaW5rIHRoZSBrZXJuZWwgYXQNCj4+IGFwcHJveGltYXRlbHkgUEFHRV9PRkZTRVQsIHRo
dXMgcmVxdWlyaW5nIG1lZGFueSAoYXMgbWVkbG93IHJlcXVpcmVzIHRoZQ0KPj4gY29kZSB0byBi
ZSBsaW5rZWQgd2l0aGluIDJHaUIgb2YgMCkuICBUaGUgaW52ZXJzZSBkb2Vzbid0IGFwcGx5LCB0
aG91Z2g6DQo+PiBzaW5jZSBtZWRhbnkgY29kZSBjYW4gYmUgbGlua2VkIGFueXdoZXJlIGl0J3Mg
ZmluZSB0byBsaW5rIGl0IGNsb3NlIHRvDQo+PiAwLCBzbyB3ZSBjYW4gc3VwcG9ydCB0aGUgc21h
bGxlciBtZW1vcnkgY29uZmlnLg0KPj4NCj4+IEZpeGVzOiBkZTVmNGI4ZjYzNGIgKCJSSVNDLVY6
IERlZmluZSBNQVhQSFlTTUVNXzFHQiBvbmx5IGZvciBSVjMyIikNCj4+IENjOiBzdGFibGVAdmdl
ci5rZXJuZWwub3JnDQo+PiBTaWduZWQtb2ZmLWJ5OiBQYWxtZXIgRGFiYmVsdCA8cGFsbWVyQHJp
dm9zaW5jLmNvbT4NCj4gDQo+IFRoYW5rcyBmb3IgeW91ciBwYXRjaCwgd2hpY2ggaXMgbm93IGNv
bW1pdCA5ZjM2Yjk2YmM3MGY5NzA3ICgiUklTQy1WOg0KPiBNQVhQSFlTTUVNXzJHQiBkb2Vzbid0
IGRlcGVuZCBvbiBDTU9ERUxfTUVETE9XIikuDQo+IA0KPj4gSSBmb3VuZCB0aGlzIHdoZW4gZ29p
bmcgdGhyb3VnaCB0aGUgc2F2ZWRlZmNvbmZpZyBkaWZmcyBmb3IgdGhlIEsyMTANCj4+IGRlZmNv
bmZpZ3MuICBJJ20gbm90IGVudGlyZWx5IHN1cmUgdGhleSdyZSBkb2luZyB0aGUgcmlnaHQgdGhp
bmcgaGVyZQ0KPj4gKHRoZXkgc2hvdWxkIHByb2JhYmx5IGJlIHNldHRpbmcgQ01PREVMX0xPVyB0
byB0YWtlIGFkdmFudGFnZSBvZiB0aGUNCj4+IGJldHRlciBjb2RlIGdlbmVyYXRpb24pLCBidXQg
SSBkb24ndCBoYXZlIGFueSB3YXkgdG8gdGVzdCB0aG9zZQ0KPj4gcGxhdGZvcm1zIHNvIEkgZG9u
J3Qgd2FudCB0byBjaGFuZ2UgdG9vIG11Y2guDQo+IA0KPiBJIGNhbiBjb25maXJtIE1BWFBIWVNN
RU1fMkdCIHdvcmtzIG9uIEsyMTAgd2l0aCBDTU9ERUxfTUVEQU5ZLg0KPiANCj4gQXMgdGhlIElj
aWNsZSBoYXMgMTc2MCBNaUIgb2YgUkFNLCBJIGdhdmUgaXQgYSB0cnkgd2l0aCBNQVhQSFlTTUVN
XzJHQg0KPiAoYW5kIENNT0RFTF9NRURBTlkpLCB0b28uICBVbmZvcnR1bmF0ZWx5IGl0IGNyYXNo
ZXMgdmVyeSBlYXJseQ0KPiAobmVlZHMgZWFybHljb24gdG8gc2VlKToNCkdpdmVuIHlvdSBzYWlk
IDE3NjAgTWlCIEkgYXNzdW1lIHlvdSdyZSBub3QgcnVubmluZyB0aGUgZGV2aWNlIHRyZWUgDQpj
dXJyZW50bHkgaW4gdGhlIGtlcm5lbD8NCkJ1dCB0aGUgZGVmY29uZmlnIGlzIC9hcmNoL3Jpc2N2
L2NvbmZpZ3MvZGVmY29uZmlnPw0KDQpJIHRlc3RlZCBpdCB3LyBteSBuZXdlciB2ZXJzaW9uIG9m
IHRoZSBkdHMsIHVzaW5nIGJvdGggMTc2MCAmIDczNiBNaUIgDQooZGRyY19jYWNoZV9sbyBvbmx5
KSB3LyBNQVhQSFlTTUVNXzJHQi4NCkVuYWJsaW5nIE1BWFBIWVNNRU1fMkdCIHdpdGggZWl0aGVy
IENNT0RFTF9NRURBTlkgb3IgQ01PREVMX01FRExPVw0KbGVhZCB0byB0aGUgc2FtZSBib290IGZh
aWx1cmUgYXMgeW91IGdvdC4NCj4gDQo+ICAgICAgT0Y6IGZkdDogSWdub3JpbmcgbWVtb3J5IHJh
bmdlIDB4ODAwMDAwMDAgLSAweDgwMjAwMDAwDQo+ICAgICAgTWFjaGluZSBtb2RlbDogTWljcm9j
aGlwIFBvbGFyRmlyZS1Tb0MgSWNpY2xlIEtpdA0KPiAgICAgIHByaW50azogZGVidWc6IGlnbm9y
aW5nIGxvZ2xldmVsIHNldHRpbmcuDQo+ICAgICAgZWFybHljb246IG5zMTY1NTBhMCBhdCBNTUlP
MzIgMHgwMDAwMDAwMDIwMTAwMDAwIChvcHRpb25zICcxMTUyMDBuOCcpDQo+ICAgICAgcHJpbnRr
OiBib290Y29uc29sZSBbbnMxNjU1MGEwXSBlbmFibGVkDQo+ICAgICAgcHJpbnRrOiBkZWJ1Zzog
c2tpcCBib290IGNvbnNvbGUgZGUtcmVnaXN0cmF0aW9uLg0KPiAgICAgIGVmaTogVUVGSSBub3Qg
Zm91bmQuDQo+ICAgICAgVW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQg
dmlydHVhbCBhZGRyZXNzIGZmZmZmZmZmODdlMDAwMDENCj4gICAgICBPb3BzIFsjMV0NCj4gICAg
ICBNb2R1bGVzIGxpbmtlZCBpbjoNCj4gICAgICBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIg
Tm90IHRhaW50ZWQgNS4xNi4wLTA4NzcxLWc4NTUxNTIzMzQ3N2QgIzU2DQo+ICAgICAgSGFyZHdh
cmUgbmFtZTogTWljcm9jaGlwIFBvbGFyRmlyZS1Tb0MgSWNpY2xlIEtpdCAoRFQpDQo+ICAgICAg
ZXBjIDogZmR0X2NoZWNrX2hlYWRlcisweDE0LzB4MjA4DQo+ICAgICAgIHJhIDogZWFybHlfaW5p
dF9kdF92ZXJpZnkrMHgxNi8weDk0DQo+ICAgICAgZXBjIDogZmZmZmZmZmY4MDJkZGFjYyByYSA6
IGZmZmZmZmZmODA4MjQxNWEgc3AgOiBmZmZmZmZmZjgxMjAzZWUwDQo+ICAgICAgIGdwIDogZmZm
ZmZmZmY4MTJlYzNhOCB0cCA6IGZmZmZmZmZmODEyMGNkODAgdDAgOiAwMDAwMDAwMDAwMDAwMDA1
DQo+ICAgICAgIHQxIDogMDAwMDAwMTA0MDAwMDAwMCB0MiA6IGZmZmZmZmZmODAwMDAwMDAgczAg
OiBmZmZmZmZmZjgxMjAzZjAwDQo+ICAgICAgIHMxIDogZmZmZmZmZmY4N2UwMDAwMCBhMCA6IGZm
ZmZmZmZmODdlMDAwMDAgYTEgOiAwMDAwMDAwNDBmZmZmY2U3DQo+ICAgICAgIGEyIDogMDAwMDAw
MDAwMDAwMDBlNyBhMyA6IGZmZmZmZmZmODA4MDM5NGMgYTQgOiAwMDAwMDAwMDAwMDAwMDAwDQo+
ICAgICAgIGE1IDogMDAwMDAwMDAwMDAwMDAwMCBhNiA6IDAwMDAwMDAwMDAwMDAwMDAgYTcgOiAw
MDAwMDAwMDAwMDAwMDAwDQo+ICAgICAgIHMyIDogZmZmZmZmZmY4MTIwM2Y5OCBzMyA6IDgwMDAw
MDBhMDAwMDY4MDAgczQgOiBmZmZmZmZmZmZmZmZmZmYzDQo+ICAgICAgIHM1IDogMDAwMDAwMDAw
MDAwMDAwMCBzNiA6IDAwMDAwMDAwMDAwMDAwMDEgczcgOiAwMDAwMDAwMDAwMDAwMDAwDQo+ICAg
ICAgIHM4IDogMDAwMDAwMDAyMDIzNmMyMCBzOSA6IDAwMDAwMDAwMDAwMDAwMDAgczEwOiAwMDAw
MDAwMDAwMDAwMDAwDQo+ICAgICAgIHMxMTogMDAwMDAwMDAwMDAwMDAwMCB0MyA6IDAwMDAwMDAw
MDAwMDAwMTggdDQgOiAwMGZmMDAwMDAwMDAwMDAwDQo+ICAgICAgIHQ1IDogMDAwMDAwMDAwMDAw
MDAwMCB0NiA6IDAwMDAwMDAwMDAwMDAwMTANCj4gICAgICBzdGF0dXM6IDAwMDAwMDAyMDAwMDAx
MDAgYmFkYWRkcjogZmZmZmZmZmY4N2UwMDAwMSBjYXVzZTogMDAwMDAwMDAwMDAwMDAwZA0KPiAg
ICAgIFs8ZmZmZmZmZmY4MDJkZGFjYz5dIGZkdF9jaGVja19oZWFkZXIrMHgxNC8weDIwOA0KPiAg
ICAgIFs8ZmZmZmZmZmY4MDgyNDE1YT5dIGVhcmx5X2luaXRfZHRfdmVyaWZ5KzB4MTYvMHg5NA0K
PiAgICAgIFs8ZmZmZmZmZmY4MDgwMmRlZT5dIHNldHVwX2FyY2grMHhlYy8weDRlYw0KPiAgICAg
IFs8ZmZmZmZmZmY4MDgwMDcwMD5dIHN0YXJ0X2tlcm5lbCsweDg4LzB4NmQ2DQo+ICAgICAgcmFu
ZG9tOiBnZXRfcmFuZG9tX2J5dGVzIGNhbGxlZCBmcm9tDQo+IHByaW50X29vcHNfZW5kX21hcmtl
cisweDIyLzB4NDQgd2l0aCBjcm5nX2luaXQ9MA0KPiAgICAgIC0tLVsgZW5kIHRyYWNlIDkwM2Rm
MWEwYWRlMGI4NzYgXS0tLQ0KPiAgICAgIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBBdHRl
bXB0ZWQgdG8ga2lsbCB0aGUgaWRsZSB0YXNrIQ0KPiAgICAgIC0tLVsgZW5kIEtlcm5lbCBwYW5p
YyAtIG5vdCBzeW5jaW5nOiBBdHRlbXB0ZWQgdG8ga2lsbCB0aGUgaWRsZSB0YXNrISBdLS0tDQo+
IA0KPiBTbyB0aGUgRkRUIGlzIGF0IDB4ZmZmZmZmZmY4N2UwMDAwMCwgaS5lLiBhdCAweDdlMDAw
MDAgZnJvbSB0aGUgc3RhcnQNCj4gb2YgdmlydHVhbCBtZW1vcnkgKENPTkZJR19QQUdFX09GRlNF
VD0weGZmZmZmZmZmODAwMDAwMDApLCBhbmQgdGh1cw0KPiB3aXRoaW4gdGhlIDIgR2lCIHJhbmdl
Lg0KPiANCj4+IC0tLSBhL2FyY2gvcmlzY3YvS2NvbmZpZw0KPj4gKysrIGIvYXJjaC9yaXNjdi9L
Y29uZmlnDQo+PiBAQCAtMjgwLDcgKzI4MCw3IEBAIGNob2ljZQ0KPj4gICAgICAgICAgICAgICAg
ICBkZXBlbmRzIG9uIDMyQklUDQo+PiAgICAgICAgICAgICAgICAgIGJvb2wgIjFHaUIiDQo+PiAg
ICAgICAgICBjb25maWcgTUFYUEhZU01FTV8yR0INCj4+IC0gICAgICAgICAgICAgICBkZXBlbmRz
IG9uIDY0QklUICYmIENNT0RFTF9NRURMT1cNCj4+ICsgICAgICAgICAgICAgICBkZXBlbmRzIG9u
IDY0QklUDQo+PiAgICAgICAgICAgICAgICAgIGJvb2wgIjJHaUIiDQo+PiAgICAgICAgICBjb25m
aWcgTUFYUEhZU01FTV8xMjhHQg0KPj4gICAgICAgICAgICAgICAgICBkZXBlbmRzIG9uIDY0QklU
ICYmIENNT0RFTF9NRURBTlkNCj4gDQo+IEdye29ldGplLGVldGluZ31zLA0KPiANCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgIEdlZXJ0DQo+IA0KPiAtLQ0KPiBHZWVydCBVeXR0ZXJob2V2ZW4g
LS0gVGhlcmUncyBsb3RzIG9mIExpbnV4IGJleW9uZCBpYTMyIC0tIGdlZXJ0QGxpbnV4LW02OGsu
b3JnDQo+IA0KPiBJbiBwZXJzb25hbCBjb252ZXJzYXRpb25zIHdpdGggdGVjaG5pY2FsIHBlb3Bs
ZSwgSSBjYWxsIG15c2VsZiBhIGhhY2tlci4gQnV0DQo+IHdoZW4gSSdtIHRhbGtpbmcgdG8gam91
cm5hbGlzdHMgSSBqdXN0IHNheSAicHJvZ3JhbW1lciIgb3Igc29tZXRoaW5nIGxpa2UgdGhhdC4N
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLS0gTGludXMgVG9ydmFsZHMNCj4g
DQo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQo+IGxp
bnV4LXJpc2N2IG1haWxpbmcgbGlzdA0KPiBsaW51eC1yaXNjdkBsaXN0cy5pbmZyYWRlYWQub3Jn
DQo+IGh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtcmlz
Y3YNCj4gDQoNCg==
