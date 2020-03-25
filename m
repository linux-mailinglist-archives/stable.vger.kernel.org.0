Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8D5192D08
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 16:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgCYPlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 11:41:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60095 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbgCYPlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 11:41:15 -0400
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jH88e-0002Va-Sr; Wed, 25 Mar 2020 15:40:17 +0000
Date:   Wed, 25 Mar 2020 16:40:13 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        "jannh@google.com" <jannh@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "avagin@gmail.com" <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "duyuyang@gmail.com" <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "christian@kellner.me" <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v6 14/16] pidfd: Use new infrastructure to fix deadlocks
 in execve
Message-ID: <20200325154013.jkpkwer3y7c6kr64@wittgenstein>
References: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
 <e2ae1c06-b205-a053-d36c-045be27b3138@hotmail.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e2ae1c06-b205-a053-d36c-045be27b3138@hotmail.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 21, 2020 at 02:46:16AM +0000, Bernd Edlinger wrote:
> This changes __pidfd_fget to use the new exec_update_mutex
> instead of cred_guard_mutex.
> 
> This should be safe, as the credentials do not change
> before exec_update_mutex is locked.  Therefore whatever
> file access is possible with holding the cred_guard_mutex
> here is also possbile with the exec_update_mutex.
> 
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>

Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
