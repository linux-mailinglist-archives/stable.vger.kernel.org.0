Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08748690142
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 08:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjBIH3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 02:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBIH3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 02:29:39 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2078.outbound.protection.outlook.com [40.107.22.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFDE26CF0
        for <stable@vger.kernel.org>; Wed,  8 Feb 2023 23:29:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J9yqng7EiK6E3e9OtnLOeW02CsS5B+226n1ZoJ9yeQ/94DvuWCtxxIpas06EO+oiO6OrTtMewAfbYemcMq9gO4Y30b76l0xbiz1jIEELLJ+5Mx2hW0Ah9UR9GjWzGlaaMXmsrcF31dv+H9cxQXRmjdxaIjF3JFr5WoUaHngkK+0RpXnB5DOyWGZnNsoB3GRPcFiGO1B63HuUna2CmxU0qAl68qyG6wg53ezT3EEhY3YNWoKdZn/qzPod3Qcn16kE73rL7U1lNqXGgxBx95CpGszszcLR9HzMbstyVU7d4mcsY0ghkEOCXbYv10hsCu2XyhPPItqHFszdDx2yB9gHiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pqbUPH87mjtHySpjPqvve/BlHTfzAknQXBSg0sjIwGM=;
 b=H1yiaZwaNH296EJX+J5HDxcUAdvORwiUxOzDfLHQ4iMY0uAc1kw/MOvttBkUVPCigXulb4ltixy1gVyfWvi7j8yddJUqXge9ao5JrBp1kHz4WrVmkfrKLo+f8KbOIF6ft38NvequWAg0PpfL3Vx7GuNt1IFU1SRs6A3J7PduSzPnLUOiCbi1SXvvD5bS469ftWkZo0fR9wHveKo81UTOHT5M89Q1VeVehc9YQiZMhtL/UOfV68ECBl9WAcE8R1R+6IHHUMBRtiU4hiA0RHxnUzfY2KekNE7y6E2gMSf1YXK8aGFygHsFM7hrFlJKydAJhsaSyEDJQZYKnfgyvjpl7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=netclusive.com; dmarc=pass action=none
 header.from=netclusive.com; dkim=pass header.d=netclusive.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=netclusive.onmicrosoft.com; s=selector1-netclusive-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqbUPH87mjtHySpjPqvve/BlHTfzAknQXBSg0sjIwGM=;
 b=BFi4Ek7o4sovZGf/eJT99hnT0/HeCHTTpeQO+B8RD6wg4jB0Vt6ZxDnHx5/1/a/46CbAjEzSD7Sz4rPrS8SVJ0CDXWJtDx36yoGTxjlAxZCI1YaVeyJpqKIcTQojuiKGIc0yFUoKu5spSuuHXgcfu6cW0Irz8LNCAVOB4KzwwYg=
Received: from HE1PR0902MB1882.eurprd09.prod.outlook.com (2603:10a6:3:ea::8)
 by AM7PR09MB4165.eurprd09.prod.outlook.com (2603:10a6:20b:112::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 07:29:35 +0000
Received: from HE1PR0902MB1882.eurprd09.prod.outlook.com
 ([fe80::4740:8147:4e2d:60f9]) by HE1PR0902MB1882.eurprd09.prod.outlook.com
 ([fe80::4740:8147:4e2d:60f9%12]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 07:29:35 +0000
From:   Michael Nies <michael.nies@netclusive.com>
To:     'Greg KH' <gregkh@linuxfoundation.org>
CC:     "'stable@vger.kernel.org'" <stable@vger.kernel.org>
Subject: AW: Kernel Bug 217013
Thread-Topic: Kernel Bug 217013
Thread-Index: AQHZPFWpsJH2Ciq6fUKH8KOK8K4GZq7GNYWg
Date:   Thu, 9 Feb 2023 07:29:35 +0000
Message-ID: <HE1PR0902MB18820481569DEBCF299FA9F3E1D99@HE1PR0902MB1882.eurprd09.prod.outlook.com>
References: <HE1PR0902MB188277E37DED663AE440510BE1D99@HE1PR0902MB1882.eurprd09.prod.outlook.com>
 <Y+ScSE/M54LxkzZu@kroah.com>
In-Reply-To: <Y+ScSE/M54LxkzZu@kroah.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=netclusive.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: HE1PR0902MB1882:EE_|AM7PR09MB4165:EE_
x-ms-office365-filtering-correlation-id: 91959410-57c0-479c-e56c-08db0a6f64ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hDUDsUu7JgSv4DnUIOy2C7C4hx1knn/Tqw8eIHKZp6X+R+e4aGo3Kvmwo9W1kkSnNaozWGgKBdARtsqzpiAfkINLeySu7q58MycnCm1K6sfceSr6afVkiE4l9y1O3PE8DBwT4FQIn+s9SbNIFLrvCOCGBk8NPJaxRa39U3fRLnjoqW+jFg57moftSmZGaq3DEd/P4PDxfS23Ir55Z/Y6gHzYcbLNA+r+PqWM+7z/MU2jiaP7LbvTz7rjKuIFMnYbm5xHJ68hlxiS6X/eF4IWrd+rGri2hc9q4uRcJfBQDSEbx/pRDu9RfXhxotWJ7hV9Uv4U82hw3fOFTcTtydAVv0AztLanYogYMwtXChYQ0adlKa+qxPeM9vkTmHUQcHQHRghgXQy5bGzAKOyPGgmEEoDfDF6zDV298HubtXU3WPEwyfHJSFXMRneJ7Z78U3ik7dhz4gEzaH24dtWgJLQNdMrmpIAqP7tQ06fVGKDrNtTHZchOk03FREJDtUt//1F3y3mwx0+SUdT2F+4FDtI5uFCp7hvAmP7hwdW12JxseuwDz08jaZGUu435ghSWLDFk5mP4JsyDtrMSaj2cMC7n5mCihAztm2ifZ5gJcwfl9yUTwoNASvRcNDMwcE6nLBMFBzWOMmSwNUNJy3TrGDM3vA6HAXfdrHAYOwPRH3KShbmAWb6EzPoYxUZbcobJ/qpDVX+kK0bpXnDo77vPYUczJj/+0+vf1ES9GSdJcwJlmjY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0902MB1882.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(396003)(39830400003)(346002)(376002)(451199018)(38100700002)(122000001)(7116003)(5660300002)(316002)(52536014)(86362001)(55016003)(33656002)(38070700005)(7696005)(71200400001)(2906002)(9686003)(186003)(966005)(478600001)(66946007)(66476007)(66556008)(64756008)(6916009)(66446008)(76116006)(4326008)(8676002)(6506007)(41300700001)(44832011)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?F9sH8LX1n69MZEddGQu/l2aGEMWZvn5o2cYWrZ4TGQuDCrpI7g8PPmE3LH?=
 =?iso-8859-1?Q?TXD7dt64qo77bNuG6NnLjh8oLljb7givJCu4N4YCoMggo5xhUGtFcGVwmm?=
 =?iso-8859-1?Q?pEgl0dPJBoOumpl3UmnJuykCNHklbDkWVMogpgJdYD4Y/7vxHHgR2092Jf?=
 =?iso-8859-1?Q?gM78ld9Lx3p4Ar2PDvetdiDaDC+qbAUngnbQL1kIjJS9AtlxEPsSbBEeiX?=
 =?iso-8859-1?Q?3GkSN6s+ZUYTnjIzKOtr3uxrnoCSa+Uxt0t2CPG7EYE8ieyCaraKxhkIyD?=
 =?iso-8859-1?Q?ft0p0ROibRo/kO83o2n66aH6q2L3Kii+dDcdvCM5WCZgHaKU9WM/YVe0bx?=
 =?iso-8859-1?Q?wABy0UckHiKplp9ApZhuxkHmfvP+7m7mSO7Og+mVSnJpE0S7rVUavzEOKY?=
 =?iso-8859-1?Q?IS2GJI6ffmvDVcQZ6sMAs58YsiPsGh8q6n0AcxGDy/ZGy0RU5rYRDzF1Xy?=
 =?iso-8859-1?Q?nAFpGizqS9jePlkxj4T0ufhSKNjXsta4sDcEEjICYyyQF61kG6bSpr5xAG?=
 =?iso-8859-1?Q?zC+Lk5/ZGfyM5EXWcQB//g8niZA1l5dRvllinkUeB5sIPh1HngdbAv/+hx?=
 =?iso-8859-1?Q?a6xoGWuIC4bBXAC+LbSI4dhf9b5fFd6Fd8HX2W+UsemRQozJ2LlbInQ+Iy?=
 =?iso-8859-1?Q?QPkKkllUuvSaA7PMxSjc3tEKOEyEPz2dOMQLd8Q9fwPkaX5Po1hXRFiE6p?=
 =?iso-8859-1?Q?C/vxWhsPTX29PsRrsyLEG1f45pluAQkexQ0lPTZkJ2lda+s+ruTgkCW4q3?=
 =?iso-8859-1?Q?kXxMDjFZEXNOhIQ3bN4dY+EJ7n/uGHcbF7SyYfB6nh8KxVwiDHvPlAPN0y?=
 =?iso-8859-1?Q?0C/vKQTl2Pxj6ttAlgd3TpDaZ9Dj6Wd7uXTtYPxmaTysPh3600X6q3rdvO?=
 =?iso-8859-1?Q?Ji8PqJYABwbZXD872BqEzN2W2DzenyMuy39O5C9XGWHUeG+10fkX4v7FJX?=
 =?iso-8859-1?Q?smyFj+IFR2cwO6WeORwvtnqEitENQJgJCCBfg+op6cmQ6XyM2M28Nkaoh/?=
 =?iso-8859-1?Q?EYW4sLcOk0rqtluU5vu2fiqGA0//5vlsFnv980iWr3ErMT81nlj15vOtnp?=
 =?iso-8859-1?Q?QqPIUpdUHxbS/w3Vutoae4yC+FvMXA6UP0IGUDyYRxLvBmSkrhLiV4Nenx?=
 =?iso-8859-1?Q?0dBoataMeyc0PeFYDAiI6d0upq/g43DpQHGDoQFs+xGxsQcOoJfrdp5tMA?=
 =?iso-8859-1?Q?4JTwB3ed4Iw8qYhB171ILzdBf9kJ69hOQKKBTyPh9dQfmmC1gp08ObIudj?=
 =?iso-8859-1?Q?CbOj64uEdUpN1eIzB5yAd9mkuSxtKRvNScws3mM/inpoS18H9PsIOg6gVN?=
 =?iso-8859-1?Q?2hoSBvnPxF4eOQjW6orcT8SQH/wfn27+dftBUSmzT4UEhjW9palCDeBTH1?=
 =?iso-8859-1?Q?DXl17SmPpoaR8DtepPhOBSpaqi+Oj5g9TEMew/dpJFCvinaRIo2zRg3JQI?=
 =?iso-8859-1?Q?pwMFDY4dvGMZ53Zc9Qtw3XMr0aPWyuZ3Vi12iAdGMIRmQxPwTdP93aekW0?=
 =?iso-8859-1?Q?c4i9wV0n2eZlS5YvfbpKDGXwtiAIHNm/7APi45LtAQ8XOoPTK5IThUiFWy?=
 =?iso-8859-1?Q?aKuavL/gf+Jnw+IklOtXVOmkJ0d3fu6X1hPf4R4Di5FHAnIIHpIGmkLvrJ?=
 =?iso-8859-1?Q?OAYqoUQbuH2E+GnkcyJ/XelJbVkyaBkaiNzKonrsxUCpMU/QT9rcGE4rl7?=
 =?iso-8859-1?Q?rg288MQP6NgEMyH0+9v8OQcinP7cFKXoz42ApQg+?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: netclusive.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0902MB1882.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91959410-57c0-479c-e56c-08db0a6f64ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 07:29:35.3548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7efcf5f5-5d2f-4b3b-800b-1cc1cfa2a04e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gW+FtydLo+wl6yEM87BolIto1dFtdZRsWhM7x4+3F2jBTx2oN4VHdv/CH+HY12+bIxAKERuFTmcqc4Saas3O0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR09MB4165
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

thanks for your answer.
We do not use kernel 4.19 at the moment.
On the systems itself we have only gcc 4.4.5 - so requirements for kernel 4=
.19 are not matched and we stay on 4.14.
But if anyone else should try to compile 4.19 with gcc 4.6 - they should ru=
n into the same problem because of "_Alignof".

On my side it is planned to compile kernel 4.19 with gcc 4.7 or higher - so=
 we should not have problems with "_Alignof" in the future.

Best regards,
Michael

-----Urspr=FCngliche Nachricht-----
Von: Greg KH <gregkh@linuxfoundation.org>=20
Gesendet: Donnerstag, 9. Februar 2023 08:10
An: Michael Nies <michael.nies@netclusive.com>
Cc: 'stable@vger.kernel.org' <stable@vger.kernel.org>
Betreff: Re: Kernel Bug 217013

On Thu, Feb 09, 2023 at 06:54:51AM +0000, Michael Nies wrote:
> Hello,
>=20
> could you please have a look at Kernel Bug 217013 that was reported by me=
 yesterday?
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217013
>=20
> Greg wrote that I should write a Mail to this address.

Thanks for the email, and the bug report, I'll work on this later today.

Do you also see the same problem with the 4.19.y kernel tree?  Or are you n=
ot using that one too, or with a newer compiler?

thanks,

greg k-h
