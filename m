Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498E9393681
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 21:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235470AbhE0Tqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 15:46:39 -0400
Received: from www62.your-server.de ([213.133.104.62]:53450 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbhE0Tqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 15:46:36 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lmLwA-000Fp2-N7; Thu, 27 May 2021 21:44:58 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lmLwA-000Rs0-G4; Thu, 27 May 2021 21:44:58 +0200
Subject: Re: [PATCH 4.19 00/12] bpf: fix verifier selftests, add
 CVE-2021-29155 fixes
To:     Ovidiu Panait <ovidiu.panait@windriver.com>, stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, samjonas@amazon.com
References: <20210527173732.20860-1-ovidiu.panait@windriver.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <215e98bf-21c7-0074-129d-49a51526418b@iogearbox.net>
Date:   Thu, 27 May 2021 21:44:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210527173732.20860-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26183/Thu May 27 13:07:49 2021)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/27/21 7:37 PM, Ovidiu Panait wrote:
> This patchset is based on Frank van der Linden's backport of CVE-2021-29155
> fixes to 5.4 and 4.14:
> https://lore.kernel.org/stable/20210429220839.15667-1-fllinden@amazon.com/
> https://lore.kernel.org/stable/20210501043014.33300-1-fllinden@amazon.com/

You also need at least the first two:

   * 3d0220f6861d713213b015b582e9f21e5b28d2e0 ("bpf: Wrap aux data inside bpf_sanitize_info container")
   * bb01a1bba579b4b1c5566af24d95f1767859771e ("bpf: Fix mask direction swap upon off reg sign change")
   * a7036191277f9fa68d92f2071ddc38c09b1e5ee5 ("bpf: No need to simulate speculative domain for immediates")

They already went to 5.4/5.10/5.12 stable.

Thanks,
Daniel
