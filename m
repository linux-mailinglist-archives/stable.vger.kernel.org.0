Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C71504E43
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 11:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbiDRJO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 05:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbiDRJO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 05:14:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412DE6444
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 02:12:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C849B80E54
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 09:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A649C385A7;
        Mon, 18 Apr 2022 09:12:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="biIla/Ix"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1650273135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5PqsBAwviynO1wxTCIN8hv3iyO/eGasN07/aheG7rD4=;
        b=biIla/IxtZ5YEdOhAwOm1mpwR/45lzvZ6OssP9F+MIg52oRgFLr8Kc1/I313WZOE3xj6kC
        pR2krJAWS3ltJLE+NWV6zfKlqDqmcKFo7KuoaopvvdQTQPs6f/+5nTiGoA4HHUElwE+pZ7
        JC+Z/kriV+TmC9HJ3bGxISEJ7jlQY/g=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id eb5e1d47 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 18 Apr 2022 09:12:15 +0000 (UTC)
Date:   Mon, 18 Apr 2022 11:12:11 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     gregkh@linuxfoundation.org
Cc:     keescook@chromium.org, pageexec@freemail.hu, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gcc-plugins: latent_entropy: use
 /dev/urandom" failed to apply to 4.9-stable tree
Message-ID: <Yl0rFqfaETxNfTgh@zx2c4.com>
References: <16502694453885@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <16502694453885@kroah.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Apr 18, 2022 at 10:10:45AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From c40160f2998c897231f8454bf797558d30a20375 Mon Sep 17 00:00:00 2001

Apparently on 4.9.y, applying this commit cleanly also requires
5a45a4c5c3f5e36a03770deb102ca6ba256ff3d7 to be cherry picked first.

Jason
