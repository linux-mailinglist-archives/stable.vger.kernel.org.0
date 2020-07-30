Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC54233357
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 15:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgG3NsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 09:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgG3NsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 09:48:12 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39D1621744;
        Thu, 30 Jul 2020 13:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596116891;
        bh=0kikEbDUa3zExFt1IkWDJPeAJvE9LXEN/m7Ii0rJrs4=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=tjRcle+EOf6BBHSl06uPu5RwE2q2RuB+6HF5KYnOPfToGy0r63WxcpcZLYYQhgDLB
         a7Ywq0M1Th9cY/t4k5ikZ3gSwluIkz874nc+qZK3BkJVr55ZQeYFKpfUkmp2QfKLdQ
         QDU+SEfeATKG40R+BfYlCmGxK+B2UQJOYv2d1ArU=
Date:   Thu, 30 Jul 2020 13:48:10 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jann Horn <jannh@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     devel@driverdev.osuosl.org, Mattias Nissler <mnissler@google.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] binder: Prevent context manager from incrementing ref 0
In-Reply-To: <20200727120424.1627555-1-jannh@google.com>
References: <20200727120424.1627555-1-jannh@google.com>
Message-Id: <20200730134811.39D1621744@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 457b9a6f09f0 ("Staging: android: add binder driver").

The bot has tested the following trees: v5.7.11, v5.4.54, v4.19.135, v4.14.190, v4.9.231, v4.4.231.

v5.7.11: Build OK!
v5.4.54: Build OK!
v4.19.135: Build OK!
v4.14.190: Build OK!
v4.9.231: Failed to apply! Possible dependencies:
    14db31814a9a ("binder: Deal with contexts in debugfs")
    19c987241ca1 ("binder: separate out binder_alloc functions")
    1b77e9dcc3da ("ANDROID: binder: remove proc waitqueue")
    342e5c90b601 ("binder: Support multiple context managers")
    408c68b17aea ("ANDROID: binder: push new transactions to waiting threads.")
    4bfac80af3a6 ("binder: Add extra size to allocator")
    512cf465ee01 ("binder: fix use-after-free in binder_transaction()")
    7980240b6d63 ("binder: Add support for scatter-gather")
    9630fe8839ba ("binder: introduce locking helper functions")
    a056af42032e ("binder: Refactor binder_transact()")
    ac4812c5ffbb ("binder: Support multiple /dev instances")
    def95c73567d ("binder: Add support for file-descriptor arrays")
    fdfb4a99b6ab ("binder: separate binder allocator structure from binder proc")
    feba3900cabb ("binder: Split flat_binder_object")

v4.4.231: Failed to apply! Possible dependencies:
    14db31814a9a ("binder: Deal with contexts in debugfs")
    19c987241ca1 ("binder: separate out binder_alloc functions")
    1b77e9dcc3da ("ANDROID: binder: remove proc waitqueue")
    212265e5ad72 ("android: binder: More offset validation")
    342e5c90b601 ("binder: Support multiple context managers")
    408c68b17aea ("ANDROID: binder: push new transactions to waiting threads.")
    4bfac80af3a6 ("binder: Add extra size to allocator")
    512cf465ee01 ("binder: fix use-after-free in binder_transaction()")
    7980240b6d63 ("binder: Add support for scatter-gather")
    83050a4e2197 ("android: drivers: Avoid debugfs race in binder")
    9630fe8839ba ("binder: introduce locking helper functions")
    a056af42032e ("binder: Refactor binder_transact()")
    a906d6931f3c ("android: binder: Sanity check at binder ioctl")
    ac4812c5ffbb ("binder: Support multiple /dev instances")
    def95c73567d ("binder: Add support for file-descriptor arrays")
    feba3900cabb ("binder: Split flat_binder_object")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
