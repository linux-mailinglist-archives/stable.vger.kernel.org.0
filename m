Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220326901CF
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 09:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjBIIFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 03:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBIIE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 03:04:59 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2087.outbound.protection.outlook.com [40.107.20.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BD926867
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 00:04:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtszH9loW4Cvfqb8qWOcnQMVQl/jWZN1N0Ryy2FDqaauZKQdVkZclcYETASY459DEAiZVpa5AxPXrVfbCSBqLhkKZvcqKWoDGZ5Ao30CuCB7aO3p2axJnaXePUuSFZ1U2sWrITWtf6/MlK+rxi8Tdfvol6el3VfWeCJAPww9NkU3W8PzdkzEdCvhbWDakeDXIcpsiwwaq2PqTf+L6Or1KroYJAmfbzS+/UzdY8DXZly7/YKyfsksW+fL3OS+KKId5JWAZBSxkRvWMH+peECoYx8rHstO6tEvceN71Pc+uXC0XcgZCzSBd4OYbg+Rf4YS7oyY/YUNsTldSX/vDaDbQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0nLGEFMxu998zUWlQza50QOo77P3c9Bo0rHRDqpMvFw=;
 b=OZDEgs5Z0Q3Yx0GN6Dmuzf9xBsdkMcci1oXnP40rKIsTBMJRcPPI1nGWKCyajYDXkSeW1dOnJS3mDPIhn/7jmW0Z/VIGJr2CNZPf864ipH6PwvyFRgCsfqprRYCZModXl8zNS64OPRVcLAlvXQdBJlo2iK+ZYxrYPHkCe1wxENfVJhkiT4UsN7jq0hq/EevFmd2vQQvTtbE0+lwvIKvvKovO9C2iN/CpNpVxGOk/IF+VH/LXWQfK/f8KzSad6mBwJIZhJm1yBQ3vvTFI0oyPL5Kins0s4Gro+Xjy4OAqHs9QLCe0ezlOK/qFSr8LxCLWBzz2Q2THzkbROOtneEfb9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=netclusive.com; dmarc=pass action=none
 header.from=netclusive.com; dkim=pass header.d=netclusive.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=netclusive.onmicrosoft.com; s=selector1-netclusive-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0nLGEFMxu998zUWlQza50QOo77P3c9Bo0rHRDqpMvFw=;
 b=V9GKAhTKRHUwDLSFJVbja86lx2ypV5rVqy/P8UYi9dLgxX/MbV2jpjP5N1SIp67D1FptltVZFlNx16P6CQGGZ0y8USiG4+9neFfHyCNHUD6WOXzbM/L9LmcoRGK8nsxq6WyHn/g+9a0pSli7j9hrum/oNd/VZIs6PM4cHzp8sNw=
Received: from HE1PR0902MB1882.eurprd09.prod.outlook.com (2603:10a6:3:ea::8)
 by AS8PR09MB6363.eurprd09.prod.outlook.com (2603:10a6:20b:5a2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.18; Thu, 9 Feb
 2023 08:04:53 +0000
Received: from HE1PR0902MB1882.eurprd09.prod.outlook.com
 ([fe80::4740:8147:4e2d:60f9]) by HE1PR0902MB1882.eurprd09.prod.outlook.com
 ([fe80::4740:8147:4e2d:60f9%12]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 08:04:53 +0000
From:   Michael Nies <michael.nies@netclusive.com>
To:     'Greg KH' <gregkh@linuxfoundation.org>
CC:     "'stable@vger.kernel.org'" <stable@vger.kernel.org>
Subject: AW: Kernel Bug 217013
Thread-Topic: Kernel Bug 217013
Thread-Index: AQHZPFWpsJH2Ciq6fUKH8KOK8K4GZq7GNYWggAALJrA=
Date:   Thu, 9 Feb 2023 08:04:52 +0000
Message-ID: <HE1PR0902MB1882AE00D357F1794A25EA15E1D99@HE1PR0902MB1882.eurprd09.prod.outlook.com>
References: <HE1PR0902MB188277E37DED663AE440510BE1D99@HE1PR0902MB1882.eurprd09.prod.outlook.com>
 <Y+ScSE/M54LxkzZu@kroah.com>
 <HE1PR0902MB1882314643322D58AD3A71F8E1D99@HE1PR0902MB1882.eurprd09.prod.outlook.com>
In-Reply-To: <HE1PR0902MB1882314643322D58AD3A71F8E1D99@HE1PR0902MB1882.eurprd09.prod.outlook.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=netclusive.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: HE1PR0902MB1882:EE_|AS8PR09MB6363:EE_
x-ms-office365-filtering-correlation-id: c825e699-1b17-4e86-546a-08db0a7452ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8dxCqX6gI+cpitP3DRVMOKXkNJZLcMWyOMXk8FnHFz9UNPVF8cyZw4HRTf4MzIJwf5wMRkqeZ01nWqO9KmZTxu3n4S6VADhTeeffkVxf8Mo1MAyJ9rv+X6Dv0DO3aJdYmUGhyhO04t/KByJ/cqKftBHKFnIulBhBDb1ajAIjlnc3TAdAYP8OvE+2iIvzqsCveqWN9SQtvJV7S1uzt6QyK5yjJaybH4Znc3k1MRqvC1tOhCMh+aG+toJXPQ7ZkXhBdmoPcBlWlP3JWjz7e3kjTqvEq+lzbHHE1UJRX2Rim1AIy4Ne5w+CrOPxneJPeUu7Guvjfo1i8PcDhFUiMaHLImTOfLZJG1f8fIIKJNgVa9RGL8k6ZeO24mrIN3pIw1Vx4cxqaHiWLOTduM12QwJ7MIChkACiwSe3qSCVPyvbQzwRF8T+atNriVvGeIN5XmeTKW71lTWgmccYiKJcF7BzEUoShbZssvkW6t6IQIRNy5Tm/ZRMPqY4oFhhC8IEq+Zi6xJroYFHKrBlyABINE8tyGcVWkIp0IGwi68uZcWJXStA5EavqKk9CKk2MLp12gtQlGpgkhnOI1w11jmeJt9sn7fFkkjAI2vS/phCAspbUetn2iw55KbXog6MNqGPk/J4AggUyLFapt3uTJSS69D06f92T4A2daWjVzYr+85hCLu/ZoZ+kNQo6oR8MMzjQGLWKyFDn9QZhhJcMJvlP4lI/WSkshE5ThgDnXMMtzc7ilI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0902MB1882.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(39830400003)(366004)(346002)(136003)(451199018)(8676002)(86362001)(6916009)(64756008)(4326008)(38070700005)(122000001)(38100700002)(66556008)(66476007)(66946007)(76116006)(66446008)(316002)(52536014)(33656002)(5660300002)(55016003)(44832011)(7116003)(8936002)(2906002)(6506007)(7696005)(83380400001)(966005)(71200400001)(41300700001)(186003)(478600001)(9686003)(2940100002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?iJUTec2SX1+L6dgNpCUMFgiMlkEuU/qhXtnoqH0uXNOLhEtegzxMatYmBs?=
 =?iso-8859-1?Q?Ev8/+8h3j/SlXFYb+Ew8Mt8yEkG+c0PvDu1eezqzKFhkUwvpjWwWeYrw0j?=
 =?iso-8859-1?Q?3Tcf12tpTMkmuYylrKUd0m6qQ8HwXZ+VXDoyVUNCHu5/eEChEWoft0ayKY?=
 =?iso-8859-1?Q?I7PVPVCyx6zMmcWbBKlNO4OJIISpgo3X7jTkoNHSbTMyMQNaoi+cUz3and?=
 =?iso-8859-1?Q?TSBfmELlR81soa/dN4u2GGid8mnWq1WJOGQXqzllHa/DieLQm16XdW4Zib?=
 =?iso-8859-1?Q?bnSyfx7KGDY6r3goasRvEmL8Ty4xc5B3sFEl36c4810Pns9BVSy50IdegR?=
 =?iso-8859-1?Q?SNf0afpzpEHNbEcaDBinYRQR8B8FiEyie2VAO4MWNpq3CQ5VE6kKLtm/oX?=
 =?iso-8859-1?Q?gRcpX8N9td0CxdYop9mn/DMxj1tV509HMagvWVX4N/VD3aJewFttOkDXto?=
 =?iso-8859-1?Q?mYrTW4b4Lx+at6RDNj0pa2EeIzn39PAnVKGHmGC+2P64j4ZEn3gOQxhrzN?=
 =?iso-8859-1?Q?bt0YLNH+QXyceAhDXw80ebPxEHHFzlPTOgUYThkCsCWECD/irE/3hyrbC+?=
 =?iso-8859-1?Q?29trDMzPohYo8hMn5bg00dBbPoRyaZgAiuk0WIWgPnvQ3wvY1k/0TEoko6?=
 =?iso-8859-1?Q?CFmlBPfSjgexEeksrhVqijKhVR92oyie6Y2T0P17XlyxHSmHGGXQk0bJD8?=
 =?iso-8859-1?Q?akhEorfoNMLecGgZ4uhKJITGLFJswSsjdeKoeny339FlL0JGPAnEQw7hQ+?=
 =?iso-8859-1?Q?5AtbDv9JQxK8Zdt1PObf910qZ+wlZzOoPqpXMVe5qQGYVN3+Yvw8RySCJK?=
 =?iso-8859-1?Q?gNM3YDJrXbMT+KOKnXPH+4c1Z4EJ6sJ+AbYzcW6lEjSaIoVsdZc6f1WN0f?=
 =?iso-8859-1?Q?CiCRHTfrrvQ4piv3btTQWrDMf6VJnH9k/FQMgMMHAB2MlrnxhAq8svkSWE?=
 =?iso-8859-1?Q?5Jte4HzAt1pnCFsd8PP7u+/GEEAS4jWdbVi5jOvnIsO6As70HLI0lEiatp?=
 =?iso-8859-1?Q?jqthYtWfNyeeBfoKq3OFaoMCQeHt1FNvlL7wWxiPvoXFvFAXxBEXi+mbK5?=
 =?iso-8859-1?Q?VYl+xWPBFHwpCuRTA6cK83xIDZ7wF+NbBPa7FnfatHjWMPJlGFHquqUDxX?=
 =?iso-8859-1?Q?BtEb+Ehhwq3h6Kb09B4RgSZk0P2CQYT/EPSfZoUV/Qa+siiiIJG53XREwm?=
 =?iso-8859-1?Q?n/+X7zJvmZ/lvnIurlmhG8D3EkWK2lFU+069XAWhaaitjVcI/izkf4MT/u?=
 =?iso-8859-1?Q?4HuKbQx5qrEkTfKyVv4/5FI3Facs1L9csocK039THGE4LqLWbKAgBnx1y9?=
 =?iso-8859-1?Q?RVjZfl9l9AlaFSKa/lABjx1y/69LklrA4YSn63V7XWmKS0hMBvciJz/mZ3?=
 =?iso-8859-1?Q?AJcdYNutq2vgvg/6nbyRgXVlQBQya5P8GvetZiavz2V6qFqa5HvrI6avd0?=
 =?iso-8859-1?Q?b5WQl/wlxEEgwycwuU4Si5LQvm84+J8DnmjcqhkUN8FtZn2RdkKk3RdEwB?=
 =?iso-8859-1?Q?uYv8buWv/JAi4n/cdh5SXZEutfYZYQCvZJtBeKjxtxitMG+KyE0nw+ubuO?=
 =?iso-8859-1?Q?Dwtw43enDm0X/pFX/NczNhNT+n2BDun1IPPpk8wNiA83k8JNaOUlLfmeEP?=
 =?iso-8859-1?Q?5jkX2qudZcv8ndHdqPLp3nbXRpq0+r2WyzHrTQ0ingwM/yDDCKI7bwleSF?=
 =?iso-8859-1?Q?e3OjqVTpFH64smK0qEV8ke+2PbjgtbN+8sNbgByA?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: netclusive.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0902MB1882.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c825e699-1b17-4e86-546a-08db0a7452ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 08:04:52.7381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7efcf5f5-5d2f-4b3b-800b-1cc1cfa2a04e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 445nXowpANaaZX8rB5bZr853BUkGL1halRPv+GyJlfkVZiYUvU8HJnqp/f9S9OBnnHKveOAlsIX4hktwZljsdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR09MB6363
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

I noticed that gcc 4.6 is also the requirement for kernel 5.4:
https://www.kernel.org/doc/html/v5.4/process/changes.html

So anyone who compiles 5.4 with gcc4.6 should also run into the problem.

Best regards,
Michael

-----Urspr=FCngliche Nachricht-----
Von: Michael Nies=20
Gesendet: Donnerstag, 9. Februar 2023 08:30
An: 'Greg KH' <gregkh@linuxfoundation.org>
Cc: 'stable@vger.kernel.org' <stable@vger.kernel.org>
Betreff: AW: Kernel Bug 217013

Hi Greg,

thanks for your answer.
We do not use kernel 4.19 at the moment.
On the systems itself we have only gcc 4.4.5 - so requirements for kernel 4=
.19 are not matched and we stay on 4.14.
But if anyone else should try to compile 4.19 with gcc 4.6 - they should ru=
n into the same problem because of "_Alignof".

On my side it is planned to compile kernel 4.19 with gcc 4.7 or higher - so=
 we should not have problems with "_Alignof" in the future.

Best regards,
Michael

-----Urspr=FCngliche Nachricht-----
Von: Greg KH <mailto:gregkh@linuxfoundation.org>=20
Gesendet: Donnerstag, 9. Februar 2023 08:10
An: Michael Nies <mailto:michael.nies@netclusive.com>
Cc: 'stable@vger.kernel.org' <mailto:stable@vger.kernel.org>
Betreff: Re: Kernel Bug 217013

On Thu, Feb 09, 2023 at 06:54:51AM +0000, Michael Nies wrote:
> Hello,
>=20
> could you please have a look at Kernel Bug 217013 that was reported by me=
 yesterday?
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217013
>=20
> Greg wrote that I should write a Mail to this address.

Thanks for the email, and the bug report, I'll work on this later today.

Do you also see the same problem with the 4.19.y kernel tree?  Or are you n=
ot using that one too, or with a newer compiler?

thanks,

greg k-h
