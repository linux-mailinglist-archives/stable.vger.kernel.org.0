Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37DC4E240B
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 11:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239507AbiCUKOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 06:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbiCUKOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 06:14:45 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F20D17A80
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 03:13:20 -0700 (PDT)
Date:   Mon, 21 Mar 2022 11:13:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1647857598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=gDV90gqnyeQtw1YJGnbnnx5rUoyprbVnOQVhOvGW9oY=;
        b=rLTqpyiLGa6olnZ5jz4ve90O59NgHOlE/aC9xKjZBIgCi+Tze18GujMSl+Y7lJ5Krn7YAd
        HbsetDX/zV37tV0pHK5mle27Snf1f/TDjNM1YdVlMm8D7cKJ3hWn/t73eJsKHpHMYrWJF1
        EroVGvyRSVU/TacjteS5d3TbHmUag7dmJwDLSoJ8poirOhefUOApDVtsQCW8hNMfB087iu
        5xSzlEIC1ZvYS06NpC17LRjF0IVlo1hfXDBNsMzwBISJuQTuGVuMFhFO4ILHpEgHpuEzqg
        dyRH0hDIXR7rwJLuFtX6EP9IparKqZxBpGuSfU7c5m8RwIByiGHOUlUQ9z/duQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1647857598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=gDV90gqnyeQtw1YJGnbnnx5rUoyprbVnOQVhOvGW9oY=;
        b=81tikQvX5IO12Zq8IN1G6/CvsBTXXaKSttfXufTLn7jWCwjDy6Os0tnjsuGJ/CQkxNgjRe
        8pktyYIhTAs98PCA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, tglx@linutronix.de
Subject: The linux-5.17.y tag looks bogus.
Message-ID: <YjhPvcJ9opIrx+ua@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I just noticed that the stable repository has the linux-5.17.y tag and
no branch with the linux-5.17.y name. That tag looks like a copy of
Linus' v5.17.

I guess this is a mistake. On my side git refused to push the
linux-5.17.y branch because it already had a tag with the same name.

Could you please remove it?

Sebastian
