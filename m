Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479F7334CAA
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 00:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbhCJXgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 18:36:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:40110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232948AbhCJXfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 18:35:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFFFF64E25;
        Wed, 10 Mar 2021 23:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615419351;
        bh=t3krhPD11ofGEiSmPTU/+CNh4JE+znDg12ZjyBGuWAk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lS9iRF1+il5DczROcaOp2VngrCNt+kk1SyWi4aoLeB1FmQOCkfrxxLmAWFa/QYePl
         pxOuRxfo3yo/dua4hV3ToQxulL2Sj/66Bu6TaExKvQzIkh1ELYjg5Fk2e3X445DV/F
         ul6Gos89II1Mek4I4I/IIPgSw58pmWMQLWkuYonaB0ZNacVVS5tyh96a/McugQMYXG
         eSlTkFIy7nyhCZb5QaWh+86xPuIpTimBzmXW89ow+AgmZcq5028I+cIwiU6a9ZQ+zS
         RQ5PpWBM42yhgkjPgvl2nE0lubumLM6kWkvlVUxablIrt+AROFNpQ9crWoXFc/2OEu
         GV8gOWlKLgpHQ==
Date:   Wed, 10 Mar 2021 18:35:50 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: commit <sha> upstream. vs git cherry-pick -x
Message-ID: <YElX1tunCDhCtz8v@sashalap>
References: <CAKwvOdmAEKQmi-Hy4Gi33t4nb3mCuKUd_qmbEdwrkRwezAWpiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKwvOdmAEKQmi-Hy4Gi33t4nb3mCuKUd_qmbEdwrkRwezAWpiA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 02:37:03PM -0800, Nick Desaulniers wrote:
>Hello stable maintainers,
>While working on some backports I'm about to send hopefully today or
>tomorrow, I was curious why the convention seems to be for folks to
>use "commit <sha> upstream." in commit messages?  I know that's what's
>in https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#option-3,
>but I was curious whether the format from `git cherry-pick -xs <sha>`
>is not acceptable? I assume there's context as to why not?  It is nice
>to have that info uniformly near the top, but I find myself having to
>cherry-pick then amend a lot.  Or is there an option in git to
>automate the stable kernel's preferred style?

AFAIK it's just due to historical reasons. Both the stable tree and git
added this "feature" at about the same time, each doing it slightly
differently.

-- 
Thanks,
Sasha
