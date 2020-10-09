Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F57F2887D1
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 13:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388085AbgJIL26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 07:28:58 -0400
Received: from mail-eopbgr30107.outbound.protection.outlook.com ([40.107.3.107]:40832
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729986AbgJIL26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Oct 2020 07:28:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nl7rAz2oGT/nN5TIRHmQyyNclItQCy4ujvuu4xsQgXNx44eA+6zAyqGqWxS3MxhxlUcYUrnz7/S8wtAuE2Z7uzeu7ELdx2zHMaPR8vkamp2sDsUaEn8jV1FV/nCKiONI7BBYfiLRW6SNrF1GtqjkxVmpHaqc+bhSQsQPdxku73Mz5IXCkpY+U35g6CKElDi7gnaF1zxYxCwCwGFWTWwmGCVV8CfqoiQXe/k81zcc0RIEIVW6I2ao/IzlfunhLSPg8R2hldL0MxOKZZ3XUIhIWSelWaBEr7IkmNIOX0LIGEtVbqbB0sOllVQRIoWVu5ibC7diKdTqfagL14T/8vkLOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+55ybRl8FO1fPtVwKshA7kwUPv+x3gBMx2JtvV9YYVo=;
 b=nuLNmJBCdQNMfgiTVTkDzbumhGe5PPcd9PqEY5GkKIs2PPaWvmbuO85WgVTHy7lLQxGsJXPi6CSSFzHvxyeSw/sAaDjqwBPSFLJsj6xgwfyvOOE3kBQuObqRkSQEh2gXBVO7bMyosnb04Y7uFXPetlQ50YvvWQihdUjTmB1dYFrTMTokmb08OL3ayE8swpTpK5OiJnzSNL5LOojGE1x6oV7wDQFnw8wDzGfSG7nByX0nKRelwFlP3nPN84M+uHJJZo7V77ihHLRgyU+pzuWI6sZEjfKu/C4+Y13QyxUlnv7EsQZZhpU+E+UV099y/q3pVCJirlCoLHiWJzKz/Q8yXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+55ybRl8FO1fPtVwKshA7kwUPv+x3gBMx2JtvV9YYVo=;
 b=bajlJWyfM7jBPeRQ4oWlUY/k9GCK3r2s6y2KMINA4uY7OtQD8zN8uvpmCUiX0XfpziWqziwGci8zpV0twyq+DDzfkyX7FgxNHmzC8QKsCR8/ibaAoI9udL44rGniVrwtfc1WTkDNrasdLIkvxVxJvjrM5zXf5ii31awtZjb3sUk=
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com (2603:10a6:7:2c::17) by
 HE1PR07MB3100.eurprd07.prod.outlook.com (2603:10a6:7:31::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.11; Fri, 9 Oct 2020 11:28:09 +0000
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::eca3:4085:434:e74]) by HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::eca3:4085:434:e74%6]) with mapi id 15.20.3455.023; Fri, 9 Oct 2020
 11:28:09 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: LTS couple perf test and perf top fixes
Thread-Topic: LTS couple perf test and perf top fixes
Thread-Index: AQHWni9DJjv3tFLW4UqXV6LpqZfhgw==
Date:   Fri, 9 Oct 2020 11:28:09 +0000
Message-ID: <f471ab5f93cd97af4eddebbc78d047289cc55888.camel@nokia.com>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-1.fc32) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
x-originating-ip: [131.228.2.18]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 37727927-421c-4615-4a57-08d86c466669
x-ms-traffictypediagnostic: HE1PR07MB3100:
x-microsoft-antispam-prvs: <HE1PR07MB3100BF0BEA28EBFEA68AD24DB4080@HE1PR07MB3100.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:234;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NYmwsXTI/AE84gCEyCMUoqgMojJyt6QpkokISuwbrQJbE1P+q5dCabXrBYab0P7dLZiSTlo8ZvtBob974vEC3BTnAd/Ctl0UFlF+m0S46N2FxJB1KUwJOxGoPKUJLJF6X6cRdMUsTNpfRPQPYekbjmlNRlsyaK5aSyqoOUt4gky4WKChFRq5Qridu0Y/JbAGYscB6g+LChdeAJhXw6K+jZkNrPirjgxrpcFF4cy2f25OHYwOewOT35WAra+C8TqTGW45mMauALG6ng6k+FD68OooU3tqcTCw/ckvE+JkoJI/1iXpUQCIzWpdxd8gaTfo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR07MB3450.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(6512007)(8936002)(110136005)(5660300002)(2906002)(6506007)(186003)(6486002)(316002)(8676002)(4744005)(478600001)(2616005)(71200400001)(86362001)(4326008)(66446008)(64756008)(66556008)(66476007)(66946007)(76116006)(91956017)(26005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ICufSHg5+REgIpSCDfHbL6/h1sG/AviLdzbE1AV1lCbA2hlh34ZuF3wbsJ50y+0BOdv9n6dl1XAi1beyy06hfl9td3amE8aKmHkfkN3FHzHQqepMqHwvwUYeEzWQ1N6vv3KCPvhhr37h7gGGGRe3rKQBSDQbohotoai1xL0qp59OK2hggdiOZCbFLmoDbP1xrK5dUjjR2ztoPIkAknep17niRL6ZvpTbYdHcBcIDGLM8RXblhvIEjoUoa+Fzf3N2oTymJjsBVSsLtSpCK3uIQBM8GyeSS8oCDLjnbfP+XtSaAxZ2LSieH5ATVl7JYjzul91cjfifpMP2VQXVy4zTa1ZJvW/nRV4+YSgW0Ud5D/siztMFiuAscxzZPsTcEJdP7ib7rr5Yu4x4loNqpZvsRB8EMF2We211KmK9bmolM+jNxr9fsI6jeWuOu6s27/6Af1eW8ik1sfr4AkCzDxSNFKMRtvK+QfbdDZcswq0EtvDChoRODOBOYY73QtqEMQ9b9w6hWcbPly5WVIX2VxxYeLFt8UCkQyYCkWzwOpYwxP7uaOzGJY8zHlP+rjArxZCqWVhWh3vvt5WxaE0tSbWxjPFqnCLgp3F/cmVYFsuY6aa0njF9ux3/Dwd5cGEUQbSN/rAGxR61AIMI8xstDeEFNw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9ED17A6BE8CA514D9A38DC387E534D42@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR07MB3450.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37727927-421c-4615-4a57-08d86c466669
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 11:28:09.3082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 64CzusExGDF0VQKz76cmRl/8DbVPBTgXr9qAYmHGdVZn0YkZrLkE+tRZOmXkU4oFCyedRiCsEXbMKV6XhSsGDXeQAMcYJr+7rJW5/795Q9c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR07MB3100
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywgU2FzaGEsDQoNCkNhbiB5b3UgcGljayB0aGlzIHRvIDUuNDoNCg0KY29tbWl0IGRi
ZDY2MGU2YjI4ODRiODY0ZDI2NDJkOTMwYTE2M2QzYmNlYmU0YmUNCkF1dGhvcjogVG9tbWkgUmFu
dGFsYSA8dG9tbWkudC5yYW50YWxhQG5va2lhLmNvbT4NCkRhdGU6ICAgVGh1IEFwciAyMyAxNDo1
Mzo0MCAyMDIwICswMzAwDQoNCiAgICBwZXJmIHRlc3Qgc2Vzc2lvbiB0b3BvbG9neTogRml4IGRh
dGEgcGF0aA0KDQoNCkFuZCB0aGlzIHRvIDUuNCBhbmQgb2xkZXIgTFRTIHRyZWVzIHRvbzoNCg0K
Y29tbWl0IDI5YjRmNWYxODg1NzFjMTEyNzEzYzM1Y2M4N2VlZmI0NmVmZWU2MTINCkF1dGhvcjog
VG9tbWkgUmFudGFsYSA8dG9tbWkudC5yYW50YWxhQG5va2lhLmNvbT4NCkRhdGU6ICAgVGh1IE1h
ciA1IDEwOjM3OjEyIDIwMjAgKzAyMDANCg0KICAgIHBlcmYgdG9wOiBGaXggc3RkaW8gaW50ZXJm
YWNlIGlucHV0IGhhbmRsaW5nIHdpdGggZ2xpYmMgMi4yOCsNCg0KDQpUaGFua3MhDQotVG9tbWkN
Cg0K
