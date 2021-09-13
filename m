Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422E9408802
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 11:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238270AbhIMJUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 05:20:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238489AbhIMJTR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 05:19:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78A1C60F8F;
        Mon, 13 Sep 2021 09:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631524682;
        bh=6hj2zaSI1/DOSlfBJTCUJZn6PTQexTSxUTCcLktH3dE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ae4u/sBGEU6imkILotJQ6N/jjzZpUmWPg5gcsm0f7M1JMO68kEsf+k9k04MBU8uzm
         Nzzhj/GYgGIbBbLYonPedSElBurdZIgQppXHEByz05MD6hLQXq1Yke4kFH6bX//Dvu
         XKUXT46seoxv64OhbXG3K7HPXLdFA+Y7At36Goxc=
Date:   Mon, 13 Sep 2021 11:17:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH 5.4 0/4] bpf: backport fixes for
 CVE-2021-34556/CVE-2021-35477
Message-ID: <YT8XR5AiS5eu3P6D@kroah.com>
References: <20210907131701.1910024-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210907131701.1910024-1-ovidiu.panait@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 07, 2021 at 04:16:57PM +0300, Ovidiu Panait wrote:
> With this patchseries all bpf verifier selftests pass (tested in qemu for x86_64):
> root@intel-x86-64:~# ./test_verifier
> ...
> #1057/p XDP pkt read, pkt_meta' <= pkt_data, bad access 1 OK
> #1058/p XDP pkt read, pkt_meta' <= pkt_data, bad access 2 OK
> #1059/p XDP pkt read, pkt_data <= pkt_meta', good access OK
> #1060/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 OK
> #1061/p XDP pkt read, pkt_data <= pkt_meta', bad access 2 OK
> Summary: 1571 PASSED, 0 SKIPPED, 0 FAILED
> 
> Daniel Borkmann (3):
>   bpf: Introduce BPF nospec instruction for mitigating Spectre v4
>   bpf: Fix leakage due to insufficient speculative store bypass
>     mitigation
>   bpf: Fix pointer arithmetic mask tightening under state pruning
> 
> Lorenz Bauer (1):
>   bpf: verifier: Allocate idmap scratch in verifier env

Thanks for these, now queued up.

greg k-h
