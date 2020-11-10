Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775272ADFA0
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 20:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732765AbgKJTdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 14:33:12 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:51064 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732739AbgKJTdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 14:33:10 -0500
Received: from mailhost.synopsys.com (badc-mailhost4.synopsys.com [10.192.0.82])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B9862C00DC;
        Tue, 10 Nov 2020 19:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1605036789; bh=KKDbFoNYyRc2NmRMSbjf5j0UT/VS9qAVcZ8cFo6ssQ4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=gMoTwsaz2dPURCPoF6bSyfxTLqYTqP9EagXigMQ6324OX4II+6ZEEu4SzLtvDREXL
         O6P21SdGgG7MMPUIuL95qu1mHpdGn96Dcniid75OVRxcCS5X3mfLAy+xrAdIozRDeu
         xZLQICRFtGLtVj3MFYiU11gaX5+pL2MSywL2wIZ+Y35lhtfeBTl2WTCFZX0iHYacDZ
         rZT0LBV4+Mc59Em/TEMJSgkfb1XbnuAWz7+1qRZkgOJzAGZLUe1mlgnHHLF4Dhyd3m
         fTHh9irQr4T6GbmrRDZZrQbWL8n+MuEtQ+6gOpya3ti9ksDd617kTKXTL1pWvSSAW2
         SmcgmwdLXTYMw==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 8DC61A005E;
        Tue, 10 Nov 2020 19:33:05 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id AAD804004A;
        Tue, 10 Nov 2020 19:33:04 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=vgupta@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="SjdYXZMN";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQ6l1dKEKkKOs8TqpkxEgx+LbjjxsuQIXhzLy6ExSAFE5tqoVA7xFVEwOQhj7sf3pQ0XXxJWNAeDIFP40jjadZ2V05gsaKDy+K9TAsGV90kV88bS8Lrwpzt/vEouG6FE2ghempTRnvho+T+dybAA8brOxbViZchwEO4z0s0MwxJpQbtGexLbrYFZp7f+gExPywYBNmNTaMJmCyYW1lNJTwm8LcP4k1tzggSfFHQYy4okA9fcJANVUvwHcnDG1xpYskf9f9B27Mgy83LtRIImWeDd3mzs0KZfEZHt/6KgSUYhI645CIhoK7dwYP7av8JZY5Zq7ib7i+YKImJgONYcUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKDbFoNYyRc2NmRMSbjf5j0UT/VS9qAVcZ8cFo6ssQ4=;
 b=G6OzikgU36KERaPav3Z7TPhk0Y962j2c9dzqKJx5o4VJf8DvuxV8/edG4+c1xsPCSoU/4XmJ1Wc63HMD+ZqLGNeq4l7t+UDDtVS+TPQUKBvFYdJPo2ckMvHic2pYdm4Iejbz3y8agwxoGi2swDQXXg6lyzNW6ypMczC2HBgfaHDJMTYjtsxXHItHzJUSrwnxlm78V5TX+2argw3BD/Odm0EPFGv8S6qPB60LYkWSeYWowpQA7MOOEHB0O+pTG69wNOjrGjd3usUosu26EOaQMYfSbZrmd1OSC/VlahZ7DiLSt2D8HZ+TQf+JblFCYsKsWtXG6q5+fyxniYggZPe3/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKDbFoNYyRc2NmRMSbjf5j0UT/VS9qAVcZ8cFo6ssQ4=;
 b=SjdYXZMNFv0QTtBBQ7MazRk/gzOlCt029Wv8ZI5D1VjVAY5oDUb3d5veKKOyVv6OHC3daoH47Gb++bnVWNhTxJ4HpTmxaU++rthKlPHFL/47uC0tMJk/ube9jjUlWVGu1bbWoEgqjihCcbbc+/Ax4P0tfSlQy9RpQPEI9hwMpgk=
Received: from BYAPR12MB3479.namprd12.prod.outlook.com (2603:10b6:a03:dc::26)
 by BYAPR12MB2901.namprd12.prod.outlook.com (2603:10b6:a03:138::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Tue, 10 Nov
 2020 19:33:03 +0000
Received: from BYAPR12MB3479.namprd12.prod.outlook.com
 ([fe80::c562:e026:68d6:cd31]) by BYAPR12MB3479.namprd12.prod.outlook.com
 ([fe80::c562:e026:68d6:cd31%6]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 19:33:02 +0000
X-SNPS-Relay: synopsys.com
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Waldemar Brodkorb <wbx@uclibc-ng.org>
Subject: Re: [PATCH] Revert "ARC: entry: fix potential EFA clobber when
 TIF_SYSCALL_TRACE"
Thread-Topic: [PATCH] Revert "ARC: entry: fix potential EFA clobber when
 TIF_SYSCALL_TRACE"
Thread-Index: AQHWpoeFs2lAESMsXEi9RfDQ8a2iPKm7qYCAgAEo0wCAAub0AIACKkSA
Date:   Tue, 10 Nov 2020 19:33:02 +0000
Message-ID: <bb732e42-c679-eb26-e87c-b00fd12f65d3@synopsys.com>
References: <20201020021957.1260521-1-vgupta@synopsys.com>
 <9cec26bd-6839-b90d-9bda-44936457e883@synopsys.com>
 <20201107141006.GB28983@kroah.com> <20201109102914.GD1238638@kroah.com>
In-Reply-To: <20201109102914.GD1238638@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=synopsys.com;
x-originating-ip: [24.4.73.83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20cc4ec3-d4ef-400e-0a61-08d885af7099
x-ms-traffictypediagnostic: BYAPR12MB2901:
x-microsoft-antispam-prvs: <BYAPR12MB2901B34EF738B61F761D8914B6E90@BYAPR12MB2901.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mMAZ32z5PJOxHQeCywgF7xSnfYqdc7t2usSsMPIZOlVivP7pPoaYVUIg2nOwRsZtuymOl8VQ4P6wLdV3O5/F56m0OwIPJx/r9oYLAL8l/d2i7SgXrJdo/zsI9CJF58AKCm2xD1iA8yA8WaRvlHSC3V1VFoIRnf8FUXXPvr/44CTLuLGdUttRLJo6Rh8qAHAwCjjHn09uqyUniJdyr/hBvF5jkfcsiqFsErnixC6SPlCHJV1ara6QhHsNbVIduY4MP+35PaT9c3DF5kXA4yE1qFrq8VmD9Ve/zCl/AvjXQy9DOS3erFUepqfdYXNcM+2UebbPPMIO84Fzlu4NAqNhy5rdMDsL8ZNU1BUPkuOzVz0E+18QxEsieqaKIGx1gVFf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3479.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(6916009)(8676002)(36756003)(76116006)(2906002)(4326008)(186003)(6486002)(54906003)(6506007)(8936002)(53546011)(71200400001)(26005)(31686004)(31696002)(86362001)(498600001)(64756008)(66556008)(66946007)(66446008)(66476007)(6512007)(2616005)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: GbzlscehQo4s6rqyNAW+ycpWLZx8E71nj4DBmKMhbcN5kIrVRVZj7OROFf3BMZscrGQ44TzkRwKM9yeXzDYq+H5ds0cuLs3U70qRBG7TMSMyoqOtan4usg2O+h4pzndjVJh/CUlpCiEi/PTAhOjuStPKTt3LfTcfsTN8XvLVaXzen+3uOx6XV43LiuUxyzMriGavpgPl5Ym9QEbrc50gjbamN/ektVJpkjHc3OGDXBFv++CSAmyhRmNTd+334lhcaRoG1mhCKOTg6lEh10+ad+5yxVWOsPRPEGZ6xQa0i1pS4CkZXLZUu1v2BTg5CkM8CMnERm3815I0LbCYVRpMNFu1Q2rj+bmTBDd7JGug9D2oZsY4BTcAhlIJzOO4hSR04Cjv8CMBtmh1ZQ1V/YB843pfzyM+q5cL3OA/wOgtOrQDvMLiDJZ+V25Dz4/anflFhupthokNYCEuNVSA6OVNhfWIu7J8BO5H8G3YDQFOF3x6QJ69UH8iNS/2nLrdtHsqjMa6wSCtni1bIPK7fNLZlqgp6hsNJO0Ix0dyUH/fnuxUMyiwC1ihWi+RRPeV0D8x/c0KTfVUEecMjNx5G2ppdPRQEwsQjgtGZD7S+2zVAREE3MgmsAcSu48RUqfCYs1tsCdeBlKickqarzDC7iT4tg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A949D3CD6BA3F144AC5BD65215D1BD16@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3479.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20cc4ec3-d4ef-400e-0a61-08d885af7099
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2020 19:33:02.4855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7c8Hj2SVESIHK304+MOjCRLfAqyDgNqZXntQJS5+IeFokijSJK6iGdadTUfsCj0IO0hghPKSieEFrRNNRZ+aPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2901
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTEvOS8yMCAyOjI5IEFNLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+IE9uIFNhdCwg
Tm92IDA3LCAyMDIwIGF0IDAzOjEwOjA2UE0gKzAxMDAsIEdyZWcgS3JvYWgtSGFydG1hbiB3cm90
ZToNCj4+IE9uIEZyaSwgTm92IDA2LCAyMDIwIGF0IDA4OjI3OjQ0UE0gKzAwMDAsIFZpbmVldCBH
dXB0YSB3cm90ZToNCj4+PiBIaSBTdGFibGUgVGVhbSwNCj4+Pg0KPj4+IE9uIDEwLzE5LzIwIDc6
MTkgUE0sIFZpbmVldCBHdXB0YSB3cm90ZToNCj4+Pj4gVGhpcyByZXZlcnRzIGNvbW1pdCAwMGZk
ZWM5OGQ5ODgxYmY1MTczYWYwOWFlYmQzNTNhYjNiOWFjNzI5Lg0KPj4+PiAoYnV0IG9ubHkgZnJv
bSA1LjIgYW5kIHByaW9yIGtlcm5lbHMpDQo+Pj4+DQo+Pj4+IFRoZSBvcmlnaW5hbCBjb21taXQg
d2FzIGEgcHJldmVudGl2ZSBmaXggYmFzZWQgb24gY29kZS1yZXZpZXcgYW5kIHdhcw0KPj4+PiBh
dXRvLXBpY2tlZCBmb3Igc3RhYmxlIGJhY2stcG9ydCAoZm9yIGJldHRlciBvciB3b3JzZSkuDQo+
Pj4+IEl0IHdhcyBPSyBmb3IgdjUuMysga2VybmVscywgYnV0IHR1cm5lZCB1cCBuZWVkaW5nIGFu
IGltcGxpY2l0IGNoYW5nZQ0KPj4+PiA2OGU1YzZmMDczYmNmNzAgIihBUkM6IGVudHJ5OiBFVl9U
cmFwIGV4cGVjdHMgcjEwICh2cy4gcjkpIHRvIGhhdmUNCj4+Pj4gICBleGNlcHRpb24gY2F1c2Up
IiBtZXJnZWQgaW4gdjUuMyB3aGljaCBpdHNlbGYgd2FzIG5vdCBiYWNrcG9ydGVkLg0KPj4+PiBT
byB0byBzdW1tYXJpemUgdGhlIHN0YWJsZSBiYWNrcG9ydCBvZiB0aGlzIHBhdGNoIGZvciB2NS4y
IGFuZCBwcmlvcg0KPj4+PiBrZXJuZWxzIGlzIGJ1c3RlZCBhbmQgaXQgd29uJ3QgYm9vdC4NCj4+
Pj4NCj4+Pj4gVGhlIG9idmlvdXMgc29sdXRpb24gaXMgYmFja3BvcnQgNjhlNWM2ZjA3M2JjZjcw
IGJ1dCB0aGF0IGlzIGEgcGFpbiBhcw0KPj4+PiBpdCBkb2Vzbid0IHJldmVydCBjbGVhbmx5IGFu
ZCBlYWNoIG9mIGFmZmVjdGVkIGtlcm5lbHMgKHNvIGZhciB2NC4xOSwNCj4+Pj4gdjQuMTQsIHY0
LjksIHY0LjQpIG5lZWRzIGEgc2xpZ2h0bHkgZGlmZmVyZW50IG1hc3NhZ2VkIHZhcmFpbnQuDQo+
Pj4+IFNvIHRoZSBlYXNpZXIgZml4IGlzIHRvIHNpbXBseSByZXZlcnQgdGhlIGJhY2twb3J0IGZy
b20gNS4yIGFuZCBwcmlvci4NCj4+Pj4gVGhlIGlzc3VlIHdhcyBub3QgYSBiaWcgZGVhbCBhcyBp
dCB3b3VsZCBjYXVzZSBzdHJhY2UgdG8gc3BvcmFkaWNhbGx5DQo+Pj4+IG5vdCB3b3JrIGNvcnJl
Y3RseS4NCj4+Pj4NCj4+Pj4gV2FsZGVtYXIgQnJvZGtvcmIgZmlyc3QgcmVwb3J0ZWQgdGhpcyB3
aGVuIHJ1bm5pbmcgQVJDIHVDbGliYyByZWdyZXNzaW9ucw0KPj4+PiBvbiBsYXRlc3Qgc3RhYmxl
IGtlcm5lbHMgKHdpdGggb2ZmZW5kaW5nIGJhY2twb3J0KS4gT25jZSBoZSBiaXNlY3RlZCBpdCwN
Cj4+Pj4gdGhlIGFuYWx5c2lzIHdhcyB0cml2aWFsLCBzbyB0aHggdG8gaGltIGZvciB0aGlzLg0K
Pj4+Pg0KPj4+PiBSZXBvcnRlZC1ieTogV2FsZGVtYXIgQnJvZGtvcmIgPHdieEB1Y2xpYmMtbmcu
b3JnPg0KPj4+PiBCaXNlY3RlZC1ieTogV2FsZGVtYXIgQnJvZGtvcmIgPHdieEB1Y2xpYmMtbmcu
b3JnPg0KPj4+PiBDYzogc3RhYmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiAjIDUuMiBhbmQg
cHJpb3INCj4+Pj4gU2lnbmVkLW9mZi1ieTogVmluZWV0IEd1cHRhIDx2Z3VwdGFAc3lub3BzeXMu
Y29tPg0KPj4+IENhbiB0aGlzIHJldmVydCBiZSBwbGVhc2UgYXBwbGllZCB0byA0LjE5IGFuZCBv
bGRlciBrZXJuZWxzIGZvciB0aGUgbmV4dCBjeWNsZS4NCj4+Pg0KPj4+IE9yIGlzIHRoZXJlIGlz
IGEgcHJvY2VkdXJhbCBpc3N1ZSBnaXZlbiB0aGlzIHJldmVydCBpcyBub3QgaW4gbWFpbmxpbmUu
IEkndmUNCj4+PiBkZXNjcmliZWQgdGhlIGlzc3VlIGluIGRldGFpbCBhYm92ZSBzbyBpZiB0aGVy
ZSdzIGEgYmV0dGVyL2Rlc2lyYWJsZSB3YXkgb2YNCj4+PiByZXZlcnRpbmcgaXQgZnJvbSBiYWNr
cG9ydHMsIHBsZWFzZSBsZXQgbWUga25vdy4NCj4+IFRIaXMgaXMgZmluZSwgc29ycnksIGl0J3Mg
anVzdCBpbiBhIGJhY2tsb2cgb2YgbG90cyBvZiBzdGFibGUgcGF0Y2hlcy4uLg0KPj4NCj4+IFdl
IHdpbGwgZ2V0IHRvIGl0IHNvb24uDQo+IE5vdyBxdWV1ZWQgdXAsIHRoYW5rcy4NCg0KVGh4IGEg
YnVuY2ggR3JlZy4NCg0KLVZpbmVldA0K
