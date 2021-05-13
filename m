Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4D437F5D2
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 12:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhEMKrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 06:47:39 -0400
Received: from mail-mw2nam12on2070.outbound.protection.outlook.com ([40.107.244.70]:24961
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231282AbhEMKre (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 06:47:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVw+Hew3KC/Fwphb2Emp8vR62+BGe1Al3Wsodfz+KQyPxaLCWYXddaBjT/uVz+BXt8l1UFVda1nx+mBDpWrOiCAq/CEUrfIYFgqC/J+Au867b6gZdRwVNtaR6QWPizreCm5Xmj78Se4/b1Wls3SR7mOcVwTlB5HC/kYmIMB3wW6eMmeyvU9UdGA0jr3LTGI2xD2jfDkMLyKg+YvxBEDKvWOtQ9vDyZLMsvNTbRIXwDmWDx01qQATMAl8fBKemK8u5XXQiwvuvaOfdb78tIe+pNTyzPC+0zshD6sdRXYONE3/O9ort03NRanvQqrjZkwmdiKxqA6+vmVQP+4W9PAEMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3K9t0uFAcoPNZT/yViVJNQEKykoyJNvUFjcshItU/z0=;
 b=Gw8mPe5zU6B1jWx0F1aXNQOS6nI8qcuqUXlTT9YStuTzfCvutVaPYboiBlfkqz7zC2dizGtoWcgAbPsUqBu3+fajIUiU6aktQt4bPDXqFP+pv7YT1FyLqIjRh4j+7wo15FFCCpgFBLkrSKsB2FjqDiqYsayiHZ9kw7NkZLJ8ggyRetbHPaYPGS9o4SHG0ef9/taVTX1D6HfGudVKOv6i52PmoreGlrXcXzDhOIvCkAxkuAtjBEKTbH5XDldOA3sP0F2TcKDkzvK+yxX2JEdUfT1z61nM3Wy/t9ho3sC9+hTDRYXyfu0Qz1upBvjHkc05Dxy0kayfD0vbv3JHAcufmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3K9t0uFAcoPNZT/yViVJNQEKykoyJNvUFjcshItU/z0=;
 b=1dW43NqUoFUUVWr/CFIK9YTsskUPji4deKbsIBes0QAv/d5zz2SWjvYeT25mxUam08Qn6aEAd3/GaTn/0r/PzhcO1x09p5+8/+6wegRn4FwIDOEbIyN2HsNW/gPrVoVNfxqFI+ojYI7FJqeM+NGo3ekotBcu3o/zXF1n8tDxuh8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21)
 by MW3PR12MB4506.namprd12.prod.outlook.com (2603:10b6:303:53::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Thu, 13 May
 2021 10:46:22 +0000
Received: from MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c]) by MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c%4]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 10:46:22 +0000
Date:   Thu, 13 May 2021 18:45:55 +0800
From:   Huang Rui <ray.huang@amd.com>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Alexander Monakov <amonakov@ispras.ru>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        "Fontenot, Nathan" <Nathan.Fontenot@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4] x86, sched: Fix the AMD CPPC maximum perf on some
 specific generations
Message-ID: <20210513104555.GC1621127@hr-amd>
References: <20210425073451.2557394-1-ray.huang@amd.com>
 <alpine.LNX.2.20.13.2105130130590.10864@monopod.intra.ispras.ru>
 <YJxdttrorwdlpX33@gmail.com>
 <20210513042420.GA1621127@hr-amd>
 <YJz7fp17T1cyed4j@gmail.com>
 <YJ0BzPs0WPJ42qG1@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJ0BzPs0WPJ42qG1@gmail.com>
X-Originating-IP: [165.204.134.251]
X-ClientProxiedBy: HKAPR03CA0011.apcprd03.prod.outlook.com
 (2603:1096:203:c8::16) To MWHPR12MB1248.namprd12.prod.outlook.com
 (2603:10b6:300:12::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from hr-amd (165.204.134.251) by HKAPR03CA0011.apcprd03.prod.outlook.com (2603:1096:203:c8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Thu, 13 May 2021 10:46:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba3e9820-14a9-4729-5656-08d915fc5910
X-MS-TrafficTypeDiagnostic: MW3PR12MB4506:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR12MB45063FB1D22F2E5ECBDFCCE8EC519@MW3PR12MB4506.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YaUJiltf6JrkaRG9rvlNRZkYT7JBSpc1G2i2fHNopYvOF9or/QgCPxhK6TAC0MipvwaP/rkw1h161K2dc5vF03nTlN3ocpZ5jYHz5jFOVGIPxwAJUwDu+PhiaaZ3amrkJNHibqW1N2f+K173nZFcYQrwzdP3FQ4SowPQfddN2QJNdCRCay+B5LewnISPgI7lMPX3MCCYhn37QLQ/vA3imfdx8jRh6+TSq+oW7+EcqAcWUv5LRMkdQY4tqHjomBuoAE1MKK6vyX82VTQLdf5Y2YK+NmtqCVQPJur9MNryF0prfWsdfpLVgCZQV2/3fAesoTgU+hYvpUhi0c9jJxFHHg4zQr2OqmrZRxp8vI4ehhESEXDrPjXbWaKhOnF2KF6H+heg9uW/vLyscc2p17Erhw/06xVltAeCozn9rFDBAlXo0wHywlzmGY6MZ2U1qrgP6j9jfyOkthi0dJo6RYEGaQryBbRW8cc0VAjXlz882X/hCfxVdEKB73x8U8a6LjJa1HVIlOmQ87Ro7p4SWQZfGTRKrwHnrKYd2RsBqiW/fNGRvQv3MP1aEYaxygXOdbFqyHrclLoiCGB5rQmf2pTRi3isKkp3Fg9dA4FAedBWkGj7AZNbIlr1h/RzmF8cHkyrlb7LEX4ExlAbHA6fa1DcKK2bRDyJAV5BkC8hmVwP/bg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(4326008)(66556008)(4744005)(956004)(8936002)(7416002)(38100700002)(1076003)(6916009)(5660300002)(33656002)(2906002)(26005)(33716001)(54906003)(52116002)(55016002)(9686003)(38350700002)(478600001)(8676002)(83380400001)(6496006)(86362001)(6666004)(16526019)(316002)(66946007)(186003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uZDyLgmFaER01cG504GOfTnF1Aw1h1iKpFpTrtPmp2Ew67iBdgwmaCF0mjmT?=
 =?us-ascii?Q?m+3hwWxcmmfze75IXd8BG036z9KDAXFdgwkSI3UoaH2cnVv/kVRkJtketm4j?=
 =?us-ascii?Q?Lw8b7sa5b32LZmOt/j+86eFiIZTFvPU8cTUmjtrmBu6yhqTUdP4jnz2F/LiR?=
 =?us-ascii?Q?LjodPES6NpvqcZIdB6b93Fsf5B5eM8zzb41FJYLGOVoFmQfmryQ63vLkEehT?=
 =?us-ascii?Q?7JfxkiBRVfjfxYfHHwOHkohcG5vmH4yQwP6c6JrzsFSbXT72Ift0WZJ/09md?=
 =?us-ascii?Q?j/yaaOUtSOFGaFZxVXpcFfZ9auTRyQht0EqPaSzxWR3E+67dQqWIA9L9ZIgN?=
 =?us-ascii?Q?fbVUKhi1R/W38qDvEHXE+J1xpDIlxCbkyrBlj2ZXfLc8hhBPDfoRWTL9QQXk?=
 =?us-ascii?Q?NQq4r98AgCzw2KUn+siPii9gFXzLgms/nhPCssjo9sEufr8Mz0fujyZr5Pi5?=
 =?us-ascii?Q?z9ZJhwefUPHhKy5jZLPrQwgAz+qlTD8mF0vEwwZO1SKY71CAmqdjAo6o/I9X?=
 =?us-ascii?Q?Izau1ZDnxo4USsRVNr5StAmHIuotfwqBU1LyOiWJQ1fl5SuDKehUkAiDPB5U?=
 =?us-ascii?Q?vm4HgRoOopWDMS7iM/kEV4IN72plAqCHbCsbAWWYcdD7TsKpfYPlob/+d14v?=
 =?us-ascii?Q?eqD4QK3COe3HbG849RJW7rIOd5O1emYTlWLSZowtbSYGmHQ/ElPKOo+aqK+m?=
 =?us-ascii?Q?TEqZE9gw5nL+UuF9Vhxj5MznkjLBT6e0xFdX9sTvS8dcTvvYLvfdHJe5+B3N?=
 =?us-ascii?Q?z251RIOJcuSHG0vImuOvhnU5rhBqgUQeA8c6ntc9fcX9nNl7WgR8UDJtYwp3?=
 =?us-ascii?Q?WZkXb71BJxPVO9RTtypIchjcZyiqD1dzSjC4MMvaJvLdHIQDgywQuuakPpV6?=
 =?us-ascii?Q?M+WGc13brEZGQyuB9NGKrATChlqx2X0xaMV7ApAzBAnE0DIEF/6NoRnRPlPK?=
 =?us-ascii?Q?q5xec8wlJo9enCEJv8R7erKm5QTIXjOr0tiKEz9V/ZGAdM6GruLL5b6mE0/k?=
 =?us-ascii?Q?yovu/czIzfknyB5qmvGjV4Wu2FCoHMG9QVU9FvEGsD76U7aj9SsZFDmhM3C2?=
 =?us-ascii?Q?uU0HLL98q5NMfc+ZV8m0L2sIVDdRrpmjcP9H3zjM7VE7i7U+EV5QJMGddvOl?=
 =?us-ascii?Q?NJPxwNqCZgH5imNA90N0tGtk19laZ6IsmtgLNNFOGL03KdT/b4s/NchOVmPj?=
 =?us-ascii?Q?O3HKe5lwNnPDlHEQd+9+27eKjddr6wTxt6zNuUBXo37HMqwvMJMb5eBbv3ad?=
 =?us-ascii?Q?+9jyc6Dv/gbV039AbK7PSPX7ve/vSDDPD7uqHaptiD6l+DEvlTPqhFoVrEJk?=
 =?us-ascii?Q?llKsTnD468TmSZwmUxsUihAT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba3e9820-14a9-4729-5656-08d915fc5910
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 10:46:22.1609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cbRR80es0vyPkOm6pEaV2lzK+OlpdbakQXT4I1ZSCe1zx1ErwlYA+zbwT/rIz1e5A4KA2h+4TYPG3Qfy3rXwAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4506
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 06:39:08PM +0800, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > No need to send v5, done!
> > 
> > I have a system that appears to be affected by this bug:
> > 
> >   kepler:~> lscpu | grep -i mhz
> >   CPU MHz:                         4000.000
> >   CPU max MHz:                     7140.6250
> >   CPU min MHz:                     2200.0000
> > 
> > So I should be able to confirm after a reboot.
> 
> 'CPU max Mhz' seems to be saner now:
> 
>   kepler:~> lscpu | grep -i mhz
> 
>   CPU MHz:                         2200.000
>   CPU max MHz:                     4917.9678
>   CPU min MHz:                     2200.0000
> 

Yes, happy to know this :-)

Thanks,
Ray
