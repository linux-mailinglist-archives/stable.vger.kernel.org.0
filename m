Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BC41CCC95
	for <lists+stable@lfdr.de>; Sun, 10 May 2020 19:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgEJRQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 13:16:52 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:43021 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729078AbgEJRQw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 May 2020 13:16:52 -0400
Received: from [192.168.1.9] (x4d0df58f.dyn.telefonica.de [77.13.245.143])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id AE39F2002EE10;
        Sun, 10 May 2020 19:16:49 +0200 (CEST)
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Regression with *bootconfig: Fix to remove bootconfig data from
 initrd while boot*
Message-ID: <9b1ba335-071d-c983-89a4-2677b522dcc8@molgen.mpg.de>
Date:   Sun, 10 May 2020 19:16:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Masami,


Commit de462e5f10 (bootconfig: Fix to remove bootconfig data from initrd 
while boot) causes a cosmetic regression on my x86 system with Debian 
Sid/unstable.

Despite having no `bootconfig` parameter on the Linux CLI, the warning 
below is shown.

     'bootconfig' found on command line, but no bootconfig found

Reverting the commit fixes it.


Kind regards,

Paul
