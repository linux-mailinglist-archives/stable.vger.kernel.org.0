Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9380F1D8812
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 21:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgERTRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 15:17:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:35380 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbgERTRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 15:17:44 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jalGe-0007FU-HQ; Mon, 18 May 2020 21:17:40 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jalGe-000Wc4-69; Mon, 18 May 2020 21:17:40 +0200
Subject: Re: FAILED: patch "[PATCH] bpf: Restrict bpf_trace_printk()'s %s
 usage and add %pks," failed to apply to 5.4-stable tree
To:     gregkh@linuxfoundation.org, ast@kernel.org,
        brendan.d.gregg@gmail.com, hch@lst.de, mhiramat@kernel.org,
        torvalds@linux-foundation.org
Cc:     stable@vger.kernel.org
References: <15898172865189@kroah.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <72fe3785-bfbe-d672-fa77-8a90fc4d2844@iogearbox.net>
Date:   Mon, 18 May 2020 21:17:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <15898172865189@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25816/Mon May 18 14:17:08 2020)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

On 5/18/20 5:54 PM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
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
>  From b2a5212fb634561bb734c6356904e37f6665b955 Mon Sep 17 00:00:00 2001
> From: Daniel Borkmann <daniel@iogearbox.net>
> Date: Fri, 15 May 2020 12:11:18 +0200
> Subject: [PATCH] bpf: Restrict bpf_trace_printk()'s %s usage and add %pks,
>   %pus specifier

The whole series related to this commit is:

  - 0ebeea8ca8a4 ("bpf: Restrict bpf_probe_read{, str}() only to archs where they work")
  - 47cc0ed574ab ("bpf: Add bpf_probe_read_{user, kernel}_str() to do_refine_retval_range")
  - b2a5212fb634 ("bpf: Restrict bpf_trace_printk()'s %s usage and add %pks, %pus specifier")

It would only apply to 5.6.y stable branch, but not older ones.

Thanks,
Daniel
