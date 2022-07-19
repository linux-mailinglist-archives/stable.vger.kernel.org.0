Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6179557A894
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 22:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240429AbiGSUwS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 19 Jul 2022 16:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240339AbiGSUwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 16:52:08 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5E261132;
        Tue, 19 Jul 2022 13:51:48 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:48826)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oDuBz-00HAg6-67; Tue, 19 Jul 2022 14:51:43 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:57296 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oDuBx-005w1j-JJ; Tue, 19 Jul 2022 14:51:42 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Valentin Schneider <vschneid@redhat.com>,
        stable@vger.kernel.org, Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <CAHmME9qrd25vfRYYvCWtPg+wVC5joEzzJiihCN+L4rqMfTL4Rg@mail.gmail.com>
        <20220719201108.264322-1-Jason@zx2c4.com>
Date:   Tue, 19 Jul 2022 15:51:34 -0500
In-Reply-To: <20220719201108.264322-1-Jason@zx2c4.com> (Jason A. Donenfeld's
        message of "Tue, 19 Jul 2022 22:11:08 +0200")
Message-ID: <87sfmwsu5l.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1oDuBx-005w1j-JJ;;;mid=<87sfmwsu5l.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1/5tVDVVHuGaRokt+4yK+YkkkmjIhNYR60=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;"Jason A. Donenfeld" <Jason@zx2c4.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 986 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 11 (1.1%), b_tie_ro: 9 (1.0%), parse: 1.34 (0.1%),
         extract_message_metadata: 31 (3.2%), get_uri_detail_list: 6 (0.6%),
        tests_pri_-1000: 48 (4.9%), tests_pri_-950: 1.28 (0.1%),
        tests_pri_-900: 1.03 (0.1%), tests_pri_-90: 276 (28.0%), check_bayes:
        274 (27.8%), b_tokenize: 19 (1.9%), b_tok_get_all: 16 (1.6%),
        b_comp_prob: 4.7 (0.5%), b_tok_touch_all: 229 (23.2%), b_finish: 1.08
        (0.1%), tests_pri_0: 602 (61.0%), check_dkim_signature: 0.72 (0.1%),
        check_dkim_adsp: 3.1 (0.3%), poll_dns_idle: 1.10 (0.1%), tests_pri_10:
        2.3 (0.2%), tests_pri_500: 8 (0.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v10] ath9k: let sleep be interrupted when unregistering
 hwrng
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> There are two deadlock scenarios that need addressing, which cause
> problems when the computer goes to sleep, the interface is set down, and
> hwrng_unregister() is called. When the deadlock is hit, sleep is delayed
> for tens of seconds, causing it to fail. These scenarios are:
>
> 1) The hwrng kthread can't be stopped while it's sleeping, because it
>    uses msleep_interruptible() instead of schedule_timeout_interruptible().
>    The fix is a simple moving to the correct function. At the same time,
>    we should cleanup a common and useless dmesg splat in the same area.
>
> 2) A normal user thread can't be interrupted by hwrng_unregister() while
>    it's sleeping, because hwrng_unregister() is called from elsewhere.
>    The solution here is to keep track of which thread is currently
>    reading, and asleep, and signal that thread when it's time to
>    unregister. There's a bit of book keeping required to prevent
>    lifetime issues on current.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

The fix as it is seems fine.

The whole design seems very strange to me.  I would think instead of
having a current hardware random number generator the kernel would
pull from every hardware random generator available.  Further that
we can get a userspace read all of the way into driver code for
a hardware random generator seems weird.    I would think in
practice we would want all of this filtered through /dev/random,
/dev/urandom, and the get_entropy syscall.

Which is a long way of saying it seems very strange to me that we
actually want to do what the code is doing.

Eric


> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Rui Salvaterra <rsalvaterra@gmail.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Valentin Schneider <vschneid@redhat.com>
> Cc: stable@vger.kernel.org
> Reported-by: Gregory Erwin <gregerwin256@gmail.com>
> Tested-by: Gregory Erwin <gregerwin256@gmail.com>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly dumping into random.c")
> Link: https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytGgDsFGTEjs0c00giw@mail.gmail.com/
> Link: https://lore.kernel.org/lkml/CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7EY8Hys_DVXtent3HA@mail.gmail.com/
> Link: https://bugs.archlinux.org/task/75138
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Changes v9->v10:
> - Call it wake_up_task_interruptible, per Eric's remark.
> Changes v8->v9:
> - Use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL.
> - Don't export wake_up_state, but rather have __set_notify_signal use
>   wake_up_process_interruptible.
>
>  drivers/char/hw_random/core.c        | 30 ++++++++++++++++++++++++----
>  drivers/net/wireless/ath/ath9k/rng.c | 19 +++++++-----------
>  include/linux/sched.h                |  1 +
>  include/linux/sched/signal.h         |  2 +-
>  kernel/sched/core.c                  |  6 ++++++
>  5 files changed, 41 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 16f227b995e8..df45c265878e 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -38,6 +38,8 @@ static LIST_HEAD(rng_list);
>  static DEFINE_MUTEX(rng_mutex);
>  /* Protects rng read functions, data_avail, rng_buffer and rng_fillbuf */
>  static DEFINE_MUTEX(reading_mutex);
> +/* Keeps track of whoever is wait-reading it currently while holding reading_mutex. */
> +static struct task_struct *current_waiting_reader;
>  static int data_avail;
>  static u8 *rng_buffer, *rng_fillbuf;
>  static unsigned short current_quality;
> @@ -208,6 +210,7 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>  	int err = 0;
>  	int bytes_read, len;
>  	struct hwrng *rng;
> +	bool wait;
>  
>  	while (size) {
>  		rng = get_current_rng();
> @@ -225,9 +228,15 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>  			goto out_put;
>  		}
>  		if (!data_avail) {
> +			wait = !(filp->f_flags & O_NONBLOCK);
> +			if (wait && cmpxchg(&current_waiting_reader, NULL, current) != NULL) {
> +				err = -EINTR;
> +				goto out_unlock_reading;
> +			}
>  			bytes_read = rng_get_data(rng, rng_buffer,
> -				rng_buffer_size(),
> -				!(filp->f_flags & O_NONBLOCK));
> +				rng_buffer_size(), wait);
> +			if (wait && cmpxchg(&current_waiting_reader, current, NULL) != current)
> +				synchronize_rcu();
>  			if (bytes_read < 0) {
>  				err = bytes_read;
>  				goto out_unlock_reading;
> @@ -513,8 +522,9 @@ static int hwrng_fillfn(void *unused)
>  			break;
>  
>  		if (rc <= 0) {
> -			pr_warn("hwrng: no data available\n");
> -			msleep_interruptible(10000);
> +			if (kthread_should_stop())
> +				break;
> +			schedule_timeout_interruptible(HZ * 10);
>  			continue;
>  		}
>  
> @@ -608,13 +618,21 @@ int hwrng_register(struct hwrng *rng)
>  }
>  EXPORT_SYMBOL_GPL(hwrng_register);
>  
> +#define UNREGISTERING_READER ((void *)~0UL)
> +
>  void hwrng_unregister(struct hwrng *rng)
>  {
>  	struct hwrng *old_rng, *new_rng;
> +	struct task_struct *waiting_reader;
>  	int err;
>  
>  	mutex_lock(&rng_mutex);
>  
> +	rcu_read_lock();
> +	waiting_reader = xchg(&current_waiting_reader, UNREGISTERING_READER);
> +	if (waiting_reader && waiting_reader != UNREGISTERING_READER)
> +		set_notify_signal(waiting_reader);
> +	rcu_read_unlock();
>  	old_rng = current_rng;
>  	list_del(&rng->list);
>  	if (current_rng == rng) {
> @@ -640,6 +658,10 @@ void hwrng_unregister(struct hwrng *rng)
>  	}
>  
>  	wait_for_completion(&rng->cleanup_done);
> +
> +	mutex_lock(&rng_mutex);
> +	cmpxchg(&current_waiting_reader, UNREGISTERING_READER, NULL);
> +	mutex_unlock(&rng_mutex);
>  }
>  EXPORT_SYMBOL_GPL(hwrng_unregister);
>  
> diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
> index cb5414265a9b..8980dc36509e 100644
> --- a/drivers/net/wireless/ath/ath9k/rng.c
> +++ b/drivers/net/wireless/ath/ath9k/rng.c
> @@ -52,18 +52,13 @@ static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32 buf_size)
>  	return j << 2;
>  }
>  
> -static u32 ath9k_rng_delay_get(u32 fail_stats)
> +static unsigned long ath9k_rng_delay_get(u32 fail_stats)
>  {
> -	u32 delay;
> -
>  	if (fail_stats < 100)
> -		delay = 10;
> +		return HZ / 100;
>  	else if (fail_stats < 105)
> -		delay = 1000;
> -	else
> -		delay = 10000;
> -
> -	return delay;
> +		return HZ;
> +	return HZ * 10;
>  }
>  
>  static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> @@ -80,10 +75,10 @@ static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
>  			bytes_read += max & 3UL;
>  			memzero_explicit(&word, sizeof(word));
>  		}
> -		if (!wait || !max || likely(bytes_read) || fail_stats > 110)
> +		if (!wait || !max || likely(bytes_read) || fail_stats > 110 ||
> +		    ((current->flags & PF_KTHREAD) && kthread_should_stop()) ||
> +		    schedule_timeout_interruptible(ath9k_rng_delay_get(++fail_stats)))
>  			break;
> -
> -		msleep_interruptible(ath9k_rng_delay_get(++fail_stats));
>  	}
>  
>  	if (wait && !bytes_read && max)
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index c46f3a63b758..f164098fb614 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1936,6 +1936,7 @@ extern struct task_struct *find_get_task_by_vpid(pid_t nr);
>  
>  extern int wake_up_state(struct task_struct *tsk, unsigned int state);
>  extern int wake_up_process(struct task_struct *tsk);
> +extern int wake_up_task_interruptible(struct task_struct *tsk);
>  extern void wake_up_new_task(struct task_struct *tsk);
>  
>  #ifdef CONFIG_SMP
> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
> index cafbe03eed01..56a15f35e7b3 100644
> --- a/include/linux/sched/signal.h
> +++ b/include/linux/sched/signal.h
> @@ -364,7 +364,7 @@ static inline void clear_notify_signal(void)
>  static inline bool __set_notify_signal(struct task_struct *task)
>  {
>  	return !test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL) &&
> -	       !wake_up_state(task, TASK_INTERRUPTIBLE);
> +	       !wake_up_task_interruptible(task);
>  }
>  
>  /*
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index da0bf6fe9ecd..b178940185d7 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4280,6 +4280,12 @@ int wake_up_process(struct task_struct *p)
>  }
>  EXPORT_SYMBOL(wake_up_process);
>  
> +int wake_up_task_interruptible(struct task_struct *p)
> +{
> +	return try_to_wake_up(p, TASK_INTERRUPTIBLE, 0);
> +}
> +EXPORT_SYMBOL_GPL(wake_up_task_interruptible);
> +
>  int wake_up_state(struct task_struct *p, unsigned int state)
>  {
>  	return try_to_wake_up(p, state, 0);
