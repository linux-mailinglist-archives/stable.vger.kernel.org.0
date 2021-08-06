Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95483E24B9
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243326AbhHFIFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243272AbhHFIEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:04:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E98461164;
        Fri,  6 Aug 2021 08:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237079;
        bh=53FeYF5yqwiC6qyWTbj+p9U4H9CyUL32XLAnL7InKCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QUganLJCvDJknnbG3o5euAzc379SezwzezFy9I2kp3o4+QaixfBpkHo5XhuuUEMkH
         0+hyZUio2DnXaF307LrlcGQgkMWW+Hiz7UOV3zYIHIvsCcpAnd+gtelFfKWO2Avifk
         K6LpkTxxqJ5wN8guzxgo2KITM3U/ZjBzvXPK7tP0=
Date:   Fri, 6 Aug 2021 10:04:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH 5.10 0/6] bpf: selftests: fix verifier selftests
Message-ID: <YQztFMdlo7OMEbC5@kroah.com>
References: <20210804170917.3842969-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804170917.3842969-1-ovidiu.panait@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 04, 2021 at 08:09:11PM +0300, Ovidiu Panait wrote:
> This patchseries fixes all failing bpf verifier selftests:
> 
> root@intel-x86-64:~# ./test_verifier
> #1149/p XDP pkt read, pkt_meta' <= pkt_data, bad access 2 OK
> #1150/p XDP pkt read, pkt_data <= pkt_meta', good access OK
> #1151/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 OK
> #1152/p XDP pkt read, pkt_data <= pkt_meta', bad access 2 OK
> Summary: 1691 PASSED, 0 SKIPPED, 0 FAILED
> 
> 
> Andrei Matei (2):
>   selftest/bpf: Adjust expected verifier errors
>   selftest/bpf: Verifier tests for var-off access
> 
> Daniel Borkmann (3):
>   bpf, selftests: Adjust few selftest result_unpriv outcomes
>   bpf: Update selftests to reflect new error states
>   bpf, selftests: Adjust few selftest outcomes wrt unreachable code
> 
> Yonghong Song (1):
>   selftests/bpf: Add a test for ptr_to_map_value on stack for helper
>     access

Thanks for these, all now queued up.

greg k-h
