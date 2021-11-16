Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D5E452129
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354688AbhKPBAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:00:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1359427AbhKPA5n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 19:57:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7158961353;
        Tue, 16 Nov 2021 00:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637024086;
        bh=/lUOlfcs8ay7OosNGXvUDqQ7o0NXgJO6wq7L5JkeCaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FDRk5/OnUmHlblSDO8j1BEkIyg7y27bKae4LJVCuqSPA+rSWJsrESg4W9kTggla4o
         W6K3m8GrKRVIOXxQhEBcPA6F74+woojBQvuyNmeeIf4E4Txfb3AvY2dSJhnOIYImem
         uaNsB7bnxdfSd6CQU+nBVP4aYSPnGbRR7qnS3Gp/k1rrrop9mn9Ly+yif+U1MD88oG
         3wZ2vEER79S5xdvX3pA4Qr/aAsqatQKxAePcae6MdlbX9tShKRsVDVaDCA2LXZKoDy
         P3L08t5hF0Ccb5QATXsa4dCmO0sAMgKjspDkVdB4DbsQCdDRo8/koWLI7UhaIVQJUJ
         uCo+xAjXrjq0Q==
Date:   Mon, 15 Nov 2021 19:54:45 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 063/355] powerpc/kvm: Fix kvm_use_magic_page
Message-ID: <YZMBVdDZzjE6Pziq@sashalap>
References: <20211115165313.549179499@linuxfoundation.org>
 <20211115165315.847107930@linuxfoundation.org>
 <CAHc6FU7a+gTDCZMCE6gOH1EDUW5SghPbQbsbeVtdg4tV1VdGxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHc6FU7a+gTDCZMCE6gOH1EDUW5SghPbQbsbeVtdg4tV1VdGxg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 06:47:41PM +0100, Andreas Gruenbacher wrote:
>Greg,
>
>On Mon, Nov 15, 2021 at 6:10 PM Greg Kroah-Hartman
><gregkh@linuxfoundation.org> wrote:
>> From: Andreas Gruenbacher <agruenba@redhat.com>
>>
>> commit 0c8eb2884a42d992c7726539328b7d3568f22143 upstream.
>>
>> When switching from __get_user to fault_in_pages_readable, commit
>> 9f9eae5ce717 broke kvm_use_magic_page: like __get_user,
>> fault_in_pages_readable returns 0 on success.
>
>I've not heard back from the maintainers about this patch so far, so
>it would probably be safer to leave it out of stable for now.

What do you mean exactly? It's upstream.

-- 
Thanks,
Sasha
