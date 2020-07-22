Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70CE229FA8
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 20:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgGVSvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 14:51:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46024 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgGVSvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 14:51:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06MIhL3E130198;
        Wed, 22 Jul 2020 18:50:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=C/y7nOWN2zZL8t7wViPxEtK7Dpw4bYa251sNZduPTUI=;
 b=kfhvgLnnRnVduoCN7BiAlRJeiFcydBpsKpk3H3LvTTQL0V/Xjuc7F+MYz8Qtg9FvrR72
 01AuL4uqCujMX9h0uNuhfLP/vi0mIybit3wj1/dWwtuMC/Qn41ZnHwpq8Ii5kpmSVxrP
 vHy7wwTEUuoUAW+qup38aSeAJEn1ClbMjgYJ8nyDn8/2G39amkB6DTV65TywLTyishla
 LLz6eO3M2yrtis/aybW5mKqYNw9W7uypLsb6M3W1d1k8e05I4cUCXzdHoxXRgd/tf5eF
 8UJPzzpztOJU5rOe7Xvuy9dLSd0oSqoTj4s4ZLaOxs1TRcbMMBdu7MJtJo8OdjhbvnX8 Uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32d6kssbxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jul 2020 18:50:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06MIi6nW167531;
        Wed, 22 Jul 2020 18:50:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32eq20erpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jul 2020 18:50:52 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06MIopgc012980;
        Wed, 22 Jul 2020 18:50:51 GMT
Received: from localhost (/10.175.216.251)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jul 2020 11:50:51 -0700
Date:   Wed, 22 Jul 2020 20:50:47 +0200
From:   Gregory Herrero <gregory.herrero@oracle.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] recordmcount: only record relocation of type
 R_AARCH64_CALL26 on arm64.
Message-ID: <20200722185047.GW17377@ltoracle>
References: <20200717143338.19302-1-gregory.herrero@oracle.com>
 <20200717133003.025f2096@oasis.local.home>
 <20200722163650.GI27540@gaia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722163650.GI27540@gaia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9690 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007220119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9690 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220119
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 22, 2020 at 05:36:50PM +0100, Catalin Marinas wrote:
> On Fri, Jul 17, 2020 at 01:30:03PM -0400, Steven Rostedt wrote:
> > On Fri, 17 Jul 2020 16:33:38 +0200
> > gregory.herrero@oracle.com wrote:
> > > From: Gregory Herrero <gregory.herrero@oracle.com>
> > > Currently, if a section has a relocation to '_mcount' symbol, a new
> > > __mcount_loc entry will be added whatever the relocation type is.
> > > This is problematic when a relocation to '_mcount' is in the middle of a
> > > section and is not a call for ftrace use.
> > > 
> > > Such relocation could be generated with below code for example:
> > >     bool is_mcount(unsigned long addr)
> > >     {
> > >         return (target == (unsigned long) &_mcount);
> > >     }
> > > 
> > > With this snippet of code, ftrace will try to patch the mcount location
> > > generated by this code on module load and fail with:
> > > 
> > >     Call trace:
> > >      ftrace_bug+0xa0/0x28c
> > >      ftrace_process_locs+0x2f4/0x430
> > >      ftrace_module_init+0x30/0x38
> > >      load_module+0x14f0/0x1e78
> > >      __do_sys_finit_module+0x100/0x11c
> > >      __arm64_sys_finit_module+0x28/0x34
> > >      el0_svc_common+0x88/0x194
> > >      el0_svc_handler+0x38/0x8c
> > >      el0_svc+0x8/0xc
> > >     ---[ end trace d828d06b36ad9d59 ]---
> > >     ftrace failed to modify
> > >     [<ffffa2dbf3a3a41c>] 0xffffa2dbf3a3a41c
> > >      actual:   66:a9:3c:90
> > >     Initializing ftrace call sites
> > >     ftrace record flags: 2000000
> > >      (0)
> > >     expected tramp: ffffa2dc6cf66724
> > > 
> > > So Limit the relocation type to R_AARCH64_CALL26 as in perl version of
> > > recordmcount.
> > 
> > I'd rather have this go through the arm64 tree, as they can test it
> > better than I can.
> > 
> > Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> Thanks Steve.
> 
> > > Fixes: ed60453fa8f8 ("ARM: 6511/1: ftrace: add ARM support for C version of recordmcount")
> 
> This Fixes tag looks wrong. The above commit was for arm32.
> 
Thanks for catching this.
It should be as below instead:

  Fixes: af64d2aa872a ("ftrace: Add arm64 support to recordmcount")

Should I send a V2?

Thanks,
Greg
