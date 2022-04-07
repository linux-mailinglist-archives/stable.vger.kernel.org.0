Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9512F4F7E65
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 13:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238729AbiDGLwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 07:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245050AbiDGLwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 07:52:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2088FD7;
        Thu,  7 Apr 2022 04:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649332237; x=1680868237;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=G3TGUcvpJVT+lveWFVlhCaw4n8pnrm4+2O2B+9LSS0Y=;
  b=fNhO4wFJBb5j/9G0/3fAAbfJWvAmrmN2e4HnJWtvPdErgA/uxK3z60vv
   W3BYL3+XptlF9y5hD9AALnL/WQQWbQH+scH80+jXRQYYG1fEJOIabRjZ3
   WGD6ZQ889CcwGmx0FKUZpjYfmdeAXrx0/WiIVtJuYBVbZb9EwPQV8iKmS
   N/oW7D5GfwJu0d6YAO6iKxI7tfyNtjwlcxXm7tTZv4JLCdVzMmWnUxvUM
   BN4B64f9Z2SG7GaMHMdVFKDI6qH5eeuzxd309tPd6QpuCv+lrquSY26pv
   1eNMn9C7QYpEb0wcyl0JJO6um9SktiUQLY0Da+TJVgQ24O7fpv1p3fLUY
   w==;
X-IronPort-AV: E=Sophos;i="5.90,241,1643698800"; 
   d="scan'208";a="168789287"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Apr 2022 04:50:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 7 Apr 2022 04:50:37 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Thu, 7 Apr 2022 04:50:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/3VKcbKMXdVJTWNC3ETPq6DVS6ojJpVIL//7PKSoJjkl6jm38XYjELDJLYj5TbVYzF+v6AuCqFAmJJgPdHjatqa/KjiIvH8xn5pBkNhddDE4mjGLSEJAwtt1jMY91ll1y8Cxm6LY29bemHzrIUxt0Yfz/tzwA+9uzhCPX0i3jVXch0jbxfJXz1Uks82AwgI2OFopdCcihni3W3ni93get1avMXeCm2VVU0MM26yS5XCYyBsb2H8Sz2mGta2quNSUWV4RcS5S6SqjL/Gk5+3JNRQHRwHnDz8UEB0nnVvkJSUsiRdNvADMhV+NIRep+0iEGWvNJnyzx9Dd3n55HwmHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G3TGUcvpJVT+lveWFVlhCaw4n8pnrm4+2O2B+9LSS0Y=;
 b=NhxIv27/GOozaGSxo1LvAQoXPPR/NI7SQwvShAZBtt5+vLwQki7Cu1CsxzsZVUJNR0/0JEEO8tD8DnatR9lo/IJwpW3y/c8mW84tqYKmeuukRIvOJhwUAQzNknwbIie49HHwwasMHfpuoV0+TScDzsCzmRE+wbQg/JGroW5RDc+8FVJAeW/ki8T8AUJnhEvk9cs8Ys3CBTf/RIe0KdYDJqmNhUEe//Uvk4KriB6vOXg0TxUqkaiDMaJHS+97R7Q23jF4T34SizGL2Wh4QywmUaS/QOoX4r1O00XMuK9LgdmCwFtHB5wYMgDVPBUzPfzUnK+cqy5tDmhIUUhAXTzRvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3TGUcvpJVT+lveWFVlhCaw4n8pnrm4+2O2B+9LSS0Y=;
 b=YIMzULn9vMUgTEX4iUNvD0Zt90/sYpGzJB3+vFP0yq3cSTgv/inP1NkU+VcLNjSxrho2dgGas/qIhzLZ8fArD8m4ZyCcnEkkm7JinKkDMy0LkNvdSq4AuCvS6XU91yUmNvRR1s2gRB4BSfSS8GGcO8IIkM4hpIp6uKfCtHw7sA8=
Received: from DM8PR11MB5687.namprd11.prod.outlook.com (2603:10b6:8:22::7) by
 CY4PR1101MB2360.namprd11.prod.outlook.com (2603:10b6:903:b9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 11:50:31 +0000
Received: from DM8PR11MB5687.namprd11.prod.outlook.com
 ([fe80::e18a:23c1:abed:64a0]) by DM8PR11MB5687.namprd11.prod.outlook.com
 ([fe80::e18a:23c1:abed:64a0%6]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 11:50:31 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <michael@walle.cc>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Claudiu.Beznea@microchip.com>, <sumit.semwal@linaro.org>,
        <christian.koenig@amd.com>, <linux-i2c@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        <linaro-mm-sig@lists.linaro.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] i2c: at91: use dma safe buffers
Thread-Topic: [PATCH] i2c: at91: use dma safe buffers
Thread-Index: AQHYLxo2SrBDkK5iS0KDJl/Ehr5HqazhP32AgAAENQCAAAaigIAAEpYAgAAvSwCAAALXAIAC/hsA
Date:   Thu, 7 Apr 2022 11:50:31 +0000
Message-ID: <b80f9ff0-9fc5-7cc5-fb67-1192f3375e7b@microchip.com>
References: <20220303161724.3324948-1-michael@walle.cc>
 <46e1be55-9377-75b7-634d-9eadbebc98d7@microchip.com>
 <bc32f1107786ebcbfb4952e1a6142304@walle.cc>
 <360914ee-594c-86bc-2436-aa863a67953a@microchip.com>
 <27f124c9adaf8a4fbdfb7a38456c4a2e@walle.cc>
 <74494dda-e0cd-aa73-7e58-e4359c1ba292@microchip.com>
 <9e715ed06a28165446e29483cca7e3d0@walle.cc>
In-Reply-To: <9e715ed06a28165446e29483cca7e3d0@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd36b03d-4570-4894-a3e7-08da188cd198
x-ms-traffictypediagnostic: CY4PR1101MB2360:EE_
x-microsoft-antispam-prvs: <CY4PR1101MB2360711D68A5DB56475D2FBEE7E69@CY4PR1101MB2360.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +X71GVlq1nsxU1rQB4YoQgtzGQIHMWdqWr7bsY+pGtO/AV9gGbA13QF97VY6zYvk4wsp8mpy2eYkpwQ2WshYrHnjs2+t4w1F32FMVG+ipcDifVG2AWqxbyrxHIUVVxy89EtZyF4fvEsc6QTdicWWwDF9HK/LEc6HOUQjKCpaPHvVontyStvkCXhDwoZJubPxlGoIzTeTqWRXWPAuXthSYdAluUC6JYR2vJGXOU6zDipXBC8iQoqd7RaoiTedZhr9JmQ7bJS0HW5w9bsYWmp8G0WonxfBBmmYM4vuo+hynMA9MJpEeuPMe3RWoTLsCqOBoc0B6Jj0V+R7Q+sUlDn9bgF+Y7C60wuX3Af5Kx9irJneIt8Xn45auPpGq9GFPrJnlFvbJU5dG+ia/YTLKGU2enGrJ4XpNoQQaYevlP0dhEWnLNSSJpCgwa4mn9sCy5c1M3BKYy/NkZ8S3kXTyvefq64qZrmKMqHi0AfWvJxXrq2H52M8px0iSsoVvoKfgArnHI+lIFNmvFd+25bv6zmpX+O4UgwkR0DjzGzOycrFa32xB2BkmYc73FwxeLx5vhw9vPPEdDChtJmRAzJIXuWw/gyVA4wtL4ckcTzoGZ6UPmagI/23cFQM4IIhZkPvPfvsQwtrecV/o+DBUKnlp0GakiCMRn1vblbQIMjPN1SJX+DcGoBUfbk2KCSgkI5gRbDax6n2OWo/TijMoQNiF+MVn54QweUlRzVJ4xdbDZogg7g0oKr6duWZS0sd1daygkO2PYkRjDgIZvpkNZ0poHu6iA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5687.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(36756003)(508600001)(54906003)(6916009)(38070700005)(8936002)(5660300002)(6486002)(7416002)(2616005)(71200400001)(31686004)(2906002)(64756008)(66946007)(66446008)(66476007)(66556008)(4326008)(8676002)(38100700002)(6506007)(316002)(6512007)(31696002)(53546011)(86362001)(76116006)(91956017)(122000001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlBHTk5XRE8xSEI1d09WbWU0SEh3V1VrREdicnhaVEd0OGI3YkxSYVltOTM3?=
 =?utf-8?B?aUszck1MaHFuT29jdVRKZ25NNk5ibGdaakhsQ2pkb3ZvQ0pMNmJ0U2hKZHFS?=
 =?utf-8?B?WTNsTnpsRDdMT3pnOHNXbHZ0c3ZrdFN4Z2V3aG41V0FkSTd6aTV2U3hjRVls?=
 =?utf-8?B?bXFKSTJ0OENsWk9HYStaVnlocElhbzVKWG51bWFibWwwMldkVTNzL3FUOWNs?=
 =?utf-8?B?UVA0QkdsSm1lMFpWOTNmWWdtcEpqVG42RHNzVGZ5T1ZBZnRWeHVaS3dKZnpF?=
 =?utf-8?B?ZVk2OTF1MjRMN3NuV2V1U1YzaHV4SFk4SDZrbk5ReVh1L3BqSnRDc3hGaEJ2?=
 =?utf-8?B?aXo2Tlg0TmZLR3VUb1lNTGlYUGVxRmdsQmNtNW8wMW5rKzluU1FoclhQRnpX?=
 =?utf-8?B?czVKSFlNdXZPQncxZm9mZDh5UWdKTC8yYjRrUHdoZiswS3A0ekZFY1B0SGtV?=
 =?utf-8?B?UWJ6Wk5kVDFGcEI1YzBqRlRrRmhpTGpMS2Z0K2VHbGNnVlhBelV0Mkx5TFk3?=
 =?utf-8?B?b1NvMWtQT0YvZjNOd280SkFQNUt4b0Y2SEszVWxUQkJhbTJ3MTBlVXF4WENB?=
 =?utf-8?B?NW1NbDMwYkdMUzdhZFBVWlhkK3llaXN1TVg0RGY0Z1hyemhsUlJhMU1CZDhJ?=
 =?utf-8?B?b3E4eS9rRHRBZlh4N0xBL3A2am1QY2U4akM5c0MyZXEwZ1pmYVVjUi9xQkVk?=
 =?utf-8?B?OXJzaGFrWjEzaWVISldMdnpLL0FtTmhWTXZad2Z0d1l0NkhFNWdzQ2tlUnht?=
 =?utf-8?B?SUYwWmU3TnhkRklQME80WWpGOHQzL0dkbXJPcS81dis2dEFmMGlBS3RXM3Bu?=
 =?utf-8?B?K0VPVzU3OVRCNGUwZVRoN2xKUTZONnZuV25VekxqcnFLTTJ3Z2tLZktkajJ5?=
 =?utf-8?B?NVJnelRtZ1VYMzZnbk1vdVZraW5tQ05lcjU2ZmdmWWJ2U0g0LzkxaWRVVE5J?=
 =?utf-8?B?VjJ6UzEvVS8zRUFHWisybENkUzZQQVBnc0lxVWRrOTl0azZGSWVRdTU1V1Qx?=
 =?utf-8?B?MXhsR3ZnbzNuVkJ6VFRIeGZFcnlVeEgzb0NhQTRVa0dCZkpNcnBNQlBwV1du?=
 =?utf-8?B?RXVhcTdrMXRrRkNzMWdwMFF6eFd6bktlaTdQeGFNTEF4eDQySFJLYU9wT2F3?=
 =?utf-8?B?djkxeUJvcnNHV0VtTlZyUXUxTVh6Z2hEVy9ieUs2cG5vbmJSVHJpUWRLKzd1?=
 =?utf-8?B?Rm96Rzc5bFgyeEpnMDhKcWNJMWRqY2dhVmlqZzRkRVQ2VzhVdmNYRXEzUkJO?=
 =?utf-8?B?WjlaNWpJdlhiUFQ0eUozZUtoaXBrOEFIU0VTWTBGNVZMaUIxbU1MQUxrNUl2?=
 =?utf-8?B?VGZ3a1krVW1OZ2tPNXl1YkhuQWRiODIxSzgyNGUxNERjRENtakZIVVFNYkhQ?=
 =?utf-8?B?UW44TmlKUmxvKzdGVG8ycGpoTW9taHV2ckFnQmw1REZJc2M1ell0WlNwM1Ux?=
 =?utf-8?B?YmNVNDI1UlFpdkEydnRKcm9XdVVXTnhGbEFmVVVYUWl5NlBBNmVOaW4xWit0?=
 =?utf-8?B?RnZDTWRwd25ETUwzc1hBRER5TnZpdkIzK3RKejFxbUlOSU5kZUVDQjk0OUVt?=
 =?utf-8?B?K3FWYS9CYXVxNXQ5S3locXFkeWp6N0NvNlZQZ3I2a1pBbCtaSTRCUnRySzR6?=
 =?utf-8?B?OGQyOEdSc1JSbElDTXMreitiQzlTSFhsQUFOa3RmNiszYXQrUkFrN04rTjg1?=
 =?utf-8?B?cExwOFJPdVBKaCtpMVhLK0c3azdwWmxJUVZva3ZFVm1HSDQ4Zkh1MklhK0Ry?=
 =?utf-8?B?cGdmcDNBNDhtb1FlWWhxb21HdTZ5d1NlYVJRZmFtbXcyZWEzaHFRZTdsbS83?=
 =?utf-8?B?NCtPZkw1RkRhM1d1blJhWWwvUWZxTUxZZ1pWT2NTSEVXMi9ickNuTk1ESndj?=
 =?utf-8?B?WlcwbG9PRG1YWVJPQ0gxeXd2TS9ZQS9KYlVnL01Kd1ZsblpZZk5pdENmVDZL?=
 =?utf-8?B?RzRIcEZCZGk2aWhSUEUybFpocURIbXROT2RhZzBhZ1NwTE5QM25FRkttclpP?=
 =?utf-8?B?RkdSRERRc1JSV2x3Si9mMXlWYnBjWVR1NEpGSlIzYU95S1RNY1k4cllQRmtx?=
 =?utf-8?B?RkltNUhVTE01K2t2c3pFMzJGR1F3Ymo3UWVkcXZEclFUUlVtR3VBWmpjVFpz?=
 =?utf-8?B?WVZqYWVDQXlDUkVteU5mU212L1VaUDJ4S1RaSnZwYkFlYWNzOVdwK0xaUWI1?=
 =?utf-8?B?Q3hFUHlxa1d4Mm5adHN5MmZnY3NseXVWTUYrVFFob2FaU2xxOFFnRVJIR08w?=
 =?utf-8?B?OEFwb2pldlpzZWp1Z2phL3ZPc3hlbk1qUmdiL01PUjl4T014Nm02b1NzM3dK?=
 =?utf-8?B?SDEvTEZNWlpiSjM5Y1N3ZzdzR1dyLzVFYVNtakpQN3kyeFJ4THoyd3liWW00?=
 =?utf-8?Q?KMGcdy6nlETCoGQ7I8huzNvHuPJXtqmH6SyCMaZ3mX3T1?=
x-ms-exchange-antispam-messagedata-1: /+vJfd60nI6Axt89QhluYJJedF4nVfdcdRk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0C11A77E103AD44950E5C0D0C6578F1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5687.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd36b03d-4570-4894-a3e7-08da188cd198
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2022 11:50:31.6651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EIbsTcWIzWxbDHFZ7gnXzD74G74yJyoamHFYmZMcVkWIAgmY7uy0nF+dVC01iHhicLUGEKXAbYqxSOCFKtSjS/uC0a1pJVwBxzrmqCXfWy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2360
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMDUuMDQuMjAyMiAxNzowOCwgTWljaGFlbCBXYWxsZSB3cm90ZToNCj4gRVhURVJOQUwgRU1B
SUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25v
dyANCj4gdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gQW0gMjAyMi0wNC0wNSAxNTo1OCwgc2No
cmllYiBDb2RyaW4uQ2l1Ym90YXJpdUBtaWNyb2NoaXAuY29tOg0KPj4gT24gMDUuMDQuMjAyMiAx
NDowOSwgTWljaGFlbCBXYWxsZSB3cm90ZToNCj4+PiBBbSAyMDIyLTA0LTA1IDEyOjAyLCBzY2hy
aWViIENvZHJpbi5DaXVib3Rhcml1QG1pY3JvY2hpcC5jb206DQo+Pj4+IE9uIDA1LjA0LjIwMjIg
MTI6MzgsIE1pY2hhZWwgV2FsbGUgd3JvdGU6DQo+Pj4+PiBBbSAyMDIyLTA0LTA1IDExOjIzLCBz
Y2hyaWViIENvZHJpbi5DaXVib3Rhcml1QG1pY3JvY2hpcC5jb206DQo+Pj4+Pj4+ICvCoMKgwqDC
oMKgwqAgaWYgKGRldi0+dXNlX2RtYSkgew0KPj4+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBkbWFfYnVmID0gaTJjX2dldF9kbWFfc2FmZV9tc2dfYnVmKG1fc3RhcnQsIDEpOw0K
Pj4+Pj4+DQo+Pj4+Pj4gSWYgeW91IHdhbnQsIHlvdSBjb3VsZCBqdXN0IGRldi0+YnVmID0gaTJj
X2dldF9kbWFfc2FmZS4uLg0KPj4+Pj4NCj4+Pj4+IEJ1dCB3aGVyZSBpcyB0aGUgZXJyb3IgaGFu
ZGxpbmcgaW4gdGhhdCBjYXNlPyBkZXYtPmJ1ZiB3aWxsDQo+Pj4+PiBiZSBOVUxMLCB3aGljaCBp
cyBldmVudHVhbGx5IHBhc3NlZCB0byBkbWFfbWFwX3NpbmdsZSgpLg0KPj4+Pj4NCj4+Pj4+IEFs
c28sIEkgbmVlZCB0aGUgZG1hX2J1ZiBmb3IgdGhlIGkyY19wdXRfZG1hX3NhZmVfbXNnX2J1Zigp
DQo+Pj4+PiBjYWxsIGFueXdheSwgYmVjYXVzZSBkZXYtPmJ1ZiB3aWxsIGJlIG1vZGlmaWVkIGR1
cmluZw0KPj4+Pj4gcHJvY2Vzc2luZy4NCj4+Pj4NCj4+Pj4gWW91IHN0aWxsOg0KPj4+PiDCoMKg
wqDCoMKgIGlmICghZGV2LT5idWYpIHsNCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0ID0gLUVOT01FTTsNCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7
DQo+Pj4+IMKgwqDCoMKgwqAgfQ0KPj4+Pg0KPj4+PiBTbywgYXQ5MV9kb190d2lfdHJhbnNmZXIo
KS9kbWFfbWFwX3NpbmdsZSgpIHdpbGwgbm90IGJlIGNhbGxlZC4NCj4+Pg0KPj4+IEFoaCwgSSBt
aXN1bmRlcnN0b29kIHlvdS4gWWVzLCBidXQgYXMgSSBzYWlkLCBJIG5lZWQgdGhlIGRtYV9idWYN
Cj4+PiB0ZW1wb3JhcnkgdmFyaWFibGUgYW55d2F5LCBiZWNhdXNlIGRldi0+YnVmIGlzIG1vZGlm
aWVkLCBlZy4gc2VlDQo+Pj4gYXQ5MV90d2lfcmVhZF9kYXRhX2RtYV9jYWxsYmFjaygpLg0KPj4g
YXQ5MV90d2lfcmVhZF9kYXRhX2RtYV9jYWxsYmFjaygpIGlzIGNhbGxlZCBhcyBjYWxsYmFjayBp
Zg0KPj4gZG1hX2FzeW5jX2lzc3VlX3BlbmRpbmcoZG1hLT5jaGFuX3J4KSBpcyBjYWxsZWQuDQo+
PiBkbWFfYXN5bmNfaXNzdWVfcGVuZGluZyhkbWEtPmNoYW5fcngpIGlzIGNhbGxlZCBvbg0KPj4g
YXQ5MV90d2lfcmVhZF9kYXRhX2RtYSgpLCB3aGljaCBpcyBjYWxsZWQgaW4gYXQ5MV9kb190d2lf
dHJhbnNmZXIoKSwNCj4+IHdoaWNoIHdlIGRlY2lkZWQgYWJvdmUgdG8gc2tpcCBpbiBjYXNlIG9m
IGVycm9yLg0KPiANCj4gSXQgaXMgbm90IGFib3V0IGVycm9ycywgeW91IG5lZWQgdGhlIGV4YWN0
IHNhbWUgcG9pbnRlciB5b3UNCj4gZ290IGZyb20gaTJjX2dldF9kbWFfc2FmZV9tc2dfYnVmKCkg
dG8gYmUgcGFzc2VkIHRvDQo+IGkyY19wdXRfZG1hX3NhZmVfbXNnX2J1ZigpLiBBbmQgYmVjYXVz
ZSAoaW4gc29tZSBjYXNlcywgaXQNCj4gaXNuJ3QgcmVhbGx5IG9idmlvdXMpIHRoZSBkZXYtPmJ1
ZiB3aWxsIGJlIGFkdmFuY2VkIGEgZmV3DQo+IGJ5dGVzLCBJIGNhbm5vdCBwYXNzIGRldi0+YnVm
IHRvIGkyY19wdXRfZG1hX3NhZmVfbXNnX2J1ZigpLg0KDQpZb3UgYXJlIHJpZ2h0LCB3aGVuIGRl
di0+dXNlX2RtYSAmJiAoZGV2LT5idWZfbGVuIDw9IEFUOTFfSTJDX0RNQV9USFJFU0hPTEQpDQoN
CmdvdCBpdC4gVGhhbmtzIQ0KDQpCZXN0IHJlZ2FyZHMsDQpDb2RyaW4NCg==
