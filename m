Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F2E374DD8
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 05:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhEFDNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 23:13:10 -0400
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:61761
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232750AbhEFDNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 23:13:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BicLf7rtJE/dxjewlxzlDErfuLqrtvktBE0xJWCtK53pgB461eSBhjsdhbg2fsAE+UGQg7OVnD0SeQpZsqRUc4snTpfVon7Fhnx7zi+tq4jZk6XAsIqc6342uCyC7RI2VuKpBv32xZXzaSZsIm7406E+REDEFzZqM/XUcgNAuXhyM68wsMIn9pcTNhsl980sFVdQuuySvzSqQ+KaCg6yf4fl5i6b60pXkWfilWHkO9zwWBm/l3yz2cq/1j2WpbM+QC32mRbx9XkxCRNXrEt3QZxaMub6btUqDbIQz5d0cahxLC7LCgmMjITQXZaXPNlFuGoImsBgxNAF8Yo5GAjRfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVAPxv0D2/2ISPfbA+qrPbZqQJmVqkzmkJdrkxNeuxU=;
 b=iO/875nyCL/+/MWnCRVGR8MBUIOr5oMw2XzoDEckui1zF8HPuVXFcfiEm6kZrRaiVohQtpEIF5pXf/v6vXe4XKR2RRd8lzpGrpiF5bPzgHgDJ9IANUyY/J+ya9/Ua2NEkuoKzmzMY88sXWw+hfEr6X+4qMdhJ/JmXc/Qf4KlXERed2lvol7NMdLLUsEiLs1BQXJS4LRVaR12J1xS7wZ74igAsL44Gz3i78khxrzuvjO3XqbfiKVUwaTxGlV0d9pVTKmzWdNP5+RnTBbWt0VxzDIJzik+jKkjm4AEMzTbZ9Q/9QR8y+1/lXn5r63IYHpHsXiRnbY2p1Wv3XevwDd+Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVAPxv0D2/2ISPfbA+qrPbZqQJmVqkzmkJdrkxNeuxU=;
 b=EJ6VIGaji94W8KYRdlsBGmnrp3UAOLVk5tc8THdPfCtU0DbswacAQEj4OdjeAxk8TBvFrmxhtzEu9am3/ayE6tqPF4C8/aDPANtEGQNzh0MRA5rM32bChgQidSWZBER5rml+INAbgDiKK/h+ydbE2uaLA2nNx7xiueW7oUc3GbY=
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BYAPR12MB2792.namprd12.prod.outlook.com (2603:10b6:a03:65::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Thu, 6 May
 2021 03:12:09 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::ac06:4fe4:c52f:bdd7]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::ac06:4fe4:c52f:bdd7%7]) with mapi id 15.20.4087.044; Thu, 6 May 2021
 03:12:09 +0000
From:   "Liang, Prike" <Prike.Liang@amd.com>
To:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "Chaitanya.Kulkarni@wdc.com" <Chaitanya.Kulkarni@wdc.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: RE: [PATCH v5 2/2] nvme-pci: add AMD PCIe quirk for simple
 suspend/resume
Thread-Topic: [PATCH v5 2/2] nvme-pci: add AMD PCIe quirk for simple
 suspend/resume
Thread-Index: AQHXNxWJtr80iBIQkEK5D5f1dfi8r6rV2/sQ
Date:   Thu, 6 May 2021 03:12:09 +0000
Message-ID: <BYAPR12MB32386C5B8CAF7E49DC248EA1FB589@BYAPR12MB3238.namprd12.prod.outlook.com>
References: <1619054346-4566-1-git-send-email-Prike.Liang@amd.com>
 <1619054346-4566-3-git-send-email-Prike.Liang@amd.com>
In-Reply-To: <1619054346-4566-3-git-send-email-Prike.Liang@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=fc18d40c-9c02-4f79-a716-4a4ba765797a;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-05-06T03:11:42Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=amd.com;
x-originating-ip: [139.227.235.92]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ebe41f7-d5ae-4605-7921-08d9103cbc53
x-ms-traffictypediagnostic: BYAPR12MB2792:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2792ED69420AEEAE12DE75F0FB589@BYAPR12MB2792.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:597;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 32sSfVjQTe9DLvQBbsVagY4Ll+FYHplxZaFJ9N90+ZQ4dnPk+6CnNhbyNS8eu1tARDrVDLPKpdterp+H9M+wRBVHiMaXF07Yz1I3YH4DQW0PSAFMfLy+wy3wp24aWWbTi0/jLLXsD3AFgt4yKNyaFm1fW+HHyd4XC8hNiBI+fZGVK8BW6BzWEd0eX6vNClCUsRTDtLCgVpdTlArUkEcjPj2mRx7B0AetbfDRcD0QrQUogX4JeL6nHZ2B1/KpH0EZi92hWlu+ILdX97EIrKsmYTYkL7f0ug/oZknEDAQG4u4a1kkUzk/D4vwVZGLjmrVFeVeAayHNYgFy5pCcTp7gyvtav9yQuVfhSaJVDgQJiiOKWP9qvTX4ZlF7wB1+niPnIQXE5pd1qpwTiYLr90mHn9weR2YSmPzy/aOBbTyR7XP9vswoRBL12UApPTU0tkrg2pTRLWgLISLTUpwtMX8GzvIqtt9QMCOR4q1Hzq9fefAQZq888CweG+9hon2Ff1+EtU02foI5NOAbP52L0kVVY7UR5bDkwsXTq/KRW47ZzOdo9vQgo8MG5l9ahefVDy/LNqwTP/03HnwPDk6sICRMECFDck9axDkLKPtVeFWgR9s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(86362001)(55016002)(66556008)(38100700002)(110136005)(6506007)(9686003)(186003)(5660300002)(83380400001)(8676002)(15650500001)(26005)(71200400001)(66946007)(66476007)(64756008)(66446008)(76116006)(316002)(8936002)(33656002)(52536014)(122000001)(478600001)(53546011)(2906002)(7696005)(4326008)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?wOhxAja2syaSZfoxt5v7nopiCaVnsfRMSMiqnYi1ZTUeduKr8aUEKaJj4iWQ?=
 =?us-ascii?Q?LrWBNxs26rflEnCiQA74L+FVsCfkmUvptqrsHXgvGvygjuKH+TaZw8JyKfOW?=
 =?us-ascii?Q?AK9LrErrFhGvPmIeWcNCY/ItxuR99z1rl+poSVPOy60yqSY5SeVKIRuQd7Zb?=
 =?us-ascii?Q?SZckiaFxDFvd5zawlLdK1EDBRhHiOoQAn7bjlbx5N9wa7Bg6zIg2VbIRuBdG?=
 =?us-ascii?Q?QkB9JalR5p+wXSf7j59Any3eLyxjs0ZNpggRmGoeKCNZKeI7epP1JXLOVo7k?=
 =?us-ascii?Q?gbNpSksrL2NNa2Y9fe0z3kyyN3my+MdLls3JW3CiV5DOPzLnJj65NdXRa6Je?=
 =?us-ascii?Q?mWdO3JlulAh6XT+dGqVVAaNQZMBvvjIJTx23s0Onw2eJpsT7K/Lpvf90hEdM?=
 =?us-ascii?Q?tbn8w9H4sygHewbLnQopiWHpPf+BheEtsIMg3PKDEw/i/iCVC6Gv4os693Dh?=
 =?us-ascii?Q?j75Hyg3R+9wNS631jXdTEa3eswgweDEBqBiTs+azToNeq0FHsD5urcjsTd/l?=
 =?us-ascii?Q?+wWvDrRlmAoNcSP5cmONmjuoMAT+TsxTOo2rjMuV/yCXFO9341Gvpc4PtueA?=
 =?us-ascii?Q?5Bfj5Sw2L9n7paKDiGDv6LUl6NJMekMut7cGKqGgLsdQQju7sn8HPVMeMdyT?=
 =?us-ascii?Q?h0Tp1tIfC4zJYv2hmdixJULDK3fclNHiSi2XniJegvJfaHT5jxfi/xAb+SBm?=
 =?us-ascii?Q?743DvufgpxW+04fBkpzL2L7Dv1Z/cU8CRLDsZcjAXX/Kx7sq8tg5xeMQdJe1?=
 =?us-ascii?Q?dL3tjiTz8YG8qKuvLvWsL67/3gFroMEIb5rgHudhZkcPbdUlNpg9lWiC/lqW?=
 =?us-ascii?Q?sunqVx0F5WpTHNkFEHuzdWB1I+Y5lgsb28ylbEsgDseTpy/NVAZKmdsiTiPK?=
 =?us-ascii?Q?EFNVE6uTIK28DbA6JzRL/zZ6RG8j7EUNIZJ3rURVw8UENFko3RHCWtS3gZOZ?=
 =?us-ascii?Q?envBTazqelZxMWDm9u7L+5Y0BaBOOM/oP2hmiDMNLZ2eiCGk+CJpf8ttw+Vg?=
 =?us-ascii?Q?MNrG8s/3QRclliEpr0yejZe916k5Y9kgicsGJZv0CR8uemnNy0xYZgumxfNR?=
 =?us-ascii?Q?FjuEyagcY9csMPb8M0S/WEVP7iJLTS8D07XQShimzxXpx1yVPsjt6dOehbe6?=
 =?us-ascii?Q?TE+uClPxxojACpb1av+4h+ec4R7LU2KRr4IYOu6hf/6DgPUlG8w4rV5AsmBI?=
 =?us-ascii?Q?TS+enPBAT+E1bfUK9V5H9vCZ7vyItbPc8FzJpB/tX/5a7NIozSGcZby93RAg?=
 =?us-ascii?Q?mLVpvYwrlq+Byzd4GDf3T/AheCwcv+yED3sMDrr6mqxM3Apc2m844f0BuRaS?=
 =?us-ascii?Q?Z+7p1I1MVPhpqzJE3ZOrA6dn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ebe41f7-d5ae-4605-7921-08d9103cbc53
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2021 03:12:09.1406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PX+PzmaCKB27zMtusRKd4f+51UvB6fqXDkWoAA62wOpItinU0/yXLElgec5zzVSr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2792
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

+ linux-pci for further review.

Thanks,
> -----Original Message-----
> From: Liang, Prike <Prike.Liang@amd.com>
> Sent: Thursday, April 22, 2021 9:19 AM
> To: linux-nvme@lists.infradead.org; kbusch@kernel.org; hch@infradead.org;
> Chaitanya.Kulkarni@wdc.com; gregkh@linuxfoundation.org
> Cc: stable@vger.kernel.org; Deucher, Alexander
> <Alexander.Deucher@amd.com>; S-k, Shyam-sundar <Shyam-sundar.S-
> k@amd.com>; Liang, Prike <Prike.Liang@amd.com>; Chaitanya Kulkarni
> <chaitanya.kulkarni@wdc.com>
> Subject: [PATCH v5 2/2] nvme-pci: add AMD PCIe quirk for simple
> suspend/resume
>
> In the NVMe controller default suspend-resume seems only save/restore the
> NVMe link state by APST opt and the NVMe remains in D0 during this time.
> Then the NVMe device will be shutdown by SMU firmware in the s2idle entry
> and then will lost the NVMe power context during s2idle resume.Finally, t=
he
> NVMe command queue request will be processed abnormally and result in
> access timeout.This issue can be settled by using PCIe power set with sim=
ple
> suspend-resume process path instead of APST get/set opt.
>
> This patch is updating the nvme_acpi_storage_d3() with previously added
> quirk.
>
> Cc: <stable@vger.kernel.org> # 5.10+
> Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> [ck: split patches for nvme and pcie]
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> Suggested-by: Keith Busch <kbusch@kernel.org>
> Acked-by: Keith Busch <kbusch@kernel.org>
> ---
> Changes in v2:
> Fix the patch format and check chip root complex DID instead of PCIe RP t=
o
> avoid the storage device plugged in internal PCIe RP by USB adaptor.
>
> Changes in v3:
> According to Christoph Hellwig do NVME PCIe related identify opt better i=
n
> PCIe quirk driver rather than in NVME module.
>
> Changes in v4:
> Split the fix to PCIe and NVMe part and then call the pci_dev_put() put t=
he
> device reference count and finally refine the commit info.
>
> Changes in v5:
> According to Christoph Hellwig and Keith Busch better use a passthrough
> device(bus) gloable flag to identify the NVMe shutdown opt rather than lo=
ok
> up the device BDF.
> ---
>  drivers/nvme/host/pci.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c index
> 6bad4d4..617256e 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -2836,6 +2836,8 @@ static bool nvme_acpi_storage_d3(struct pci_dev
> *dev)
>  acpi_status status;
>  u8 val;
>
> +if (dev->bus->bus_flags & PCI_BUS_FLAGS_DISABLE_ON_S2I)
> +return true;
>  /*
>   * Look for _DSD property specifying that the storage device on the
> port
>   * must use D3 to support deep platform power savings during
> --
> 2.7.4

