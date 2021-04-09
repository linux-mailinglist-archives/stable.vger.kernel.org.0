Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F7E35A7B3
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbhDIUON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:14:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:54432 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhDIUON (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 16:14:13 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lUxVu-0002xf-FZ; Fri, 09 Apr 2021 22:13:58 +0200
Received: from [85.7.101.30] (helo=pc-6.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lUxVu-000OFj-9V; Fri, 09 Apr 2021 22:13:58 +0200
Subject: Re: [PATCH 5.10 39/41] bpf, x86: Validate computation of branch
 displacements for x86-32
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Piotr Krysiuk <piotras@gmail.com>, andrii@kernel.org,
        ast@kernel.org
References: <20210409095304.818847860@linuxfoundation.org>
 <20210409095306.075652415@linuxfoundation.org> <YHCwWhGh7eoU8OdU@debian>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <400e9fca-c207-effb-05bf-844bc0e79021@iogearbox.net>
Date:   Fri, 9 Apr 2021 22:13:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YHCwWhGh7eoU8OdU@debian>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26135/Fri Apr  9 13:10:03 2021)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/9/21 9:51 PM, Sudip Mukherjee wrote:
> On Fri, Apr 09, 2021 at 11:54:01AM +0200, Greg Kroah-Hartman wrote:
>> From: Piotr Krysiuk <piotras@gmail.com>
>>
>> commit 26f55a59dc65ff77cd1c4b37991e26497fc68049 upstream.
> 
> I am not finding this in Linus's tree and even not seeing this change in
> master branch also. Am I missing something?

Both are in -net tree at this point, thus commit sha won't change anymore. David or
Jakub will likely send their -net PR to Linus today or tomorrow for landing in
mainline. For stable things had to move a bit quicker given the announcement in [0]
yesterday. Timing was a bit unfortunate here as I would have preferred for things to
land in stable the regular way first (aka merge to mainline, cherry-picking to stable,
minor stable release, then announcement).

Thanks,
Daniel

   [0] https://www.openwall.com/lists/oss-security/2021/04/08/1
