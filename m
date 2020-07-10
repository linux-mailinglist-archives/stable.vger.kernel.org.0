Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6CEE21BD3B
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 20:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgGJS4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 14:56:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30936 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726872AbgGJS4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 14:56:16 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06AIY8de004832;
        Fri, 10 Jul 2020 14:56:09 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 326j81bkjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jul 2020 14:56:09 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06AIpWFb056849;
        Fri, 10 Jul 2020 14:56:09 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 326j81bkhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jul 2020 14:56:09 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06AIZHcE031343;
        Fri, 10 Jul 2020 18:56:07 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 326bcf0vu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jul 2020 18:56:07 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06AIrRae459318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jul 2020 18:53:27 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F64442045;
        Fri, 10 Jul 2020 18:54:49 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0DB442042;
        Fri, 10 Jul 2020 18:54:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.206.93])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Jul 2020 18:54:48 +0000 (GMT)
Message-ID: <1594407288.14405.36.camel@linux.ibm.com>
Subject: Re: [PATCH v5] ima: move APPRAISE_BOOTPARAM dependency on
 ARCH_POLICY to runtime
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Bruno Meneguele <bmeneg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-integrity@vger.kernel.org, erichte@linux.ibm.com,
        nayna@linux.ibm.com, stable@vger.kernel.org
Date:   Fri, 10 Jul 2020 14:54:48 -0400
In-Reply-To: <20200710183420.GB10547@glitch>
References: <20200709164647.45153-1-bmeneg@redhat.com>
         <1594401804.14405.8.camel@linux.ibm.com> <20200710180338.GA10547@glitch>
         <20200710183420.GB10547@glitch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-10_14:2020-07-10,2020-07-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007100121
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-07-10 at 15:34 -0300, Bruno Meneguele wrote:
> On Fri, Jul 10, 2020 at 03:03:38PM -0300, Bruno Meneguele wrote:
> > On Fri, Jul 10, 2020 at 01:23:24PM -0400, Mimi Zohar wrote:
> > > On Thu, 2020-07-09 at 13:46 -0300, Bruno Meneguele wrote:
> > > > APPRAISE_BOOTPARAM has been marked as dependent on !ARCH_POLICY in compile
> > > > time, enforcing the appraisal whenever the kernel had the arch policy option
> > > > enabled.
> > > 
> > > > However it breaks systems where the option is set but the system didn't
> > > > boot in a "secure boot" platform. In this scenario, anytime an appraisal
> > > > policy (i.e. ima_policy=appraisal_tcb) is used it will be forced, without
> > > > giving the user the opportunity to label the filesystem, before enforcing
> > > > integrity.
> > > > 
> > > > Considering the ARCH_POLICY is only effective when secure boot is actually
> > > > enabled this patch remove the compile time dependency and move it to a
> > > > runtime decision, based on the secure boot state of that platform.
> > > 
> > > Perhaps we could simplify this patch description a bit?
> > > 
> > > The IMA_APPRAISE_BOOTPARAM config allows enabling different
> > > "ima_appraise=" modes - log, fix, enforce - at run time, but not when
> > > IMA architecture specific policies are enabled.  This prevents
> > > properly labeling the filesystem on systems where secure boot is
> > > supported, but not enabled on the platform.  Only when secure boot is
> > > enabled, should these IMA appraise modes be disabled.
> > > 
> > > This patch removes the compile time dependency and makes it a runtime
> > > decision, based on the secure boot state of that platform.
> > > 
> > 
> > Sounds good to me.
> > 
> > > <snip>
> > > 
> > > > diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> > > > index a9649b04b9f1..884de471b38a 100644
> > > > --- a/security/integrity/ima/ima_appraise.c
> > > > +++ b/security/integrity/ima/ima_appraise.c
> > > > @@ -19,6 +19,11 @@
> > > >  static int __init default_appraise_setup(c
> > > 
> > > > har *str)
> > > >  {
> > > >  #ifdef CONFIG_IMA_APPRAISE_BOOTPARAM
> > > > +	if (arch_ima_get_secureboot()) {
> > > > +		pr_info("appraise boot param ignored: secure boot enabled");
> > > 
> > > Instead of a generic statement, is it possible to include the actual
> > > option being denied?  Perhaps something like: "Secure boot enabled,
> > > ignoring %s boot command line option"
> > > 
> > > Mimi
> > > 
> > 
> > Yes, sure.
> > 
> 
> Btw, would it make sense to first make sure we have a valid "str"
> option and not something random to print?
>  
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index a9649b04b9f1..1f1175531d3e 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -25,6 +25,16 @@ static int __init default_appraise_setup(char *str)
>                 ima_appraise = IMA_APPRAISE_LOG;
>         else if (strncmp(str, "fix", 3) == 0)
>                 ima_appraise = IMA_APPRAISE_FIX;
> +       else
> +               pr_info("invalid \"%s\" appraise option");
> +
> +       if (arch_ima_get_secureboot()) {
> +               if (!is_ima_appraise_enabled()) {
> +                       pr_info("Secure boot enabled: ignoring ima_appraise=%s boot parameter option",
> +                               str);
> +                       ima_appraise = IMA_APPRAISE_ENFORCE;
> +               }
> +       }

Providing feedback is probably a good idea.  However, the
"arch_ima_get_secureboot" test can't come after setting
"ima_appraise."

Mimi

>  #endif
>         return 1;
>  }
> 
> 
> The "else" there I think would make sense as well, at least to give the
> user some feedback about a possible mispelling of him (as a separate
> patch).
> 
> And "if(!is_ima_appraise_enabled())" would avoid to print anything about
> "ignoring the option" to the user in case he explicitly set "enforce",
> which we know there isn't any real effect but is allowed and shown in
> kernel-parameters.txt.
> 
> > Thanks!
> > 
> > > > +		return 1;
> > > > +	}
> > > > +
> > > >  	if (strncmp(str, "off", 3) == 0)
> > > >  		ima_appraise = 0;
> > > >  	else if (strncmp(str, "log", 3) == 0)
> > > 
> > 
> > -- 
> > bmeneg 
> > PGP Key: http://bmeneg.com/pubkey.txt
> 
> 
> 

