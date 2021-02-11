Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4672318CD0
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 15:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhBKN6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 08:58:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231604AbhBKN4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 08:56:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4093F64DE7;
        Thu, 11 Feb 2021 13:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613051736;
        bh=56A/zXMW+u1Xa/pklclVwvjtFjV+bei4ZbfVxs6CvKo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HGBWVf3S50HbjHZrdDuKzhZjyFVYinLVgeTyyauV0pcA/dIdPgpqSVlfrX0DxOQ1a
         ryH98grErIFDexas14C/4fSyPkaNc+EpaNf0007AbD80xco6z3ln6d+2jfDCPzi5T2
         CZDb+htaMovhdqHEBUO2NJXYv9TI6jt08M/zJEgA=
Date:   Thu, 11 Feb 2021 14:55:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Xi Ruoyao <xry111@mengyan1223.wang>
Cc:     stable@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miroslav Benes <mbenes@suse.cz>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip: objtool/urgent] objtool: Fix seg fault with Clang
 non-section symbols
Message-ID: <YCU3Vdoqd+EI+zpv@kroah.com>
References: <ba6b6c0f0dd5acbba66e403955a967d9fdd1726a.1607983452.git.jpoimboe@redhat.com>
 <160812658044.3364.4188208281079332844.tip-bot2@tip-bot2>
 <dded80b60d9136ea90987516c28f93273385651f.camel@mengyan1223.wang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dded80b60d9136ea90987516c28f93273385651f.camel@mengyan1223.wang>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 09:32:03PM +0800, Xi Ruoyao wrote:
> Hi all,
> 
> The latest GNU assembler (binutils-2.36.1) is removing unused section symbols
> like Clang [1].  So linux-5.10.15 can't be built with binutils-2.36.1 now.  It
> has been reported as https://bugzilla.kernel.org/show_bug.cgi?id=211693.

2.36 of binutils fails to build the 4.4.y tree right now as well, but as
objtool isn't there, I don't know what to do about it :(

thanks,

greg k-h
