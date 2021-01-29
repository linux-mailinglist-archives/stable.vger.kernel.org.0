Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E69308BE4
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 18:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhA2Rqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 12:46:48 -0500
Received: from mail-dm6nam12on2105.outbound.protection.outlook.com ([40.107.243.105]:44300
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231533AbhA2Rnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Jan 2021 12:43:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3+m//2SzUCtjf1GKF0wn5EpF722FlOqSCShmzjn+B44I8JY/g/F9csnlbwb2WD1cGkf8qr3D0kxlJEK+HkDHSyDSgDpeyazp4SKepBAQzzOHyf6bcEb5B6M4SebWt33GgK/BVrCpjdP5rt3i1tDxWGcP7kuLloJ8ZCbcRitzrQ/CsFQ9hSWD2jCJoW9+VfjI8Q2d+51+Xh/8tBY2VYJX4iZjQ4izDMhV1m1yFKK77Wsokf3QD2dSQFpNK55zoRCxEe85MIkbf4umogGglNyHqlDaRgrcvXF9PAmkCSEbJiCdwTivqoTVRxxmrCjDr9IBpBFTXKMCkOgF2MIkmu3fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5yRyy//eQdW4//2ABsKC4N9cX+q5wr8wgNgDMIiSNQ=;
 b=iOy/j7ppEv4fb2D+3scHakue5X5TeGXKBWJNfHGKvJnEHaIC1s70vMdM6sNNOfCpdR7ud9NqmPPnkPZ79o2Am1wbUhkd6rY9FWaZIW1kdfjcQaG0fcN8v+8AxvcXPQkgxf8coMAYG/ZjEZauBAL3/RAJOdMgrM6AVqovhoHW94u43/1YpS6i0XeU/unZkrkBxx7kQ0TqML7tUM/0Ie6u904GpoOIfNWAUnek+8T/HXqT9MyWMm4hY8ScJARvSSIwmM70d3VbVnw84V1hb/dv4/9bcRpfPsZy7/0i36gt/IdxjLv/JHBHps1cCR/IxouhX1T4RaQ43+HCC8/eGP9iSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5yRyy//eQdW4//2ABsKC4N9cX+q5wr8wgNgDMIiSNQ=;
 b=EKHLHNGQsXEtSRkjzTn+F6MEWaguuh9+5d84w5W5W+FZDx3+rZr6tOE3uidPmQTDRuIZ64WICBVU7zAM2UZ0xiKlXZkxuaY/cRVqH++G7kS3cLqwJatXIiLpELcN97K8lBLKRjhY/yA7tMa1R7OERGyL0OPyCvDrHQLwFrkTlMk=
Received: from (2603:10b6:805:4::27) by
 SN6PR2101MB1632.namprd21.prod.outlook.com (2603:10b6:805:53::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.3; Fri, 29 Jan
 2021 17:42:54 +0000
Received: from SN6PR2101MB0974.namprd21.prod.outlook.com
 ([fe80::79ec:7ff0:9f3b:7513]) by SN6PR2101MB0974.namprd21.prod.outlook.com
 ([fe80::79ec:7ff0:9f3b:7513%6]) with mapi id 15.20.3784.020; Fri, 29 Jan 2021
 17:42:53 +0000
From:   Pavel Shilovskiy <pshilov@microsoft.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Steven French <Steven.French@microsoft.com>,
        Shyam Prasad <Shyam.Prasad@microsoft.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [EXTERNAL] FAILED: patch "[PATCH] SMB3.1.1: do not log warning
 message if server doesn't" failed to apply to 5.4-stable tree
Thread-Topic: [EXTERNAL] FAILED: patch "[PATCH] SMB3.1.1: do not log warning
 message if server doesn't" failed to apply to 5.4-stable tree
Thread-Index: AQHW3PyGmg9uBfPX+kKwfY/aU0hLwKo6jhawgAQMzgCAAHdscA==
Date:   Fri, 29 Jan 2021 17:42:53 +0000
Message-ID: <SN6PR2101MB0974B23484E87113CCD5CBF5B6B99@SN6PR2101MB0974.namprd21.prod.outlook.com>
References: <1609148098104221@kroah.com>
 <SN6PR2101MB0974ADC3551085BD9DBDAD80B6BC9@SN6PR2101MB0974.namprd21.prod.outlook.com>
 <YBPk5Ly0iDCUGL2+@kroah.com>
In-Reply-To: <YBPk5Ly0iDCUGL2+@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d9d2128b-f698-4ae5-8303-4426fbfc3942;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-01-29T17:42:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [174.21.175.110]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4f4e5dad-553e-40cf-d617-08d8c47d4e7d
x-ms-traffictypediagnostic: SN6PR2101MB1632:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR2101MB163285FABBFE6D296AAD218DB6B99@SN6PR2101MB1632.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MvGkVow1/L7Id3RAciMPMmp01EXsE0PnQkvG2AJQq26//fiEx7UeNXsNrOL+dtUv2Yp9qu2gieu3DdbdDk/kxa5xfT7sk8M6fhSRRc+h6n8k92E01kki+vhkJsl7EJJtA4ZeorzbX8uvs3ShJNY7Jbg7bihLbcNlqgMc/YgO7ML5/Indri6f2rs1JAf2qTjx+xIaL3YWOYsGJCygPzPKgQoul9a4k4x/yz21SQS9Lat/34V7+U5oPb8iWiU6vqTvBIDF8wQVARw9tt3CGU5hzb32gMDDG3FkXeO1B6ROtRwYR5qy4v8IbP6vfv/7yjaC8qoqOodGp9S1cufLjFD1ZXBKKPweyhjJlqTCkDVmQFE3M9vkfOpSU3pHgZcPxRO2gv0/NNHvmtJAIvMQJJbmFOxAt+zoLsV2DPNfUTKB96dGny0EmTEcdw+9yodCyJCSjUgaeCqq3JkOwN9h8QW7R3hM2h+ViQw0BLcHXKv7Ql7ANmbDBvqlh/Ga+D95KOuHmAI5nnpV/3gIxzjSbPrmxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB0974.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(2906002)(15650500001)(82950400001)(8676002)(71200400001)(82960400001)(55016002)(5660300002)(86362001)(10290500003)(6916009)(4744005)(186003)(83380400001)(26005)(8990500004)(9686003)(33656002)(7696005)(53546011)(66946007)(8936002)(316002)(478600001)(6506007)(52536014)(4326008)(66556008)(66476007)(64756008)(76116006)(54906003)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?2eJVS+AI8fyRSXfh4CK0Ce2QhIV8l1ure72z6NDyVVk+mI0NvMPOGzM9G7ju?=
 =?us-ascii?Q?6UWEATIY5FBeaEEQk8nLgGGWxZv7FW/MyUiS8RhGzRVIQnEYt7AKygxCQ7Wu?=
 =?us-ascii?Q?mqTrQV72KaGae84kfG8c9IbQ7985sxsRZhKfIce82pnhNme4GDaiqg8yGCfC?=
 =?us-ascii?Q?ewLmGf+s6zb3M5H2er2o08wjH6UFCqsnvD0P7XFxQ7zVhHPXk+Vi2M19mqZr?=
 =?us-ascii?Q?TJ9BIWbznLECYI6nSJLACJdWaUAJERcoJeRhaZ1mDJJqNewTJAMPEYWqgX6b?=
 =?us-ascii?Q?7UJoWwI47x7fGiM6FM0EHFH2U5N9QFD7rBGNzjgozf7ErxhdsycvidLk7tCr?=
 =?us-ascii?Q?1Ll7fBRRD9pFkJzK2tscEdUJtBbn99YJMD2ftjAZRWFZXYPfvk8hkkMbEYMG?=
 =?us-ascii?Q?j0lwtQKlRvOz5Exg8mkY9Y7hh9r5aMrV66unGfNSSmGKSQOLwwfbkcAZ28wp?=
 =?us-ascii?Q?TrMGaBxSvED9jkFGXiXTADzqV/AjfQvAOzbPmQt8NuPjCa6TnuH7tMbTwgBH?=
 =?us-ascii?Q?JJ8D7Xm2KTv6mBY/C7LA8IBmmwML6RD9rDikf+Zh4+PQTvKa+yUIKWYFFgkA?=
 =?us-ascii?Q?AsKcTbJvpzsbpsefV2BIjf9tyMupF/JRJr7Ahu9Pw2wDpio25oN+mC5govkV?=
 =?us-ascii?Q?NKD1Xqveb945KdLmeT/QLaLOJ/8TTqTyHM8f9IL87El4t+PFlWoRs6rHzPQM?=
 =?us-ascii?Q?TN3TbYmFIfymzsORUGad8TkmUpe89xCoEQAwHeXTNGY+ldxUXqy4BavGpb+H?=
 =?us-ascii?Q?lBa3SzdqOYSgAAsZe6UeOIgvpP4Jb3+XB2EFbc6TeFmxQX5L0GATz7VSuG0c?=
 =?us-ascii?Q?t8fYJN0uVh0/WRkJL/VO80obNJXHldXCiFraCJ35DOBwZLb/KLeh+usg5Sdk?=
 =?us-ascii?Q?lh0MPR5OGrDNCQXOOYsijwlVimETOtO6h95GMipIdIuzMIknRBCBBIiu+zgg?=
 =?us-ascii?Q?KD0OVp/vi/EXK+ualk6SqSh4bEmFF9IDHh0Ysa3/QI6Qsljmu0d7A2tSzA93?=
 =?us-ascii?Q?I00BxtLP5Kv4iEX3WY2d+Oz5Q0cIoP2uVcVv9Sc4KyA7JAtWhTJxv1eBzNGu?=
 =?us-ascii?Q?9WxcWfrlEhItQQXTz3B9tP4tIAu+cx0MfzAY1GWOY7QtVnC3eUMLS9wj7pip?=
 =?us-ascii?Q?jyNb2FTr+K65AIJ5Cx/1Tn1G8Y0l1EvBCkEr79EbB4+u11leWF1YWwCvzYDJ?=
 =?us-ascii?Q?sI5kIRJ7CUqfte3RphFJ0UZvyk3T274iUTS3JA9YjNYlusXnfvOYYHMWX8xd?=
 =?us-ascii?Q?PCGSl6ktstGG43EMoIRy1Cf0VjFnhyuy15wWspXM183o5wBiPwxxebsubTow?=
 =?us-ascii?Q?JH0WffJ6dhuN7kSnH/3cAfYW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB0974.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f4e5dad-553e-40cf-d617-08d8c47d4e7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2021 17:42:53.9021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pPEs8LO1Vh78pOX2S/5CiJiWqXodsVwOnGklhuV1i8d3TrEooNo17WbTJRUJJloS3F7qOhb9enjejsP//zkb7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB1632
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks!

-----Original Message-----
From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>=20
Sent: Friday, January 29, 2021 2:35 AM
To: Pavel Shilovskiy <pshilov@microsoft.com>
Cc: Steven French <Steven.French@microsoft.com>; Shyam Prasad <Shyam.Prasad=
@microsoft.com>; stable@vger.kernel.org
Subject: Re: [EXTERNAL] FAILED: patch "[PATCH] SMB3.1.1: do not log warning=
 message if server doesn't" failed to apply to 5.4-stable tree

On Tue, Jan 26, 2021 at 08:46:11PM +0000, Pavel Shilovskiy wrote:
> Hi Greg,
>=20
> Please find the backported version of the patch for the 5.4-stable tree i=
n attachments.

Thanks, now queued up.

greg k-h
