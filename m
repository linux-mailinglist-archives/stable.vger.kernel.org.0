Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC295210D1
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 11:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbiEJJae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 05:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238733AbiEJJad (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 05:30:33 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AF9210100
        for <stable@vger.kernel.org>; Tue, 10 May 2022 02:26:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=acCA4bYfR98BB/afJGsgMuN+cYf6QH5djdCe/CdSxd+k7ONUc3RDxVgBxGM/txc+HdXX8PoCkoXf0d59BT4IbsADOLXR1Sdm8sjBmI0zfGmZuZ5N3HIZAICOr70TvCt0kwD6zJ4IDRyWcuiW8ddTnHjc/rppwzNrKj9VMcSpCyH2LCvxAsMCTG9ifkiZ72htx6fY8TIVQgSBX2oKwa21MBfPqDVymJx3DpI53WzDvJlDsewtl7CXZ19m3woDgcIDhHk7PghztatLox16yWZ6abEJw4wwLeQ7ak3mN9l1zHv8BBWSCo2Yfr9ICZMPIZdolBgCUqCWCj8/ZqIW0DduJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=It7f3srp0f3J4DXENu593PnoLi4LaimAiYF37w0gGi4=;
 b=RCLGax1EyD8TZYMhKhmKHJJk0vt+lNhLRR1psVsYT8QbbXfWIsVmpCv6NvYHsfgc3FhB6ADfg0hvKFSsulrvE/e/TCbrY0k6ahNWk/6onlZAv31IVhamFBSEzebeiuZPM9nypf+aDt+n/AjICd7r4K+zyAQfazS2hwKo+pYedOHF7uwsuZBx9amegKDbcSY0g2VtgrnEfT8UHs2MLvQNBljAkI1uGzB4iw03GEShxgB7uiyIi7W5GwseghoDXprymzh9dsi+fjqXb57huocM08dxoGkpYRqXzdQAGF0BB6RK6ud2q2E6dDibROOpyqwexxF0qkwAF7n3rWj+3mivDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=It7f3srp0f3J4DXENu593PnoLi4LaimAiYF37w0gGi4=;
 b=KtNSYa3G1BmhihuV93uMRgpXxu4fx3Y+iSNJuDdQ58k4c/Gkcm303ZvgBtzdjxjE6J/jfK0DnIaYIamayO/9tyEtDimh1hu6tX/WrykgAd54Y6AsFiFrCSSiO22qxGTc9roU7fqUe/uKZF2oPfq+OgmlnHMgpHNe8z/sW5wxAoQ=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by SJ0PR10MB4685.namprd10.prod.outlook.com (2603:10b6:a03:2df::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 09:26:31 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::dc1f:39cd:605b:5588]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::dc1f:39cd:605b:5588%7]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 09:26:31 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "sean.wang@mediatek.com" <sean.wang@mediatek.com>,
        "nbd@nbd.name" <nbd@nbd.name>
Subject: Please backport to 5.15.x:
 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=602cc0c9618a819ab00ea3c9400742a0ca318380
Thread-Topic: Please backport to 5.15.x:
 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=602cc0c9618a819ab00ea3c9400742a0ca318380
Thread-Index: AQHYZFAI+01uizJOjUCyscMmeK6+9A==
Date:   Tue, 10 May 2022 09:26:31 +0000
Message-ID: <18d76e36dd24bd03cb470ce6e934533f7ef88b87.camel@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b789246-ecca-4d31-7e1b-08da32672b33
x-ms-traffictypediagnostic: SJ0PR10MB4685:EE_
x-microsoft-antispam-prvs: <SJ0PR10MB46855F32E9AF0E0A4C8B3E47F4C99@SJ0PR10MB4685.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kRNUIe37euc33vahO/Id9vnm+zZ66mZT5YAtYZUQXoLbjpABXHnOzjlvtRFeDzf4ZC6qBfNP6ALWMi8zbic+cVeYj3tVldi7x68KGIRUg23vJnHeNSknZDBiqABcizFkQc//sJmhrBiJjOsSAELaEAOpSch65UW95F1PkaHXIgePw6QJKKm5syu+t0k0saAAD6nvRFQibl+o8zQAqti/QLOfl3+WNDp1rHgMXeoyeoQtXbBsZ8MtCDsr6NUrQqilqa5kmN5Bza0K5UMB81Q9l8lzmvtfFr2SMT7I4yjEut8yizHqpdvW5J9VxJp3jCc+sOWS10+1pTKnq1ylQf91jAzyB8XnrY+BhQkBF6lhQU7ZIqCI01dqonZU7lD/lZ/nwpc7yRHZHfA42OwLSRCzAZQLsYLKW/r2eGZWBeZPwbpbw9nluVmHf8lV6d53SfDAWfUuPUKm+FXVz5ByWdpoxJvm/m7wNW+naJD3MsAQnZA1Mp9hcpKcOEOFlCiyuETcm80MXE+B81Y6M7QnDKLkT0/9/xTvJzWXNTBmEqdt9hm6oMPiohPshWnWH2DyzJ+lLCEsCQEfBc3N09cWOUU4+r7SDKJn/9HeGhLq9WeHnubNZXGc2LmSTxMXszz245QGRAiGtodoDATdJu53S68bBb/ImyTBNmJTqMKqPvb0jtHBOtbOul7cr290Mu8amHOkvhy8tkQON2CozyLMSgcYaMUtI4Y+n66yBOe5jH5TAPfyvglc82SrRkwU7BmGwRxgigcsQcDmtfITvsGE2eALhDR1VNanTSxmp24wbySxEAg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6506007)(38100700002)(54906003)(558084003)(71200400001)(6916009)(86362001)(122000001)(316002)(966005)(6486002)(2906002)(38070700005)(186003)(66946007)(36756003)(76116006)(91956017)(2616005)(5660300002)(26005)(6512007)(8676002)(4326008)(66446008)(8936002)(64756008)(66556008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b29oZFpGMm1kT2RyaEpIdWVIbUV4SUlHSnRscUE0cjRseUs1RXlOTndZQmdQ?=
 =?utf-8?B?WXMzaHZKK2duTWdmMy9RRFBwOEZrT2tQaWgwK1A1cFFOc2NZMkp4dG9QbE5E?=
 =?utf-8?B?UWM3bmFxR0k1dDFYd1R3dTBzc2UyOC81N2VSOTVMbnBaYTRZaFJhT2lraU1R?=
 =?utf-8?B?cVlGemE2dWE5YmxBUU9mZ29vQ3lLeldYb25NN1A0Tk9FaHFiVWRNT3pXRUxt?=
 =?utf-8?B?OC8wdU1ob3Z2M2lmUXZxeG1wT2pDbXhwUFFGNTBmNEY5dEFmYTBEemVDNmYy?=
 =?utf-8?B?RnFEc0JZYnNtc3dIMk5DQzdoSVpEbWE0NHdtcTZEZ0h2RXhoTzlyb05LYmpp?=
 =?utf-8?B?QVhseHMzNEFXU2JvUVAvbmZwR3NLN210bXc0eXZrRXRieVNzcjVGeTB5Qjdv?=
 =?utf-8?B?cVo4YmpGU0I0ZTBXSnFncDdmRUlZYmM4aFBjdUN6ZmQ2RGc4dTRQaHRCakUz?=
 =?utf-8?B?Y250dGcrSjJOdnc2enVOWElQOEZiZ0dJK0RIQzNhMWM0b2pTQVhzK3hnKy9T?=
 =?utf-8?B?OC9JOFljMzd5d0NHbUxSTHU3NitlZURjUEVnWEVZZE1mR3llSGM0U1gxNzVK?=
 =?utf-8?B?Slh1WTYwaXRGemxvZ21tQ0VpK0lkcFY3Qno0MVhqdHZJY2cyNnZ1em51NHRu?=
 =?utf-8?B?T20yWXZTdU5SNjJyV0VVWi9qa25FOWdTejNFMFl6U044NXMzOS93MG92a2RC?=
 =?utf-8?B?WHpkM2c1V040M3VLWk5tMXZpMUVCTVdQOEVsbmE5eGh6cnZBSHYxOHpUN0Ro?=
 =?utf-8?B?WUtkNTY1emNaY0dUbW5IcFZEVEkxdWlwTU1ZcHk5L0xVZ0YvSWdJZHZKeDZK?=
 =?utf-8?B?Wmc4cXQ2MFR3SU9MOFRISGJnUXZGRFJuWDdIOGNJNUpOYTRPTmwyQ2cwRTdY?=
 =?utf-8?B?Umo5eVhLMHpYMS9RdEZWYWkrY2NNRVdrR0o0ZUZIcnpHYXBXRGwrb3ZTSFh3?=
 =?utf-8?B?d2dKdGxaZy9xeERwNVJST2ZibEhPbVlncENWQms2S2ZwQUZmSjd4WkVpaHZk?=
 =?utf-8?B?MVNibGpmcFNBOHVsaFQ5Yll2eGRKcDF5RDVWL3NDV25ncnFUb05yc05mZGJB?=
 =?utf-8?B?amV4Z2xDaCs1N3NSOWFzT2VkNjhkbXZHSUZ3OWJxaEFZTjdTVWNQM0hIckd3?=
 =?utf-8?B?TEhEajYvWmxHdk55VkpNMWwxMStRSll5N0tZMUt2SC9HSmdNWkNpYVhkTU9J?=
 =?utf-8?B?N2g5c1g2RXJlSi9jWGIvNDZrMXV6UzE1L3Q0SG9oZkcyUFNNMVo1Ym02Tkx4?=
 =?utf-8?B?TEtrclZoWUlydWZqbWVIVG9LaE45QVVOSno4djJKbWVWeTlZYzBiK2ZHZEZw?=
 =?utf-8?B?Q1JaNjF1aDd0S3dYL1N2QldISUE3UlM2VGFCbUNjdldzb3kxb05tVnhtQ1dp?=
 =?utf-8?B?dlFYajUwemxHa0pmeDloWjZnclNnYTN4TFZxZnBDSWNaQ2M0bXJYb2FjTmdp?=
 =?utf-8?B?UmpyNmRubjFscFRJbHB6M0M3VUNuZTVoNHkvRlJPUGdhNFI3aHFxZjA3MnhF?=
 =?utf-8?B?WG9RZW8vTzhPUmFlQnJjYWJRbHVTL0F2NElSdUU4bzlSWHZzRFdaWjlabkdK?=
 =?utf-8?B?SHVPV3EvR2MxbDh1VHVjRFNoancwVUtYN09acXF3b2o1NlNXaFBMakg3a3JS?=
 =?utf-8?B?cDlnMzFpbVlKV3dEb09Fa3BOd1hYbjkwNkxOcFdjRmVMdmsweXdrZFlvbjVh?=
 =?utf-8?B?YXZoRzdDK1dEcHdBY1pFQm5sQ1JuOE9CK0w5djN3RENXR3NkTUVjelcrVnpC?=
 =?utf-8?B?SktXZllBdEpiWVRnYXFJYVVHUDhDa1JJbTVsN2lTMjlIOFV6Y2RqME1JMUNK?=
 =?utf-8?B?SUFvdTQ3c2l6cjg2Q2NLQ3M0UmpSY2MrUE1HNCs3Q2N6aE9Cc1l3SUdoTWxz?=
 =?utf-8?B?RFcvZ3Y3VjRYMUg5U2lsYWpuTnZ0cEFySUJ6N3pHbDhYVlBWZFZQZDg5SVhP?=
 =?utf-8?B?NXhzNHpkRWVVWis4U2FDSkJOb2JXR1ArVUZNb3hBcFB2SS9VNDRhWXEzaWcx?=
 =?utf-8?B?Snp0RnBNbjZYSHh4cVZQc1VZWjBzcFJtQVB3REVMT0RUT3BxRmoyTXA0UENI?=
 =?utf-8?B?aVZyckpoVHpwYm9UNnhLcWxvVktaQWM1SFBoSGRrcnpkd3RJRlZyYzQ3Umt4?=
 =?utf-8?B?ZVBJb3NxbzlRZnZ2NXdjK080R2ljYWlubTVXTkRwMVVKZUh6OXVMMi8zOWFs?=
 =?utf-8?B?UzdXb0RZeVA5YVdCemVjd3FFME1uQXh1cTQ5Uno5Y0xvUi8vYnNFN1pkb05h?=
 =?utf-8?B?bElrU2pTRk1QWDd5aTh1a1l2V2lEaUc3T0krdGVHWm55bk92bWdFYkpuRU9N?=
 =?utf-8?B?a1BRUG1LNjh6YThOZVhjT0gxaEJ1MUJZb1NEVjRCWDUyQm9LWHJtMGt1S3Rz?=
 =?utf-8?Q?jlhMQu8e9jHE3JXg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <26D0007F0A030C42AE19DB9333B5BEEC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b789246-ecca-4d31-7e1b-08da32672b33
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 09:26:31.4005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HPh/QL4EPR/b1m4eMRS99elURw0eG+2VcDyoVMJogMKj1DhkA7ugmHMZvfISO1cmsIGkHWdw28d8k0L/JCJK8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4685
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

aHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvc3RhYmxlL2xp
bnV4LmdpdC9jb21taXQvP2lkPTYwMmNjMGM5NjE4YTgxOWFiMDBlYTNjOTQwMDc0MmEwY2EzMTgz
ODANCg0KSSBzZWUgdGhpcyBlcnJvciBvbiBUaGlua1BhZCBUMTQgR2VuIDJhDQoNCiBKb2NrZQ0K
