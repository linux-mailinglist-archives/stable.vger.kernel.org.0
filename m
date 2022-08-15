Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C286E593F0F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346679AbiHOUyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346671AbiHOUxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:53:36 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789B0BD114;
        Mon, 15 Aug 2022 12:10:43 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q7-20020a17090a7a8700b001f300db8677so7561720pjf.5;
        Mon, 15 Aug 2022 12:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=KUjRZPqE91jzSYN2iE0zIp+wxb3Fz8jBCptNiXCO28k=;
        b=nl5D74t6p6a2b7Jz2/xeLL85eNGxMaG3q869rymjnx1KUzapWeOISxWX+Bvmkl4271
         z2s1HKqnfi00Leht9JdsPLQHpEJip7s09mwJrSD/co/QWkM4CP7FbOTt3cR8LqhGZjVX
         W39fR3JaIwng1yNdPmuW5bbBYDG/XxtfJdQhkl0eAfpCrKbB8ByBNKFQEgDQj4WCo46E
         Vq9u5iMZ2Z1FDRfICD6WBo7Z3wvd9rBk6M0Y1jDkBER6vmrodcDrxVS7C1gpbg576Ugx
         LpxTfqWuUSnDDOhQVS7U9pznNGBzDyQN40bxh5ZUTnzCn7V53y72UzUUiVUMmUasHbIw
         FkKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=KUjRZPqE91jzSYN2iE0zIp+wxb3Fz8jBCptNiXCO28k=;
        b=gt3hRB501knQXt5wfiJBmokwuVYuLNxVIT/S7QGshwBwvTWc+x48HBpUcuwEQ9/Hoc
         /zzl3apewL5+tjvevm80VHrCt0Q+njFc0w7VPgz54O9KCWuQG+F9HdmqdOuQKAfweE+q
         LHwddVOI1KXKu1QsTCO/J3jkG/qeKFDEtCoghxN92R1mLY8AXHqjB/+GhRtlhr1FAY+c
         YRSD21Tc/3NMsCYpWyA52VN9gJkI6hiIFeZX8rojdovsg0L+Wd/ycoojUMX2ghnxyxft
         Le7VlWJ/ypa6u17AIMv4bAaNp8CUrB3uLQdo3kYqzTsAjinFh3xci/VgzdtLAugphIkA
         u9HQ==
X-Gm-Message-State: ACgBeo0g7p+1sZh7I4mXCIcTQOKewwWEBrQpMpCORxF1ImpyZrQC5mUh
        r9Zn6+J4XM34i4mb7hujY2w=
X-Google-Smtp-Source: AA6agR4vn6iDlfADGbaSh46rlmxbHe822Dd3CTfESNqOHC4cvV2/XfoCT4HkKO1FddAI/ECHIaJ6qQ==
X-Received: by 2002:a17:90a:20f:b0:1f8:cc20:1216 with SMTP id c15-20020a17090a020f00b001f8cc201216mr17823341pjc.225.1660590637729;
        Mon, 15 Aug 2022 12:10:37 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:3a69])
        by smtp.gmail.com with ESMTPSA id b6-20020a1709027e0600b0016b90620910sm7361957plm.71.2022.08.15.12.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 12:10:36 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 15 Aug 2022 09:10:35 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Hector Martin <marcan@marcan.st>
Cc:     Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, jirislaby@kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Neukum <oneukum@suse.com>,
        Roman Pen <roman.penyaev@profitbricks.com>,
        Asahi Linux <asahi@lists.linux.dev>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
Message-ID: <YvqaK3hxix9AaQBO@slm.duckdns.org>
References: <20220815175810.17780-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815175810.17780-1-marcan@marcan.st>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 02:58:10AM +0900, Hector Martin wrote:
> This has been broken since the dawn of time, and it was incompletely
> fixed by 346c09f80459, which added the necessary barriers in the work
> execution path but failed to account for the missing barrier in the
> test_and_set_bit() failure case. Fix it by switching to
> atomic_long_fetch_or(), which does have unconditional barrier semantics
> regardless of whether the bit was already set or not (this is actually
> just test_and_set_bit() minus the early exit path).
...

Oh, tricky one and yeah you're absolutely right that it makes no sense to
not guarantee barrier semantics when already pending. I didn't even know
test_and_set_bit() wasn't a barrier when it failed. Thanks a lot for hunting
down and fixing this. Applied to wq/for-6.0-fixes.

Thanks.

-- 
tejun
