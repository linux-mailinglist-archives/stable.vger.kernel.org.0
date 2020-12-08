Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CC52D2D98
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 15:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbgLHOyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 09:54:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:55914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729386AbgLHOyP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 09:54:15 -0500
Date:   Tue, 8 Dec 2020 09:53:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607439214;
        bh=H7ui1oXZMfgPrgKMZ/Ya1iXKLIGPc5dIFOJ9CStsf0I=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=ioNpx9DdRgYplXbnBE4XWzVebyQAqe0zFcyb9vYxXXTcymUp5oVAfsRwkZ53LS8gf
         y8EZoDNysAtgZ/QUVvyHjRSOVDxuxIKA2GvBVzHetWXBcIVJXfc9yjG81/HYbO5gLr
         bdJzEg0P3FFmMdzK9CBh/2Njr7XpcvtcfhNqCMLd77sNkncwaMo8u7exI6B6zWj92D
         9uMx7VmAmt5FyKxeutE+bJThkri0yx5WSYXjzWWbLNqibn3IXqN6weLxOpOxVRNvjz
         gtJj5WHsI4KRghnlETLa+o2knLyQbMiMXho7sA+pdN0/nCUBEI43wrDZDhJQtEGVYc
         HYomZb0qG+lbw==
From:   Sasha Levin <sashal@kernel.org>
To:     Kamal Mostafa <kamal@canonical.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Verbeiren <david.verbeiren@tessares.net>,
        stable@vger.kernel.org
Subject: Re: [5.4.y] selftests/bpf build broken by "bpf: Zero-fill..."
Message-ID: <20201208145333.GK643756@sasha-vm>
References: <20201204182846.27110-1-kamal@canonical.com>
 <20201207224238.GA28646@ascalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201207224238.GA28646@ascalon>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 07, 2020 at 02:42:40PM -0800, Kamal Mostafa wrote:
>On Fri, Dec 04, 2020 at 10:28:46AM -0800, Kamal Mostafa wrote:
>> Hi Sasha-
>>
>> This v5.4.78 commit breaks the tools/testing/selftests/bpf build:
>>
>> [linux-5.4.y] c602ad2b52dc bpf: Zero-fill re-used per-cpu map element
>>
>> Like this:
>>
>> 	prog_tests/map_init.c:5:10: fatal error: test_map_init.skel.h: No such file or directory
>> 	    5 | #include "test_map_init.skel.h"
>>
>> Because tools/testing/selftests/bpf/Makefile in v5.4 does not have the
>> "skeleton header generation" stuff (circa v5.6).
>>
>> Reverting c602ad2b52dc from linux-5.4.y fixes it.
>
>Another option would be to just drop the selftest from linux-5.4.y,
>but keep the beneficial change to kernel/bpf/hashtab.c.
>
>(We're leaning towards that approach for Ubuntu).

That's what I did, thanks!

-- 
Thanks,
Sasha
