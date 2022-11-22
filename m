Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECC66336C4
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 09:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbiKVIMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 03:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbiKVIMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 03:12:36 -0500
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D00DEE0;
        Tue, 22 Nov 2022 00:12:31 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.229])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4NGcJL3Bkwz9v7Gp;
        Tue, 22 Nov 2022 16:05:38 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwDnGPVLhHxj44iEAA--.29174S2;
        Tue, 22 Nov 2022 09:12:07 +0100 (CET)
Message-ID: <aa51b845dca6021282b5b2ae260020a3a5cfb5c6.camel@huaweicloud.com>
Subject: Re: [PATCH v4 1/5] reiserfs: Add missing calls to
 reiserfs_security_free()
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, jmorris@namei.org,
        serge@hallyn.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, casey@schaufler-ca.com,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        keescook@chromium.org, nicolas.bouchinet@clip-os.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date:   Tue, 22 Nov 2022 09:11:50 +0100
In-Reply-To: <CAHC9VhQ9WftDrF1R--ZYJXOv-YbVU-Pr1Ob_deDwEWm8OcQ-TA@mail.gmail.com>
References: <20221110094639.3086409-1-roberto.sassu@huaweicloud.com>
         <20221110094639.3086409-2-roberto.sassu@huaweicloud.com>
         <CAHC9VhQ9WftDrF1R--ZYJXOv-YbVU-Pr1Ob_deDwEWm8OcQ-TA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: GxC2BwDnGPVLhHxj44iEAA--.29174S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCw48Zr1xAF4kJFW5GFW8Crg_yoW5KF1fpF
        WxK3WUKr1DJF1kur1Fvanxua1Iq3yag3y7GrsxKryqya9xZw1kKF4Ikay3u397KrWDGr4I
        qa1xGw43uw45J3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZ18PUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAEBF1jj4GyWwAAsb
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-11-21 at 18:41 -0500, Paul Moore wrote:
> On Thu, Nov 10, 2022 at 4:47 AM Roberto Sassu
> <roberto.sassu@huaweicloud.com> wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > Commit 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes
> > during inode creation") defined reiserfs_security_free() to free the name
> > and value of a security xattr allocated by the active LSM through
> > security_old_inode_init_security(). However, this function is not called
> > in the reiserfs code.
> > 
> > Thus, add a call to reiserfs_security_free() whenever
> > reiserfs_security_init() is called, and initialize value to NULL, to avoid
> > to call kfree() on an uninitialized pointer.
> > 
> > Finally, remove the kfree() for the xattr name, as it is not allocated
> > anymore.
> > 
> > Fixes: 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes during inode creation")
> > Cc: stable@vger.kernel.org
> > Cc: Jeff Mahoney <jeffm@suse.com>
> > Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Reported-by: Mimi Zohar <zohar@linux.ibm.com>
> > Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > ---
> >  fs/reiserfs/namei.c          | 4 ++++
> >  fs/reiserfs/xattr_security.c | 2 +-
> >  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> If I'm understanding this patch correctly, this is a standalone
> bugfix, right?  Any reason this shouldn't be merged now, independent
> of the rest of patches in this patchset?

Yes. It would be fine for me to pick this sooner.

Thanks

Roberto

> > diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
> > index 3d7a35d6a18b..b916859992ec 100644
> > --- a/fs/reiserfs/namei.c
> > +++ b/fs/reiserfs/namei.c
> > @@ -696,6 +696,7 @@ static int reiserfs_create(struct user_namespace *mnt_userns, struct inode *dir,
> > 
> >  out_failed:
> >         reiserfs_write_unlock(dir->i_sb);
> > +       reiserfs_security_free(&security);
> >         return retval;
> >  }
> > 
> > @@ -779,6 +780,7 @@ static int reiserfs_mknod(struct user_namespace *mnt_userns, struct inode *dir,
> > 
> >  out_failed:
> >         reiserfs_write_unlock(dir->i_sb);
> > +       reiserfs_security_free(&security);
> >         return retval;
> >  }
> > 
> > @@ -878,6 +880,7 @@ static int reiserfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
> >         retval = journal_end(&th);
> >  out_failed:
> >         reiserfs_write_unlock(dir->i_sb);
> > +       reiserfs_security_free(&security);
> >         return retval;
> >  }
> > 
> > @@ -1194,6 +1197,7 @@ static int reiserfs_symlink(struct user_namespace *mnt_userns,
> >         retval = journal_end(&th);
> >  out_failed:
> >         reiserfs_write_unlock(parent_dir->i_sb);
> > +       reiserfs_security_free(&security);
> >         return retval;
> >  }
> > 
> > diff --git a/fs/reiserfs/xattr_security.c b/fs/reiserfs/xattr_security.c
> > index 8965c8e5e172..857a65b05726 100644
> > --- a/fs/reiserfs/xattr_security.c
> > +++ b/fs/reiserfs/xattr_security.c
> > @@ -50,6 +50,7 @@ int reiserfs_security_init(struct inode *dir, struct inode *inode,
> >         int error;
> > 
> >         sec->name = NULL;
> > +       sec->value = NULL;
> > 
> >         /* Don't add selinux attributes on xattrs - they'll never get used */
> >         if (IS_PRIVATE(dir))
> > @@ -95,7 +96,6 @@ int reiserfs_security_write(struct reiserfs_transaction_handle *th,
> > 
> >  void reiserfs_security_free(struct reiserfs_security_handle *sec)
> >  {
> > -       kfree(sec->name);
> >         kfree(sec->value);
> >         sec->name = NULL;
> >         sec->value = NULL;
> > --
> > 2.25.1
> > 
> 
> 

