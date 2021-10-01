Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B246041F52B
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 20:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354615AbhJASsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 14:48:18 -0400
Received: from sonic302-28.consmr.mail.ne1.yahoo.com ([66.163.186.154]:44992
        "EHLO sonic302-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354883AbhJASsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Oct 2021 14:48:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1633113988; bh=cgLBbwM3X2SowZBkxRF+MUZcErWiL2gbg2TQBSGhL9s=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=EPP3uL/UaKQjlT7bXK9OmASVV9OL1TedIh3TO5B5SrA2/FZLsKPkUhf9g8HkiCJhtRhbO0ydQj8SpSOHBXWH5uMercs+kcEwnJzo41GFemPVf9mq1TibQkvHXXZGfr4tRZaSw7Y2N9YSPFFaZX4djJj7ldhtzbMLYbMgKYeYcLpzZeeBCUR60oOIj4KB9hPwlPVI8eRfVcAA8hEk+Alp9Fm9q+634JShjBNOHfrwrlnhXvChEr+bvKBeQupjVSVbmyoSgzYWiZbMxUEtkshyaxvAA2jm3/hey/ctfVZLlTdZAIJRhzwgPONC0abJPfhRVspZkNu6bK7WQ+Dc0lpyww==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1633113988; bh=BfWVLJvivhrVfafKGTyxMhqjFxLBHK+g9Hr9ZVq3L5R=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=psrX3EMVmNgrad3//K7k69yChqtn0nMEI/GnNyDLG1+UcHOCVP3JScHpf+uiPAtyVblOCnuPZxckI8UfWn70wNzYn1FL+tClZhhV1PtBIXSFe0fCWZrdFkw/vjzjG/OajaqClmj+X9W355SBrRs2eU11mPy+2R1ENmm7D76qU17atR33N3Sm9rXR/MFa9HjAQwev3DiWMVKNWdFf5eowFagpnwSxLMcGdwqIi+3fADQjtnpzwAfIs5zQJqAaPegc7a2p8S5gdqYqMqtWMqix8hh7TLQQ/w2MLjdocRkJVdmBmAj8XnSkxYCElA6y7TNOs9/5xmXduUppjxF1NePfwQ==
X-YMail-OSG: gYSsFZcVM1mKruu.1q7OSG9mz2.Eoo.GLz4MCSYN8WDNga94S3FfYi0anzRsvQA
 7JXU56anRXabrDiSMETnO7_ZiZ0n09aNYUP1sodBaFAzEq78vFDtDNorD1j5cBSHi.jjs1V83CCG
 4ZLjr.bVSq_sMac4xMXKgKPxG9sOy8b_AIRTxYs47MGh.J6W1_IDo75bNvMK5cIFMTh97IFpSxjk
 yKehyM_87l_NnEDA3mISWVb0VvA7cbcTaqoO0VDUZMJJ8euYFWl9WT8lcTQ.eaIikeBDRoyuoWF2
 WS16F6x3EIplh_y1TSHmsMl0eyxMgVxBO1OTKLPDGDd2yPt_nMLbpO3Wwa_wbphy36LF98A5wdDn
 jJZ_Ow6oUO0iQnZtwhoZgXgNX.bQsrMrCY.Zq8TjSBfXWMOKu54zUZ8nRvQXqxpS5fdaIyGDtHPw
 orNHZ0maUPjl_1lGwkMobnrE8toOfaUglEdPhwrjnMjzwE.U7vb3Q8gGQtYoSzr6XPzoSvXyL.32
 lY2uDx_sGTDV059OyxUK7es8EwpU8pOR7usRifUSjvxzAcATq3OVaKIOp3IfRA6HU0mF0BoY9N1W
 kyxOMJqxCXzDvejQmCdOVoQclIkIdXqC6pbc3MKz.yZtRjhlK5hTT2GAHr1qrhDaEiHeIFeupRLn
 vppw6DdpGcCX0z1hFKwTgYUz6mvCcoV1GR4LS192k74z4shxJLKANHDy_nhg6joNeDktTbChYQcf
 DhzDVu5jX3lko9fyR.NdDCogPLpYWFni4Qp.oek4jIht2KjRAXQPs5y9UuM9uD7EFMqil2WscRrR
 nDxZ0bMWjntoWHBCuUSVLeBSWNoinVsLdCbpzq8gr48RKfW87y2WiXxeUqIZy.2cHo4CZjQcgU_p
 xkUVcrI8nfRwvSs89AtzTGNCXEp54vrJuzqTeTJ7ioErYoZss0oK_MR7w6X41VjSwuPWSuTljJk2
 9aF9ne31hLxnyvZPp77yoIjzZQSem6Mg1BVHEeiTKmOUbr44P10J2eBUi0jDKv8titBCe0t96Kwx
 ON8qFQd9AAK2XM3PcuB17oMRt_lkqWW2ml.l_awD5pdeKQufdvCYUC70H3ZyuuEdayJ7UfceTDHV
 ILOPAHZSK0EcTd1mBzmTng4iyYafP3NMoCeJELHtyGGTPkedLJEcroZ55GtAUEWWTFsytNUZBP9L
 Hr8MP_hLzJ38lB_4ZivewnfkNxzdSaFjoPmxB0YXYUxmOG7AQbDl62HUNwV3mHgU.VbfGs1SiPaM
 bRBb8KiCor1029Y3ISQic45txSIEoE.OkGzr1bSHW0d2XNsqyOWl52AjVMx9jHyrvcNjCiN3QHAN
 bUHY9wqLRmwLKxnY.7Rq7ROTFa4BQ8pZBHlOWYB.ocN.CZxvS6WJx3YjwQAdQS54_JGU.nbZVwht
 zqWbWho8JD7nwYnozKNFkYo1P.ruzuYcN9M.2.RaK_E6lYFf9gWYE1pKXV2ddQusa2vrw85WdJ_F
 PX.ITkWm4eIfGMgFVShvWevtcm6XfsIP7wL9916Tj7nNXzeqg3rlv1mkvS6OPcvptAZ2.VUs.GBC
 f3pGdHc8n64SmkhL1qENeM8FXLISUDnHuM2BhUzK6CYqd1jt_RCaX5Yy4PRqS1i2B7FAx_7.Hjfj
 XIAwh9rYx1jJ0Iv3MgTPPdnyzrksYLfC23hPDJyTwhc.3FXbZ58S1RxuWCc.H.lpDQqekaVqnkc2
 fWJEteprIZq7aSlxM1DR8mVrHJHAGUgU6iMSEgl_nN23XmBhM190qNKQQNtvhz2eBW8B7vehGTlM
 4b5IArut3YcZPi3fuerZ4YKvgPCDzRTPitbbEhYWS13GrLdlWjqAWnjQihqDZ_xFYuZs1DlQQYR2
 WQH2Is7C5lmSJQFPwssnO3Pvkr1BXjMp.2bZ81trU1N4TlyrjOdDeCU73sLlhYrj9WnQN5.4lqbq
 UFIyXslOfT2T94W0RZ48KTh7xAqeYlQ3_Yxso31045bamkjXOx9ZQZ5QpAqB4hPHOTRWeN1_y_q6
 rCU3iNR2gd5LAqC2VnYN4UE11mnsxxVOQEt2CFeZ1VPFeIGGP0Zib_Bz55BkjHGLrsWeoh0N5RRL
 9sZx_eviIC4EoD6DNcDz02b8dlkOghXsRVLhrlQ6Ge7EP6VrjHHMqFR5aBmPdJrugCYhypnHHgDt
 kdJOVNMPKDmGfGBsl9rLgokEj93z68kT1rloFGdpDt9CDMnm2QgHD0t5IkDg.3xlbjY_bihklUXT
 x5nJP4ucRvi2RF.gJp8TC9_o7js54..bMYKVSReajMyRrrDj2uXalPeTo3.lks1lNwAjMAlXeQBJ
 Y_oAu0iNlMB35GzM-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Fri, 1 Oct 2021 18:46:28 +0000
Received: by kubenode522.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID e60de3ca792a93a9042488d7b2a21692;
          Fri, 01 Oct 2021 18:46:26 +0000 (UTC)
Subject: Re: [PATCH v2] binder: use cred instead of task for selinux checks
To:     Todd Kjos <tkjos@google.com>, gregkh@linuxfoundation.org,
        arve@android.com, tkjos@android.com, maco@android.com,
        christian@brauner.io, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, keescook@chromium.org, jannh@google.com,
        jeffv@google.com, zohar@linux.ibm.com,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc:     joel@joelfernandes.org, kernel-team@android.com,
        stable@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
References: <20211001175521.3853257-1-tkjos@google.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <c6a650e4-15e4-2943-f759-0e9577784c7a@schaufler-ca.com>
Date:   Fri, 1 Oct 2021 11:46:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211001175521.3853257-1-tkjos@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.19076 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/1/2021 10:55 AM, Todd Kjos wrote:
> Save the struct cred associated with a binder process
> at initial open to avoid potential race conditions
> when converting to a security ID.
>
> Since binder was integrated with selinux, it has passed
> 'struct task_struct' associated with the binder_proc
> to represent the source and target of transactions.
> The conversion of task to SID was then done in the hook
> implementations. It turns out that there are race conditions
> which can result in an incorrect security context being used.

In the LSM stacking patch set I've been posting for a while
(on version 29 now) I use information from the task structure
to ensure that the security information passed via the binder
interface is agreeable to both sides. Passing the cred will
make it impossible to do this check. The task information
required is not appropriate to have in the cred.

I understand that there are no users of the binder driver
other than SELinux in Android upstream today. That's not
the issue. Two processes on a system with SELinux and AppArmor
together may be required to provide incompatible results
from security_secid_to_secctx()/security_secctx_to_secid().
If it's impossible to detect this incompatibility it's
impossible to prevent serious confusion.

The LSM stacking isn't upstream yet. But I hope to have it
there Real Soon Now. If there's another way to fix this that
doesn't remove the task_struct it would avoid my having to
put it back.

Thank you.

>
> Fix by saving the 'struct cred' during binder_open and pass
> it to the selinux subsystem.
>
> Fixes: 79af73079d75 ("Add security hooks to binder and implement the
> hooks for SELinux.")
> Signed-off-by: Todd Kjos <tkjos@google.com>
> Cc: stable@vger.kernel.org # 5.14+ (need backport for earlier stables)
> ---
> v2: updated comments as suggested by Paul Moore
>
>  drivers/android/binder.c          | 14 +++++----
>  drivers/android/binder_internal.h |  4 +++
>  include/linux/lsm_hook_defs.h     | 14 ++++-----
>  include/linux/lsm_hooks.h         | 14 ++++-----
>  include/linux/security.h          | 28 +++++++++---------
>  security/security.c               | 14 ++++-----
>  security/selinux/hooks.c          | 48 +++++++++----------------------=

>  7 files changed, 60 insertions(+), 76 deletions(-)
>
> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> index 9edacc8b9768..ca599ebdea4a 100644
> --- a/drivers/android/binder.c
> +++ b/drivers/android/binder.c
> @@ -2056,7 +2056,7 @@ static int binder_translate_binder(struct flat_bi=
nder_object *fp,
>  		ret =3D -EINVAL;
>  		goto done;
>  	}
> -	if (security_binder_transfer_binder(proc->tsk, target_proc->tsk)) {
> +	if (security_binder_transfer_binder(proc->cred, target_proc->cred)) {=

>  		ret =3D -EPERM;
>  		goto done;
>  	}
> @@ -2102,7 +2102,7 @@ static int binder_translate_handle(struct flat_bi=
nder_object *fp,
>  				  proc->pid, thread->pid, fp->handle);
>  		return -EINVAL;
>  	}
> -	if (security_binder_transfer_binder(proc->tsk, target_proc->tsk)) {
> +	if (security_binder_transfer_binder(proc->cred, target_proc->cred)) {=

>  		ret =3D -EPERM;
>  		goto done;
>  	}
> @@ -2190,7 +2190,7 @@ static int binder_translate_fd(u32 fd, binder_siz=
e_t fd_offset,
>  		ret =3D -EBADF;
>  		goto err_fget;
>  	}
> -	ret =3D security_binder_transfer_file(proc->tsk, target_proc->tsk, fi=
le);
> +	ret =3D security_binder_transfer_file(proc->cred, target_proc->cred, =
file);
>  	if (ret < 0) {
>  		ret =3D -EPERM;
>  		goto err_security;
> @@ -2595,8 +2595,8 @@ static void binder_transaction(struct binder_proc=
 *proc,
>  			return_error_line =3D __LINE__;
>  			goto err_invalid_target_handle;
>  		}
> -		if (security_binder_transaction(proc->tsk,
> -						target_proc->tsk) < 0) {
> +		if (security_binder_transaction(proc->cred,
> +						target_proc->cred) < 0) {
>  			return_error =3D BR_FAILED_REPLY;
>  			return_error_param =3D -EPERM;
>  			return_error_line =3D __LINE__;
> @@ -4353,6 +4353,7 @@ static void binder_free_proc(struct binder_proc *=
proc)
>  	}
>  	binder_alloc_deferred_release(&proc->alloc);
>  	put_task_struct(proc->tsk);
> +	put_cred(proc->cred);
>  	binder_stats_deleted(BINDER_STAT_PROC);
>  	kfree(proc);
>  }
> @@ -4564,7 +4565,7 @@ static int binder_ioctl_set_ctx_mgr(struct file *=
filp,
>  		ret =3D -EBUSY;
>  		goto out;
>  	}
> -	ret =3D security_binder_set_context_mgr(proc->tsk);
> +	ret =3D security_binder_set_context_mgr(proc->cred);
>  	if (ret < 0)
>  		goto out;
>  	if (uid_valid(context->binder_context_mgr_uid)) {
> @@ -5055,6 +5056,7 @@ static int binder_open(struct inode *nodp, struct=
 file *filp)
>  	spin_lock_init(&proc->outer_lock);
>  	get_task_struct(current->group_leader);
>  	proc->tsk =3D current->group_leader;
> +	proc->cred =3D get_cred(filp->f_cred);
>  	INIT_LIST_HEAD(&proc->todo);
>  	init_waitqueue_head(&proc->freeze_wait);
>  	proc->default_priority =3D task_nice(current);
> diff --git a/drivers/android/binder_internal.h b/drivers/android/binder=
_internal.h
> index 402c4d4362a8..d6b6b8cb7346 100644
> --- a/drivers/android/binder_internal.h
> +++ b/drivers/android/binder_internal.h
> @@ -364,6 +364,9 @@ struct binder_ref {
>   *                        (invariant after initialized)
>   * @tsk                   task_struct for group_leader of process
>   *                        (invariant after initialized)
> + * @cred                  struct cred associated with the `struct file=
`
> + *                        in binder_open()
> + *                        (invariant after initialized)
>   * @deferred_work_node:   element for binder_deferred_list
>   *                        (protected by binder_deferred_lock)
>   * @deferred_work:        bitmap of deferred work to perform
> @@ -426,6 +429,7 @@ struct binder_proc {
>  	struct list_head waiting_threads;
>  	int pid;
>  	struct task_struct *tsk;
> +	const struct cred *cred;
>  	struct hlist_node deferred_work_node;
>  	int deferred_work;
>  	int outstanding_txns;
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_def=
s.h
> index 2adeea44c0d5..61590c1f2d33 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -26,13 +26,13 @@
>   *   #undef LSM_HOOK
>   * };
>   */
> -LSM_HOOK(int, 0, binder_set_context_mgr, struct task_struct *mgr)
> -LSM_HOOK(int, 0, binder_transaction, struct task_struct *from,
> -	 struct task_struct *to)
> -LSM_HOOK(int, 0, binder_transfer_binder, struct task_struct *from,
> -	 struct task_struct *to)
> -LSM_HOOK(int, 0, binder_transfer_file, struct task_struct *from,
> -	 struct task_struct *to, struct file *file)
> +LSM_HOOK(int, 0, binder_set_context_mgr, const struct cred *mgr)
> +LSM_HOOK(int, 0, binder_transaction, const struct cred *from,
> +	 const struct cred *to)
> +LSM_HOOK(int, 0, binder_transfer_binder, const struct cred *from,
> +	 const struct cred *to)
> +LSM_HOOK(int, 0, binder_transfer_file, const struct cred *from,
> +	 const struct cred *to, struct file *file)
>  LSM_HOOK(int, 0, ptrace_access_check, struct task_struct *child,
>  	 unsigned int mode)
>  LSM_HOOK(int, 0, ptrace_traceme, struct task_struct *parent)
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 5c4c5c0602cb..59024618554e 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1313,22 +1313,22 @@
>   *
>   * @binder_set_context_mgr:
>   *	Check whether @mgr is allowed to be the binder context manager.
> - *	@mgr contains the task_struct for the task being registered.
> + *	@mgr contains the struct cred for the current binder process.
>   *	Return 0 if permission is granted.
>   * @binder_transaction:
>   *	Check whether @from is allowed to invoke a binder transaction call
>   *	to @to.
> - *	@from contains the task_struct for the sending task.
> - *	@to contains the task_struct for the receiving task.
> + *	@from contains the struct cred for the sending process.
> + *	@to contains the struct cred for the receiving process.
>   * @binder_transfer_binder:
>   *	Check whether @from is allowed to transfer a binder reference to @t=
o.
> - *	@from contains the task_struct for the sending task.
> - *	@to contains the task_struct for the receiving task.
> + *	@from contains the struct cred for the sending process.
> + *	@to contains the struct cred for the receiving process.
>   * @binder_transfer_file:
>   *	Check whether @from is allowed to transfer @file to @to.
> - *	@from contains the task_struct for the sending task.
> + *	@from contains the struct cred for the sending process.
>   *	@file contains the struct file being transferred.
> - *	@to contains the task_struct for the receiving task.
> + *	@to contains the struct cred for the receiving process.
>   *
>   * @ptrace_access_check:
>   *	Check permission before allowing the current process to trace the
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 5b7288521300..6344d3362df7 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -258,13 +258,13 @@ extern int security_init(void);
>  extern int early_security_init(void);
> =20
>  /* Security operations */
> -int security_binder_set_context_mgr(struct task_struct *mgr);
> -int security_binder_transaction(struct task_struct *from,
> -				struct task_struct *to);
> -int security_binder_transfer_binder(struct task_struct *from,
> -				    struct task_struct *to);
> -int security_binder_transfer_file(struct task_struct *from,
> -				  struct task_struct *to, struct file *file);
> +int security_binder_set_context_mgr(const struct cred *mgr);
> +int security_binder_transaction(const struct cred *from,
> +				const struct cred *to);
> +int security_binder_transfer_binder(const struct cred *from,
> +				    const struct cred *to);
> +int security_binder_transfer_file(const struct cred *from,
> +				  const struct cred *to, struct file *file);
>  int security_ptrace_access_check(struct task_struct *child, unsigned i=
nt mode);
>  int security_ptrace_traceme(struct task_struct *parent);
>  int security_capget(struct task_struct *target,
> @@ -508,25 +508,25 @@ static inline int early_security_init(void)
>  	return 0;
>  }
> =20
> -static inline int security_binder_set_context_mgr(struct task_struct *=
mgr)
> +static inline int security_binder_set_context_mgr(const struct cred *m=
gr)
>  {
>  	return 0;
>  }
> =20
> -static inline int security_binder_transaction(struct task_struct *from=
,
> -					      struct task_struct *to)
> +static inline int security_binder_transaction(const struct cred *from,=

> +					      const struct cred *to)
>  {
>  	return 0;
>  }
> =20
> -static inline int security_binder_transfer_binder(struct task_struct *=
from,
> -						  struct task_struct *to)
> +static inline int security_binder_transfer_binder(const struct cred *f=
rom,
> +						  const struct cred *to)
>  {
>  	return 0;
>  }
> =20
> -static inline int security_binder_transfer_file(struct task_struct *fr=
om,
> -						struct task_struct *to,
> +static inline int security_binder_transfer_file(const struct cred *fro=
m,
> +						const struct cred *to,
>  						struct file *file)
>  {
>  	return 0;
> diff --git a/security/security.c b/security/security.c
> index 9ffa9e9c5c55..67264cb08fb3 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -747,25 +747,25 @@ static int lsm_superblock_alloc(struct super_bloc=
k *sb)
> =20
>  /* Security operations */
> =20
> -int security_binder_set_context_mgr(struct task_struct *mgr)
> +int security_binder_set_context_mgr(const struct cred *mgr)
>  {
>  	return call_int_hook(binder_set_context_mgr, 0, mgr);
>  }
> =20
> -int security_binder_transaction(struct task_struct *from,
> -				struct task_struct *to)
> +int security_binder_transaction(const struct cred *from,
> +				const struct cred *to)
>  {
>  	return call_int_hook(binder_transaction, 0, from, to);
>  }
> =20
> -int security_binder_transfer_binder(struct task_struct *from,
> -				    struct task_struct *to)
> +int security_binder_transfer_binder(const struct cred *from,
> +				    const struct cred *to)
>  {
>  	return call_int_hook(binder_transfer_binder, 0, from, to);
>  }
> =20
> -int security_binder_transfer_file(struct task_struct *from,
> -				  struct task_struct *to, struct file *file)
> +int security_binder_transfer_file(const struct cred *from,
> +				  const struct cred *to, struct file *file)
>  {
>  	return call_int_hook(binder_transfer_file, 0, from, to, file);
>  }
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index e7ebd45ca345..c8bf3db90c8b 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -255,29 +255,6 @@ static inline u32 task_sid_obj(const struct task_s=
truct *task)
>  	return sid;
>  }
> =20
> -/*
> - * get the security ID of a task for use with binder
> - */
> -static inline u32 task_sid_binder(const struct task_struct *task)
> -{
> -	/*
> -	 * In many case where this function is used we should be using the
> -	 * task's subjective SID, but we can't reliably access the subjective=

> -	 * creds of a task other than our own so we must use the objective
> -	 * creds/SID, which are safe to access.  The downside is that if a ta=
sk
> -	 * is temporarily overriding it's creds it will not be reflected here=
;
> -	 * however, it isn't clear that binder would handle that case well
> -	 * anyway.
> -	 *
> -	 * If this ever changes and we can safely reference the subjective
> -	 * creds/SID of another task, this function will make it easier to
> -	 * identify the various places where we make use of the task SIDs in
> -	 * the binder code.  It is also likely that we will need to adjust
> -	 * the main drivers/android binder code as well.
> -	 */
> -	return task_sid_obj(task);
> -}
> -
>  static int inode_doinit_with_dentry(struct inode *inode, struct dentry=
 *opt_dentry);
> =20
>  /*
> @@ -2066,18 +2043,19 @@ static inline u32 open_file_to_av(struct file *=
file)
> =20
>  /* Hook functions begin here. */
> =20
> -static int selinux_binder_set_context_mgr(struct task_struct *mgr)
> +static int selinux_binder_set_context_mgr(const struct cred *mgr)
>  {
>  	return avc_has_perm(&selinux_state,
> -			    current_sid(), task_sid_binder(mgr), SECCLASS_BINDER,
> +			    current_sid(), cred_sid(mgr), SECCLASS_BINDER,
>  			    BINDER__SET_CONTEXT_MGR, NULL);
>  }
> =20
> -static int selinux_binder_transaction(struct task_struct *from,
> -				      struct task_struct *to)
> +static int selinux_binder_transaction(const struct cred *from,
> +				      const struct cred *to)
>  {
>  	u32 mysid =3D current_sid();
> -	u32 fromsid =3D task_sid_binder(from);
> +	u32 fromsid =3D cred_sid(from);
> +	u32 tosid =3D cred_sid(to);
>  	int rc;
> =20
>  	if (mysid !=3D fromsid) {
> @@ -2088,24 +2066,24 @@ static int selinux_binder_transaction(struct ta=
sk_struct *from,
>  			return rc;
>  	}
> =20
> -	return avc_has_perm(&selinux_state, fromsid, task_sid_binder(to),
> +	return avc_has_perm(&selinux_state, fromsid, tosid,
>  			    SECCLASS_BINDER, BINDER__CALL, NULL);
>  }
> =20
> -static int selinux_binder_transfer_binder(struct task_struct *from,
> -					  struct task_struct *to)
> +static int selinux_binder_transfer_binder(const struct cred *from,
> +					  const struct cred *to)
>  {
>  	return avc_has_perm(&selinux_state,
> -			    task_sid_binder(from), task_sid_binder(to),
> +			    cred_sid(from), cred_sid(to),
>  			    SECCLASS_BINDER, BINDER__TRANSFER,
>  			    NULL);
>  }
> =20
> -static int selinux_binder_transfer_file(struct task_struct *from,
> -					struct task_struct *to,
> +static int selinux_binder_transfer_file(const struct cred *from,
> +					const struct cred *to,
>  					struct file *file)
>  {
> -	u32 sid =3D task_sid_binder(to);
> +	u32 sid =3D cred_sid(to);
>  	struct file_security_struct *fsec =3D selinux_file(file);
>  	struct dentry *dentry =3D file->f_path.dentry;
>  	struct inode_security_struct *isec;

