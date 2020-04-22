Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B0E1B4879
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 17:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgDVPWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 11:22:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:32884 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgDVPWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 11:22:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MFJ070049163;
        Wed, 22 Apr 2020 15:22:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=URGddE/rla++MvolJEfSZrKgtDDP+qOWMmeR82gZX2A=;
 b=U4iDnYZn5mArrrPDO/jPJ5tpWfk04o1vdsyNldlo4hs3VJA2YgKf/AhTSnr5T7zh8ROK
 TRWnI4KDJc4Z0KZlxbVd+u73ZzAZtgV+HRdFYEtweQFCXnUaWkXGOENSZAGcpa3+azUZ
 ciP1Zu1J/+6bFTOw+z3Cfj4cPmvy24nJ16rS0k7VbkFtUvrvfCJCmT9RvE2xQ23Rc0Af
 U6qUdoxnLHs9s6MPxdTo3E57S8vpiVO63AS2/cV5B0l1m9qTzEPMoIyk2wWwrCFeoTcj
 K+cMRp4Ry5BvhGtVZ89eSiZc3vdlDu4ErCavlBB5u84UJPwsuEeQu5smP7KXZpX4Qagt kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30grpgqyss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 15:22:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MFIJLQ180656;
        Wed, 22 Apr 2020 15:21:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30gb1jt2f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 15:21:59 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03MFLtvK001754;
        Wed, 22 Apr 2020 15:21:55 GMT
Received: from [10.175.186.214] (/10.175.186.214)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Apr 2020 08:21:54 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH 1/1] x86/fpu: Allow clearcpuid= to clear several bits
From:   John Haxby <john.haxby@oracle.com>
In-Reply-To: <20200422143554.GI608746@tassilo.jf.intel.com>
Date:   Wed, 22 Apr 2020 16:21:51 +0100
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <96EA2DF4-7490-4FF0-BB3E-EC9157517918@oracle.com>
References: <cover.1587555769.git.john.haxby@oracle.com>
 <03a3a4d135b17115db9ad91413e21af73e244500.1587555769.git.john.haxby@oracle.com>
 <20200422143554.GI608746@tassilo.jf.intel.com>
To:     Andi Kleen <ak@linux.intel.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220119
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On 22 Apr 2020, at 15:35, Andi Kleen <ak@linux.intel.com> wrote:
>=20
>=20
> Thanks good catch.
>=20
>> 	if (cmdline_find_option(boot_command_line, "clearcpuid", arg,
>> -				sizeof(arg)) &&
>> -	    get_option(&argptr, &bit) &&
>> -	    bit >=3D 0 &&
>> -	    bit < NCAPINTS * 32)
>> -		setup_clear_cpu_cap(bit);
>> +				sizeof(arg))) {
>> +		/* cpuid bit numbers are mostly three digits */
>> +		enum  { nints =3D sizeof(arg)/(3+1) + 1 };
>=20
> Not sure what the digits have to do with the stack space of an int =
array.
>=20
> We should have enough stack to afford some more than 8.

sizeof(arg) =3D=3D 32; room enough for eight three-digit with their =
trailing commas.   If sizeof(arg) =3D=3D 1024 instead then there'd be =
more than enough room to remove every single feature.   TBH, 512 is more =
than enough for the 89 flags I have listed on this machine I'm looking =
at here.   I'll grow sizeof(arg) and nints accordingly.

>=20
> Would be good to have a warning if the arguments are longer.
>=20

Yes, I should definitely do that -- coming to a V2 soon.


> Maybe it would be simpler to fix the early arg parser
> to allow multiple instances again? That would also avoid the limit,
> and keep everything compatible.
>=20

I did wonder about that.   However, cmdline_find_option() is =
specifically documented as=20

 * Find a non-boolean option (i.e. option=3Dargument). In accordance =
with
 * standard Linux practice, if this option is repeated, this returns the
 * last instance on the command line.

And since that appeared in 2017 I decided to stick with the new-fangled =
interface :)   This is a little-used feature; I'm not sure it's worth =
the effort of parsing the command line for the old style.  What do you =
think?

jch


> -Andi
>=20
>=20
>> +		int i, bits[nints];
>> +
>> +		get_options(arg, nints, bits);
>> +		for (i =3D 1; i <=3D bits[0]; i++) {
>> +			if (bits[i] >=3D 0 && bits[i] < NCAPINTS * 32)
>> +				setup_clear_cpu_cap(bits[i]);
>> +		}
>> +	}
>> }
>>=20
>> /*
>> --=20
>> 2.25.3
>>=20

