Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C417F41120E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 11:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhITJtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 05:49:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39404 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229565AbhITJtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 05:49:00 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18K9SwpJ025729;
        Mon, 20 Sep 2021 05:47:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=ETtu+5Pc20bD6D7zi+b403rZ0SKWKGkwZh6X1dWOqn8=;
 b=Zm47I09FTgx0OO9B2FxhD7LlupZAxb5EysrcUEFUpXDK8NcEqT+vhrsqb/h5EvcqUf/P
 /L379gAokvRxdVFrq/VjzbLaeqhbmdtkYBNDmCTmBD5JKIWEkSXaLQYO4acy6bUICDdm
 K4puP1Fz26Ykw2nE00bEO0Q93cjUqimxiL3ajSC8YpOxMdACke+qGCBlrZSTnS1T/3B+
 sP0h3s8M4KM8QrrjxXZ4Nfba3SGf2omokFuWi9lCMEXRc1Nnzc2UEXhiZUTSCBBmYEBF
 Zfpj9e8gz9TcVgVUx3EuaYxmu3b2MjGII6jRNxVPXRd8RXwl8opXHOa2tWUpQQ3/i0Bb qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w4ddsb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 05:47:05 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18K92oe7010353;
        Mon, 20 Sep 2021 05:47:04 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w4ddsa8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 05:47:04 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18K9h7PU016918;
        Mon, 20 Sep 2021 09:47:01 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3b57r96g41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:47:01 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18K9kxf751970518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 09:46:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46249AE053;
        Mon, 20 Sep 2021 09:46:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34E68AE04D;
        Mon, 20 Sep 2021 09:46:58 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.153.169])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 20 Sep 2021 09:46:58 +0000 (GMT)
Date:   Mon, 20 Sep 2021 12:46:56 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     Borislav Petkov <bp@alien8.de>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        marmarek@invisiblethingslab.com, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org, x86@kernel.org
Subject: Re: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
Message-ID: <YUhYkKDe364BGb2f@linux.ibm.com>
References: <20210914094108.22482-1-jgross@suse.com>
 <163178944634.25758.17304720937855121489.tip-bot2@tip-bot2>
 <4422257385dbee913eb5270bda5fded7fbb993ab.camel@gmx.de>
 <YUdwMm9ncgNuuN4f@zn.tnic>
 <d315decb-2c95-da81-e8e9-9e4a44252656@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d315decb-2c95-da81-e8e9-9e4a44252656@suse.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zQnSuITc-914wLdXynIR-gHoPNnryQ9O
X-Proofpoint-ORIG-GUID: ghOdFsjfiG0m7Ktz-UmmsDGJMstFKG5o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_05,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 malwarescore=0 mlxlogscore=999 suspectscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200058
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Sep 20, 2021 at 08:00:31AM +0200, Juergen Gross wrote:
> On 19.09.21 19:15, Borislav Petkov wrote:
> > On Sun, Sep 19, 2021 at 06:55:16PM +0200, Mike Galbraith wrote:
> > > On Thu, 2021-09-16 at 10:50 +0000, tip-bot2 for Juergen Gross wrote:
> > > > The following commit has been merged into the x86/urgent branch of
> > > > tip:
> > > > 
> > > > x86/setup: Call early_reserve_memory() earlier
> > > 
> > > This commit rendered tip toxic to my i4790 desktop box and i5-6200U
> > > lappy.  Boot for both is instantly over without so much as a twitch.
> > > 
> > > Post bisect revert made both all better.
> > 
> > I had a suspicion that moving stuff around like that would not just
> > simply work in all cases, as our boot order is very lovely and fragile.
> > 
> > And it booted just fine on my machines here.
> > 
> > ;-\
> > 
> > Anyway, commit zapped from the x86/urgent lineup. We'll have to have a
> > third try later.
> > 
> 
> How will that try look like? I'm seeing the following alternatives:
> 
> 1. Just revert a799c2bd29d19c565 ("x86/setup: Consolidate early memory
>    reservations").
> 
> 2. Try to move the call of early_reserve_memory() just before the call
>    of e820__memory_setup().
> 
> 3. Split early_reserve_memory() into two parts, with the first part
>    doing the memblock_reserve() calls for the kernel text, initrd and
>    page 0 right at the start of setup_arch(), and the second part for
>    the rest at the same place it is handled now.
> 
> 4. Analyze why Mike's systems fail to boot and try to fix his issue(s)
>    (probably via one of the above ways).
> 
> Looking at the calls done in early_reserve_memory() I have my doubts
> that memblock_x86_reserve_range_setup_data() will work before
> early_ioremap_init() has been called, as it is using early_memremap().
> This would suggest variant 2 could be a working solution.
> 
> In case I'm wrong with my doubts I'd prefer variant 3.

I actually prefer variant 2 to keep the early memory reservations together
as much as possible. 

I tend to agree with your doubts about
memblock_x86_reserve_range_setup_data(), but it should be fine to move
early_reserve_memory() just before e820__memory_setup().
  
Anyway, I'd like to understand why Mike's systems fail before moving on
with the fixes.

-- 
Sincerely yours,
Mike.
