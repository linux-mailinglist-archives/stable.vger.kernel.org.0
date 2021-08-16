Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C142E3EDDC1
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 21:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhHPTUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 15:20:13 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:23680 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229556AbhHPTUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 15:20:12 -0400
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17GJ8HwS022495;
        Mon, 16 Aug 2021 12:19:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=proofpoint20171006;
 bh=YNO86e1IrdqEb3FFC3RTUodsnRA8apvoorVdZb1u2Ns=;
 b=wGo2127flgBM3JmZS+ozr1nWN8IQ0NB2D12/KT5NSsWGjEZ4bfGALeNWzNaUAc6FUJoC
 twE4alUx6xTpTantrr8pA1zCAbXRQDtb+FpI7TCEZh/JDFzlP19uVQopjkVdOyS7mO7n
 rOgDphdVKQFsVhDuhdGH53Kfz5D9nrYoZapOkOAQeqymW5UP2178MU6K5sRbfSSbUopD
 pKI7ha1vbtP24L7oIpf2ihLzYxAyQMmD5gCrKz/kjeU1+BPlpbbSe32+ivd8FtR9cVck
 1Ig697vTjoWOHye0W/WaBa6aQ0L4yo5e5Pzcm4AZ4pu7IsOefpOzyj6QUOsCF0xZFl3U Jw== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2172.outbound.protection.outlook.com [104.47.73.172])
        by mx0a-002c1b01.pphosted.com with ESMTP id 3afqn5rvcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 12:19:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eM8Jz88fixs6WpN2ZWK9g54zgWQB3IrabtQKpSEounifoYWpyAHBDbsFfG3HL3PZURlmo6cHos+xxmth9js1DJN3CWvlyAmc6YOt+2DDyJoUVv+JhGXUUl9FUSqQiblMljJkYTbtq5bEH6b6Egl/SLOG7QeTH495K+xm5jBCiez6Ctt/cprZRXOQJXp54iQT3YeDgjVA6HtMElScuQZAto8WPi+dsDFQ3oJG5J+3PxITrnQZ8a6Ur6vHYENAxrK441J9EMpTtPc30lqwPBJB6OKZRj/1XX7k6EiTFT+CdnJmUnKBEHE/bRQnE+QEQbkp9uMuIyJnx/fKIJaJZNaHkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNO86e1IrdqEb3FFC3RTUodsnRA8apvoorVdZb1u2Ns=;
 b=KhVfsJ6wbQNL9CU4RCvS4i//52pwQCNc3ktEs1493LkFr/o5wj20Qaz5PMlDSdbubYHbG41bOR0AysXH7+ua+boGrj6tyhqb7M4z5HEW4HUHPR65xz5oM0Lpb1Y+T5Qqx0j+u0yY4a9BXeQJ3sz7twgfDgLLxhXZmaoNGa8kuIr+SeziroA+i/5KVAihs4Pg88POPTy5rRuJeK7Hspe+nKCFaac9Z3a7Zxi7UyJerNLlgG6+l7YajObBLenx+sNiXFUTaKRrqeQlvV2nOKs+I0a37lfypR6+pFMfaibr6seS1Bp6PzN86bIsLVXvpUCCdzwt05+pM/LP6U/DftAbdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO1PR02MB8489.namprd02.prod.outlook.com (2603:10b6:303:158::17)
 by MWHPR0201MB3531.namprd02.prod.outlook.com (2603:10b6:301:7c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Mon, 16 Aug
 2021 19:19:34 +0000
Received: from CO1PR02MB8489.namprd02.prod.outlook.com
 ([fe80::84b4:fa2:b281:c43]) by CO1PR02MB8489.namprd02.prod.outlook.com
 ([fe80::84b4:fa2:b281:c43%9]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 19:19:34 +0000
From:   David Chen <david.chen@nutanix.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "neeraju@codeaurora.org" <neeraju@codeaurora.org>
Subject: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
Thread-Topic: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
Thread-Index: AQHXktGCsfrxxwEReUWMujEGbBEH2A==
Date:   Mon, 16 Aug 2021 19:19:34 +0000
Message-ID: <CO1PR02MB8489A10983A22C72447EEB5C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f0a82d3-5b42-4820-c53f-08d960eac803
x-ms-traffictypediagnostic: MWHPR0201MB3531:
x-microsoft-antispam-prvs: <MWHPR0201MB3531403A5790D3160C4092EC94FD9@MWHPR0201MB3531.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZMqhg8FV8FyKrv1STbrcVFYlZNpsvYRboFph8gyfC9mL28hWXqKsSuNTV7gR9DRmd4U04NTo479vVE+xbrWOsd6akIXE6GR7BID8GBDkXKsknAF0fNY6h2/NvchhWHJABemTH4kty4yOj2DJX8ySKY/ts7wgG4h6c5v51htWkI5+qIpze0rCbNXoYmPKF9+9XedHxNLmjFGguDOgPF32jDZ9qflNbemu6iQ7esocy1FmxLck+kCkNnd7lGjGAVmTH0oZjHxFZU1mdOrc9SnFzOSODxT4wRPnf1V5y3DVpa4kVi8ofUNg9hySmqzqY60wlT9BgnZvUEPf0JB6QRRAGc58NI87nb0J+epcrufLIQ5JQy29dTcRjFmU+FtWwtfUXBylb9s9BV20bAStitSLcjZ/Ldrm2AbmmvC1DamfdWrIwNPhlhDwDicxmksOYAoeY5ks3XN7zKsThW1njc1Z5Y/ol0o2kEZxND5g11WVRa8oI2SdRycA9iXzN7UlFMBTE6JmFcjkUnG9HjN2rd9jDb5M5Rho7t69Cez6/2xoFqLqVV0ecFT1B8ftIfR5UaGz6duRusXWLTqsF04LNyNsRYDjrlLjNDUqaJDkvZptVhMG6osn2s2oggpyRdCh9IEx4BGOx3eRowMU7MUz67TW7b57vTFRZVxD0V8Lv+1gzvQDvYlINzzCU+WyyIwr1r6gulMy4X3D3cW2/ikis12QJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR02MB8489.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(376002)(39860400002)(136003)(38100700002)(55016002)(7696005)(6506007)(8936002)(316002)(9686003)(52536014)(33656002)(54906003)(38070700005)(8676002)(83380400001)(186003)(44832011)(6916009)(26005)(122000001)(91956017)(64756008)(76116006)(66446008)(71200400001)(4326008)(2906002)(5660300002)(4744005)(478600001)(86362001)(66476007)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?0HXa+h3xLw9uQLP4gdFxZ6r9EmRxQtQahp5hMlOcBPWceaycR6l2LlVOsO?=
 =?iso-8859-1?Q?XbyCZkpUvd+p4Dsvn0UrAQ9K1aQWJb1DvBC4XwZ5rHDpbuVttHdvIVqWo5?=
 =?iso-8859-1?Q?rgTlBszpmAdPTn55Z8/dCG/9LpMQ34oYLosWFbLYQXSM48XDETtZ88CicQ?=
 =?iso-8859-1?Q?EoiEut0jXy9K9RluXOH5ijbzpzONH5HCciScaR4AV9JOE/9jPPsA4bbgRY?=
 =?iso-8859-1?Q?3p8/YhcPXM6ARP4OqQ/86DGsLXqJE8hibliDWPjpDD4Y9uS58+qPuqtyCe?=
 =?iso-8859-1?Q?EBSGVNDv4qbmFPVCcSurasfVJrLzpeRo3nbO0JVVZhNKjWupDwReWEM682?=
 =?iso-8859-1?Q?kK2G+RsZc7sf1t1QU5EfKOmpJH+t5UGPdG5FgYKVg8dE5CnTUvLZdyntXd?=
 =?iso-8859-1?Q?tPmjy6Cc/3F+o5KGARWPdWGMF55tsegYmFCjhVc52dmmlkEUWrCwQZDSKm?=
 =?iso-8859-1?Q?T1kk+QnVOLsw2+oYC2l3IBBOQmw2PvlWeDRwjWy4BMTKmfCz7YF0nKTHNC?=
 =?iso-8859-1?Q?WiW7KY9wYitT4RfB25LBNFHeQmIxCx3T6ywm0ULiCmVr8ENDMPoK8vEZUg?=
 =?iso-8859-1?Q?Qugg1HdugMF1Q2ZlPvYLdICe+giuJQakT/Sau6SEEXkkaxMyxGwE9esI/l?=
 =?iso-8859-1?Q?V3lUUdV8nAciSczG+cTWCCPwF4nAR6dvf4bZEuWiQFSzu5DSNEJFoaxIpi?=
 =?iso-8859-1?Q?YCCkgGKDYciXLBIvcl4mzkq0S9T8bjI3tZt+JzvvunD+UWWAkp1hRz3Dvr?=
 =?iso-8859-1?Q?ihKnnzmpNwmfSwwApAtxmwT5DIlggln/hb+k79uEEPV6HRQIZ8QDYZ3r4v?=
 =?iso-8859-1?Q?AE2E2kU/WqnRQWf/bwcpC/+jfg8EqyVMiZiMa+QebDYLfYpstCqf+79lFb?=
 =?iso-8859-1?Q?UARMeqOGhT8uhSy6gxuH375VG+HcCVTMB6TyLi2GKR/3VOHn6Lqumym9vJ?=
 =?iso-8859-1?Q?DpLY5CKWzzxaQJtK7LroopO7VWbsxZ3PIjzsV/wy+cC/5/TdKi9e1md8NR?=
 =?iso-8859-1?Q?caJOm+WEALcULjn98YRPY1QKJycbaTv4bpZNA8vLhh94Uk8JW92xanUTZV?=
 =?iso-8859-1?Q?Okwl+UEnZPbW0yXqZNPOjhvZpRe+opoYTsrFIoECqquTO95i6xhM2gUrei?=
 =?iso-8859-1?Q?N1yN3i8p2CDIKevTghe82lMGBARXkGcVURsEGASfHJ7OgRftPCKTm6sRZa?=
 =?iso-8859-1?Q?YhkW0YgE7I3U5iEoy5GUaMHR8K6wggPPIwDKHPDPct9I1NNMDspCqiRuTB?=
 =?iso-8859-1?Q?y+hhAvPpf1Glp5V/5we0Us22S+RnoK5sIWbtTmthu9JTxThF+Vu3hgv3cl?=
 =?iso-8859-1?Q?8PFvAlej909fI+8qrfC5rsYWqBpaJPDo53pQo/DOh71QWdA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR02MB8489.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0a82d3-5b42-4820-c53f-08d960eac803
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 19:19:34.2446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 08UaAKjDgIJPQV6Vzx4FKuzbchB49sxeCYjjbJ2chcUW/ESAJnrd33RPkV0H7hTj1T0FpU5tv9wNcOCD0JngHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0201MB3531
X-Proofpoint-GUID: RwMkGtokcXQwuixN9BXXq_BViHoJ8p-y
X-Proofpoint-ORIG-GUID: RwMkGtokcXQwuixN9BXXq_BViHoJ8p-y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-16_07,2021-08-16_02,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,=0A=
=0A=
We recently hit a hung task timeout issue in=A0synchronize_rcu_expedited on=
 4.14 branch.=0A=
The issue seems to be identical to the one described in `fd6bc19d7676 rcu: =
Fix missed wakeup of exp_wq waiters`=0A=
Can we backport it to 4.14 and 4.19 branch?=0A=
The patch doesn't apply cleanly, but it should be trivial to resolve, just =
do this=0A=
=0A=
-		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(rsp->expedited_sequence) & 0x3]);=
=0A=
+		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(s) & 0x3]);=0A=
=0A=
I don't know if we should do it for 4.9, because the handling of sequence n=
umber is a bit different.=0A=
=0A=
Thanks,=0A=
David=
