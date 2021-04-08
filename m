Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E513584F6
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 15:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbhDHNlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 09:41:12 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:45596 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231812AbhDHNlI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Apr 2021 09:41:08 -0400
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 539FDC09C2;
        Thu,  8 Apr 2021 13:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1617889257; bh=y8Bg5l24P7f2paFntq4Afzor81cLBflYd2zvY86/ZxQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=W0sN4Fys04H5Cp6ErVPX9QZXaL9rx3gzJwq6t4fJ1Mpwz73TGCnvTjo3mGRexRxr2
         FrOJdo4V04ypiiQ4MKZBTTz9Qer5RyOYRM9VYaJM9NHNbwQmiQI0CIA6Mx9fKDt2Pi
         tX6NSO+9Rgt+R31my7n4LmYKB7wkYUOBnohXIBlT6Ui4h/fIGr1s4H6aMaYpC6Z3oB
         VLMOsxMaYI0U2bwST3mOKg9kPj8G5gSQQH5wFMYouxRCWNMFMbiH6iU1vkbwn+/xgh
         W4dnNjA8u2CmVm3e8DmYzH5bx/8bJnhV/Q3DEJJBm7pvQe1GmIHyBV/0XKTI8uQlM6
         m0SWkvPH4Ftmg==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 9BF44A007C;
        Thu,  8 Apr 2021 13:40:55 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 2CE2380129;
        Thu,  8 Apr 2021 13:40:54 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=hminas@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="JLyD49Hr";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfNEWYxv69+vo8n8vb6m5UmjM2qVNXIlZvxggHEq/mg8B5BwcwRJqlxabTdUNCOR6EtyUsdh/yUgotdCu/ZN2AeVid8i9JfPUO0o5ES9uwmmyLR2ajMIEWbErJkBRPbyoN/ti+0u/ZkEtjaIxy2GC4Ml4ccDyyr8nh0mBZGUkjWEcwFTWuYBcfIviqljOIywJVJhVwhMG6DLZ0Uxz9r7G5IxfrrypFI7uNxe+nQmGfx3Hyjnd8vuEPIjv3k+dD5kr/1DlV3jEZrxK+UDP7Tglu/VxSe/K96VcuCS28TjEcT7Y6S3HAeXhukmWNilAe3EtMuLwhhchatRbJfnAbdd8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8Bg5l24P7f2paFntq4Afzor81cLBflYd2zvY86/ZxQ=;
 b=Ka4FK/bfaUTcFqUIZ4+eHkEwUNZDt25DMyIb16NszcOCVhPfO/UWVaGFRBVpW7+YWcA/idYlulkpwVTxsl6XxyoSItQeVR93DxJ4ZL9zbA+gokg9SmjTlKVIhrHQ6fVvqKPcRnXH/9FgHlwKDvGuAXup5HrJRNITKsjB4dlOIT9ivv4B6qHlXoKUcipCiBbVKG6vfJBtOetqK+e63SnSOHe9Q+hnkVzn0FhwdUl10mzmloA6BEjJbIPHr0yMPKCE6yhIc214SZcWS7Jrm3XodCSyOhxXmPB49nu0HxgDCdQfMXgIJtWP8LyTqD1/xxO8xYqxIPvcJxSdbjRwK9SJLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8Bg5l24P7f2paFntq4Afzor81cLBflYd2zvY86/ZxQ=;
 b=JLyD49HrF/LGBID+Gk9Re6jtR6ih11Ban5WD1hfgoaxPrHj91y0+RoAfmIqGck4UOVTAmBMN+cQ20UE+SUaF0UX0mfx1Sb73nu28HoYEe4RVelfPiAn5RIm1dvWDunVR7/we5KcVg+vbRhBYuk17TiPcK/ntzQZ2NODnxs22Ii4=
Received: from BYAPR12MB3462.namprd12.prod.outlook.com (2603:10b6:a03:ad::16)
 by BYAPR12MB4630.namprd12.prod.outlook.com (2603:10b6:a03:107::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26; Thu, 8 Apr
 2021 13:40:52 +0000
Received: from BYAPR12MB3462.namprd12.prod.outlook.com
 ([fe80::a025:1ced:b6f2:6c1]) by BYAPR12MB3462.namprd12.prod.outlook.com
 ([fe80::a025:1ced:b6f2:6c1%4]) with mapi id 15.20.4020.018; Thu, 8 Apr 2021
 13:40:52 +0000
X-SNPS-Relay: synopsys.com
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
To:     Artur Petrosyan <Arthur.Petrosyan@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>
CC:     John Youn <John.Youn@synopsys.com>,
        Paul Zimmerman <paulz@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH v3 13/14] usb: dwc2: Fix partial power down exiting by
 system resume
Thread-Topic: [PATCH v3 13/14] usb: dwc2: Fix partial power down exiting by
 system resume
Thread-Index: AQHXLFwCmyr7Ck8rqUq5wlDQjFaBTKqqoNyA
Date:   Thu, 8 Apr 2021 13:40:52 +0000
Message-ID: <93c724db-3f71-09c1-1c8f-cb931b793740@synopsys.com>
References: <cover.1617782102.git.Arthur.Petrosyan@synopsys.com>
 <20210408094607.1A9BAA0094@mailhost.synopsys.com>
In-Reply-To: <20210408094607.1A9BAA0094@mailhost.synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
authentication-results: synopsys.com; dkim=none (message not signed)
 header.d=none;synopsys.com; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [37.252.80.199]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 889e053b-e810-407c-c86a-08d8fa93ed76
x-ms-traffictypediagnostic: BYAPR12MB4630:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB4630A65E643EE7C30BDC8BDFA7749@BYAPR12MB4630.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lnlK0/X6/X7NF4Nb/Ia6pZQg0FYLJQnVjtEazEZx379k6lBINWAs4yhWEeE3wcDfGajvCszdMxusNzidQwSUvKj7ycfyMcJl2y+HZJq2T+kASJDd+E2xNN7q1uwoa5VqqhqHlrkBMDoWx52tIFoOUUIoK2wU0YtjpdPiWkCx0ZKJCHtwyGKt9Vs6qQj81mbbdW67wQzMCjdOEeDMh+4pAnmgbwGRd39UcFrC9b2Wc1a/zMC/VVaWRjjrMBdKAA0jKICp7P6LDATau3S93qq0mSz+hIE/0U1Lo0b01pWpIeCGqfIMGCYX8zf4zuyFdniKvcrJZ3O4IdGpiUfPEZCRafztzc7EM4h+D0kpkZpMsv8ekLj1EPfjGOABhXCqOWVjPlpl2qbpkeSHdIj4I+zB2bip+wo4jXadnbLWAQ0CZ8vdkMCSoWqCyQQ2GQAsrvVQFPZlDY2X6FrBrowypMYI/jGpXHqlYbCbOfXQ2veYx23/RyyQiNQQBYnXio31YecwrJ6LE6HwRvI4MX1h35e95ZZpFGsvj5dQpXlIiRP7x8sIHrvYuRchBhAf3kY4yMtcs/R5sfyOBCnD8PWhNaMgwP7LFWj6orp3meBFoE39BB7eeSy8ktftzQ44k3mDa1thnGZcYlCyjDeVSiwqIqF2YOMiGcxynYt47ZEG3RmwzmAz+VMcQ+EWNn363lMVu1GQBEpzIIY7WhDFv6SakGipGKrkIJKlZiIgpMr1WI82n0U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3462.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(396003)(346002)(376002)(6486002)(38100700001)(2616005)(26005)(186003)(91956017)(76116006)(316002)(2906002)(110136005)(71200400001)(54906003)(36756003)(4326008)(64756008)(66556008)(86362001)(66946007)(66446008)(6506007)(53546011)(478600001)(66476007)(6512007)(31696002)(31686004)(83380400001)(5660300002)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WVN1VXpsbSt0Z3ByMTVxbUtuckM2bUt4YW1ick1lb203SmlVYzNZZDlydVAz?=
 =?utf-8?B?NGJTUWxGNXZxeEtaUlRNUDJzc283UnpmNUtEYmZ4dys1QWtyK0xzdjFTZTZk?=
 =?utf-8?B?am5yZVJYVDVqVzNIM0lEK0Y3QVJNcjRYTU9Uamx6bWR0cTdJR0lrYjZuZWNJ?=
 =?utf-8?B?LzFPMkFTZGR6V2JZejFnL1lrMUx0ZzZwL3ZzMm5CYlo1NmlLUk4zUlNIN2lo?=
 =?utf-8?B?eURVbE1JS2htempIbldpSlFUR0JmSHBzYldLNk0vZEJDUUUyMVoyMFdpQ0ht?=
 =?utf-8?B?WEtZY3NiMXh1NmRuMTQ4SmdqeTJxd0V4RlozRk1vMkZFRXNiOVJ3cGY5U01F?=
 =?utf-8?B?S0NOeW9tQS81bEwrY2ZQcnlNWlE5WWJSdDRmb0VEOS9Gam9qRFJYajM3OVhj?=
 =?utf-8?B?emtGdUg4VVQzVlI4R3V5b0wramcwVERIVndzUUhHK1B6Z3hOZXBuaXNncUNw?=
 =?utf-8?B?SDk4dlNkK0xQd242WXF5R3N3VXgySTI1NkRUeno2enFkSUd4dU1YZzlGTHdm?=
 =?utf-8?B?OHV4NXU2QVRHY3pOcm5BMWZpK1paVUtmTTBDYndnYlk2dXYzcHpOYUpkeWpW?=
 =?utf-8?B?bzJNd0pXaTFmK2lEeXI5ODBOWWhlQk54bXhySzVpdUljeDhJRGRSVEJNN3Iv?=
 =?utf-8?B?VTlMUWJCQ2h6TE9SYkVVUDZia0JHTXg3U2MycUpXTjBQV2x2MWdlcUVnb2Iw?=
 =?utf-8?B?bGIvSUZHR1AxUFlrdm5rMkUrSm9hcVdURXM2eE4xV0R3N1phWnMxcnE1ek1H?=
 =?utf-8?B?dnRDdFNqN0ZCZ3NzdndrZnJWOG0yNVdBNjlGb3k5dWdaaEJUU3JBNGxHQmk1?=
 =?utf-8?B?V2l3cVhrRXd3Z0Z0ZmZvNE4zQmdGSlVHWDQ0dFRMQ1k2TnIzK2YvZ1JSY09z?=
 =?utf-8?B?VE5HWEhMTk5zZHN1SURDY2ZoTUFNS1E3KyszL3Z3RjN2NEhkTFJZTkliVGZE?=
 =?utf-8?B?S1RuREZtRk5UcUt5WEpEOU42QW1XVnVOZldDc2tKVFV1N0NFdTR5cFN1N1c0?=
 =?utf-8?B?NlZLZ3E0UU5XZ29rREg5bVhwN2Z6ajVJUk9jS0tFUThMNWZRUFduZ3FNL0lh?=
 =?utf-8?B?UlJwUE5xKzM3ajFxaDkycFJCcDliR0srZkNOOVgzaytTcWRzbk5ZOVArQWZR?=
 =?utf-8?B?VlJsSmhwWEJkNW5NVEZZZkZYcURHSCt0OWpvOC9iR1BxdmNRWkxNTk9ONUh5?=
 =?utf-8?B?dVV3b0JlVFBhNHd6MzUwOHE5RGRCc1lZY3lmZHg3QkxBRlRvRkNPdHQ1MDFM?=
 =?utf-8?B?SWhzUStXWnhMcERkcFdleTA5bmlqWi80cm56d1ZncFFDdWN6cUVzSmtDQWFo?=
 =?utf-8?B?NStQVDNDZ0dKSTB2cTlMVDl2bXFXbDd4RUJFK0R4cG51eGhPS2lxaEpVSEVh?=
 =?utf-8?B?U0dObWZSR2c1YWdzY0xMOWNoQ0p4YkNOR0dNVUxMeVhpVmhlMlF4OG9ESnBO?=
 =?utf-8?B?TkxGT0FHLzVGcUlHeWx2dDAzaTJFUU5kN2VoSndFbWZIRG9SRG5ra0pFdUFk?=
 =?utf-8?B?TWpQbWdIYWJETHB0VnluR0JTaWo3RTh2UWtRcmpSdVJOS3pIczFRdWFreTZx?=
 =?utf-8?B?ajI1TlE4ZkhiOGs4QlZLOHBHSjdzbDVhNjdnNzBQYUNPV2FzU2hDUDE4Ymdj?=
 =?utf-8?B?L05KY25aaUpmM2tsNjdxbmEvOWQvc25WS1hTU0xwSTFvZWZISVNXU1l4cWdK?=
 =?utf-8?B?YndjenRGWDBoWTZQTGw2bkZSQUJ0QitHQm1wZHg3MmgzU1VEcnA4NTJwbHRx?=
 =?utf-8?Q?e2okFgM9LStuIS99WE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D805179ECEC1744BF625B9446103417@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3462.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 889e053b-e810-407c-c86a-08d8fa93ed76
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 13:40:52.2287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tHapxt3JIeM4r0tWfsSrEwXc+eND3Ib/cK8oYby3/2NKZp/c+pZOWkHGEvxX9oFM5GM+VW1dz2/L10e3bSeOTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4630
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gNC84LzIwMjEgMTo0NiBQTSwgQXJ0dXIgUGV0cm9zeWFuIHdyb3RlOg0KPiBGaXhlcyB0aGUg
aW1wbGVtZW50YXRpb24gb2YgZXhpdGluZyBmcm9tIHBhcnRpYWwgcG93ZXIgZG93bg0KPiBwb3dl
ciBzYXZpbmcgbW9kZSB3aGVuIFBDIGlzIHJlc3VtZWQuDQo+IA0KPiBBZGRlZCBwb3J0IGNvbm5l
Y3Rpb24gc3RhdHVzIGNoZWNraW5nIHdoaWNoIHByZXZlbnRzIGV4aXRpbmcgZnJvbQ0KPiBQYXJ0
aWFsIFBvd2VyIERvd24gbW9kZSBmcm9tIF9kd2MyX2hjZF9yZXN1bWUoKSBpZiBub3QgaW4gUGFy
dGlhbA0KPiBQb3dlciBEb3duIG1vZGUuDQo+IA0KPiBSZWFycmFuZ2VkIHRoZSBpbXBsZW1lbnRh
dGlvbiB0byBnZXQgcmlkIG9mIG1hbnkgImlmIg0KPiBzdGF0ZW1lbnRzLg0KPiANCj4gTk9URTog
U3dpdGNoIGNhc2Ugc3RhdGVtZW50IGlzIHVzZWQgZm9yIGhpYmVybmF0aW9uIHBhcnRpYWwNCj4g
cG93ZXIgZG93biBhbmQgY2xvY2sgZ2F0aW5nIG1vZGUgZGV0ZXJtaW5hdGlvbi4gSW4gdGhpcyBw
YXRjaA0KPiBvbmx5IFBhcnRpYWwgUG93ZXIgRG93biBpcyBpbXBsZW1lbnRlZCB0aGUgSGliZXJu
YXRpb24gYW5kDQo+IGNsb2NrIGdhdGluZyBpbXBsZW1lbnRhdGlvbnMgYXJlIHBsYW5uZWQgdG8g
YmUgYWRkZWQuDQo+IA0KPiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQo+IEZpeGVzOiA2
ZjZkNzA1OTdjMTUgKCJ1c2I6IGR3YzI6IGJ1cyBzdXNwZW5kL3Jlc3VtZSBmb3IgaG9zdHMgd2l0
aCBEV0MyX1BPV0VSX0RPV05fUEFSQU1fTk9ORSIpDQo+IFNpZ25lZC1vZmYtYnk6IEFydHVyIFBl
dHJvc3lhbiA8QXJ0aHVyLlBldHJvc3lhbkBzeW5vcHN5cy5jb20+DQoNCkFja2VkLWJ5OiBNaW5h
cyBIYXJ1dHl1bnlhbiA8TWluYXMuSGFydXR5dW55YW5Ac3lub3BzeXMuY29tPg0KDQo+IC0tLQ0K
PiAgIENoYW5nZXMgaW4gdjM6DQo+ICAgLSBOb25lDQo+ICAgQ2hhbmdlcyBpbiB2MjoNCj4gICAt
IE5vbmUNCj4gDQo+ICAgZHJpdmVycy91c2IvZHdjMi9oY2QuYyB8IDkwICsrKysrKysrKysrKysr
KysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCA0NiBpbnNl
cnRpb25zKCspLCA0NCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vz
Yi9kd2MyL2hjZC5jIGIvZHJpdmVycy91c2IvZHdjMi9oY2QuYw0KPiBpbmRleCAzNDAzMGJhZmRm
ZjQuLmYwOTYwMDZkZjk2ZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91c2IvZHdjMi9oY2QuYw0K
PiArKysgYi9kcml2ZXJzL3VzYi9kd2MyL2hjZC5jDQo+IEBAIC00NDI3LDcgKzQ0MjcsNyBAQCBz
dGF0aWMgaW50IF9kd2MyX2hjZF9yZXN1bWUoc3RydWN0IHVzYl9oY2QgKmhjZCkNCj4gICB7DQo+
ICAgCXN0cnVjdCBkd2MyX2hzb3RnICpoc290ZyA9IGR3YzJfaGNkX3RvX2hzb3RnKGhjZCk7DQo+
ICAgCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+IC0JdTMyIHBjZ2N0bDsNCj4gKwl1MzIgaHBydDA7
DQo+ICAgCWludCByZXQgPSAwOw0KPiAgIA0KPiAgIAlzcGluX2xvY2tfaXJxc2F2ZSgmaHNvdGct
PmxvY2ssIGZsYWdzKTsNCj4gQEAgLTQ0MzgsMTEgKzQ0MzgsNDAgQEAgc3RhdGljIGludCBfZHdj
Ml9oY2RfcmVzdW1lKHN0cnVjdCB1c2JfaGNkICpoY2QpDQo+ICAgCWlmIChoc290Zy0+bHhfc3Rh
dGUgIT0gRFdDMl9MMikNCj4gICAJCWdvdG8gdW5sb2NrOw0KPiAgIA0KPiAtCWlmIChoc290Zy0+
cGFyYW1zLnBvd2VyX2Rvd24gPiBEV0MyX1BPV0VSX0RPV05fUEFSQU1fUEFSVElBTCkgew0KPiAr
CWhwcnQwID0gZHdjMl9yZWFkX2hwcnQwKGhzb3RnKTsNCj4gKw0KPiArCS8qDQo+ICsJICogQWRk
ZWQgcG9ydCBjb25uZWN0aW9uIHN0YXR1cyBjaGVja2luZyB3aGljaCBwcmV2ZW50cyBleGl0aW5n
IGZyb20NCj4gKwkgKiBQYXJ0aWFsIFBvd2VyIERvd24gbW9kZSBmcm9tIF9kd2MyX2hjZF9yZXN1
bWUoKSBpZiBub3QgaW4gUGFydGlhbA0KPiArCSAqIFBvd2VyIERvd24gbW9kZS4NCj4gKwkgKi8N
Cj4gKwlpZiAoaHBydDAgJiBIUFJUMF9DT05OU1RTKSB7DQo+ICsJCWhzb3RnLT5seF9zdGF0ZSA9
IERXQzJfTDA7DQo+ICsJCWdvdG8gdW5sb2NrOw0KPiArCX0NCj4gKw0KPiArCXN3aXRjaCAoaHNv
dGctPnBhcmFtcy5wb3dlcl9kb3duKSB7DQo+ICsJY2FzZSBEV0MyX1BPV0VSX0RPV05fUEFSQU1f
UEFSVElBTDoNCj4gKwkJcmV0ID0gZHdjMl9leGl0X3BhcnRpYWxfcG93ZXJfZG93bihoc290Zywg
MCwgdHJ1ZSk7DQo+ICsJCWlmIChyZXQpDQo+ICsJCQlkZXZfZXJyKGhzb3RnLT5kZXYsDQo+ICsJ
CQkJImV4aXQgcGFydGlhbF9wb3dlcl9kb3duIGZhaWxlZFxuIik7DQo+ICsJCS8qDQo+ICsJCSAq
IFNldCBIVyBhY2Nlc3NpYmxlIGJpdCBiZWZvcmUgcG93ZXJpbmcgb24gdGhlIGNvbnRyb2xsZXIN
Cj4gKwkJICogc2luY2UgYW4gaW50ZXJydXB0IG1heSByaXNlLg0KPiArCQkgKi8NCj4gKwkJc2V0
X2JpdChIQ0RfRkxBR19IV19BQ0NFU1NJQkxFLCAmaGNkLT5mbGFncyk7DQo+ICsJCWJyZWFrOw0K
PiArCWNhc2UgRFdDMl9QT1dFUl9ET1dOX1BBUkFNX0hJQkVSTkFUSU9OOg0KPiArCWNhc2UgRFdD
Ml9QT1dFUl9ET1dOX1BBUkFNX05PTkU6DQo+ICsJZGVmYXVsdDoNCj4gICAJCWhzb3RnLT5seF9z
dGF0ZSA9IERXQzJfTDA7DQo+ICAgCQlnb3RvIHVubG9jazsNCj4gICAJfQ0KPiAgIA0KPiArCS8q
IENoYW5nZSBSb290IHBvcnQgc3RhdHVzLCBhcyBwb3J0IHN0YXR1cyBjaGFuZ2Ugb2NjdXJyZWQg
YWZ0ZXIgcmVzdW1lLiovDQo+ICsJaHNvdGctPmZsYWdzLmIucG9ydF9zdXNwZW5kX2NoYW5nZSA9
IDE7DQo+ICsNCj4gICAJLyoNCj4gICAJICogRW5hYmxlIHBvd2VyIGlmIG5vdCBhbHJlYWR5IGRv
bmUuDQo+ICAgCSAqIFRoaXMgbXVzdCBub3QgYmUgc3BpbmxvY2tlZCBzaW5jZSBkdXJhdGlvbg0K
PiBAQCAtNDQ1NCw1MiArNDQ4MywyNSBAQCBzdGF0aWMgaW50IF9kd2MyX2hjZF9yZXN1bWUoc3Ry
dWN0IHVzYl9oY2QgKmhjZCkNCj4gICAJCXNwaW5fbG9ja19pcnFzYXZlKCZoc290Zy0+bG9jaywg
ZmxhZ3MpOw0KPiAgIAl9DQo+ICAgDQo+IC0JaWYgKGhzb3RnLT5wYXJhbXMucG93ZXJfZG93biA9
PSBEV0MyX1BPV0VSX0RPV05fUEFSQU1fUEFSVElBTCkgew0KPiAtCQkvKg0KPiAtCQkgKiBTZXQg
SFcgYWNjZXNzaWJsZSBiaXQgYmVmb3JlIHBvd2VyaW5nIG9uIHRoZSBjb250cm9sbGVyDQo+IC0J
CSAqIHNpbmNlIGFuIGludGVycnVwdCBtYXkgcmlzZS4NCj4gLQkJICovDQo+IC0JCXNldF9iaXQo
SENEX0ZMQUdfSFdfQUNDRVNTSUJMRSwgJmhjZC0+ZmxhZ3MpOw0KPiAtDQo+IC0NCj4gLQkJLyog
RXhpdCBwYXJ0aWFsX3Bvd2VyX2Rvd24gKi8NCj4gLQkJcmV0ID0gZHdjMl9leGl0X3BhcnRpYWxf
cG93ZXJfZG93bihoc290ZywgMCwgdHJ1ZSk7DQo+IC0JCWlmIChyZXQgJiYgKHJldCAhPSAtRU5P
VFNVUFApKQ0KPiAtCQkJZGV2X2Vycihoc290Zy0+ZGV2LCAiZXhpdCBwYXJ0aWFsX3Bvd2VyX2Rv
d24gZmFpbGVkXG4iKTsNCj4gLQl9IGVsc2Ugew0KPiAtCQlwY2djdGwgPSByZWFkbChoc290Zy0+
cmVncyArIFBDR0NUTCk7DQo+IC0JCXBjZ2N0bCAmPSB+UENHQ1RMX1NUT1BQQ0xLOw0KPiAtCQl3
cml0ZWwocGNnY3RsLCBoc290Zy0+cmVncyArIFBDR0NUTCk7DQo+IC0JfQ0KPiAtDQo+IC0JaHNv
dGctPmx4X3N0YXRlID0gRFdDMl9MMDsNCj4gLQ0KPiArCS8qIEVuYWJsZSBleHRlcm5hbCB2YnVz
IHN1cHBseSBhZnRlciByZXN1bWluZyB0aGUgcG9ydC4gKi8NCj4gICAJc3Bpbl91bmxvY2tfaXJx
cmVzdG9yZSgmaHNvdGctPmxvY2ssIGZsYWdzKTsNCj4gKwlkd2MyX3ZidXNfc3VwcGx5X2luaXQo
aHNvdGcpOw0KPiAgIA0KPiAtCWlmIChoc290Zy0+YnVzX3N1c3BlbmRlZCkgew0KPiAtCQlzcGlu
X2xvY2tfaXJxc2F2ZSgmaHNvdGctPmxvY2ssIGZsYWdzKTsNCj4gLQkJaHNvdGctPmZsYWdzLmIu
cG9ydF9zdXNwZW5kX2NoYW5nZSA9IDE7DQo+IC0JCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhz
b3RnLT5sb2NrLCBmbGFncyk7DQo+IC0JCWR3YzJfcG9ydF9yZXN1bWUoaHNvdGcpOw0KPiAtCX0g
ZWxzZSB7DQo+IC0JCWlmIChoc290Zy0+cGFyYW1zLnBvd2VyX2Rvd24gPT0gRFdDMl9QT1dFUl9E
T1dOX1BBUkFNX1BBUlRJQUwpIHsNCj4gLQkJCWR3YzJfdmJ1c19zdXBwbHlfaW5pdChoc290Zyk7
DQo+IC0NCj4gLQkJCS8qIFdhaXQgZm9yIGNvbnRyb2xsZXIgdG8gY29ycmVjdGx5IHVwZGF0ZSBE
Ky9ELSBsZXZlbCAqLw0KPiAtCQkJdXNsZWVwX3JhbmdlKDMwMDAsIDUwMDApOw0KPiAtCQl9DQo+
ICsJLyogV2FpdCBmb3IgY29udHJvbGxlciB0byBjb3JyZWN0bHkgdXBkYXRlIEQrL0QtIGxldmVs
ICovDQo+ICsJdXNsZWVwX3JhbmdlKDMwMDAsIDUwMDApOw0KPiArCXNwaW5fbG9ja19pcnFzYXZl
KCZoc290Zy0+bG9jaywgZmxhZ3MpOw0KPiAgIA0KPiAtCQkvKg0KPiAtCQkgKiBDbGVhciBQb3J0
IEVuYWJsZSBhbmQgUG9ydCBTdGF0dXMgY2hhbmdlcy4NCj4gLQkJICogRW5hYmxlIFBvcnQgUG93
ZXIuDQo+IC0JCSAqLw0KPiAtCQlkd2MyX3dyaXRlbChoc290ZywgSFBSVDBfUFdSIHwgSFBSVDBf
Q09OTkRFVCB8DQo+IC0JCQkJSFBSVDBfRU5BQ0hHLCBIUFJUMCk7DQo+IC0JCS8qIFdhaXQgZm9y
IGNvbnRyb2xsZXIgdG8gZGV0ZWN0IFBvcnQgQ29ubmVjdCAqLw0KPiAtCQl1c2xlZXBfcmFuZ2Uo
NTAwMCwgNzAwMCk7DQo+IC0JfQ0KPiArCS8qDQo+ICsJICogQ2xlYXIgUG9ydCBFbmFibGUgYW5k
IFBvcnQgU3RhdHVzIGNoYW5nZXMuDQo+ICsJICogRW5hYmxlIFBvcnQgUG93ZXIuDQo+ICsJICov
DQo+ICsJZHdjMl93cml0ZWwoaHNvdGcsIEhQUlQwX1BXUiB8IEhQUlQwX0NPTk5ERVQgfA0KPiAr
CQkJSFBSVDBfRU5BQ0hHLCBIUFJUMCk7DQo+ICAgDQo+IC0JcmV0dXJuIHJldDsNCj4gKwkvKiBX
YWl0IGZvciBjb250cm9sbGVyIHRvIGRldGVjdCBQb3J0IENvbm5lY3QgKi8NCj4gKwlzcGluX3Vu
bG9ja19pcnFyZXN0b3JlKCZoc290Zy0+bG9jaywgZmxhZ3MpOw0KPiArCXVzbGVlcF9yYW5nZSg1
MDAwLCA3MDAwKTsNCj4gKwlzcGluX2xvY2tfaXJxc2F2ZSgmaHNvdGctPmxvY2ssIGZsYWdzKTsN
Cj4gICB1bmxvY2s6DQo+ICAgCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhzb3RnLT5sb2NrLCBm
bGFncyk7DQo+ICAgDQo+IA0KDQo=
