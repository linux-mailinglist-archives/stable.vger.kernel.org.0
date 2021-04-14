Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEA135ECE6
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 08:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbhDNGKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 02:10:38 -0400
Received: from mail-bn7nam10on2043.outbound.protection.outlook.com ([40.107.92.43]:14049
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229840AbhDNGKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 02:10:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBiuGAJwlIFybkseRD7R63/IiDO5EgQi5iSobJ3HEqrCBXbmmc6mGQwGVjQNS5/wwrNjFkpTFDDJuX3SmCYIPXwz8vbs2qaxis2ZZdtlohPAUMzeoncurBxnHwggcvIMbdHFHZlWh3LHGBD4XGTDRK1fZkQ8GIuJqj/njd+YjwyfZ8/bIjKQ5t/zK8c4qIdZg5UAoDzLyc/DXPbRSS85iQ8HdQZ6AskcMmwYASqu2tgG++jtG3Eah7e/7jJWeELVFux1wIkyqsfp2UuaX4162cNE04hre2RGDWDcpfvI6NF+5NnA46/3r1f+kaEFORD0zpkF5I6Q9f1ADzs/LEhuSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5q4vWvlF/vM9POCXZCJtVOB6wHS+ExNJFeRAAEN9zo=;
 b=cLBnLooBa5mE294GAtCx7B9jeko2dVu7TjHV3H3Q3XTPo0NNjQF3ZMR2iI2CoNk2CKOFWvlJSRKUXbszg4bZA1dKYUPexe0ShQlhLsrvmuUKuJGP7k9eVj3bZdVbIqa3eGkwwWyKkAeRZ0tuC7P74nvxD0BuLJ8gWp+FhOr89ZlrZiilh+fMEHOwE+0Pi/vPczISlFOrTx4tVC45AMo0ms+SHbBBxBHQ2xwyllEvT3QJdph7dCg2S66fMjH5hA9beKSktsQUhgF9j2nY/B7XwBv8EBwSFkGB+bxFYJAoaxAsf03CWf7tRVqeEw56jY7StcZ3rpRL6aCcj841N1U62Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5q4vWvlF/vM9POCXZCJtVOB6wHS+ExNJFeRAAEN9zo=;
 b=2HXhBq7c0zGnrF/i26COoFPLwQt6keokUNaTVBQDGhNnq/0V7E2vs6EzeZ3dbUPNDjJnJjaG/ipspQsWaJVHMpYCrBzcYhCTC2JcN9m/wQ0odOVSbLOrBXMPXrhYV3ElmS7Pb/bedsAd0ZfhlUJdoghH1vF/kKzQSwSofiD0pUM=
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BY5PR12MB4965.namprd12.prod.outlook.com (2603:10b6:a03:1c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 14 Apr
 2021 06:10:14 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4020.023; Wed, 14 Apr 2021
 06:10:13 +0000
From:   "Liang, Prike" <Prike.Liang@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "Chaitanya.Kulkarni@wdc.com" <Chaitanya.Kulkarni@wdc.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: RE: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
Thread-Topic: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
Thread-Index: AQHXMNSXwyDulAP0GkO4gw0VELcct6qzfesAgAADYTA=
Date:   Wed, 14 Apr 2021 06:10:13 +0000
Message-ID: <BYAPR12MB3238535EADFD78EB3681A868FB4E9@BYAPR12MB3238.namprd12.prod.outlook.com>
References: <1618366694-14092-1-git-send-email-Prike.Liang@amd.com>
 <1618366694-14092-2-git-send-email-Prike.Liang@amd.com>
 <YHZ+0M9OW7dpiBKC@kroah.com>
In-Reply-To: <YHZ+0M9OW7dpiBKC@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=4b6887ca-9f2c-4b7c-8539-18bc48f6f2f4;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-04-14T05:46:32Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=amd.com;
x-originating-ip: [180.167.199.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b730ebdc-a55a-4447-ed65-08d8ff0bf7b3
x-ms-traffictypediagnostic: BY5PR12MB4965:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB49652FC299C05AC2DB773160FB4E9@BY5PR12MB4965.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /e39ha7F5xQJeSbl8H5Wop2aJmtUJRtm/VDI2wa75oqZhkCTGZcwY0YsWla3p2xru1a5rbGFCiH5xUz2qKCByKgxaWMjVMSnYrA5+u66vrnNoYc/OXLSeY1UxOD1accvzB9zdkRqGe18sXg7SoTsPxuPPO0UuGHpRrbxdQokqAuAIMB9ee48BL4duLOgUo4PSW3mzRQLYfevZ9sC5Coy7NN+UStR7puyBfdxRPAs9xNxS9EjUxQ+rL9h0fjAha7QNMihLKaeU7r/47D/nmjNsDzhbEeO/cmrV0j/61wLImkW81euC+j5J1J81P9EHVVGVwzLu7jZepPcvSZcd9OmvVOBIfU6Xurx2ESVoOYlKCupmgV8aefDfygZ6JDRsBiniZ1r/I8/CwjXIbQx87MQAiZiDcUoNijrGXiR6O42eKA+0UibupWzROHduR66a0DFhSq1/tpsFp0vfMuQdi2LFuHvY9BnuwBZ+0CQa2Sgy38FBBWkogOU6D5zlX5LjXmosPB1Wr28j8cxEppge7MXNbgy3XeUHOTvaKbI+mBl2BOCzWyscaM4H0VvMqjCYXl51NLTjA39IBE0kY5EC064GOIZkpzNRPzRw7T8Y4yRjiw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(38100700002)(122000001)(316002)(2906002)(478600001)(66946007)(86362001)(66446008)(55016002)(186003)(52536014)(64756008)(15650500001)(54906003)(9686003)(66556008)(8936002)(33656002)(6916009)(53546011)(6506007)(76116006)(71200400001)(5660300002)(26005)(4326008)(66476007)(83380400001)(7696005)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?XjQduSY3Cfr6yrDcxouBacTZUMZ+We/7ZKc2nVA4d0pjZaVnr23FeVZdjNrP?=
 =?us-ascii?Q?nLz9R9Xc3XMiUS3gR6igo8XALNwSf+hfdHxMCuyIvTdBmoLERKzWQYhIzzTD?=
 =?us-ascii?Q?D2gUwkkVznWeJuIlWeBZ356QPm8khuoUghtasefqr/rQbdY0oAkekDrte6gS?=
 =?us-ascii?Q?Lb9LM9wpo8qlLyhm/G+MtAUmNcu75IF98rjj2UoPkThQHGiZWYiYbr83tcwD?=
 =?us-ascii?Q?tggGnzRbh7Ho6R2kmhIg7xWvIguhsAU/VRr40BtM30NWFUEGuqD9dY8bph5F?=
 =?us-ascii?Q?E6tU3inO1RQRQ4qbthS1o+L2UwfapuaMgWOtgGPy6tiZ3801rAvAP1kZdj0S?=
 =?us-ascii?Q?RWiMusGR8RrDr81ft4SUGmhEQVaBe6nS4Cm9TrnCmiF+kpw0+RZSSvkW+svf?=
 =?us-ascii?Q?xeKyQtXUzeElaoZllJVxSmVU6lHo4X/VTaOqqu0BF8P3L1R2epD3tHNN/SBe?=
 =?us-ascii?Q?yZGzTyq+hc2c+MqjH3zGLynqrM8baJ96/BovGaUOPcaGR7cWeSue5nk5ba6a?=
 =?us-ascii?Q?2BUVIhhWUmE8bdeqtP8l0G6ETvADExwatOPowMx5y1W4ybNX5ayQirw8hmN5?=
 =?us-ascii?Q?a7YlZD2J1Gc0RyvHzuVyVHwd+q0AiRKm0LWl1EekWAZEa7obxxazG7Uwd7hr?=
 =?us-ascii?Q?hfFhLgW3HrXQT5eSEBVhbl1VJSy6AR6OuxUufYq8fduXF6LkTCqPEqy2FNAw?=
 =?us-ascii?Q?gXLhINZkS3AKUym3KEkKRK/QB/GB/a4qveVzpDbTewLr4vakRzI4ErAly83i?=
 =?us-ascii?Q?yDLsgcWy30Y0iOvgIjvoCBixKk0rRM0dxXklv/iCO7hAGicv82ZmsMEbSOmB?=
 =?us-ascii?Q?E3jh9JCM3/MIx66CFdOV/4AlqMHUOLcvsawg3AT8tI/1Eb3EYbqKNJns4ZsQ?=
 =?us-ascii?Q?wj8LDu2I1hYH/KjXsT6f9z5QS4BqCgxzAQ8dhXEAwf39NhifxicyG4hQRCMO?=
 =?us-ascii?Q?2dxgYRc8BGP6ygsv4vOT15vqad5swxxJ6lsHuUAUlLk76923UYhnr27Jh4Pq?=
 =?us-ascii?Q?a70aM35pOug3ulkp0fcOYcuK4k6W2xaRMq46kvYLxWxwBy6kuxTBDgvBzymz?=
 =?us-ascii?Q?P0QWIECNOxKzukbV+qFwFFidUuNZLEcZfZW96J2/Ndw/22dVHnMlTOZfCJOA?=
 =?us-ascii?Q?W4IpjvWiuOlAtTo+hhM0kvRVsFY1PAUh5+eLqHfAFp9Z9jxLg3+3opGRJOed?=
 =?us-ascii?Q?9R/svqJxXUmjAx/+uncdw9BQtIhv62+8KfFWvSGBqd49r+ZRP5/kEUsViOsc?=
 =?us-ascii?Q?MPBQhyzKUu6/uAAJlXjh0xsgzMPnPm8Cgd3vuvQZsQLHSie4gTzgitcy7kOu?=
 =?us-ascii?Q?qTVnLRGTtjHCUR8bYkggiuU7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b730ebdc-a55a-4447-ed65-08d8ff0bf7b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2021 06:10:13.6573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KgDcbP93q3Dy53gmwAbD78Y+MGWrsNei+vwUb13AxMbDSLJyS2P8p00v+YQ1r3nQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4965
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Wednesday, April 14, 2021 1:34 PM
> To: Liang, Prike <Prike.Liang@amd.com>
> Cc: linux-nvme@lists.infradead.org; kbusch@kernel.org;
> Chaitanya.Kulkarni@wdc.com; hch@infradead.org; stable@vger.kernel.org;
> S-k, Shyam-sundar <Shyam-sundar.S-k@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>
> Subject: Re: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
>
> On Wed, Apr 14, 2021 at 10:18:14AM +0800, Prike Liang wrote:
> > The NVME device pluged in some AMD PCIE root port will resume timeout
> > from s2idle which caused by NVME power CFG lost in the SMU FW restore.
> > This issue can be workaround by using PCIe power set with simple
> > suspend/resume process path instead of APST. In the onwards ASIC will
> > try do the NVME shutdown save and restore in the BIOS and still need
> > PCIe power setting to resume from RTD3 for s2idle.
> >
> > Update the nvme_acpi_storage_d3() _with previously added quirk.
> >
> > Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> > [ck: split patches for nvme and pcie]
> > Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> > Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> > Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> > Cc: <stable@vger.kernel.org> # 5.11+
> > ---
> >  drivers/nvme/host/pci.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c index
> > 6bad4d4..dd46d9e 100644
> > --- a/drivers/nvme/host/pci.c
> > +++ b/drivers/nvme/host/pci.c
> > @@ -2832,6 +2832,7 @@ static bool nvme_acpi_storage_d3(struct pci_dev
> > *dev)  {
> >  struct acpi_device *adev;
> >  struct pci_dev *root;
> > +struct pci_dev *rdev;
> >  acpi_handle handle;
> >  acpi_status status;
> >  u8 val;
> > @@ -2845,6 +2846,10 @@ static bool nvme_acpi_storage_d3(struct
> pci_dev *dev)
> >  if (!root)
> >  return false;
> >
> > +rdev =3D pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
> > +if (rdev->dev_flags &
> PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND)
> > +return NVME_QUIRK_SIMPLE_SUSPEND;
> > +
>
> You just leaked a reference count :(
>
> And what if rdev is NULL?
That seems the root complex entity not likely inexistence but have a null p=
oint check will be more safe.
Thanks point out and will update the patch.

Thanks,
Prike
