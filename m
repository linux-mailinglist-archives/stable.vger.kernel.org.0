Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7863E210108
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 02:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgGAAgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 20:36:52 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:43958 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgGAAgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 20:36:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593563818; x=1625099818;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=YN8eP54DcNUdUy3IP3tqbIWZlyq10ty0kpzchRmVOzk=;
  b=amB3usE0QCrfzQQB/zDb9c03atTnaBPnTj3/HPHz+SoxctbL9RsWUE4f
   2/6yIxDfzjW5nFOn1hnC2TQMO5gY+y1bBgqZW4ex9TSN/p/XTrvRs11IF
   TO6mWR7ndUgPyaovutqzZE9xGjIzkgZu7cI63FrwjApwSzt9jro2dWVtz
   FQREkdesiZVazpb6KIZJ6xBQiyLk5mX9d4vsfCzl30dR2s9f3L6H7r4nH
   WbtG7aJ/3qc1+KN1waUdIGyHwQWQX5VpFeDIxGawUykgZOCI+2iiyyigT
   80sMB4iuCII0fdn/35jkvQ981M2RVePUDT/uBm/aOlXgloVkEg1xuQIoM
   w==;
IronPort-SDR: PibBXsvb8g8CdONAYLFNevxwOR79RRhDL8nYRKLlYIa5L2wNAFgYU7a7Z5pqjDRi+PgVFe0rkV
 mSbDJ3CgsOBWvMTW8Gq5hdk3rRYPo22tJNfsppxRgJ4b1Zgl9yC+cNR/Kjssv7a+nejh3BWG3i
 0OKP7oTFtGd/sqdnhs8lkdJ5p3PrFXLF09Yq5T4FR6+jesuRP7YHWWqy4NJcgIjM7tbT/HIXR8
 ici4i73iktepcjhk8G1NzLJdZv/2M0SwNLgDqUTw5VdrJF6SgmnVwFtaEPundshZmdCVg0GMMa
 cOs=
X-IronPort-AV: E=Sophos;i="5.75,298,1589212800"; 
   d="scan'208";a="244347880"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jul 2020 08:36:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJXRzYm5pHEZS7eMb3sK9Cd5/8BfiQgILVEznW9nJFwz8YQf+KrwlnFGJLR21BOXY5yngdP36TnMk1S2rp2y/1wA0kAS6D9HWspqNSnDInIZCNFFWZLmgK2CHYC1DGG/AXz4xsgh326Y7qRqjRXd04EppxXE3kC/ialEobInMXoT/jsneY3M1jHnh8JkTuJdyCPZqp0zKahp2mcGhGkPtkhX5bytVDQ90dLXoAg52k93wIO2hwLuQvd30nMLQ4SCME3H3pd9/AZQFK7uV2pk5PpUBvCnrDE6I2kAyFBTLmQq1Z3o2kOJldCTahzDazalnb/Q1TTbjYqQitigAI+dyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dS1esog2i88u+L7RKb2GmEmuOaC6H+be9umpSbF/mqg=;
 b=HdBYdQGW/xfvb6EPwBXzrWh/9pVa9X4Jwo9ZsOmKTP2GIZK//3Tfnz9QXyDWDBsUs3ZxQFLpjSEPb10ExknlJz3vCPhdD/d18IAR695NyXue2BpM8yVNszaJBxDjzFELPLWCHQsran1UwLj5uKAuXc40/9Z+wsmcdghDUNT80S6enWfxxQuE1XIxQ6MkS+vvOVpk2peuEMpNnbCFIfUyrrH9lvyfDZ8QUDJAYYar3B7aBH49EqX3P38MuuQpSAlYI2LDayXTCUW6bdfZyLAVqrh9LBfmKOIaMxEvd7xfEIy+cf8ZVKPAAw+F1y4GW/p07tIgFkK5FYNfUX+zEICG0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dS1esog2i88u+L7RKb2GmEmuOaC6H+be9umpSbF/mqg=;
 b=mX2RBhy92y0jb0K1ivK28T0cNf+onfyJZYAQxlaElqJY73ijvMOjuVhxhQdwmtLeYFPEoF4dERoco6BoQwFtaHEjVYm09uZHSvbZXpf1GgAbeSX3MK6oN3uxueg8pKLRWqOuQGZuGbOGRTzVySabX6hKhWA1Md4nysBtqIVfaAQ=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1031.namprd04.prod.outlook.com (2603:10b6:910:51::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Wed, 1 Jul
 2020 00:36:49 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3131.024; Wed, 1 Jul 2020
 00:36:49 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] dm zoned: assign max_io_len correctly
Thread-Topic: [PATCH] dm zoned: assign max_io_len correctly
Thread-Index: AQHWTqZPeEg3XNK87Ee3cx6pw/0PdA==
Date:   Wed, 1 Jul 2020 00:36:49 +0000
Message-ID: <CY4PR04MB3751E01A0219B5A76E771450E76C0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200630040047.231197-1-damien.lemoal@wdc.com>
 <20200630061840.GC616711@kroah.com>
 <CY4PR04MB37511B459111266535ACEF62E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200630082019.GA636803@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3725496c-e782-423b-3b4a-08d81d56d7ce
x-ms-traffictypediagnostic: CY4PR04MB1031:
x-microsoft-antispam-prvs: <CY4PR04MB1031FAA506FF3F16AF1EB6E6E76C0@CY4PR04MB1031.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 04519BA941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FOeRK3+pCSWDDNVUzjwHnAtalO0ZZn2rvynRZhHppaRSpQnPx89DY/Cmay6fOy3Vt7iaAdv/cdKNlR/ZVi36QpY8UNxmpOKpiDdwJyhd22WUFC6sEbN4306/GEsENwJEzkWUaQPpEp6vnzHOO3MPR4EINyLs2/lqB/o0txgIgap6kXn2JgAZvLR3Fjs+DmEh1R8gVNgJLbNf5lnuT/ydIxEhsjkHtTVKi4Jo0wmdlf6PklkLYPgoRteQq7okuxv1Z5AF8JI9X3r8DQ5oyruq6IETGwAfAsR+HLxZGdk915ieOOmJHlBBj39ZRuj/KjH4RBDe9pRDx5WZ5diD4wjjRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(186003)(76116006)(26005)(52536014)(91956017)(8936002)(64756008)(86362001)(66446008)(33656002)(8676002)(53546011)(66556008)(5660300002)(66476007)(6916009)(6506007)(54906003)(2906002)(66946007)(478600001)(83380400001)(7696005)(9686003)(4326008)(55016002)(71200400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 6vfqyoe4ytqjSiW0xYA3SiqknRazwcbi836AnGcyVgSJUj8W9Lms1LiIeh4BgJzfwH+Kg5ZPK5f2MON1jdVGYHGGvINmOfbyycd6z7iWaLXRERHamd/CfwLGSmQqae3pq9a9q0W3JtrKrb0v/f3L5Q5lH54phuiqGV6dd+eNliNkYsy/qc681w7GSnH3wflX//vIabSmZc2aLUdkw+WRnlYa+LMG9aVJmp7wUPOGtRv4uh622Qbfw8s+E+ESHRsMlDe/kmS4rV6uaaorKJBBZblYwsw8nBMf3YmQi6ShmkqIDnn34OR+X1Bf1tBSUFdKFxOe3ilc6N0Jadj8aQdM9TmvJkvZ7RMtPwJS94UvpF5QVTs8quvqV80361XXpaYHP1xYo4GMvr4J80Eh4ITC4/1jPB9TDX9F03CbNK9XsXteBmYpGWrrktLHZuzs964oD7WNLygWxpsTbF7gncylhmxfYZ1jEygmA1nV+PsPa778d3i6ljlFzoHXSgzY6mWa
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3725496c-e782-423b-3b4a-08d81d56d7ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2020 00:36:49.6725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sWOpwFW5Gc1BX9uxkuqWmKvMmV8e7egSoBU6O6kLDxnz+ZT1CCRjDyI7F2AVlyfSCbU2yuW7LGYQpg7rqMWf1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1031
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/06/30 17:20, Greg Kroah-Hartman wrote:=0A=
> On Tue, Jun 30, 2020 at 06:20:58AM +0000, Damien Le Moal wrote:=0A=
>> On 2020/06/30 15:18, Greg Kroah-Hartman wrote:=0A=
>>> On Tue, Jun 30, 2020 at 01:00:47PM +0900, Damien Le Moal wrote:=0A=
>>>> From: Hou Tao <houtao1@huawei.com>=0A=
>>>>=0A=
>>>> commit 7b2377486767503d47265e4d487a63c651f6b55d upstream.=0A=
>>>>=0A=
>>>> The unit of max_io_len is sector instead of byte (spotted through=0A=
>>>> code review), so fix it.=0A=
>>>>=0A=
>>>> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device targe=
t")=0A=
>>>> Cc: stable@vger.kernel.org=0A=
>>>> Signed-off-by: Hou Tao <houtao1@huawei.com>=0A=
>>>> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>>>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>=0A=
>>>> ---=0A=
>>>>  drivers/md/dm-zoned-target.c | 2 +-=0A=
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)=0A=
>>>=0A=
>>> What stable tree(s) is this for?=0A=
>>>=0A=
>>=0A=
>> 5.7, 5.4, 4.19 and 4.14.=0A=
>>=0A=
>> Got the automated email that the patch was not applying so I sent this c=
orrected=0A=
>> version. I sent you a separate note about this.=0A=
> =0A=
> Yes, but given the huge email flow, you need to be specific as your=0A=
> response there was seen about an hour after this email due to them not=0A=
> being threaded/attached/whatever :)=0A=
=0A=
Greg,=0A=
=0A=
Sorry about that. I will make sure to be more clear with a cover letter nex=
t=0A=
time. Thanks !=0A=
=0A=
> =0A=
> thanks,=0A=
> =0A=
> gre gk-h=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
