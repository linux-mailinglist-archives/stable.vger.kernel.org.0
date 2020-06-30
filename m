Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12DC20EE33
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 08:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbgF3GVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 02:21:02 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:58114 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgF3GVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 02:21:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593498059; x=1625034059;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=a0sQQJPDvdDCtI1T354F8LJ6rzJ2eJd8Mc1xhqxV8Zk=;
  b=ERQS5kcwWEtSMiUnT/LOG9LcqYQ9u9ddEbaIAQgFpfcBUILy7emPv/AF
   AsoRIyK1Rh3eiy1jr/DqsPZz8iY38jCcR+IvKmPcNgDbJw3UNT+2QM5YA
   5V9xx+J9UkmF4kawcfr41sTgpfo8bk1OmPWz+07SDmGF+RQ2ahzkU+2l7
   4B4lRUo3KW9lKQeMY9XWSu3jsRsMeLC+B8pN2WeLh22nbrmDJ8Tfg140j
   OZ0XXxugsfdxPTkNVovj0AsT1661AZ0OJY6LugFYxAPHMieP9Uj90m38J
   wPt/bhXBgHLa8nLFWEtRHchJnqUJRgQAl34/uMR0SI9+QSGTWEfpDI5xr
   g==;
IronPort-SDR: OwLw6loXGpBja2DzBhCH8hfVipBgGtlkRP2D/bBJ48inicZUPD1cw0aY0nkQeEN//UasijEPSP
 pga1Q5SaohzKxZG4wFkVY9NtPGMRxeRePEi4B+V3ua4HhbgeG8+eLohhFyZuoxX+jsrUuY/ky2
 ImkIj284se9fbdWzmktycRozmnA11dNDzLjezgzSjZIEgsoDC+hZSkAzYjfqlAhZu9r1Agnz6f
 Z+6ZLRpXazgGx/t9CRXutFxstHujEUy35di9/74j8yuoaLPhwcQKuuGPyIU/k/k/b0LeB6NaWx
 KGk=
X-IronPort-AV: E=Sophos;i="5.75,296,1589212800"; 
   d="scan'208";a="141248156"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jun 2020 14:20:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbiFXT1/5/Qvp0pWZ2YUpthrxfa8B5dwPP3dagNQdr6mQRTvbXsIX/CtoZusnPafZrJo8iMf9K0b+PtCSn0Lrxkm80tuSw/lo5LA9qGey9lWH9e57z7PJuIp54FzbDVJR4D56UmcqO6C0oWMHxKSO1yFa/Jwh851qOSE9GFDS16riJECJiw5Pc89CYwnROs24R3dXSIHFOr0rRl5TbEbVjsjnHvvVqpXsgf5DRRMFuwr2iR6uLpqZ77fVeuIbdYdGvfMa9WigGEVLf0rcR/FUmWo9LqKlBxbSNlW7OcpUHxnTloM86rRsje0ymmOoaBiBj6WpCyWpJyWSP4hnu6TXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOYrDahCz8aC4GYSStlrDFo27lwvsmFYSIjrmEqLGjs=;
 b=oNdrUpQoD1Dk4ZOF/Z8cIvd0rNgKh6f9TvlDcvgSarqT3IJaml7q2nOiuclE1AouW8urmBYP0jHpL4420bK6BMZNFDXw8kIEY+98cyurcD/mQJKld7+KeIxtP3aYPDNMvJCwgtO5WRKBJyTVuSokfZ+ctE/ws+0KJ5s4VQQfiTqOydPKR17tP/PAhlLuQENouCUtoOpKKf7ZNO7GYN0Wp7Sf+9W8/URcjesqwj8hx4tE3U3qtb30PiFy0iof/i4hserf+BpTI+mrF5h3BcVVxyk8U6WplIHpG9ZgLS1ZirRtnduIOH2LHRWkWUi4XWiwT5DE8hjxWyZOVIFvUk86Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOYrDahCz8aC4GYSStlrDFo27lwvsmFYSIjrmEqLGjs=;
 b=eF+TzWv/LEMeKufbTixtLJzZ3zhJn9YbWunQKu853zEpR+eyXrqku4oAPqawTldovfNjuhkkcnfHGMwjncgsB4jvSXlCfHh00wFO82Z7LwShRw9TfTpuLWWhuoUgslW2whlpuUHc4CdFbrCRuRWsl6KoPYjxdItV8aTEkLikujM=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0569.namprd04.prod.outlook.com (2603:10b6:903:be::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Tue, 30 Jun
 2020 06:20:58 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3131.024; Tue, 30 Jun 2020
 06:20:58 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] dm zoned: assign max_io_len correctly
Thread-Topic: [PATCH] dm zoned: assign max_io_len correctly
Thread-Index: AQHWTqZPeEg3XNK87Ee3cx6pw/0PdA==
Date:   Tue, 30 Jun 2020 06:20:58 +0000
Message-ID: <CY4PR04MB37511B459111266535ACEF62E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200630040047.231197-1-damien.lemoal@wdc.com>
 <20200630061840.GC616711@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [199.255.47.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ee65e17a-f3c4-4b4b-4ed8-08d81cbdc0f4
x-ms-traffictypediagnostic: CY4PR04MB0569:
x-microsoft-antispam-prvs: <CY4PR04MB05695FFDC99CF0FAB18C4D05E76F0@CY4PR04MB0569.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:826;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VOnOnBBKevsqdreKvlZMG0bqFUqsB21dZjC6bKIE9tgiKNy6Cws2chmMqaTb/0a4ySrLZy59bAM4NelDVLiuQsskIGBKE8eN4OjtMjf/mGP/LZMvUdEtFwmlcZyoOJEYZEhqHCOpcA2z3do/NM1aup4YdREqzjZvjBpgQgNibogD62fSBS+gqXAV16rZZwGM6B1z3ViGGS0tbCxlweOCuL0U9Foms9YtQAXMwTc3hKOicXRBQWmspm65LThcCUqrrASsK7JiQQg9DCl7S/dZ78752CeUosYRvWPHjUqV+wRLmgF+aTVbc8RDr6nhlsdBYOWopOprT+YARs9kxetcpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(8936002)(478600001)(71200400001)(4326008)(316002)(9686003)(66556008)(66476007)(6916009)(64756008)(66946007)(52536014)(66446008)(8676002)(5660300002)(86362001)(4744005)(55016002)(2906002)(6506007)(33656002)(186003)(26005)(83380400001)(7696005)(76116006)(91956017)(54906003)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: yK+50c7KccparilXgojff32m7BAiS+pQbVG7184FFXMEWGw87PMp4GAu3jRB0urbzF1TfBMMpU2GR6ShphYywmX0QiebfvlUSOYgpKTPyRCpUhyLyUeeBkGOzYG3xSx1SAP0GKGL+nHpOtagn8TxlbthOeqYUX0Rms74uP5YPUZUP8ORvgjFpc4CyDKxKNX4f6pPFAVoc7tmc8p9s653fq9Z6HsHqc/3mfz+eeXJcwD/9FxrmwPM/Elu4N92o1fQg65iOU79TnYxs3d526QxwwcUvw7WIUd9vzTvKjVYg/pZ7xIjqORYZvfda1wDcJioHcqgkfDy4itDVLD6dPmq7suMPxFitkUKR2/w4U9pfcxcXn/GMs556tcc9hfY1CjpeIahn6IWmI/3PcPljWqJmE0fK1p1eVIpA6+k6b0c7zIN9hJ+/2j7v932seLiPPgUDScOyEoERRSMX9etUgZs/mndCbp3iOhHjypyZnbEexI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee65e17a-f3c4-4b4b-4ed8-08d81cbdc0f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 06:20:58.3188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XAZElSL7zKDsLcrQP+tSKZOpdUCwne5lWn8qWi2pbglvhHS8RY+NMubduH74bLr+HASpp6yyFRiJs48I4jc/FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0569
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/06/30 15:18, Greg Kroah-Hartman wrote:=0A=
> On Tue, Jun 30, 2020 at 01:00:47PM +0900, Damien Le Moal wrote:=0A=
>> From: Hou Tao <houtao1@huawei.com>=0A=
>>=0A=
>> commit 7b2377486767503d47265e4d487a63c651f6b55d upstream.=0A=
>>=0A=
>> The unit of max_io_len is sector instead of byte (spotted through=0A=
>> code review), so fix it.=0A=
>>=0A=
>> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target"=
)=0A=
>> Cc: stable@vger.kernel.org=0A=
>> Signed-off-by: Hou Tao <houtao1@huawei.com>=0A=
>> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>=0A=
>> ---=0A=
>>  drivers/md/dm-zoned-target.c | 2 +-=0A=
>>  1 file changed, 1 insertion(+), 1 deletion(-)=0A=
> =0A=
> What stable tree(s) is this for?=0A=
> =0A=
=0A=
5.7, 5.4, 4.19 and 4.14.=0A=
=0A=
Got the automated email that the patch was not applying so I sent this corr=
ected=0A=
version. I sent you a separate note about this.=0A=
=0A=
Thanks !=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
