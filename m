Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980616916A7
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 03:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjBJC1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 21:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjBJC07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 21:26:59 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F1136FE7;
        Thu,  9 Feb 2023 18:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fsArWw3hax7gGrjHrh2tUfn2rMHVzbr6sq4sVwA49Y4=;
 b=LnzWjntGStd0xjw1dMc2q5FVF3v/GuMC/ihWk7prUeqjh4nB7S7Q5b1NVuEAWZVRfPuggxAsibjbSsXfNtDvAoxiZYrn4O8d7hSG0StNGzosNDCe3MITDPMgu/Wsaep0auGomQgViSn1B0ktvTGHziHqIF5IHXqKr1NqluJEQo8=
Received: from AM6PR10CA0070.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:80::47)
 by GV2PR08MB7956.eurprd08.prod.outlook.com (2603:10a6:150:a9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 02:26:45 +0000
Received: from AM7EUR03FT040.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:80:cafe::aa) by AM6PR10CA0070.outlook.office365.com
 (2603:10a6:209:80::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19 via Frontend
 Transport; Fri, 10 Feb 2023 02:26:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT040.mail.protection.outlook.com (100.127.140.128) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.19 via Frontend Transport; Fri, 10 Feb 2023 02:26:45 +0000
Received: ("Tessian outbound 43b0faad5a68:v132"); Fri, 10 Feb 2023 02:26:44 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: ecf49cc967716877
X-CR-MTA-TID: 64aa7808
Received: from 0c44468e7332.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 836D8097-64C2-4407-A733-F97798C00BA6.1;
        Fri, 10 Feb 2023 02:26:38 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 0c44468e7332.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 10 Feb 2023 02:26:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtTZlXm8IBbLn7K+Tkfrby1twHai1blTnXDE5UQ/mKqVyxCNgYgwytF499uFPPV9UaGTF6Gh6zP0MU3cqxWPBzU05SnxKNpW5PHxNj74i4NqwHvseP3hrKmqQJtUqHT2JO9Ia7F845sUP2G66PUOI+0GCtLOzmBQqafafa+PWP4ZoRrfBUcl+LyySMzDgSFdZFtA0Gqg0OEvtv2as72D6JAz/15vDKFAUSHma1NF1u7hGAoJxo43mwsvsAjuy2Nffqq/6fHcncv85dsmWEJTiyA7Yo8Y1oXGzwxhG+aWmVtxXoeqtLXyXnBXwEH7dhdtDRewZD2vrPL+soCg+nwa7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fsArWw3hax7gGrjHrh2tUfn2rMHVzbr6sq4sVwA49Y4=;
 b=HmEGMsljPK0QZ01Y9vyUqAe6IwJ9Adu+JYtCmz0FYi+eK3kOb/B3xQ71BfaWdl0SDZQKu4D8j+htIVW1amEclNUGq4NUn2eGpmd7kthgQgZMdF1NHNaJdRD/uj9Wke6MtQgfZ65hx3k5TBIUw67i571C/2KkT8B8ZuV2S+1vw3Pfmh97P8xnq82W+JqeIlBG4AODiXTBw7YrZZ3HM8W3IdNnTHzcerQ25jSl/oEfERhqYTBzz99vSUET9iWzZuux3Y/12s/84VEAPxW0GYkcvddPT+b8zmuipSBXuHwhu7tUyjaa8waKdLC9i/dXpypB+xfjaWdvjY+r3OE8kI0I0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fsArWw3hax7gGrjHrh2tUfn2rMHVzbr6sq4sVwA49Y4=;
 b=LnzWjntGStd0xjw1dMc2q5FVF3v/GuMC/ihWk7prUeqjh4nB7S7Q5b1NVuEAWZVRfPuggxAsibjbSsXfNtDvAoxiZYrn4O8d7hSG0StNGzosNDCe3MITDPMgu/Wsaep0auGomQgViSn1B0ktvTGHziHqIF5IHXqKr1NqluJEQo8=
Received: from DBBPR08MB4538.eurprd08.prod.outlook.com (2603:10a6:10:d2::15)
 by DBAPR08MB5832.eurprd08.prod.outlook.com (2603:10a6:10:1a5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 02:26:30 +0000
Received: from DBBPR08MB4538.eurprd08.prod.outlook.com
 ([fe80::2d8:92a:3c7:2fcd]) by DBBPR08MB4538.eurprd08.prod.outlook.com
 ([fe80::2d8:92a:3c7:2fcd%4]) with mapi id 15.20.6086.017; Fri, 10 Feb 2023
 02:26:30 +0000
From:   Justin He <Justin.He@arm.com>
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     Darren Hart <darren@os.amperecomputing.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Alexandru Elisei <alexandru.elisei@gmail.com>, nd <nd@arm.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: RE: [PATCH v2] arm64: efi: Force the use of SetVirtualAddressMap() on
 eMAG and Altra Max machines
Thread-Topic: [PATCH v2] arm64: efi: Force the use of SetVirtualAddressMap()
 on eMAG and Altra Max machines
Thread-Index: AQHZPB16WuoCttLgRE2E1vPXNQssV67F5ikggADYnoCAAK658A==
Date:   Fri, 10 Feb 2023 02:26:29 +0000
Message-ID: <DBBPR08MB45386333A9AB1A46F1331E94F7DE9@DBBPR08MB4538.eurprd08.prod.outlook.com>
References: <2ab9645789707f31fd37c49435e476d4b5c38a0a.1675901828.git.darren@os.amperecomputing.com>
 <DBBPR08MB4538C586B721C8209B03AEEEF7D99@DBBPR08MB4538.eurprd08.prod.outlook.com>
 <CAMj1kXG8TY9eKJxtSWYPCu_8qs7W3FWwDSZ+teuwhHb1BHUf7g@mail.gmail.com>
In-Reply-To: <CAMj1kXG8TY9eKJxtSWYPCu_8qs7W3FWwDSZ+teuwhHb1BHUf7g@mail.gmail.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic: DBBPR08MB4538:EE_|DBAPR08MB5832:EE_|AM7EUR03FT040:EE_|GV2PR08MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: 6842b4b5-4101-4cc4-ed78-08db0b0e4110
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: ISs3ANjTIrDGJncy0Fxjos9EoDrD6H3k5mzpFc/7YTbeJGe85eZMWcSahnrPv1nrrR9+w+HL3G/jtVF2QR9osmL/EI1R2HjHVGFyMPrg945ymmTbWyzA7La8ohfXURYlxLPWxq2p6X6yKYIwEaCwnyBUCy58fF2iUA0FHMFfd/2SwpP/xKwaSZU+JqEPXbbP0VjBvZPUM10F1wh+g9y2OSGuzXtZE9e1uzJb5ESsdjfNwXL4y6TAVHtx1WY1EhusLztWOekuV7pY3iuxKMP8G5t041CXiVcHWcem8rEGp0pnzt4Xx5ytAXK3FP57GcrU2fjNteH2ppM/Tky/zEa81XRhKRbWmetSHzq9LT4usXLMaTpZF1IDljDd+eSG4s08n+m2/xF7yfwOFbPu2UY5Jyd2Wi5xGUroVvj83Z1KrgbZb1l70sTeNDT7Bfy3VONXB42UH8WOmZ6ujP+6ViDJSxCVXObMFksLZBVnI+6SMwW5QgiWC9/GLwyURZ8UIE80xDNm/QD7ud8wzN/vgGKb7rq7KWMpN78fHkq/LAw4ZO61j7OfI3Uv57gmrK4cLfhSjrwXKIdUehkrmLJ1R61FUKpwq7lAU1iYFHehqQyb6/bzzTRzh0o4jEz2q6j3/Ryv72tFsZsOWIRdzqWLXM+yIuE06kLJmPL8cZWEpMkfT22wuHlqGou9ZhHlaVTlAuQ0wwbVPUh1UVk5T6fOCiVxkA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR08MB4538.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(396003)(346002)(376002)(136003)(451199018)(71200400001)(6506007)(53546011)(7696005)(33656002)(26005)(478600001)(83380400001)(6916009)(4326008)(66556008)(8676002)(66446008)(64756008)(66476007)(76116006)(66946007)(9686003)(54906003)(316002)(186003)(38070700005)(86362001)(41300700001)(55016003)(8936002)(52536014)(5660300002)(2906002)(122000001)(38100700002);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5832
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT040.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 7aadfe33-e6f4-4942-70aa-08db0b0e37f9
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gpynPv03PE2rd6VYL1IGMq7aTMB+tEdoP2WYTBdQA98YPOV4m6oRBxNQPx9UumXnwkU4OZszbbmnfsURi9mBn6JKg0x3wXJf+YMwQwKI0MriIsZF2DkZU5UyzCscfU4STrtxABGfMAuHYkpU4PtmwQNUHSWPBq37kxwdTk5AzY6h2gMwxrKXVZ7XeivfH9/W1nEZ7tCYf8D5ZEWhHJNvHKEKGAbMo3N7VLxy2aqItIHoNM0ur3WGubxBXR3AYb+XV5Q1EZEdpgGFQsi+277HRqK1eukUZ3ADygkYj3+Irk1L7XcI1fm4RvmKy734RjNuAD3TkyBokMWXCTJZ+0VwikXrfE7yHQlhGJN5eQ15CsDyyDWDpL2Ws5gK0BoqF7dQnl8S9hlKqXA6MAgEVUPUKLjQGKRd0sXS1k2wEWtPgiI4w9Zy+KPaLAviiH4KLO5NFPnXvmF3N45c4Jq9z9dpKxUamyP+UDrvQJGcpIxNUNJeQLsVR2Lv7lMPOExRD5/EmYUMWXpFbY+rCrO7JRHTMamooSlaDlnJGS5UN0rlYshVy4yIDMnvtvwc3BhqZfJdZLiM5Yqi1srTUKHM4yeVT/X2N2lATlaxNoj6wBHJHIT3enx3sG7kG26DbovUjKt7WqFsZJT7806algHvv8qQbs4iKzig7D9AtfmP4b6FDrC68JmWH9U1Qz20FMY/kQFkB7b+73cY1A8G4Qb2s2ib0A==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199018)(40470700004)(46966006)(36840700001)(36860700001)(356005)(82310400005)(26005)(82740400003)(53546011)(6506007)(9686003)(186003)(86362001)(478600001)(40480700001)(47076005)(40460700003)(336012)(81166007)(6862004)(83380400001)(8936002)(52536014)(41300700001)(5660300002)(4326008)(2906002)(54906003)(8676002)(7696005)(70206006)(450100002)(55016003)(316002)(70586007)(33656002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 02:26:45.1039
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6842b4b5-4101-4cc4-ed78-08db0b0e4110
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT040.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB7956
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgQXJkLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFyZCBCaWVz
aGV1dmVsIDxhcmRiQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IFRodXJzZGF5LCBGZWJydWFyeSA5LCAy
MDIzIDExOjMxIFBNDQo+IFRvOiBKdXN0aW4gSGUgPEp1c3Rpbi5IZUBhcm0uY29tPg0KPiBDYzog
RGFycmVuIEhhcnQgPGRhcnJlbkBvcy5hbXBlcmVjb21wdXRpbmcuY29tPjsgTEtNTA0KPiA8bGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxp
bnV4LWVmaUB2Z2VyLmtlcm5lbC5vcmc7IEFsZXhhbmRydSBFbGlzZWkgPGFsZXhhbmRydS5lbGlz
ZWlAZ21haWwuY29tPjsgbmQNCj4gPG5kQGFybS5jb20+OyBOYXRoYW4gQ2hhbmNlbGxvciA8bmF0
aGFuQGtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjJdIGFybTY0OiBlZmk6IEZv
cmNlIHRoZSB1c2Ugb2YgU2V0VmlydHVhbEFkZHJlc3NNYXAoKSBvbg0KPiBlTUFHIGFuZCBBbHRy
YSBNYXggbWFjaGluZXMNCj4gDQo+IChjYyBOYXRoYW4sIGFub3RoZXIgaGFwcHkgQW1wZXJlIGN1
c3RvbWVyKQ0KPiANCj4gT24gVGh1LCA5IEZlYiAyMDIzIGF0IDA1OjI2LCBKdXN0aW4gSGUgPEp1
c3Rpbi5IZUBhcm0uY29tPiB3cm90ZToNCj4gPg0KPiA+DQo+ID4NCj4gPiA+IC0tLS0tT3JpZ2lu
YWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBEYXJyZW4gSGFydCA8ZGFycmVuQG9zLmFtcGVy
ZWNvbXB1dGluZy5jb20+DQo+ID4gPiBTZW50OiBUaHVyc2RheSwgRmVicnVhcnkgOSwgMjAyMyA4
OjI4IEFNDQo+ID4gPiBUbzogTEtNTCA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz4NCj4g
PiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1lZmlAdmdlci5rZXJuZWwub3Jn
OyBBbGV4YW5kcnUNCj4gPiA+IEVsaXNlaSA8YWxleGFuZHJ1LmVsaXNlaUBnbWFpbC5jb20+OyBK
dXN0aW4gSGUgPEp1c3Rpbi5IZUBhcm0uY29tPjsNCj4gPiA+IEh1YWNhaSBDaGVuIDxjaGVuaHVh
Y2FpQGtlcm5lbC5vcmc+OyBKYXNvbiBBLiBEb25lbmZlbGQNCj4gPiA+IDxKYXNvbkB6eDJjNC5j
b20+OyBBcmQgQmllc2hldXZlbCA8YXJkYkBrZXJuZWwub3JnPg0KPiA+ID4gU3ViamVjdDogW1BB
VENIIHYyXSBhcm02NDogZWZpOiBGb3JjZSB0aGUgdXNlIG9mDQo+ID4gPiBTZXRWaXJ0dWFsQWRk
cmVzc01hcCgpIG9uIGVNQUcgYW5kIEFsdHJhIE1heCBtYWNoaW5lcw0KPiA+ID4NCj4gPiA+IENv
bW1pdCA1NTBiMzNjZmQ0NDUgKCJhcm02NDogZWZpOiBGb3JjZSB0aGUgdXNlIG9mDQo+ID4gPiBT
ZXRWaXJ0dWFsQWRkcmVzc01hcCgpIG9uIEFsdHJhIG1hY2hpbmVzIikgaWRlbnRpZmllcyB0aGUg
QWx0cmENCj4gPiA+IGZhbWlseSB2aWEgdGhlIGZhbWlseSBmaWVsZCBpbiB0aGUgdHlwZSMxIFNN
QklPUyByZWNvcmQuIGVNQUcgYW5kDQo+ID4gPiBBbHRyYSBNYXggbWFjaGluZXMgYXJlIHNpbWls
YXJseSBhZmZlY3RlZCBidXQgbm90IGRldGVjdGVkIHdpdGggdGhlIHN0cmljdA0KPiBzdHJjbXAg
dGVzdC4NCj4gPiA+DQo+ID4gPiBUaGUgdHlwZTFfZmFtaWx5IHNtYmlvcyBzdHJpbmcgaXMgbm90
IGFuIGVudGlyZWx5IHJlbGlhYmxlIG1lYW5zIG9mDQo+ID4gPiBpZGVudGlmeWluZyBzeXN0ZW1z
IHdpdGggdGhpcyBpc3N1ZSBhcyBPRU1zIGNhbiwgYW5kIGRvLCB1c2UgdGhlaXINCj4gPiA+IG93
biBzdHJpbmdzIGZvciB0aGVzZSBmaWVsZHMuIEhvd2V2ZXIsIHVudGlsIHdlIGhhdmUgYSBiZXR0
ZXINCj4gPiA+IHNvbHV0aW9uLCBjYXB0dXJlIHRoZSBidWxrIG9mIHRoZXNlIHN5c3RlbXMgYnkg
YWRkaW5nIHN0cmNtcCBtYXRjaGluZyBmb3INCj4gImVNQUciDQo+ID4gPiBhbmQgIkFsdHJhIE1h
eCIuDQo+ID4gPg0KPiA+ID4gRml4ZXM6IDU1MGIzM2NmZDQ0NSAoImFybTY0OiBlZmk6IEZvcmNl
IHRoZSB1c2Ugb2YNCj4gPiA+IFNldFZpcnR1YWxBZGRyZXNzTWFwKCkgb24gQWx0cmEgbWFjaGlu
ZXMiKQ0KPiA+ID4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiAjIDYuMS54DQo+ID4gPiBD
YzogPGxpbnV4LWVmaUB2Z2VyLmtlcm5lbC5vcmc+DQo+ID4gPiBDYzogQWxleGFuZHJ1IEVsaXNl
aSA8YWxleGFuZHJ1LmVsaXNlaUBnbWFpbC5jb20+DQo+ID4gPiBDYzogSnVzdGluIEhlIDxKdXN0
aW4uSGVAYXJtLmNvbT4NCj4gPiA+IENjOiBIdWFjYWkgQ2hlbiA8Y2hlbmh1YWNhaUBrZXJuZWwu
b3JnPg0KPiA+ID4gQ2M6ICJKYXNvbiBBLiBEb25lbmZlbGQiIDxKYXNvbkB6eDJjNC5jb20+DQo+
ID4gPiBDYzogQXJkIEJpZXNoZXV2ZWwgPGFyZGJAa2VybmVsLm9yZz4NCj4gPiA+IFNpZ25lZC1v
ZmYtYnk6IERhcnJlbiBIYXJ0IDxkYXJyZW5Ab3MuYW1wZXJlY29tcHV0aW5nLmNvbT4NCj4gPiBU
ZXN0ZWQtYnk6IGp1c3Rpbi5oZUBhcm0uY29tDQo+ID4gPiAtLS0NCj4gPiA+IFYxIC0+IFYyOiBp
bmNsdWRlIGVNQUcNCj4gPiA+DQo+ID4gPiAgZHJpdmVycy9maXJtd2FyZS9lZmkvbGlic3R1Yi9h
cm02NC5jIHwgOSArKysrKystLS0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25z
KCspLCAzIGRlbGV0aW9ucygtKQ0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2Zp
cm13YXJlL2VmaS9saWJzdHViL2FybTY0LmMNCj4gPiA+IGIvZHJpdmVycy9maXJtd2FyZS9lZmkv
bGlic3R1Yi9hcm02NC5jDQo+ID4gPiBpbmRleCBmZjJkMThjNDJlZTcuLjQ1MDE2NTJlMTFhYiAx
MDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvZmlybXdhcmUvZWZpL2xpYnN0dWIvYXJtNjQuYw0K
PiA+ID4gKysrIGIvZHJpdmVycy9maXJtd2FyZS9lZmkvbGlic3R1Yi9hcm02NC5jDQo+ID4gPiBA
QCAtMTksMTAgKzE5LDEzIEBAIHN0YXRpYyBib29sIHN5c3RlbV9uZWVkc192YW1hcCh2b2lkKQ0K
PiA+ID4gICAgICAgY29uc3QgdTggKnR5cGUxX2ZhbWlseSA9IGVmaV9nZXRfc21iaW9zX3N0cmlu
ZygxLCBmYW1pbHkpOw0KPiA+ID4NCj4gPiA+ICAgICAgIC8qDQo+ID4gPiAtICAgICAgKiBBbXBl
cmUgQWx0cmEgbWFjaGluZXMgY3Jhc2ggaW4gU2V0VGltZSgpIGlmDQo+IFNldFZpcnR1YWxBZGRy
ZXNzTWFwKCkNCj4gPiA+IC0gICAgICAqIGhhcyBub3QgYmVlbiBjYWxsZWQgcHJpb3IuDQo+ID4g
PiArICAgICAgKiBBbXBlcmUgZU1BRywgQWx0cmEsIGFuZCBBbHRyYSBNYXggbWFjaGluZXMgY3Jh
c2ggaW4gU2V0VGltZSgpDQo+IGlmDQo+ID4gPiArICAgICAgKiBTZXRWaXJ0dWFsQWRkcmVzc01h
cCgpIGhhcyBub3QgYmVlbiBjYWxsZWQgcHJpb3IuDQo+ID4gPiAgICAgICAgKi8NCj4gPiA+IC0g
ICAgIGlmICghdHlwZTFfZmFtaWx5IHx8IHN0cmNtcCh0eXBlMV9mYW1pbHksICJBbHRyYSIpKQ0K
PiA+ID4gKyAgICAgaWYgKCF0eXBlMV9mYW1pbHkgfHwgKA0KPiA+ID4gKyAgICAgICAgIHN0cmNt
cCh0eXBlMV9mYW1pbHksICJlTUFHIikgJiYNCj4gPiA+ICsgICAgICAgICBzdHJjbXAodHlwZTFf
ZmFtaWx5LCAiQWx0cmEiKSAmJg0KPiA+ID4gKyAgICAgICAgIHN0cmNtcCh0eXBlMV9mYW1pbHks
ICJBbHRyYSBNYXgiKSkpDQo+ID4gSW4gdGVybXMgb2YgcmVzb2x2aW5nIHRoZSBib290IGhhbmcg
aXNzdWUsIGl0IGxvb2tzIGdvb2QgdG8gbWUuIEFuZA0KPiA+IEkndmUgdmVyaWZpZWQgdGhlICJl
TUFHIiBwYXJ0IGNoZWNrLg0KPiA+IFNvIHBsZWFzZSBmZWVsIGZyZWUgdG8gYWRkOg0KPiA+IFRl
c3RlZC1ieTogSnVzdGluIEhlIDxqdXN0aW4uaGVAYXJtLmNvbT4NCj4gPg0KPiANCj4gVGhhbmtz
LiBJJ3ZlIHF1ZXVlZCB0aGlzIHVwIG5vdy4NCj4gDQo+ID4gQnV0IEkgaGF2ZSBzb21lIG90aGVy
IGNvbmNlcm5zOg0KPiA+IDEuIE9uIGFuIEFsdHJhIHNlcnZlciwgdGhlIHR5cGUxX2ZhbWlseSBy
ZXR1cm5zICJTZXJ2ZXIiLiBJIGRvbid0IGtub3cNCj4gPiB3aGV0aGVyIGl0IGlzIGEgc21iaW9z
IG9yIHNlcnZlciBmaXJtd2FyZSBidWcuDQo+IA0KPiBUaGlzIGlzIG5vdCByZWFsbHkgYSBidWcu
IE9FTXMgYXJlIGZyZWUgdG8gcHV0IHdoYXRldmVyIHRoZXkgd2FudCBpbnRvIHRob3NlDQo+IGZp
ZWxkcywgYWx0aG91Z2ggdGhhdCBpcyBhIGdyZWF0IGV4YW1wbGUgb2YgYSBzbG9wcHkgdmVuZG9y
IHRoYXQganVzdCBwdXRzDQo+IHJhbmRvbSBqdW5rIGluIHRoZXJlLg0KPiANCj4gV2UgY291bGQg
cGx1bWIgaW4gdGhlIHR5cGUgNCBzbWJpb3MgcmVjb3JkIHRvbywgYW5kIGNoZWNrIHRoZSB2ZXJz
aW9uIGZvcg0KPiAqQWx0cmEqIC0gaG93ZXZlciwgaXQgd291bGQgYmUgbmljZSB0byBnZXQgYW4g
aWRlYSBvZiBob3cgbWFueSBtb3JlIHdlIHdpbGwNCj4gZW5kIHVwIG5lZWRpbmcgdG8gaGFuZGxl
IGhlcmUuDQo+IA0KPiBBbHNvLCBpcyBhbnlvbmUgbG9va2luZyB0byBnZXQgdGhpcyBmaXhlZD8g
VGhlcmUgaXMgQWx0cmEgY29kZSBpbiB0aGUgcHVibGljIEVESzINCj4gcmVwbywgYnV0IGl0IGlz
IHZlcnkgaGFyZCB0byBnZXQgc29tZW9uZSB0byBjYXJlIGFib3V0IHRoZXNlIHRoaW5ncywgYW5k
IGZpeA0KPiB0aGVpciBmaXJtd2FyZS4NCj4gDQo+IA0KPiANCj4gDQo+ID4gMi4gT24gYW4gZU1B
RyBzZXJ2ZXIsIEkgb25jZSBzdWNjZXNzZnVsbHkgcnVuIGVmaWJvb3RtZ3IgLXQgMTAgdG8gY2Fs
bA0KPiA+IHRoZSBTZXRfdmFyaWFibGUgcnRzLCBidXQgY3VycmVudGx5IEkgYWx3YXlzIG1ldCB0
aGUgZXJyb3IsIGV2ZW4gd2l0aCBhYm92ZQ0KPiBwYXRjaDoNCj4gPiAjIGVmaWJvb3RtZ3IgLXQg
OTsgZWZpYm9vdG1nciAtdCA1Ow0KPiA+IENvdWxkIG5vdCBzZXQgVGltZW91dDogSW5wdXQvb3V0
cHV0IGVycm9yIENvdWxkIG5vdCBzZXQgVGltZW91dDoNCj4gPiBJbnB1dC9vdXRwdXQgZXJyb3IN
Cj4gPg0KPiANCj4gRGlkIHRoaXMgd29yayBiZWZvcmU/IENhbiB5b3UgYmlzZWN0Pw0KWWVzLCBp
dCB3b3JrZWQgYmVmb3JlLCBhcyB0aGUgbG9nIEkgYXR0YWNoZWQgaW4gcHJldmlvdXMgdGhyZWFk
Lg0KVGhhdCBrZXJuZWwgaXMgdjUuMTkrLg0KQnV0IHZlcnkgc3RyYW5nZSwgbm93IEkgdHJpZWQg
ZGlmZmVyZW50IGtlcm5lbCAodjYueCwgdjUuMTksdjQuMTkpLA0KSXQgZGlkbid0IHdvcmsgbm93
Lg0KDQpCaXNlY3QgZG9lc27igJl0IGhlbHAgaW4gdGhpcyBjYXNlLg0KDQotLQ0KQ2hlZXJzLA0K
SnVzdGluIChKaWEgSGUpDQoNCg==
