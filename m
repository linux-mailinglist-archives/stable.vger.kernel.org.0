Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE733046F5
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 19:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbhAZRSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 12:18:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390000AbhAZI1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 03:27:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73517221EA;
        Tue, 26 Jan 2021 08:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611649624;
        bh=25zZYKOmoVPTW9yZu15uNT/rWxBGwiq4FeiJ8t5wLQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PyAqUo3oQoc5AUuu9ouTopJhGOXDlPTKK0bU9LRpnpguxgHQiLEBgnOfnJf3my+hd
         Qg6s/n6wCrLnWfDdVaYiJTHOv354Hr4xIUvnpNhZG8OHE0aFNGsU7/zV8KgAWHoCn9
         XS1zSPz7t+LxTSp2/Jjbt+5T5aDYI43RyAP+JwoA=
Date:   Tue, 26 Jan 2021 09:27:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Krzysztof =?utf-8?Q?Ol=C4=99dzki?= <ole@ans.pl>
Cc:     linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        stable@vger.kernel.org, Krzysztof Mazur <krzysiek@podlesie.net>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 5.10 119/199] x86/mmx: Use KFPU_387 for MMX string
 operations
Message-ID: <YA/SVYUj53QZPkWd@kroah.com>
References: <20210125183216.245315437@linuxfoundation.org>
 <20210125183221.250497496@linuxfoundation.org>
 <82dfa5e7-286d-777a-b1aa-ebe5144e79db@ans.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <82dfa5e7-286d-777a-b1aa-ebe5144e79db@ans.pl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 07:24:56PM -0800, Krzysztof Olędzki wrote:
> Hi,
> 
> I think for both 5.4-stable and 5.10-stable we also need https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e45122893a9870813f9bd7b4add4f613e6f29008
> - "x86/fpu: Add kernel_fpu_begin_mask() to selectively initialize state"
> 
> Without this, there is no kernel_fpu_begin_mask().

Thank you, I have now added this to both trees.

greg k-h
