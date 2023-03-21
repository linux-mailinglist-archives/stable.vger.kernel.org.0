Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7676C3C87
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 22:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjCUVTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 17:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjCUVTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 17:19:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6F0136D3;
        Tue, 21 Mar 2023 14:19:19 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32LJEQfR001100;
        Tue, 21 Mar 2023 21:19:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=bbozAYZVvpIJ1rSltt7P6n1hBU/8cwQRgE061FnjM7I=;
 b=DsXBP3/qmMEf3FMQeTlM0NX1KGMFhTygFGvqej6rq6u5Y6pj/Ev5GOKVVnHKENug67AM
 5ne6Nj3xpX49KYw/GbH1vj8xjy+4x/b8LCvl2JE/w+VhTgHQn9vqmUIk/tvM3WunFT9C
 hCjcszzHdkpfuDsmZ3YV/whSl4SuxVBjXLIXPPz3ARYHMLNGWHdL8Pr9YU88LGScxndx
 NEX8EujJ0uNv0VnlYOsEZTlH/dM0zcomKvO3XfBsMC5PW7Svav/6olxaJhkKdfxRpozy
 lxUnahFoDtI9aLd0fkmCoLh1W1EOJZ8KesUB34MlwghQXZurw5CU0BsVWnBUcr7UeDXV TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pfjjdtgd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Mar 2023 21:19:15 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32LLBCel005465;
        Tue, 21 Mar 2023 21:19:14 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pfjjdtgck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Mar 2023 21:19:14 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32L50Jdi018062;
        Tue, 21 Mar 2023 21:19:12 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3pd4jfc9x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Mar 2023 21:19:12 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32LLJ9g842205758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 21:19:09 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F289D20043;
        Tue, 21 Mar 2023 21:19:08 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51ADE20040;
        Tue, 21 Mar 2023 21:19:08 +0000 (GMT)
Received: from localhost (unknown [9.171.1.78])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 21 Mar 2023 21:19:08 +0000 (GMT)
Date:   Tue, 21 Mar 2023 22:19:06 +0100
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Joe Lawrence <joe.lawrence@redhat.com>, stable@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH] s390: reintroduce expoline dependence to scripts
Message-ID: <your-ad-here.call-01679433546-ext-8459@work.hours>
References: <705ce64c-5f73-2ec8-e4bc-dd48c85f0498@kernel.org>
 <20230316112809.7903-1-jirislaby@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230316112809.7903-1-jirislaby@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GlJMtsEVQZZ0gT78_adUV8bdi7lGyiQO
X-Proofpoint-ORIG-GUID: 0ug9ZL6ZKPv_3YE6ECwxu-eCpoqk4EUS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_11,2023-03-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=998 spamscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 impostorscore=0 clxscore=1015 adultscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303210166
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023 at 12:28:09PM +0100, Jiri Slaby (SUSE) wrote:
> Expolines depend on scripts/basic/fixdep. And build of expolines can now
> race with the fixdep build:
> 
>  make[1]: *** Deleting file 'arch/s390/lib/expoline/expoline.o'
>  /bin/sh: line 1: scripts/basic/fixdep: Permission denied
>  make[1]: *** [../scripts/Makefile.build:385: arch/s390/lib/expoline/expoline.o] Error 126
>  make: *** [../arch/s390/Makefile:166: expoline_prepare] Error 2
> 
> The dependence was removed in the below Fixes: commit. So reintroduce
> the dependence on scripts.
> 
> Fixes: a0b0987a7811 ("s390/nospec: remove unneeded header includes")
> Cc: Joe Lawrence <joe.lawrence@redhat.com>
> Cc: stable@vger.kernel.org
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: linux-s390@vger.kernel.org
> Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
> ---
>  arch/s390/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/Makefile b/arch/s390/Makefile
> index b3235ab0ace8..ed646c583e4f 100644
> --- a/arch/s390/Makefile
> +++ b/arch/s390/Makefile
> @@ -162,7 +162,7 @@ vdso_prepare: prepare0
>  
>  ifdef CONFIG_EXPOLINE_EXTERN
>  modules_prepare: expoline_prepare
> -expoline_prepare:
> +expoline_prepare: scripts
>  	$(Q)$(MAKE) $(build)=arch/s390/lib/expoline arch/s390/lib/expoline/expoline.o
>  endif
>  endif
> -- 

Applied, thank you.
