Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387A4452E1E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 10:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbhKPJk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 04:40:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232916AbhKPJk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 04:40:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BC9E61BFB;
        Tue, 16 Nov 2021 09:37:26 +0000 (UTC)
Date:   Tue, 16 Nov 2021 10:37:23 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Todd Kjos <tkjos@google.com>
Cc:     gregkh@linuxfoundation.org, arve@android.com, tkjos@android.com,
        maco@android.com, christian@brauner.io, jmorris@namei.org,
        serge@hallyn.com, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        keescook@chromium.org, jannh@google.com, jeffv@google.com,
        zohar@linux.ibm.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH] binder: fix test regression due to sender_euid change
Message-ID: <20211116093723.ttwv4e77v43lgb45@wittgenstein>
References: <20211112180720.2858135-1-tkjos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211112180720.2858135-1-tkjos@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 12, 2021 at 10:07:20AM -0800, Todd Kjos wrote:
> This is a partial revert of commit
> 29bc22ac5e5b ("binder: use euid from cred instead of using task").
> Setting sender_euid using proc->cred caused some Android system test
> regressions that need further investigation. It is a partial
> reversion because subsequent patches rely on proc->cred.
> 
> Cc: stable@vger.kernel.org # 4.4+
> Fixes: 29bc22ac5e5b ("binder: use euid from cred instead of using task")
> Signed-off-by: Todd Kjos <tkjos@google.com>
> Change-Id: I9b1769a3510fed250bb21859ef8beebabe034c66
> ---

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
