Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1662226C47
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbgGTQsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:48:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59568 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389129AbgGTQsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 12:48:01 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KGeov0022118;
        Mon, 20 Jul 2020 09:46:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=WmImxihwqCrms0/6f1fFagjlktJFTvlbSTurvW7fOMo=;
 b=ibf6dRTVxvJCANMa1G0/328H1kMwjFOpkOs9Odre8ji7zP91X3szAdiFYZq2CJTsXPh1
 yFvAUD0LX/0/ZlUakrq50+TRcTzPyMIS3oBPFPD5wI/Q3NpWsH0dTYD7k3Uwz1aR6wIH
 FbLuYxVHccJC7LkUsi80AKGt1bgBI7uUqXw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32cgsp53ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 20 Jul 2020 09:46:16 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 20 Jul 2020 09:46:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdAZWfBYqfCWsmaDv0VSRuTpZpoPfn66okaSX5hydXeE3vtgp/b/3rralhlO/Q5BeZoLeyUE+0lJJSj2hNY/0zmYh0n5p/b+BKsqVfyvAJAjEU/RMnN+tzSw8foHlCfH6RSQXsZO9D9HEL30fPCEGqzHs6VDxsbgUGxi8FqqLtHSllCwEtI200ClOoNex04qUd4U/+wC0LAEtzVaLqnKWQL5bpaYisCUuHdzonn9gE4zTmOA2vDK3plI7YsmUwVx06QH3oi8xB2zcQHLZGVsTNtYBvfzmyRD0bNtVLl9CR11o5KhJSqR3YB/DXU9nbnxPpiBJUGq7biMAPLt8AXrGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJ6/T9M+n4R1CrSit1/rl9jtwChIHhUBvCB2V5epU1c=;
 b=azj6T8GkIiGUW/kSaemiulyhL0knxK57Er8zQomSXNKUgT8XvJZHs26i7Axq+Ns4CsLmltdJ3Bgk1Oafbg0iNfCfhY4GzszCHefhhB9fF4DCHBBwaqDOLn3tSEq8EUx/nLYJTEsuuT6n0P28BfNJwlmBBiQlnJjQglHMUplUFcj+GP86uIl3LyP8CwNIzuugPjFbVgvCOhTIuMfQkYMJMr6TSNgGxwTHNLTLHYlG6BaHsgWPiyxlRR9E0cCGMLC5ewPM1sIp6MCKYgFPducJMo1K5IonbURfXtKSrUPGdhb9Ah9v+D1YqdxKUA9qFrnI4yE5MeF467XUOb46mX4k+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJ6/T9M+n4R1CrSit1/rl9jtwChIHhUBvCB2V5epU1c=;
 b=FJQhjfCkDltoYFeheguV40IhRaAT/H8regN8HGlrzz928j77wzCpysjyO2KE0Cti5as8xBQJNI2AA1r0W1cRw5VxiZgNrQDIUDBgSi7KOKA6ddKirfSZJepX4cGXaXu64ZJbVUpaLhdO//IMrDDlmbFyGIkuvYViRB6NdlTqSMs=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3031.namprd15.prod.outlook.com (2603:10b6:a03:b4::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Mon, 20 Jul
 2020 16:46:14 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1%5]) with mapi id 15.20.3195.025; Mon, 20 Jul 2020
 16:46:14 +0000
Date:   Mon, 20 Jul 2020 09:46:10 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?iso-8859-1?Q?Dani=EBl?= Sonck <dsonck92@gmail.com>,
        Zhang Qiang <qiang.zhang@windriver.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.7 021/244] cgroup: fix cgroup_sk_alloc() for
 sk_clone_lock()
Message-ID: <20200720164541.GA139672@carbon.dhcp.thefacebook.com>
References: <20200720152825.863040590@linuxfoundation.org>
 <20200720152826.873682902@linuxfoundation.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200720152826.873682902@linuxfoundation.org>
X-ClientProxiedBy: BYAPR05CA0067.namprd05.prod.outlook.com
 (2603:10b6:a03:74::44) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:598e) by BYAPR05CA0067.namprd05.prod.outlook.com (2603:10b6:a03:74::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.17 via Frontend Transport; Mon, 20 Jul 2020 16:46:13 +0000
X-Originating-IP: [2620:10d:c090:400::5:598e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6133694d-8cd9-4551-f36d-08d82ccc6a1d
X-MS-TrafficTypeDiagnostic: BYAPR15MB3031:
X-Microsoft-Antispam-PRVS: <BYAPR15MB30313A3A07835DC321601B13BE7B0@BYAPR15MB3031.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yeZ9SZFtRAplirmMQ59S5kJsngqR3YdQsE0Tvq2q2FS42nqujWJQF2MlwQgoAyPvHgOVgOpLrBtjHLpHD77QDokidbf3jectJoQg8lTURLJ/uhaqQpJuy7L7+pU6OfqhAc6pkBGYT4n2Az3wZpHZ8rwxTA+3EtRgzzlo/xgvi5s6Y2CjmG2m5vy+AOnSKosZq+G8yp5dZ8L64LdFajSWMWhNEx7tPODlS4M72lPYikKLRlUaIELp7qP2T+KFU3BdBQo3xCLDl6CKLs/O+mRfzhMA+wqKzy1hgWucCIMSagkg7KbYpVVWTQw8dJGm0Z2Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(136003)(346002)(39860400002)(2906002)(83380400001)(7416002)(8676002)(66476007)(66946007)(66556008)(86362001)(5660300002)(4326008)(54906003)(1076003)(66574015)(316002)(478600001)(33656002)(52116002)(9686003)(8936002)(6916009)(55016002)(6506007)(186003)(16526019)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: bvUF/doe+8EZ7WxmVctLTFRxhrNeaYoY5UHVyb9OAw4J40Bpsh2+IHzvCo5HaH9AzuvjTBgwBVY3BBPkec0sqbtaPkDrx5fWoK6Jva3lejArbwuJ9MpX2n/BTtUZuMlLnaJWiFVSPv1D8g0F8F/lqWSJDe//5AdmsbhKV4YRR+Asa6g8pHez/HqDauAEy20fEZ5D/MsKFdjK0vbwsUwzqtbxfHVkJNGZrMfeFc46opK+hLIcBdiyjMkJBuGJgrPpw2XTZJ8ips3mkjCj8fdOVkszNyeFDTCgbaWtlhEA5Ob1xNpuWO+aKwkpQ2Wc+x7NP6m9+twGp4/ENc34NDpS6r+tZmFj+zh+/QLSXDLl39rZME8KCU00q0fA5OOVwrosm/MdVbdO3GZph/GG+SJitWMfcTnr8k6vYFOZ91j9sd97RvEM8tTm0dOSFaeN6O2fOt9tmzlgg3HwWRUgkkdR/59FE4LZN9HWgjFLuJPzMf0aC6qdsdKSXs1FjkLlREZHRNkYmnzMnK0Mte+P6bqgrw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6133694d-8cd9-4551-f36d-08d82ccc6a1d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2020 16:46:14.1641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2fKyQp+DPZirsahf94In3isyiYGnqKFFIrJaVBD77RXZt/SVnNvEB3b5KZYjwFVW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3031
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1011 suspectscore=5 priorityscore=1501
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007200112
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 20, 2020 at 05:34:52PM +0200, Greg Kroah-Hartman wrote:
> From: Cong Wang <xiyou.wangcong@gmail.com>
> 
> [ Upstream commit ad0f75e5f57ccbceec13274e1e242f2b5a6397ed ]

Hi Greg!

There is a fix for this commit:
14b032b8f8fc ("cgroup: Fix sock_cgroup_data on big-endian.")

Can you, please, grab it too?

Thanks!

> 
> When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
> copied, so the cgroup refcnt must be taken too. And, unlike the
> sk_alloc() path, sock_update_netprioidx() is not called here.
> Therefore, it is safe and necessary to grab the cgroup refcnt
> even when cgroup_sk_alloc is disabled.
> 
> sk_clone_lock() is in BH context anyway, the in_interrupt()
> would terminate this function if called there. And for sk_alloc()
> skcd->val is always zero. So it's safe to factor out the code
> to make it more readable.
> 
> The global variable 'cgroup_sk_alloc_disabled' is used to determine
> whether to take these reference counts. It is impossible to make
> the reference counting correct unless we save this bit of information
> in skcd->val. So, add a new bit there to record whether the socket
> has already taken the reference counts. This obviously relies on
> kmalloc() to align cgroup pointers to at least 4 bytes,
> ARCH_KMALLOC_MINALIGN is certainly larger than that.
> 
> This bug seems to be introduced since the beginning, commit
> d979a39d7242 ("cgroup: duplicate cgroup reference when cloning sockets")
> tried to fix it but not compeletely. It seems not easy to trigger until
> the recent commit 090e28b229af
> ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups") was merged.
> 
> Fixes: bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup")
> Reported-by: Cameron Berkenpas <cam@neo-zeon.de>
> Reported-by: Peter Geis <pgwipeout@gmail.com>
> Reported-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> Reported-by: Daniël Sonck <dsonck92@gmail.com>
> Reported-by: Zhang Qiang <qiang.zhang@windriver.com>
> Tested-by: Cameron Berkenpas <cam@neo-zeon.de>
> Tested-by: Peter Geis <pgwipeout@gmail.com>
> Tested-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Zefan Li <lizefan@huawei.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <guro@fb.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  include/linux/cgroup-defs.h |    6 ++++--
>  include/linux/cgroup.h      |    4 +++-
>  kernel/cgroup/cgroup.c      |   31 +++++++++++++++++++------------
>  net/core/sock.c             |    2 +-
>  4 files changed, 27 insertions(+), 16 deletions(-)
> 
> --- a/include/linux/cgroup-defs.h
> +++ b/include/linux/cgroup-defs.h
> @@ -790,7 +790,8 @@ struct sock_cgroup_data {
>  	union {
>  #ifdef __LITTLE_ENDIAN
>  		struct {
> -			u8	is_data;
> +			u8	is_data : 1;
> +			u8	no_refcnt : 1;
>  			u8	padding;
>  			u16	prioidx;
>  			u32	classid;
> @@ -800,7 +801,8 @@ struct sock_cgroup_data {
>  			u32	classid;
>  			u16	prioidx;
>  			u8	padding;
> -			u8	is_data;
> +			u8	no_refcnt : 1;
> +			u8	is_data : 1;
>  		} __packed;
>  #endif
>  		u64		val;
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -822,6 +822,7 @@ extern spinlock_t cgroup_sk_update_lock;
>  
>  void cgroup_sk_alloc_disable(void);
>  void cgroup_sk_alloc(struct sock_cgroup_data *skcd);
> +void cgroup_sk_clone(struct sock_cgroup_data *skcd);
>  void cgroup_sk_free(struct sock_cgroup_data *skcd);
>  
>  static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
> @@ -835,7 +836,7 @@ static inline struct cgroup *sock_cgroup
>  	 */
>  	v = READ_ONCE(skcd->val);
>  
> -	if (v & 1)
> +	if (v & 3)
>  		return &cgrp_dfl_root.cgrp;
>  
>  	return (struct cgroup *)(unsigned long)v ?: &cgrp_dfl_root.cgrp;
> @@ -847,6 +848,7 @@ static inline struct cgroup *sock_cgroup
>  #else	/* CONFIG_CGROUP_DATA */
>  
>  static inline void cgroup_sk_alloc(struct sock_cgroup_data *skcd) {}
> +static inline void cgroup_sk_clone(struct sock_cgroup_data *skcd) {}
>  static inline void cgroup_sk_free(struct sock_cgroup_data *skcd) {}
>  
>  #endif	/* CONFIG_CGROUP_DATA */
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -6447,18 +6447,8 @@ void cgroup_sk_alloc_disable(void)
>  
>  void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
>  {
> -	if (cgroup_sk_alloc_disabled)
> -		return;
> -
> -	/* Socket clone path */
> -	if (skcd->val) {
> -		/*
> -		 * We might be cloning a socket which is left in an empty
> -		 * cgroup and the cgroup might have already been rmdir'd.
> -		 * Don't use cgroup_get_live().
> -		 */
> -		cgroup_get(sock_cgroup_ptr(skcd));
> -		cgroup_bpf_get(sock_cgroup_ptr(skcd));
> +	if (cgroup_sk_alloc_disabled) {
> +		skcd->no_refcnt = 1;
>  		return;
>  	}
>  
> @@ -6483,10 +6473,27 @@ void cgroup_sk_alloc(struct sock_cgroup_
>  	rcu_read_unlock();
>  }
>  
> +void cgroup_sk_clone(struct sock_cgroup_data *skcd)
> +{
> +	if (skcd->val) {
> +		if (skcd->no_refcnt)
> +			return;
> +		/*
> +		 * We might be cloning a socket which is left in an empty
> +		 * cgroup and the cgroup might have already been rmdir'd.
> +		 * Don't use cgroup_get_live().
> +		 */
> +		cgroup_get(sock_cgroup_ptr(skcd));
> +		cgroup_bpf_get(sock_cgroup_ptr(skcd));
> +	}
> +}
> +
>  void cgroup_sk_free(struct sock_cgroup_data *skcd)
>  {
>  	struct cgroup *cgrp = sock_cgroup_ptr(skcd);
>  
> +	if (skcd->no_refcnt)
> +		return;
>  	cgroup_bpf_put(cgrp);
>  	cgroup_put(cgrp);
>  }
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1837,7 +1837,7 @@ struct sock *sk_clone_lock(const struct
>  		/* sk->sk_memcg will be populated at accept() time */
>  		newsk->sk_memcg = NULL;
>  
> -		cgroup_sk_alloc(&newsk->sk_cgrp_data);
> +		cgroup_sk_clone(&newsk->sk_cgrp_data);
>  
>  		rcu_read_lock();
>  		filter = rcu_dereference(sk->sk_filter);
> 
> 
