Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE36943339A
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 12:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235226AbhJSKhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 06:37:00 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:45497 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235235AbhJSKgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 06:36:54 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HYVVS3SP1z4xd4;
        Tue, 19 Oct 2021 21:34:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1634639680;
        bh=IpcYl6X8FtmaNpPVMZUUfggRSLNdsvYUxbHeE0Kbz8k=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=S0wE63q5BhyQ4pY9u+YsaZoRIr8qSQooLpGUpDKN9UyYQ3T6hOXR5u61QrwOplfDd
         WTLWU4ZXhhdDgHXnPXotymZYhqZqsa5+7LpGgEN49q2fO4jsfAsiWy2u/R/FD38L01
         wcKJY1tFO27NmwWMH7KbpOFUgG6Jb6xuYclU4rP6YxiNAqsSDYLAHBrT9DrIQYyafR
         UqhCaSK++qYQW83iMAxs38jj6j2cEvdqIXYOBshZU9BLQW+RluCGTUUqcmXh8ANtQI
         SHA6lzra1uwXjONfqTYkTQ2x2uy0z6pCyRrXPAc2HOR+AwwqLHTFLbAamhQUzQxxRl
         9qFZva75Vlhbg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 34/69] KVM: PPC: Book3S HV: Fix stack handling in
 idle_kvm_start_guest()
In-Reply-To: <20211018132330.615103813@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
 <20211018132330.615103813@linuxfoundation.org>
Date:   Tue, 19 Oct 2021 21:34:39 +1100
Message-ID: <87k0i9cngg.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> From: Michael Ellerman <mpe@ellerman.id.au>
>
> commit 9b4416c5095c20e110c82ae602c254099b83b72f upstream.
>
> In commit 10d91611f426 ("powerpc/64s: Reimplement book3s idle code in
> C") kvm_start_guest() became idle_kvm_start_guest(). The old code
> allocated a stack frame on the emergency stack, but didn't use the
> frame to store anything, and also didn't store anything in its caller's
> frame.

Please drop this for now, it's exposed some other bugs.

cheers
