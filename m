Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4902E301EBD
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 21:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbhAXUeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 15:34:19 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:37980 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbhAXUeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 15:34:16 -0500
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611520414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D/IqCWHHyGiwt+g3GQmqDtT2+ZYdsv/r2P6TKaoW1gc=;
        b=suIfycoDCwE5wAe/CXnU6pJLmifovx0uu37daXYbR+J54G0EgAeNh5biRQglBM0/6+pbcp
        u8CStzKzgUt29BeKGA6+oPXp7lbR3UfWmJM6dNvO9azqJCM/LCS6Z04cYGthEW2UNk9Da3
        9JgB1W9EyF/Hd7jCeynRT1lwycmix5C9lsI6Zl+NdI0qpVaAYMVc4PU43niWVzh1AImA/k
        +VC86saBkvv8/gnNzBMqwR6TSl14PK7bpmBJb0Al9OfUqvja0xJn/LhjOBozc9Fv0hqsL7
        445w7YWFf9wJOhawNUahjRqOxVdbRdVzfPoipkWg6gsaicnLq1vgVcQDdrmpDA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611520414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D/IqCWHHyGiwt+g3GQmqDtT2+ZYdsv/r2P6TKaoW1gc=;
        b=wursuvBrDvHJsIzHX/c+PC1c7jhm/FFkVUJmA7ob18YhAsFvv4RBWwD/7DG616NTmtLyG8
        lUoFJlj73maKFiAw==
To:     gregkh@linuxfoundation.org, gregkh@linuxfoundation.org,
        pmladek@suse.com, sergey.senozhatsky@gmail.com,
        stable@vger.kernel.org
Cc:     stable-commits@vger.kernel.org
Subject: Re: Patch "printk: fix buffer overflow potential for print_text()" has been added to the 5.10-stable tree
In-Reply-To: <1611495423221153@kroah.com>
References: <1611495423221153@kroah.com>
Date:   Sun, 24 Jan 2021 21:39:33 +0106
Message-ID: <87zh0ym5wi.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 2021-01-24, <gregkh@linuxfoundation.org> wrote:
> This is a note to let you know that I've just added the patch titled
>
>     printk: fix buffer overflow potential for print_text()

We just learned that this patch introduces a new problem. I have just
posted a patch to fix the new problem:

https://lkml.kernel.org/r/20210124202728.4718-1-john.ogness@linutronix.de

You may want to hold off on applying the first fix until the second fix
has been accepted. Then you can apply both.

John Ogness
