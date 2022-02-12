Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24A44B3354
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 06:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbiBLFyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 00:54:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbiBLFyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 00:54:04 -0500
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2097.outbound.protection.outlook.com [40.92.103.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3131728E3E;
        Fri, 11 Feb 2022 21:54:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5BtT6xgwCU9D1hp12QcGsjCZ6iXyKGgkjmel4An8kJujqP+xlaJHhZ+lJ857VxYLH2qjN6KgybRhpv940lT01DNYlWXkfPNiktltDxSdrrFmBURUMma1SCHVBKxLOR/04cIpFI6PelKGa01bpXpsoc4f/jhe+ILIyj9704nHH/LI1Pk6grzGK5G4Vu553bDBRNvpQFuB8knMsH5jWgW9f9/RwusuBxM+Vn/lbGco6+Etkp4T8zgiWrcNc08SCf6wxA0rCinHq1BQ3vRj1RiSnTKpjAhJe9TfUEzlBJ+qbq2eLrrdgQnNYTt34oQC3XWKw+3TJF4pubxJPeVtVC4eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sx94ROBMcXcKq2p93UbUlS9Oua+LZX/dijFH/i+7Mm4=;
 b=ZkkmrqmFJ6etfRNqrEXyBP9WA+sWvwHMpGCoCfY4px3yLptfmY0R48w3K+/u+HHYVthQei19x/LVOeBpl6VLZVHxCIjMr7NxDg0lf86CVAwdOttf14ScFkTUSReiSJE9rsRYpnvj4PVfZmokG3b2pNV0VE3eB09vlK0wJbV6Nda3Q4ufDVbol0gGhrdu2pK/1JnX8c68B6hukjHWfJfZ5XlTS2OMasmUu8rm4drErigSWDq3uibDmsvlP2ZBs6JHCPiZgrKHod2BQqJtW6KKK5oXx9CcCj59J+T8pMSAT2Z+euxQ+Dr1jCRMXyOkVSqN5I5tzICOpj5P1UNaB3d+zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sx94ROBMcXcKq2p93UbUlS9Oua+LZX/dijFH/i+7Mm4=;
 b=nuYlj+uZ/3rhoDcCuApRlcPgy1Twl4xo1XUQNNvyp7HN71homIL2fe1eNm4TIthJHVZYOPyqH179u7nCnapEQvlSmA49SMJ2UBkqLbVrj86qWFqoVQNlJEBxYrkcibufSaoqmrnxvPy72tOrwb0Yaj5AKxhCWwQKf3Fm380MPQhBumt9ohXzy/SJ8ZW0+UckzmgVCWkrJJGlMF8vpLktcCjXZRI8GpDIddZ+Fwxr+SRj0O3BiifdWdRgKGrgQXAW8miFRWLVvH8kr3TjjkB42ZBI7E8DSaoL8BpnqjbpdlqDOY7AaOedRpcSr/eiH6X/Cc9vhsZXn6qfmd/uX8qYTQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by MAXPR01MB3902.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:64::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Sat, 12 Feb
 2022 05:53:47 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055%9]) with mapi id 15.20.4975.011; Sat, 12 Feb 2022
 05:53:47 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Matthew Garrett <mjg59@srcf.ucam.org>
CC:     Ard Biesheuvel <ardb@kernel.org>, Jeremy Kerr <jk@ozlabs.org>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eric.snowberg@oracle.com" <eric.snowberg@oracle.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "James.Bottomley@hansenpartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "mic@digikod.net" <mic@digikod.net>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Aun-Ali Zaidi <admin@kodeit.net>
Subject: Re: [PATCH] efi: Do not import certificates from UEFI Secure Boot for
 T2 Macs
Thread-Topic: [PATCH] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYHcE4ht34Z1CESEaNjR8+yzmieayLbqGAgAAURwCAAAlIgIAAESOAgACrMQCAAM6NgIAAs3IAgADC6YCAAODbAA==
Date:   Sat, 12 Feb 2022 05:53:47 +0000
Message-ID: <F078BEBE-3DED-4EE3-A2B8-2C5744B5454C@live.com>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <20220209164957.GB12763@srcf.ucam.org>
 <5A3C2EBF-13FF-4C37-B2A0-1533A818109F@live.com>
 <20220209183545.GA14552@srcf.ucam.org> <20220209193705.GA15463@srcf.ucam.org>
 <2F1CC5DE-5A03-46D2-95E7-DD07A4EF2766@live.com>
 <20220210180905.GB18445@srcf.ucam.org>
 <99BB011C-71DE-49FA-81CB-BE2AC9613030@live.com>
 <20220211162857.GB10606@srcf.ucam.org>
In-Reply-To: <20220211162857.GB10606@srcf.ucam.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [KwRip9eU7BJB5OefkSn5Mk37Q6fcHb6CT9pultrrnOEbiPrJaJ1jrLJjWFT/ihKT]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb82397e-62e3-497d-e172-08d9edec0937
x-ms-traffictypediagnostic: MAXPR01MB3902:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PH3r/lVVg3HBEKlVgMSIAqmM+GHn81+HDNBLCYcQMZb1CebsP4+Wa/kSPOF2oWQMMtGaUpM944RbEfFgC0/cY2bhx+i21KBwXy+nJRj+MVbwr49uRytprmqvFhSuZtFcmzeGt4W0Cm64pTT0w/f5MntOYhYK+yGTQa7pq2nCvO774y0cLSCUPgNQHJYJIxm7XKRV3vzO0C1viYnEtjUCO+SAmRVz0BMN6OP5E6ZzaPz9rImROtbHU9vcWJulXo2ZsULe3JJFWI5iCLWlvs/ZN+n2AncB0SWjL8Mf2y3VpBx5izSv8H/NnGkEWpkf8cqGqLRSIYR6CvhXDHHEN0bkuAiO7NZhdz9uDNuFjGmEqKoV5aIxLHBAOekC20WMFNCbbmXfdESw3/L3QjMLKIJDD6S4bDXa4mrn7aIfc5LFynaQxHSsJrAwCoJGFFN83GGquPEGfVidlO29LBYfw5Syz3bp15EtNlbTPoYuPiZvLl4TMoTqHhDKCGpgN2HKaFI2jegvA9Xz+rMmQCe7GEQDGA56uK1ue8/qwlajxpb9nAGddaIJp0c39Fp4DL6aZD7KmiXN01L+l6GdzROHFLvBytq7qcyWDIZYxaursRV02scME0nv4zoypuxxVYrycII7
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q5QYxJVzhkJOdFhgkXpXxHnkBOCQoYSJrk2oHXQD1t3J4eQ8duGL77F/obkg?=
 =?us-ascii?Q?tGl25mdcQEnfpQ14dWgttL+z99hBdP0XhSN1JWXuq4wvUEPwdEEJzZYVnYsx?=
 =?us-ascii?Q?JDVnmopi3yOxD6C77T5B01C6HqIv5I3RDrLSdzbh2RLBDwd2nNiPBgImNHuZ?=
 =?us-ascii?Q?B68tTvrUn8PmWJ6qOfB7X4pMEJ6i4LtFs6maJ86GpbKwoqVnuNcgtk7blprx?=
 =?us-ascii?Q?ckcOiv1aBfnFzhxTRg6NWxbjFkUqbppjGuNXMX+IUSLNvpOYTrgpm0PAnroN?=
 =?us-ascii?Q?cANxGotrtweOF0SdnIPaB18QQ2e9dkCAsVYwudQFLBZYtm7tyAxoyA7E5O9J?=
 =?us-ascii?Q?G9Z41lEL8PlzmQP2sKBS3dK1k3duiylcyoVK1LUm+uQ/Pd9kP1gI5IBMMNxQ?=
 =?us-ascii?Q?ZFCVyXWaqHgeviCMVOyqr9NVL0g8pEuhWxb433BYI9AMFowhiWuttWs/nrnt?=
 =?us-ascii?Q?s20g9FptIdf7vqxoa2PGOFgcn0hbvNQRUA3LcpLkBefm1qokBoZ/FnAuCBXK?=
 =?us-ascii?Q?E/1ObxqnNd6PTl3kxGIOkehOo+Iv0PcJ3YJS9GA+s5bFtbhSfxZ/T3vYYIqG?=
 =?us-ascii?Q?SeyKjMxgkSUfqtlI++uX2DJ5lQv3+JBBEotDcl2fdm/7CWBh+fX2zuGFssZa?=
 =?us-ascii?Q?pkONqkjWC08Gnt+mCLRk+ickBtHXRoQKdx8BMFULLcA6cTMukuhIBrLuQ3wf?=
 =?us-ascii?Q?r2Vr6sH1qF/MbRS/bq/O3QmLB0PXUk9qflOIXw4g20jlB8SwIzDA8rzFGu7G?=
 =?us-ascii?Q?RhchGceRsxzDky3CImYJAY9SrUKS6Skgf11ucuBzEOWU7/oOCnZx0A6Anep3?=
 =?us-ascii?Q?npzWAkafdgc+XY+cAWUz1iEwDQwb+0wr0MDyIosaQ4qNOo64FftCUaXi64li?=
 =?us-ascii?Q?7uX9wRXOLzuA2Vw1EqqNech4RI9BJHEd46+m4nETGiJm68EhxVwsYnLOlCV3?=
 =?us-ascii?Q?F3BU92TgaK+Ob0W648FMNe+/A09eYI8V8ssY50ZFGe/0HvRv0G0B1XgXi1/a?=
 =?us-ascii?Q?6FX85Rm7WsFRDa9Bn5yQ3ojKhA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <402E8CCB90284142BB8E8C90A4791469@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: eb82397e-62e3-497d-e172-08d9edec0937
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2022 05:53:47.1734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MAXPR01MB3902
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



>=20
> Oh gosh I'm an idiot. Please try this one instead.
>=20

Looks like EFI variable MokIgnoreDB-605dab50-e046-4300-abb6-3dd810dd8b23 an=
d EFI variable db-d719b2cb-3d3a-4596-a3bc-dad00e67656f are causing issues

Feb 12 11:01:52 MacBook kernel: Reading EFI variable MokIgnoreDB-605dab50-e=
046-4300-abb6-3dd810dd8b23
Feb 12 11:01:52 MacBook kernel: Reading EFI variable db-d719b2cb-3d3a-4596-=
a3bc-dad00e67656f
Feb 12 11:01:52 MacBook kernel: ------------[ cut here ]------------
Feb 12 11:01:52 MacBook kernel: [Firmware Bug]: Page fault caused by firmwa=
re at PA: 0xffffbc34c0068000
Feb 12 11:01:52 MacBook kernel: WARNING: CPU: 7 PID: 98 at arch/x86/platfor=
m/efi/quirks.c:735 efi_crash_gracefully_on_page_fault+0x50/0xf0
Feb 12 11:01:52 MacBook kernel: Modules linked in:
Feb 12 11:01:52 MacBook kernel: CPU: 7 PID: 98 Comm: kworker/u24:1 Not tain=
ted 5.16.8-t2 #2
Feb 12 11:01:52 MacBook kernel: Hardware name: Apple Inc. MacBookPro16,1/Ma=
c-E1008331FDC96864, BIOS 1715.81.2.0.0 (iBridge: 19.16.10744.0.0,0) 01/06/2=
022
Feb 12 11:01:52 MacBook kernel: Workqueue: efi_rts_wq efi_call_rts
Feb 12 11:01:52 MacBook kernel: RIP: 0010:efi_crash_gracefully_on_page_faul=
t+0x50/0xf0
Feb 12 11:01:52 MacBook kernel: Code: fc e8 44 30 03 00 49 81 fc ff 0f 00 0=
0 76 08 48 3d 50 04 3c 9b 74 04 41 5c 5d c3 4c 89 e6 48 c7 c7 c0 00 7c 9a e=
8 69 71 be 00 <0f> 0b 83 3d 87 62 11 02 0a 0f 84 0a 62 be 00 e8 bc 1b 00 00=
 48 8b
Feb 12 11:01:52 MacBook kernel: RSP: 0000:ffffbc34c03f29d8 EFLAGS: 00010086
Feb 12 11:01:52 MacBook kernel: RAX: 0000000000000000 RBX: ffffbc34c03f2a18=
 RCX: 0000000000000000
Feb 12 11:01:52 MacBook kernel: RDX: 0000000000000003 RSI: ffffbc34c03f2820=
 RDI: 00000000ffffffff
Feb 12 11:01:52 MacBook kernel: RBP: ffffbc34c03f29e0 R08: 0000000000000003=
 R09: 0000000000000001
Feb 12 11:01:52 MacBook kernel: R10: ffff9f6801685640 R11: 0000000000000001=
 R12: ffffbc34c0068000
Feb 12 11:01:52 MacBook kernel: R13: 0000000000000000 R14: ffffbc34c03f2b68=
 R15: ffff9f6801233380
Feb 12 11:01:52 MacBook kernel: FS:  0000000000000000(0000) GS:ffff9f6b6ebc=
0000(0000) knlGS:0000000000000000
Feb 12 11:01:52 MacBook kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080=
050033
Feb 12 11:01:52 MacBook kernel: CR2: ffffbc34c0068000 CR3: 00000001001ec002=
 CR4: 00000000003706e0
Feb 12 11:01:52 MacBook kernel: Call Trace:
Feb 12 11:01:52 MacBook kernel:  <TASK>
Feb 12 11:01:52 MacBook kernel:  page_fault_oops+0x4f/0x2c0
Feb 12 11:01:52 MacBook kernel:  ? search_bpf_extables+0x6b/0x80
Feb 12 11:01:52 MacBook kernel:  ? search_module_extables+0x50/0x80
Feb 12 11:01:52 MacBook kernel:  ? search_exception_tables+0x5b/0x60
Feb 12 11:01:52 MacBook kernel:  kernelmode_fixup_or_oops+0x9e/0x110
Feb 12 11:01:52 MacBook kernel:  __bad_area_nosemaphore+0x155/0x190
Feb 12 11:01:52 MacBook kernel:  bad_area_nosemaphore+0x16/0x20
Feb 12 11:01:52 MacBook kernel:  do_kern_addr_fault+0x8c/0xa0
Feb 12 11:01:52 MacBook kernel:  exc_page_fault+0xd8/0x180
Feb 12 11:01:52 MacBook kernel:  asm_exc_page_fault+0x1e/0x30
Feb 12 11:01:52 MacBook kernel: RIP: 0010:0xfffffffeefc440c5
Feb 12 11:01:52 MacBook kernel: Code: 31 c9 48 29 f9 48 83 e1 0f 74 0c 4c 3=
9 c1 49 0f 47 c8 49 29 c8 f3 a4 4c 89 c1 49 83 e0 0f 48 c1 e9 04 74 2c f3 0=
f 7f 44 24 18 <f3> 0f 6f 06 66 0f e7 07 48 83 c6 10 48 83 c7 10 e2 ee 0f ae=
 f0 66
Feb 12 11:01:52 MacBook kernel: RSP: 0000:ffffbc34c03f2c18 EFLAGS: 00010286
Feb 12 11:01:52 MacBook kernel: RAX: fffffffeefc9205a RBX: ffffffff9a81787a=
 RCX: 0000000000000033
Feb 12 11:01:52 MacBook kernel: RDX: ffffbc34c0067d20 RSI: ffffbc34c0067ff6=
 RDI: fffffffeefc92330
Feb 12 11:01:52 MacBook kernel: RBP: ffffbc34c03f2ca0 R08: 0000000000000001=
 R09: ffffbc34c0068326
Feb 12 11:01:52 MacBook kernel: R10: fffffffeefc8e018 R11: 000000000019f2a5=
 R12: 0000000000000000
Feb 12 11:01:52 MacBook kernel: R13: ffffbc34c0067db0 R14: ffffbc34c0067d01=
 R15: 0000000000000607
Feb 12 11:01:52 MacBook kernel:  ? __efi_call+0x28/0x30
Feb 12 11:01:52 MacBook kernel:  ? switch_mm+0x20/0x30
Feb 12 11:01:52 MacBook kernel:  ? efi_call_rts+0x20d/0x970
Feb 12 11:01:52 MacBook kernel:  ? process_one_work+0x222/0x3f0
Feb 12 11:01:52 MacBook kernel:  ? worker_thread+0x4a/0x3d0
Feb 12 11:01:52 MacBook kernel:  ? kthread+0x17a/0x1a0
Feb 12 11:01:52 MacBook kernel:  ? process_one_work+0x3f0/0x3f0
Feb 12 11:01:52 MacBook kernel:  ? set_kthread_struct+0x40/0x40
Feb 12 11:01:52 MacBook kernel:  ? ret_from_fork+0x22/0x30
Feb 12 11:01:52 MacBook kernel:  </TASK>
Feb 12 11:01:52 MacBook kernel: ---[ end trace c81d89c8fdfe87c4 ]---
Feb 12 11:01:52 MacBook kernel: efi: Froze efi_rts_wq and disabled EFI Runt=
ime Services
Feb 12 11:01:52 MacBook kernel: integrity: Couldn't get size: 0x80000000000=
00015
Feb 12 11:01:52 MacBook kernel: integrity: MODSIGN: Couldn't get UEFI db li=
st
Feb 12 11:01:52 MacBook kernel: efi: EFI Runtime Services are disabled!
Feb 12 11:01:52 MacBook kernel: integrity: Couldn't get size: 0x80000000000=
00015
Feb 12 11:01:52 MacBook kernel: integrity: Couldn't get UEFI dbx list
Feb 12 11:01:52 MacBook kernel: integrity: Couldn't get size: 0x80000000000=
00015
Feb 12 11:01:52 MacBook kernel: integrity: Couldn't get mokx list
Feb 12 11:01:52 MacBook kernel: integrity: Couldn't get size: 0x80000000000=
00015
Feb 12 11:01:52 MacBook kernel: integrity: Couldn't get UEFI MokListRT


The full journalctl log is here on https://gist.githubusercontent.com/Adity=
aGarg8/8e820c2724a65fb4bbb5deae2b358dc8/raw/c71e13036426211cbd590fdfabe5f88=
531bac645/log.log


With CONFIG_LOAD_UEFI_KEYS=3Dn, these variables are not seen and EFI Runtim=
e Services work.=
