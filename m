Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D106D17F6
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 09:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjCaHDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 03:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjCaHDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 03:03:33 -0400
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E962C676;
        Fri, 31 Mar 2023 00:03:31 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4PnrcV0fHpz9xHvT;
        Fri, 31 Mar 2023 14:54:18 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwAHQg2ghSZkCtHjAQ--.59837S2;
        Fri, 31 Mar 2023 08:03:07 +0100 (CET)
Message-ID: <27ee02c2f6a01bf5ffd5cb2b29148721cd27c892.camel@huaweicloud.com>
Subject: Re: [PATCH v9 1/4] reiserfs: Add security prefix to xattr name in
 reiserfs_security_write()
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, jmorris@namei.org,
        serge@hallyn.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, casey@schaufler-ca.com,
        reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        bpf@vger.kernel.org, kpsingh@kernel.org, keescook@chromium.org,
        nicolas.bouchinet@clip-os.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Fri, 31 Mar 2023 09:02:52 +0200
In-Reply-To: <CAHC9VhRg7twUWXLH0xTaWc2MeSFExkGr9tJztYopzD0JEM-npw@mail.gmail.com>
References: <20230329130415.2312521-1-roberto.sassu@huaweicloud.com>
         <20230329130415.2312521-2-roberto.sassu@huaweicloud.com>
         <CAHC9VhRg7twUWXLH0xTaWc2MeSFExkGr9tJztYopzD0JEM-npw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LxC2BwAHQg2ghSZkCtHjAQ--.59837S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAF15Jw47AryUXw17Aw45trb_yoW5Wr1fpF
        WUK3Wqkr1DtF12g34S9anxuw1SgFWfGr47WrZxKryDAanrZw1xtFW0k34S9rW8WrWkJr1I
        qa1Iga13A3s8A3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZ18PUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQANBF1jj4thygADsa
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2023-03-30 at 17:15 -0400, Paul Moore wrote:
> On Wed, Mar 29, 2023 at 9:05 AM Roberto Sassu
> <roberto.sassu@huaweicloud.com> wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > Reiserfs sets a security xattr at inode creation time in two stages: first,
> > it calls reiserfs_security_init() to obtain the xattr from active LSMs;
> > then, it calls reiserfs_security_write() to actually write that xattr.
> > 
> > Unfortunately, it seems there is a wrong expectation that LSMs provide the
> > full xattr name in the form 'security.<suffix>'. However, LSMs always
> > provided just the suffix, causing reiserfs to not write the xattr at all
> > (if the suffix is shorter than the prefix), or to write an xattr with the
> > wrong name.
> > 
> > Add a temporary buffer in reiserfs_security_write(), and write to it the
> > full xattr name, before passing it to reiserfs_xattr_set_handle().
> > 
> > Since the 'security.' prefix is always prepended, remove the name length
> > check.
> > 
> > Cc: stable@vger.kernel.org # v2.6.x
> > Fixes: 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes during inode creation")
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > ---
> >  fs/reiserfs/xattr_security.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/reiserfs/xattr_security.c b/fs/reiserfs/xattr_security.c
> > index 6bffdf9a4fd..b0c354ab113 100644
> > --- a/fs/reiserfs/xattr_security.c
> > +++ b/fs/reiserfs/xattr_security.c
> > @@ -95,11 +95,13 @@ int reiserfs_security_write(struct reiserfs_transaction_handle *th,
> >                             struct inode *inode,
> >                             struct reiserfs_security_handle *sec)
> >  {
> > +       char xattr_name[XATTR_NAME_MAX + 1];
> >         int error;
> > -       if (strlen(sec->name) < sizeof(XATTR_SECURITY_PREFIX))
> > -               return -EINVAL;
> 
> If one really wanted to be paranoid they could verify that
> 'XATTR_SECURITY_PREFIX_LEN + strlen(sec->name) <= XATTR_NAME_MAX' and
> return EINVAL, but that really shouldn't be an issue and if the
> concatenation does result in a xattr name that is too big, the
> snprintf() will safely truncate/managle it.

Ok, I could do it.

Thanks

Roberto

> Regardless, this patch is fine with me, but it would be nice if at
> least of the reiserfs/VFS folks could provide an ACK/Reviewed-by tag,
> although I think we can still move forward on this without one of
> those.
> 
> > -       error = reiserfs_xattr_set_handle(th, inode, sec->name, sec->value,
> > +       snprintf(xattr_name, sizeof(xattr_name), "%s%s", XATTR_SECURITY_PREFIX,
> > +                sec->name);
> > +
> > +       error = reiserfs_xattr_set_handle(th, inode, xattr_name, sec->value,
> >                                           sec->length, XATTR_CREATE);
> >         if (error == -ENODATA || error == -EOPNOTSUPP)
> >                 error = 0;
> > --
> > 2.25.1

