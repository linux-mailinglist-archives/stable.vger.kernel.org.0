Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6991317D796
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 01:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgCIAvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Mar 2020 20:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbgCIAvQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Mar 2020 20:51:16 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAFF9206D5;
        Mon,  9 Mar 2020 00:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583715076;
        bh=R+hotVaZLUgGyJ1wG14be80Q2rLBKsLy+5lPmqdg9nA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JdYkHRpNWGgTu8q6jMZXCqYb7Lwac9HXt4HzMZeZfO4j5HSUbQXRjAMionCvbmimo
         rv458nCBtAVqNI/XyezDQ6LhXLrvBqUHH69A8XdAsqeXoFdYIAW96RGFFTUEueGsWL
         gbS0XjU7Y9Z1RTTSlNF1Z1lLnY+IRAxCfmr3DKHU=
Date:   Sun, 8 Mar 2020 20:51:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] slub: Improve bit diffusion for freelist ptr obfuscation
Message-ID: <20200309005112.GU21491@sasha-vm>
References: <202003051623.AF4F8CB@keescook>
 <20200307232038.3880B2075A@mail.kernel.org>
 <202003081450.CEBF081F@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202003081450.CEBF081F@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 08, 2020 at 02:51:27PM -0700, Kees Cook wrote:
>On Sat, Mar 07, 2020 at 11:20:37PM +0000, Sasha Levin wrote:
>> Hi
>>
>> [This is an automated email]
>>
>> This commit has been processed because it contains a "Fixes:" tag
>> fixing commit: 2482ddec670f ("mm: add SLUB free list pointer obfuscation").
>>
>> The bot has tested the following trees: v5.5.8, v5.4.24, v4.19.108, v4.14.172.
>>
>> v5.5.8: Build failed! Errors:
>>     mm/slub.c:262:4: error: implicit declaration of function ‘swab’; did you mean ‘swap’? [-Werror=implicit-function-declaration]
>>
>
>Eek; this must be missing an include that is implicit from something
>recent? I will investigate...

swab() didn't exist "back then" :) It was introduced by d5767057c9a7
("uapi: rename ext2_swab() to swab() and share globally in swab.h"). I
can just take that patch to stable kernels.

-- 
Thanks,
Sasha
