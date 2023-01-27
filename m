Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEFA67DEC1
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 08:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbjA0H4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 02:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjA0H4W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 02:56:22 -0500
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD406C127;
        Thu, 26 Jan 2023 23:56:20 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4P38nr5Pxkz9xtnJ;
        Fri, 27 Jan 2023 15:48:16 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwAn9FqNg9Njo+7MAA--.2032S2;
        Fri, 27 Jan 2023 08:56:06 +0100 (CET)
Message-ID: <34e99a8326316f998d034b009469589ca177769d.camel@huaweicloud.com>
Subject: Re: [PATCH v3 1/2] ima: Align ima_file_mmap() parameters with
 mmap_file LSM hook
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Stefan Berger <stefanb@linux.ibm.com>, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, jmorris@namei.org, serge@hallyn.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Fri, 27 Jan 2023 08:55:53 +0100
In-Reply-To: <295c5915-b680-16be-3d51-b7c1d2ca5e4f@linux.ibm.com>
References: <20230126163812.1870942-1-roberto.sassu@huaweicloud.com>
         <295c5915-b680-16be-3d51-b7c1d2ca5e4f@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: GxC2BwAn9FqNg9Njo+7MAA--.2032S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuw1UtF43ZF4xGrW7Ar45trb_yoW7Ww4DpF
        Z8Ka4UGFZ3JFy29r929ay7Za4fK3yxKryUuaySgry0y3WqqF1v9r13AFy7uF1rCr95CF1I
        q347KrW3A3WqyFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAKBF1jj4QqgAAEsX
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2023-01-26 at 14:37 -0500, Stefan Berger wrote:
> 
> On 1/26/23 11:38, Roberto Sassu wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > Commit 98de59bfe4b2f ("take calculation of final prot in
> > security_mmap_file() into a helper") moved the code to update prot, to be
> > the actual protections applied to the kernel, to a new helper called
> > mmap_prot().
> > 
> > However, while without the helper ima_file_mmap() was getting the updated
> > prot, with the helper ima_file_mmap() gets the original prot, which
> > contains the protections requested by the application.
> > 
> > A possible consequence of this change is that, if an application calls
> > mmap() with only PROT_READ, and the kernel applies PROT_EXEC in addition,
> > that application would have access to executable memory without having this
> > event recorded in the IMA measurement list. This situation would occur for
> > example if the application, before mmap(), calls the personality() system
> > call with READ_IMPLIES_EXEC as the first argument.
> > 
> > Align ima_file_mmap() parameters with those of the mmap_file LSM hook, so
> > that IMA can receive both the requested prot and the final prot. Since the
> > requested protections are stored in a new variable, and the final
> > protections are stored in the existing variable, this effectively restores
> > the original behavior of the MMAP_CHECK hook.
> > 
> And flags is being passed in preparation for IMA to meet the interface
> requirements of the LSM hooks - I suppose in preparation for IMA to become an LSM.

Yes, correct. I reused a patch from that patch set. Anyway reqprot was
needed for MMAP_CHECK_REQPROT.

> > Cc: stable@vger.kernel.org
> > Fixes: 98de59bfe4b2 ("take calculation of final prot in security_mmap_file() into a helper")
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>

Thanks

Roberto

> > ---
> >   include/linux/ima.h               | 6 ++++--
> >   security/integrity/ima/ima_main.c | 7 +++++--
> >   security/security.c               | 7 ++++---
> >   3 files changed, 13 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/linux/ima.h b/include/linux/ima.h
> > index 5a0b2a285a18..d79fee67235e 100644
> > --- a/include/linux/ima.h
> > +++ b/include/linux/ima.h
> > @@ -21,7 +21,8 @@ extern int ima_file_check(struct file *file, int mask);
> >   extern void ima_post_create_tmpfile(struct user_namespace *mnt_userns,
> >   				    struct inode *inode);
> >   extern void ima_file_free(struct file *file);
> > -extern int ima_file_mmap(struct file *file, unsigned long prot);
> > +extern int ima_file_mmap(struct file *file, unsigned long reqprot,
> > +			 unsigned long prot, unsigned long flags);
> >   extern int ima_file_mprotect(struct vm_area_struct *vma, unsigned long prot);
> >   extern int ima_load_data(enum kernel_load_data_id id, bool contents);
> >   extern int ima_post_load_data(char *buf, loff_t size,
> > @@ -76,7 +77,8 @@ static inline void ima_file_free(struct file *file)
> >   	return;
> >   }
> >   
> > -static inline int ima_file_mmap(struct file *file, unsigned long prot)
> > +static inline int ima_file_mmap(struct file *file, unsigned long reqprot,
> > +				unsigned long prot, unsigned long flags)
> >   {
> >   	return 0;
> >   }
> > diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> > index 377300973e6c..f48f4e694921 100644
> > --- a/security/integrity/ima/ima_main.c
> > +++ b/security/integrity/ima/ima_main.c
> > @@ -397,7 +397,9 @@ static int process_measurement(struct file *file, const struct cred *cred,
> >   /**
> >    * ima_file_mmap - based on policy, collect/store measurement.
> >    * @file: pointer to the file to be measured (May be NULL)
> > - * @prot: contains the protection that will be applied by the kernel.
> > + * @reqprot: protection requested by the application
> > + * @prot: protection that will be applied by the kernel
> > + * @flags: operational flags
> >    *
> >    * Measure files being mmapped executable based on the ima_must_measure()
> >    * policy decision.
> > @@ -405,7 +407,8 @@ static int process_measurement(struct file *file, const struct cred *cred,
> >    * On success return 0.  On integrity appraisal error, assuming the file
> >    * is in policy and IMA-appraisal is in enforcing mode, return -EACCES.
> >    */
> > -int ima_file_mmap(struct file *file, unsigned long prot)
> > +int ima_file_mmap(struct file *file, unsigned long reqprot,
> > +		  unsigned long prot, unsigned long flags)
> >   {
> >   	u32 secid;
> >   
> > diff --git a/security/security.c b/security/security.c
> > index d1571900a8c7..174afa4fad81 100644
> > --- a/security/security.c
> > +++ b/security/security.c
> > @@ -1661,12 +1661,13 @@ static inline unsigned long mmap_prot(struct file *file, unsigned long prot)
> >   int security_mmap_file(struct file *file, unsigned long prot,
> >   			unsigned long flags)
> >   {
> > +	unsigned long prot_adj = mmap_prot(file, prot);
> >   	int ret;
> > -	ret = call_int_hook(mmap_file, 0, file, prot,
> > -					mmap_prot(file, prot), flags);
> > +
> > +	ret = call_int_hook(mmap_file, 0, file, prot, prot_adj, flags);
> >   	if (ret)
> >   		return ret;
> > -	return ima_file_mmap(file, prot);
> > +	return ima_file_mmap(file, prot, prot_adj, flags);
> >   }
> >   
> >   int security_mmap_addr(unsigned long addr)

