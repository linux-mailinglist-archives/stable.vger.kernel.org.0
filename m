Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A6F30DBB7
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbhBCNsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:48:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:37668 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231881AbhBCNrl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 08:47:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 57AF7ACBA;
        Wed,  3 Feb 2021 13:47:00 +0000 (UTC)
Date:   Wed, 3 Feb 2021 14:46:55 +0100
From:   Borislav Petkov <bp@suse.de>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [stable-5.10.y] Pick up "x86/entry: Remove put_ret_addr_in_rdi
 THUNK macro argument"
Message-ID: <20210203134655.GB11823@zn.tnic>
References: <CA+icZUVysDKMQxw4Fxp5SzBxau1Rpy7rra-a09TY-nzwgh54SQ@mail.gmail.com>
 <YBlONpmGoM0/qG7R@kroah.com>
 <CA+icZUXeK4_5A8YzkuQUcP9jhZKvYrCtWbcgToV-FDE+VY=BvQ@mail.gmail.com>
 <YBp1QM3HFjV4kTwM@kroah.com>
 <CA+icZUVKG8YnFfwBYmkKtvsf5zK6yPty2g_0wk2-h6XqRF=otA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+icZUVKG8YnFfwBYmkKtvsf5zK6yPty2g_0wk2-h6XqRF=otA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 03, 2021 at 01:30:50PM +0100, Sedat Dilek wrote:
> Let's hear the CCed folks.

I have said this a couple of times already that the stable@ trees pick
up too many patches already and the reasoning for some of them is
debatable. But that is my opinion.

These patches are not even close to being stable material. Also my
opinion.

HTH.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
