Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFB73EF23A
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 20:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhHQSsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 14:48:25 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:41906 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230373AbhHQSsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 14:48:24 -0400
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17HE34Lc006420;
        Tue, 17 Aug 2021 11:47:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=0R0yz1KMaxq2+YS+y9yBlAQxm/HiK+H15dSecyiIdqQ=;
 b=iHJ08OhdvEpd41vN7yzcn3WJ/z0rYAVM7hU71HJG3N2P+spBnfjD8wgD3uV9Ht6sbvL1
 my96FQ6n1xjUYzfJ94c3cDnnz4c797h0tE3csX853LVwXKGSB2CjdP1AgHJg0jy3/j+s
 0fu3pU+U9egBUnOYKtP+Xf/S16RZS768ZUecHetZKleKtEux1tM7EgYCvznzPzl5bbNI
 4k+z1lkKDVL6HBqWBgwqB4H4U4ZTZCVCaJhT66qNBfS0E4TlgmmfW7dTiJSnBBTd9GHa
 0toDYd2kSTcOH73HiAetCgJG8OjAocHJ54ZIqPusMptPpsdHezPrSQXwW6Ow0uxZ1K7B dw== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-002c1b01.pphosted.com with ESMTP id 3agehn0nk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 11:47:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ogd+Ud34VZEpqlC78HQFr3EiNkAMQCmqKALNAvd3QMApQi/fO1NejvGYajPUmBpRaxRGasKkPjb6Rf1HcNr17OSDc1f9kRECJd0zdVERgowAifFdOirrNtX8fEIO9he8E72aecdeCG/MRWDyAkaDcBczpMnfSNqIxBT68utbvPEGElgW8hJVCqyAXxyM5dRqQT4VNVmBZc19lUpxeLax/SiDIvm3DjAAqbfHSsGTkgE+83dDP+JvfjoSi+XAbcSWfLjwq5meEOkt4qB0k5LmWDDfLJsPoqJ3xiY+tvQU8aXLKuW2sthCqkxmsM/WtEvGR/cPd1kYaIDXB+6DOGlJyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0R0yz1KMaxq2+YS+y9yBlAQxm/HiK+H15dSecyiIdqQ=;
 b=L3LHQGiOOwNl6roObpNLrk2si+2oznsO9GZTTXOYfg6pOhOvNyJ/JOlJscgQAPaEVnjvgMS6yxqm7aX6O6bpZW7YjEa1vSwb4M6nUdEXtBRoKtvn8mOklScgzcR/Ci14OWq5fthB62Hcob9SdWuZcSalymslhmt5Ar7HOfsPfb88mkA1yrXycHNLAlCdK7P47qRVZWDM7JzQsoNIQK+h+jNlQyIxk1SOVqRAbNvjdHhzfBNHLEQl2CW4vhVQBnvfKjm3f6zBBZ1n3paVR0SBICPwo72lC8xoNXevRwQN3roj/3JY0d0tDk6t1lA6Z3EN8ar7kfiY7xUDmr0EdBWszw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO1PR02MB8489.namprd02.prod.outlook.com (2603:10b6:303:158::17)
 by MW4PR02MB7412.namprd02.prod.outlook.com (2603:10b6:303:70::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Tue, 17 Aug
 2021 18:47:45 +0000
Received: from CO1PR02MB8489.namprd02.prod.outlook.com
 ([fe80::84b4:fa2:b281:c43]) by CO1PR02MB8489.namprd02.prod.outlook.com
 ([fe80::84b4:fa2:b281:c43%9]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 18:47:45 +0000
From:   David Chen <david.chen@nutanix.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "neeraju@codeaurora.org" <neeraju@codeaurora.org>
Subject: RE: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
Thread-Topic: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
Thread-Index: AQHXktGCsfrxxwEReUWMujEGbBEH2Kt2hLUAgAAopoCAAIvOAIAA0Cog
Date:   Tue, 17 Aug 2021 18:47:45 +0000
Message-ID: <CO1PR02MB848942762455555DD6C9B9D794FE9@CO1PR02MB8489.namprd02.prod.outlook.com>
References: <CO1PR02MB8489A10983A22C72447EEB5C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
 <YRq81jcZIH5+/ZpB@kroah.com>
 <CO1PR02MB8489899CD7101180B2759D9C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
 <YRtUNtyom4DDaa5a@kroah.com>
In-Reply-To: <YRtUNtyom4DDaa5a@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03e9d124-b763-4b2b-7b15-08d961af8095
x-ms-traffictypediagnostic: MW4PR02MB7412:
x-microsoft-antispam-prvs: <MW4PR02MB7412736E04241C319AA6BA6994FE9@MW4PR02MB7412.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kRLCA3dJZ6KAeYWSzf7aklHDnZ4Fp4tKqCCz18ZzBa7vmMAMU/CzpQFIjlN+B/oZ7x8HcbHcyxgCZOMNrQKRM64OQ+giZdkZJPlEN5flzqnctU37oYf9A4oBYaOcrcp7wQJCThNt8IJYzFXKMBnTP89Bsh+HW03YJpoOiSzxmYiXRH2EJIq2v0hVhXd39KBRx7PWd/XZrPSgpRsajxg3g6vebbj2cO/E8VEK2udL3SmoLw85w0OBNXdrNsyMYI+BQiW6+gfhCjoAZvEOiPS9NAZmYdg1NyLhx5TdJUIbfuziEIN4s5Stp65gPyGnNcRUCtlRG/nGUiCjZ8WyfrjNQX2RNtpb4NGKYfCQm7gOqF3aWd2rTMwVTQHe9+ERed5X5F7sti7r567LCYKYWtc7ihzvpaEsOJ6hI4PO+AVab4bNYqPOYfuliG9Qviid7sqBeTwLxHrN8QJN7z5LYoJYhzAWBSOF54dCjPbfykDjeZERNdq3XsP+9erYVBrbRnBkGip0jb68XnGDD36Qd9U6BX8EFv3i866nfHXgezBK1Di/uKFNHOpD4whnyeLt78JWgpxIhPlwc0PVBfSxrBLxillA6Hcl865sIZFLBZ3zFdPjJtdFs88+OlvDfI9sYoC2utQQv723Z0UpKn052rrI6RqWq8H/CPIhtS1rcBl//ZJ3B6W/GrNqSLOv8C0kHDO5uwXQpd4pnfMAQiqiHF0D/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR02MB8489.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(136003)(39850400004)(76116006)(66446008)(5660300002)(478600001)(66476007)(64756008)(66946007)(66556008)(26005)(2906002)(38070700005)(6916009)(52536014)(7696005)(53546011)(6506007)(71200400001)(33656002)(8676002)(4326008)(186003)(83380400001)(86362001)(316002)(54906003)(38100700002)(44832011)(55016002)(9686003)(8936002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?74nGvYcYQ22cX0t6znNmTDEftCWCZOxunPlHO8WIaxwC5YXxb3tkLN3U4V?=
 =?iso-8859-1?Q?Fd9DKp9RJd4ZaKX8Whmce3b6zo6BUkZHmMu9T+cJz8GOAY9VOEOvuJn0/b?=
 =?iso-8859-1?Q?vaJfZVDMJu3W4u6Jc5vbDXFHIrwYhraXvKkRLXv8kh5O0E9so+SRXgUfox?=
 =?iso-8859-1?Q?TaU0h82nmEw/qaJmwfFucf3Sj8lIdEJnE11ksRq7PjkcFHL3Si4ap5CMjE?=
 =?iso-8859-1?Q?XRcC7mThUbVhMFdX1ZgPHoMpDNl8W/S/s5gljxd2tlPUJ/60lKTUNAL1c1?=
 =?iso-8859-1?Q?j3sj6XjYwrza931AWVHm2H1E70XRCdEXE/0Bj/nB8pQRua7uRJJVJrsUH9?=
 =?iso-8859-1?Q?q+Xt9W7kqO9lqXOG82I+GLaqMmImx/p6Z700SuSx3Tmly275dHmz0RHVXm?=
 =?iso-8859-1?Q?12zVUtIl2/PnohUqb7JHeT+1CHD/DGfraVIg5PFQtMj0k9T2cUNSshnqSK?=
 =?iso-8859-1?Q?vUKcRhnwVhLLMz+2a66xi+upearp99JzMKJpx6LCMRjqghUQyvW8jql4bb?=
 =?iso-8859-1?Q?4m9HNx4itgmn8eBj63Jm63CWIlFIt/wnu5No6cP6z/ez5S7ldED/nVyRA6?=
 =?iso-8859-1?Q?VMWctP18x5U4FKqzJve5Isp4NDBzNY3zRdMGZQ97mC8UgmWhUveZ5DKnco?=
 =?iso-8859-1?Q?C6p7MO7ZtacNuWT8PkUaG8y2CDwrhp68pCAfgU9v3CRiTK22eie7gcacNL?=
 =?iso-8859-1?Q?LOJbDoajDB2XpyVHJNJshonZV57MqUd4OQbMdY5ezERGeRuY1tVESMLzxH?=
 =?iso-8859-1?Q?j4fF3l66rtlYfUiuXUvF6ql6SqI46Dfy2GlPH3GlMWpiahHyZZU4skNWMw?=
 =?iso-8859-1?Q?F+tr/SJDWpn9IfETqX73B7RWmwi/VcgsvTQa83kjrkT5rBGN9ynSq1TWg2?=
 =?iso-8859-1?Q?ifJY5Grhvm36GnrR9nUVNlxQbOat7ScpnqS+lGNrZyC0k7OALKfzmq0jjV?=
 =?iso-8859-1?Q?GyO4ruo1YcKFT9hsNcM1iSMYlr4PEj6RFkSaKToAt5Zxiscq17iPc1xuKo?=
 =?iso-8859-1?Q?spYvoFIVwq6QCBZC1bR6U7aOdND//kIU97TdUTCv0KsEGxknuyxUCvDg5S?=
 =?iso-8859-1?Q?cQGzmoTPRSu5rH6UiZAfR/ms24FvNjPRBNAbJ208XwvJfaic3hGzeVB/Pb?=
 =?iso-8859-1?Q?HUiPa+ywm+mUe6Ghy09LUKRKAXv0qyaTiNI3x00qovhh9eWaJgSOETdhkA?=
 =?iso-8859-1?Q?U57ZY1amQHSnNKDua7cOWthphekPFsgWlFFJGxdLJkXrbYC+crXxIuEbdy?=
 =?iso-8859-1?Q?hWrA8XKWkEwTUo897pO7kpX4Iot/PD2KxqHZ+QtkBgYTPvswV2KiVQXGiC?=
 =?iso-8859-1?Q?Jpp0AF6Sgr9UKbPbdwBgC0/cj8+voFCSbVn8G7jjHjheyop++4f2tqILVK?=
 =?iso-8859-1?Q?t/KTYMr4Li?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR02MB8489.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e9d124-b763-4b2b-7b15-08d961af8095
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 18:47:45.3061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tZoxGjE4PnCKYpVPnbOi7bnk9Aw9PMT+VSvQzpC6m4tzta3ebbkauG9yI+6mgs35/wuaJrvcHn4Nyxqe1sCEiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7412
X-Proofpoint-GUID: oymtcX2prCTakkFNHpvqKkOSGznCwfvn
X-Proofpoint-ORIG-GUID: oymtcX2prCTakkFNHpvqKkOSGznCwfvn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_06,2021-08-17_02,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, August 16, 2021 11:16 PM
> To: David Chen <david.chen@nutanix.com>
> Cc: stable@vger.kernel.org; Paul E. McKenney <paulmck@linux.vnet.ibm.com>=
; neeraju@codeaurora.org
> Subject: Re: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
>=20
> On Mon, Aug 16, 2021 at 10:02:28PM +0000, David Chen wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Sent: Monday, August 16, 2021 12:31 PM
> > > To: David Chen <david.chen@nutanix.com>
> > > Cc: stable@vger.kernel.org; Paul E. McKenney
> > > <paulmck@linux.vnet.ibm.com>; neeraju@codeaurora.org
> > > Subject: Re: Request for backport fd6bc19d7676 to 4.14 and 4.19 branc=
h
> > >
> > > On Mon, Aug 16, 2021 at 07:19:34PM +0000, David Chen wrote:
> > > > Hi Greg,
> > > >
> > > > We recently hit a hung task timeout issue in=A0synchronize_rcu_expe=
dited on
> > > 4.14 branch.
> > > > The issue seems to be identical to the one described in `fd6bc19d76=
76
> > > > rcu: Fix missed wakeup of exp_wq waiters` Can we backport it to 4.1=
4 and
> > > 4.19 branch?
> > > > The patch doesn't apply cleanly, but it should be trivial to resolv=
e,
> > > > just do this
> > > >
> > > > -		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(rsp-
> > > >expedited_sequence) & 0x3]);
> > > > +		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(s) & 0x3]);
> > > >
> > > > I don't know if we should do it for 4.9, because the handling of se=
quence
> > > number is a bit different.
> > >
> > > Please provide a working backport, me hand-editing patches does not s=
cale,
> > > and this way you get the proper credit for backporting it (after test=
ing it).
> >
> > Sure, appended at the end.
> >
> > >
> > > You have tested, this, right?
> >
> > I don't have a good repro for the original issue, so I only ran rcutort=
ure and
> > some basic work load test to see if anything obvious went wrong.
>=20
> Ideally you would be able to also hit this without the patch on the
> older kernels, is this the case?
>=20
So far we've only seen this once. I was able to figure out the issue from t=
he vmcore,
but I haven't been able to reproduce this. I think the nature of the bug ma=
kes it
very difficult to hit. It requires a race with synchronize_rcu_expedited bu=
t once
the thread hangs, you can't call it again, because it might rescue the hung=
 thread.

> thanks,
>=20
> greg k-h
