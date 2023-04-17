Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D515B6E4C68
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 17:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjDQPJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 11:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjDQPJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 11:09:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EF08A47
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 08:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681744111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UdR56u8UGYt8+KvAqE9HS2K/Gu8fK80IlOcfRq4k3lg=;
        b=YwJuCM9IVXF++Kk0O1b2x4CKtzc7gJpz/OTnh8VCukRzEsaAgWLE02/fTPcQTd+SSjaVdj
        KYaMXikQ2QR1PIgIwtKHzB+sAfZiWyKKvRecqvr9ms2cyG8RnktvDhlDDQUWKdDPqtYtV8
        UoVS0ELFlXB2gtGs62+iu+d+PhytdCw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-gRyM_6vLM0O1YeB5wTAawA-1; Mon, 17 Apr 2023 11:08:27 -0400
X-MC-Unique: gRyM_6vLM0O1YeB5wTAawA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39B0B185A78F;
        Mon, 17 Apr 2023 15:08:27 +0000 (UTC)
Received: from [10.18.17.153] (dhcp-17-153.bos.redhat.com [10.18.17.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AC8D14171B8;
        Mon, 17 Apr 2023 15:08:26 +0000 (UTC)
Message-ID: <27c98635-4114-0e49-cfb8-f653de06d867@redhat.com>
Date:   Mon, 17 Apr 2023 11:08:26 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: FAILED: patch "[PATCH] cgroup/cpuset: Add cpuset_can_fork() and
 cpuset_cancel_fork()" failed to apply to 6.1-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, mkoutny@suse.com, tj@kernel.org
Cc:     stable@vger.kernel.org
References: <2023041702-vertebrae-bonsai-f1de@gregkh>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <2023041702-vertebrae-bonsai-f1de@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/17/23 04:04, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> To reproduce the conflict and resubmit, you may use the following commands:
>
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
> git checkout FETCH_HEAD
> git cherry-pick -x eee87853794187f6adbe19533ed79c8b44b36a91
> # <resolve conflicts, build, test, etc.>
> git commit -s
> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041702-vertebrae-bonsai-f1de@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..
>
> Possible dependencies:
>
> eee878537941 ("cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods")
> 42a11bf5c543 ("cgroup/cpuset: Make cpuset_fork() handle CLONE_INTO_CGROUP properly")
> 18f9a4d47527 ("cgroup/cpuset: Skip spread flags update on v2")

I have posted a patch series that also include commit 18f9a4d47527 
("cgroup/cpuset: Skip spread flags update on v2") which is not 
technically a fix but is relative simple and low risk.

Cheers,
Longman


> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
>  From eee87853794187f6adbe19533ed79c8b44b36a91 Mon Sep 17 00:00:00 2001
> From: Waiman Long <longman@redhat.com>
> Date: Tue, 11 Apr 2023 09:35:59 -0400
> Subject: [PATCH] cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork()
>   methods
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
>
> In the case of CLONE_INTO_CGROUP, not all cpusets are ready to accept
> new tasks. It is too late to check that in cpuset_fork(). So we need
> to add the cpuset_can_fork() and cpuset_cancel_fork() methods to
> pre-check it before we can allow attachment to a different cpuset.
>
> We also need to set the attach_in_progress flag to alert other code
> that a new task is going to be added to the cpuset.
>
> Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
> Suggested-by: Michal Koutný <mkoutny@suse.com>
> Signed-off-by: Waiman Long <longman@redhat.com>
> Cc: stable@vger.kernel.org # v5.7+
> Signed-off-by: Tejun Heo <tj@kernel.org>
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 2ccfae74acf9..166a45019f66 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2453,6 +2453,20 @@ static int fmeter_getrate(struct fmeter *fmp)
>   
>   static struct cpuset *cpuset_attach_old_cs;
>   
> +/*
> + * Check to see if a cpuset can accept a new task
> + * For v1, cpus_allowed and mems_allowed can't be empty.
> + * For v2, effective_cpus can't be empty.
> + * Note that in v1, effective_cpus = cpus_allowed.
> + */
> +static int cpuset_can_attach_check(struct cpuset *cs)
> +{
> +	if (cpumask_empty(cs->effective_cpus) ||
> +	   (!is_in_v2_mode() && nodes_empty(cs->mems_allowed)))
> +		return -ENOSPC;
> +	return 0;
> +}
> +
>   /* Called by cgroups to determine if a cpuset is usable; cpuset_rwsem held */
>   static int cpuset_can_attach(struct cgroup_taskset *tset)
>   {
> @@ -2467,16 +2481,9 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>   
>   	percpu_down_write(&cpuset_rwsem);
>   
> -	/* allow moving tasks into an empty cpuset if on default hierarchy */
> -	ret = -ENOSPC;
> -	if (!is_in_v2_mode() &&
> -	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
> -		goto out_unlock;
> -
> -	/*
> -	 * Task cannot be moved to a cpuset with empty effective cpus.
> -	 */
> -	if (cpumask_empty(cs->effective_cpus))
> +	/* Check to see if task is allowed in the cpuset */
> +	ret = cpuset_can_attach_check(cs);
> +	if (ret)
>   		goto out_unlock;
>   
>   	cgroup_taskset_for_each(task, css, tset) {
> @@ -2493,7 +2500,6 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>   	 * changes which zero cpus/mems_allowed.
>   	 */
>   	cs->attach_in_progress++;
> -	ret = 0;
>   out_unlock:
>   	percpu_up_write(&cpuset_rwsem);
>   	return ret;
> @@ -3264,6 +3270,68 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
>   	percpu_up_write(&cpuset_rwsem);
>   }
>   
> +/*
> + * In case the child is cloned into a cpuset different from its parent,
> + * additional checks are done to see if the move is allowed.
> + */
> +static int cpuset_can_fork(struct task_struct *task, struct css_set *cset)
> +{
> +	struct cpuset *cs = css_cs(cset->subsys[cpuset_cgrp_id]);
> +	bool same_cs;
> +	int ret;
> +
> +	rcu_read_lock();
> +	same_cs = (cs == task_cs(current));
> +	rcu_read_unlock();
> +
> +	if (same_cs)
> +		return 0;
> +
> +	lockdep_assert_held(&cgroup_mutex);
> +	percpu_down_write(&cpuset_rwsem);
> +
> +	/* Check to see if task is allowed in the cpuset */
> +	ret = cpuset_can_attach_check(cs);
> +	if (ret)
> +		goto out_unlock;
> +
> +	ret = task_can_attach(task, cs->effective_cpus);
> +	if (ret)
> +		goto out_unlock;
> +
> +	ret = security_task_setscheduler(task);
> +	if (ret)
> +		goto out_unlock;
> +
> +	/*
> +	 * Mark attach is in progress.  This makes validate_change() fail
> +	 * changes which zero cpus/mems_allowed.
> +	 */
> +	cs->attach_in_progress++;
> +out_unlock:
> +	percpu_up_write(&cpuset_rwsem);
> +	return ret;
> +}
> +
> +static void cpuset_cancel_fork(struct task_struct *task, struct css_set *cset)
> +{
> +	struct cpuset *cs = css_cs(cset->subsys[cpuset_cgrp_id]);
> +	bool same_cs;
> +
> +	rcu_read_lock();
> +	same_cs = (cs == task_cs(current));
> +	rcu_read_unlock();
> +
> +	if (same_cs)
> +		return;
> +
> +	percpu_down_write(&cpuset_rwsem);
> +	cs->attach_in_progress--;
> +	if (!cs->attach_in_progress)
> +		wake_up(&cpuset_attach_wq);
> +	percpu_up_write(&cpuset_rwsem);
> +}
> +
>   /*
>    * Make sure the new task conform to the current state of its parent,
>    * which could have been changed by cpuset just after it inherits the
> @@ -3292,6 +3360,11 @@ static void cpuset_fork(struct task_struct *task)
>   	percpu_down_write(&cpuset_rwsem);
>   	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
>   	cpuset_attach_task(cs, task);
> +
> +	cs->attach_in_progress--;
> +	if (!cs->attach_in_progress)
> +		wake_up(&cpuset_attach_wq);
> +
>   	percpu_up_write(&cpuset_rwsem);
>   }
>   
> @@ -3305,6 +3378,8 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
>   	.attach		= cpuset_attach,
>   	.post_attach	= cpuset_post_attach,
>   	.bind		= cpuset_bind,
> +	.can_fork	= cpuset_can_fork,
> +	.cancel_fork	= cpuset_cancel_fork,
>   	.fork		= cpuset_fork,
>   	.legacy_cftypes	= legacy_files,
>   	.dfl_cftypes	= dfl_files,
>

