Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A96447568
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 20:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbhKGTzC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 7 Nov 2021 14:55:02 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46024 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbhKGTzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Nov 2021 14:55:02 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:44400)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mjoDB-007SSi-MT; Sun, 07 Nov 2021 12:52:17 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:52608 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mjoDA-00070t-He; Sun, 07 Nov 2021 12:52:17 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        stable@vger.kernel.org
References: <20211027224348.611025-1-alexander.mikhalitsyn@virtuozzo.com>
        <20211027224348.611025-3-alexander.mikhalitsyn@virtuozzo.com>
        <87wnlmqyw4.fsf@disp2133>
        <61ca7331-4a86-2bf6-9ccb-50f6a7824e12@colorfullife.com>
        <87lf22qob5.fsf_-_@disp2133>
        <8ba678da-207e-ea00-a56d-736a2184e69e@colorfullife.com>
Date:   Sun, 07 Nov 2021 13:51:40 -0600
In-Reply-To: <8ba678da-207e-ea00-a56d-736a2184e69e@colorfullife.com> (Manfred
        Spraul's message of "Sat, 6 Nov 2021 15:42:07 +0100")
Message-ID: <87r1brpwvn.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1mjoDA-00070t-He;;;mid=<87r1brpwvn.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19L+vydsPu37ThWuj8HzXPv2CWj9pJNGhc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa01.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.1 required=8.0 tests=ALL_TRUSTED,BAYES_40,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong,
        XM_B_SpammyWords,XM_B_Unicode autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
        *      [score: 0.3663]
        *  0.7 XMSubLong Long Subject
        *  0.0 XM_B_Unicode BODY: Testing for specific types of unicode
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.2 XM_B_SpammyWords One or more commonly used spammy words
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Manfred Spraul <manfred@colorfullife.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 527 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 3.9 (0.7%), b_tie_ro: 2.7 (0.5%), parse: 0.84
        (0.2%), extract_message_metadata: 10 (1.8%), get_uri_detail_list: 2.0
        (0.4%), tests_pri_-1000: 4.0 (0.8%), tests_pri_-950: 0.98 (0.2%),
        tests_pri_-900: 0.82 (0.2%), tests_pri_-90: 92 (17.5%), check_bayes:
        91 (17.2%), b_tokenize: 8 (1.6%), b_tok_get_all: 9 (1.7%),
        b_comp_prob: 1.94 (0.4%), b_tok_touch_all: 68 (12.9%), b_finish: 0.82
        (0.2%), tests_pri_0: 402 (76.3%), check_dkim_signature: 0.45 (0.1%),
        check_dkim_adsp: 2.2 (0.4%), poll_dns_idle: 0.71 (0.1%), tests_pri_10:
        2.6 (0.5%), tests_pri_500: 7 (1.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC] shm: extend forced shm destroy to support objects from several IPC nses (simplified)
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Manfred Spraul <manfred@colorfullife.com> writes:

> Hello together,
>
> On 11/5/21 22:34, Eric W. Biederman wrote:
>>   +static inline void shm_clist_del(struct shmid_kernel *shp)
>> +{
>> +	struct task_struct *creator;
>> +
>> +	rcu_read_lock();
>> +	creator = rcu_dereference(shp->shm_creator);
>> +	if (creator) {
>> +		task_lock(creator);
>> +		list_del(&shp->shm_clist);
>> +		task_unlock(creator);
>> +	}
>> +	rcu_read_unlock();
>> +}
>> +
>
> shm_clist_del() only synchronizes against exit_shm() when shm_creator
> is not NULL.
>
>
>> +		list_del(&shp->shm_clist);
>> +		rcu_assign_pointer(shp->shm_creator, NULL);
>> +
>
> We set shm_creator to NULL -> no more synchronization.
>
> Now IPC_RMID can run in parallel - regardless if we test for
> list_empty() or shm_creator.
>
>> +
>> +		/* Guarantee shp lives after task_lock is dropped */
>> +		ipc_getref(&shp->shm_perm);
>> +
>
> task_lock() doesn't help: As soon as shm_creator is set to NULL,
> IPC_RMID won't acquire task_lock() anymore.
>
> Thus shp can disappear before we arrive at this ipc_getref.
>
> [Yes, I think I have introduced this bug. ]
>
> Corrected version attached.
>
>
> I'll reboot and retest the patch, then I would send it to akpm as
> replacement for current patch in mmotm.
>
> --
>
>     Manfred
>

> @@ -382,48 +425,94 @@ void shm_destroy_orphaned(struct ipc_namespace *ns)
>  /* Locking assumes this will only be called with task == current */
>  void exit_shm(struct task_struct *task)
>  {
> -	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
> -	struct shmid_kernel *shp, *n;
> +	for (;;) {
> +		struct shmid_kernel *shp;
> +		struct ipc_namespace *ns;
>  
> -	if (list_empty(&task->sysvshm.shm_clist))
> -		return;
> +		task_lock(task);
> +
> +		if (list_empty(&task->sysvshm.shm_clist)) {
> +			task_unlock(task);
> +			break;
> +		}
> +
> +		shp = list_first_entry(&task->sysvshm.shm_clist, struct shmid_kernel,
> +				shm_clist);
>  
> -	/*
> -	 * If kernel.shm_rmid_forced is not set then only keep track of
> -	 * which shmids are orphaned, so that a later set of the sysctl
> -	 * can clean them up.
> -	 */
> -	if (!ns->shm_rmid_forced) {
> -		down_read(&shm_ids(ns).rwsem);
> -		list_for_each_entry(shp, &task->sysvshm.shm_clist, shm_clist)
> -			shp->shm_creator = NULL;
>  		/*
> -		 * Only under read lock but we are only called on current
> -		 * so no entry on the list will be shared.
> +		 * 1) get a reference to shp.
> +		 *    This must be done first: Right now, task_lock() prevents
> +		 *    any concurrent IPC_RMID calls. After the list_del_init(),
> +		 *    IPC_RMID will not acquire task_lock(->shm_creator)
> +		 *    anymore.
>  		 */
> -		list_del(&task->sysvshm.shm_clist);
> -		up_read(&shm_ids(ns).rwsem);
> -		return;
> -	}
> +		WARN_ON(!ipc_rcu_getref(&shp->shm_perm));
>  
> -	/*
> -	 * Destroy all already created segments, that were not yet mapped,
> -	 * and mark any mapped as orphan to cover the sysctl toggling.
> -	 * Destroy is skipped if shm_may_destroy() returns false.
> -	 */
> -	down_write(&shm_ids(ns).rwsem);
> -	list_for_each_entry_safe(shp, n, &task->sysvshm.shm_clist, shm_clist) {
> -		shp->shm_creator = NULL;
> +		/* 2) unlink */
> +		list_del_init(&shp->shm_clist);
> +
> +		/*
> +		 * 3) Get pointer to the ipc namespace. It is worth to say
> +		 * that this pointer is guaranteed to be valid because
> +		 * shp lifetime is always shorter than namespace lifetime
> +		 * in which shp lives.
> +		 * We taken task_lock it means that shp won't be freed.
> +		 */
> +		ns = shp->ns;
>  
> -		if (shm_may_destroy(ns, shp)) {
> -			shm_lock_by_ptr(shp);
> -			shm_destroy(ns, shp);
> +		/*
> +		 * 4) If kernel.shm_rmid_forced is not set then only keep track of
> +		 * which shmids are orphaned, so that a later set of the sysctl
> +		 * can clean them up.
> +		 */
> +		if (!ns->shm_rmid_forced) {
> +			ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
> +			task_unlock(task);
> +			continue;
>  		}
> -	}
>  
> -	/* Remove the list head from any segments still attached. */
> -	list_del(&task->sysvshm.shm_clist);
> -	up_write(&shm_ids(ns).rwsem);
> +		/*
> +		 * 5) get a reference to the namespace.
> +		 *    The refcount could be already 0. If it is 0, then
> +		 *    the shm objects will be free by free_ipc_work().
> +		 */
> +		ns = get_ipc_ns_not_zero(ns);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Isn't this increment also too late?  Doesn't this need to move up
by ipc_rcu_getref while shp is still on the list?

Assuming the code is running in parallel with shm_exit_ns after removal
from shm_clist shm_destroy can run to completion and shm_exit_ns can
run to completion and the ipc namespace can be freed.

Eric
