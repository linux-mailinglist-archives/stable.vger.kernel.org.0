Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE00500E37
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 14:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243675AbiDNNBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243664AbiDNNBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:01:37 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C315792865
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 05:59:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Abpm9iqUt2iuq5QKs5gIscdV1kUB2wgIRzQlpq0EoPjqYLdkG583HqPsApeLk75CR/Uk9lUVRrC86i7GVS87W5b3ZfcvF8Y3qG6qmz6+aKkmHL4z9nK0qpJnf1srkGhwDoVeYcWJj+A3QFN1dMOOFHc03+GRkHOnMNv3D5H097cVZbv+2TPeSyxoXVaVldLsBzpDyJO4ppZYXQb6m0tTfgPdbDyIgmIG0QZrVvkHc/RqatldpUnd6ssD4/Hi0pT9QZQDv4C3qKnf7gMP6nFGyIexpq1YPGoJobXyUePWHnSIfoTFx9m3FRfGiB9yxe7ORxk/jrPi35QQvGL8xDLoyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8gwAmKMwBiM1Lb8VerbUFDlL1coyWL4jgONAXWsPqr4=;
 b=HA6EPiyDeeVTSKxxDMJUFf9BZQJHAIZJ5W9++1cU3hD4jqfDoBJbmAKZMWd6wE2Y15MZu52K4sNR3DqKU+UV34M/dnl6W0iaIaKVPWG42gUxSytQvP8ewoB7LUwQlvxtr3PbhVzlqXEy5ct95GN64V54QIdizLkPYN9F6JrNYVkNSS6hbeFF1KII+bjEjkPzpn0ccOJIBObQDHaXMRRAR57jFEb0jk808/pRWHJVnhAUWeFPkmAdoOgc4xVLMnQmnbs+SwuhPykZD7qjV2M7+Ni5NF3Z7H0qy3IB3PNJ3JDa3IrKrP9zE/Eixcr23vkkxpAEG3l0vMP8qdf/FfT8+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8gwAmKMwBiM1Lb8VerbUFDlL1coyWL4jgONAXWsPqr4=;
 b=w9ZgIzOttNeb4CVzrCtWANz92J6mA3gcSrV7N0/G3IE4spYdBlM3tUHn5T7lI88YFkApfViIymsiZLtlnxLqo0W9szefFZzX7UIhK9OBBR39pDQefEjPI7AAFDYjyGDBKzcLDmKqp+J/oe+WaqvT3Elb4cYRgl9U8bdiRlyJVYI=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by BL0PR12MB2531.namprd12.prod.outlook.com (2603:10b6:207:3f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 12:59:09 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603%7]) with mapi id 15.20.5164.018; Thu, 14 Apr 2022
 12:59:09 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Gong, Richard" <Richard.Gong@amd.com>
Subject: RE: Allow playing dead in C3 for 5.15.y
Thread-Topic: Allow playing dead in C3 for 5.15.y
Thread-Index: AdhOumxBQNQEbOKASjOWtX5oq9oTegBM/uSAAAQ75JA=
Date:   Thu, 14 Apr 2022 12:59:09 +0000
Message-ID: <BL1PR12MB5157EDD7F142FB7F214E179CE2EF9@BL1PR12MB5157.namprd12.prod.outlook.com>
References: <BL1PR12MB5157E3D352FB769DB61E2D0DE2ED9@BL1PR12MB5157.namprd12.prod.outlook.com>
 <Ylf+DcjOorOMYnkN@kroah.com>
In-Reply-To: <Ylf+DcjOorOMYnkN@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Enabled=true;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SetDate=2022-04-14T12:59:07Z;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Method=Standard;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Name=AMD Official Use
 Only-AIP 2.0;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ActionId=628a99e0-4825-4646-802e-e975273e4961;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ContentBits=1
msip_label_88914ebd-7e6c-4e12-a031-a9906be2db14_enabled: true
msip_label_88914ebd-7e6c-4e12-a031-a9906be2db14_setdate: 2022-04-14T12:59:07Z
msip_label_88914ebd-7e6c-4e12-a031-a9906be2db14_method: Standard
msip_label_88914ebd-7e6c-4e12-a031-a9906be2db14_name: AMD Official Use
 Only-AIP 2.0
msip_label_88914ebd-7e6c-4e12-a031-a9906be2db14_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_88914ebd-7e6c-4e12-a031-a9906be2db14_actionid: ecf6d7ad-1be7-4d9a-8b0e-ed6091a237f2
msip_label_88914ebd-7e6c-4e12-a031-a9906be2db14_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63ef2a6b-ae8b-4059-7ed4-08da1e1690b6
x-ms-traffictypediagnostic: BL0PR12MB2531:EE_
x-microsoft-antispam-prvs: <BL0PR12MB2531D3013D9AACBD4F46D1E8E2EF9@BL0PR12MB2531.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tLmt8ptMjXBpjv5X1YaRKNTP24eXXFIwDGMNVPuHtIoh72v434L4pgQDYtwJbTQeF3DgeJe+GhfvovNKR36n9Rx+oBJkVOhDkrWFZcenguVMj2Hvjrx/lwuwzBWfvFIhg5YQ0H71MmTZLrw53dGRcdEhZuBOKO0h3tXs9TM6wvh2O1+Siw7wHHuCGaAYYJfzA/bmjYQZSTXEm7c4tbYP0kLEUPwprzC9RRpUx+eOWPQ4A9vJs5iJt0rEkNgCNs6IWyp1k0djSosfegjD7ONlLkEYSXu6+2AtjmWLdIPq9ENcoff06l42MqODpNjNO+P0GtiE9w7/bCZQyVg0S4Pq0L3nvrBiguERULSvZGVbWyUp4CcRNC6D8GbKI7fb4sC75HrAdGvDVWXU1OKifHqcdRc2fWvbr8+Y7W2xZDx34tTpLus7083uJLzEnM4UrK21s8xU7gkqywpk7UYWHmFNL4oQ4WCFRh5R3pZoY1exaCXRJyQMaAZLw09JQdjUVAiVJsQymHn/h8nTZgoMm3eImOvAJmSnY1s7Ur8Z9jGJ25z2kdPvdcXNRhkLxnVToGwbYFeqsWhVamX6yinwgp/KR2BUba6ap1II+hp6/sIxtQtAd4Rdr/TpvFieKP32NjG6Gdrga+GuKweq8o6ZXT9Kr/+0RdMShyit5KrhcPCtk/ZYarpLl+sEck4TW9CfHpMjtehhZcfk3/T8oLYNuS0NeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(6506007)(7696005)(9686003)(186003)(55016003)(122000001)(38070700005)(38100700002)(86362001)(83380400001)(33656002)(316002)(66556008)(5660300002)(66446008)(64756008)(4326008)(66476007)(66946007)(508600001)(76116006)(8676002)(2906002)(6916009)(52536014)(71200400001)(8936002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G20BKZqz/qbv74F4wYclyOXX9FHrIcWn4BeenHbN4GoSnfEeDNJZairi7FHd?=
 =?us-ascii?Q?N04ZmhECGxOySJO+cBRrFAOTPaAyWO4thQAU/jl/pReHKA1LTAcXe5QUdn4X?=
 =?us-ascii?Q?u+Pkl30nFA7BhoMzVaEOKVI/zpfh+4lXFb9v/cyUbiaaXjv34WDfpejNeMBN?=
 =?us-ascii?Q?pe7U4jLqxtHS68lHCdYiGCwUOYvam5N4Ja+LkywtDxm0JXoicpg6yUuCBF0E?=
 =?us-ascii?Q?v3Z+R6LaFvzd1HiJJNAyy5qJdjvAlqbQk0AxLH2L2Vld1vDa27FM/a2mdjl2?=
 =?us-ascii?Q?rREYMlQ7ZPDV/5SacCj9LrhsMrg+OBKL0++ToFsfOH5rcAIrCzOCL/Y94Alj?=
 =?us-ascii?Q?UC89AkhRGGTUQLFNM79TvKu7/f9HejFE2t+XNuej2m+cxXudUqGWLE+JyrRM?=
 =?us-ascii?Q?S+Tn6g0RMY24gG0tpj1hVvozveDMIVhDn+7rtI/bJMRSLvvG1CTqnZkV+psc?=
 =?us-ascii?Q?Q/r+uSNLGvJhwCVlpCWWfygPXIsN7qgxmrfpjONJmt/kJu1ZezkdrO0OmZGo?=
 =?us-ascii?Q?saeS5++azlKznZL7vRLYJLt5A4ozUSF2MfEnQ4ipcb9Fe3a0I00IyOJmYzuY?=
 =?us-ascii?Q?pr4Aaoc950h2B+kbMrSkZAVcDuMeJpboKm9qLVmGhjyU+Li4hRgyOMF7Stjy?=
 =?us-ascii?Q?I1CGjKbEdfuklXAgupk9Sj2FjagvWV3WKsURyOoiZdgMi8A6yL2HkgxjBVRP?=
 =?us-ascii?Q?PcBLmI/7d1eAB+oFb6UrcVAyKXSUFCkq5FDNiN/Ejct86ONeJG7BoWT6AYIk?=
 =?us-ascii?Q?YRgpLYUJhaXx8DSIc/PbFAax/PeulbzDczPHFuITUHYpq7baH9xqEuDEH7JB?=
 =?us-ascii?Q?7jWf1l01Pu4KF/1s+lvx53cfrTF09AA2uDxk3N72nQszKLrfbty0CKlieD8r?=
 =?us-ascii?Q?vgJJPPaDjyzhSZHNEOWEHwFvVn6+7P9++hntWoaboO3WTq0czqN9vUsBMhOW?=
 =?us-ascii?Q?3zhu0wNWd3PRDkHt0DVvTKtuuW/IORPlnXL78Exo0QgAYG552praKdCsjh5t?=
 =?us-ascii?Q?g0bx4S+bDsR9tyPUGKusbT0HKmzeL/q3IRVhLobqCn/C0e6uvkY6l14uqLyJ?=
 =?us-ascii?Q?XPIC5k1/8tTCeE2Mo+g3iIxgRdWycAKxaq1W2ym6TVLbMbRp5aQyNHdTW/IH?=
 =?us-ascii?Q?qo7p5rG2Mhv9ok0FWgfhZmtf4mBQUpl4ui8NxuQc0+4nF38ahgjVVyrPGrSr?=
 =?us-ascii?Q?Lvb/m3/WQE2qqqFBTFNqOkLab8EyXxrtoMZJT8G9njl2pwD2Bwx7BbHxh6O/?=
 =?us-ascii?Q?TBXPz6BpyiI18qzVlkg2PnP42imShaNyfV29RBujnisxtck2tIG6qStjhbiO?=
 =?us-ascii?Q?+m5Y/EvPzL4t6AXjYTZWRLIFntmd/hYwMb81ZK2BJhuhj317rXCakOA6RCHn?=
 =?us-ascii?Q?fGlKtK86DyMJC5H+PbazT0ZJ6NWyNlhA7Ie6G8TadKOlY5OYV5DHdMkRWnfz?=
 =?us-ascii?Q?WEs6YzoibEVJVZQBgrV1OEw2eSmEimPTQF4+f5ss+92/+DLNIX96G/7YsfFY?=
 =?us-ascii?Q?smtY9PFVaswsQzGyAbR1EFtRL0w+c+8Lghz2LGYLvxeBn17f36JX633VD/hK?=
 =?us-ascii?Q?N4guwMI3AWXgvp1Ysi6Cl3c1jAwqDJvdiSfmG6nPX8AQ0UhwN0+HZ4MIg6Mp?=
 =?us-ascii?Q?f3S9ofqWCsb7HpuAz5MaMqoe6z9gZ9I6Og7OxlSyMM7xIfoKL+/fWJne+c9c?=
 =?us-ascii?Q?k9cFYK4eE/YSzdqBA766qrdKx5p1j+5M7l/A2IhgkkiLo3wqxbaSmfPIZ6DK?=
 =?us-ascii?Q?hjfxSnjccHWJVVMIAbEb/dPHj5EikvkKEcpBCIdSgP/TgDMuZdmwMUZTKMYx?=
x-ms-exchange-antispam-messagedata-1: H63/b95+21WSZQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63ef2a6b-ae8b-4059-7ed4-08da1e1690b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 12:59:09.1870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zh2OIVMlVM4NhcWrUwSLkF5pNKckxH2m/KPxUO+41sHx9OF9DO1mPy8ITl1XwLYqUY4afxXNXLUn0tfk5/CjPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2531
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



> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Thursday, April 14, 2022 05:57
> To: Limonciello, Mario <Mario.Limonciello@amd.com>
> Cc: stable@vger.kernel.org; Gong, Richard <Richard.Gong@amd.com>
> Subject: Re: Allow playing dead in C3 for 5.15.y
>=20
> On Tue, Apr 12, 2022 at 10:15:37PM +0000, Limonciello, Mario wrote:
> > [Public]
> >
> > Hi,
> >
> > A change went into 5.17 to allow CPUs to play dead in the C3 state whic=
h
> fixed freezes on s2idle entry if a CPU is offlined by a user.
> > This has had some time to bake now, and a regression was identified on =
an
> ancient machine that is now fixed.
> >
> > Can you please backport these commits to 5.15.y to fix that problem and
> avoid the regression?
> > commit d6b88ce2eb9d2698eb24451eb92c0a1649b17bb1 ("ACPI: processor
> idle: Allow playing dead in C3 state")
>=20
> Now queued up.
>=20
> > commit 0f00b1b00a44bf3b5e905dabfde2d51c490678ad ("ACPI: processor:
> idle: fix lockup regression on 32-bit ThinkPad T40").

My apologies; I must have had two references in my tree.  The correct hash =
is=20
bfe55a1f7fd6bfede16078bf04c6250fbca11588

>=20
> There is no such commit in Linus's tree :(
>=20
> thanks,
>=20
> greg k-h
