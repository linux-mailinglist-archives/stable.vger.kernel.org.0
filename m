Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B1732A3B
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 10:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfFCIBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 04:01:34 -0400
Received: from mail-eopbgr770088.outbound.protection.outlook.com ([40.107.77.88]:26336
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbfFCIBe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 04:01:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hlzuwHA35du3I/10HaoYYycsM9jUMSsluoRrq7888GA=;
 b=GxOtdvSfLRKeElhRMqjqigmM0feX4NQvkSX3himK5IYlod37euYabVamHj3e6AZiX/L4MTTfr0jvOrIuobiBX3sjiNEcPNQsXjm0wzHtpKsEPx8K8p9QOnjhmqdXVuXXQZm7bu0NLqNHHKYp6thjNn6S9BcTaGclp+uuwmO2FfM=
Received: from BN8PR10MB3540.namprd10.prod.outlook.com (20.179.78.205) by
 BN8PR10MB3603.namprd10.prod.outlook.com (20.179.79.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 08:01:31 +0000
Received: from BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::a460:e299:c4c:4ba8]) by BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::a460:e299:c4c:4ba8%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 08:01:31 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: "tipc: fix modprobe tipc failed after switch order of device
 registration" broke firefox
Thread-Topic: "tipc: fix modprobe tipc failed after switch order of device
 registration" broke firefox
Thread-Index: AQHVGeKNKp1Lkiq9lkmy5ArDCci9zw==
Date:   Mon, 3 Jun 2019 08:01:31 +0000
Message-ID: <1b1dba03a69d70553827a972fa7058562dcd13be.camel@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Joakim.Tjernlund@infinera.com; 
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebb240dc-f16e-40f5-f132-08d6e7f9b099
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR10MB3603;
x-ms-traffictypediagnostic: BN8PR10MB3603:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <BN8PR10MB3603619BD200E45948F16D8EF4140@BN8PR10MB3603.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:207;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(346002)(136003)(376002)(396003)(366004)(39860400002)(199004)(189003)(3846002)(6116002)(25786009)(2351001)(68736007)(8676002)(81156014)(305945005)(36756003)(8936002)(81166006)(7736002)(1730700003)(6916009)(99286004)(66066001)(86362001)(102836004)(6506007)(186003)(26005)(2501003)(476003)(316002)(478600001)(486006)(2616005)(2906002)(72206003)(966005)(6306002)(5640700003)(6436002)(6486002)(53936002)(118296001)(6512007)(14454004)(256004)(71190400001)(71200400001)(66476007)(66446008)(91956017)(5660300002)(66946007)(73956011)(76116006)(66556008)(64756008)(4744005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR10MB3603;H:BN8PR10MB3540.namprd10.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: infinera.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +wxapg87UyA4Vnm6EJwvXh9dSZb710RhsCcS20Zt7BE55tmGV67KZWKiY+AX3e2CWoOq1/jmhSJ9VlHXWOXnzjo0NlQek6zG/Fzo76YX7X2wpFAM5RXtJcQL+lPQVP5uq7MHTzpAxaG8jkOypOlL6qP+1TtohrlkpFF1rNUc3aO1X7Rcg7v/bWy28C3piU6o9gkkSH/vhZ9ofWwJXkDbX5PxYm4ynDq00c1LAwoqKclsr1aQd3cOISP62bCc1z0aLtvWszYiNbMfkRjdE/EVeYyAmPgZ7fihxfPgOky4DcrzKn/qOvnaUdtYdC5jy48PjWHeZTNf/+u87hrFniqwlVn8v4cPUhhTTIxjYXReMWRmtueGk8+HuTpS1o/slXU+lqK+HsTVyKidax9Ku3yNbhnS+CAyxkSMKJSPWjX/56A=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4C5474A517F9241B31BD3B2F6F624C4@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb240dc-f16e-40f5-f132-08d6e7f9b099
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 08:01:31.3406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jocke@infinera.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3603
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Q29tbWl0IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3N0
YWJsZS9saW51eC5naXQvY29tbWl0Lz9oPWxpbnV4LTQuMTQueSZpZD1hZjRhZjY4ZGYzZTQ4ZjQ5
YTAzYzIyMTNiOGU0MzhhYzQ3MTQzMTM1IA0KYnJva2Ugc3RhYmxlIDQuMTQvNC4xOQ0KVXBzdHJl
YW0gcmV2ZXJ0ZWQgdGhhdCBjb21taXQgYW5kIHJlcGxhY2VkIGl0IHdpdGggYSBuZXcgdmVyc2lv
bjoNCmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3N0YWJs
ZS9saW51eC5naXQvY29tbWl0L25ldC90aXBjL2NvcmUuYz9pZD01MjZmNWI4NTFhOTY1NjY4MDNl
ZTRiZWU2MGQwYTM0ZGY1NmM3N2Y4DQoNCiBKb2NrZQ0K
