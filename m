Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B39A53AA92
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 17:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243117AbiFAP44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 11:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349560AbiFAP4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 11:56:54 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2119.outbound.protection.outlook.com [40.107.244.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD22F29819
        for <stable@vger.kernel.org>; Wed,  1 Jun 2022 08:56:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ml4HkOwFXBaRSDNEaPWzSQCqSnUklShYyPXvxbS7BAEyy2OgPJBpiNNhXNmybafaAnOKvXPOX64BpKCzvVxJpaMgSOEaaS2xEVGSocDEC5LGkwFRiEZUBClgXRxtpbldqxiHpXJ0Ae0hfKb5WErL2Fmj9QjB0TBeyuyGyI8rfaCHVW4l4ZCWNv/U213PyTwfxltDe6WWN9ZibZHkk3k+Rm3qjQc4yjxt8WfePKFCjKm2SZ0vzg3sTo1Cw/a4AFZgXN0Oi0NBHmlC2pP36OlbKLgwFMlCMHdDeeKfqSIZx6NcMa3mtUNSDrrC209QNfKiz13KU97vKkOkC5bwQqyNCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cdi3/Au0WB6rvamlQfH3x7+Y8da7J/OAQUnXLle5N9E=;
 b=d0+gz3F95Wnmt52NkMMRlYNBgs74mFeurVuQdyPIP5V6qLf+I2n3E/OI6Ks5QBs5q4bJstj6D0Gx88l6bhWB1kxTbraFKmCfWZ3JTy1W/yVaAuxf0dhD5Aguad2ubqGbJaf9avyVd3bp+/6NHgRK77za1wvrKO1LbgFwmHHy3if/WE3/3CRKHY+Fq4Syp8nAvFPBjPSXP2qu9kT2fbrMl1tDiPRy31JehIyMzTJmlpUkUV3GpF1tk9xGg+4Xmmq8pNYvyF6GBQcJ24KOHq6OuPcvqOqFUlrJpJF1laQ3F06ovxxn3tEmdovGepDjdDcAdJJqcPUQPjsCcpD1ImeMSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=novatechautomation.com; dmarc=pass action=none
 header.from=novatechautomation.com; dkim=pass
 header.d=novatechautomation.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NOVATECHWEB.onmicrosoft.com; s=selector2-NOVATECHWEB-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdi3/Au0WB6rvamlQfH3x7+Y8da7J/OAQUnXLle5N9E=;
 b=fWgXyZrQs/xGrzWZ61U2s+O4VTOJz07hebYT9m7Di1KJAnWUok42gQdIq3CQM8h20QxXP6zsEkUyE2rolHnHgqBg28tvICu7RepE/mON4JCamxqyWuw/ahNJBRAI35uGo90OCOT1JZPVPdHYhYNDx/mFquf9mPag/34pX3U7HVA=
Received: from CY1PR07MB2700.namprd07.prod.outlook.com (2a01:111:e400:c61b::8)
 by DM5PR07MB3893.namprd07.prod.outlook.com (2603:10b6:4:af::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Wed, 1 Jun
 2022 15:56:51 +0000
Received: from CY1PR07MB2700.namprd07.prod.outlook.com
 ([fe80::a9b6:a462:eddc:cedc]) by CY1PR07MB2700.namprd07.prod.outlook.com
 ([fe80::a9b6:a462:eddc:cedc%12]) with mapi id 15.20.5293.019; Wed, 1 Jun 2022
 15:56:51 +0000
From:   Eric Schikschneit <eric.schikschneit@novatechautomation.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: [REGRESSION] gpio: omap: ensure irq is enabled before wakeup
Thread-Topic: [REGRESSION] gpio: omap: ensure irq is enabled before wakeup
Thread-Index: AQHYdc+tWv7aWWd/6kGN6rTOpeTdyQ==
Date:   Wed, 1 Jun 2022 15:56:51 +0000
Message-ID: <CY1PR07MB2700E81609B0967127D0773381DF9@CY1PR07MB2700.namprd07.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 4dfcf29b-4524-b1d6-15cb-38588e780b0c
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=novatechautomation.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 238a2e74-3984-43ec-abc6-08da43e7579e
x-ms-traffictypediagnostic: DM5PR07MB3893:EE_
x-microsoft-antispam-prvs: <DM5PR07MB389340FEFB5CFCC48CCAC12081DF9@DM5PR07MB3893.namprd07.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pSegnSBNVQ0G3dv112cCb4TMGfBaU2Q95bRTpPp7wNrocxVffQf78upspW3h+yG7H0OPR3y9aNLbNCf1ts9hAWsnK6bqy62h0PfkSz9RrvX51VYZ4e1qikZ2IItT2pK92tXKyf8ym+IJ7n8MiWD335+wWt8/VsURNC+HBa6UyuU4wa+EIXVrXkH1Xs4Wu7FzAgYI5IZkK3wvKJ2cWfFzWbPcoLJ+9DFdzx/Lc8MaBoOEYMh+3bsmI3aKQJ0ENpLALJGS7n1I6MYrSVLvgXBiq9dWUI4VvRoU5ixj7Rdt/SNTRmk8qRwoG4EEEZvwWocWaxkCJnp/ihwrk8Kce7zDRavtbIAg/GG4Jx7LfV+UVE7oGR12GVnaFl99TZExpoP0t4z8oCE8iHCq4MUW9ecsf27WNtojlkFQkKvwSkp3yV+f9bHYtTnfwLgW6c6slYFjZqBf64eQGv+lUFkLAUar87JBEkteXRs4J+36LF+HgGrbTD9+Euv20m0V6uk8oWFUWh8rtOimJTUgSVlBNULk01R9ApabUsC7PJCkV9kSPlTM5WzmPoCvRb2VNL46HRfrvd7TzEOp7gJKTFl1K9NLFt96CaH4dKSO9IbbGvMn3dbG044Or9K3esXnJ8uhdcwBH64FgzbTKtHThsG8D/HYTlkpXqwGkn/z8v9QigceLA9j5O9qBIMh5hkIFb0DayN8enfflO92gFvIBPaS3mKHzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR07MB2700.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(39840400004)(366004)(396003)(136003)(71200400001)(186003)(316002)(508600001)(91956017)(41300700001)(38100700002)(54906003)(6916009)(6506007)(33656002)(40140700001)(83380400001)(26005)(7696005)(55016003)(9686003)(2906002)(122000001)(4744005)(64756008)(52536014)(66446008)(44832011)(66556008)(38070700005)(76116006)(86362001)(8936002)(66946007)(4326008)(8676002)(66476007)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?zjOzkWQowvqzC/sLJJTSWfVAQxD0abngKl5WLo89bp/czng4JzT4/WuJcf?=
 =?iso-8859-1?Q?1De7keDYDBiZ1i0YFr6DgoT5hJPp4X50T3LMyeObqFG7zj+wMPSdL0nTY3?=
 =?iso-8859-1?Q?7bdcEsvjoo1AocbybRLYjM53yo6MEIpMYws/fCQEL9H41TdfHaTtJMBojE?=
 =?iso-8859-1?Q?IMgg45NQ13HEQdDkHlEFJgbKQctxgDpqGcF4VUDD5oJzOHyeJdWJmX3UZA?=
 =?iso-8859-1?Q?L4qaaLlV/HvZUaNuq2gc65qpbS1LvTDcapZejKoedI1p0TFzo88aP7xQyY?=
 =?iso-8859-1?Q?Sv6MUzIpGbbUbFn1RRjkqddc/FUitTEV/9pqsIW4HOk0u0s2lA1hds/XHY?=
 =?iso-8859-1?Q?qsD0LQakUICPViBfoZ5sb/rVBG+Y47PayoyCgs+JQJkG85KZ7DVLgDBlhs?=
 =?iso-8859-1?Q?XWsgQigfUUbvtzUfVCgPufdGdcEnxgPYvxGxsu3pDLs/ZLBQeRuIy1NtEc?=
 =?iso-8859-1?Q?fHnNd7Jso9qUePaB0WHPCGGUUA6luLr3HYzZPiRK2sg/7EDjeQ+AqqooSF?=
 =?iso-8859-1?Q?B1mYc6gJNz9izRBRdKjFNn2wZ+kc1ADcyQ9OJPSGtD3CB/hhFkarZWTIb6?=
 =?iso-8859-1?Q?jWy/7KWkFpmRzU1aMPdZuQp5IU1cpFJ7n3oJWSUUpgPUZ+wAWpFTA6sxfz?=
 =?iso-8859-1?Q?/xyPOdPoGqJ093rCMlsMa9Y2TM197HSHWE0AiBMKlFj2o2nL9REJ32rhp8?=
 =?iso-8859-1?Q?0cOiWYWqpS5wSIgJQ4ILZ8umkLLtd2RpAxmqdVg79nvypfrltpJ/80VaIR?=
 =?iso-8859-1?Q?Yx+pBzecIZ79IMQnxRZN1IqsIkJ1sxsltvFER9PC6bl/g4Lrw1vfv3iBem?=
 =?iso-8859-1?Q?DGn1orX1SAYVeS+lJsuCiYELJiWFH82IdMy+jXJl8YRIr/rLudXNM7upGj?=
 =?iso-8859-1?Q?0uAKhIg3fV5fn7lNBVpbMQfFNU97VttyQGyAS5aoQw5y02O2QADAAbptRG?=
 =?iso-8859-1?Q?d+Y1v5wvLkF3NBZOvW/erAtCWJCVuk1Uc0+XvFf6eNJRv1g9BMWsgD0bPR?=
 =?iso-8859-1?Q?spCd39rWaunegZtYtpFMrTD995GYocQs2KKXCVKxuAmxRjuXYa1krUhGXv?=
 =?iso-8859-1?Q?133YDttZ0GF5fBH9D57zImeLSZKJuSTADkuLcXQZOcijAReCaY1bkr7HFL?=
 =?iso-8859-1?Q?pJMtjWuxEe5w+6JDt234TeBs9lLf03myZ4+tQXYPS7cpZaCU8MLwk1LNdL?=
 =?iso-8859-1?Q?ErbNqBYg1tPUBnmkOwfbo5GbtOCAH4t5wFzct9R4P761p4fjRzrZF9n0gr?=
 =?iso-8859-1?Q?J0gofedk2AVPYvSEaIo0CfON557p+no9PNvFg99iQBxDFMzrdXUpqrb4a7?=
 =?iso-8859-1?Q?Cgb0NMbtakTa7g+q6VLgaxI9j/zLdo4IdUTJSCs5CUcojmJpDqa9N9Z8+Z?=
 =?iso-8859-1?Q?3sLmzqFqEHuSiEHy3XV2ElA/+AI7t5SpvclzYAS9T/eTuf2bfOPPSlFYph?=
 =?iso-8859-1?Q?ptenrVGYxKGvQuzdt77OTwtaWYs8zal0IsJB8oX9uu5RsDbSgKbcit+B+5?=
 =?iso-8859-1?Q?uDJBkFeF4lEGqU45755b61p5qCUkz5qhsR+8Fsi12Q5VjWnSvI0ZDgtIDs?=
 =?iso-8859-1?Q?mcVLYqYcsxp191RAo9LoUTqz18Q26oAwMZMbn4+grTFB1Y4jLR36O3UzCQ?=
 =?iso-8859-1?Q?dDwKCsjCq/bFxEDzHUoWIxqhxUbkOZRU9pCFTScd8JSqKpcf5QmSUz1s/u?=
 =?iso-8859-1?Q?KhDJdxT1HqRLFNiOS8kOR7FgZAp67fDZNvQP/5y0n7zOAXazEZQUvhzs5E?=
 =?iso-8859-1?Q?++f4nB15/DzxLJ0k214uhG7e2Rqms5ELvhgJX5+FzuJRu85/wu+b4yaFns?=
 =?iso-8859-1?Q?bkNJj2ItB4ip+7vuzz27LOFZ9lQJUM9Xz7LLgTtluPc95PjZdK1s?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: novatechautomation.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY1PR07MB2700.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 238a2e74-3984-43ec-abc6-08da43e7579e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2022 15:56:51.2244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eb0f6598-d3e5-4ff3-a8b8-fe893d304059
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AafhQAMfjoRLcXNSgiNbbPDG9WP+mYaVPJELyz+KKPiTxWYJTWIuYLapi3HmHUzKQmEubRr2rKQ7TXfUOBTiSyo/lG5yG1oIKCZPrlcM6S5e4ZEilDIosxc608dIEG1ZsmuCQ9bS9+GDGD3Du8GHxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR07MB3893
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Summary: OMAP patch causes SPI bus transaction failure on TI CPU=0A=
Commit: c859e0d479b3b4f6132fc12637c51e01492f31f6=0A=
Kernel version: 5.10.87=0A=
=0A=
=0A=
The detailed description:=0A=
=0A=
=0A=
I know this is a old commit at this point, but we have observed a regressio=
n caused by this commit. It causes improper toggle during a SPI transaction=
 with a microcontroller. The CPU in use is Texas Instruments AM3352BZCZA80.=
 The microcontroller in use is a PIC based micro. I have logic capture imag=
es available to show the signal difference that is causing confusion on the=
 SPI bus.=0A=
=0A=
=0A=
..............................................=0A=
=0A=
Eric Schikschneit=0A=
=0A=
Embedded Linux Engineer=0A=
=0A=
NovaTech, LLC=0A=
13555 W. 107th Street=0A=
Lenexa, KS 66215=0A=
(913) 451-1880 (main)=0A=
(913) 742-XXXX (direct)=0A=
=0A=
Eric.Schikschneit@novatechweb.com=
