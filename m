Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA334C4549
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 14:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240881AbiBYNFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 08:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240910AbiBYNFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 08:05:33 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FFF1E5A57
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 05:04:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YieEcKbElKxvg/hJnWPboa7w9Ci/KesUrQb583wFPisw3cOkI1p7ihDTRQMLbDoGUfFkpigNQxOTx5jhwBnIE+yXOQVnV7hSDDhvZNqUTSGddQLYsg7oLFlbhCMu+uBtgZOesV/Onkidsrn7XspzSbHuZK4kqI8NjiRT6TdflT6XoE8hwPSYO2Htjy68tJoW8jU4g/2EmQ+lkYiOzsMZnB6weZ2hP6QzpliLTgRQp3aCYiBWlogBRf3Sd08NiVGjGni/GtM9a7aWARWA6sRei7oJVISeZJ1BtGiok6biiBnKkJYiLCThp4uqfPcDbpHbxBUW0t1kcMQ5yk2ZxpkqcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=weIznP+pFxKt40aFyoepzd38uF/psqcP3KUcpgjg4Z0=;
 b=VAO744tOwYrrcFxpPpjXzodxIZqDpaC4cTxoT1RI/YLtHfTdzm0FmJpTOv6vapj1awxLR41dTvcQn0U3JKndhQ+QJhqJ4GEW4AJmoNwc7IEi5t6LKsbKtKgOb0PasZEUK7PHOsyam/UAkbGi15v3QPu1LT4Bv4of5dzUFtp9FT9L9lUM2YyL4LiTuyKsogOFurbJQtxmB1jPiVI3nMCRegbkW4deV5MPb2a7Wsu+Vt1VhOdLxITMf2hv0hlYRUzB/4pH7xzGwHN8y1QTyi/YkISc1FsrPpeAaZuDBpErDuibqodBPJGvXOTNq6tBi/Vi1rOHbwENMZer0IJShOEUtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=weIznP+pFxKt40aFyoepzd38uF/psqcP3KUcpgjg4Z0=;
 b=Ae21y0+QMG4f2BozQqR8rVEoD6OCUQO76hIAuy2Suwumk7aBCykx/MaQ/ojPFfM0hRuIzNy3L8yjbr99YeNrVhhM71y9DaMLmK0RtL0qjI6Gf7CiQMQCayGJ8gFBgvjLDIruU3SFgjeeTaDy/qk6nqgAM9jwEulYjLdIVvMsv6Y=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by SN1PR12MB2495.namprd12.prod.outlook.com (2603:10b6:802:32::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Fri, 25 Feb
 2022 13:04:57 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::692d:9532:906b:2b08]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::692d:9532:906b:2b08%5]) with mapi id 15.20.5017.024; Fri, 25 Feb 2022
 13:04:57 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Messaging verbosity backport
Thread-Topic: Messaging verbosity backport
Thread-Index: AdgpCbf8l7Z4rDscRRehamZpyAtlRABOSYeAAABDgQAAAQV0Xw==
Date:   Fri, 25 Feb 2022 13:04:57 +0000
Message-ID: <BL1PR12MB5157C1E7A7B6FF4C3A2DC082E23E9@BL1PR12MB5157.namprd12.prod.outlook.com>
References: <BL1PR12MB51572C542F61E7C087C729D5E23C9@BL1PR12MB5157.namprd12.prod.outlook.com>
 <YhjK4RMbHjFc6xal@kroah.com> <YhjMpqwE6BDjzNj7@kroah.com>
In-Reply-To: <YhjMpqwE6BDjzNj7@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Enabled=True;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SetDate=2022-02-25T13:04:56.364Z;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Name=AMD
 Official Use
 Only;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ContentBits=0;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Method=Standard;
suggested_attachment_session_id: c91de8a1-1838-ea20-6cc2-db5ccaf00986
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4197ee7c-c004-4f53-e4e8-08d9f85f6c67
x-ms-traffictypediagnostic: SN1PR12MB2495:EE_
x-microsoft-antispam-prvs: <SN1PR12MB2495D4AF7D34B27BA1CCB4DAE23E9@SN1PR12MB2495.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gVphvihWdQ9TJ4lIGNKWq90YGr/4BBRklB09Jk96ksgaw/erqFXgtOKEZO9/cRnXKuUDHlzaCbzY6PtjuJdfU1Hz74KTNBYr9hmLVJo8hqEHmkvWSD8lM5SJd6689YeebruRn7D2ftztK3+iNloVTh32h+wz65UBa0DQcofS4VMDuivJNT+NUfSYIB5pgDdZALr5KCbAhlxpXgiILj7+bayfeh2H9TJIFjNlsmDMBXCOcCC/Pl2ifnI18TlL/gJzME9WpkUFQCjQwR5gdI1GmXyViQTMmKhFLZgfr4YmaEU3iBQC9Jo0rE9FuzLrSCRavs9P2RZQLmcdvyBINnsChEfONpIOOf+T2mEAHPQhntO1lbnOKDXiEe8dtM2hi5LDQnE9sDWQF9E0f0h9G4tX1xvfmFg/LJ44rP+fnODnIlVbkzYFuD8ZV4qYJ5BJsfxufAxVCXVQwlXskXCUO7GKzuTeOl1tpAyDy9LJroSgrfcOXRhYdXjckPQrlOe8FBMqwU7a4Yn+d5TdFbhySLUnDB7Qak6Jxz+RgTgEAJLC/ki8okCFApFEk0KGU582N02fn1SwZFvZ4BlwPTrIEyVTzYW90qPBK905+NDGvZd6emeLKmUqbgsfyaEcoIXIPKH4yIMexqD7DGZWmLj7A4KTqan6lJrkOmE0KtrBhuyXHaC9QAuEq+eYz5dD9N2xXmF0gdn8KZu+dM1aLIciu8/a1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(122000001)(5660300002)(38100700002)(316002)(6916009)(26005)(186003)(55016003)(33656002)(4326008)(8676002)(7116003)(38070700005)(86362001)(508600001)(71200400001)(4744005)(8936002)(66446008)(66476007)(66556008)(66946007)(91956017)(76116006)(64756008)(3480700007)(7696005)(2906002)(52536014)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Jv8nUaT1a66Ku8gvY5gUgW029HKxSezYHioEyVunScAbgh1gMRKE8eB0/h?=
 =?iso-8859-1?Q?e5w2PRlyLcPMhunglnvoNSP99/9EBpzpjS5kkQc4gTYDkiigKaAVP2NugA?=
 =?iso-8859-1?Q?ifnZ/Fwl9IQoRrUZVyTAadPM1yiSoyTuhgBbTUqDhPOJgrbZ6Np6PZ0Y10?=
 =?iso-8859-1?Q?aLc7iSpcXK07+kcMsE7P5cDF7xwlb7je12YKG05Nc5PJTyk5rfSpVdjKmU?=
 =?iso-8859-1?Q?hdmaBINHeLyUSaH9Es1/heaxbiDsrT7GtubWQItmbT9q7vAXQexm/Lo7Es?=
 =?iso-8859-1?Q?OcE6GoxXnBi9ibjKMhuVHH/+h9bzxBTnfMi6i1r2tpwRHYE0Xszx/Ae+CM?=
 =?iso-8859-1?Q?InLwMz4wuZVXKHi9dukC5eAhC3g1KkK5WkCTw1SHGYjbiBidAF4zhfCPr4?=
 =?iso-8859-1?Q?F/zaSpzoGlcQXNdwBBEnqRD2/x8CGwIRlZlo0DBBnCOHbQR24wgzvgQfCW?=
 =?iso-8859-1?Q?83WNEjM9wF1WP1EU/iZj/czZeFHBvUBgIY7rdFsmfMWtyk9Lto0ocNUEVF?=
 =?iso-8859-1?Q?oKkeT+j93K2Afk9crMUHbF3WX/oSCDvYPb0qKAm1Uk60t3rLSkCcOtbycQ?=
 =?iso-8859-1?Q?jfFyZQ6BTCao2qqRCQ54GkEA05gvuSNgfycZVjCljJVJNRc3iobmTBCPGo?=
 =?iso-8859-1?Q?0pdpiolGpGmyaOcBOcrPBV+ts686whTYBMFo0WmfTN5ae1dWPvFMj+PYE/?=
 =?iso-8859-1?Q?uTtWyYnrNVrJOaivGHWCZsmSIEKAgsKgMmIMfXGOsBqSaa9U8mT2H1eP9i?=
 =?iso-8859-1?Q?Kezk8P1jVPnKbTzOJ9PA38pdr4RviznE+6ky/Dx+YMHYjeG3cuKLni4HFT?=
 =?iso-8859-1?Q?S4ky34QGFDQhyWIcoay1MlNSyQWVZ9HwKlQ1iMYHJhXZLQ9CRFpLAt1pf0?=
 =?iso-8859-1?Q?/xy4jlxQ6rwbeI9b9OH/n/ycfKYjDAa8lPJH4UHEn9zjD0v5GAcJv63oI0?=
 =?iso-8859-1?Q?qTRbOb6/JfjTr6Ov2kMPTILG8vdQ05EBoZZO15O0sSUfkjIcIQwPimyvit?=
 =?iso-8859-1?Q?y13cF5de6DA4FPtqtKwsYq5KHS85jhtbxwFb4QLs47msFyqzKAlJXkIC8f?=
 =?iso-8859-1?Q?02euIgkYFQ2dfvZjRykWZ8+3op66Jh+p6GdQuQDI0Nb3lLI1628Ky8ABm0?=
 =?iso-8859-1?Q?6BS4lQsxEOIAnooywBHy7Pm3vTiQgbvsgu11xloGXUefzVdBkRdea+MM3C?=
 =?iso-8859-1?Q?Xf3v7jz/I1rc4XSBBMIRlsSerbaZVCjgjtcxeSTtgTU5/an9HVZ7LgIrAC?=
 =?iso-8859-1?Q?psU5CVxNiI09GmeIrH4YuqwrdVTCe2H+yHSmmpctlIx6TE57zOsymAw/Mz?=
 =?iso-8859-1?Q?udQiign8A2Kq0EQFAet94fePxNNPgUyAddC0UJv+YuoL3nJTqChhkIAlVn?=
 =?iso-8859-1?Q?iAQMBmGOPt5XPETeX7Q2IXBLAWxkUrqZhvJaCwer58PCAQpt/eUiviY+eh?=
 =?iso-8859-1?Q?J5hXOFlYFVJ88cxSAiYqVdurfNEzOkcvfaOBAcpziGAZd6Rdi6CrA4GuVb?=
 =?iso-8859-1?Q?GufX7B2G6kABWD0doz6AqZsv+sus08ofzKK2TNigkT+yXTI+LtVbNw4O8Z?=
 =?iso-8859-1?Q?hzZVBbsKd2xrtclXIuZLA2X7mWNCyfQK/0uoaZLwVc0RgOcck0lLRg5vkG?=
 =?iso-8859-1?Q?KEZegynkVluAFpxytFSwwERY9HYWAOa5zpYmkNXTKUJyvk8uRG47aTzg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4197ee7c-c004-4f53-e4e8-08d9f85f6c67
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2022 13:04:57.2559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n8QH3TSMo1rVIHysvWD2Lrz+vGBx+HVRhP+h4GGelVqsVOaguc22bYxdnTdgi5ZCdggylAgp4Q6+lDc1m+Hx/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2495
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only]

>No, not at all, it breaks the build.  Did you try this yourself?

My apologies; being a one line change it looked straight-forward backport a=
nd I hadn't tried beyond apply.  I'll check all of these in the future even=
 the trivial.

The macro was introduced in commit f01ee01958622 which doesn't make sense t=
o bring the whole thing, I'll manually retrofit something and send it back =
up.
