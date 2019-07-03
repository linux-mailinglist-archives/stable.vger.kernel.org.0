Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07D85E878
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 18:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfGCQM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 12:12:58 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:52112 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725847AbfGCQM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 12:12:58 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D06E1C00FF;
        Wed,  3 Jul 2019 16:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1562170377; bh=0HCbz62W0SD90lgw0eWLOaeWUqNPRKl575wG2TM8rHs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Z5JHl88YhGRScP/0PYjz7Yk/PsU47jnxe1+BR6t14LJHkP60SA1ITl0otDn2RmBvs
         CZmvnbQV49ikmBOmoOVdxVPeIVlTiSolrEbWM/k7PaD39OKmIgy+GoOoelMa6Z3BSS
         NC/9T5E6Ez+cPLp5joh2qfpDuQ72mjgOzGiQRNSzXyWB73HU/gif0MHqbAXBoNsiKF
         tUlnAmyML52yfg4Bmp8eXeB6O9qLm8aCPpqhUUCciraa+bLp45qfWnPYreXUxpa1AV
         8d9SvF8BF9skYToGrbyBSUql+rrcrYN0S5SyJe8+DfAzNfIX2vFGDd9GGYRHINgKHN
         x9/wsmdrqOWNg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 53140A0091;
        Wed,  3 Jul 2019 16:12:55 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 3 Jul 2019 09:12:54 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 3 Jul 2019 09:12:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HCbz62W0SD90lgw0eWLOaeWUqNPRKl575wG2TM8rHs=;
 b=G33F4WMKb/KhpMthlv7VmD/9oMiO/KkiaQmqQO3RVRJMNqe2ZMmojaNveYNnysb/3HOl9UiMKcWROS69UCTL8qzzJ09Ru+d+Hvh26/Be0TeSsggv+QNHh+2H3x3wgW4b8o7wlIarA5CMnIrL6k9AN/B1FlHnBVUx9Z+rjwa42uU=
Received: from BN6PR1201MB0035.namprd12.prod.outlook.com (10.174.238.140) by
 BN6PR1201MB0051.namprd12.prod.outlook.com (10.174.114.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.17; Wed, 3 Jul 2019 16:12:52 +0000
Received: from BN6PR1201MB0035.namprd12.prod.outlook.com
 ([fe80::c4ec:41a0:dfb5:767f]) by BN6PR1201MB0035.namprd12.prod.outlook.com
 ([fe80::c4ec:41a0:dfb5:767f%10]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 16:12:52 +0000
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARC: hide unused function unw_hdr_alloc
Thread-Topic: [PATCH] ARC: hide unused function unw_hdr_alloc
Thread-Index: AQHVMaTXsiWHeSj06keYhFaxN9Sn16a5EQgA
Date:   Wed, 3 Jul 2019 16:12:52 +0000
Message-ID: <7584cf05-e3f9-7027-a08c-87efbfb0f608@synopsys.com>
References: <20190703133940.1493249-1-arnd@arndb.de>
In-Reply-To: <20190703133940.1493249-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
x-originating-ip: [198.182.56.5]
x-clientproxiedby: BY5PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:a03:180::37) To BN6PR1201MB0035.namprd12.prod.outlook.com
 (2603:10b6:405:4d::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vgupta@synopsys.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb45f0df-a691-4a7b-c633-08d6ffd14c7d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR1201MB0051;
x-ms-traffictypediagnostic: BN6PR1201MB0051:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BN6PR1201MB00517F35FC591D14F8A10B8FB6FB0@BN6PR1201MB0051.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(136003)(39860400002)(366004)(199004)(189003)(66066001)(64756008)(66446008)(66476007)(58126008)(5660300002)(229853002)(6486002)(66556008)(54906003)(66946007)(52116002)(65826007)(31696002)(6306002)(73956011)(6512007)(7736002)(316002)(81156014)(4326008)(86362001)(65956001)(65806001)(81166006)(26005)(8676002)(305945005)(64126003)(386003)(6506007)(8936002)(476003)(53546011)(76176011)(53936002)(186003)(36756003)(4744005)(71200400001)(71190400001)(486006)(6436002)(6916009)(99286004)(25786009)(31686004)(446003)(966005)(102836004)(11346002)(2616005)(3846002)(6116002)(14454004)(68736007)(6246003)(478600001)(14444005)(2906002)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR1201MB0051;H:BN6PR1201MB0035.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3zh/duXv5tHB8MMX2s0mv3KoCjMmNbRB6VegnCkIAJ41fly7Sy/8rc19tjv3dhSufVrl00JSVI/9y4tBphOj9c1qOpLypcsnhZ3kyRzOvRF2FH5P6pDbXllYLQTGRi8ZQev8gTJn7959mkAU40G4Lmj43m+xgz+bqKIFCC8cpvQ/EcFugH2u7MqRe7BXclng4pYW/+zHmG8BVaNx9eh6nwlR54VQ5NTvvDPGZ8PFUzDviN59x3SNZqEuXRJbFXjft7xleI3+sxSsKFv37AWcD0ehXOF7rr4bhXlSFCS5+IAMkYowd2O2wcZvJZs7ZNRI9VPxQPZ4MU0zvygsHTGpVgp5jbmdETRGXRCcjQA4jYM/+uvFbUEvVZW7mD2IFFJJNLaGnVBfWzDTx9bdvq6xFsyX0d+2wDO28ag58bJiJ5c=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA708647CF42D248BF5FBACD6EAC489D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cb45f0df-a691-4a7b-c633-08d6ffd14c7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 16:12:52.1737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vgupta@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0051
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gNy8zLzE5IDY6MzkgQU0sIEFybmQgQmVyZ21hbm4gd3JvdGU6DQo+IEFzIGtlcm5lbGNpLm9y
ZyByZXBvcnRzLCANCg0KQ3VyaW91cywgaG93IGFyZSB5b3UgZ2V0dGluZyB0aGVzZSByZXBvcnRz
ID8gSSB3YW50IHRvIHNlZSBhcyB3ZWxsLg0KDQo+IHRoaXMgZnVuY3Rpb24gaXMgbm90IHVzZWQg
aW4NCj4gdmRrX2hzMzhfZGVmY29uZmlnOg0KPiANCj4gYXJjaC9hcmMva2VybmVsL3Vud2luZC5j
OjE4ODoxNDogd2FybmluZzogJ3Vud19oZHJfYWxsb2MnIGRlZmluZWQgYnV0IG5vdCB1c2VkIFst
V3VudXNlZC1mdW5jdGlvbl0NCj4gDQo+IEZpeGVzOiBiYzc5YzlhNzIxNjUgKCJBUkM6IGR3MiB1
bndpbmQ6IFJlaW5zdGFudGUgdW53aW5kaW5nIG91dCBvZiBtb2R1bGVzIikNCj4gTGluazogaHR0
cHM6Ly9rZXJuZWxjaS5vcmcvYnVpbGQvaWQvNWQxY2FlM2Y1OWI1MTQzMDAzNDBjMTMyL2xvZ3Mv
DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6IEFybmQgQmVy
Z21hbm4gPGFybmRAYXJuZGIuZGU+DQoNClRoeCwgZG8geW91IHdhbnQgbWUgdG8gcGljayB0aGlz
IHVwIHZpYSBhcmMgdHJlZS4NCg0KVGh4LA0KLVZpbmVldA0K
