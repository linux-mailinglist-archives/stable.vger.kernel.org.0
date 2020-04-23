Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04ACE1B6604
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 23:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgDWVNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 17:13:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44036 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbgDWVNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 17:13:35 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03NLDNNG032297;
        Thu, 23 Apr 2020 14:13:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=0uJeAqdPLqw94l+dV1Njb4xsZxCU/7uryhP0/teR86U=;
 b=q+SiZ4XElGA9JCJM0PQ3oRLkxONtJpNZ1Z5VaydQJH6Ssx3bw1JYViwfP5UVJX/0nOpm
 g6waBqIUs5d+4hjcQEiRpCjyTrNmnRzYxg85DhHsFo7hghHlEwCfY/C7uuY4eb4PmI5L
 6GaZYHjANKd+yFkDBSjiZS2nQafoq74Nl5g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30jq4jhfb9-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Apr 2020 14:13:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 23 Apr 2020 14:13:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6PyXqC8z/oocCJxrnINFX53mPWUqM3W9un6NmgTz0FThrNP5O4ixBZQJGHdMyybQyolx+fgAS98YfZ+sfx7zRtFQpKdHoFfE2tCtxUYS8uJsVRKU2Ulfe29yenxmn5MuLFJxkWWuc++i3Yosn/wwfbBrOy/QXtqeXEyBW3TqjRo3Vazc9URQ/UmITQbeRFVrIwlhvqlnakVucy9gMvjbzwSyTLm/xb712LSvjwKmOV/svSlDIAPrRBRFzDmHwIr0T9f3q7d+ZjtnMULZHMbpApf2aet3XbuwJ/lp8RcUuVBXYogU6qjHv2ojHtKukIUiOPZva9HFCvzlC4KmYMF1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uJeAqdPLqw94l+dV1Njb4xsZxCU/7uryhP0/teR86U=;
 b=nQ0S4PR+1vx1C9zSQL7ywb3VD4NlJNy58T7UmL6gN9DmR/NJUyeo7ejmf0P+xTsnHbaOjmJu1u2dO47IcEdAhfK9+p/lVZmCTBxpRHZL5DfrnNNs355m4XSvY3kcSwS1rJNK3tW8QOeGNXtLwtLrkqKfk83QJLgLWGGQ57vjToBN0gUBAnGvpmZq6HZcktrkYduQU1axednqfXz5rXcKq3k6mbWzseZWy38UuvjU0vx0ea+sRnAWMf9RDCtWLd1emD6eiiCozKxMzKnku7linIKFS3sRIylEnwNOZTrqGlERltpeHpK2VGeifKkwNf+JcfIYlTeqjg+UL1tJL353Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uJeAqdPLqw94l+dV1Njb4xsZxCU/7uryhP0/teR86U=;
 b=CVjJc2yu7v7xhOfRl+ZD00PFlPlRCmknRfD9nO+w36/dRYqv5CUPU0YuHGOOcgydtTbnG+uM5MXfBe0s2Th36qfxrLgfUJDtBUXEaw0/C3PW7E9FQAsI9l1h/FnCllzwW7hcRt8uLWQ3uK9aBuAZsHw1aOefs9PARk0tiM8GLc8=
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2309.namprd15.prod.outlook.com (2603:10b6:a02:8b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Thu, 23 Apr
 2020 21:13:24 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::bdf9:6577:1d2a:a275]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::bdf9:6577:1d2a:a275%7]) with mapi id 15.20.2937.012; Thu, 23 Apr 2020
 21:13:24 +0000
Date:   Thu, 23 Apr 2020 14:13:19 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Chris Down <chris@chrisdown.name>
CC:     Yafang Shao <laoar.shao@gmail.com>, <akpm@linux-foundation.org>,
        <mhocko@kernel.org>, <vdavydov.dev@gmail.com>,
        <linux-mm@kvack.org>, <stable@vger.kernel.org>,
        <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
Message-ID: <20200423211319.GC83398@carbon.DHCP.thefacebook.com>
References: <20200423061629.24185-1-laoar.shao@gmail.com>
 <20200423153323.GA1318256@chrisdown.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423153323.GA1318256@chrisdown.name>
X-ClientProxiedBy: MWHPR22CA0065.namprd22.prod.outlook.com
 (2603:10b6:300:12a::27) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:bd8b) by MWHPR22CA0065.namprd22.prod.outlook.com (2603:10b6:300:12a::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Thu, 23 Apr 2020 21:13:23 +0000
X-Originating-IP: [2620:10d:c090:400::5:bd8b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65692cf8-29f0-4525-c0d2-08d7e7cb2882
X-MS-TrafficTypeDiagnostic: BYAPR15MB2309:
X-Microsoft-Antispam-PRVS: <BYAPR15MB23098650D2D204C3A366BDBBBED30@BYAPR15MB2309.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03827AF76E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(376002)(396003)(366004)(346002)(39860400002)(136003)(6916009)(9686003)(8936002)(478600001)(2906002)(55016002)(86362001)(316002)(4326008)(33656002)(6506007)(52116002)(7696005)(1076003)(66946007)(6666004)(66556008)(66476007)(81156014)(16526019)(186003)(5660300002)(8676002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mKlsLRlRb/aKHxBFePykZE+sj7cUg3pnn4WK5Tsj3g14ez/zZY9feqbwrm+x1l594Yc1nCildidEjchhrMkIFK3aLpCl3MCfC2D2c68BRdYPg2WBhrnQOfWt2+gK1X4sHSAizlGGtBwYwdZ011uIM16OLqRAF++fhKHM0aW02eaYlSVchEci/ooaMgIPolF3U5f45WwL4QJWSqaNmtGICWEj0uBkTqkJyDflIIYyWXJ6Ped63XwgcPPD+37D3IvMWtuB44lE4qBTPvTL95NyKdmWefd5h1JqJR10lit3s8vom0stwRFEapzdH5KuOzCs6bVrlXVXKPcT0sypIRkC/1dxGchdplTLjtyHu8m0XRdjRIGI2HQdCt86gGJqyPUgjENwdpfiptLYq/8wTIn16WS1ZkSVECa79ivZy8Rzsm8Xlm9EXfE0bLXvljDXbODD
X-MS-Exchange-AntiSpam-MessageData: oSXkmGUITrnB1r4HHwXk6D0PGVZcNM0GgTjBM4YWsdhv0fqEuxZyfvoYYd+HAzAjlWNp8qzr5er+S8mLYB4hmUk+L4ye/+K7W2KXngX9tVHPshJ49abD8Inb2steFmDsjh8m8TFdm6yVEQXOolks0yfwbbVBusORnCbr5M4FOQMsZl5LHEu9Dvu8/0iGl0ph
X-MS-Exchange-CrossTenant-Network-Message-Id: 65692cf8-29f0-4525-c0d2-08d7e7cb2882
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2020 21:13:24.1169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 652vau3v39xmOXdTU/zn4P4oZIByBHDEjQ+U2MgLK0gCncojWVIJ8HHd/22JLhst
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2309
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-23_16:2020-04-23,2020-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=1 spamscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230152
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 23, 2020 at 04:33:23PM +0100, Chris Down wrote:
> Hi Yafang,
> 
> I'm afraid I'm just as confused as Michal was about the intent of this patch.
> 
> Can you please be more concise and clear about the practical ramifications
> and demonstrate some pathological behaviour? I really can't visualise what's
> wrong here from your explanation, and if I can't understand it as the person
> who wrote this code, I am not surprised others are also confused :-)
> 
> Or maybe Roman can try to explain, since he acked the previous patch? At
> least to me, the emin/elow behaviour seems fairly non-trivial to reason
> about right now.

Hi Chris!

So the thing is that emin/elow cached values are shared between global and
targeted (caused by memory.max) reclaim. It's racy by design, but in general
it should work ok, because in the end we'll reclaim or not approximately
the same amount of memory.

In the case which Yafang described, the emin value calculated in the process
of the global reclaim leads to a slowdown of the targeted reclaim. It's not
a tragedy, but not perfect too. It seems that the proposed patch makes it better,
and as now I don't see any bad consequences.

Thanks!
