Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C443EDF9F
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 00:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhHPWDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 18:03:08 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:27038 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232067AbhHPWDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 18:03:08 -0400
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17GHeakw030577;
        Mon, 16 Aug 2021 15:02:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=/g+0WPK2jjLewqDEj9+LGzhyIgI4NMb1Mhetj41vmac=;
 b=0yMKznwij9pXw/OKiqJ07AWcbJcl5k0gJ9AAI316OyQnhIkRdSI8XfRZvvIGEodFugS1
 rgB1DpoZt+XEZeXytb3vGUt9TH5eev4EKP8HYi4DqJtdYU6t5Me+7KFpkT5K6nCpS5AB
 /Ktl1FNSGUJpYWa1LmsrF3nZ+3/ZpyXkG0kaK9oQ3gdorER3yvuDYOYvRRTIsJjmTk/u
 iTvMY3halqZlLa+OdzbSbeMi+pCWYeu4af5vVbz60dH5m65ZTIWoLKfXDcQYRsGmojKw
 yvhr7UhIUOrlVeE4Fi9c79E0/eGOjPsVQNHhA4Sp5BOwlRJtbB6RvsoZvlWIHmg19Hu/ YA== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by mx0b-002c1b01.pphosted.com with ESMTP id 3afvmhgefq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 15:02:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1Lyw3aJ7MjoIX8HEzYoO/HBbuiNq81z8g2HB8v28ueZrs6V5zqOBj2oiRXj65mNoGaSAFOxmEQwAIY6M/WM/KVlGqEYKSNHT3sE9qYsTahq5F0zzQvyBr0MbGePD+75cZQ8IVQfM7Hgwkg7UWHkYXVF/Segvg6/Wa0Hh/cu9wwlLqbiCcuBEyBjK27GUHbvS82FpDd1oUVjteR0ki8rEt2wFkeMbkW/g2ZUS1fzGkS+yeTVst5cU7PMRgTYh81mub/ha1Mvcd/5GIY40Mp5RnTgdQKBkOa87xFjZSj4qoJE2dWVVcgOu2RpWnQTjrlhZmO27b53r4Vd3E5wTk3wNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/g+0WPK2jjLewqDEj9+LGzhyIgI4NMb1Mhetj41vmac=;
 b=LdT9gLOG/ENL1sw5WXJiJZ0+oLYpmgYFwAVSGjshPS0T63YBUOUaBufEmEELk9MmmyV5+9cWqcIkj+dzmcirPaptrjPy5ec3aULQzDdwAtJn1sweVD+WtcrjImXRiSPP6kS+xvaj+tkUdSB/yisqqMuDh9HQ5PYrcNheR+XuF4dgeay3F0j2txZlDTCi0NZq7NaHmdqPmBGfaeVWihiI2ldycD1tzORelGWQtlkYwJs2sI+DespS5jZ4IOFrDojPb/NximX0idlgmGwq7st+dzJX/IujCojHHK7KRwJJw7aGWZUhXYIIbOCif8OM0cE8tP/AyBQ8sl4aOH6ukYADBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO1PR02MB8489.namprd02.prod.outlook.com (2603:10b6:303:158::17)
 by MW4PR02MB7282.namprd02.prod.outlook.com (2603:10b6:303:72::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Mon, 16 Aug
 2021 22:02:28 +0000
Received: from CO1PR02MB8489.namprd02.prod.outlook.com
 ([fe80::84b4:fa2:b281:c43]) by CO1PR02MB8489.namprd02.prod.outlook.com
 ([fe80::84b4:fa2:b281:c43%9]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 22:02:28 +0000
From:   David Chen <david.chen@nutanix.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "neeraju@codeaurora.org" <neeraju@codeaurora.org>
Subject: RE: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
Thread-Topic: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
Thread-Index: AQHXktGCsfrxxwEReUWMujEGbBEH2Kt2hLUAgAAopoA=
Date:   Mon, 16 Aug 2021 22:02:28 +0000
Message-ID: <CO1PR02MB8489899CD7101180B2759D9C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
References: <CO1PR02MB8489A10983A22C72447EEB5C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
 <YRq81jcZIH5+/ZpB@kroah.com>
In-Reply-To: <YRq81jcZIH5+/ZpB@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca9d10d4-fa80-460f-f3f4-08d9610189c6
x-ms-traffictypediagnostic: MW4PR02MB7282:
x-microsoft-antispam-prvs: <MW4PR02MB728279B6D0D0CBB90539186994FD9@MW4PR02MB7282.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bDiBQCF4yT6HxNOfQb4brxCddtfPeVCRYSA73H2FRVxfp91e8pOR/pM9VMvtLUxGcaPgE+PGdpNbF65+NmE4XSHFNVjIrd0FF2nmm/KTYlutKhRYIWbhlNCO5q7KZ0c+rcpUaBHLHPMcFjFMGQfyq6I5OdA3dFfOL8cXyeqBE5s8IiEu5luG8SzKJysUGowu792hh4q3Uzoj/YHBDK62z50oJ9GoV0Kg8xbpP6vaoRwMoX8pJ7howZKBfhv/2bRZrl/bMY0LU7bpGRce/+kRqrGgkfmpfdmAMPPWukoXwXufUGz+79rTchFAWoElTI0FA34cGaNmLEMP+uNO7EFdjewSGMzC/17FeYEMkjJx65A49G3dd9rTjRnjK7SmRdFeU9W9iPEy6/SjSleFwWIzq14UGCcMHYs2XeC03ZcT7UUDoFxu1ZaUMcAYDF+TUbHM3pLUSvrTp849wdGs/Q1+2ocmqUuIbRTX4Q5dkE0JqCFY0GCmMVT+caPLQu83ai5fDq96L5ngazmSZgnCMoj8WyZrZsZZznjX3TdECMnaL4zQtkvQdc1jNicR+GXMFog0Utq4sNZiCs1OqM8E3Uj/LPdxPsqsoJNh8Z2r1AhOswsBPZpkcjjI5fRqLEm9YWrBUZJbjV0O/I7rmPFjAOJ3/6VtzmnDxr0LWq+CTflUzYc45LZPedxj6S6Q9lFmFs3Zk/B/9NAgD9QmS+HRfV5OVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR02MB8489.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(346002)(396003)(39860400002)(38100700002)(186003)(6916009)(8936002)(26005)(2906002)(86362001)(8676002)(4326008)(33656002)(83380400001)(122000001)(478600001)(54906003)(66946007)(71200400001)(7696005)(53546011)(76116006)(55016002)(38070700005)(66556008)(66476007)(6506007)(64756008)(66446008)(44832011)(9686003)(316002)(52536014)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?SvI3Y/Z22uGFVFk2R5B7nnzyXurGLfzEfglb8+ZVtOGye2GMhLgjINQ9OS?=
 =?iso-8859-1?Q?9PFXVtRUDriW+WxyXTDEoSWSe7N4hiCpzW2X+a6jiHMznLTXephXWvklxo?=
 =?iso-8859-1?Q?K676baUrhhq5C4MwAohIJfHzEZj/k/6waLPoG0myUG4h2XMqdZJp0NzR7q?=
 =?iso-8859-1?Q?LwxaHkkgQfDyJyrRPMeA3sTtydIz9zOjEsWiLl/X5lMhvUEBvw9xEPTHlK?=
 =?iso-8859-1?Q?nutA9maaRpNUcG9kY33/J11Vzx8FdBwjJc7FHXVuuVsTCZIZY4UturMq58?=
 =?iso-8859-1?Q?mhQPa0wZdoBm6YWvzPI0HH1XajOHTKu53IsTJnHo+l/1qcAJLfsbPqvoN0?=
 =?iso-8859-1?Q?njQ87W37pBIkVAM3CTVID6OjPZqUmA5ybplij/kPtRbin4uXffeyT3+UQV?=
 =?iso-8859-1?Q?FiSigl+rBrd6jc5t3qCDlwQgXIfe4vIR4LqHA4FBF4eLHACxX0NEIbrt2u?=
 =?iso-8859-1?Q?va0XXJMIBRIrE/9pv/NyGD668lE/sIPWny4HpIPJ0vjjgEvm3bGV6QQFXR?=
 =?iso-8859-1?Q?nogxMdd5xKJ8GKwWLEq6ysnDSO6r8oEs28yg0L3tEgdKG+eR7PLZc7L/3f?=
 =?iso-8859-1?Q?6jwDCbhQF4uyTJHVy3R9y7s1w/J/BIL8fW8hPPfBEF1SLaNY2CTCQF6psd?=
 =?iso-8859-1?Q?xJdta18d5IM93tlG462HKZCiajeg3sMnUv94itKJgnqnpehVcxWuve8UoH?=
 =?iso-8859-1?Q?x+rv+U3rNOHoX1nJQ4Drl0ZG+ZaS8kop5Mq1cDuP/+mz5weMBQef8u7TAe?=
 =?iso-8859-1?Q?vOkw/MxH3S/uMagqle54hlcLUyAsXK6Wdp2hDn5NtItPHsDgOa9LxUPVpq?=
 =?iso-8859-1?Q?o+Nw8urtE2PLZWDOYfa0hUxgynF5uOrwjEm0HFGEe7A5TTY1jYwAWh3Ncw?=
 =?iso-8859-1?Q?06X9k03hSPJq2MhjcWjt8lc8+RFyLw6x0LwhTbng1CTerSsVdZSiStEbmO?=
 =?iso-8859-1?Q?E/k7mcjesQi1ujejO4uE9mgLeTkNI3+tIhFVwp+HAhVnUtUCWZeuhaWOLI?=
 =?iso-8859-1?Q?aj3i9br0/oVcy4wxo+/cQvGDBdQEH5tBglqdhLTPDaIRUh889XQ/VkZpwo?=
 =?iso-8859-1?Q?bc7eu81puI2pkjwPHz9bfreyRORJy0KZPGU1r8SNylGXgwGIwitMKYHqfQ?=
 =?iso-8859-1?Q?s32nH5XLHn051UeBeem4K0sVT7Ldbl5dZkjaQr/SYman/T9u9lmRjy+fA8?=
 =?iso-8859-1?Q?mr2+5Nn/geWmCS4cjLIergM8TKT4kBiSbQkTsBQ+tU1kdPwQ5U+OglmiOF?=
 =?iso-8859-1?Q?VVYJVCytkcTzmkJpdwfkt7RVXEjvUZB9ngdDyqmSQRY7jslnk7m7fZ4WEr?=
 =?iso-8859-1?Q?OyEq3KAs1V6I59Dxi4dIDE9+xGbtzfPcUcQptG4Jhck5V7k=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR02MB8489.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca9d10d4-fa80-460f-f3f4-08d9610189c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 22:02:28.2521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TwOB+7aaYXj1EXOv/F3Sct/VFv+SOOd+oSwakc2xhlOBMZ7DaX/YZKQVzs5VsR275Ua1ya1x50myOt7WKjhR5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7282
X-Proofpoint-GUID: XvcyI5Nn9VvIWy0mATyKPSny0GHWwMqb
X-Proofpoint-ORIG-GUID: XvcyI5Nn9VvIWy0mATyKPSny0GHWwMqb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-16_08,2021-08-16_02,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, August 16, 2021 12:31 PM
> To: David Chen <david.chen@nutanix.com>
> Cc: stable@vger.kernel.org; Paul E. McKenney
> <paulmck@linux.vnet.ibm.com>; neeraju@codeaurora.org
> Subject: Re: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
>=20
> On Mon, Aug 16, 2021 at 07:19:34PM +0000, David Chen wrote:
> > Hi Greg,
> >
> > We recently hit a hung task timeout issue in=A0synchronize_rcu_expedite=
d on
> 4.14 branch.
> > The issue seems to be identical to the one described in `fd6bc19d7676
> > rcu: Fix missed wakeup of exp_wq waiters` Can we backport it to 4.14 an=
d
> 4.19 branch?
> > The patch doesn't apply cleanly, but it should be trivial to resolve,
> > just do this
> >
> > -		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(rsp-
> >expedited_sequence) & 0x3]);
> > +		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(s) & 0x3]);
> >
> > I don't know if we should do it for 4.9, because the handling of sequen=
ce
> number is a bit different.
>=20
> Please provide a working backport, me hand-editing patches does not scale=
,
> and this way you get the proper credit for backporting it (after testing =
it).

Sure, appended at the end.

>=20
> You have tested, this, right?

I don't have a good repro for the original issue, so I only ran rcutorture =
and
some basic work load test to see if anything obvious went wrong.

>=20
> thanks,
>=20
> greg k-h

--------

From 307a212335fe143027e3a9f7a9d548beead7ba33 Mon Sep 17 00:00:00 2001
From: Neeraj Upadhyay <neeraju@codeaurora.org>
Date: Tue, 19 Nov 2019 03:17:07 +0000
Subject: [PATCH] rcu: Fix missed wakeup of exp_wq waiters

[ Upstream commit fd6bc19d7676a060a171d1cf3dcbf6fd797eb05f ]

Tasks waiting within exp_funnel_lock() for an expedited grace period to
elapse can be starved due to the following sequence of events:

1.	Tasks A and B both attempt to start an expedited grace
	period at about the same time.	This grace period will have
	completed when the lower four bits of the rcu_state structure's
	->expedited_sequence field are 0b'0100', for example, when the
	initial value of this counter is zero.	Task A wins, and thus
	does the actual work of starting the grace period, including
	acquiring the rcu_state structure's .exp_mutex and sets the
	counter to 0b'0001'.

2.	Because task B lost the race to start the grace period, it
	waits on ->expedited_sequence to reach 0b'0100' inside of
	exp_funnel_lock(). This task therefore blocks on the rcu_node
	structure's ->exp_wq[1] field, keeping in mind that the
	end-of-grace-period value of ->expedited_sequence (0b'0100')
	is shifted down two bits before indexing the ->exp_wq[] field.

3.	Task C attempts to start another expedited grace period,
	but blocks on ->exp_mutex, which is still held by Task A.

4.	The aforementioned expedited grace period completes, so that
	->expedited_sequence now has the value 0b'0100'.  A kworker task
	therefore acquires the rcu_state structure's ->exp_wake_mutex
	and starts awakening any tasks waiting for this grace period.

5.	One of the first tasks awakened happens to be Task A.  Task A
	therefore releases the rcu_state structure's ->exp_mutex,
	which allows Task C to start the next expedited grace period,
	which causes the lower four bits of the rcu_state structure's
	->expedited_sequence field to become 0b'0101'.

6.	Task C's expedited grace period completes, so that the lower four
	bits of the rcu_state structure's ->expedited_sequence field now
	become 0b'1000'.

7.	The kworker task from step 4 above continues its wakeups.
	Unfortunately, the wake_up_all() refetches the rcu_state
	structure's .expedited_sequence field:

	wake_up_all(&rnp->exp_wq[rcu_seq_ctr(rcu_state.expedited_sequence) & 0x3])=
;

	This results in the wakeup being applied to the rcu_node
	structure's ->exp_wq[2] field, which is unfortunate given that
	Task B is instead waiting on ->exp_wq[1].

On a busy system, no harm is done (or at least no permanent harm is done).
Some later expedited grace period will redo the wakeup.  But on a quiet
system, such as many embedded systems, it might be a good long time before
there was another expedited grace period.  On such embedded systems,
this situation could therefore result in a system hang.

This issue manifested as DPM device timeout during suspend (which
usually qualifies as a quiet time) due to a SCSI device being stuck in
_synchronize_rcu_expedited(), with the following stack trace:

	schedule()
	synchronize_rcu_expedited()
	synchronize_rcu()
	scsi_device_quiesce()
	scsi_bus_suspend()
	dpm_run_callback()
	__device_suspend()

This commit therefore prevents such delays, timeouts, and hangs by
making rcu_exp_wait_wake() use its "s" argument consistently instead of
refetching from rcu_state.expedited_sequence.

Fixes: 3b5f668e715b ("rcu: Overlap wakeups with next expedited grace period=
")
Signed-off-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: David Chen <david.chen@nutanix.com>
---
 kernel/rcu/tree_exp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
index 46d61b597731..f90d10c1c3c8 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -534,7 +534,7 @@ static void rcu_exp_wait_wake(struct rcu_state *rsp, un=
signed long s)
 			spin_unlock(&rnp->exp_lock);
 		}
 		smp_mb(); /* All above changes before wakeup. */
-		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(rsp->expedited_sequence) & 0x3]);
+		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(s) & 0x3]);
 	}
 	trace_rcu_exp_grace_period(rsp->name, s, TPS("endwake"));
 	mutex_unlock(&rsp->exp_wake_mutex);
--=20
2.22.3

