Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E11547A8A8
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 12:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhLTL2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 06:28:11 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:58617 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhLTL2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 06:28:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639999692; x=1671535692;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=64OtZyjH2l7XAvSzONI7xXWFB8dZgNc6ZlQ7p0FbD0Y=;
  b=NLeUMXouYkDL3oVAun4lsJ/Ewth7nLA5f2CGl8U8UJWOLbUJ4QgpeuCJ
   25iQ1MCDJJH3CyPHAPEZ3Mgx7qwLZp41B1iVghDrhLNQDXUB3NiZeHEV4
   /D+oQNxmqhT5iU93Dk4ngccbiFssdK5QdsMrXLGbCVAukezY32Zp4Wcu+
   C6Ro5EDJkzGPMcgEBY4D9rLZ9VuaZM/7q/AbMZl3M1QloY7c/+4tvnAGl
   wpmF+etWdHcUe3c2NZutfJqfuY/xu31lB/pLBpzDpz1TiBAL1WvARo7BX
   5zppHO1pV2EdVU4l+rvvviWwQGB+UHYHmCY7gbp0y+Qz95ptku+mOeYnW
   g==;
IronPort-SDR: Y/Pk0valm5NkAN+xGJqLo94397GS2QwlTRDldMe+Te0ObGHwRf3/lpEbD1xCznuASKcIjeXs6B
 Xo/wz1Gy5uwbMl9JZkQVlzlQqTv8nxrycOK+6AWUrJNLpU2YSZZTvAOaHedj3Hh6aOeNYgfzf4
 odAIiVJIxy5As0boq0YEljEH66N2bP5l7ooql1FGlEw0kUyfag19ccASF+M3PSqud893Azgii9
 b2jxxOUpB6R7jX539B+8mPwBcEPda68QEHyd8nThW1HoykiY+cY9b7fpmEu7Z8LzzKOYwM6cjD
 vjriI2JljauLF7k2zeA2QBdV
X-IronPort-AV: E=Sophos;i="5.88,220,1635231600"; 
   d="scan'208";a="147229152"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Dec 2021 04:28:10 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 20 Dec 2021 04:28:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Mon, 20 Dec 2021 04:28:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrlUzhh9de3fGeBwSn4lNGOYtrtDd4D0UEbqWG5jsuHQ7fKLa7aEiqz0ZxQ7Qplo170zJJ6IEDLAJXlFZU2EilD24Pj4t6rlSdBngLS97dJw117IlhJlImkZqWBKvApAuhWoHspBNe/nqgo86fsJVdSdF/YTA8efI/UVdk8nUPgikzvHppVZ5cH0dFFD5B7x0e/xwian1NXOl9Rxoc8C58Mxbrm4KfUeuCZfMl49cJ9SaKIEE5hazL2TBBekHIBUVszUNsLVtL/JyDvCva5TFR6CthggutOjHDDaLRei8JLx3nSwgBvqxXVRKyuZHyOOSQxnfM3UgeXaWJk/1zJcMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=64OtZyjH2l7XAvSzONI7xXWFB8dZgNc6ZlQ7p0FbD0Y=;
 b=N2DRgXorhzlF2eUoBPsP4v1VBdg3vUX6iN1Q8Ba2r8fesKOSq1waHVQK26EBH/K52tYXdgz9UQdeQTW2o31CB7Om+G2drNc8K5eq/uCCFvlww2BRoOSF7PawCOPMEgIv1OG7hyWOkduYt/+CAx2UL/87F5o4k+GZOndJnstE6RVpe6G8vH1xQpWzeLNaY+MFfAEo5/ftHhJKMub2hXyrvlBE0IVBW1LNlUj46utyy82ANpUWxzQBiDlP0AMvShAN5hxwNaIKT8qpleUDcbuKzztP4SLvpVWf7R+Dgd3a8e4ElQAGHbJEBQDTlV4Rb9HdZqZUHzsWdD6WGLVBzWav9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64OtZyjH2l7XAvSzONI7xXWFB8dZgNc6ZlQ7p0FbD0Y=;
 b=cfkUqcWIZs2mInGql07FN5rcLWa0ZR1qn2Vt9k3UyIU7JShq+08qatxQAzDsdxMbLmKvSNvXw9wYwcTYtHsZ3ahf+WuwoU5QeEIliXKHZT47oa9nFpATTBMYiMIM35VctMlfUvhpsYfrUwtxDDQR2qqXSkStnKN7VTdaKXrluYg=
Received: from SA2PR11MB4874.namprd11.prod.outlook.com (2603:10b6:806:f9::23)
 by SN6PR11MB3248.namprd11.prod.outlook.com (2603:10b6:805:c4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Mon, 20 Dec
 2021 11:28:01 +0000
Received: from SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::5c96:23c3:4407:d3b1]) by SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::5c96:23c3:4407:d3b1%9]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 11:28:01 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <alexander.sverdlin@nokia.com>, <linux-mtd@lists.infradead.org>
CC:     <p.yadav@ti.com>, <michael@walle.cc>, <miquel.raynal@bootlin.com>,
        <richard@nod.at>, <vigneshr@ti.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mtd: spi-nor: Check for zero erase size in
 spi_nor_find_best_erase_type()
Thread-Topic: [PATCH v2] mtd: spi-nor: Check for zero erase size in
 spi_nor_find_best_erase_type()
Thread-Index: AQHX867zGrsgvJvvRkumR0zAW0g6cQ==
Date:   Mon, 20 Dec 2021 11:28:01 +0000
Message-ID: <88db4d69-e983-a359-ad50-9981e465b1fa@microchip.com>
References: <20211119081412.29732-1-alexander.sverdlin@nokia.com>
 <0cabce03-bc22-eb3d-fa77-a1f5f787784d@microchip.com>
 <08d6657c-afa9-8739-196b-1e66d802e614@nokia.com>
In-Reply-To: <08d6657c-afa9-8739-196b-1e66d802e614@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3be2f7f-a8ab-4647-e772-08d9c3abc830
x-ms-traffictypediagnostic: SN6PR11MB3248:EE_
x-microsoft-antispam-prvs: <SN6PR11MB32484226B9B728E7834BDA6AF07B9@SN6PR11MB3248.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 59zW2gj8oyRrtNGlzLFtCNd6rtLYNLVNs0K9PungJb6SZjez+2FnCsI2bUuRYn5DDcqPKTX09vT6xYKYs9YTcgQ/AQs+bugdSsmhOwvAwHyYeRTqXFzcV2nUZpJ5/m8US8+hNJLuV5ibmstKMdTNUD2OnLxRZ01rj6CaeaZa+5QpHYB0pzvEUQDfNPHGo+ZrRJz8Ixmg+JZ92TbRB/mjtdmALp9EaLbCG2DO/eZeFpIVFRT7rzw/MhmQxroC7/Re3e3neWAdR1ZJ6X7eTama2DO32y0tZ3f2GRdkT22f5AfnljELdMEnn+7eE5DCj3q3kWERZy7OzCC/szyUHIYSpxiJspddtt6KnlqD5FPYqlGXS7jP1phxo4TvARoTpMU4aIcrVJmIJX0vYVjvBIFfB/x3Ji/L4QHVC6XvK8Oglz0U0mLn5+1d2uqYr5HHwvq44alPldzH88G1yzWsPzsOz4oR1sJtoGJ/5mM9mSRuhIFyjsAUVr7glwLGdJrkxkv/qUhRsc+Kq8QmpKvSWmnT/5I5qga8jTTxwZk/Zb5BknbsbWKP/SYkAS4Xjv+E5Av0y8Fq/gj2t0GNWJw3EQb9zsMmIcBAb9quW0034hY504eMM/k9W8PZh+Ux7b9/jgTrfDp7YDfmdhTukuOt9Pvr0bvifrekeqny+KeBYiaLLCSSbKC0/5cv664/mYNXkvwuKK7SlzkA0IqKdHon9j8JsG4dPhSU928a+N+GtkPg2AdY55VneWYYFR7eTVVAqtz9G1YEZTsKsYVS3vWsjcRH9xFktmiftQX4PCz0uDOW5cIOIOXxSjsONMFz5aXwvXbp9ihaP/rd69qKT6v+o4UGO3ZTYUGZsi7Gwduz+KDMXJDCqtMJs3dFJRBkVLqOmDCtz8pqjXtQj2TaoEWKpsrRqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4874.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(86362001)(2616005)(38070700005)(38100700002)(508600001)(122000001)(31686004)(36756003)(966005)(2906002)(186003)(83380400001)(6506007)(53546011)(71200400001)(66446008)(31696002)(6486002)(66556008)(66476007)(64756008)(6512007)(26005)(66946007)(76116006)(91956017)(8936002)(54906003)(110136005)(8676002)(4326008)(296002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmgrV3hvZFczVkxRdTJ0c0J5c2Znc0dGMGRFUzhIVWRSamRCU2ZUTlZRbnZo?=
 =?utf-8?B?Z1VOSXgrUmN0RHBMQ1dTNzNWNUFSdHhrMmN1eG1BOFBLaXJnd1pLUnFHNnV1?=
 =?utf-8?B?d01CbWx1UmtJQzFuVkN2NVAvaGV4ODZDQkh2Y3IvWlpIS2xNM1BEdk02QzBm?=
 =?utf-8?B?OUx2U1dNZUFJdG80ZFlMc3cyVzVBRzVRMlRLeVRac1FOMGtjaDFkQ25LSkFk?=
 =?utf-8?B?MmZOODJOdnppUzhJVnRuV1ZHMzY2dFlMenA0KzdWMzZNVE9nOWZ0b2xIeWc1?=
 =?utf-8?B?emI1dENkODBOK3JCRml1MUUyY25FMDE0L2J5VEVoNS9ZL3FIcGxCZ1lNc1Uv?=
 =?utf-8?B?ZkFsWGZiSjQrOXZvb3FzVEw3SFNIQk95RGVFWWR4QUtadUdVVWpsNUNqK2xl?=
 =?utf-8?B?U0pNK1g4dmJGcEJJaS82NzlObDlxajhZSnlvMnJ3MTFFaXFqcUlwRlZpYi9q?=
 =?utf-8?B?a050M0J4RnBRanJWc2k0Q0VJTTZqUW1CeUxQdWRJKzV2UzBUUExtbDJtNHRh?=
 =?utf-8?B?NTM0dXRINkI2SWYyUTNQRmFGMzNRVGt1T2dtMHlxc0ZrMGNlYTdzcGJaVUVk?=
 =?utf-8?B?NWJ3ODBtTGRRbDl5eHJTUXhNUE9ySkZxWXhscjY0TXByMzlYOVpBV1QvK2du?=
 =?utf-8?B?WlVlZ3ZKOWRQbnNVbGpvQW9iL1p6S3ZMQlk0SHN4aUFFWjJlQ29WV2NOUkRH?=
 =?utf-8?B?TjFqVzBjQmtOR3Z6SFRiUU8zeTVvMUhiN0p0QlNUWDBSMDJGdkFDenNscDFn?=
 =?utf-8?B?S3VrN0JJMjQ2dm1qOVdNZW53Ris3WlFnK1N4a0czUnUrcDN3ejVmMHM4TUNn?=
 =?utf-8?B?WHdmbmU3VisrREhaRFMzQnRvSEhWbmdZQ09Hcko0aHowd2RWZUt6UUExV29k?=
 =?utf-8?B?MjNuQ0Rwd054MVpraUxmL3BmRTg3RFdGZ29mM1dMMnZsOVZyWTVnR3hQeXQw?=
 =?utf-8?B?MHhPekR6WjNaM2NxTWhkZWVCTXg0dkl6dncwQmVrejZ3V1dYOGRINkkycXNh?=
 =?utf-8?B?aFQ3Q1FOUWhMNE8zdmU2Qkx1bnBtU0JqbFl0UGFLbmNPWTRmdVV1WnRHMGJz?=
 =?utf-8?B?dmlmekhsZE14VmRiL2tPUDEwZTUwYTJyOFNUdlZpaDVOb21OUDZITG1XK2p4?=
 =?utf-8?B?ejFvVWIzcUtQTGw0NklJRVVLRmVwb1ZwMHpNTXRPRVpFbW42NzZiRUxDNGJJ?=
 =?utf-8?B?aXh3cTVMeUxGUlVLUklUMHJvNk9aRDJBMFEyNXQzbjhmUDFlTDNWYmEyaVhB?=
 =?utf-8?B?MWtaL1ptTlc3UFRSMnB4anR4REhteDIwQk9tSFBpUWNtUm9mWlNUUmJEWUVJ?=
 =?utf-8?B?UzBEcTdRU01oWCtqYzM0SXhXbHZneXpLWVJHcVNlcjRKN0J5L3ZjbUlVYXV6?=
 =?utf-8?B?SVI0WlBlZ2FISmpwSS9rUVZsY2dCSm15anZjSjdIYS9wSnF1bGRtTEpBSEVu?=
 =?utf-8?B?dGpzcXJiYURlU0RRU1JRZ3Q0SThEbzNuNGxlYktWQTRuYTlCbVh4aG82T01s?=
 =?utf-8?B?dXhxTndQbHpGQnBUMEVwWklSeXcxU29MaVFCYkhmc0w4SnFaVXBNTFk1bWc5?=
 =?utf-8?B?aFNOT1l0UXl3NFZLVVBmUnhlVER3NkVkaEpVeXFwVW1vYnZWcGhpRWxKbHJi?=
 =?utf-8?B?a1F0QkJGU3VEYlBaOGs5U2hBWjZ6WlZ2dFB0T3lkdzF6UFBJUUFjUFIwRHRP?=
 =?utf-8?B?dFpnZzVRNlFQSjExREJ4U1JsQ0NhVURJc1JPa1pZdkluL29HdTFEdHU1Q2Jx?=
 =?utf-8?B?aXlJY3ZOOFpscHlDZ1d4Z2YyWkJtWDcwRHMzYmF3bnVOOVBteWw3aEcvNFFm?=
 =?utf-8?B?c3BjYnMvZUt5M2JxZ29qUlprenRBd3B6SllsK1JuY3NBNXV2blgvYUlPY3E5?=
 =?utf-8?B?U0JuaWVkU3VRKzFkSUJOeUpNd2Vvb0tDOG9oakZFcnl0UkJxcVJJVHJhNGNi?=
 =?utf-8?B?OFJVVXRGQTdtbWkxTlVnRDdvK0kyT0hGS1RrSnBpV0hYM1FkWW1JcHBMSURY?=
 =?utf-8?B?OFV4TU8zZGRmQ056enZrS08xOEw5SldpdG9FK09jRmdMbDhXWFd0WVRBNkwx?=
 =?utf-8?B?TEtiTVhIclJNZ1NsaDNEREhpUjZWQlphd3BYdVdnTGNEcGJWNEdSQ21vMkZj?=
 =?utf-8?B?QUxjb1hnV01ZdlZMdURBR3c5MWpaUE9WRFYwdUFnUE9jZW55UzNONjBTM1gz?=
 =?utf-8?B?bDFDZ29ONERNV2Jid1luVHBLZlNnT1NVcEhaM0U4amkzY20zTXRCQlRZYmJG?=
 =?utf-8?B?MWduUC80Y2lwbGNYNzVkbXFWa2FRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B257F56D80DBD641B514057339AED7D9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4874.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3be2f7f-a8ab-4647-e772-08d9c3abc830
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2021 11:28:01.4012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VSbBpQ1YipkNRkr24gwnCDaxUPZzk4tstzhHU3GSyWvggGQY66YVHSBhpD+Dr92z9Ea6ZlH/4NhuqWFyrW52AaZzA8qq9tauf5YYBsrYhMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3248
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTIvMjAvMjEgMTE6NDYgQU0sIEFsZXhhbmRlciBTdmVyZGxpbiB3cm90ZToNCj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBIZWxsbyBUdWRvciwNCg0KSGkhDQoN
Cj4gDQo+IE9uIDE4LzEyLzIwMjEgMDI6MzEsIFR1ZG9yLkFtYmFydXNAbWljcm9jaGlwLmNvbSB3
cm90ZToNCj4+PiBFcmFzZSBjYW4gYmUgemVyb2VkIGluIHNwaV9ub3JfcGFyc2VfNGJhaXQoKSBv
cg0KPj4+IHNwaV9ub3JfaW5pdF9ub25fdW5pZm9ybV9lcmFzZV9tYXAoKS4gSW4gcHJhY3RpY2Ug
aXQgaGFwcGVuZWQgd2l0aA0KPj4+IG10MjVxdTI1NmEsIHdoaWNoIHN1cHBvcnRzIDRLLCAzMkss
IDY0SyBlcmFzZXMgd2l0aCAzYiBhZGRyZXNzIGNvbW1hbmRzLA0KPj4+IGJ1dCBvbmx5IDRLIGFu
ZCA2NEsgZXJhc2Ugd2l0aCA0YiBhZGRyZXNzIGNvbW1hbmRzLg0KPj4NCj4+IDpEDQo+Pg0KPj4+
DQo+Pj4gRml4ZXM6IGRjOTI4NDMxNTlhNyAoIm10ZDogc3BpLW5vcjogZml4IGVyYXNlX3R5cGUg
YXJyYXkgdG8gaW5kaWNhdGUgY3VycmVudCBtYXAgY29uZiIpDQo+Pj4gQ2M6IHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmcNCj4+PiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kZXIgU3ZlcmRsaW4gPGFsZXhh
bmRlci5zdmVyZGxpbkBub2tpYS5jb20+DQo+Pj4gLS0tDQo+Pj4gQ2hhbmdlcyBpbiB2MjoNCj4+
PiBlcmFzZS0+b3Bjb2RlIC0+IGVyYXNlLT5zaXplDQo+Pj4NCj4+PiAgZHJpdmVycy9tdGQvc3Bp
LW5vci9jb3JlLmMgfCAyICsrDQo+Pj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykN
Cj4+Pg0KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL210ZC9zcGktbm9yL2NvcmUuYyBiL2RyaXZl
cnMvbXRkL3NwaS1ub3IvY29yZS5jDQo+Pj4gaW5kZXggODhkZDA5MC4uMTgzZWE5ZCAxMDA2NDQN
Cj4+PiAtLS0gYS9kcml2ZXJzL210ZC9zcGktbm9yL2NvcmUuYw0KPj4+ICsrKyBiL2RyaXZlcnMv
bXRkL3NwaS1ub3IvY29yZS5jDQo+Pj4gQEAgLTE0MDAsNiArMTQwMCw4IEBAIHNwaV9ub3JfZmlu
ZF9iZXN0X2VyYXNlX3R5cGUoY29uc3Qgc3RydWN0IHNwaV9ub3JfZXJhc2VfbWFwICptYXAsDQo+
Pj4gICAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7DQo+Pj4NCj4+PiAgICAgICAgICAg
ICAgICAgZXJhc2UgPSAmbWFwLT5lcmFzZV90eXBlW2ldOw0KPj4+ICsgICAgICAgICAgICAgICBp
ZiAoIWVyYXNlLT5zaXplKQ0KPj4+ICsgICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0K
Pj4NCj4+IEkgbmVlZCBhIGJpdCBvZiBjb250ZXh0IGhlcmUuIERvZXMgbXQyNXF1MjU2YSBoYXMg
YSB1bmlmb3JtIGVyYXNlIGxheW91dD8NCj4gDQo+IFlvdSBjYXVnaHQgbWUsIHRoZSBidWcgd2ls
bCBub3QgYmUgdmlzaWJsZSB3aXRoIHRoaXMgZmxhc2ggdHlwZSB3aXRob3V0IHRoZSBwYXRjaA0K
PiB3aGljaCBoYXMgYmVlbiBpZ25vcmVkIGZvciBsb25nIHRpbWU6DQo+IGh0dHBzOi8vd3d3LnNw
aW5pY3MubmV0L2xpc3RzL2xpbnV4LW10ZC9tc2cxMTUxMC5odG1sDQoNClNvcnJ5IGFib3V0IHRo
aXMsIEkgZG9uJ3Qgc2VlIGl0IGluIHBhdGNod29yaywgaXQgcHJvYmFibHkgaGFzIGl0cyBzdGF0
dXMgY2hhbmdlZC4NCmh0dHBzOi8vcGF0Y2h3b3JrLm96bGFicy5vcmcvcHJvamVjdC9saW51eC1t
dGQvbGlzdC8/c2VyaWVzPSZzdWJtaXR0ZXI9JnN0YXRlPSZxPXNwaS1ub3ImYXJjaGl2ZT0mZGVs
ZWdhdGU9DQoNCk5leHQgdGltZSB3aGVuIHlvdSBmZWVsIGEgcGF0Y2ggaXMgbm90IGRlc2Vydmlu
ZyB0aGUgYXR0ZW50aW9uIGl0IG5lZWRzLA0KZmVlbCBmcmVlIHRvIHJlc2VuZCBpdCB3aXRoICJS
RVNFTkQgUEFUQ0giIGluIHRoZSBjb21taXQncyBzdWJqZWN0Lg0KDQpXaWxsIHlvdSByZXNlbmQg
aXQ/IERvIHRoZSB1cHBlciBsYXllcnMgY29tcGxhaW4gaWYgeW91IHVzZSB0aGUgYmVzdCBlcmFz
ZSBzZXF1ZW5jZT8NCkhhdmUgeW91IHRyaWVkIHViaWZzIG9uIHRvcCBvZiB5b3VyIGlnbm9yZWQg
cGF0Y2g/DQoNCj4gDQo+IEkgaG93ZXZlciBydW4gdGhlIGFib3ZlIHBhdGNoIGJlY2F1c2Ugb2Yg
dGhlIHJlYXNvbnMgZGVzY3JpYmVkIGluIHRoZSBjb21taXQgbWVzc2FnZS4NCj4gTmV2ZXJ0aGVs
ZXNzLCB0aGUgYnVnIGZpeGVkIG5vdyByZW1haW5zIGEgYnVnIG5vIG1hdHRlciB3aGF0IHRyaWdn
ZXJzIGl0Lg0KDQpJJ20gbm90IHlldCBjb252aW5jZWQgdGhhdCB0aGlzIGlzIHRoZSBiZXN0IHdh
eSB0byBmaXggaXQuIFNob3VsZCB3ZSB1cGRhdGUNCnRoZSBlcmFzZSBtYXNrIHRvIGNvdmVyIHRo
aXMgY2FzZT8NCg0KQ2hlZXJzLA0KdGENCj4gDQo+PiBpLmUuIERvZXMgeW91ciBmbGFzaCBoYXMg
c2VjdG9ycyBvZiBtb3JlIHRoYW4gb25lIHNpemUgb3IgZG9lcyBub3QgYWxsb3cNCj4+IHRoZSA0
SyBhbmQgNjRLIGVyYXNlIHR5cGVzIHRvIGJlIGFwcGxpZWQgb24gYWxsIHNlY3RvcnMgaW4gdGhl
IDRCIGNhc2U/DQo+PiBJZiBubywgeW91IHNob3VsZCBoYXZlIGJlZW4gaW4gdGhlIHNwaV9ub3Jf
aGFzX3VuaWZvcm1fZXJhc2UoKSBjYXNlLCBhbmQNCj4+IGlmIHRoaXMgY2FzZSBkb2VzIG5vdCBz
dWl0IHlvdSwgbWF5YmUgd2Ugc2hvdWxkIHVwZGF0ZSB0aGUgY29kZSBmb3IgdGhpcw0KPj4gc3Bl
Y2lmaWMgY2FzZSBpbnN0ZWFkLg0KPj4NCj4+IE9uIGEgc2hvcnQgbG9vayBJIHNlZSB0aGF0IHRo
aXMgZmxhc2ggZGVmaW5lcyBqdXN0IEJGUFQgYW5kIDRCQUlUIHRhYmxlLA0KPj4gc28gbm8gU01Q
VC4gSXQgbG9va3MgbGlrZSB5b3UncmUgZm9yY2luZyB0aGUgZmxhc2ggdG8gYmVoYXZlIGFzIGl0
IGhhZCBkZWZpbmVkDQo+PiBTTVBULiBBbSBJIHdyb25nPw0KPj4NCj4+IEFsc28sIHNob3VsZCB3
ZSB1cGRhdGUgdGhlIHJlZ2lvbidzIGVyYXNlIG1hc2sgaW5zdGVhZCBhbmQgbWFzayBvdXQgdGhl
DQo+PiB1bnN1cHBvcnRlZCBlcmFzZSB0eXBlPyBJIHdvdWxkIGxvdmUgdG8gaGVhciBtb3JlIGFi
b3V0IHlvdXIgdXNlIGNhc2UuDQo+IA0KPiAtLQ0KPiBCZXN0IHJlZ2FyZHMsDQo+IEFsZXhhbmRl
ciBTdmVyZGxpbi4NCj4gDQoNCg==
