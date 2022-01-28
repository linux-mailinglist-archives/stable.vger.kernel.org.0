Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5FE49F324
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 06:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346230AbiA1Fq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 00:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346228AbiA1Fqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 00:46:55 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7663FC061747
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 21:46:55 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id b9so9597175lfq.6
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 21:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j9QAUXsaGpNiwuJIMC+KzjJsq2rTUeG9HMZR2DewBO8=;
        b=yoIsllthc2gx8wbUIUQuCG8p1I0wYSRZKefrJu+CAtf0ULpTgx6Qg5H+4zp3+mUzTO
         hYrVQVPLAwRE+xj5FtiGAH4jMocYWMmwqp+IgVTxDZNabJDCLNWcx8Rg0hXcEp3EkABZ
         AkXOulyZhQagDKel+3a6RUTCjn2UmepFUtju8egkGwbjyRkWARXn2gIP+pxh9fgsm6p3
         /kmEg1cKSJdM5iH/67lqoelLxuqPwTB3iVxHzD3mUQ7Mds89IzJEq5stg1l3a4tWN3q/
         uykC5DosHpywHnAVprDYPykTN1AKp+/PwI/4Q/VSH/+tN0CQ3GTW7qg3sJylj+Z/TJPl
         OHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j9QAUXsaGpNiwuJIMC+KzjJsq2rTUeG9HMZR2DewBO8=;
        b=bD7H1mPoapdmz6VNgRNaXejvE3zkocrKfKjwN8zOKpIl/36/Beurko/aZ32qQdomkx
         NKzcRy0pusVgoWi0vkspRAcKbPACCgrQF08WMp7Bt7FKVNndOX5UDNDwB1IsmM5nP9gs
         11fUD6dVe8F5uN8Bupc9N4BRJ2EdFZ/3Klsj/JsrUNMR6B/a7gUzmLmIYrtoLUpqRCGN
         +wrb97OazVAIwadPqZ/vNpupNXMRZuEtfOg/372e4nGjqbQva0FpJ8YcK3RnosPF1LgN
         RiK8GJA2dCwThuNhGlyZN7n9llPRtubFk8e644TC1mC7tPp+5TBJr+tf+DhcFwf/YGIf
         oQSA==
X-Gm-Message-State: AOAM533VtWdSDVbNPNcf4j0TyLsKIbUhPYCVTNWlOhWJhJJE5plo8mw7
        mHaQ3aUIyKQ8nVMBPksShfbFewt7b4RKYTcEDxunFw==
X-Google-Smtp-Source: ABdhPJxnmQ20HpbyUDw9hMByogFp3Orp93zxdrpqFiewdOkYCfjIl2MUBVUHwOBO0ODHX0X3Vluj+M3OCjrtuLuIKuE=
X-Received: by 2002:ac2:52b8:: with SMTP id r24mr5121225lfm.80.1643348813552;
 Thu, 27 Jan 2022 21:46:53 -0800 (PST)
MIME-Version: 1.0
References: <20220127142939.1734912-1-jens.wiklander@linaro.org>
In-Reply-To: <20220127142939.1734912-1-jens.wiklander@linaro.org>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Fri, 28 Jan 2022 11:16:42 +0530
Message-ID: <CAFA6WYNqSKwtRYN+dudreG=ZuRLhzsbNgy8wwjrYuSR6oq_79w@mail.gmail.com>
Subject: Re: [PATCH] optee: use driver internal tee_contex for some rpc
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     linux-kernel@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Lars Persson <Lars.Persson@axis.com>,
        Lars Persson <larper@axis.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 at 19:59, Jens Wiklander <jens.wiklander@linaro.org> wrote:
>
> Adds a driver private tee_context by moving the tee_context in struct
> optee_notif to struct optee. This tee_context was previously used when
> doing internal calls to secure world to deliver notification.
>
> The new driver internal tee_context is now also when allocating driver
> private shared memory. This decouples the shared memory object from its
> original tee_context. This is needed when the life time of such a memory
> allocation outlives the client tee_context.
>
> This patch fixes the problem described below:
>
> The addition of a shutdown hook by commit f25889f93184 ("optee: fix tee out
> of memory failure seen during kexec reboot") introduced a kernel shutdown
> regression that can be triggered after running the OP-TEE xtest suites.
>
> Once the shutdown hook is called it is not possible to communicate any more
> with the supplicant process because the system is not scheduling task any
> longer. Thus if the optee driver shutdown path receives a supplicant RPC
> request from the OP-TEE we will deadlock the kernel's shutdown.
>
> Fixes: f25889f93184 ("optee: fix tee out of memory failure seen during kexec reboot")
> Fixes: 217e0250cccb ("tee: use reference counting for tee_context")
> Reported-by: Lars Persson <larper@axis.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> ---
>
> This patch is from "optee: add driver private tee_context" and "optee: use
> driver internal tee_contex for some rpc" in [1] combined into one patch for
> easier tracking. It turned out that those two patches fixes reported
> problem so I'm breaking out this from the patchset in order to target it
> for the v5.17.
>
> [1] https://lore.kernel.org/lkml/20220125162938.838382-1-jens.wiklander@linaro.org/
>
>  drivers/tee/optee/core.c          |  1 +
>  drivers/tee/optee/ffa_abi.c       | 77 +++++++++++++++++--------------
>  drivers/tee/optee/optee_private.h |  5 +-
>  drivers/tee/optee/smc_abi.c       | 48 +++++++------------
>  4 files changed, 64 insertions(+), 67 deletions(-)
>

Reviewed-by: Sumit Garg <sumit.garg@linaro.org>

-Sumit

> diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
> index 1ca320885fad..17a6f51d3089 100644
> --- a/drivers/tee/optee/core.c
> +++ b/drivers/tee/optee/core.c
> @@ -158,6 +158,7 @@ void optee_remove_common(struct optee *optee)
>         optee_unregister_devices();
>
>         optee_notif_uninit(optee);
> +       teedev_close_context(optee->ctx);
>         /*
>          * The two devices have to be unregistered before we can free the
>          * other resources.
> diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
> index 20a1b1a3d965..545f61af1248 100644
> --- a/drivers/tee/optee/ffa_abi.c
> +++ b/drivers/tee/optee/ffa_abi.c
> @@ -424,6 +424,7 @@ static struct tee_shm_pool_mgr *optee_ffa_shm_pool_alloc_pages(void)
>   */
>
>  static void handle_ffa_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
> +                                             struct optee *optee,
>                                               struct optee_msg_arg *arg)
>  {
>         struct tee_shm *shm;
> @@ -439,7 +440,7 @@ static void handle_ffa_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
>                 shm = optee_rpc_cmd_alloc_suppl(ctx, arg->params[0].u.value.b);
>                 break;
>         case OPTEE_RPC_SHM_TYPE_KERNEL:
> -               shm = tee_shm_alloc(ctx, arg->params[0].u.value.b,
> +               shm = tee_shm_alloc(optee->ctx, arg->params[0].u.value.b,
>                                     TEE_SHM_MAPPED | TEE_SHM_PRIV);
>                 break;
>         default:
> @@ -493,14 +494,13 @@ static void handle_ffa_rpc_func_cmd_shm_free(struct tee_context *ctx,
>  }
>
>  static void handle_ffa_rpc_func_cmd(struct tee_context *ctx,
> +                                   struct optee *optee,
>                                     struct optee_msg_arg *arg)
>  {
> -       struct optee *optee = tee_get_drvdata(ctx->teedev);
> -
>         arg->ret_origin = TEEC_ORIGIN_COMMS;
>         switch (arg->cmd) {
>         case OPTEE_RPC_CMD_SHM_ALLOC:
> -               handle_ffa_rpc_func_cmd_shm_alloc(ctx, arg);
> +               handle_ffa_rpc_func_cmd_shm_alloc(ctx, optee, arg);
>                 break;
>         case OPTEE_RPC_CMD_SHM_FREE:
>                 handle_ffa_rpc_func_cmd_shm_free(ctx, optee, arg);
> @@ -510,12 +510,12 @@ static void handle_ffa_rpc_func_cmd(struct tee_context *ctx,
>         }
>  }
>
> -static void optee_handle_ffa_rpc(struct tee_context *ctx, u32 cmd,
> -                                struct optee_msg_arg *arg)
> +static void optee_handle_ffa_rpc(struct tee_context *ctx, struct optee *optee,
> +                                u32 cmd, struct optee_msg_arg *arg)
>  {
>         switch (cmd) {
>         case OPTEE_FFA_YIELDING_CALL_RETURN_RPC_CMD:
> -               handle_ffa_rpc_func_cmd(ctx, arg);
> +               handle_ffa_rpc_func_cmd(ctx, optee, arg);
>                 break;
>         case OPTEE_FFA_YIELDING_CALL_RETURN_INTERRUPT:
>                 /* Interrupt delivered by now */
> @@ -582,7 +582,7 @@ static int optee_ffa_yielding_call(struct tee_context *ctx,
>                  * above.
>                  */
>                 cond_resched();
> -               optee_handle_ffa_rpc(ctx, data->data1, rpc_arg);
> +               optee_handle_ffa_rpc(ctx, optee, data->data1, rpc_arg);
>                 cmd = OPTEE_FFA_YIELDING_CALL_RESUME;
>                 data->data0 = cmd;
>                 data->data1 = 0;
> @@ -793,7 +793,9 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
>  {
>         const struct ffa_dev_ops *ffa_ops;
>         unsigned int rpc_arg_count;
> +       struct tee_shm_pool *pool;
>         struct tee_device *teedev;
> +       struct tee_context *ctx;
>         struct optee *optee;
>         int rc;
>
> @@ -813,12 +815,12 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
>         if (!optee)
>                 return -ENOMEM;
>
> -       optee->pool = optee_ffa_config_dyn_shm();
> -       if (IS_ERR(optee->pool)) {
> -               rc = PTR_ERR(optee->pool);
> -               optee->pool = NULL;
> -               goto err;
> +       pool = optee_ffa_config_dyn_shm();
> +       if (IS_ERR(pool)) {
> +               rc = PTR_ERR(pool);
> +               goto err_free_optee;
>         }
> +       optee->pool = pool;
>
>         optee->ops = &optee_ffa_ops;
>         optee->ffa.ffa_dev = ffa_dev;
> @@ -829,7 +831,7 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
>                                   optee);
>         if (IS_ERR(teedev)) {
>                 rc = PTR_ERR(teedev);
> -               goto err;
> +               goto err_free_pool;
>         }
>         optee->teedev = teedev;
>
> @@ -837,50 +839,57 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
>                                   optee);
>         if (IS_ERR(teedev)) {
>                 rc = PTR_ERR(teedev);
> -               goto err;
> +               goto err_unreg_teedev;
>         }
>         optee->supp_teedev = teedev;
>
>         rc = tee_device_register(optee->teedev);
>         if (rc)
> -               goto err;
> +               goto err_unreg_supp_teedev;
>
>         rc = tee_device_register(optee->supp_teedev);
>         if (rc)
> -               goto err;
> +               goto err_unreg_supp_teedev;
>
>         rc = rhashtable_init(&optee->ffa.global_ids, &shm_rhash_params);
>         if (rc)
> -               goto err;
> +               goto err_unreg_supp_teedev;
>         mutex_init(&optee->ffa.mutex);
>         mutex_init(&optee->call_queue.mutex);
>         INIT_LIST_HEAD(&optee->call_queue.waiters);
>         optee_supp_init(&optee->supp);
>         ffa_dev_set_drvdata(ffa_dev, optee);
> +       ctx = teedev_open(optee->teedev);
> +       if (IS_ERR(ctx))
> +               goto err_rhashtable_free;
> +       optee->ctx = ctx;
>         rc = optee_notif_init(optee, OPTEE_DEFAULT_MAX_NOTIF_VALUE);
> -       if (rc) {
> -               optee_ffa_remove(ffa_dev);
> -               return rc;
> -       }
> +       if (rc)
> +               goto err_close_ctx;
>
>         rc = optee_enumerate_devices(PTA_CMD_GET_DEVICES);
> -       if (rc) {
> -               optee_ffa_remove(ffa_dev);
> -               return rc;
> -       }
> +       if (rc)
> +               goto err_unregister_devices;
>
>         pr_info("initialized driver\n");
>         return 0;
> -err:
> -       /*
> -        * tee_device_unregister() is safe to call even if the
> -        * devices hasn't been registered with
> -        * tee_device_register() yet.
> -        */
> +
> +err_unregister_devices:
> +       optee_unregister_devices();
> +       optee_notif_uninit(optee);
> +err_close_ctx:
> +       teedev_close_context(ctx);
> +err_rhashtable_free:
> +       rhashtable_free_and_destroy(&optee->ffa.global_ids, rh_free_fn, NULL);
> +       optee_supp_uninit(&optee->supp);
> +       mutex_destroy(&optee->call_queue.mutex);
> +err_unreg_supp_teedev:
>         tee_device_unregister(optee->supp_teedev);
> +err_unreg_teedev:
>         tee_device_unregister(optee->teedev);
> -       if (optee->pool)
> -               tee_shm_pool_free(optee->pool);
> +err_free_pool:
> +       tee_shm_pool_free(pool);
> +err_free_optee:
>         kfree(optee);
>         return rc;
>  }
> diff --git a/drivers/tee/optee/optee_private.h b/drivers/tee/optee/optee_private.h
> index 46f74ab07c7e..92bc47bef95f 100644
> --- a/drivers/tee/optee/optee_private.h
> +++ b/drivers/tee/optee/optee_private.h
> @@ -53,7 +53,6 @@ struct optee_call_queue {
>
>  struct optee_notif {
>         u_int max_key;
> -       struct tee_context *ctx;
>         /* Serializes access to the elements below in this struct */
>         spinlock_t lock;
>         struct list_head db;
> @@ -134,9 +133,10 @@ struct optee_ops {
>  /**
>   * struct optee - main service struct
>   * @supp_teedev:       supplicant device
> + * @teedev:            client device
>   * @ops:               internal callbacks for different ways to reach secure
>   *                     world
> - * @teedev:            client device
> + * @ctx:               driver internal TEE context
>   * @smc:               specific to SMC ABI
>   * @ffa:               specific to FF-A ABI
>   * @call_queue:                queue of threads waiting to call @invoke_fn
> @@ -152,6 +152,7 @@ struct optee {
>         struct tee_device *supp_teedev;
>         struct tee_device *teedev;
>         const struct optee_ops *ops;
> +       struct tee_context *ctx;
>         union {
>                 struct optee_smc smc;
>                 struct optee_ffa ffa;
> diff --git a/drivers/tee/optee/smc_abi.c b/drivers/tee/optee/smc_abi.c
> index 449d6a72d289..bacd1a1d79ee 100644
> --- a/drivers/tee/optee/smc_abi.c
> +++ b/drivers/tee/optee/smc_abi.c
> @@ -622,6 +622,7 @@ static void handle_rpc_func_cmd_shm_free(struct tee_context *ctx,
>  }
>
>  static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
> +                                         struct optee *optee,
>                                           struct optee_msg_arg *arg,
>                                           struct optee_call_ctx *call_ctx)
>  {
> @@ -651,7 +652,8 @@ static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
>                 shm = optee_rpc_cmd_alloc_suppl(ctx, sz);
>                 break;
>         case OPTEE_RPC_SHM_TYPE_KERNEL:
> -               shm = tee_shm_alloc(ctx, sz, TEE_SHM_MAPPED | TEE_SHM_PRIV);
> +               shm = tee_shm_alloc(optee->ctx, sz,
> +                                   TEE_SHM_MAPPED | TEE_SHM_PRIV);
>                 break;
>         default:
>                 arg->ret = TEEC_ERROR_BAD_PARAMETERS;
> @@ -747,7 +749,7 @@ static void handle_rpc_func_cmd(struct tee_context *ctx, struct optee *optee,
>         switch (arg->cmd) {
>         case OPTEE_RPC_CMD_SHM_ALLOC:
>                 free_pages_list(call_ctx);
> -               handle_rpc_func_cmd_shm_alloc(ctx, arg, call_ctx);
> +               handle_rpc_func_cmd_shm_alloc(ctx, optee, arg, call_ctx);
>                 break;
>         case OPTEE_RPC_CMD_SHM_FREE:
>                 handle_rpc_func_cmd_shm_free(ctx, arg);
> @@ -776,7 +778,7 @@ static void optee_handle_rpc(struct tee_context *ctx,
>
>         switch (OPTEE_SMC_RETURN_GET_RPC_FUNC(param->a0)) {
>         case OPTEE_SMC_RPC_FUNC_ALLOC:
> -               shm = tee_shm_alloc(ctx, param->a1,
> +               shm = tee_shm_alloc(optee->ctx, param->a1,
>                                     TEE_SHM_MAPPED | TEE_SHM_PRIV);
>                 if (!IS_ERR(shm) && !tee_shm_get_pa(shm, 0, &pa)) {
>                         reg_pair_from_64(&param->a1, &param->a2, pa);
> @@ -954,57 +956,34 @@ static irqreturn_t notif_irq_thread_fn(int irq, void *dev_id)
>  {
>         struct optee *optee = dev_id;
>
> -       optee_smc_do_bottom_half(optee->notif.ctx);
> +       optee_smc_do_bottom_half(optee->ctx);
>
>         return IRQ_HANDLED;
>  }
>
>  static int optee_smc_notif_init_irq(struct optee *optee, u_int irq)
>  {
> -       struct tee_context *ctx;
>         int rc;
>
> -       ctx = teedev_open(optee->teedev);
> -       if (IS_ERR(ctx))
> -               return PTR_ERR(ctx);
> -
> -       optee->notif.ctx = ctx;
>         rc = request_threaded_irq(irq, notif_irq_handler,
>                                   notif_irq_thread_fn,
>                                   0, "optee_notification", optee);
>         if (rc)
> -               goto err_close_ctx;
> +               return rc;
>
>         optee->smc.notif_irq = irq;
>
>         return 0;
> -
> -err_close_ctx:
> -       teedev_close_context(optee->notif.ctx);
> -       optee->notif.ctx = NULL;
> -
> -       return rc;
>  }
>
>  static void optee_smc_notif_uninit_irq(struct optee *optee)
>  {
> -       if (optee->notif.ctx) {
> -               optee_smc_stop_async_notif(optee->notif.ctx);
> +       if (optee->smc.sec_caps & OPTEE_SMC_SEC_CAP_ASYNC_NOTIF) {
> +               optee_smc_stop_async_notif(optee->ctx);
>                 if (optee->smc.notif_irq) {
>                         free_irq(optee->smc.notif_irq, optee);
>                         irq_dispose_mapping(optee->smc.notif_irq);
>                 }
> -
> -               /*
> -                * The thread normally working with optee->notif.ctx was
> -                * stopped with free_irq() above.
> -                *
> -                * Note we're not using teedev_close_context() or
> -                * tee_client_close_context() since we have already called
> -                * tee_device_put() while initializing to avoid a circular
> -                * reference counting.
> -                */
> -               teedev_close_context(optee->notif.ctx);
>         }
>  }
>
> @@ -1366,6 +1345,7 @@ static int optee_probe(struct platform_device *pdev)
>         struct optee *optee = NULL;
>         void *memremaped_shm = NULL;
>         struct tee_device *teedev;
> +       struct tee_context *ctx;
>         u32 max_notif_value;
>         u32 sec_caps;
>         int rc;
> @@ -1446,9 +1426,13 @@ static int optee_probe(struct platform_device *pdev)
>         optee->pool = pool;
>
>         platform_set_drvdata(pdev, optee);
> +       ctx = teedev_open(optee->teedev);
> +       if (IS_ERR(ctx))
> +               goto err_supp_uninit;
> +       optee->ctx = ctx;
>         rc = optee_notif_init(optee, max_notif_value);
>         if (rc)
> -               goto err_supp_uninit;
> +               goto err_close_ctx;
>
>         if (sec_caps & OPTEE_SMC_SEC_CAP_ASYNC_NOTIF) {
>                 unsigned int irq;
> @@ -1496,6 +1480,8 @@ static int optee_probe(struct platform_device *pdev)
>         optee_unregister_devices();
>  err_notif_uninit:
>         optee_notif_uninit(optee);
> +err_close_ctx:
> +       teedev_close_context(ctx);
>  err_supp_uninit:
>         optee_supp_uninit(&optee->supp);
>         mutex_destroy(&optee->call_queue.mutex);
> --
> 2.31.1
>
