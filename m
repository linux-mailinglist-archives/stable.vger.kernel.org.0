Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96264DB1B0
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 14:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356362AbiCPNjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 09:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355178AbiCPNjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 09:39:16 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2074.outbound.protection.outlook.com [40.107.95.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977D36264;
        Wed, 16 Mar 2022 06:38:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FO695hUl73gZHzWnVDV+uxhdMRiRAYJiaSe0mEuo8ef5pXg1zgv9EbcQ2WYzxmtnbg1/vhfxV0yf+4pAH4rKOfSQVrVSmpx6kUCCHskIk5CKKaF/dybj5o0ByKCDxxy9bk8z7BcmjX+TLyQB4qfO6rhcGJ6Idxp7VNWcxGbUy9gdMCQwNidc2Xqn7wsuGLzIXQ7ize01k4gAONsHaoCaoQAzZNU+oml4TPlW1cHRrZF0ZIfbFWqOeRDV1mY8LUPPE7s2WLaUaTBHQpQwVx4Y8zyk/VqjTI76P9TFgnxNCadjnCt2kn0sWVmDFBo9tlVH4EX9m2ZIMjl2eh/HQM1DAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bvx7UDUTylNd4eS4dsjGZRiWeGGO5wJGyeRa2L6lqxA=;
 b=gkCmhifelkn///cPxsLI4TaYgbfd2egFJWSr57UzNQPcBgkRQckWCISKNQUlMV9WZbX8nTHkIV6Qv58K/SJhjIRRW15Nq+aJ5CxCPNWtVxaCqBD+OUwFF+RIM4aoiroJeAHHcs9/YzMufV7YjTqxFljSOTDUtPOgUI2LDmC6dmUJuZt3EvS+WnAzYOniE4FrtiOmRHiUQ/7aAp3VGhjCorfLU82nMMszRXuzCG93/WKq+v3tf6Jjwv/T6ceXEDzjnsofOx44oUR/xXx+jQNZ7iPhlxOGDh1w4nlTIvTjCllONiksookURmNSMzQzLo+PZgSkSquJ4lc8iSs140dXDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvx7UDUTylNd4eS4dsjGZRiWeGGO5wJGyeRa2L6lqxA=;
 b=DpIwAQkHd6nXtshSnb1lz6PgTWegIaY7drcAikIK3Oto4rl7NXmvA4iqQheH4i77oPzpV5uECW478v3tLY0/Ld3Cx5DzraReANAAqgywGohqAUEyKzcrJ7K0b2QS/JRQeEIl0RllIoWH4CrQAEsCJF31HyKjnbjmv0ldq94kW9E=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by DM5PR1201MB0028.namprd12.prod.outlook.com (2603:10b6:4:5a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Wed, 16 Mar
 2022 13:37:59 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::692d:9532:906b:2b08]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::692d:9532:906b:2b08%5]) with mapi id 15.20.5081.014; Wed, 16 Mar 2022
 13:37:59 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
CC:     Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Mark Pearson <markpearson@lenovo.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: RE: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
Thread-Topic: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
Thread-Index: AQHYN7EE9MG5JHJAY0ujFaTCu2p8pKzB/M0AgAAFFgA=
Date:   Wed, 16 Mar 2022 13:37:59 +0000
Message-ID: <BL1PR12MB51572AA41E116C59FE0D5698E2119@BL1PR12MB5157.namprd12.prod.outlook.com>
References: <31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com>
 <CAJZ5v0hQifvD+U8q1O7p_5QeicG_On4=CrgNj0RsbPSbkY8Hww@mail.gmail.com>
 <ad3b77f8-7e75-1dfa-8ee4-1077336911aa@redhat.com>
 <CAJZ5v0js8Vr7dW09WGyR_JTn4kMybDhaTWt4yziqwSM+oAXUNA@mail.gmail.com>
 <CAJZ5v0imJfOp-Uw=tH2dimSQzb-EgHu_yEU_0LScmrQ43t3pbw@mail.gmail.com>
 <c9a1adb5-17b7-c7ed-d23f-6b6523a4771a@redhat.com>
 <CAJZ5v0gB2ZCWe3MeGnw6_CNu_Ds0QEPZ6X6jnA7dQbZe6gKZ8w@mail.gmail.com>
 <5fb0cbe8-5f9d-1c75-ae0a-5909624189d3@redhat.com>
 <ce781d92-f269-aaf5-1733-25de85f05b7b@amd.com>
 <CAJZ5v0irKgmSQ7YegP=US1ACUfqVMCNitu2azMbMAqm2f+cXTg@mail.gmail.com>
In-Reply-To: <CAJZ5v0irKgmSQ7YegP=US1ACUfqVMCNitu2azMbMAqm2f+cXTg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-03-16T13:37:41Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=2ebd3b41-640a-4205-885e-90c0161da223;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-03-16T13:37:57Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 95eada06-057d-42f1-bc8a-7463e704a7f0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd345407-4979-45f4-ca94-08da07522fc0
x-ms-traffictypediagnostic: DM5PR1201MB0028:EE_
x-microsoft-antispam-prvs: <DM5PR1201MB00282D1CFA1F2A2C491A9479E2119@DM5PR1201MB0028.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zjNndiHN7hVYzLsBkpuIB7gC82ds2QTgyGksYTxLOcLEAESNR9n9kbwEtItHn8+ATo2y+VpSrRsCayNfen1RLnRfgs5+INf5Y1WugaWsWAFpyGENVTFsChB04yzUybxJJMfpwXpYHs36wx28+t1r5m8qNtzNqLB9CleGuPXFD7Qn9jdJ1FfzYiCn5zRWfTm+VdSkfaNg/WLEaYbsrU4nGo5T5+iMbHh5KdTYgmkLDFWnGDPNPzADzvabSPqJnvJkTMYwur3HvDNOGdAepSbhy600I/AQ88pi8Ib3j58IDQjI1AbMs6GCLZBK+Kr8cLnAc0ulOJsoOfo2fh9shYDwHOp3+EEpLKryzoK7gIyUGIle0JaVBcpqJpSPr+jsRCgjJsbRKLImseUa3d/AZCwNoPcC7cSq8VMqPZf1PFaQxPrz2BOUrFe9p+q+LpMCCu6/NmzMhnEtG8gBTgnkG0O0WUufgk4RJRC0qZLrAX1VoPQo5/N6EKMTykQcGJd9g8d93BXgZXrzPnBVYUoJtnrW2fJ0JtG4LEmv2Y67Kh6tSsHpgtYBfZgWelANNiXZ2Bza09uaVeqIfGWCDhPEGIlsonFz/5YxutOqvX5u4hvQz7UhX1muSQEL7UDFz42BZNQUlDhRvoKL26edOiqGpC9FGSW3H60xdOgeQH3TYkv4kK/CyJR4OtgsIn60Ji03E4FJkAq4Ap8IJ3CEHl/bp4FoOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(83380400001)(508600001)(122000001)(71200400001)(38100700002)(9686003)(5660300002)(7696005)(6506007)(33656002)(52536014)(8936002)(316002)(55016003)(38070700005)(186003)(54906003)(110136005)(86362001)(76116006)(8676002)(66946007)(66556008)(66476007)(64756008)(66446008)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kVhlxUoMIB7A+wfXRqUcBxpWu+TRybxQoq5FIUwLEJTeYn52guOxCxRfa/rQ?=
 =?us-ascii?Q?g7zPzyAU7emeGHWy0Haj6g9pKg3wS/qRwNDMss0k2GacfEuES3EuNw1CNwLH?=
 =?us-ascii?Q?Kq9LXBHDD/Ckccct+ZbIo97yIRpwX18TjZcIuhLTiRd7NrFJQh9RnJIObo2q?=
 =?us-ascii?Q?4VxAQ7Cult6HZ+m8htlbjteSdeP4XTXgw7cUyTZ4ddM22yo0X+5owhfxYr2C?=
 =?us-ascii?Q?C/HJYql1s5c/YDD8puUdNyPzyYV+ew8dD3ziQWlNr/SG2Ly4p30xQsDnpkBy?=
 =?us-ascii?Q?dRe0a+6qRs66wEflXTAMoMRupRKhke9hVmXrj7QMYU85rdIu6kThtnAjK3rE?=
 =?us-ascii?Q?dHe03VhPLZdcB9y16p+jCgaQzmUgq/V45gdtxcPWDhUtxxe/mXJqpihWhpLh?=
 =?us-ascii?Q?0FOSxa35Uiz1rVL+qCXczvQAQ69rrWM9dgAxdIJPLEaMXvKyVRGRUtEFuz0b?=
 =?us-ascii?Q?JVRLnbBRpVZsFj4LRFoX4ZyyX/VxwLwRPUMxyPEFv7XsshLOOSmSwVocoSOr?=
 =?us-ascii?Q?lK0xNLP4NTf4xX5oximO7aEhvlEu2b3KbNJSypAgIyCT+CJGm76LOnKgw6Z5?=
 =?us-ascii?Q?jO3P3VSsV+8+8zFVLKbYetWVtozQufyq2wN1s2ti1qbOSUTwup0WB/LpPnbf?=
 =?us-ascii?Q?OwDbK7Qa+/d7PSZbTMxTtpy6zIu3nmEufewIFG24hT8ZnpDPp+zwRm5XklVs?=
 =?us-ascii?Q?ZDdFtb17+W1sQwaAx5gmq9FuEXNHluVddl+VIjcfSenq0DlBQmMkDfxm4Qwp?=
 =?us-ascii?Q?lwNR9EnqwqhiQXCmpXiCRyEdg5Lfkj6qUvRRs9WwP1s8UeNimrp4a6ZQVFET?=
 =?us-ascii?Q?oI8lmJxOfchR8m9efl6BkGyZNbg2bMB+8WZspdsheiOprrTYnAf7O1Pf4/dw?=
 =?us-ascii?Q?CJ77/m5xRgT9XfmVX+/kq+qdKq1AUkp2OPHrTtx+hd8vKCELRjKPeLxnOr7V?=
 =?us-ascii?Q?H0PbMc7UY6MqCwoCJQtCSrpM2lQjCcBAW36vUzss5IZxERvjBILKd6IzCCLQ?=
 =?us-ascii?Q?tgl17+pX8xRgFl0PLiYZtOZuiwx7Qb/CM8V0IElWWDukJfLMuo9BKhQuIRbU?=
 =?us-ascii?Q?ptm+nc4GMt3njmn8OUm2Fy9nfT8qpdNhBC/UYiHP9tcGKsaFG5+z++F2+gHS?=
 =?us-ascii?Q?xX7D1lEhg+7I6tcx2Og2cWodc1myB6WWYg66G0LvbIZnlFUzNi2v2q4MDbEW?=
 =?us-ascii?Q?6ufW/SZW7oP6a3nbeiewFeRdB3G6wOM6Cx7GRmC6pj8at0wlJj0o88vpw3SP?=
 =?us-ascii?Q?tqsBMXr0YpZxneLdKe/ncM5SbbZy4psUpJ29ahWyTAA2Ix7es1nCeUPb5wTA?=
 =?us-ascii?Q?FMKKaBKpB+tXSGIo8bxy9KOWfWcGLaCx3v227kPcvJToGXGwEA1XLeqGzeWB?=
 =?us-ascii?Q?ROt00SQY9iFEr+wqo69Nc2plf8HK6yFKqpq16NBByHhz0PvBC8ovXqqaoq2/?=
 =?us-ascii?Q?NDr3XJPSvpZbYOCWlXo/Nw1Bqnwr6eA/eLI9CDzZ7+U51LgQo6PfL0zPdLcF?=
 =?us-ascii?Q?3/gZX5rR4a4J0HDrlEiINpjoumioYkr3V5ua?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd345407-4979-45f4-ca94-08da07522fc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2022 13:37:59.5285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1/5EpPKjP6fcP363O/ztr+cVml4xnnKbEKmLkTEqoRdYeSE1PYdrL4b9gLsDuR9LrtxGvI1UxYbJrl8vPEmjmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0028
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> > Just FWIW this fix that was backported to stable also fixed keyboard
> > wakeup from s2idle on a number of HP laptops too.  I know for sure that
> > it fixed it on the AMD versions of them, and Kai Heng Feng suspected it
> > will also fix it for the Intel versions.  So if there is another commit
> > that can be backported from 5.17 to make it safer for the other systems=
,
> > I think we should consider doing that to solve it too.
>=20
> There is a series of ACPI EC driver commits that are present in
> 5.17-rc, but have not been included in any "stable" series:
>=20
> befd9b5b0c62 ACPI: EC: Relocate acpi_ec_create_query() and drop
> acpi_ec_delete_query()
> c33676aa4824 ACPI: EC: Make the event work state machine visible
> c793570d8725 ACPI: EC: Avoid queuing unnecessary work in
> acpi_ec_submit_event()
> eafe7509ab8c ACPI: EC: Rename three functions
> a105acd7e384 ACPI: EC: Simplify locking in acpi_ec_event_handler()
> 388fb77dcf97 ACPI: EC: Rearrange the loop in acpi_ec_event_handler()
> 98d364509d77 ACPI: EC: Fold acpi_ec_check_event() into
> acpi_ec_event_handler()
> 1f2350443dd2 ACPI: EC: Pass one argument to acpi_ec_query()
> ca8283dcd933 ACPI: EC: Call advance_transaction() from
> acpi_ec_dispatch_gpe()
>=20
> It is likely that they prevent the problem exposed by the problematic
> commit from occurring, but I'm not sure which ones do that.  Some of
> them are clearly cosmetic, but the ordering matters.

Hans,

Do you think you could get one of the folks who reported this regression to=
 do
a bisect to see which one "fixed" it?  If we get lucky we can come down to
some smaller hunks of code that can come back to stable instead of revertin=
g.
