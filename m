Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC0D46C7C9
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 23:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242372AbhLGW5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 17:57:19 -0500
Received: from mail1.bemta35.messagelabs.com ([67.219.250.113]:60086 "EHLO
        mail1.bemta35.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233920AbhLGW5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 17:57:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1638917627; i=@motorola.com;
        bh=rZvg5cnlpQh/QAj9XFnJBGpTVZKy6RjoC3nTD1U+qdM=;
        h=From:To:Subject:Date:Message-ID:Content-Type:
         Content-Transfer-Encoding:MIME-Version;
        b=oW6f6ZcQcWAeG+Nigyq1fRzZIbJo2qruUQwwy2JBibKlPt2mV/ulGS3rPktm7HGop
         Gm7U1wTbMsgtIRaDzVX6GoSNVZ045SZS2H+LtT5s0CkIcuhxRMe+o/vyd+mxpS+aaz
         DnoPItzOy/5Dd/YYG/95Xo3KHBJzCkdztvErIEmYUL6UDC+c9D4/jiLeFR8IwLZ2Uc
         G3UdIlDeW91MaTXkHCD4u5sPViksxh2qNqOTEDNlDbBududL5jCoQjZYamlfdjcRYp
         +DJKZT2qRPuu8RfT3vk05HoWa7F7xPv9uVG5JzBa0mHpz3xczVLbZjdOgaH6mHQXES
         R4jE7KcADSvBg==
Received: from [100.114.97.172] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-5.bemta.az-a.us-west-2.aws.ess.symcld.net id BE/26-05076-BF5EFA16; Tue, 07 Dec 2021 22:53:47 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRWlGSWpSXmKPExsWSoS9loPv76fp
  Eg/PNYhYLNj5idGD0+LxJLoAxijUzLym/IoE1Y/bxJ0wFFxkrZnz4yd7AuJWxi5GLg1FgKbPE
  g71HWCCcRawSl3rOskI42xgljl+5wg7iCAnMY5L4MfkNM4Rzh1Hi4OMeti5GTg42ATWJD+fvM
  oHYIgKmEjemb2EFsYUFdCV+TT/NDBE3klj54jIrhK0nsXfFJaB6dg4WARWJpeJdjBwcvAKxEj
  9P+YEUMAqISXw/tQZsILOAuMStJ/PBbAkBAYkle84zQ9iiEi8f/4Na5CpxauZhdojeMokjex4
  wQtTISlya3w1l+0rsPN7PCLJKAuiwBcdtIMI5Ejf7l7FA2GoS7RdWsUPYchKreh9CxeUlpi16
  DxWXkXhwYzsbKBAkBP6wSrx+ehpq/htmiYN9oRC2gcS8b0egilYISnyYNQvqGT2JG1OnsEHY2
  hLLFr5mnsCoPQvJn7OQlM1CUgZi8woISpyc+YRlASPLKkabpKLM9IyS3MTMHF1DAwNdQ0MTCG
  1sqJdYpZuoV1qsW55aXKJrpJdYXqyXWlysV1yZm5yTopeXWrKJEZhgUopSmncwLun/qXeIUZK
  DSUmUV+bi+kQhvqT8lMqMxOKM+KLSnNTiQ4wyHBxKErzlj4BygkWp6akVaZk5wGQHk5bg4FES
  4fV+ApTmLS5IzC3OTIdInWI05pjwcu4iZo6G7q4lzEIsefl5qVLivM0gpQIgpRmleXCDYEn4E
  qOslDAvIwMDgxBPQWpRbmYJqvwrRnEORiVh3mkgU3gy80rg9r0COoUJ6BTnFrBTShIRUlINTN
  ySa47NsfljUb/lKPOBaOOaryLf2eSa7Xd+nDfxS9V1BV2bsEbR5L5eJ7PCiwfylcQDXMxq5su
  YVf9z/D5ljsGzL6s7Z7zxO3B2wUubPW/b17/nVl9/3MfBrU5764uFdRPlex86zl73wujMOS5/
  fodXuic1RYqMPe1eGDgU7vRktExc8SnnsW77M0HBuwvMvM/4XtismVrj/+5K7LK3/3uiJzVvt
  2/qejk/ZKfOoxsxr+6ckdsWp6ZV8O/NLxvp+RfyRE++iDbr5YpxD5dconAn5yxDUn2iUn3ApV
  sftthvEV/dqsbcs+21f+MZK4/CysbZbS3iBTf1VS3n25o9/fK1+66gSoWCtuWPR4uXK7EUZyQ
  aajEXFScCAMLvfIE9BAAA
X-Env-Sender: W36195@motorola.com
X-Msg-Ref: server-2.tower-655.messagelabs.com!1638917626!20540!1
X-Originating-IP: [104.47.26.48]
X-SYMC-ESS-Client-Auth: mailfrom-relay-check=pass
X-StarScan-Received: 
X-StarScan-Version: 9.81.7; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 21611 invoked from network); 7 Dec 2021 22:53:47 -0000
Received: from mail-psaapc01lp2048.outbound.protection.outlook.com (HELO APC01-PSA-obe.outbound.protection.outlook.com) (104.47.26.48)
  by server-2.tower-655.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 7 Dec 2021 22:53:47 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nA8AS0njO7mzByKNaBMGtoBP/ZyJeCtTDgjpekhPlCY5P0bmQK03Znbq7cRAQX01P4O6O1gDK7NPvqNoYsbMBXs0IKOsvGbel2W9iRoJCE0qjvttDwGBIJFqNQzp2YeK2rm1Ygjfh+XapHdm3ijfRE0gjUGbnYS3pXlyFjOffFLqMCe+oVKdikaI6IV3Pmv4fjLhdbnYyPr1xi07N1feTYDJzdOsz9OlRb+Y9Ja1mL7ja8/nDar61UMXoM+1bSacIJlB0dwxE6CzHqfvfSpyJIlmRv+F6GE5fJrqXSdUs2oQyuw/sT3/vGiOWnNT/VyByIchOZX7u+59YxV+ONCjSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZvg5cnlpQh/QAj9XFnJBGpTVZKy6RjoC3nTD1U+qdM=;
 b=DWCebc0DZpOuQq72m/pmbaEJJ0VDVzupRwFMU94FoJRL5N3G0LjyvF/LC2r/bhEuJMqX8QYBG0AO5j5VQUfGgVBz1hxiMtiTPsuokFmB5OGIN+dLxIPJXCDq1UIIhMiN185TLGgDDSicMxbNZq24SdVsZunaEurWWSCFsLkpoq8diqu01mkZBSaCW6VuCgY/dxAJpyUHK12IscirKrVlS2chX9s/jnkRMGMRgh/WuhMhExLU4sNc17hK0l2UekAL4iT7yI0he3PIA5X0Ddm4MEZ7ZAyGCvEYGCnmPUYK5gTRND6hAH8jkFhK4KU5YnFZgHL2t3k7Kj4l1i+0uM2OFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=motorola.com; dmarc=pass action=none header.from=motorola.com;
 dkim=pass header.d=motorola.com; arc=none
Received: from TY2PR03MB3614.apcprd03.prod.outlook.com (2603:1096:404:3a::17)
 by TY2PR03MB3696.apcprd03.prod.outlook.com (2603:1096:404:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10; Tue, 7 Dec
 2021 22:53:45 +0000
Received: from TY2PR03MB3614.apcprd03.prod.outlook.com
 ([fe80::9117:24aa:ec4:84aa]) by TY2PR03MB3614.apcprd03.prod.outlook.com
 ([fe80::9117:24aa:ec4:84aa%5]) with mapi id 15.20.4778.010; Tue, 7 Dec 2021
 22:53:44 +0000
From:   Dan Vacura <W36195@motorola.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: usb: gadget: uvc: fix multiple opens
Thread-Topic: usb: gadget: uvc: fix multiple opens
Thread-Index: AQHX67hf4V7pa066YkiQM5AqI3qJBw==
Date:   Tue, 7 Dec 2021 22:53:44 +0000
Message-ID: <PS1PR03MB360765EE2F51F5A44F80EAB0F36E9@PS1PR03MB3607.apcprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 3312b8b2-0dd2-c732-3b3f-adbf25e47334
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: caee224c-8768-4b02-cf3d-08d9b9d46c1f
x-ms-traffictypediagnostic: TY2PR03MB3696:EE_
x-microsoft-antispam-prvs: <TY2PR03MB3696265DDC033943931F7D34F36E9@TY2PR03MB3696.apcprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZKzVW6VZxacMERifwWTTPkpaKnWeOdmFmNLnQKTXbbg6klFbqI8c4/ilh/DF57Cq+zwNYMe9fPHqtEPPaNXc27sDK0dqId314cm7qTdfE49+S7NTnfQ1jyeiZhPsmCJFD4wqklXZHPCQXIUv8yQKlC8DTqbiRRJGGaLKxMYiHM/XEVrCpoDLpW1WKEpuZSGnuv3njdJCmxWJ2D6B3fhcOUqY3Vl+iDE9Vvv+H8Y1mKg5KdfycQEyAO32ahdY1MAyvjg8B+CQ2g/2h641bqwdThiG4LdNptNvSkFP/H4hvyFW2IF2SzDV9yYweUrI3uv4DYL/5KFUT1pMgwPNTkh2LcT+8elNvB4wrswVr3WZeNHntFUHvTOcDrRhbXY9muUP+XyT37NnICFYyHeVKZb5DfnhnGbTZw+KBXmUAQBgsq2aErRIHF0Hm+W54Lii92yMXLYKrWr513CDDVejbN//XyMRMzIJCuKrdw5E1NWu2xZjLKUXcXUHlZQJu3g55adbkKS/OJVDQ6sjCpSNHGiISWKDyqGX6wFpWHIHUC+5tFbSzW/CoXMYx8X5L0ODeK0Z+7VzKD3yyIPHnH6KNbPtwWYhYgLDHKvOXyMAZHluUcq1uRPhDVx5VstBRV+EfabKQsrgO7EcyFUff4KS7HyUNXyS/hR977DAT29Y4mcOzkKbSLj8fDz6K8BUm9RBePY6xTrc2ZlyfsmVjL/sfJIoqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR03MB3614.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(6916009)(6486002)(2906002)(8676002)(38070700005)(8936002)(91956017)(76116006)(66946007)(66476007)(66556008)(64756008)(66446008)(86362001)(83380400001)(71200400001)(558084003)(82960400001)(26005)(9686003)(186003)(5660300002)(6506007)(6512007)(33656002)(52536014)(316002)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gROMi9irBSZ/YDu2j787DoryHNNXYuvVi8DDAH6cutIGVHTqikJ2FD/ClX?=
 =?iso-8859-1?Q?xvVgZIv6ts21AHXlCZT1UGggOJJvm/l2+vscqt3NCjGGDNidD7QRUsZAMZ?=
 =?iso-8859-1?Q?Mxr+7Me3o7HBm/iyRU0/gvWc47cTUnoD4wKaBz/mfEsAFgh+gxv8yBfl3j?=
 =?iso-8859-1?Q?kogpZ2ed6r4TK4FEXMJ2r7bA5t/dyEen4n8yWvQgnoq8ZGa58v/1Xx8tzy?=
 =?iso-8859-1?Q?kcss7OaqNkmC7Dam2Fb0aHn1q3qHCijSmaRzSwgPXpKu1bAyGICWm2RKx8?=
 =?iso-8859-1?Q?IzwHq3RPjSu7B+azVzH1FasP+c+wV16o+TE4XCm4IqOco2JMddZ+Faq1CY?=
 =?iso-8859-1?Q?hI1n284OW0CkswRviZ83XN/YrGIn99bykELTFEpeONsoPEG/ziWPbAoRs0?=
 =?iso-8859-1?Q?4MKUOpqi+DobwMAL032Wp35aEyGLta2yQZM92Fgaaxi+7QH4YHCDqJ2Ad2?=
 =?iso-8859-1?Q?EbbaR7JVoNZvCoQ+vHcy9kKtXPr6JeRdq/RDrWMVP7hI1r7Ad5VNUKZyqB?=
 =?iso-8859-1?Q?pvvcA/NNQOeIyLxs9RRlNswDDXiZbFCclcRP/1512xPGZv5TcGVrCXGFtp?=
 =?iso-8859-1?Q?dHEvOIkY3gDuUnoCabxYl/sCUFjg5Vze8KvETlzv2grxW0tS1qUexfYCWn?=
 =?iso-8859-1?Q?eJ8uXD0DVd1YeftUeehHKGpWswRzZHE38WSe7TZyth6h3auPSdoMHqrZJF?=
 =?iso-8859-1?Q?RXGmCfxTB0mEQsWk4ABPfhEzsRW4y1lWbX7lLEWJZU1vJhKsrPs0SgQ688?=
 =?iso-8859-1?Q?ziqKhbqPl+rOFesT/9YUb9a5rbmlhueEse8ZbIgVcUPOtw2GKUmps4cHRK?=
 =?iso-8859-1?Q?VUTg3onEm6Ir3cNGHWs6++SvfPbhLiNLcPTAYvXjMR4zqxnngPlSaVKoyJ?=
 =?iso-8859-1?Q?UK94tskrel4GJcn8djZdCZ9qWssfNmpPGRYuZf+7iqlGJUPABp3ExlObeN?=
 =?iso-8859-1?Q?sL+Hhyl8SZ6Jf3GfrJeoAkjc7Y9/WdCSktQ7pzvS0Z8LHtWG2TYOzwZY7p?=
 =?iso-8859-1?Q?nw37BDxEAmlCDuPuETjahERFz+Peey3DYn2kVRC7a3TFUNwEaK/RJgz58K?=
 =?iso-8859-1?Q?rjn4x2Hz8Z8z/X1dUdxQms1jjiTMLQJ5Yb/t9qHKK9SLgWv0QVH7/nupOI?=
 =?iso-8859-1?Q?WkZf7EBSC7XEBF0FZSYer0pdumiRKcgw1zlux4os1cNcDoXlm84x+q6AO3?=
 =?iso-8859-1?Q?vT2+c3qUz//eWvZSkLCuWg837UxHBUsDiwQPKXJniYNJgs+R7PIrL2a3nh?=
 =?iso-8859-1?Q?5wAl+EE54VB10IgbJUNW1rafdEH00xr3XtaUCvwMWsxMqHTloAN1PWi6Wh?=
 =?iso-8859-1?Q?a6WLYZYTxIbMPIfUpvcTaGBFhtgaA6OhjiZnvypy7B7xMjXkZlKihpCQxY?=
 =?iso-8859-1?Q?JQYKjzAnDDEYWyOMUZ8EQYVQCMPjuQa2GDy0BxBzAGK5qXoU+WeE/pUmc6?=
 =?iso-8859-1?Q?DhDSUsNB1xofPUuURive9ya74Z7sE1Tu7HAYY+Muvf+BsV4l+JZ+QIVq6W?=
 =?iso-8859-1?Q?3BYirLs6elMTZtn9BXlo8csfPzIX8nhXcHX3dMs0YGGbIIL4+3bChrYRJU?=
 =?iso-8859-1?Q?f9OQQGyoxclbRhmMqWKq7OY7x40ySoM16SeQqbIEO35JWEB1ifiSjzfIWA?=
 =?iso-8859-1?Q?GOdELE7gV7FOPEGVE5sErRXlvVeaQ5adAAgNI4VK0LImy8bK0lPn3atQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: motorola.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR03MB3614.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caee224c-8768-4b02-cf3d-08d9b9d46c1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 22:53:44.6771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5c7d0b28-bdf8-410c-aa93-4df372b16203
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bI4ePoMa8xU4PZ0l35qDB0e8LLkCwaZAcUT5+1f994OAMy/b+U9sVMYWl3IcocWKkixOBnOi6rI0NvvKXGluqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR03MB3696
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Requesting 72ee48ee8925446eaeda8e4ef3f2eb16b4a93d2a to be cherry-picked to =
stable 5.10 and 5.15 for use on Android devices=0A=
with external camera support enabled in conjunction with UVC gadget support=
.=
