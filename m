Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649024248EE
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 23:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239587AbhJFV3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 17:29:45 -0400
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:14835 "EHLO
        rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhJFV3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 17:29:45 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Oct 2021 17:29:45 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=876; q=dns/txt; s=iport;
  t=1633555672; x=1634765272;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=d2YzwSdoHPraOCadMwugkc6q+338idKyV6zzQeJxw8A=;
  b=B7edNNiEvAuL79KIW1r1u4yWua4m2nS2zyLqSHOI3wVY6vlNDtBRgnHX
   mqeTkp5YhxiceSlWNiNbeD+W77dWn7EZejoMlnajBTN5083BMdzPYfCOq
   WCImw//kxxkx6UupT7ZD5UF3MvarmRp32kNejUDY/HS7NkR6U6sf/iXNJ
   Y=;
IronPort-PHdr: =?us-ascii?q?A9a23=3A6k6xIxxEN4CGx7nXCzM3ngc9DxPP853qMQMPr?=
 =?us-ascii?q?JkqkbRDduKk5ZuxdEDc5PA4iljPUM2b7v9fkOPZvujmXnBI+peOtn0OMfkuH?=
 =?us-ascii?q?x8IgMkbhUosVciCD0CoMvHndWo5Ed5EWVsj+Gu0YgBZHc/kbAjUpXu/pTcZB?=
 =?us-ascii?q?hT4M19zIeL4Uo7fhsi6zaa84ZrWNg5JnzG6J7h1KUbekA=3D=3D?=
IronPort-Data: =?us-ascii?q?A9a23=3A0clUkq/bghv9Ys/Dg5GADrUDvnyTJUtcMsCJ2?=
 =?us-ascii?q?f8bNWPcYEJGY0x3nGROCG6OMvrYN2GkL9Fwa9y29EgH6JeEmt9hQFc/+SpEQ?=
 =?us-ascii?q?iMRo6IpJzg2wmQcns+qw0aqoHtPt63yUfGdapBpJpPgjk31aOG49SEijfvgq?=
 =?us-ascii?q?ofUUYYoBAggHWeIdw954f5Ts7ZRbr9A2bBVMSvU0T/Bi5W31Gue5tJBGjl8B?=
 =?us-ascii?q?5RvB/9YlK+aVDsw5jTSbB3Q1bPUvyF94Jk3fcldI5ZkK7S4ENJWR86bpF241?=
 =?us-ascii?q?nnS8xFoAdS/n/OkNEYLWbXVewOJjxK6WYD73UME/XN0g/19baZHAatUo23hc?=
 =?us-ascii?q?9RZyNhCqYK9RRsBNazXk+NbWB5de817Ffwfp+KYeCTu7aR/yGWDKRMA2c5GA?=
 =?us-ascii?q?1s7Mo4Y0uJ2B3xe+/sFLjwEchGEgaSx2r3TYvJwj84nIeH1M44F/HJt1zfUC?=
 =?us-ascii?q?bAhW5+rfklgzbe0xx8qjcxIWP3ZfcdcNnxkbQ/LZFtEPVJ/NX73p8/w7lGXT?=
 =?us-ascii?q?tGSgAv9SXIL3lXu?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3APySxiKE9v4f2Nu4RpLqFXZHXdLJyesId70?=
 =?us-ascii?q?hD6qkvc31om52j+fxGws516fatskdqZJhSo6H8BEDmewKSyXcV2/hcAV7GZm?=
 =?us-ascii?q?nbUQSTXflfBOfZsljd8k7Fh6BgPMVbAtND4bTLZDAQ56uXkWrIcerIq+P3l5?=
 =?us-ascii?q?xA8N2utkuFOjsaDZ2IgT0JbjqzIwlTfk1rFJA5HJ2T6o5svDy7Y0kaacy9Gz?=
 =?us-ascii?q?0sQ/XDj8ejruOmXTc2QzocrCWehzKh77D3VzKC2A0Fbj9JybA+tUDYjg3C4L?=
 =?us-ascii?q?m5uf3T8G6d64aT1eUUpDLS8KoHOCW+sLlQFtwqsHfuWG1VYczBgNnympDo1L?=
 =?us-ascii?q?9lqqiUn/5qBbUO15qYRBDLnfKq4Xi57N7rgEWSk2NxRhDY0JfErXsBerR8rJ?=
 =?us-ascii?q?McfR3D50U6utZglKpNwmKCrpJSSQjNhSLn+rHzJllXf2eP0AwfeNQo/jViuE?=
 =?us-ascii?q?olGc1shJ1a+FkQHIYLHSr85oxiGO5yDNvE7PITdV+BdXjWsmRm3dTpBx0Ib1?=
 =?us-ascii?q?27a1lHvtbQ3yldnXh/wUddzMsDnm0Y/JZ4T5Vf/ezLPqlhibkLRM4LaqB2Av?=
 =?us-ascii?q?sHXKKMeyfwaAOJNHjXLUXsFakBNX6Io5nr4K8t7OXvY5AMxItaouW3bLqZjx?=
 =?us-ascii?q?9HR6vKM7zC4HRmyGG8fIyNZ0WZ9igF3ekJhlTVfsuZDRG+?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CoBwBbEl5h/49dJa1aHgErCwYMAgs?=
 =?us-ascii?q?VgVmBUVEHgVE3MYgMAgOFOYVkmH2EF4EugSUDVAsBAQENAQFBBAEBhH0Cgkg?=
 =?us-ascii?q?CJTQJDgECBAEBARIBAQUBAQECAQYEgREThWgNhlsoBgEBOBEBHCJCJwQBEgg?=
 =?us-ascii?q?ahSUDLwGiLwGBOgKKH3iBM4EBgggBAQYEBIUKGII1CYE6gwGCdhNBh2UcgUl?=
 =?us-ascii?q?EgViCN4U1g02CLo4dkxysIgqDMAWJK5VTFINpkjGQeC2VeKA3gRSDdQIEAgQ?=
 =?us-ascii?q?FAg4BAQaBYTuBWXAVgyRRGQ+SEopedDgCBgsBAQMJlHABAQ?=
X-IronPort-AV: E=Sophos;i="5.85,352,1624320000"; 
   d="scan'208";a="917571494"
Received: from rcdn-core-7.cisco.com ([173.37.93.143])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 06 Oct 2021 21:20:45 +0000
Received: from mail.cisco.com (xbe-rcd-005.cisco.com [173.37.102.20])
        by rcdn-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id 196LKj3x027329
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 6 Oct 2021 21:20:45 GMT
Received: from xfe-rtp-001.cisco.com (64.101.210.231) by xbe-rcd-005.cisco.com
 (173.37.102.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15; Wed, 6 Oct 2021
 16:20:45 -0500
Received: from xfe-rcd-001.cisco.com (173.37.227.249) by xfe-rtp-001.cisco.com
 (64.101.210.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15; Wed, 6 Oct 2021
 17:20:43 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (72.163.14.9) by
 xfe-rcd-001.cisco.com (173.37.227.249) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15
 via Frontend Transport; Wed, 6 Oct 2021 16:20:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhHknJGfbSHXh4D+6/UjNKxEUY5L+nNB+aS5IW8ZeaNBmC6RBs1kRG+zTpfwptxTz21dpXdZKqqj+9WtCC5R9tinD+EzAd9hRx3ZXv2MJKjP2lf0wcwtg46m0JvUkVGH9r38f7m/RvxD43eT4ivhY0MqgHY3TqDH6QY6fsKHazdzekFdNYkzW+z82jqYIO20Vg7j7k8BzEUWMbuLYRjJ/zgFI7vp3x35luLhTkhkak7JTYRnx10yc6XEzvRyNXVIS7XGq/c5+Wf74sDFfvDuZvLnvX8Hxbxxcprvy2te7b5mtkeZbYjcu+ezTdyHzC4ARiU9Cbk20o1fc1YBMoOC6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yTRg6xjXs+9Hd2aExKUQ+RXf7haTa43k+4vsmgFWZ+w=;
 b=nfREANVsEQXNgRKhZxGRlmWgJ7WO0JFH/23ltHOEVD/+nYYO+8segHTX/OwnwgsKTwahhh6wtLYEaMcENO990ZVZWe7H/FMUOrp4vSYQet5gYE0cxEBZ3wq/DFy/CL6glgdnTSEDbshncrB1qWmbj/wEyEwzwazL5R5KMfV1dGtfwosWytqZNDsNIQZkkw2Bg+W7ObUAujfIUidXO5MTgYJkF48c1NORRzWZatEwhX253MuttNV7ABW61DgohnICMVTNevluspcnKnWVAOAlmr6Zf8DQwR3ZR9m7+Cws5vZ//PFNYxJGA/7L+jfFKnWwFs2uJmjwkcE0IzvlK5lkJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yTRg6xjXs+9Hd2aExKUQ+RXf7haTa43k+4vsmgFWZ+w=;
 b=VQP2UEpi/EzDmJO5R3kc+lLsWbvuR4VSDU/jxsNLCJgxFZ/ziBXtuyUbZDd9ubAgDT/9ufYZrFt6FHJaYZGKhYkAGJcYpM1mXy1HL29p/u2w+jwx3VDRtJh/zwkp7KEYTcQZE05DVHrDbsZRdmwDG8aOC2eCSLe75ELMEDsOQf8=
Received: from DM5PR11MB0012.namprd11.prod.outlook.com (2603:10b6:4:68::36) by
 DM5PR11MB1900.namprd11.prod.outlook.com (2603:10b6:3:10a::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.16; Wed, 6 Oct 2021 21:20:42 +0000
Received: from DM5PR11MB0012.namprd11.prod.outlook.com
 ([fe80::b13c:c7a:1850:445b]) by DM5PR11MB0012.namprd11.prod.outlook.com
 ([fe80::b13c:c7a:1850:445b%7]) with mapi id 15.20.4566.017; Wed, 6 Oct 2021
 21:20:42 +0000
From:   "Hans-Christian Egtvedt (hegtvedt)" <hegtvedt@cisco.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Stable release 4.4.286 broken for ARM64 with
 CONFIG_CC_STACKPROTECTOR=y
Thread-Topic: Stable release 4.4.286 broken for ARM64 with
 CONFIG_CC_STACKPROTECTOR=y
Thread-Index: AQHXuvgEEAcz+w4fIUmBPUXfzUd6kQ==
Date:   Wed, 6 Oct 2021 21:20:42 +0000
Message-ID: <DM5PR11MB001226B8D03B8CC8FA093AC6DDB09@DM5PR11MB0012.namprd11.prod.outlook.com>
Accept-Language: en-DK, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=cisco.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7fce5bd0-8899-4c6c-1f7f-08d9890f2760
x-ms-traffictypediagnostic: DM5PR11MB1900:
x-microsoft-antispam-prvs: <DM5PR11MB1900FDCDD5E7403EE1233A06DDB09@DM5PR11MB1900.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PJ3sbYrX7BmX5E8iMeL4zwXMHRcKdoCJXKwWFgLUImzUdC4o5NXrcXvG1o8mqBQun8lsBSn0GTQZaTP9LU/267gKTeqMq7VA9YMsa53wr3OTs1FrGwDFeATDpRSQuc4OJlkTJrpYN7hpD/v1Tkrrer74rbemAzC+86FQy8BCXfNq2JdkNPNP7x830T9U4Jpo4ExVMaZKa61XM8INO4Mv9MuHHxGvvSd/7wsrLJxNTRXyW0WcuNPuhtirc/79k3g8kgtEGjs+X/aejaLveEibou8ntpyOcKBcshyf6ClXKh2SX30MBlpX41RXf0FY0HLZdSmP91IQKSbvO5tHtYB2wwIS7ocGOCy9oY7Q0a1IiNl55UzyEJS8n85UfPQiMfKTxwnfcwti7LvXPCQ4LB6CFx2pkjuIbyvasgH3dVW8pdNUw1ht7MsDADzZH75fZyNjrp7m2PtnP1fMzwqiseLy5cXRY1r0jLvEQvYAEGRi2UdKu+FsZKsFwiaJRSf1N6LEazP+qCdgXHQyPxgNb6tnxQH/68DGzZENb9amKNiwt96CyfQBVvw872iFg+oxs2iRSzWIKbRUy6WhXql1rMNtKT31wgV3Mf1NIGak+4CKq6Fm/phNBkoxPiZn0pILRIfUcQGSNopYTZizUyRGa06T9DysTrNqcoarxroQBTQuDWm/cn+6EweFjhPcDxHAVdIl2DikmKefBw476HNZb+XPLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0012.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(52536014)(55016002)(5660300002)(122000001)(38070700005)(508600001)(4744005)(2906002)(71200400001)(9686003)(38100700002)(8936002)(7696005)(316002)(186003)(86362001)(66446008)(110136005)(66556008)(66946007)(76116006)(33656002)(64756008)(91956017)(8676002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?baiWbgPPtS45manies8jEF2DRzFHwV+TZqNO8/Xe9qUMqRiulgwxh0pTeifF?=
 =?us-ascii?Q?++0N4GFwziwfgxNGhoiZJd3R5JEsKmk2BN/NEY7PVRd3ckMhAcRmPEPYLB3+?=
 =?us-ascii?Q?scJ3B2yi0W43D4ZVpWwn0XGZZlejDblcx6s1aluM/ABEIj8ocmvR96JBypAy?=
 =?us-ascii?Q?nxJdgp22bF5dJMjLKqIlZwus/+S0MfgHT8iDWauHTvBX7NpATZcUp4AagfdY?=
 =?us-ascii?Q?t/CLMIELK5GmaryCbv+YXIIZoOyLhFqKqK65mk5RehKh8ZtdrmYDub1hnhty?=
 =?us-ascii?Q?+apgAunQGjT+hb9aGzezhbLctEcFMgjAaS7B0OqCPZgiQItJYmHfHFqAwpqk?=
 =?us-ascii?Q?eEOkgPssJEszml1cqDkX0fPZW661Um8HiXFr5BZXrZZiB2jQh/VAk965R5b4?=
 =?us-ascii?Q?bFVpMUC9CqMMy3+2E886xgGLNcX328lFeZ8tsIU0j5uKcYFVIlq63F1o0TRW?=
 =?us-ascii?Q?oLqkjRJW9X5CS13iML/u7x7qUeHhpdy1/CpBJtztnBSj6IPyTUocUh4RnTqY?=
 =?us-ascii?Q?5hD2TIfyGQ6mVOsvhcmYmcI8AM3zqL8HiU2GDHxDRA1CRNrPlidtgDhogXl6?=
 =?us-ascii?Q?P1LRxTdMRxPvtJwAAtyuAX78+4WFpoybh70isIcp4j9PeLWwu2dK49Nt2W4G?=
 =?us-ascii?Q?HLXJZ9zis+U6dWulAgL7UfHXZEcNbBqEs59CKlKarpyzRnqN2pe87kgiDOU3?=
 =?us-ascii?Q?oegaB/oJUKyVrVlZpzbNstE3OGh+DHdsLu2rHw3KdoOCyo80cQf5U1eNQsgv?=
 =?us-ascii?Q?Nw/LB8qYBthxcqGK2FEOayuWiNKbtOP12AO5iXuU8HAuCLezZU1D1WYB7PX0?=
 =?us-ascii?Q?4nN4KZAiiJ0prFVdF2EraMahK+olehsUkXabUDfmAtY5oAUmNwh1baeOLTwJ?=
 =?us-ascii?Q?lGdJwkI2j5+SLaJyhZJo+PXfuRNSYNDmoQr+lfrQWeI+T/xLDSB+/9gnoq1B?=
 =?us-ascii?Q?GjSpoqkZnFbdyRrUHPKPNcdTAnh7gPN76aSNunuMXp5IHcYpD0HuvMWEyknJ?=
 =?us-ascii?Q?k9gx3ctRtbBURL1gsDtemcR0pMzwDIxWLJB/2zJtEKCex+Ks0a5RnX5y3U8f?=
 =?us-ascii?Q?iQsM/3+Qk5Vj97N/7b3qFypltWozKtVlm/Xhez2Bd6soms8sJi5Dsf9+rGQK?=
 =?us-ascii?Q?dxD9IQarpAeMVaTHEVn7BbFc+A0+snUa20ZuYR9k+lKhKaa95gC8HG7Y07wi?=
 =?us-ascii?Q?Ogm3iAAV/95q2DN5Drpv6lBsQJflVtJ8t+AQE1s/xxtYlKxZ0JM1bDgv8SPt?=
 =?us-ascii?Q?7PJJ4OCC26Tqfe1XUTb4dvKAaktZEm6GnF84rKSHbxSJNQSjBWhtr18PvJXq?=
 =?us-ascii?Q?BovrH5qXBIwxbOQGK8PZva6Whsb2vm+Vg0lKcKkNRc9Tiw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0012.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fce5bd0-8899-4c6c-1f7f-08d9890f2760
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2021 21:20:42.6012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YlMODtRH+035rECXlH717AH0Wz+BnIqKZ7DsFeFoq2g9GW6YrEFPtc2AXiDwShe9zf0kcE40Gwpve3uBm1Nm7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1900
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.20, xbe-rcd-005.cisco.com
X-Outbound-Node: rcdn-core-7.cisco.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,=0A=
=0A=
latest stable release 4.4.286 does not build for me on ARM64 with =0A=
CONFIG_CC_STACKPROTECTOR=3Dy.=0A=
=0A=
The offending commit=0A=
=0A=
commit 69e450b170995e8a4e3eb94fb14c822553124870=0A=
Author: Dan Li <ashimida@linux.alibaba.com>=0A=
Date:   Tue Sep 14 11:44:02 2021=0A=
=0A=
     arm64: Mark __stack_chk_guard as __ro_after_init=0A=
=0A=
The 4.4.y kernel does not have the ro_after_init section defined at all, =
=0A=
stable kernel 4.9.y is the first to have it.=0A=
=0A=
I do not have an overview of this feature, but it appears to have =0A=
started with commit=0A=
=0A=
commit c74ba8b3480da6ddaea17df2263ec09b869ac496=0A=
Author: Kees Cook <keescook@chromium.org>=0A=
Date:   Wed Feb 17 23:41:15 2016=0A=
=0A=
     arch: Introduce post-init read-only memory=0A=
=0A=
-- =0A=
Best regards, Hans-Christian Noren Egtvedt.=0A=
