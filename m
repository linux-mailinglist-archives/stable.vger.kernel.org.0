Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529D833EEAD
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 11:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhCQKsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 06:48:15 -0400
Received: from mail-mw2nam10on2085.outbound.protection.outlook.com ([40.107.94.85]:32320
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230346AbhCQKsC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 06:48:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A+jT3bj9REKrlJrdSYOWlS3q3tdVHTHwdDFJJlYBEhqCBshGXjDFY53cn2+35Y/pNCUp6k129E+DFGta+D7pMi1Dw+eWLCMbp9pbYc6n8EsLTedv3baTTeaUeDBpo5N95fx8ug0fYfszRwRrzlD2rANMaRK7AeK+HCWVcumLXj40E5obEdXe0QKLpQdNTTUWfHUg8CwI/tuqTdEWHRKsul9xAcUZzFFacrXMXjyv6ls6fxrA+jvfPbHhfQnWBb/bprKNdUub/VAW+AhpHmw5AGMXDKoxw3ljTbzGHRdZwRw3Mx0pqEXTzx/OEQnKHPnkMTjH80Ll83bu90yF8Dtawg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkaBXnLcL6uwF4bis8UzVH0TXclV33vNF9rElS27uX8=;
 b=H+P2kO3ZTw/FwL9y536D0AsL7RPfvol6CApxWbnPLchnZatvoMpvoVJj+15YAsHPyCLB/gQ4mt96a0p+4Y1mLwtlWY5iXPBcEcZHsY8MMkh0z+a27UFuoI3P4HnwhV87Hrn772Ev8jG17UuR52/KVe8AtXxxIOgpHOunoPJKb1BBM+7OjyOkvM5IBNgZkZiOxnu25hpOcDWplsCe7qgmOT7Ny4Y4IKgcVuKmHkmcy7FYZmRhXhdVR0Wamsm1sU0aP6sUMxtQRsPy+6xg6NPDP5AU8mA5VTwlh9jMvFsXEgwQj5MuHcbk0H2FDu/F2ho9BoIl/MAkIbJEW4vYqebOWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkaBXnLcL6uwF4bis8UzVH0TXclV33vNF9rElS27uX8=;
 b=wB0UEbT79ELX3Wbfnl+/fkGkJpu5kd7MhRhL3sgtnLhKUU9bQQwIlryXln4kcXAlJ2Kpb6xcN4CIrGpv/k4W77I71+OBNlcX6wqaU9KaswXL5ZuUACKaWND+9aVnDbMfoLFdrCILRJURXTPP3vSTVaglVR36pe82K+3K1iDWSn0=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21)
 by MWHPR12MB1790.namprd12.prod.outlook.com (2603:10b6:300:109::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 10:47:59 +0000
Received: from MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::5094:3a69:806f:8a28]) by MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::5094:3a69:806f:8a28%5]) with mapi id 15.20.3955.018; Wed, 17 Mar 2021
 10:47:59 +0000
Date:   Wed, 17 Mar 2021 18:46:56 +0800
From:   Huang Rui <ray.huang@amd.com>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Du, Xiaojian" <Xiaojian.Du@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] iommu/amd: Fix iommu remap panic while amd_iommu is set
 to disable
Message-ID: <20210317104656.GA2508995@hr-amd>
References: <20210311142807.705080-1-ray.huang@amd.com>
 <YFCvsort3oZGfDBy@suse.de>
 <20210316133602.GB2497230@hr-amd>
 <YFDICtszzhFzX8cH@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFDICtszzhFzX8cH@suse.de>
X-Originating-IP: [58.247.170.245]
X-ClientProxiedBy: HK0PR03CA0119.apcprd03.prod.outlook.com
 (2603:1096:203:b0::35) To MWHPR12MB1248.namprd12.prod.outlook.com
 (2603:10b6:300:12::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from hr-amd (58.247.170.245) by HK0PR03CA0119.apcprd03.prod.outlook.com (2603:1096:203:b0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 10:47:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ca33137b-cea6-487a-a6bd-08d8e9322108
X-MS-TrafficTypeDiagnostic: MWHPR12MB1790:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR12MB1790A718EDED6D72574726C1EC6A9@MWHPR12MB1790.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d8iJGyBavNDd7TO9YUvoiy2pTElrRRNMsQVyDAPyu6o8hRZ1UXe6qAzWEIsbt0PCwXLvUCMUqE4SPX5qYIcx6jdIgsELywAZh0mfQSn/oXKMdbp/gbLkvWiVLWarzwARyeesmNs/3YjracmXRs5SYXC4EUsNzyiUCOb1NzFb6UWGKrXaLjaild5iWER98u1jn71is7uN6c60ctK+LrtjckoyBTGsp6J9ooh4iwPBlQS1Iid6FmWZSsmF9WaYSMvE+SL+thYHEruyJPM9lJdoOCmTX+zWQzPV7k2yYM7FkWW+NV4cc/aO1AsIPkSr2UZz3JoXwn6TpQCMRftKTCshnhNY/D37YCsBOt3CVutHpgOrTEc5l4b4ReyDMVQu19q4hdAV/aU59eV4NQh4OgfGCZWC2xcaZtlWE7IHnbMENax4GkVOuKJeZDMKqzumpATR4tKySScvg9hTKRx4FldjLs5SgEXMGRdHnJuuBalEDcaas3EaVVcPyhj9/glqYZbgvMZ5tYaNQPMFKTRTErcdqF+J701vtX0+RrgzXxGJThretNX+3kys/rfEgBWJIhCP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(316002)(66476007)(6496006)(26005)(66946007)(956004)(33716001)(55016002)(33656002)(8676002)(83380400001)(8936002)(186003)(16526019)(66556008)(52116002)(478600001)(6916009)(4326008)(1076003)(5660300002)(2906002)(86362001)(54906003)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?l6Y2H2CJ7KpKdZbRYjevIBUSO97dnPSmgDFpBrx9ohr0zyGiHObl7Q1rFwdc?=
 =?us-ascii?Q?KgHdgCthjMHyKdo9Jqbw2GIcUxiH4CIC/Gy8aMHV863RggDvxW7lL7kEHZd7?=
 =?us-ascii?Q?J/+fLPTzRevckx2dgCWIPTyY5leKeXF1J9UXpv+ooCNQPezrSStL+JJ6cNC1?=
 =?us-ascii?Q?LpHgqoH1vhxhyAmVQSvI745oMdbeKwh790H/CLGWzXYW6IsqE02AE1ToyGng?=
 =?us-ascii?Q?9/HU4kZSUTolDb76SRhi96srHIBwRrYceR9A/rymS5dTdY4pislHfWxmSOUY?=
 =?us-ascii?Q?tLNENP6OuwFxYqhLreJ5aoNrZyx+HBypczE69lNjAlNlrwf3GObz08fR1tUb?=
 =?us-ascii?Q?kUunLORJktF6bmFIxgyjCKqkthurR/E2Y0ty2OGI7edWtWI/zZ0fxukDmVNo?=
 =?us-ascii?Q?s2z7aqcresti38oZqxgoAusG+TxVglsZ+byrtBnIGOU0xWhWbYn0otdvqbRb?=
 =?us-ascii?Q?AE5s1SYYuwkiV+nlX8Fu0rwDQnr7vr97ZLIf94uJdv4upj5TCwYAlotBPEdU?=
 =?us-ascii?Q?UosJGJtfX7O449Sxvxm4NOl7kIfNxSlN/lXek7Xnfy3W8AYC6NCGYOkuYJjE?=
 =?us-ascii?Q?0fS8Cj0DZ3nceaKgdjjfq3o00BY27Af3Rg/m5nldXe6vueB6jhpiaazdopEe?=
 =?us-ascii?Q?OcQpaq/DpncE4iEj5rq3OOQ6o3sjXn4ZjW0TXdvW8oKT6BIx5Ep4t/IKlZcm?=
 =?us-ascii?Q?/ztWXAxKwr6p25dRHhTPN/QfM8yGdQwvE6+4UL0b/GAq8ivRyFuygGlMRxoS?=
 =?us-ascii?Q?XBQzxePttulFccwQITV6SHmEbiGZo5mZjgAasJgyGiBS+XrGns9KYGZ2OrOV?=
 =?us-ascii?Q?pL7YhSg9upHJFtP14xeGe2fSTF5XfQ490KTnWWwZepDXNDs31mHqBVyMxLoy?=
 =?us-ascii?Q?dkE1hCkNW8eFkqQ8hnBWlgq1tNkG1LZsyA82gSQIuyoI8kVBdFWPlBVxZAJ2?=
 =?us-ascii?Q?zWOwi7eUDLK1wIhHQRz9No+Okq69Ofda7tK+L3s8nvXJ6gO5RhJYUDREzKla?=
 =?us-ascii?Q?DWek5LISbOj7jCxtNIeDjg59ehPhnK2IJrD7Pokfx2+Z9dirnxvT6QTTPFM4?=
 =?us-ascii?Q?qlilyV8u2JFvwzsc9cVLb2fsPAGabH4wRIws9jpNnv9J1js0jvx66wRYPSXF?=
 =?us-ascii?Q?5ZAsrgMlSXm7EjoVC7UaeYeG3msFarj2M7dQ1jhlH6bgc2h4UUqLjNkQ79WA?=
 =?us-ascii?Q?0BH3cFhWz5ADDTE1mIBO5BF3O+63dkShTL/vWPjxw+Wbu04UHw2pr1HZSo1q?=
 =?us-ascii?Q?9RxJOR7z7w03tAeHf/jgj3PzbFlAS91O81+mskbrpU874D60i0BEieyP46OW?=
 =?us-ascii?Q?WjIq7Tz0OVF3ew7dITCQPDuR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca33137b-cea6-487a-a6bd-08d8e9322108
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 10:47:58.8365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VjsXGL6xxw8RGroOTBI4u+r42T0m7iM2TM5GbQ9i3XANRp4STKaIU9WGtVuO8fvk7yRo6BP6Mvz0zC7ei/42Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1790
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 11:00:26PM +0800, Joerg Roedel wrote:
> On Tue, Mar 16, 2021 at 09:36:02PM +0800, Huang Rui wrote:
> > Thanks for the comments. Could you please elaborate this?
> > 
> > Do you mean while amd_iommu=off, we won't prepare the IVRS, and even
> > needn't get all ACPI talbes. Because they are never be used and the next
> > state will always goes into IOMMU_CMDLINE_DISABLED, am I right?
> 
> The first problem was that amd_iommu_irq_remap is never set back to
> false when irq-remapping initialization fails in amd_iommu_prepare().
> 
> But there are other problems, like that even when the IOMMU is set to
> disabled on the command line with amd_iommu=off, the code still sets up
> all IOMMUs and registers IRQ domains for them.
> 

Yes, that was the problem I found in my side. No very clear about the
orignal intention. But if you said this is a problem, that makes sense...

> Later the code checks wheter the IOMMU should stay disabled and tears
> everything down, except for the IRQ domains, which stay in the global
> list.
> 
> The APIs do not really support tearing down IRQ domains well, so its not
> so easy to add this to the tear-down path. Now that the IRQ domains stay
> in the list, the ACPI code will come along later and calls the
> ->select() call-back for every IRQ domain, which gets execution to
> irq_remapping_select(), depite IOMMU being disabled and
> amd_iommu_rlookup_table already de-allocated. But since
> amd_iommu_irq_remap is still true the NULL pointer is dereferenced,
> causing the crash.

OK. We found some memleaks here before as well. It looks cause by iommu data
buffer initialization and not be cleared. And yes, if setup iommu here, it
actually causes many issues.

unreferenced object 0xffff888332047500 (size 224):
  comm "swapper/0", pid 0, jiffies 4294892296 (age 362.192s)
  hex dump (first 32 bytes):
    b0 22 03 00 00 00 00 00 00 00 00 40 00 00 00 00  .".........@....
    06 00 00 00 00 00 00 00 00 20 00 00 00 20 00 00  ......... ... ..
  backtrace:
    [<000000008f162024>] kmem_cache_alloc+0x145/0x440
    [<00000000420093ba>] kmem_cache_create_usercopy+0x127/0x2c0
    [<00000000f5ed7ff0>] kmem_cache_create+0x16/0x20
    [<000000004c1e4f47>] iommu_go_to_state+0x8e4/0x165d
    [<00000000a191b705>] amd_iommu_prepare+0x1a/0x2f
    [<00000000afe5b97e>] irq_remapping_prepare+0x35/0x6d
    [<00000000209f36b5>] enable_IR_x2apic+0x2b/0x1ae
    [<00000000b64491b5>] default_setup_apic_routing+0x16/0x65
    [<00000000e89c64a1>] apic_intr_mode_init+0x81/0x10a
    [<00000000eaa14bf6>] x86_late_time_init+0x24/0x35
    [<00000000e291fc71>] start_kernel+0x509/0x5c7
    [<0000000099930dfe>] x86_64_start_reservations+0x24/0x26
    [<00000000b369765d>] x86_64_start_kernel+0x75/0x79
    [<000000004f411919>] secondary_startup_64_no_verify+0xb0/0xbb

> 
> When the IRQ domains would not be around, this would also not happen. So
> my patches also change the initializtion to not do all the setup work
> when amd_iommu=off was passed on the command line.
> 

Thanks for the fix and explaination. :-)

Best Regards,
Ray
