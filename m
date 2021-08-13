Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B1A3EBE15
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 23:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbhHMV62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 17:58:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:46144 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbhHMV62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 17:58:28 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mEfBf-0009bB-4V; Fri, 13 Aug 2021 23:57:59 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mEfBe-000F9N-VP; Fri, 13 Aug 2021 23:57:59 +0200
Subject: Re: [PATCH 5.10 04/19] bpf: Add _kernel suffix to internal
 lockdown_bpf_read
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrii Nakryiko <andrii@kernel.org>
References: <20210813150522.623322501@linuxfoundation.org>
 <20210813150522.774143311@linuxfoundation.org>
 <20210813195523.GA4577@duo.ucw.cz>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f42f4fbb-3777-6e5b-0daf-6fdb2cc707b8@iogearbox.net>
Date:   Fri, 13 Aug 2021 23:57:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210813195523.GA4577@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26262/Fri Aug 13 10:20:51 2021)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

On 8/13/21 9:55 PM, Pavel Machek wrote:
>> From: Daniel Borkmann <daniel@iogearbox.net>
>>
>> commit 71330842ff93ae67a066c1fa68d75672527312fa upstream.
>>
>> Rename LOCKDOWN_BPF_READ into LOCKDOWN_BPF_READ_KERNEL so we have naming
>> more consistent with a LOCKDOWN_BPF_WRITE_USER option that we are
>> adding.
> 
> As far as I can tell, next bpf patch does not depend on this one and
> we don't need it in 5.10. (Likely same situation with 5.13).

Yeah, it's nice to have for consistency given also small as well, but
also fully okay to drop it as there shouldn't be any conflict.

Thanks,
Daniel
