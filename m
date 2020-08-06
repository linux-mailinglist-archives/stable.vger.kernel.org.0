Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EEA23D71A
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 08:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgHFG6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 02:58:51 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:46260 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728294AbgHFG6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 02:58:49 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 37DA4408B8;
        Thu,  6 Aug 2020 06:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1596697129; bh=oa2bUhT+pO6WfaC41ZWwlYRCku+eOUaqjDbmColiyJs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=ZKrb1gK/iHM6EHKUTAB8GQHaztEPuAaGyIv2yDli8zxNgHJCuhAhOxqESrNwnPJAe
         LJbyZvJk3ac0lUgHr6rwn53LkkZqDrDs9PDcZgzeHZVJYgYeP1Wa51M86lDKhBAV0k
         +5270nMu9LmzOcqxNdN49pkY8XxKq7NwA6rbXZVN/EBLL7xenydGTVw/lUE37flINj
         BZXRrHbk8c933P/m0P+lQLGAVK17rYWbK2zd2MmwaB6N6eofx2GMgZNYpsNudrEtvM
         0ciCGQu/cm0ujDJ0ePclLxwgKO1ZbuLHoxM1PYe3xc0BZk8Qvd3viDieTI3Akx7TG5
         M/KEjlPODdQ8A==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C43B9A0069;
        Thu,  6 Aug 2020 06:58:48 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 205044006C;
        Thu,  6 Aug 2020 06:58:48 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="ig1AQ4PN";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMyEm/I1HCfibOtB3sSPBYhh+It+c3gaUwKn0ei3OwI5rYda29NoKwlfPlk3bs06sBdpAjXvguMBAyfbB05NWpKf5AZDM2PdnCJftcx2JYd74a2iMYGJYg3J43eJUHtZblQkljX4xlGMVQPttq3OZCE4+8NZtGcPNlVneM8YY/EnjUF+bbtP2hpfxYjHaxYvg6a7RfQAxcGQwbsD9btCgm9j4uT9eyUiotnK+z6DN22QWXT99Kxy+UvbxR7r4nJyCp4UA2J+eV229iwmRUfv3AfPmpgxkwiMrSZOcukXVRvwpH/YqrZSwLV08X/pOb2vwNXpyslaaCcNH9eTeQ+Qgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oa2bUhT+pO6WfaC41ZWwlYRCku+eOUaqjDbmColiyJs=;
 b=hHoN7jaoamh/RR+BbWLOZPC6aQW2ZZsktfI8JSOpKdpTbVnnpUADAbV6iH7TyVLc++CS8wMC6O1YZZLALnUQL1sPe5qB2vkgim79JVOk14XUt4T/Z/CEvX13XuR00Wb76jYBnf+yEG5aaR7SeGbuhUz0zfgz+nvj0INSxi624McHthqa+8rXPFR+LUDBLB1WuamLtySm+h8tWJRwEoBzNPK0hy/7gqJwJ0wd1rciTfweSCYPsiRO/+8prUbMQOQb5cmTDvh4AIsi5NQ4qWldU+sNzFwwpjjDiw/hUM5NM1zFDmUeemN6bZgswpud8IjeE4xkJYhkJ/iPvFJmVCyPFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oa2bUhT+pO6WfaC41ZWwlYRCku+eOUaqjDbmColiyJs=;
 b=ig1AQ4PNUkgQUm/D0TG/3fDGR81PzhwP1M7G4gbjn4DkSAdfc/tCzC/u82aIDb7WLXik7wsqLix2HU1LmQ9Dxl8v21bKKummStlJVLlUGi8AdpPM8kfCuq9YXdPJL7ikBIPBkgMwyJ74DtOOl25MzkYg5IHhGDbrAK5WOYxJ6fQ=
Received: from BYAPR12MB2917.namprd12.prod.outlook.com (2603:10b6:a03:130::14)
 by BYAPR12MB3382.namprd12.prod.outlook.com (2603:10b6:a03:a9::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Thu, 6 Aug
 2020 06:58:46 +0000
Received: from BYAPR12MB2917.namprd12.prod.outlook.com
 ([fe80::3844:ed8:654d:7456]) by BYAPR12MB2917.namprd12.prod.outlook.com
 ([fe80::3844:ed8:654d:7456%5]) with mapi id 15.20.3239.022; Thu, 6 Aug 2020
 06:58:46 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/7] usb: dwc3: gadget: Don't setup more than requested
Thread-Topic: [PATCH 1/7] usb: dwc3: gadget: Don't setup more than requested
Thread-Index: AQHWa4rMWgv9QVHoSE6zaFNEKh1H46kqpvYA
Date:   Thu, 6 Aug 2020 06:58:46 +0000
Message-ID: <3c07fd4d-acb9-d14d-4566-5b51054c8812@synopsys.com>
References: <cover.1596674377.git.thinhn@synopsys.com>
 <a8718dffe7deb439d71d36c7b207ed84a7ed45a4.1596674377.git.thinhn@synopsys.com>
In-Reply-To: <a8718dffe7deb439d71d36c7b207ed84a7ed45a4.1596674377.git.thinhn@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [149.117.7.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f20d38b6-7a79-4664-3c32-08d839d62a18
x-ms-traffictypediagnostic: BYAPR12MB3382:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB338256BE392F7A5ECDED2167AA480@BYAPR12MB3382.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rVynZBjnl5qVwIDDMQPRRHLBYenIJSkvthFugU85dp7iECZjIUpGuNK6v9vwAXPePv0xdz+bCvn9Ol1ypmXU2JZymBQ2pONyeGMzB/bF6b+8uKuxuWyn336c83yA85+SOK7Kthj8QZIRPdiyE00YbwHnxfpwmbhLcp5THLeI6Z6rC5F6l8uCVqE1FSs/hpJjf6cBt8w0L9Kt7ixaU5KbO+waDxRlksOXCpUH71QUG4a10rUnkz2ikHy8L8/imQcgUuxYRFCXhR0++LKtlJXsPE/w7tV6kyVKD27kppl8zVTQZ6QjBOHV+WD17LqTwiBGqEKzin0jOWC38nHVeSQ9g+6/pvA347etsyFV8Na56S31xiPPX83xkltxeLAZYCGy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2917.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(39860400002)(396003)(136003)(366004)(8936002)(31686004)(71200400001)(83380400001)(76116006)(26005)(36756003)(478600001)(5660300002)(86362001)(186003)(110136005)(31696002)(2906002)(8676002)(6512007)(2616005)(66476007)(6486002)(66446008)(64756008)(316002)(66556008)(6506007)(4326008)(4744005)(54906003)(66946007)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: qqLPyVScNRx8vyvpVknSYrcKdpEHqfuWsZHt2lrd83IGBFHLsmGWfgHo5//nGFfnnttzwTN0cF6aBQ2XHRlZXhWlT4F5hj/YMA0jz4Bg6Z4OYQzMI/gQW43KvVPENIdPQHXJ+crQ65essQdluxPTEOPkmCJ4Xjm5rkGP4/vGg2+9kQAx/p10Tyf3Js/VRekBj1Uw6mACXBnrGgLi6KPyQmHpmgakP1oELMAM+Lkhgcyv8DNWfn796EKNnqDpTXFMV+sPKTuPlMu9PKrhbcUUcRTa5XggAGxHJU3JEty9/P11BpLvAF5+UHaqUoBWoN/NDxqGLK8wYUu+XP4JKmxA86YZuspxsj4FpMuh3T+nYWztiwrxmowGsgq5Trp8AIESfAr0Mc41xxxfzKr+2RRX09/VBDAXr+n72XTisfdYC/VS4oR7Vhd5NOofCFeXV4n8BxyYFXTsm06aBB9KrOwg043/d/JpkHfTVOyPPgSvPeQezM1kg7mXjlPslEjzcqnKjVeGKMzCS4Jdowp8BFcMi4pRNcmgaOe4HGh+ULIHuHtMuky1UC7SSHntoOI7kGlrPMekk2Oi9a7jA/kpObKcN+m+HeeLkdfNcQdu+NSVwHWRPtlZJa33qKaZY/luAgqObh6oAIlN/1Nv423GnB8Ejw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <52A34638A8FB3C4BAD2B62F30DEDDDCA@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2917.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f20d38b6-7a79-4664-3c32-08d839d62a18
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2020 06:58:46.3861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mnBeN3FkVT9qj0HqQRXzpAdd7V2AKDz222CVL3k6ItKUjhzVKT81Hg1ENgVFV5uKCQtrYT/IRnkIg5ABI2ifiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3382
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhpbmggTmd1eWVuIHdyb3RlOg0KPiBUaGUgU0cgbGlzdCBtYXkgYmUgc2V0IHVwIHdpdGggZW50
cnkgc2l6ZSBtb3JlIHRoYW4gdGhlIHJlcXVlc3RlZA0KPiBsZW5ndGguIENoZWNrIHRoZSB1c2Jf
cmVxdWVzdC0+bGVuZ3RoIGFuZCBtYWtlIHN1cmUgdGhhdCB3ZSBkb24ndCBzZXR1cA0KPiB0aGUg
VFJCcyB0byBzZW5kL3JlY2VpdmUgbW9yZSB0aGFuIHJlcXVlc3RlZC4gVGhpcyBjYXNlIG1heSBv
Y2N1ciB3aGVuDQo+IHRoZSBTRyBlbnRyeSBpcyBhbGxvY2F0ZWQgdXAgdG8gYSBjZXJ0YWluIG1p
bmltdW0gc2l6ZSwgYnV0IHRoZSByZXF1ZXN0DQo+IGxlbmd0aCBpcyBsZXNzIHRoYW4gdGhhdC4g
SXQgY2FuIGFsc28gb2NjdXIgd2hlbiB0aGUgcmVxdWVzdCBpcyByZXVzZWQNCj4gZm9yIGEgZGlm
ZmVyZW50IHJlcXVlc3QgbGVuZ3RoLg0KPg0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0K
PiBGaXhlczogYTMxZTYzYjYwOGZmICgidXNiOiBkd2MzOiBnYWRnZXQ6IENvcnJlY3QgaGFuZGxp
bmcgb2Ygc2NhdHRlcmdhdGhlciBsaXN0cyIpDQo+IFNpZ25lZC1vZmYtYnk6IFRoaW5oIE5ndXll
biA8dGhpbmhuQHN5bm9wc3lzLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3VzYi9kd2MzL2dhZGdl
dC5jIHwgNDEgKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tDQo+ICAxIGZp
bGUgY2hhbmdlZCwgMjcgaW5zZXJ0aW9ucygrKSwgMTQgZGVsZXRpb25zKC0pDQo+DQo+DQoNCkdv
dCBhIGxpdHRsZSB0cmlnZ2VyIGhhcHB5IHdpdGggdGhpcyBwYXRjaC4gVG9vIG1hbnkgb2J2aW91
cyBpc3N1ZXMuDQpQbGVhc2UgaWdub3JlIHRoaXMgcGF0Y2ggZm9yIG5vdy4gV2lsbCByZXZpc2Ug
YW5kIHJlc3VibWl0Lg0KDQpUaGFua3MsDQpUaGluaA0K
