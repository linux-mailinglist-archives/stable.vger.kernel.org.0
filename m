Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDA14C52C0
	for <lists+stable@lfdr.de>; Sat, 26 Feb 2022 01:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240019AbiBZAtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 19:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234434AbiBZAtV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 19:49:21 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0D61E7A68
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 16:48:46 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id gb21so6181685pjb.5
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 16:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=lTgmKz4h0VFUW2G/G/MCnTKAAuCp3WKUZt3ECfO+bf4=;
        b=w3qkq+eybtd2SLDQN77s/j8Rd6/JT53MQ9+1N6xcYg93MPw5jmU1Z84PpEICQkmi/9
         NgsMREBLcmg1NrDoUjslYNoq22yvWRzxcbuRANHUTG6pLlKpnT1FlBIemu5BYxAUfXAI
         E8ax3wI1zFsXfNOdTQxSLKszT1dkpj8GTs0BUbGkzoxa/9oDOBu5gMdfxZ6ufwyAyZFc
         kLesiXDc43kCGYm7lHSY9paUTo15Zi07YLwks5Z05NvjGljfLSNpJhk47FJ1H4pN1i91
         kg2ZtsafdW2x46mJ5ZuKCCWhHjX9QakZUhypoVbBhmXX5EW7vW3wuHUTRD9YA3Aq/Zki
         ldHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=lTgmKz4h0VFUW2G/G/MCnTKAAuCp3WKUZt3ECfO+bf4=;
        b=Cn4ng2aUFUKzQ9BHB7f0bBHegzGHv7nabWAgjImNN/jrSed+f4Q7A1Au5ryDaCJI1C
         tYQ6JUs7a/Ihx6kWkdAA0yL3a4QlrKcRTuebn2vTKcxFQA6KrAlXis9XjmXBYqUQKhQp
         YSkACHnSawlvXWLP2VNzWmO0N+15WsuPvqhEtRJ7mGtDm+TjJd01iW1viLPUd8DPlfW1
         V0zNu+HiKRZLoec6GS+jrlNOsKS1LNc6qYMxcJs0L/+6TWRwLmbUZJURUgL51ZnzjvfC
         pmGz0gbOp94rFAkr0feNaGUz+35dw9Wv0dGG2F22o/srzu7oTtuwoFc3Jx2vWcQhde5k
         7EMQ==
X-Gm-Message-State: AOAM533LOLZnXAiFIE/imZ5BNDI4EsVmvbS9ojFbUTjkxjdYXqsL39m8
        i4/ZGMCVzeOsCFflSZMdbN9QQxOpR8KstA==
X-Google-Smtp-Source: ABdhPJwUKu4+G7SwwbeGXYsOXu0IXrgWgUiCU31fI9ytMCy/r8Qrh9Vny/YN5679KeKJCEh2IiA/dg==
X-Received: by 2002:a17:903:4084:b0:14f:cf98:5515 with SMTP id z4-20020a170903408400b0014fcf985515mr9939287plc.124.1645836525638;
        Fri, 25 Feb 2022 16:48:45 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id f15-20020a056a0022cf00b004f3b99a6c43sm4332822pfj.219.2022.02.25.16.48.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 16:48:45 -0800 (PST)
Message-ID: <99f64e12-04c3-35f5-53c3-c36fb5c6b2a9@linaro.org>
Date:   Fri, 25 Feb 2022 16:48:44 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: KASAN: use-after-free Read in __fdget_raw
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jens,
Sysbot found an UAF bug in __fdget_raw [1].
The issue triggers on 5.10 stable, and doesn't trigger on mainline.
I was able to bisect it to the fixing commit:
commit fb3a1f6c745c "io-wq: have manager wait for all workers to exit"

The fix went in around 5.12 kernel and was part of a bigger series of uio fixes:
https://lore.kernel.org/all/20210304002700.374417-3-axboe@kernel.dk/

Then I found out that there is one more fix needed on top:
"io-wq: fix race in freeing 'wq' and worker access"
https://lore.kernel.org/all/20210310224358.1494503-2-axboe@kernel.dk/

I have back ported the two patches to 5.10, see patch below, but the issue still
triggers. See trace [2]
Could you have a look and see what else could be missing. Any suggestion would
be appreciated.

-- 
Thanks,
Tadeusz

[1] https://syzkaller.appspot.com/bug?id=54c4ddb7a0d44bd9fbdc22d19caff5f2098081fe
[2] https://pastebin.linaro.org/view/raw/263a8d9f

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 3d5fc76b92d0..c39568971288 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -125,6 +125,9 @@ struct io_wq {
  	refcount_t refs;
  	struct completion done;

+	atomic_t worker_refs;
+	struct completion worker_done;
+
  	struct hlist_node cpuhp_node;

  	refcount_t use_refs;
@@ -250,6 +253,10 @@ static void io_worker_exit(struct io_worker *worker)
  	raw_spin_unlock_irq(&wqe->lock);

  	kfree_rcu(worker, rcu);
+
+	if (atomic_dec_and_test(&wqe->wq->worker_refs))
+		complete(&wqe->wq->worker_done);
+
  	if (refcount_dec_and_test(&wqe->wq->refs))
  		complete(&wqe->wq->done);
  }
@@ -691,6 +698,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe 
*wqe, int index)
  		return false;

  	refcount_set(&worker->ref, 1);
+	atomic_inc(&wq->worker_refs);
  	worker->nulls_node.pprev = NULL;
  	worker->wqe = wqe;
  	spin_lock_init(&worker->lock);
@@ -821,6 +829,14 @@ static int io_wq_manager(void *data)
  	if (current->task_works)
  		task_work_run();

+	rcu_read_lock();
+	for_each_node(node)
+		io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
+	rcu_read_unlock();
+
+	if (atomic_dec_and_test(&wq->worker_refs))
+		complete(&wq->worker_done);
+	wait_for_completion(&wq->worker_done);
  out:
  	if (refcount_dec_and_test(&wq->refs)) {
  		complete(&wq->done);
@@ -1134,6 +1150,8 @@ struct io_wq *io_wq_create(unsigned bounded, struct 
io_wq_data *data)
  	}

  	init_completion(&wq->done);
+	init_completion(&wq->worker_done);
+	atomic_set(&wq->worker_refs, 0);

  	wq->manager = kthread_create(io_wq_manager, wq, "io_wq_manager");
  	if (!IS_ERR(wq->manager)) {
@@ -1179,11 +1197,6 @@ static void __io_wq_destroy(struct io_wq *wq)
  	if (wq->manager)
  		kthread_stop(wq->manager);

-	rcu_read_lock();
-	for_each_node(node)
-		io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
-	rcu_read_unlock();
-
  	wait_for_completion(&wq->done);

  	for_each_node(node)

