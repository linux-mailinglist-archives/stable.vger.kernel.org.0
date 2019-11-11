Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB3BF6DB0
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 06:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbfKKFAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 00:00:34 -0500
Received: from mail-eopbgr740047.outbound.protection.outlook.com ([40.107.74.47]:36483
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725796AbfKKFAe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 00:00:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=loa3sM6WqXPqCh8R5fyRycnSwE0nrOrzvoeqcRIW/iu4+9ZO59WNYaD0qGWr5eSWewTaUJS8/skhzRrH0oT3fYzGW4bBR72rDuKItQ5s7aebiG4J7hoOfgmYBREBRU1pffaik/YCr058EikLNoJgHNVEXWqOrfKaakVqBl8FMB8HKqpvyoZaJPcEA7CjVFk4AH4r9tp8x7HqTOBUAtDbe28wlEWgOpykhyvjTqsBSURygUfWuCq6bUa+mV5qeW08knHumMkoQV/GfdUUKs7ehENbojVUM9QanvmnpdqDJgPEpw+LMsAfdoYsJ7yPfasKfzBCDMdfLllXXvh5vZuOXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zpk6RxWm1NOVU5k56xgyXPQa//LIW9EkPJQ91L5hg4=;
 b=BSsGGJ1GStzHR/WssE1IHOSTI858v5LDH8pkKmZzbNxjnotY6coThTWH5aidCC+MFAhuPGBSEFnFdCVZb93vgleyizn6+KS5NFHUi5PdzETohaPoSHicZEzO3YmCWuKj9RWSa8608o/B5YC50bp5YOlL/edSeaZm043x5o3dbVav/MAtmfMqIA5ZTspfdzwwJwHUKlYKeokEJpgiueDFZgCVyVsjrmjLqjh0Yjl0T8kkrWT3fId8kRN0NJi+5HeIGYJE0dlbrOYX+CWwbZTsaogUsfUJrb32FTEEGvOvtHK83bcB2/cTGwT4BXkGcxLifyCUbXsKdTsFGiff1RjmWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zpk6RxWm1NOVU5k56xgyXPQa//LIW9EkPJQ91L5hg4=;
 b=iqEPS+HestkzW47z8bKkXx8V5ilzHZjBaYXW3M7Uiztrv5nu0Nz+dbsHVNbB9URA7gq37TM9Zc+/OR9j6PGO2sY6baxVUE7ZCxfhvi5cjTKikiCcl9OMWS+6LkjwceskhYerA7LxqfzwqwyN4yQdGDU7sEUU/MaTyl71Z5A5gt8=
Received: from MN2PR05MB6208.namprd05.prod.outlook.com (20.178.241.91) by
 MN2PR05MB6814.namprd05.prod.outlook.com (52.132.172.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.16; Mon, 11 Nov 2019 05:00:30 +0000
Received: from MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::f0a2:e9fe:d312:7470]) by MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::f0a2:e9fe:d312:7470%4]) with mapi id 15.20.2451.018; Mon, 11 Nov 2019
 05:00:30 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     Vlastimil Babka <vbabka@suse.cz>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "punit.agrawal@arm.com" <punit.agrawal@arm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "mszeredi@redhat.com" <mszeredi@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Srinidhi Rao <srinidhir@vmware.com>,
        Vikash Bansal <bvikas@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        Steven Rostedt <srostedt@vmware.com>,
        "stable@kernel.org" <stable@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH v2 6/8] mm: prevent get_user_pages() from overflowing page
 refcount
Thread-Topic: [PATCH v2 6/8] mm: prevent get_user_pages() from overflowing
 page refcount
Thread-Index: AQHVfffGKc9CRR2dekieWi7B72DxaadSSqyAgA0lZICAC+hNgIASq5UAgAf2KoA=
Date:   Mon, 11 Nov 2019 05:00:29 +0000
Message-ID: <88E8A78A-6CA3-46C1-A2AA-DFE7A3A52586@vmware.com>
References: <1570581863-12090-1-git-send-email-akaher@vmware.com>
 <1570581863-12090-7-git-send-email-akaher@vmware.com>
 <f899be71-4bc0-d07b-f650-d85a335cdebb@suse.cz>
 <BF0587E3-D104-4DB2-B972-9BC4FD4CA014@vmware.com>
 <0E5175FB-7058-4211-9AA4-9D5E2F6A30B9@vmware.com>
 <35d74931-2c18-00ff-7622-522a79be9103@suse.cz>
In-Reply-To: <35d74931-2c18-00ff-7622-522a79be9103@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [2409:4071:220e:3934:3c2a:8f63:a44f:9055]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc85f22b-e9b6-4b57-d853-08d766641366
x-ms-traffictypediagnostic: MN2PR05MB6814:|MN2PR05MB6814:|MN2PR05MB6814:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR05MB6814B219DD57C19FA23F2631BB740@MN2PR05MB6814.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(39860400002)(396003)(346002)(199004)(189003)(76176011)(33656002)(54906003)(110136005)(102836004)(99286004)(478600001)(66476007)(66556008)(64756008)(66446008)(6116002)(36756003)(6436002)(91956017)(76116006)(66946007)(305945005)(229853002)(7736002)(5660300002)(25786009)(6506007)(7416002)(6486002)(86362001)(4744005)(316002)(71200400001)(71190400001)(53546011)(14454004)(186003)(256004)(46003)(446003)(11346002)(2906002)(81166006)(81156014)(8676002)(6512007)(8936002)(4326008)(6246003)(476003)(2616005)(486006)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6814;H:MN2PR05MB6208.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kA8ESF8+dEws6fJizvSKRDn5/ju4We9vuzfhtmf/kdiN8RoAsAmWvdbhiFsWmVmFaltUl68WyJW9a97Mbg2lIYBucOEcvxESmM8UuSukevSTsksoVCxHPdaTtLC7rQaAJTxT9D4Mt3x8cCv3AqoI5Rf3V6RV0tEXhT8eaoDrfcuws0veAmCGRSkg7YJoz7GUKaMELjy2uCVZH9ImvCK6Xr+2VLpFHLglODjGsXLh4UzQVr/3YvJVaSIaiVXp/7W2GNpj5TFzpFBiibXSMhX1dtfJfz/AWy2hXFF5BpCj9QIYVlTZBmQ+pEvzU84/FsqnoicEm1zgPyZa6WStIOyTg6VQG+6GWQc1s9ZHWxlzObl5O9hZ99Gd7jPjdpUvqfg1SmKe7K5Q7+lBSV/Gbe5PLohqUl8pEm4ck045vzbUYpmeNVEg8tWRJGgiiUasCZxb
Content-Type: text/plain; charset="utf-8"
Content-ID: <219FFBD87736E845A639BFC215EF7855@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc85f22b-e9b6-4b57-d853-08d766641366
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2019 05:00:30.2135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i+vsoXlm6h9qxD5hhirEgIRMDjb8xqOf7cjXF4ovWUtCwZAgeujdiCTsTuaeSoC2O867jo8ZLEca6nTGgsIQgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6814
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQrvu79PbiAwNi8xMS8xOSwgMjoyNSBQTSwgIlZsYXN0aW1pbCBCYWJrYSIgPHZiYWJrYUBzdXNl
LmN6PiB3cm90ZToNCg0KPiBPbiAxMC8yNS8xOSA4OjE4IEFNLCBBamF5IEthaGVyIHdyb3RlOg0K
Pj4gT24gMTcvMTAvMTksIDk6NTggUE0sICJBamF5IEthaGVyIiA8YWthaGVyQHZtd2FyZS5jb20+
IHdyb3RlOg0KPj4gICAgIA0KPj4+ICAgIA0KPj4+IENvdWxkIHdlIGhhbmRsZSBhcmNoLXNwZWNp
ZmljIGd1cC5jIGluIGRpZmZlcmVudCBwYXRjaCBzZXRzIGFuZCANCj4+PiBsZXQgdGhlc2UgcGF0
Y2hlcyB0byBtZXJnZSB0byA0LjQueT8NCj4+ICAgDQo+PiBWbGFzdGltaWwsIHBsZWFzZSBzdWdn
ZXN0IGlmIGl0J3MgZmluZSB0byBtZXJnZSB0aGVzZSBwYXRjaGVzIHRvIDQuNC55DQo+DQo+IEkn
bSBub3Qgc3VyZSBpZiBpdCBtYWtlcyBtdWNoIHNlbnNlIHRvIG1lcmdlIHRoZW0gd2l0aG91dCB0
aGUgYXJjaC1zcGVjaWZpYyBndXANCj4gc3VwcG9ydCwgd2hlbiB3ZSdyZSBhd2FyZSB0aGF0IGl0
J3MgbWlzc2luZy4NCj4NCj4+IGFuZCBoYW5kbGUgYXJjaC1zcGVjaWZpYyBndXAuYyBpbiBkaWZm
ZXJlbnQgcGF0Y2ggc2V0cyBzdGFydHMgZnJvbSA0LjE5LnksDQo+DQo+IEFjdHVhbGx5IGFyY2gt
c3BlY2lmaWMgZ3VwLmMgd2VyZSByZW1vdmVkIGluIDQuMTMsIHNvIGl0J3MgZW5vdWdoIHRvIHN0
YXJ0IGZyb20NCj4gNC45LnksIHdoaWNoIEknbSBnb2luZyB0byBmaW5hbGx5IGxvb2sgaW50by4N
Cg0KWWVzIHg4NiBndXAuYyBpcyByZW1vdmVkLiBzMzkwIGd1cC5jIGlzIHByZXNlbnQgdGlsbCA0
LjE5LA0Kc28gaWYgeW91IGFyZSBtYWtpbmcgY2hhbmdlcyBpbiB0aGlzIGZpbGUgZm9yIDQuNC55
IGFuZCA0LjkueSwgDQp0aGVuIHNhbWUgc2hvdWxkIGJlIGRvbmUgZm9yIDQuMTQueSBhbmQgdjQu
MTkueS4NCg0KLSBBamF5DQogICAgDQogICAgDQoNCg==
