Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECC46DDA9B
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 14:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjDKMRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 08:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjDKMRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 08:17:20 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EB135BB
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 05:17:14 -0700 (PDT)
Received: from [192.168.1.137] (unknown [213.194.153.37])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: rcn)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 76B3466031E4;
        Tue, 11 Apr 2023 13:17:13 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1681215433;
        bh=VJOBebOwlBrpg0CW9pmMsHUudQCbRXBFnYlaGggDbRg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=lkKHLZj0Rwh8twSgtkH0u8M7N5OB8It94Z1jqTnMapo45RKGP9uDOVirTEQkR0rVm
         /bGfqYqZ35NfsjEDdDokfnCeCpBnn0rXjfwWaByYpa995N8/ueOghz0ELcORhYU+dW
         0sVYoVGNJyc/7DAIR+zD5M+cslZqroYRbnO8Xert2JTCjdHFNE29IKLzZxgZ8pQoY4
         3/rgPLt9Axvzp3kR7mzNu/zrt1C2cITVpVND/cdqW/h7CIGCk2HpG3x/2D4eHcRV08
         0ri+1upTLagdG8E3rAhqpxWE5KllD9eYXlQ/jNqlgBr1bJxkUu7LkO9PItcw/7evsQ
         OMhMKP8ELDXzw==
Message-ID: <a3047b2d-3de4-f419-968b-e1109a62309a@collabora.com>
Date:   Tue, 11 Apr 2023 14:17:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] selftests: intel_pstate: ftime() is deprecated
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20230411111533.1442349-1-ricardo.canuelo@collabora.com>
 <2023041111-rewrap-cabana-3966@gregkh>
From:   =?UTF-8?Q?Ricardo_Ca=c3=b1uelo?= <ricardo.canuelo@collabora.com>
In-Reply-To: <2023041111-rewrap-cabana-3966@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 11/4/23 13:39, Greg KH wrote:
> As you are passing this on to us, you need to also sign off on it as per
> our documentation.

Thanks, I sent v2 with the new tag.

Cheers,
Ricardo
