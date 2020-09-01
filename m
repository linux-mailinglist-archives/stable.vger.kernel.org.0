Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AE4258767
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 07:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgIAF2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 01:28:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12180 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725930AbgIAF2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 01:28:41 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08153tK5060925;
        Tue, 1 Sep 2020 01:28:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=fxq6vv1+CDmGN4WYIIO/oXSXu/uA8PfSv+kaDlXlLGU=;
 b=iM3JorTFD2GH+6uW8Z1m7Klmhh5KGLYIePqtq2Cunwxr374Jqg2ovlWhjlypgyPVm61e
 yfHk+O8YPrGzmFa9cgr+pnYPy4wJ1NNF984OGXY+M5pCIHNsTwdCykWiGcxFi1Cf5Q4y
 cZRPz1x8R+iAtO3ZHz8t7Nch0NIlMolxQt1h9dQrnEp5k78JjSuAfzQJdED2Ri24VoeI
 id2tdRtdBYJni4QAg097oSClLg9dAL9PRBPoNkxb1VqWp4brVaHNEAFLXIeGhdZtAjsj
 lRy/OuUkao5V96k6OnqJ8gZhz50ai0IBiYBHGerK7uaNE8/mcG4xAUkBIzWqakKo0VgH 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 339c0m5duv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 01:28:30 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08155Dak064976;
        Tue, 1 Sep 2020 01:28:30 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 339c0m5duf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 01:28:29 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0815NMN0018674;
        Tue, 1 Sep 2020 05:28:28 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 337e9gu1dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 05:28:28 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0815SPqu28246306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Sep 2020 05:28:26 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C73F0AE058;
        Tue,  1 Sep 2020 05:28:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5ACDEAE056;
        Tue,  1 Sep 2020 05:28:22 +0000 (GMT)
Received: from in.ibm.com (unknown [9.85.70.193])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  1 Sep 2020 05:28:22 +0000 (GMT)
Date:   Tue, 1 Sep 2020 10:58:19 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Pavel Tatashin <pasha.tatashin@soleen.com>
Cc:     Roman Gushchin <guro@fb.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 00/28] The new cgroup slab memory controller
Message-ID: <20200901052819.GA52094@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <20200127173453.2089565-1-guro@fb.com>
 <20200130020626.GA21973@in.ibm.com>
 <20200130024135.GA14994@xps.DHCP.thefacebook.com>
 <CA+CK2bCQcnTpzq2wGFa3D50PtKwBoWbDBm56S9y8c+j+pD+KSw@mail.gmail.com>
 <20200813000416.GA1592467@carbon.dhcp.thefacebook.com>
 <CA+CK2bDDToW=Q5RgeWkoN3_rUr3pyWGVb9MraTzM+DM3OZ+tdg@mail.gmail.com>
 <CA+CK2bBEHFuLLg79_h6bv4Vey+B0B2YXyBxTBa=Le12OKbNdwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bBEHFuLLg79_h6bv4Vey+B0B2YXyBxTBa=Le12OKbNdwA@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_04:2020-08-31,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 malwarescore=0 clxscore=1011
 suspectscore=1 phishscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010045
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 28, 2020 at 12:47:03PM -0400, Pavel Tatashin wrote:
> There appears to be another problem that is related to the
> cgroup_mutex -> mem_hotplug_lock deadlock described above.
> 
> In the original deadlock that I described, the workaround is to
> replace crash dump from piping to Linux traditional save to files
> method. However, after trying this workaround, I still observed
> hardware watchdog resets during machine  shutdown.
> 
> The new problem occurs for the following reason: upon shutdown systemd
> calls a service that hot-removes memory, and if hot-removing fails for
> some reason systemd kills that service after timeout. However, systemd
> is never able to kill the service, and we get hardware reset caused by
> watchdog or a hang during shutdown:
> 
> Thread #1: memory hot-remove systemd service
> Loops indefinitely, because if there is something still to be migrated
> this loop never terminates. However, this loop can be terminated via
> signal from systemd after timeout.
> __offline_pages()
>       do {
>           pfn = scan_movable_pages(pfn, end_pfn);
>                   # Returns 0, meaning there is nothing available to
>                   # migrate, no page is PageLRU(page)
>           ...
>           ret = walk_system_ram_range(start_pfn, end_pfn - start_pfn,
>                                             NULL, check_pages_isolated_cb);
>                   # Returns -EBUSY, meaning there is at least one PFN that
>                   # still has to be migrated.
>       } while (ret);
> 
> Thread #2: ccs killer kthread
>    css_killed_work_fn
>      cgroup_mutex  <- Grab this Mutex
>      mem_cgroup_css_offline
>        memcg_offline_kmem.part
>           memcg_deactivate_kmem_caches
>             get_online_mems
>               mem_hotplug_lock <- waits for Thread#1 to get read access
> 
> Thread #3: systemd
> ksys_read
>  vfs_read
>    __vfs_read
>      seq_read
>        proc_single_show
>          proc_cgroup_show
>            mutex_lock -> wait for cgroup_mutex that is owned by Thread #2
> 
> Thus, thread #3 systemd stuck, and unable to deliver timeout interrupt
> to thread #1.
> 
> The proper fix for both of the problems is to avoid cgroup_mutex ->
> mem_hotplug_lock ordering that was recently fixed in the mainline but
> still present in all stable branches. Unfortunately, I do not see a
> simple fix in how to remove mem_hotplug_lock from
> memcg_deactivate_kmem_caches without using Roman's series that is too
> big for stable.

We too are seeing this on Power systems when stress-testing memory
hotplug, but with the following call trace (from hung task timer)
instead of Thread #2 above:

__switch_to
__schedule
schedule
percpu_rwsem_wait
__percpu_down_read
get_online_mems
memcg_create_kmem_cache
memcg_kmem_cache_create_func
process_one_work
worker_thread
kthread
ret_from_kernel_thread

While I understand that Roman's new slab controller patchset will fix
this, I also wonder if infinitely looping in the memory unplug path
with mem_hotplug_lock held is the right thing to do? Earlier we had
a few other exit possibilities in this path (like max retries etc)
but those were removed by commits:

72b39cfc4d75: mm, memory_hotplug: do not fail offlining too early
ecde0f3e7f9e: mm, memory_hotplug: remove timeout from __offline_memory

Or, is the user-space test is expected to induce a signal back-off when
unplug doesn't complete within a reasonable amount of time?

Regards,
Bharata.

