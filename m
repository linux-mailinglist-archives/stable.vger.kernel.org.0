Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B531D9198
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 10:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgESIDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 04:03:55 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:50816 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726943AbgESIDz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 04:03:55 -0400
X-Greylist: delayed 1887 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 May 2020 04:03:54 EDT
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04J7RHTr012384;
        Tue, 19 May 2020 00:32:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=AhKPABPlc22lHdtHSuPoR8wjoLqW3nmS19u+3XgaL6I=;
 b=ai+nQjyztLqGv7reqS4suFtg8V2tI8eqNrWc2hbxkhuoxd2TH8DQM+Qu0MqjF7e/NX60
 pyg+0XUGVKXfZA7Mah6IofX0p6cEGnLYg2HssVD4kLFClbmEn4hhUz1uSu8pPrqfG+vD
 Fh8Yq2hMeOV3iJESCaIGGg17J0EHiK1BI8OCtz9mqJZEmTciacktQBTZ+YmdgxdqCfnU
 sHn4mKnVp8gLTzF8Neo9T3tsITSo7NVXujpi2vexbonxc2PQVsrSeUBto+qncR3LdPW1
 2h9kvgjQo14AL7zsb0cp9YbX1UoJhZsgbr921MrRQYzIuYI1k2FsrGrEzfBUQ8jrJvHx Yw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0b-002c1b01.pphosted.com with ESMTP id 312e9knhye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 May 2020 00:32:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLKKjd8zCaL5JbvFfTYtNE1aHVrDcXKPC5NJmPX4e7HI2e8zvvTlI6Emq3PDx6acMqVKbDFqx7h5vD3milw9r5NZ0ooDz70MO2HdhldXNanodS2D3Oq1iJTiottD3oIILIPAgPX491C+3ljTVUJ0pj4yY7Q7mrlL0d1tioz1Q8cIBdFb80QLp3haSo45FYTwl8yhk/27I9grdItCo1J11mMLb9zrIY5Y+0bK9zteN2DdbjnR3r49RQZC05F8rPw4cqTiTN7Yr8ysRFzzOybev7sTY5Afly/O/kDF+Da1avPcTD2J+FWSL+T1dnfJT8Vgtq0Ixpt+dpqDSo4NcS8S0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhKPABPlc22lHdtHSuPoR8wjoLqW3nmS19u+3XgaL6I=;
 b=Kn7UPThRoZDHY1TeoDj7c12FcBVqkfUhOLTZc/kKHO8/WCCvE8f3lOIa/kq/BQwPEw1mk8nkCEvXLpAxmbNBiB12cs9Rsl0gJ4KI6fRIUvpxMUD6mDnfhicQhOngA4QYH3t43zMaMtfdJwYORN+M7pH9KBw6h5LAkSfwjzr83N2jXBuj/pvWJZ8HWD17halBuaQ1yyqfSV6kCZ7U6DZ3drihCxdDgsKBNy6ePBNRfFcXC9GqMDqRIWeEQeHs74pUZwKV2vp6FI6IY15KZga1QZXBNu3lPAiUBWh3miA5fK9QU7B9PVdxgMugJDyrAhDt5msQ3ljTZJ21+2UwCElitg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BYAPR02MB4358.namprd02.prod.outlook.com (2603:10b6:a03:11::17)
 by BYAPR02MB4775.namprd02.prod.outlook.com (2603:10b6:a03:41::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Tue, 19 May
 2020 07:32:23 +0000
Received: from BYAPR02MB4358.namprd02.prod.outlook.com
 ([fe80::78ae:73d2:c58c:78f7]) by BYAPR02MB4358.namprd02.prod.outlook.com
 ([fe80::78ae:73d2:c58c:78f7%7]) with mapi id 15.20.3000.034; Tue, 19 May 2020
 07:32:23 +0000
From:   Felipe Franciosi <felipe@nutanix.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: respect singlestep when emulating instruction
Thread-Topic: [PATCH] KVM: x86: respect singlestep when emulating instruction
Thread-Index: AQHWLVxnJvxzvPZMJ0O0TV1lpS345qiub1OAgACVOoA=
Date:   Tue, 19 May 2020 07:32:23 +0000
Message-ID: <9DE50568-CB68-4EB9-90C2-079F17A88E83@nutanix.com>
References: <20200518213620.2216-1-felipe@nutanix.com>
 <babce5c7-16d6-7f46-1fd2-21b4b9bac83c@redhat.com>
In-Reply-To: <babce5c7-16d6-7f46-1fd2-21b4b9bac83c@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [82.9.225.166]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a6b18c9-0260-4455-d1ca-08d7fbc6c5e8
x-ms-traffictypediagnostic: BYAPR02MB4775:
x-microsoft-antispam-prvs: <BYAPR02MB4775EF614BB1A45BC3CFA790D7B90@BYAPR02MB4775.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 040866B734
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uWCKy61u81RdZj5pCnZQaJNl8gIAtREF5d80XUZ4V7nFJ4Df8CsZn+Fc2NQKdM6+sG95FXB6hgzSaPYwwBanJWqj4HCCl8RjwND1VaKiue3vipbZljYKtr1yekE77phhzJS/WidVQu9pX/AKmCvNWWnfBoImHtK0J008KBjEIMUizS76+jI88XdxHOMj8xrQSVDyZ239MPiNXBkPhaHuqz8oEZpwp3kbXc9ceL8QXfTX5HSnjDvPNaTr2l+pOnPm09fxKghKwRmcTujTNTrN/gZcwze+ljqPwJpsNysclHbtvmi/WZ3mqXKOSTP7Kg7ymDLeeq5vMfLiu32NWgE6N9NV6lcSU7bEnmuPNeITCExp25zMN+A7C9AzRoxlrdkEMtaAvbRVXvDNv8aEw68NpFmOadpCR1PhLg5peji+xuZLNXTfZHY1srz6GVPw5m6Q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB4358.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(136003)(39860400002)(376002)(346002)(91956017)(66446008)(64756008)(76116006)(6486002)(8936002)(2616005)(66476007)(66556008)(66946007)(53546011)(8676002)(86362001)(54906003)(6506007)(4744005)(316002)(26005)(4326008)(6512007)(36756003)(5660300002)(33656002)(2906002)(6916009)(71200400001)(478600001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 5636VZkWB61+8GYxyirlzlJwK/spZpXkpYpzixBqrPddpJHCSebmsfMwunXgRdWZUhtqetYbadd1o3Jo67lTLkZGO+iV+lIBUAtKRbuKnF0ONdgLgYG7UukxlpRLvlCNn5niHxMYkeVeQyrsuqp+Au+EBXubS5SONMEZfh1T/frokUdbTjSYa9XZ0qWAzFr5Xeq22sZNTdLXmOfVx/rdVKg1N+rmt8c+CiCyktOJcj5LbHQ0vK0adr+H7oHUgWayzKX6+kc8bH9xLhsov32LnDF/a7mP9NSdBHCcsODmjEC6EY+1XAwjhsiVzFMbAnTO6ExtoYy2F5E8jNng5EGTvm2B1sVWfVL9RVSQmU/nzAksb44avndGT0sqKopNLuy7ciJdIaO8EckKW5qLwS9eKX9xiKsXWzVt2On4PPT28hldzbZvuEnu0u9ciT3BBdP3FP4Q40PpD6FXnZUP1s6SK8F2niz2IeGn630pKjRWFgQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D01783701F08D94181EFB68B4C22C969@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a6b18c9-0260-4455-d1ca-08d7fbc6c5e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2020 07:32:23.7970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0/iFLDDbuQNnzO2onIRH83jNYKTvTJHkVLhz2EYibikBdQOeCg1jqHV+gJHJXl2jJOMLOo+pgnQpdwhCAYONp7NRK+EG/8iKa/QU2CX42gg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4775
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-19_02:2020-05-15,2020-05-19 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 18, 2020, at 11:38 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 18/05/20 23:36, Felipe Franciosi wrote:
>> 		    exception_type(ctxt->exception.vector) =3D=3D EXCPT_TRAP) {
>> 			kvm_rip_write(vcpu, ctxt->eip);
>> -			if (r && ctxt->tf)
>> +			if ((r && ctxt->tf) || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)=
)
>> 				r =3D kvm_vcpu_do_singlestep(vcpu);
>=20
> Almost:
>=20
> 	if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP))
>=20
> This is because if r =3D=3D 0 you have to exit to userspace with KVM_EXIT=
_MMIO
> and KVM_EXIT_IO before completing execution of the instruction.  Once
> this is done, you'll get here again and you'll be able to go through
> kvm_vcpu_do_singlestep.

AHH yeah. I tested *only* with SINGLESTEP enabled and I didn't do any
MMIO/PIO, so I didn't even realise it. Thanks. Sending v2.

F.

>=20
> Thanks,
>=20
> Paolo
>=20

